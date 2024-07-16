package PramothVM.utilities;

import java.util.*;

public class DatasetUtils {

    /**
     * Return the columns of the dataset
     *
     * @param dataset the dataset
     * @return the columns of the dataset
     */
    public static Set<String> getColumns(final List<Map<String, String>> dataset) {
        final Set<String> columns = new LinkedHashSet<>();

        if (dataset.size() > 0) {
            columns.addAll(dataset.get(0).keySet());
        }

        return columns;
    }

    /**
     * Truncate the columns of the dataset
     *
     * @param dataset the dataset to truncate
     * @param columns the columns to keep
     * @return return a dataset with only the requested columns
     */
    public static List<Map<String, String>> selectColumns(final List<Map<String, String>> dataset, final Set<String> columns) {
        final List<Map<String, String>> selectDataset = new ArrayList<>(dataset.size());

        for (Map<String, String> row : dataset) {
            final Map<String, String> selectRow = new LinkedHashMap<>();

            for (String columnName : columns) {
                if (row.containsKey(columnName)) {
                    final String columnValue = row.get(columnName);

                    selectRow.put(columnName, columnValue);
                }
            }

            selectDataset.add(selectRow);
        }

        return selectDataset;
    }

    private static Map<String, Integer> computeColumnWidths(final List<Map<String, String>> dataset) {

        Map<String, Integer> columnWidths = new LinkedHashMap<>();

        if (dataset != null) {
            for (Map<String, String> row : dataset) {
                for (Map.Entry<String, String> entry : row.entrySet()) {
                    final String name = entry.getKey();
                    final int valueLength = entry.getValue() == null ? 0 : entry.getValue().length();

                    if (columnWidths.containsKey(name)) {
                        // check new value length bigger than existing
                        if (columnWidths.get(name) < valueLength) {
                            columnWidths.put(name, valueLength);
                        }
                    } else {
                        if (valueLength < name.length()) {
                            // use the header length as initial size
                            columnWidths.put(name, entry.getKey().length());
                        } else {
                            columnWidths.put(name, valueLength);
                        }
                    }
                }
            }
        }

        return columnWidths;
    }

    /**
     * Return the column widths for the comparison.
     *
     * @param comparisons the comparison contains rows from 1+ datasets
     * @return return the map of column names to widths
     */
    public static Map<String, Integer> computeComparisonColumnWidths(final List<DatasetComparator.Comparison> comparisons) {
        final List<Map<String, String>> dataset = new LinkedList<>();

        for (DatasetComparator.Comparison comparison : comparisons) {
            if (comparison.getRow1() != null) {
                dataset.add(comparison.getRow1());
            }

            if (comparison.getRow2() != null) {
                dataset.add(comparison.getRow2());
            }
        }

        return computeColumnWidths(dataset);
    }

    /**
     * Create a report based on a dataset.
     *
     * @param dataset the dataset to print
     * @return return the dataset as a string
     */
    public static String printDataset(final List<Map<String, String>> dataset) {
        final StringBuilder report = new StringBuilder();
        final Map<String, Integer> columnWidths = computeColumnWidths(dataset);

        report.append("|");

        for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
            report.append(" ").append(String.format("%1$" + entry.getValue() + "s", entry.getKey())).append(" |");
        }

        report.append("\n");

        for (Map<String, String> row : dataset) {
            report.append("|");

            for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
                final String value = row.get(entry.getKey());

                report.append(" ").append(String.format("%1$" + entry.getValue() + "s", value)).append(" |");
            }

            report.append("\n");
        }

        return report.toString();
    }

    /**
     * Create a report based pn the comparison.
     *
     * @param comparisons the comparisons
     * @return the string report
     */
    public static String printComparisons(final List<DatasetComparator.Comparison> comparisons) {
        final StringBuilder report = new StringBuilder();
        final Map<String, Integer> columnWidths = computeComparisonColumnWidths(comparisons);

        report.append("| Ops |");

        for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
            report.append(" ").append(String.format("%1$" + entry.getValue() + "s", entry.getKey())).append(" |");
        }

        report.append("\n");

        for (DatasetComparator.Comparison comparison : comparisons) {
            switch (comparison.getDifference()) {
                case INSERT:
                    report.append("|  +  |");

                    for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
                        final String value = comparison.getRow2().get(entry.getKey());

                        report.append(" ").append(String.format("%1$" + entry.getValue() + "s", value)).append(" |");
                    }

                    break;
                case DELETE:
                    report.append("|  -  |");

                    for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
                        final String value = comparison.getRow1().get(entry.getKey());

                        report.append(" ").append(String.format("%1$" + entry.getValue() + "s", value)).append(" |");
                    }

                    break;
                case UPDATE:
                    report.append("|  <  |");

                    for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
                        final String value = comparison.getRow1().get(entry.getKey());

                        report.append(" ").append(String.format("%1$" + entry.getValue() + "s", value)).append(" |");
                    }

                    report.append("\n|  >  |");

                    for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
                        final DatasetComparator.Difference difference = comparison.getDifferences().get(entry.getKey());
                        final String value = (difference == null) ? "@same" : comparison.getRow2().get(entry.getKey());

                        report.append(" ").append(String.format("%1$" + entry.getValue() + "s", value)).append(" |");
                    }

                    break;
                default:
                    report.append("|     |");

                    for (Map.Entry<String, Integer> entry : columnWidths.entrySet()) {
                        final String value = comparison.getRow1().get(entry.getKey());

                        report.append(" ").append(String.format("%1$" + entry.getValue() + "s", value)).append(" |");
                    }
            }

            report.append("\n");
        }

        return report.toString();
    }

    /**
     * Create a comparisons report as a string between to datasets
     *
     * @param dataset1 the first dataset
     * @param dataset2 the second dataset
     * @return return a pretty difference
     */
    public static String printDatasetComparison(final List<Map<String, String>> dataset1, final List<Map<String, String>> dataset2) {
        final DatasetComparator compareRows = new DatasetComparator();
        final List<DatasetComparator.Comparison> comparisons = compareRows.compare(dataset1, dataset2);

        return printComparisons(comparisons);
    }
}
