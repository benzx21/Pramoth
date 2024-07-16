package custx.steps;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;
import custx.utilities.PageUtils;
import custx.utilities.driver.PlaywrightDriver;
import io.cucumber.java.en.Given;
import lombok.extern.slf4j.Slf4j;

import static custx.constants.Utility.*;
import static custx.utilities.ConfigReader.definingTheHost;

@Slf4j
public class AuthenticationStep {

    @Given("authentication on {string} with credentials {string} {string}")
    public void userAuthorized(String env, String user, String password) {
        final String host = definingTheHost(env);

        Page page = PlaywrightDriver.getPage();

        log.info("ENVIRONMENT = " + host.toUpperCase());

        page.navigate(host, new Page.NavigateOptions().setTimeout(900000));

        PageUtils.screenCapture(page, "Login Prompt");

        Locator usernameLocator = page.getByRole(AriaRole.TEXTBOX, new Page.GetByRoleOptions().setName("Username"));
        Locator passwordLocator = page.getByRole(AriaRole.TEXTBOX, new Page.GetByRoleOptions().setName("Password"));
        Locator loginLocator = page.getByRole(AriaRole.BUTTON, new Page.GetByRoleOptions().setName("Login"));

        usernameLocator.type(user);
        passwordLocator.type(password);

        loginLocator.click();
        PageUtils.waitForLoad(page);

        PageUtils.screenCapture(page, "Login Request");

        FeatureContext.setParam(CONTEXT_PARAM_USER_NAME, user);
        FeatureContext.setParam(CONTEXT_PARAM_PASSWORD, password);

        page.waitForTimeout(LOAD_TIME_LOADING);
    }
}
