package PramothVM.steps;

import PramothVM.utilities.CsvProcessor;
import PramothVM.utilities.FormatUtils;
import PramothVM.utilities.PageUtils;
import PramothVM.utilities.driver.PlaywrightDriver;
import com.microsoft.playwright.Page;

import io.cucumber.java.en.Then;

import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FileStep {

    @Then("snapshot dataset {string} file as {string}")
    public void snapshotDataSetFile(String filename, final String name) {
        final Page page = PlaywrightDriver.getPage();
        final String label = "Dataset " + filename + " as " + name;

        PageUtils.screenCapture(page, label);

        final List<Map<String, String>> rows = new ArrayList<>();

        filename = FormatUtils.replaceDateValue(filename);

        List<String[]> file = CsvProcessor.readFile(Paths.get(System.getProperty("java.io.tmpdir"), filename));

        String[] headers = file.remove(0);
        file.forEach(record -> {
            Map<String, String> row = new HashMap<>();

            for (int i = 0; i < headers.length; i++) {
                String cell = "";
                if (record.length > i) {
                    cell = record[i];
                }

                row.put(headers[i], cell);
            }

            rows.add(row);
        });

        FeatureContext.setDataset(name, rows);
    }

}
