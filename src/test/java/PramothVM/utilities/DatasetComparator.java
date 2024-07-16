package PramothVM.utilities;

import lombok.Getter;

import java.util.*;


public class DatasetComparator {
    public final static float MATCH_WEIGHT_THRESHOLD = 0.25f;

    public enum Difference {
        INSERT, DELETE, UPDATE, NONE
    }

    private static final Map<String, Difference> OPERATOR_TO_DIFFERENCE_MAP = Map.ofEntries(
            new AbstractMap.SimpleEntry<String, Difference>("+", Difference.INSERT),
            new AbstractMap.SimpleEntry<String, Difference>("-", Difference.DELETE),
            new AbstractMap.SimpleEntry<String, Difference>(">", Difference.UPDATE),
            new AbstractMap.SimpleEntry<String, Difference>("~", Difference.UPDATE),
            new AbstractMap.SimpleEntry<String, Difference>("=", Difference.NONE),
            new AbstractMap.SimpleEntry<String, Difference>(" ", Difference.NONE)
    );

    @Getter
    public static class Comparison {
        private Difference difference = Difference.INSERT;
        private float matchWeighting = 0.0f;

        private Map<String, Difference> differences = new LinkedHashMap<>();
        private Map<String, String> row1;
        private Map<String, String> row2;
    }

    public static Difference getDifference(String operator) {
        return OPERATOR_TO_DIFFERENCE_MAP.get(operator);
    }

    /**
     * Compare to row.
     *
     * @param compareRow the comparator row
     * @param row        the row
     * @param toRow      the secondary row
     * @return return true on an exact match
     */
    private boolean findAndCompare(final Comparison compareRow, final Map<String, String> row, final Map<String, String> toRow) {
        int columnCount = 0;
        int columnMatchCount = 0;

        final Map<String, Difference> columnDifferences = new LinkedHashMap<>();

        for (Map.Entry<String, String> column : row.entrySet()) {
            final String name = column.getKey();
            final String value = FormatUtils.resolveValue(name, column.getValue());
            final String toValue = FormatUtils.resolveValue(name, toRow.get(name));

            if (value == null && toValue == null) {
                columnMatchCount++;
            } else if (value == null) {
                columnDifferences.put(name, Difference.INSERT);
            } else if (toValue == null) {
                columnDifferences.put(name, Difference.DELETE);
            } else {
                if (value.equals(toValue)) {
                    columnMatchCount++;
                } else {
                    columnDifferences.put(name, Difference.UPDATE);
                }
            }

            columnCount++;
        }

        final float matchWeighting = ((float) columnMatchCount / (float) columnCount);

        if (matchWeighting > MATCH_WEIGHT_THRESHOLD) {
            compareRow.difference = (matchWeighting < 1.0f) ? Difference.UPDATE : Difference.NONE;
            compareRow.differences = columnDifferences;
            compareRow.matchWeighting = matchWeighting;
            compareRow.row2 = toRow;

            return matchWeighting == 1.0f;
        }

        return false;
    }

    /**
     * Find a row within other dataset match best row.
     *
     * @param row       the row to find
     * @param toDataset the dataset to compare against
     * @return return the comparator row
     */
    private Comparison findAndCompare(final Map<String, String> row, final List<Map<String, String>> toDataset) {
        Comparison matchRow = new Comparison();

        float matchWeighting = 0.0f;

        if (toDataset != null) {
            for (Map<String, String> toRow : toDataset) {
                final Comparison possibleMatchRow = new Comparison();

                possibleMatchRow.row1 = row;

                if (findAndCompare(possibleMatchRow, row, toRow)) {
                    // break on 100% match
                    matchRow.difference = Difference.NONE;
                    matchRow = possibleMatchRow;

                    return matchRow;
                }

                // found a batch match
                if (matchRow.matchWeighting < possibleMatchRow.matchWeighting) {
                    matchRow.difference = Difference.UPDATE;
                    matchRow = possibleMatchRow;
                }
            }
        }

        if (matchRow.difference == Difference.UPDATE) {
            return matchRow;
        }

        Comparison deleteRow = new Comparison();

        deleteRow.row1 = row;
        deleteRow.difference = Difference.DELETE;

        return deleteRow;
    }

    /**
     * Compare to datasets.
     *
     * @param dataset1 the primary dataset
     * @param dataset2 the secondary datase
     * @return return comparison result
     */
    public List<Comparison> compare(final List<Map<String, String>> dataset1, final List<Map<String, String>> dataset2) {
        final List<Comparison> comparisons = new LinkedList<>();
        final List<Map<String, String>> unmatchedRows = new LinkedList<>(dataset2);

        for (Map<String, String> row : dataset1) {
            final Comparison compareRow = findAndCompare(row, unmatchedRows);

            comparisons.add(compareRow);

            if (compareRow.row2 != null) {
                unmatchedRows.remove(compareRow.row2);
            }
        }

        for (Map<String, String> unmatchedRow : unmatchedRows) {
            final Comparison compareRow = new Comparison();

            compareRow.difference = Difference.INSERT;
            compareRow.row2 = unmatchedRow;

            comparisons.add(compareRow);
        }

        return comparisons;
    }


    /**
     * Create a comprision based on a comprision defined as a dataset format (i.e has the "Ops" column)
     *
     * @param dataset the dataset contains the comprision data
     * @return return it as a comparison
     */
    public List<Comparison> load(final List<Map<String, String>> dataset) {
        final List<Comparison> comparisons = new LinkedList<>();

        for (Map<String, String> row : dataset) {
            final String ops = row.get("Ops");

            if (ops == null) {
                throw new IllegalStateException("Missing \"Ops\" column with dataset row: " + row);
            }

            Difference difference = OPERATOR_TO_DIFFERENCE_MAP.get(ops);

            if (difference == null) {
                throw new IllegalStateException("Unknown \"Ops\" column value with dataset row: " + row);
            }

            final Comparison comparison = new Comparison();

            comparison.difference = difference;

            switch (difference) {
                case NONE:
                    break;
                case INSERT:
                    comparison.row2 = new LinkedHashMap<>();
                    break;
                case DELETE:
                    comparison.row1 = new LinkedHashMap<>();
                    break;
                case UPDATE:
                    comparison.row1 = new LinkedHashMap<>();
                    comparison.row2 = new LinkedHashMap<>();
                    break;
                default:
            }

            for (Map.Entry<String, String> column : row.entrySet()) {
                final String name = column.getKey();
                final String value = column.getValue();

                if ("Ops".equals(name)) {
                    continue;
                }

                switch (difference) {
                    case NONE:
                        break;
                    case INSERT:
                        comparison.row2.put(name, value);

                        break;
                    case DELETE:
                        comparison.row1.put(name, value);
                        break;
                    case UPDATE:
                        comparison.row1.put(name, value);
                        comparison.row2.put(name, value);

                        if (!"@same".equals(value)) {
                            comparison.differences.put(name, Difference.UPDATE);
                        }

                        break;
                    default:
                }
            }
        }

        return comparisons;
    }
}