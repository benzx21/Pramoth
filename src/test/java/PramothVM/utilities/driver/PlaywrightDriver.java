package PramothVM.utilities.driver;

import PramothVM.utilities.ConfigReader;
import com.microsoft.playwright.*;

import lombok.extern.slf4j.Slf4j;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import static PramothVM.utilities.ConfigReader.readPropertyInt;


@Slf4j
public class PlaywrightDriver {
    private static ThreadLocal<Playwright> playwrightThread = new ThreadLocal<>();
    private static ThreadLocal<BrowserType> browserTypeThread = new ThreadLocal<>();
    private static ThreadLocal<Browser> browserThread = new ThreadLocal<>();
    private static ThreadLocal<BrowserContext> browserContextThread = new ThreadLocal<>();
    private static ThreadLocal<Page> pageThread = new ThreadLocal<>();
    private static Page page;
    private static Browser browser;
    private static BrowserType browserType;
    private static BrowserContext context;
    private static String browserName = "";
    private static Path downloadsPath = null;
    private static int viewWidth = 0;


    /**
     * This is for getting responding tags from terminal if passed
     *
     */
    static {
        browserName = System.getProperty("browser") == null ? ConfigReader.readProperty("browser") : System.getProperty("browser");
        viewWidth = System.getProperty("set-viewport-width") == null ? readPropertyInt("viewport-width") : Integer.parseInt(System.getProperty("set-viewport-width"));
        downloadsPath = Paths.get("target/downloads");
    }

    public static synchronized Page getPage() {
        if (playwrightThread.get() == null) {
            Playwright playwright = createPlaywright();
            playwrightThread.set(playwright);
            Page page = createPage(playwright);
            pageThread.set(page);
        }
        return pageThread.get();
    }

    public static Playwright createPlaywright() {
        return Playwright.create();
    }

    private static synchronized Page createPage(Playwright playwright) {

        playwright = Playwright.create();

        final List<String> ignoreDefaultArgs = List.of("--hide-scrollbars");

        try {
            switch (browserName.toLowerCase()) {
                case "firefox":
                    browserType = playwright.firefox();
                    browser = browserType.launch(new BrowserType.LaunchOptions().setHeadless(false).setDownloadsPath(downloadsPath));
                    break;

                case "firefox-headless":
                    browserType = playwright.firefox();
                    browser = browserType.launch(new BrowserType.LaunchOptions().setHeadless(true).setIgnoreDefaultArgs(ignoreDefaultArgs).setDownloadsPath(downloadsPath));
                    break;

                case "chrome":
                    browserType = playwright.chromium();
                    browser = browserType.launch(new BrowserType.LaunchOptions().setHeadless(false).setDownloadsPath(downloadsPath));
                    break;

                case "chrome-headless":
                    browserType = playwright.chromium();
                    browser = browserType.launch(new BrowserType.LaunchOptions().setHeadless(true).setIgnoreDefaultArgs(ignoreDefaultArgs).setDownloadsPath(downloadsPath));
                    break;

                case "edge":
                    browserType = playwright.chromium();
                    browser = browserType.launch(new BrowserType.LaunchOptions().setChannel("msedge").setHeadless(false).setDownloadsPath(downloadsPath).setSlowMo(1000));
                    break;
                case "edge-headless":
                    browserType = playwright.chromium();
                    browser = browserType.launch(new BrowserType.LaunchOptions().setChannel("msedge").setHeadless(true).setIgnoreDefaultArgs(ignoreDefaultArgs).setDownloadsPath(downloadsPath));
                    break;
            }
        } catch (Exception ex) {
            log.error("Unable to create browser: {}", browserName, ex);

            throw ex;
        }

        context = browser.newContext(new Browser.NewContextOptions().
                setIgnoreHTTPSErrors(true)
                .setTimezoneId("Europe/London")
                .setLocale("en-GB")
                .setViewportSize(viewWidth, readPropertyInt("viewport-size-height")));

        browserTypeThread.set(browserType);
        browserThread.set(browser);
        browserContextThread.set(context);
        page = context.newPage();

        return page;
    }

    public static synchronized void closePage() {
        Playwright playwright = playwrightThread.get();
        Page page = pageThread.get();
        if (playwright != null) {
            browser.close();
            browserThread.remove();
            page.close();
            pageThread.remove();
            playwright.close();
            playwrightThread.remove();
        }
    }
}
