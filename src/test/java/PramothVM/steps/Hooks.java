package custx.steps;

import com.microsoft.playwright.Page;
import custx.utilities.driver.PlaywrightDriver;
import io.cucumber.java.After;
import io.cucumber.java.AfterAll;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;
import lombok.extern.slf4j.Slf4j;

import static custx.constants.Utility.*;
import static custx.utilities.driver.PlaywrightDriver.closePage;

@Slf4j
public class Hooks {
    @Before
    public static void beforeScenario(Scenario scenario) {
        Page page = PlaywrightDriver.getPage();

        if (scenario.getSourceTagNames().contains(TAG_NEEDS_EMPTY)) {
            SystemContext.addParamValue(HOUSEKEEPING_EXECUTE_REPORT, scenario.getId());
        } else {
            do {
                page.waitForTimeout(LOAD_TIME_LOADING);
            } while (SystemContext.hasParam(HOUSEKEEPING_EXECUTE_REPORT));
        }
    }

    @After
    public static void afterScenario(Scenario scenario) {
        if (scenario.getSourceTagNames().contains(TAG_NEEDS_EMPTY)) {
            SystemContext.removeParamValue(HOUSEKEEPING_EXECUTE_REPORT, scenario.getId());
        }
    }

    @AfterAll
    public static void afterAllScenarios() {
        closePage();
    }
}
