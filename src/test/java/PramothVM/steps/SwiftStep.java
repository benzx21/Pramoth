package custx.steps;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import custx.utilities.PageUtils;
import custx.utilities.RestUtils;
import custx.utilities.SwiftUtils;
import io.cucumber.java.en.When;
import org.assertj.core.api.Assertions;

import java.util.UUID;

import static custx.constants.Utility.*;

public class SwiftStep {

    @When("swift inbound")
    public void publishSwiftMessage(final String rwaMessage) {
        String swiftMessage = SwiftUtils.format(rwaMessage);

        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);
        final ObjectNode message = RestUtils.createObjectNode();

        message.put("MESSAGE_TYPE", "EVENT_SWIFT_MESSAGE_IN");

        final ObjectNode details = RestUtils.createObjectNode();

        details.put("BODY", swiftMessage);

        message.set("DETAILS", details);
        message.put("USER_NAME", username);

        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to inject message: {}", message.toPrettyString());

        PageUtils.sleep(LOAD_TIME_UPDATE);
    }

}
