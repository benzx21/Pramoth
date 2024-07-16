package custx.utilities;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
public class RestUtils {
    private static final String HEADER_NAME_SESSION_AUTH_TOKEN = "SESSION_AUTH_TOKEN";
    private static final String HEADER_NAME_SOURCE_REF = "SOURCE_REF";
    private static final String HEADER_NAME_CONTENT_TYPE = "CONTENT_TYPE";
    private static final String HEADER_VALUE_CONTENT_TYPE = "application/json";

    private static final String SESSION_BASE_URL = "BASE_URL";
    private static final String SESSION_TOKEN = "TOKEN";
    private static final String SESSION_USERNAME = "USERNAME";
    private static final String SESSION_PASSWORD = "PASSWORD";
    private static final String SESSION_SOURCE_REF = "SOURCE_REF";

    private static final TrustManager[] noopTrustManager = new TrustManager[]{
            new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] xcs, String string) {
                }

                public void checkServerTrusted(X509Certificate[] xcs, String string) {
                }

                public X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
            }
    };

    private static ThreadLocal<HttpClient> httpClientThread = new ThreadLocal<>();
    private static ObjectMapper objectMapper = new ObjectMapper();
    private static Map<String, String> userSessionMap = new ConcurrentHashMap();
    private static Map<String, Map<String, String>> sessionAttributesMap = new ConcurrentHashMap<>();

    static {
        // Disable certificate and hostname verification
        Properties properties = System.getProperties();
        properties.setProperty("jdk.internal.httpclient.disableHostnameVerification", Boolean.TRUE.toString());

        // Define JSON object mapper
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        objectMapper.findAndRegisterModules();
    }

    public static synchronized ObjectNode createObjectNode() {
        return objectMapper.createObjectNode();
    }

    public static synchronized HttpClient getHttpClient() {
        if (httpClientThread.get() == null) {
            // Disable certificate and hostname verification
            Properties properties = System.getProperties();
            properties.setProperty("jdk.internal.httpclient.disableHostnameVerification", Boolean.TRUE.toString());

            SSLContext sslContext = null;

            try {
                sslContext = SSLContext.getInstance("ssl");
                sslContext.init(null, noopTrustManager, null);
            } catch (NoSuchAlgorithmException | KeyManagementException ex) {
                log.error("SSL Context could not be created", ex);

                throw new IllegalStateException("SSL Context could not be created: " + ex.getMessage(), ex);
            }

            HttpClient httpClient = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_1_1)
                    .connectTimeout(Duration.ofSeconds(10))
                    .sslContext(sslContext)
                    .build();

            httpClientThread.set(httpClient);
        }

        return httpClientThread.get();
    }

    /**
     * Connect and return a session identifier on a successful login.
     *
     * @param baseURL   the base URL
     * @param username  the username
     * @param password  the password
     * @param sourceRef the source reference
     * @return return the session identifier
     */
    public static String connect(final String baseURL,
                                 final String username, final String password,
                                 final String sourceRef) {

        final String userSessionKey = username + ":" + sourceRef + "@" + baseURL;

        if (userSessionMap.containsKey(userSessionKey)) {
            // Already logged
            return userSessionMap.get(userSessionKey);
        }

        final ObjectNode message = createObjectNode();

        message.put("MESSAGE_TYPE", "TXN_LOGIN_AUTH");
        message.put("SERVICE_NAME", "AUTH_MANAGER");

        final ObjectNode details = objectMapper.createObjectNode();

        details.put("USER_NAME", username);
        details.put("PASSWORD", password);

        message.set("DETAILS", details);

        try {
            final String messageAsJson = objectMapper.writeValueAsString(message);
            final HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString(messageAsJson);
            final HttpRequest requestAuthorization = HttpRequest.newBuilder()
                    .POST(bodyPublisher)
                    .uri(URI.create(baseURL + "/event-login-auth"))
                    .setHeader(HEADER_NAME_SOURCE_REF, sourceRef)
                    .setHeader("Content-Type", "application/json")
                    .setHeader(HEADER_NAME_CONTENT_TYPE, HEADER_VALUE_CONTENT_TYPE)
                    .build();

            final HttpResponse<String> responseAuthorization =
                    getHttpClient().send(requestAuthorization, HttpResponse.BodyHandlers.ofString());

            Assertions.assertThat(responseAuthorization.statusCode()).isEqualTo(HttpURLConnection.HTTP_OK);

            final JsonNode payload = objectMapper.readTree(responseAuthorization.body());
            final JsonNode messageType = payload.get("MESSAGE_TYPE");

            if (messageType.textValue().equals("EVENT_LOGIN_AUTH_NACK")) {
                throw new IllegalStateException("Unable to log into custx: {}" + payload.toPrettyString());
            }

            Assertions.assertThat(messageType.textValue()).isEqualTo("EVENT_LOGIN_AUTH_ACK");

            final JsonNode sessionAuthToken = payload.get("SESSION_AUTH_TOKEN");
            final String session = sessionAuthToken.textValue();

            final Map sessionAttributeMap = new HashMap<>();

            sessionAttributeMap.put(SESSION_BASE_URL, baseURL);
            sessionAttributeMap.put(SESSION_TOKEN, session);
            sessionAttributeMap.put(SESSION_USERNAME, username);
            sessionAttributeMap.put(SESSION_PASSWORD, password);
            sessionAttributeMap.put(SESSION_SOURCE_REF, sourceRef);

            userSessionMap.put(userSessionKey, session);
            sessionAttributesMap.put(session, sessionAttributeMap);

            return session;

        } catch (IOException | InterruptedException ex) {
            log.error("Unable to log into custx: {}", message.toPrettyString(), ex);

            throw new IllegalStateException("Unable to log into custx: " + message.toPrettyString(), ex);
        }
    }

    /**
     * check for message failure responses.
     *
     * @param response the message
     * @return return true when the response is a failure
     */
    public static boolean isFailure(final JsonNode response) {
        final JsonNode responseType = response.get("MESSAGE_TYPE");

        return responseType.textValue().equals("EVENT_LOGIN_AUTH_NACK");
    }

    /**
     * Send the following message using the specified session.
     *
     * @param session the session
     * @param message the message to send to the server
     * @return return the response
     */
    public static JsonNode send(final String session, final ObjectNode message) {
        final Map<String, String> sessionAttributeMap = sessionAttributesMap.get(session);

        if (sessionAttributeMap == null) {
            log.error("Session is not active: {}", session);

            throw new IllegalStateException("Session is not active: " + session);
        }

        final String baseURL = sessionAttributeMap.get(SESSION_BASE_URL);
        final String sourceRef = sessionAttributeMap.get(SESSION_SOURCE_REF);
        final String token = sessionAttributeMap.get(SESSION_TOKEN);
        final String messageType = message.get("MESSAGE_TYPE").textValue();

        try {
            final String messageAsJson = objectMapper.writeValueAsString(message);
            final HttpRequest.BodyPublisher httpBodyPublisher = HttpRequest.BodyPublishers.ofString(messageAsJson);
            final HttpRequest httpRequest = HttpRequest.newBuilder()
                    .POST(httpBodyPublisher)
                    .uri(URI.create(baseURL + "/" + messageType))
                    .setHeader(HEADER_NAME_SOURCE_REF, sourceRef)
                    .setHeader(HEADER_NAME_SESSION_AUTH_TOKEN, token)
                    .setHeader(HEADER_NAME_CONTENT_TYPE, HEADER_VALUE_CONTENT_TYPE)
                    .build();
            final HttpResponse<String> response = getHttpClient().send(httpRequest, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != HttpURLConnection.HTTP_OK) {
                throw new IllegalStateException("Request failed: " + response);
            }

            final JsonNode payload = objectMapper.readTree(response.body());

            log.debug("Response JSON Payload " + payload);

            return payload;
        } catch (IOException | InterruptedException ex) {
            log.error("Unable to send message: {}", message, ex);

            throw new IllegalStateException("Unable to send message: " + message, ex);
        }
    }
}
