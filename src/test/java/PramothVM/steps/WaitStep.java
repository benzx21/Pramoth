package PramothVM.steps;

import PramothVM.utilities.driver.PlaywrightDriver;
import com.microsoft.playwright.Page;

import io.cucumber.java.en.Then;

public class WaitStep {

    @Then("wait for {int} msecs")
    public void waitFor(int milliseconds) {
        final Page page = PlaywrightDriver.getPage();
        page.waitForTimeout(milliseconds);
    }

}
