package custx.utilities;

import custx.steps.FeatureContext;
import lombok.extern.slf4j.Slf4j;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Optional;
import java.util.Properties;

import static custx.constants.Utility.CONTEXT_PARAM_HOST;

@Slf4j
public class ConfigReader {

    private static final Properties properties = new Properties();

    static {
        try {
            FileInputStream file = new FileInputStream("config.properties");
            properties.load(file);

            file.close();
        } catch (IOException e) {
            log.warn("an exception was thrown", e);
        }
    }

    public static String readProperty(String keyWord) {
        return properties.getProperty(keyWord);
    }

    public static Integer readPropertyInt(String keyWord) {
        return Integer.parseInt(properties.getProperty(keyWord));
    }

    public static String definingTheHost(String portal) {
        String server;
        String host = readProperty(portal);

        String env = portal.substring(portal.indexOf("-"));

        if (null != host) {
            server = host;

            if (portal.startsWith("client-")) {
                server = Optional.ofNullable(readProperty("admin".concat(env)))
                        .orElseThrow(() -> new RuntimeException("Server not found for Client portal: " + portal));
            }
        } else {
            String defaultEnv = "admin-defaultEnv";
            if (portal.startsWith("client-")) {
                defaultEnv = "client-defaultEnv";
            }

            host = readProperty(defaultEnv);
            server = readProperty("admin-defaultEnv");
        }

        FeatureContext.setParam(CONTEXT_PARAM_HOST, server);

        return host;
    }

}
