package PramothVM.steps;

import PramothVM.utilities.FormatUtils;
import PramothVM.utilities.PageUtils;
import PramothVM.utilities.driver.PlaywrightDriver;
import com.microsoft.playwright.Download;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;

import io.cucumber.java.en.And;
import io.cucumber.java.en.When;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

import java.nio.file.Path;
import java.nio.file.Paths;

import static PramothVM.constants.Utility.LOAD_TIME_ELEMENT;


@Slf4j
public class ButtonStep {

    @When("click {string} {string}")
    public void selectButton(final String button, String type) {
        final Page page = PlaywrightDriver.getPage();
        final Locator buttonLocator = page.getByRole(AriaRole.valueOf(type.toUpperCase()), new Page.GetByRoleOptions().setName(button));

        if (!buttonLocator.isVisible()) {
            Assertions.fail("Button \"" + button + "\" cannot be found to be actioned.");
        }

        if (buttonLocator.isDisabled()) {
            Assertions.fail("Button \"" + button + "\" not in correct state to be actioned.");
        }

        buttonLocator.click();

        PageUtils.sleep(LOAD_TIME_ELEMENT);
    }

    @And("download {string} file")
    public void downloadButton(String filename) {
        final Page page = PlaywrightDriver.getPage();

        Download download = page.waitForDownload(() -> {
            selectButton("Download", "button");
        });

        PageUtils.screenCapture(page, "File download: " + filename);

        final String resolvedFilename = FormatUtils.replaceDateValue(filename);
        final String tempPath = System.getProperty("java.io.tmpdir");
        final Path resolvedPath = Paths.get(tempPath, resolvedFilename);

        log.info("Download temp file: {}", resolvedPath);

        download.saveAs(resolvedPath);
        download.delete();
    }

    @When("select {string}")
    public void select(final String option) {
        Page page = PlaywrightDriver.getPage();
        Locator selectLocators = page.locator("zero-select[role='combobox']");

        for (int i = 0; i < selectLocators.count(); i++) {
            Locator selectLocator = selectLocators.nth(i);
            Locator optionSelectLocator = selectLocator.locator("zero-option[value='" + option + "']");

            if (optionSelectLocator.count() > 0) {
                selectLocator.click();
                optionSelectLocator.click();

                PageUtils.waitForLoad(page);
                return;
            }
        }

        Assertions.fail("Unable to find select: " + option);
    }

}