package custx.steps;

import com.microsoft.playwright.Page;
import custx.utilities.driver.PlaywrightDriver;
import io.cucumber.java.en.Then;

public class WaitStep {

    @Then("wait for {int} msecs")
    public void waitFor(int milliseconds) {
        final Page page = PlaywrightDriver.getPage();
        page.waitForTimeout(milliseconds);
    }

}
