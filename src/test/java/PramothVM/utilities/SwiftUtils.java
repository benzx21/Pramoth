package custx.utilities;

import custx.steps.FeatureContext;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import static custx.constants.Utility.CONTEXT_PARAM_CUSTODIAN_TRADE_REF;
import static custx.constants.Utility.CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID;
import static custx.constants.Utility.DATE_FORMAT_DDMMMYYYY;

public class SwiftUtils {
    private static final String FUNCTION_DATE = "@date";
    private static final String FUNCTION_AMOUNT = "@amount";
    private static final String FUNCTION_CONTEXT = "@context";
    private static final DateTimeFormatter DATE_FORMATTER_SWIFT = DateTimeFormatter.ofPattern("yyyyMMdd");

    private static final String[] CONTEXT_PARAM_NAMES = new String[]{
            CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID,
            CONTEXT_PARAM_CUSTODIAN_TRADE_REF
    };

    public static String format(final String message) {
        final StringBuilder formatMessage = new StringBuilder(message);

        int startPos = formatMessage.indexOf(FUNCTION_DATE);

        while (startPos > 0) {
            final int endPos = formatMessage.indexOf(")", startPos);

            if (endPos < 0) {
                final String errorLine = formatMessage.substring(startPos - 20, startPos + 40);
                throw new IllegalStateException("Malformed function found in swift: " + errorLine);
            }

            final String rawValue = formatMessage.substring(startPos + 6, endPos);
            final String dateValue = FormatUtils.resolveDateValue(rawValue, DATE_FORMAT_DDMMMYYYY);
            final String swiftDateValue = FormatUtils.formatStringDate(dateValue, DATE_FORMATTER_SWIFT);

            formatMessage.replace(startPos, endPos + 1, swiftDateValue);

            startPos = formatMessage.indexOf(FUNCTION_DATE);
        }

        startPos = formatMessage.indexOf(FUNCTION_AMOUNT);

        while (startPos > 0) {
            final int endPos = formatMessage.indexOf(")", startPos);

            if (endPos < 0) {
                final String errorLine = formatMessage.substring(startPos - 20, startPos + 40);
                throw new IllegalStateException("Malformed function found in swift: " + errorLine);
            }

            final String rawValue = formatMessage.substring(startPos + 8, endPos);
            final BigDecimal amount = new BigDecimal(rawValue.replace(",", ""));

            String swiftAmountValue = amount.abs().toPlainString().replace(".", ",");

            if (!swiftAmountValue.contains(",")) {
                swiftAmountValue = swiftAmountValue + ",";
            }

            formatMessage.replace(startPos, endPos + 1, swiftAmountValue);

            startPos = formatMessage.indexOf(FUNCTION_AMOUNT);
        }

        final Map<String, String> contextMap = FeatureContext.getParams(CONTEXT_PARAM_NAMES);

        startPos = formatMessage.indexOf(FUNCTION_CONTEXT);

        while (startPos > 0) {
            final int endPos = formatMessage.indexOf(")", startPos);

            if (endPos < 0) {
                final String errorLine = formatMessage.substring(startPos - 20, startPos + 40);
                throw new IllegalStateException("Malformed function found in swift: " + errorLine);
            }

            final String contextName = formatMessage.substring(startPos + 9, endPos);
            final String contextValue = contextMap.get(contextName);

            if (contextValue == null) {
                final String errorLine = formatMessage.substring(startPos - 20, endPos + 10);
                throw new IllegalStateException("Invalid \"" + contextName + "\" + found in swift: " + errorLine);
            }

            formatMessage.replace(startPos, endPos + 1, contextValue);

            startPos = formatMessage.indexOf(FUNCTION_CONTEXT);
        }

        return formatMessage.toString();
    }
}
