package PramothVM.utilities;

import com.github.javafaker.Faker;

import java.util.LinkedHashMap;
import java.util.Map;

public class Credentials {

    public static Map<String, String> userCredentials(String userType) {
        Map<String, String> userCredential = new LinkedHashMap<>();
        switch (userType) {
            case "QA1":
                userCredential.put("Username", "JohnDoe");
                userCredential.put("Password", "Password11*");
                break;
            case "Fake":
                userCredential.put("Username", new Faker().name().username());
                userCredential.put("Password", new Faker().internet().password());
                break;
        }
        return userCredential;
    }

}