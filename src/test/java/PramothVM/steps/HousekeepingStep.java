package custx.steps;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.opencsv.CSVReader;
import custx.utilities.FormatUtils;
import custx.utilities.RestUtils;
import io.cucumber.java.en.Given;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;

import java.io.FileReader;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

import static custx.constants.Utility.*;

@Slf4j
public class HousekeepingStep {

    private static final String[] TEST_DATA_TABLES = new String[] {
            "ACCOUNT_TRANSFER",
            "ACCOUNT_TRANSFER_COUNTER",
            "ACCOUNT_TRANSFER_SWIFT_DETAIL",
            "ADJUSTMENT",
            "POSITION_ENTRY",
            "BALANCE_EOD",
            "CASH_DATA",
            "CASH",
            "CORPORATE_ACTION",
            "POSTING",
            "TRADE_DATA",
            "TRADE_COUNTER",
            "TRADE_COMMENTS",
            "TRADE",
            "TRADE_MATCH",
            "TRADE_MATCH_CUSTODIAN_LINKAGE",
            "SWIFT_INBOUND_MESSAGE",
            "SWIFT_OUTBOUND_MESSAGE",
            "JOURNAL",
            "EXCEPTION_CASE",
            "GENERAL_LEDGER_FEED",
            "AUDIT_TRAIL",
            "AUDIT_TRAIL_LOG",
            "TRADE_SETTLEMENT_AUDIT",
            "USER_LOGIN_AUDIT",
            "APPROVAL",
            "CASH_LADDER",
            "CASH_LADDER_PIVOT",
            "CLIENT_CORPORATE_ACTION",
            "CLIENT_REPORT",
            "CORPORATE_ACTION",
            "GENERATED_ADMIN_REPORT",
            "GENERATED_CLIENT_REPORT",
            "GENERATED_TACTICAL_REPORT",
            "GENERAL_LEDGER_FEED",
            "INSTRUMENT",
            "INSTRUMENT_PRICE",
            "FX_RATE",
            "BALANCE_EOD"
    };

    private static final String[] TEST_JOB_NAMES = new String[] {
            "EVENT_CREATE_EOD_BALANCE",
            "EVENT_UPDATE_BUSINESS_DATE"
    };

    private static final Map<String, String> FX_FIELD_NAME_MAPPINGS = Map.ofEntries(
            Map.entry("As At", "AS_AT"),
            Map.entry("Base CCY", "BASE_CURRENCY"),
            Map.entry("Quote CCY", "QUOTE_CURRENCY"),
            Map.entry("Source", "SOURCE"),
            Map.entry("Rate", "FX_RATE")
    );

    private static final Map<String, String> SECURITY_FIELD_NAME_MAPPINGS = Map.ofEntries(
            Map.entry("As At", "AS_AT"),
            Map.entry("ISIN", "ISIN"),
            Map.entry("Name", "NAME"),
            Map.entry("Type", "SECURITY_TYPE"),
            Map.entry("Exchange Code", "EXCHANGE_CODE"),
            Map.entry("CFI Code", "CFI_CODE"),
            Map.entry("Source", "SOURCE"),
            Map.entry("CCY", "CURRENCY"),
            Map.entry("Open Price", "OPEN_PRICE"),
            Map.entry("Closing Price", "CLOSING_PRICE"),
            Map.entry("Price", "CLOSING_PRICE")
    );

    /**
     * Purge all data from specified tables.
     * @param  tables  the array of tables
     */
    private void purgeData(final String[] tables) {
        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);

        ObjectMapper mapper = new ObjectMapper();
        ArrayNode array = mapper.valueToTree(tables);

        final ObjectNode details = RestUtils.createObjectNode();
        details.putArray("TABLE").addAll(array);

        final ObjectNode message = RestUtils.createObjectNode();
        message.put("MESSAGE_TYPE", "REQ_EVENT_ENTITY_PURGE");
        message.put("USER_NAME", username);
        message.set("DETAILS", details);

        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to clear all data {}: {}",
                response.toPrettyString());

        //redo EOD Balance due to CONSOLIDATOR
        final JsonNode response2 = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response2)).isFalse().as("Unable to clear all data {}: {}",
                response2.toPrettyString());
    }

    /**
     * Purge transactional data (trades, positions, etc...) for all env.
     */
    @Given("clear all data")
    public void purgeData() {
        purgeData(TEST_DATA_TABLES);

        executeJobs(TEST_JOB_NAMES);
    }

    @Given("clear all data within")
    public void pergeData(final List<Map<String, String>> inputs){
        final List<String> tableList = new LinkedList();

        for (Map<String, String> row : inputs) {
            final String tableName = row.get("Table");

            if (tableName != null) {
                tableList.add(tableName);
            }
        }

        Assertions.assertThat(tableList).isNotEmpty();

        String[] tableNames = tableList.toArray(new String[tableList.size()]);

        purgeData(tableNames);
    }
    /**
     * Purge transactional data (trades, positions, etc...) for a specified sub-account.
     *
     * @param subAccount the sub-account
     */
    @Given("clear data for {string}")
    public void purgeData(final String subAccount) {
        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);
        final ObjectNode message = RestUtils.createObjectNode();

        message.put("MESSAGE_TYPE", "EVENT_CLEAR_DATA_BY_SUB_ACCOUNT");

        final ObjectNode details = RestUtils.createObjectNode();

        details.put("SUB_ACCOUNT", subAccount);

        message.set("DETAILS", details);
        message.put("USER_NAME", username);

        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to clear sub-account {}: {}",
                subAccount, response.toPrettyString());

        final JsonNode response2 = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response2)).isFalse().as("Unable to clear sub-account {}: {}",
                subAccount, response.toPrettyString());

        SystemContext.addParamValue(HOUSEKEEPING_PURGE_DATA, "ACCOUNT_PURGE:[" + subAccount + "]");

        executeJobs(TEST_JOB_NAMES);
    }

    private ObjectNode createMessage(final String event, final String username, final Map<String, Object> parameters) {
        final ObjectNode details = RestUtils.createObjectNode();

        details.put("OVERRIDE_EXISTING_REPORT", true);

        for (Map.Entry<String, Object> params : parameters.entrySet()) {
            final String key = params.getKey();
            final Object value =  params.getValue();

            if (value instanceof String) {
                String formatValue = FormatUtils.resolveValue(key, (String) value);

                details.put(key, formatValue);
            } else if (value instanceof Boolean) {
                details.put(key, (Boolean) value);
            } else if (value == null) {
                // nothing
            } else {
                details.put(key, value.toString());
            }
        }

        final ObjectNode message = RestUtils.createObjectNode();

        message.put("MESSAGE_TYPE", event);
        message.put("USER_NAME", username);
        message.set("DETAILS", details);

        return message;
    }

    public void executeJobs(final String[] jobNames) {
        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);

        for (String jobName : jobNames) {
            final ObjectNode jobMessage = createMessage(jobName, username, Map.of());
            final JsonNode jobResponse = RestUtils.send(session, jobMessage);

            Assertions.assertThat(RestUtils.isFailure(jobResponse)).isFalse().as("Unable to execute job {}: {}",
                    jobName, jobResponse.toPrettyString());
        }

    }

    /**
     * Execute the specified job with optional parameters
     * @param event       the job event name
     * @param parameters  the optional parameters
     */
    @Given("execute {string} job on")
    public void executeJob(final String event, final Map<String, String> parameters) {
        if (SystemContext.hasParamValue(HOUSEKEEPING_PEXECUTE_JOB, "JOB:" + event)) {
            log.info("Job {} has already been executed.", event);

            return;
        }

        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);

        final Map<String, Object>attributes = parameters.entrySet()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> e.getValue()));

        final ObjectNode message = createMessage(event, username, attributes);
        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to execute job {}: {}",
                event, response.toPrettyString());
    }

    /**
     * Execute the specified report with optional parameters
     * @param event       the report event name
     * @param parameters  the optional parameters
     */
    @Given("execute {string} report on")
    public void executeReport(final String event, final Map<String, String> parameters) {
        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);

        final Map<String, Object>attributes = parameters.entrySet()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, e -> e.getValue()));

        attributes.put("OVERRIDE_EXISTING_REPORT", true);

        final ObjectNode message = createMessage(event, username, attributes);
        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to execute report {}: {}",
                event, response.toPrettyString());
    }

    /**
     * Add the FX table into JSON message document as an array of rows
     *
     * @param fxTable the FX table
     * @param fxRows  the ROW array field in the message
     */
    private void addFxRateRows(List<Map<String, String>> fxTable, final ArrayNode fxRows) {
        for (Map<String, String> row : fxTable) {
            if (fxRows.size() == 0) {
                // Add HEADER row
                final ObjectNode fxRow = RestUtils.createObjectNode();
                final ArrayNode fieldNames = fxRow.putArray("FIELD");

                for (String name : row.keySet()) {
                    final String fieldName = FX_FIELD_NAME_MAPPINGS.get(name);

                    if (fieldName == null) {
                        Assertions.fail("Invalid column name for FX rates: " + name);
                    }

                    fieldNames.add(fieldName);

                    // Add the inverse rate
                    if (fieldName.equals("FX_RATE")) {
                        fieldNames.add("INVERSE_FX_RATE");
                    }
                }

                fxRows.add(fxRow);
            }

            // Add DATA row
            final ObjectNode fxRow = RestUtils.createObjectNode();
            final ArrayNode fieldValues = fxRow.putArray("FIELD");
            final ObjectNode inverseFxRow = RestUtils.createObjectNode();
            final ArrayNode inverseFieldValues = inverseFxRow.putArray("FIELD");

            for (Map.Entry<String, String> entry : row.entrySet()) {
                final String fieldName = FX_FIELD_NAME_MAPPINGS.get(entry.getKey());

                String fieldValue = entry.getValue();

                if (fieldName.equals("AS_AT")) {
                    fieldValue = FormatUtils.resolveDateValue(fieldName, fieldValue, DATE_FORMAT_DDMMYYYY);
                }

                if (fieldName.equals("BASE_CURRENCY") || fieldName.equals("QUOTE_CURRENCY")) {
                    fieldValues.add(fieldValue);

                    if (fieldName.equals("BASE_CURRENCY")) {
                        final String quoteCcy = row.get("Quote CCY");

                        if (quoteCcy == null) {
                            Assertions.fail("Unable inverse FX rate: " + row);
                        }

                        inverseFieldValues.add(quoteCcy);
                    } else {
                        final String baseCcy = row.get("Base CCY");

                        if (baseCcy == null) {
                            Assertions.fail("Unable inverse FX rate: " + row);
                        }

                        inverseFieldValues.add(baseCcy);
                    }
                } else if (fieldName.equals("FX_RATE")) {
                    final BigDecimal rate = new BigDecimal(fieldValue).setScale(4);
                    final BigDecimal inverseRate = rate.multiply(BigDecimal.valueOf(0.5)).setScale(4, RoundingMode.HALF_UP);

                    fieldValues.add(fieldValue);
                    fieldValues.add(inverseRate.toString());

                    inverseFieldValues.add(inverseRate.toString());
                    inverseFieldValues.add(fieldValue);
                } else {
                    fieldValues.add(fieldValue);
                    inverseFieldValues.add(fieldValue);
                }

                fxRows.add(fxRow);
                fxRows.add(inverseFxRow);
            }
        }
    }

    /**
     * Load the FX rates in the specified table if they have not already been loaded for this test run.
     *
     * @param filename the filename
     */
    @SneakyThrows
    @Given("FX rates from file {}")
    public void uploadFxRate(final String filename) {
        if (SystemContext.hasParamValue(HOUSEKEEPING_UPLOAD_FX_RATES, "FILE:" + filename)) {
            log.info("FX Rates have already been uploaded.");

            return;
        }

        final CSVReader reader = new CSVReader((new FileReader(filename)));
        final List<String[]> data = reader.readAll();
        final List<Map<String, String>> fxTable = new LinkedList<>();
        final String[] headers = data.get(0);

        for (int i = 1; i < data.size(); i++) {
            final Map<String, String> row = new LinkedHashMap<>();

            for (int j = 0; j < headers.length; j++) {
                row.put(headers[j], data.get(i)[j]);
            }

            fxTable.add(row);
        }

        uploadFxRates(fxTable);
    }

    /**
     * Load the FX rate table.
     *
     * @param fxTable the FX rate table
     */
    @Given("FX rates")
    public void uploadFxRates(List<Map<String, String>> fxTable) {
        if (SystemContext.hasParamValue(HOUSEKEEPING_UPLOAD_FX_RATES, "HASHCODE" + fxTable.hashCode())) {
            log.info("FX Rates have already been uploaded.");

            return;
        }

        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);
        final ObjectNode message = RestUtils.createObjectNode();

        message.put("MESSAGE_TYPE", "EVENT_FX_MESSAGE_IN");

        final ObjectNode details = RestUtils.createObjectNode();
        final ArrayNode rows = details.putArray("ROW");

        addFxRateRows(fxTable, rows);

        message.set("DETAILS", details);
        message.put("USER_NAME", username);

        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to set FX Rates {}: {}",
                message.toPrettyString(), response.toPrettyString());

        SystemContext.addParamValue(HOUSEKEEPING_UPLOAD_FX_RATES, "HASHCODE" + fxTable.hashCode());
    }

    /**
     * Add the Security proce table into JSON message document as an array of rows
     *
     * @param priceTable the Security price table
     * @param priceRows  the ROW array field in the message
     */
    private void addSecurityPriceRows(final List<Map<String, String>> priceTable, final ArrayNode priceRows) {
        for (Map<String, String> row : priceTable) {
            if (priceRows.size() == 0) {
                // Add HEADER row
                final ObjectNode priceRow = RestUtils.createObjectNode();
                final ArrayNode fieldNames = priceRow.putArray("FIELD");

                for (String name : row.keySet()) {
                    final String fieldName = SECURITY_FIELD_NAME_MAPPINGS.get(name);

                    if (fieldName == null) {
                        Assertions.fail("Invalid column name for Security prices: " + name);
                    }

                    fieldNames.add(fieldName);
                }

                priceRows.add(priceRow);
            }

            // Add DATA row
            final ObjectNode priceRow = RestUtils.createObjectNode();
            final ArrayNode fieldValues = priceRow.putArray("FIELD");

            for (Map.Entry<String, String> entry : row.entrySet()) {
                final String fieldName = SECURITY_FIELD_NAME_MAPPINGS.get(entry.getKey());
                String fieldValue = entry.getValue();

                if (fieldName.equals("AS_AT")) {
                    fieldValue = FormatUtils.resolveDateValue(fieldName, fieldValue, DATE_FORMAT_DDMMMYYYY);
                } else if (fieldValue == null) {
                    fieldValue = "";
                }

                fieldValues.add(fieldValue);
            }

            priceRows.add(priceRow);
        }
    }

    /**
     * Load the Security prices in the specified table if they have not already been loaded for this test run.
     *
     * @param filename the filename
     */
    @SneakyThrows
    @Given("Security prices from file {}")
    public void uploadPrices(final String filename) {
        if (SystemContext.hasParamValue(HOUSEKEEPING_UPLOAD_PRICES, "FILE:" + filename)) {
            log.info("Prices have already been uploaded: {}.", filename);

            return;
        }

        final CSVReader reader = new CSVReader((new FileReader(filename)));
        final List<String[]> data = reader.readAll();
        final List<Map<String, String>> priceTable = new LinkedList<>();
        final String[] headers = data.get(0);

        for (int i = 1; i < data.size(); i++) {
            final Map<String, String> row = new LinkedHashMap<>();

            for (int j = 0; j < headers.length; j++) {
                row.put(headers[j], data.get(i)[j]);
            }

            priceTable.add(row);
        }

        uploadPrices(priceTable);

        SystemContext.addParamValue(HOUSEKEEPING_UPLOAD_PRICES, "FILE:" + filename);
    }

    /**
     * Load the Security price table.
     *
     * @param priceTable the Security price table
     */
    @Given("Security prices")
    public void uploadPrices(final List<Map<String, String>> priceTable) {
        if (SystemContext.hasParamValue(HOUSEKEEPING_UPLOAD_PRICES, "HASHCODE:" + priceTable.hashCode())) {
            log.info("Prices have already been uploaded.");

            return;
        }
        final String host = FeatureContext.getParam(CONTEXT_PARAM_HOST);
        final String username = FeatureContext.getParam(CONTEXT_PARAM_USER_NAME);
        final String password = FeatureContext.getParam(CONTEXT_PARAM_PASSWORD);
        final String sourceRef = UUID.randomUUID().toString();
        final String baseURL = host.startsWith("https:") ? host + "/sm" : host;

        final String session = RestUtils.connect(baseURL, username, password, sourceRef);
        final ObjectNode message = RestUtils.createObjectNode();

        message.put("MESSAGE_TYPE", "EVENT_INSTRUMENT_MESSAGE_IN");

        final ObjectNode details = RestUtils.createObjectNode();
        final ArrayNode rows = details.putArray("ROW");

        addSecurityPriceRows(priceTable, rows);

        message.set("DETAILS", details);
        message.put("USER_NAME", username);

        final JsonNode response = RestUtils.send(session, message);

        Assertions.assertThat(RestUtils.isFailure(response)).isFalse().as("Unable to set Security Prices {}: {}",
                message.toPrettyString(), response.toPrettyString());

        SystemContext.addParamValue(HOUSEKEEPING_UPLOAD_PRICES, "HASHCODE:" + priceTable.hashCode());
    }
}
