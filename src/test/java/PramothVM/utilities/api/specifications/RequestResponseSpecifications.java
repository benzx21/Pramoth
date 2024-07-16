package PramothVM.utilities.api.specifications;

import com.github.javafaker.Faker;
import io.restassured.http.ContentType;
import io.restassured.specification.RequestSpecification;
import io.restassured.specification.ResponseSpecification;
import org.hamcrest.Matchers;
import static PramothVM.utilities.ConfigReader.readProperty;
import static PramothVM.utilities.ConfigReader.readPropertyInt;
import static io.restassured.RestAssured.expect;
import static io.restassured.RestAssured.given;

public class RequestResponseSpecifications {
    public static RequestSpecification requestSpecification(String host) {
        return given()
                .baseUri(definingTheAPIHost(host))
                .port(readPropertyInt("port"))
                .log().all()
                .header("SOURCE_REF", "tam-web - " + new Faker().internet().uuid())
                .contentType(ContentType.JSON)
                ;
    }

    public static ResponseSpecification responseSpecification() {
        return expect()
                .contentType(ContentType.JSON)
                .statusCode(200)
                .time(Matchers.lessThan(5000L))
                ;
    }

    private static String definingTheAPIHost(String host) {
        return host == null ?
                readProperty("defaultEnv") :
                readProperty(host).replaceFirst("s", "");
    }
}
