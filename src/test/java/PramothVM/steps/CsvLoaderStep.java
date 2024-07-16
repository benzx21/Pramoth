package custx.steps;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import custx.utilities.FormatUtils;
import custx.utilities.PageUtils;
import custx.utilities.driver.PlaywrightDriver;
import io.cucumber.java.en.Then;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

import java.io.File;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static custx.constants.AppMessages.SUCCESS_MESSAGE_LOAD_CSV;
import static custx.constants.AppMessages.SUCCESS_MESSAGE_VALIDATE_CSV;
import static custx.constants.Utility.*;
import static custx.utilities.CsvProcessor.writeLineByLine;
import static custx.utilities.FormatUtils.resolveDateValue;
import static custx.utilities.PageUtils.sleep;

@Slf4j
public class CsvLoaderStep {
    @Then("{string} CSV is uploaded successfully")
    public void csvIsUploadedSuccessfully(String type, List<Map<String, String>> table) {
        Page page = PlaywrightDriver.getPage();
        selectCsvType(type);

        List<String[]> updatedCsvRows = new ArrayList<>();

        table.forEach(map -> {
            HashMap<String, String> tradeTable = map.entrySet().stream()
                    .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue, (e1, e2) -> e1, HashMap::new));

            LocalDateTime today = LocalDateTime.now();
            String tradeDate = resolveDateValue(tradeTable.getOrDefault("TradeDate", ""), DATE_FORMAT_DDMMYYYY);
            String settDate = resolveDateValue(tradeTable.getOrDefault("SettlementDate", ""), DATE_FORMAT_DDMMYYYY);
            String valueDate = resolveDateValue(tradeTable.getOrDefault("VALUE_DATE", ""), DATE_FORMAT_DDMMYYYY);

            String customIdRef = tradeTable.get("CustodianTradeRef");
            if (customIdRef.equalsIgnoreCase("@default()") || customIdRef.isEmpty()) {
                customIdRef = tradeTable.get("ClientSubAccount") + FormatUtils.dateToEpoch(today);
            }
            FeatureContext.setParam(CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID, customIdRef);
            FeatureContext.setParam(CONTEXT_PARAM_CUSTODIAN_TRADE_REF, customIdRef);

            tradeTable.put("TradeDate", tradeDate);
            tradeTable.put("SettlementDate", settDate);
            tradeTable.put("VALUE_DATE", valueDate);
            tradeTable.put("TraderId", customIdRef);
            tradeTable.put("CustodianTradeRef", customIdRef);

            if (updatedCsvRows.isEmpty()) {
                updatedCsvRows.add(tradeTable.keySet().toArray(new String[0]));
            }
            updatedCsvRows.add(tradeTable.values().toArray(new String[0]));
        });

        File tmp = writeLineByLine(updatedCsvRows, "Temp" + type);
        log.info("CSV temp file: {}", tmp.toPath());

        String responseLoad = uploadTrade(tmp.toPath());

        PageUtils.screenCapture(page, "CSV upload: " + tmp.toPath());
        Assertions.assertThat(responseLoad).contains(SUCCESS_MESSAGE_LOAD_CSV);
    }

    private void selectCsvType(String type) {
        Page page = PlaywrightDriver.getPage();
        Locator fileTypeSelect = page.locator("zero-select[role='combobox']");
        fileTypeSelect.click();
        fileTypeSelect.locator("zero-option[value='" + type + "']").click();
        page.waitForTimeout(LOAD_TIME_ELEMENT);
    }

    public String uploadTrade(Path filePath) {
        Page page = PlaywrightDriver.getPage();
        Locator selectedFile = page.locator("input[type='file']");
        Locator validateFileButton = page.locator("div.csv-button-container >> zero-button >> nth=0");
        Locator loadFileButton = page.locator("div.csv-button-container >> zero-button >> nth=1");
        Locator selectAll = page.locator("zero-tab-panel >> nth=0 >> div.lower-half >> div.ag-pinned-left-header >> input[type='checkbox']");
        Locator list = page.locator("zero-tab-panel >> nth=0 >> div.lower-half >> div.ag-center-cols-viewport > div");
        Locator colLoadFile = page.locator("div[col-id='LOAD_FILE']");
        Locator colValidationStatus = page.locator("div[col-id='VALIDATION_STATUS']");
        Locator floatingResponseMessage = page.locator("div[id='notify-container']");

        selectedFile.setInputFiles(filePath);
        validateFileButton.click();

        sleep(LOAD_TIME_LOADING);

        int rows = list.first().locator(colValidationStatus).count();
        for (int i = 0; i < rows; i++) {
            String validationStatus = list.first().locator(colValidationStatus).nth(i).textContent().trim();
            if (!SUCCESS_MESSAGE_VALIDATE_CSV.equals(validationStatus)) {
                return validationStatus;
            }
        }

        selectAll.click();
        loadFileButton.click();

        sleep(LOAD_TIME_ELEMENT);
        return floatingResponseMessage.textContent().trim();
    }

}
