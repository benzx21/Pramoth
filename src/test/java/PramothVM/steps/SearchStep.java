package custx.steps;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import custx.constants.Utility;
import custx.utilities.FormatUtils;
import custx.utilities.PageUtils;
import custx.utilities.driver.PlaywrightDriver;
import io.cucumber.java.en.When;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import java.util.Map;

import static custx.constants.Utility.*;
import static custx.utilities.FormatUtils.formatStringDate;

@Slf4j
public class SearchStep {

    public static final String FUNCTION_CONTEXT = "@context";
    private static final String[] CONTEXT_PARAM_NAMES = new String[]{
            CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID,
            CONTEXT_PARAM_CUSTODIAN_TRADE_REF,
            CONTEXT_PARAM_CUSTX_TRADE_ID,
            CONTEXT_PARAM_CUSTX_CASH_TRANS_ID,
            CONTEXT_PARAM_CUSTX_TRADE_ID_CUST01,
            CONTEXT_PARAM_CUSTX_TRADE_ID_CUST02,
            CONTEXT_PARAM_CUSTX_TRADE_ID_SPIRE01,
            CONTEXT_PARAM_CUSTX_TRADE_ID_SPIRE02
    };

    @When("search on {string} by")
    public void searchBy(String screenName, List<Map<String, String>> parameters) {
        final Page page = PlaywrightDriver.getPage();
        final Locator searchApplyButton = page.locator("zero-button[id='searchButton']");
        final Locator searchEntries = page.locator("search-panel >> div.searchEntryField");

        final boolean hasButtonContainer = page.locator("div.button-container >> nth=0").isVisible();
        final Locator searchButton = hasButtonContainer ?
                page.locator("div.button-container >> nth=0 >> zero-button").getByText("Search") :
                page.locator("div.search-toggle-button >> nth=0 >> zero-button").getByText("Search");

        Map<String, String> params = parameters.get(0);
        final Map<String, String> contextMap = FeatureContext.getParams(CONTEXT_PARAM_NAMES);

        searchButton.click();
        page.waitForTimeout(LOAD_TIME_ELEMENT);
        for (Map.Entry<String, String> param : params.entrySet()) {
            String value = param.getValue();
            Locator searchEntry = searchEntries
                    .filter(new Locator.FilterOptions().setHasText(param.getKey()))
                    .locator("input");
            if (value.startsWith("@option(")) {
                value = value.substring(8, value.lastIndexOf(")"));
                searchEntry = searchEntries
                        .filter(new Locator.FilterOptions().setHasText(param.getKey()));
                searchEntry.click();
                searchEntry.locator("zero-option").getByText(value).click();
            } else {
                if (value.startsWith("@date(")) {
                    String date = FormatUtils.resolveDateValue(null, value, Utility.DATE_FORMAT_DDMMMYYYY);
                    value = formatStringDate(date);
                } else if (value.startsWith(FUNCTION_CONTEXT)) {
                    final String contextName =
                            value.replace(FUNCTION_CONTEXT, "").replace("(", "")
                                    .replace(")", "").trim();
                    value = contextMap.get(contextName);

                    if (value == null) {
                        throw new IllegalStateException("Invalid \"" + contextName + "\" + filter: " + contextMap);
                    }
                }

                searchEntry.fill(value);
            }
        }
        searchApplyButton.click();
        PageUtils.waitForLoad(page);
        PageUtils.screenCapture("Search on " + screenName);
        searchButton.click();
    }
}
