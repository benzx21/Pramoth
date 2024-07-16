package custx.utilities;

import custx.constants.Utility;
import lombok.Getter;
import org.assertj.core.api.Assertions;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.Period;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static custx.utilities.FormatUtils.toLocalDateNull;

public class DatasetAssertion {

    @Getter
    public static class AssertionResult {
        private boolean difference;

        private List<DatasetComparator.Comparison> unmatchedComparisons;
        private List<Map<String, String>> unmatchedDifferences;
    }

    /**
     * Compare the 2 datasets are equals (no differences)
     *
     * @param dataset1 the first dataset
     * @param dataset2 the second dataset
     * @return return true when NO differences
     */
    public boolean hasNoDifference(
            final List<Map<String, String>> dataset1, final List<Map<String, String>> dataset2) {

        final DatasetComparator compareRows = new DatasetComparator();
        final List<DatasetComparator.Comparison> comparisons = compareRows.compare(dataset1, dataset2);

        for (DatasetComparator.Comparison comparison : comparisons) {
            if (comparison.getDifference() != DatasetComparator.Difference.NONE) {
                return false;
            }
        }

        return true;
    }

    /**
     * Convert the value ot a number.
     *
     * @param name  the optional name of the value
     * @param value the value to convert
     * @return return null when "blank" otherwise a number
     */
    private BigDecimal covertToNumber(final String name, final String value) {
        if (value == null || value.trim().isBlank()) {
            return null;
        }

        return new BigDecimal(value.replaceAll(",", ""));
    }

    private boolean compareEqualTo(final DatasetComparator.Comparison comparison, final String name, final String value) {
        final DatasetComparator.Difference difference = comparison.getDifference();
        final String actual1 = comparison.getRow1() == null ? null : comparison.getRow1().get(name);
        final String actual2 = comparison.getRow2() == null ? null : comparison.getRow2().get(name);

        String expectedValue = value;

        try {
            if (value != null && (value.startsWith("@diff") || value.startsWith("@abs") || value.startsWith("@date") || value.startsWith("@same"))) {
                if (value.equals("@same")) {
                    if (actual1 == null && actual2 == null) {
                        return true;
                    }

                    if (actual1 == null || actual2 == null) {
                        return true;
                    }

                    return actual1.equals(actual2);
                } else if (value.startsWith("@date(")) {
                    expectedValue = FormatUtils.resolveDateValue(name, value, Utility.DATE_FORMAT_DDMMMYYYY);
                } else if (value.startsWith("@abs(")) {

                    expectedValue = FormatUtils.resolveAbsValue(name, value);
                } else if (value.startsWith("@diff(")) {
                    if (difference != DatasetComparator.Difference.UPDATE) {
                        throw new UnsupportedOperationException("Can only perform a @diff(...) on an UPDATE");
                    }

                    if (value.startsWith("@diff(P")) {
                        final String parameter = value.substring(6, value.indexOf(")"));
                        final Period period = Period.parse(parameter);

                        LocalDate date1 = toLocalDateNull(actual1);
                        LocalDate date2 = toLocalDateNull(actual2);

                        final Period valuePeriod = Period.between(date1, date2);

                        if (period.equals(valuePeriod)) {
                            return true;
                        }

                        return false;
                    }

                    final BigDecimal number1 = covertToNumber(name, actual1);
                    final BigDecimal number2 = covertToNumber(name, actual2);

                    if (number1 == null || number2 == null) {
                        return false;
                    }

                    final String diffValue = value.substring(6, value.indexOf(")"));

                    final BigDecimal expectedDifference = covertToNumber("@diff", diffValue);
                    final BigDecimal actualDifference = number2.subtract(number1);

                    return expectedDifference.equals(actualDifference);
                }
            }

            if (difference == DatasetComparator.Difference.DELETE) {
                return (actual1 == null && expectedValue == null || actual1.equals(expectedValue));
            }

            return ((actual2 == null && expectedValue == null) ||
                    (actual2 != null && expectedValue != null && actual2.equals(expectedValue)));
        } catch (Exception ex) {
            Assertions.fail("Unable to convert value: " + name + " = " + value, ex);
        }

        return false;
    }

    private boolean compareEqualTo(
            final DatasetComparator.Comparison comparison, final Map<String, String> unmatchedDifference) {

        final DatasetComparator.Difference difference = comparison.getDifference();

        for (Map.Entry<String, String> columnDifference : unmatchedDifference.entrySet()) {
            final String name = columnDifference.getKey();

            if (name.equals(" ") || name.equals("Ops")) {
                continue;
            }

            final String value = columnDifference.getValue();

            if (!compareEqualTo(comparison, name, value)) {
                return false;
            }
        }

        return true;
    }

    private Map<String, String> hasDifference(
            final DatasetComparator.Comparison comparison, final List<Map<String, String>> unmatchedDifferences) {

        for (Map<String, String> unmatchedDifference : unmatchedDifferences) {
            final String operator = unmatchedDifference.get("Ops");
            final DatasetComparator.Difference difference = DatasetComparator.getDifference(operator);

            if (comparison.getDifference() == difference) {
                if (compareEqualTo(comparison, unmatchedDifference)) {
                    return unmatchedDifference;
                }
            }
        }

        return null;
    }

    /**
     * compare the differences between 2 datasets.
     *
     * @param dataset1            the first dataset
     * @param dataset2            the second dataset
     * @param expectedDifferences the expected differences
     * @return return true when differences are expected
     */
    public AssertionResult difference(
            final List<Map<String, String>> dataset1, final List<Map<String, String>> dataset2,
            final List<Map<String, String>> expectedDifferences) {

        final DatasetComparator compareRows = new DatasetComparator();
        final List<DatasetComparator.Comparison> actualComparisons = compareRows.compare(dataset1, dataset2);

        final List<DatasetComparator.Comparison> unmatchedComparisons = new LinkedList<>(actualComparisons);
        final List<Map<String, String>> unmatchedDifferences = new LinkedList<>(expectedDifferences);

        for (DatasetComparator.Comparison actualComparison : actualComparisons) {
            final Map<String, String> unmatchedDifference = hasDifference(actualComparison, unmatchedDifferences);

            if (unmatchedDifference != null) {
                unmatchedDifferences.remove(unmatchedDifference);
                unmatchedComparisons.remove(actualComparison);
            }
        }

        AssertionResult result = new AssertionResult();

        result.difference = ((unmatchedDifferences.size() > 0) || (unmatchedComparisons.size() > 0));
        result.unmatchedDifferences = unmatchedDifferences;
        result.unmatchedComparisons = unmatchedComparisons;

        return result;
    }

    /**
     * compare the differences between 2 datasets.
     *
     * @param dataset1            the first dataset
     * @param dataset2            the second dataset
     * @param expectedDifferences the expected differences
     * @return return true when differences are expected
     */
    public boolean hasDifference(
            final List<Map<String, String>> dataset1, final List<Map<String, String>> dataset2,
            final List<Map<String, String>> expectedDifferences) {

        final AssertionResult result = difference(dataset1, dataset2, expectedDifferences);

        return result.difference;
    }
}
