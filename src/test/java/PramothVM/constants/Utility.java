package PramothVM.constants;

import java.time.format.DateTimeFormatter;

public final class Utility {

    public static final String DATE_FORMAT_YYYYMMDD_WITHOUT = "yyyyMMdd";
    public static final String DATE_FORMAT_DDMMYYYY_WITHOUT = "ddMMyyyy";
    public static final String DATE_FORMAT_YYYYMMDD = "yyyy-MM-dd";
    public static final String DATE_FORMAT_MMDDYYYY = "MM/dd/yyyy";
    public static final String DATE_FORMAT_DDMMMYYYY = "dd-MMM-yyyy";
    public static final String DATE_FORMAT_DDMMYYYY = "dd/MM/yyyy";
    public static final String DATE_TIME_FORMAT_DDMMYYYY_HHMMSS = "dd-MMM-yyyy HH:mm:ss";

    public static final DateTimeFormatter DATE_FORMATTER_YYYYMMDD = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static final int LOAD_TIME_ELEMENT = 500;
    public static final int LOAD_TIME_LOADING = 1500;
    public static final int LOAD_TIME_UPDATE = 2500;

    public static final String CONTEXT_PARAM_HOST = "HOST";
    public static final String CONTEXT_PARAM_USER_NAME = "USER_NAME";
    public static final String CONTEXT_PARAM_PASSWORD = "PASSWORD";

    public static final String CONTEXT_PARAM_CUSTODIAN_TRADE_REF = "LAST_CUSTODIAN_TRADE_REF";
    public static final String CONTEXT_PARAM_SOURCE_ALLOCATION_TRADE_ID = "LAST_SOURCE_ALLOCATION_TRADE_ID";
    public static final String CONTEXT_PARAM_CUSTX_TRADE_ID = "LAST_CUSTX_TRADE_ID";
    public static final String CONTEXT_PARAM_CUSTX_TRADE_ID_CUST01 = "CUST01_CUSTX_TRADE_ID";
    public static final String CONTEXT_PARAM_CUSTX_TRADE_ID_CUST02 = "CUST02_CUSTX_TRADE_ID";
    public static final String CONTEXT_PARAM_CUSTX_TRADE_ID_SPIRE01 = "CUSTX_TRADE_ID_Spire01";
    public static final String CONTEXT_PARAM_CUSTX_TRADE_ID_SPIRE02 = "CUSTX_TRADE_ID_Spire02";
    public static final String CONTEXT_PARAM_CUSTX_CASH_TRANS_ID = "LAST_CUSTX_CASH_TRANS_ID";

    public static final String HOUSEKEEPING_PURGE_ALL_DATA = "PURGE DATA";
    public static final String HOUSEKEEPING_PURGE_DATA = "PURGE DATA";
    public static final String HOUSEKEEPING_EXECUTE_REPORT = "EXECUTE REPORT";
    public static final String HOUSEKEEPING_UPLOAD_FX_RATES = "UPLOAD_FX_RATES";
    public static final String HOUSEKEEPING_UPLOAD_PRICES = "UPLOAD_PRICES";
    public static final String HOUSEKEEPING_PEXECUTE_JOB = "EXECUTE_JOB";

    public static final String TAG_NEEDS_EMPTY = "@NeedsEmpty";
}
