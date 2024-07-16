package PramothVM.steps;


import PramothVM.utilities.DatasetAssertion;
import PramothVM.utilities.DatasetUtils;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
public class AssertionStep {

    private final DatasetAssertion assertion = new DatasetAssertion();

    @Then("dump snapshot {string}")
    public void dumpSnapshot(final String name) {
        final List<Map<String, String>> dataset = FeatureContext.getDataset(name);

        log.info("Dump snapshot {}:\n{}", name, DatasetUtils.printDataset(dataset));
    }

    @Then("dump snapshot {string} on")
    public void dumpSnapshotOnFields(final String name, final DataTable dataTable) {
        final Set<String> columns = new LinkedHashSet<>(dataTable.row(0));
        final List<Map<String, String>> dataset = DatasetUtils.selectColumns(FeatureContext.getDataset(name), columns);

        log.info("Dump snapshot {}:\n{}", name, DatasetUtils.printDataset(dataset));
    }

    @Then("dump snapshot {string} against {string}")
    public void dumpSnapshotDifference(final String name1, final String name2) {
        final List<Map<String, String>> dataset1 = FeatureContext.getDataset(name1);
        final List<Map<String, String>> dataset2 = FeatureContext.getDataset(name2);
        final String reportComparison = DatasetUtils.printDatasetComparison(dataset1, dataset2);

        log.info("Dump snapshot differences {} against {}:\n{}", name1, name2, reportComparison);
    }

    @And("validate snapshot {string} on")
    public void compareDifferences(final String name, final List<Map<String, String>> expectedDataSet) {
        final Set<String> columns = DatasetUtils.getColumns(expectedDataSet);
        final List<Map<String, String>> actualDataset = DatasetUtils.selectColumns(FeatureContext.getDataset(name), columns);

        if (!assertion.hasNoDifference(actualDataset, expectedDataSet)) {
            final String reportComparison = DatasetUtils.printDatasetComparison(actualDataset, expectedDataSet);

            Assertions.fail("Validate snapshot " + name + " failed:\n" + reportComparison);
        }
    }

    @And("validate snapshot {string} against {string} on")
    public void compareDifferences(final String name1, final String name2, final List<Map<String, String>> expectedDifferences) {
        final Set<String> columns = DatasetUtils.getColumns(expectedDifferences);

        final List<Map<String, String>> dataset1 = DatasetUtils.selectColumns(FeatureContext.getDataset(name1), columns);
        final List<Map<String, String>> dataset2 = DatasetUtils.selectColumns(FeatureContext.getDataset(name2), columns);

        final DatasetAssertion.AssertionResult result = assertion.difference(dataset1, dataset2, expectedDifferences);
        if (result.isDifference()) {
            final String reportActualComparison = DatasetUtils.printDatasetComparison(dataset1, dataset2);
            final String reportExpectedDifferences = DatasetUtils.printDataset(expectedDifferences);
            final String reportUnmatchedComparisons = DatasetUtils.printComparisons(result.getUnmatchedComparisons());
            final String reportUnmatchedDifferences = DatasetUtils.printDataset(result.getUnmatchedDifferences());

            Assertions.fail("Validate snapshot " + name1 + " against " + name2 + " failed:\n" +
                    reportActualComparison + "\n\n expected difference:\n" + reportExpectedDifferences +
                    "\n\n unmatchedComparisons:\n" + reportUnmatchedComparisons +
                    "\n\n unmatchedDifferences:\n" + reportUnmatchedDifferences);
        }
    }
}
