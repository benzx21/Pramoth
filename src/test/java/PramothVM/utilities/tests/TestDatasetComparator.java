package PramothVM.utilities.tests;


import PramothVM.utilities.DatasetAssertion;
import PramothVM.utilities.DatasetComparator;
import PramothVM.utilities.DatasetUtils;
import lombok.extern.slf4j.Slf4j;
import org.junit.Assert;
import org.junit.Test;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
public class TestDatasetComparator {

    private Map<String, String> row(String... values) {
        Map<String, String> row = new LinkedHashMap<>();

        for (int i = 0; i < values.length; i = i + 2) {
            row.put(values[i], values[i + 1]);
        }

        return row;
    }

    @Test
    public void testDifference() {

        final List<Map<String, String>> dataset1 = List.of(
                row("tradeId", "TD-10", "ISIN", "US0378331005", "tradeDate", "22-Jan-1965", "amount", "1000"),
                row("tradeId", "TD-11", "ISIN", "US0378331005", "tradeDate", "22-Jan-1965", "amount", "2000"),
                row("tradeId", "TD-12", "ISIN", "US5949181045", "tradeDate", "22-Jan-1965", "amount", "3000"),
                row("tradeId", "TD-15", "ISIN", "US5949181046", "tradeDate", "22-Jan-1955", "amount", "5000")
        );

        final List<Map<String, String>> dataset2 = List.of(
                row("tradeId", "TD-10", "ISIN", "US0378331005", "tradeDate", "22-Jan-1965", "amount", "1000"),
                row("tradeId", "TD-14", "ISIN", "US5949181047", "tradeDate", "22-Jan-1954", "amount", "7000"),
                row("tradeId", "TD-11", "ISIN", "US0378331005", "tradeDate", "20-Jan-1965", "amount", "4000"),
                row("tradeId", "TD-13", "ISIN", "US5949181045", "tradeDate", "22-Jan-1965", "amount", "3000")
        );

        final DatasetComparator compareRows = new DatasetComparator();
        final List<DatasetComparator.Comparison> comparisons = compareRows.compare(dataset1, dataset2);

        Assert.assertEquals(comparisons.size(), 5);

        final String report = DatasetUtils.printComparisons(comparisons);

        log.info("report:\n{}", report);

        final DatasetAssertion assertion = new DatasetAssertion();

        Assert.assertFalse(assertion.hasNoDifference(dataset1, dataset2));

        final List<Map<String, String>> expectedComparisons = List.of(
                row("Ops", " ", "tradeId", "TD-10", "ISIN", "US0378331005", "tradeDate", "22-Jan-1965", "amount", "1000"),
                row("Ops", "+", "tradeId", "TD-14", "ISIN", "US5949181047", "tradeDate", "22-Jan-1954", "amount", "7000"),
                row("Ops", ">", "tradeId", "TD-11", "ISIN", "US0378331005", "tradeDate", "@diff(P-2D)", "amount", "@diff(2000)"),
                row("Ops", ">", "tradeId", "TD-13", "ISIN", "US5949181045", "tradeDate", "22-Jan-1965", "amount", "3000"),
                row("Ops", "-", "tradeId", "TD-15", "ISIN", "US5949181046", "tradeDate", "22-Jan-1955", "amount", "5000")
        );

        Assert.assertFalse(assertion.hasDifference(dataset1, dataset2, expectedComparisons));
    }
}
