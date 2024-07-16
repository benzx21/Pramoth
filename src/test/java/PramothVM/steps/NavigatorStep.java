package PramothVM.steps;

import PramothVM.utilities.PageUtils;
import PramothVM.utilities.driver.PlaywrightDriver;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;

import io.cucumber.java.en.Given;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

@Slf4j
public class NavigatorStep {

    private final static String MENU_PATH = "div > .navStyle >> .dropdown";
    private final static String MENU_DROPDOWN_PATH = ".dropdown-content";
    private final static String MENU_OPTION_PATH = "div.dropdown-header > #drop-down-chevron > svg";

    @Given("navigation to {string} page")
    public void navigateTo(String screen) {
        final Page page = PlaywrightDriver.getPage();

        page.waitForLoadState();

        final Locator menuLocators = page.locator(MENU_PATH);

        if (menuLocators.count() >= 1) {
            dropdownMenu(menuLocators, screen);
        } else {
            buttonMenu(page, screen);
        }

        PageUtils.waitForLoad(page);
        PageUtils.screenCapture("Navigated to: " + screen);
    }

    private void dropdownMenu(Locator menuLocators, String screen) {
        for (int i = 0; i < menuLocators.count(); i++) {
            final Locator menuLocator = menuLocators.nth(i);
            final Locator menuDropdownLocator = menuLocator.locator(MENU_DROPDOWN_PATH);

            if (menuDropdownLocator.count() > 0) {
                final Locator menuOptionLocator = menuDropdownLocator.getByText(screen);

                if (menuOptionLocator.count() > 0) {
                    final Locator menuChevronLocator = menuLocator.locator(MENU_OPTION_PATH);

                    menuChevronLocator.click();
                    menuOptionLocator.click();
                    return;
                }
            }
        }

        Assertions.fail("Unable to find option: " + screen);
    }

    private void buttonMenu(Page page, String screen) {
        final Locator optionLocator = page.getByRole(AriaRole.BUTTON, new Page.GetByRoleOptions().setName(screen));

        if (optionLocator.isVisible()) {
            optionLocator.click();
            return;
        }

        Assertions.fail("Unable to find option: " + screen);
    }

}
