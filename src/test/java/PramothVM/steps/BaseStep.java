package PramothVM.steps;

import io.cucumber.java.DataTableType;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class BaseStep {

    @DataTableType(replaceWithEmptyString = "[empty]")
    public String emptyString(String cell) {
        return cell;
    }

}