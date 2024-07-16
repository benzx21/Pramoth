package PramothVM.utilities.api;

import PramothVM.utilities.api.pojo.BasePojo;
import PramothVM.utilities.api.pojo.Details;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

import io.restassured.response.Response;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


import static PramothVM.utilities.Credentials.userCredentials;
import static PramothVM.utilities.api.specifications.RequestResponseSpecifications.requestSpecification;
import static PramothVM.utilities.api.specifications.RequestResponseSpecifications.responseSpecification;
import static io.restassured.RestAssured.given;

public class APIBaseClass {
    private Response response;

    public APIBaseClass() {
    }

    public Response POSTLogin(String userType, String host) {
        ObjectWriter objectWriter = new ObjectMapper().writer().withDefaultPrettyPrinter();

        try {
            response =
                    given()
                            .spec(requestSpecification(host))
                            .body(objectWriter.writeValueAsString(setLoginBody(userType))).
                            when()
                            .post("event-login-auth").
                            then()
                            .spec(responseSpecification())
                            .log().all()
                            .extract().response()
            ;
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return response;
    }

    public BasePojo setLoginBody(String userType) {
        Details details = new Details();
        BasePojo basePojo = new BasePojo();

        details.setUSER_NAME(userCredentials(userType).get("Username"));
        details.setPASSWORD(userCredentials(userType).get("Password"));
        basePojo.setDETAILS(details);

        return basePojo;
    }

    public Map<String, String> getOnlyTheToken(String user, String host) {
        response = POSTLogin(user, host);
        Map<String, String> map = new LinkedHashMap<>();
        map.put("SESSION_AUTH_TOKEN", response.jsonPath().getString("SESSION_AUTH_TOKEN"));
        map.put("REFRESH_AUTH_TOKEN", response.jsonPath().getString("REFRESH_AUTH_TOKEN"));
        return map;
    }

    public List<String> getOnlyThePermissions(String user, String host) {
        response = POSTLogin(user, host);
        return new ArrayList<>(response.jsonPath().getList("PERMISSION"));
    }

    public List<String> getOnlyTheProfile(String user, String host) {
        response = POSTLogin(user, host);
        return new ArrayList<>(response.jsonPath().getList("PROFILE"));
    }

}
