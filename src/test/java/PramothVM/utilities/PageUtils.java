package custx.utilities;

import com.microsoft.playwright.Page;
import custx.utilities.driver.PlaywrightDriver;
import io.qameta.allure.Allure;
import io.qameta.allure.AllureLifecycle;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;

import java.io.ByteArrayInputStream;

import static custx.constants.Utility.LOAD_TIME_LOADING;

/**
 * Wrapper for reporting base functionality
 */
@Slf4j
public class PageUtils {

    @SneakyThrows
    public static void sleep(int milli) {
        Thread.sleep(milli);
    }

    /**
     * Wait to continue the execution until the div Loading... is hidden.
     *
     * @param page the page
     */
    public static void waitForLoad(final Page page) {
        do {
            page.waitForTimeout(LOAD_TIME_LOADING);
        }
        while ("Loading...".equals(page.locator("div.ag-overlay").first().textContent().trim()));
    }

    /**
     * Wait to continue the execution until the div notify-container is hidden.
     *
     * @param page the page
     */
    public static void waitForNotifyClose(final Page page) {
        do {
            page.waitForTimeout(LOAD_TIME_LOADING);
        }
        while (page.locator("div.notify-container").isVisible());
    }

    /**
     * Take a screen capture of the current page and add it into the report if/when the report exists.
     *
     * @param label the label of the screen shop in the report
     */
    public static void screenCapture(final String label) {
        final Page page = PlaywrightDriver.getPage();

        screenCapture(page, label);
    }

    /**
     * Take a screen capture of the current page and add it into the report if/when the report exists.
     *
     * @param page  the page
     * @param label the label of the screen shop in the report
     */
    public static void screenCapture(final Page page, final String label) {
        final AllureLifecycle lifecycle = Allure.getLifecycle();

        if (lifecycle.getCurrentTestCase().isPresent()) {
            Allure.addAttachment(label, new ByteArrayInputStream(page.screenshot()));
        }
    }
}
