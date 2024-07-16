package PramothVM.steps;

import PramothVM.utilities.FormUtils;
import PramothVM.utilities.PageUtils;
import PramothVM.utilities.driver.PlaywrightDriver;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;

import io.cucumber.java.en.When;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static PramothVM.constants.Utility.CONTEXT_PARAM_CUSTODIAN_TRADE_REF;
import static PramothVM.constants.Utility.CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID;


@Slf4j
public class FormStep {

    private static final String[] CONTEXT_PARAM_NAMES = new String[]{
            CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID,
            CONTEXT_PARAM_CUSTODIAN_TRADE_REF
    };

    private static final String DEFAULT_DIALOG = "zero-dialog";

    private Locator getOpenDialog(final Page page, final String dialogHeader) {
        final Locator dialogsLocator = page.locator(DEFAULT_DIALOG);
        final int dialogCount = dialogsLocator.count();
        final List<String> foundHeaders = new LinkedList<>();

        if (dialogCount == 0) {
            Assertions.fail("No dialogs in the page");
        }

        for (int i = 0; i < dialogCount; i++) {
            final Locator dialogLocator = dialogsLocator.nth(i);
            boolean notSeparateHeader = dialogLocator.locator("h2").first().isVisible();
            final Locator headerLocator = notSeparateHeader ? dialogLocator.locator("h2").first() : dialogLocator.locator("div.dialog-heading");

            if (headerLocator.isVisible()) {
                final String header = headerLocator.innerText();
                foundHeaders.add(header);

                if (header.equals(dialogHeader)) {
                    // Found the dialog
                    if (!headerLocator.isVisible()) {
                        Assertions.fail("Dialog \"" + dialogHeader + "\" found but is not open.");
                    }

                    return notSeparateHeader ? dialogLocator.locator("div").first() : dialogLocator.locator("div >> nth=1");
                }
            }
        }

        Assertions.fail("Dialog \"" + dialogHeader + "\" could not be found in page dialogs: " + foundHeaders);
        return null;
    }

    @When("submit dialog {string} using {string} button")
    public void submitDialog(final String dialog, final String button) {
        final Page page = PlaywrightDriver.getPage();
        final Locator formLocator = getOpenDialog(page, dialog);

        PageUtils.screenCapture("Submit Dialog " + dialog);
        FormUtils.submit(page, formLocator, button);
    }

    @When("submit dialog {string} using {string} button with inputs")
    public void submitDialog(final String dialog, final String button, final List<Map<String, String>> inputs) {
        final Page page = PlaywrightDriver.getPage();
        final Locator formLocator = getOpenDialog(page, dialog);
        final Map<String, Map<String, String>> inputMap =
                inputs.stream().collect(Collectors.toMap(f -> f.get("Name"), f -> f));
        final Map<String, String> contextMap = FeatureContext.getParams(CONTEXT_PARAM_NAMES);

        PageUtils.screenCapture("Submit Dialog (pre-inputs)" + dialog);
        FormUtils.setInputValues(page, formLocator, inputMap, contextMap);
        PageUtils.screenCapture("Submit Dialog (post-inputs) " + dialog);
        FormUtils.submit(page, formLocator, button);
    }
}
