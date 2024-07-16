package custx.utilities.api.pojo;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor

public class Details {
    @JsonProperty("USER_NAME")
    private String USER_NAME;
    @JsonProperty("PASSWORD")
    private String PASSWORD;
}
