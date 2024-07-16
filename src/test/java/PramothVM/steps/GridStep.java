package PramothVM.steps;

import PramothVM.utilities.GridUtils;
import PramothVM.utilities.PageUtils;
import PramothVM.utilities.driver.PlaywrightDriver;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;

import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.util.AbstractMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static PramothVM.constants.Utility.*;


public class GridStep {
    private static final String[] CONTEXT_PARAM_NAMES = new String[]{
            CONTEXT_PARAM_CUSTX_TRADE_ID,
            CONTEXT_PARAM_CUSTX_CASH_TRANS_ID,
            CONTEXT_PARAM_CUSTODIAN_TRADE_REF,
            CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID
    };

    private static final String DEFAULT_GRID_QUERY = "zero-tab-panel >> nth=0";

    Map<String, String> gridQueryMap = Map.ofEntries(
            new AbstractMap.SimpleEntry("security-position", "#positions-grid >> zero-tab-panel >> nth=0"),
            new AbstractMap.SimpleEntry("cash-positions", "#cash-positions-grid >> zero-tab-panel >> nth=0"),
            new AbstractMap.SimpleEntry("Pending Trades", "zero-tab-panel >> nth=1"),
            new AbstractMap.SimpleEntry("Pending Cash", "zero-tab-panel >> nth=1"),
            new AbstractMap.SimpleEntry("Client Statements", "zero-tab-panel >> nth=1")
    );

    @When("filter on {string} by")
    public void filterRows(final String grid, final List<Map<String, String>> filters) {
        final Page page = PlaywrightDriver.getPage();
        final String gridQuery = gridQueryMap.getOrDefault(grid, DEFAULT_GRID_QUERY);
        final Locator gridLocator = page.locator(gridQuery);
        final Map<String, Map<String, String>> filterMap =
                filters.stream().collect(Collectors.toMap(f -> f.get("Name"), f -> f));
        final Map<String, String> contextMap = FeatureContext.getParams(CONTEXT_PARAM_NAMES);

        GridUtils.setGridFilters(page, gridLocator, filterMap, contextMap);
    }

    @Then("snapshot dataset {string} as {string}")
    public void snapshotDataSet(final String grid, final String name) {
        final Page page = PlaywrightDriver.getPage();
        final String label = "Dataset " + grid + " as " + name;

        PageUtils.screenCapture(page, label);

        final String gridQuery = gridQueryMap.getOrDefault(grid, DEFAULT_GRID_QUERY);
        final Locator gridLocator = page.locator(gridQuery);
        final List<Map<String, String>> rows = GridUtils.getDatasetFromGrid(page, gridLocator);

        FeatureContext.setDataset(name, rows);
    }

    @Then("set param {string} from dataset {string} with {string} row {int}")
    public void setContextFromSnapshot(final String name, final String dataset, final String column, final int rowNo) {
        final List<Map<String, String>> rows = FeatureContext.getDataset(dataset);
        final Map<String, String> row = rows.get(rowNo);
        final String value = row.get(column);

        FeatureContext.setParam(name, value);
    }

    @When("select on {string} row {int}")
    public void selectRow(final String grid, final int rowNo) {
        final Page page = PlaywrightDriver.getPage();
        final String gridQuery = gridQueryMap.getOrDefault(grid, DEFAULT_GRID_QUERY);
        final Locator gridLocator = page.locator(gridQuery);
        GridUtils.selectRow(page, gridLocator, rowNo);

        PageUtils.sleep(LOAD_TIME_UPDATE);
    }

    @When("checkbox on {string} all rows")
    public void checkboxAllRows(final String grid) {
        final Page page = PlaywrightDriver.getPage();
        final String gridQuery = gridQueryMap.getOrDefault(grid, DEFAULT_GRID_QUERY);
        final Locator gridLocator = page.locator(gridQuery);
        GridUtils.checkboxAllRows(page, gridLocator);

        PageUtils.sleep(LOAD_TIME_UPDATE);
    }

    @When("checkbox on {string} first rows")
    public void checkboxFirstRows(final String grid, final List<String> values) {
        final Page page = PlaywrightDriver.getPage();
        final String gridQuery = gridQueryMap.getOrDefault(grid, DEFAULT_GRID_QUERY);
        final Locator gridLocator = page.locator(gridQuery);
        GridUtils.checkboxFirstRows(page, gridLocator, values);

        PageUtils.sleep(LOAD_TIME_UPDATE);
    }

    @When("click button {string} on {string} {int} row")
    public void clickButtonRow(final String button, final String grid, final int row) {
        final Page page = PlaywrightDriver.getPage();
        final String gridQuery = gridQueryMap.getOrDefault(grid, DEFAULT_GRID_QUERY);
        final Locator gridLocator = page.locator(gridQuery);
        GridUtils.clickButtonRow(page, button, gridLocator, row);

        PageUtils.sleep(LOAD_TIME_UPDATE);
    }

}