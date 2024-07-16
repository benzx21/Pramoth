package PramothVM.utilities.api;

import PramothVM.utilities.api.pojo.BasePojo;
import PramothVM.utilities.api.pojo.Details;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import io.restassured.http.ContentType;


import static PramothVM.utilities.Credentials.userCredentials;
import static io.restassured.RestAssured.given;

public class GenerateToken {

    public static String apiLogin(String userType) {
        ObjectWriter objectWriter = new ObjectMapper().writer().withDefaultPrettyPrinter();

        Details details = new Details();
        BasePojo basePojo = new BasePojo();

        details.setUSER_NAME(userCredentials(userType).get("Username") + ":" + userCredentials(userType).get("COMPID"));
        details.setPASSWORD(userCredentials(userType).get("Password"));
        basePojo.setDETAILS(details);
        String SESSION_AUTH_TOKEN = "";
        try {
            SESSION_AUTH_TOKEN =
                    given()
                            .body(objectWriter.writeValueAsString(basePojo))
                            .header("SOURCE_REF", "custx_server")
                            .contentType(ContentType.JSON).
                            when()
                            .post("/event-login-auth").
                            then()
                            .extract()
                            .jsonPath()
                            .getString("SESSION_AUTH_TOKEN")
            ;
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return SESSION_AUTH_TOKEN;
    }
}
