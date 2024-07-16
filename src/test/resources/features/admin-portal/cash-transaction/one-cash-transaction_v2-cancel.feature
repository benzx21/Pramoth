@Admin
@Regression
Feature: Admin portal

  Scenario Outline: Validate cash transaction v2 cancel on Cash Transactions and Ledger Postings screens

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv

    Given navigation to "CSV Loader" page
    Then "CASH" CSV is uploaded successfully
      | FILE_TYPE | TRADE_STATUS | INTERMEDIARY_BANK | CounterpartyCode | CounterpartyBic | VALUE_DATE         | CLIENT_CODE  | CLIENT_MASTER_ACCOUNT_NAME | ClientSubAccount | SIDE        | LEGAL_ENTITY_CODE | AMOUNT   | CURRENCY | COMMENT   | TRADE_SUBTYPE  | NOSTRO_BANK  | NOSTRO_CODE  | TraderId   | CustodianTradeRef |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<valueDate>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | <direction> | <legalEntityCode> | <amount> | <ccy>    | <comment> | <tradeSubType> | <nostroBank> | <nostroCode> | @default() | @default()        |

    Given navigation to "Cash Transactions" page
    When filter on "Cash Transactions" by
      | Name                | Operator | Value                              |
      | Custodian Trade Ref | Equals   | @context(LAST_CUSTODIAN_TRADE_REF) |
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v1"
    And validate snapshot "cash_transaction_v1" on
      | Booking Date | Contractual Value Date | Actual Value Date | Settlement Status | Transaction Status | Client code  | Master account            | Sub Account  | Nostro Code  | Nostro Bank  | Legal Entity Code (Custody) | Trade Sub-Type | Direction   | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate  | Counterparty Code | Counterparty BIC | Comment   | Intermediary Bank | Source           |
      | @date(T)     | @date(<valueDate>)     | [empty]           | UNSETTLED         | NEW                | <clientCode> | <clientMasterAccountName> | <subAccount> | <nostroCode> | <nostroBank> | <legalEntityCode>           | <tradeSubType> | <direction> | @abs(<amt>) | <ccy>    | 0.00                | @abs(<amt*ratePref>)             | <baseCcy>          | <fxRate> | A123465798        | A1234567891      | <comment> | BAML              | ADMIN_CSV_UPLOAD |
    And set param "LAST_CUSTX_CASH_TRANS_ID" from dataset "cash_transaction_v1" with "CustX Cash Trans ID" row 0

    Given navigation to "Ledger Postings" page
    When filter on "Ledger Postings" by
      | Name          | Operator | Value                              |
      | Cash Trans ID | Equals   | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v1"
    And validate snapshot "ledger_posting_v1" on
      | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name      | Cash/Security Amount | Currency |
      | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <cre_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |
      | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <deb_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |

    Given navigation to "Cash Transactions" page
    When search on "Cash Transactions" by
      | CustX Cash Trans ID                |
      | @context(LAST_CUSTX_CASH_TRANS_ID) |
    And select on "Cash Transactions" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v2"
    And validate snapshot "cash_transaction_v1" against "cash_transaction_v2" on
      | Ops | Booking Date | Contractual Value Date | Actual Value Date | Settlement Status | Transaction Status | Client code | Master account | Sub Account | Nostro Code | Nostro Bank | Legal Entity Code (Custody) | Trade Sub-Type | Direction | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate | Counterparty Code | Counterparty BIC | Comment | Intermediary Bank | Source |
      | ~   | @same        | @same                  | @same             | @same             | CANCELLED          | @same       | @same          | @same       | @same       | @same       | @same                       | @same          | @same     | @same       | @same    | @same               | @same                            | @same              | @same   | @same             | @same            | @same   | @same             | @same  |

    Given navigation to "Ledger Postings" page
    When filter on "Ledger Postings" by
      | Name          | Operator | Value                              |
      | Cash Trans ID | Equals   | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v2"
    And validate snapshot "ledger_posting_v1" against "ledger_posting_v2" on
      | Ops | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name      | Cash/Security Amount | Currency |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | +   | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <deb_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |
      | +   | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <cre_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |

    Examples:
      ##############  CONFIG  ############## ******************************************************************************************************  TRADE  ***************************************************************************************************** ####  Formatted(Amounts)  #### ************************  Aggregations(Expected results)  *********************** #############################################     GL ACCOUNT NAMES     #############################################
      | env              | username | password    | valueDate | tradeSubType                  | subAccount                           | baseCcy | direction | legalEntityCode | clientCode | clientMasterAccountName | nostroBank | nostroCode     | ccy | amount | comment             | amt       | fxRate | amt*ratePref | cre_cash_unSett_gl                            | deb_cash_unSett_gl                               |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash                   | JPM:SFL-USD-GBR:CC:REC:CANCv2:T      | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 1000   | CT via admin portal | 1,000.00  | 1.7200 | 1,720.00     | Custody Client Cash Account                   | Free Cash 'In Transit' Account                   |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash                   | JPM:SFL-USD-GBR:CC:PAY:CANCv2:T      | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 1000   | CT via admin portal | -1,000.00 | 1.7200 | -1,720.00    | Free Cash 'In Transit' Account                | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Dividend    | JPM:SFL-USD-GBR:CCDDIV:REC:CANCv2:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Dividends Receivable Account                     |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Dividend    | JPM:SFL-USD-GBR:CCDDIV:PAY:CANCv2:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | -2,000.00 | 1.7200 | -3,440.00    | Dividends Payable Account                     | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Dividend    | JPM:SFL-USD-GBR:CCCLDIV:REC:CANCv2:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Dividends Receivable Account                     |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Dividend    | JPM:SFL-USD-GBR:CCCLDIV:PAY:CANCv2:T | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | -2,000.00 | 1.7200 | -3,440.00    | Dividends Payable Account                     | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Corp Action | JPM:SFL-USD-GBR:CCCLCA:REC:CANCv2:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Corporate Action - Other Cash Receivable Account |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Corp Action | JPM:SFL-USD-GBR:CCCLCA:PAY:CANCv2:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | 2,000.00  | 1.7200 | 3,440.00     | Corporate Action - Other Cash Payable Account | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Coupon      | JPM:SFL-USD-GBR:CCDCPN:REC:CANCv2:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Coupons Receivable Account                       |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Coupon      | JPM:SFL-USD-GBR:CCDCPN:PAY:CANCv2:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | -2,000.00 | 1.7200 | -3,440.00    | Coupons Payable Account                       | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Coupon      | JPM:SFL-CAD-FRA:CCCLCPN:REC:CANCv2:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | CAD | 2000   | CT via admin portal | 2,000.00  | 1.1074 | 2,214.80     | Custody Client Cash Account                   | Coupons Receivable Account                       |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Coupon      | JPM:SFL-CAD-FRA:CCCLCPN:PAY:CANCv2:T | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | CAD | 2000   | CT via admin portal | -2,000.00 | 1.1074 | -2,214.80    | Coupons Payable Account                       | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Corp Action | JPM:SFL-USD-GBR:CCDCA:REC:CANCv2:T   | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Corporate Action - Other Cash Receivable Account |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Corp Action | JPM:SFL-USD-GBR:CCDCA:PAY:CANCv2:T   | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT via admin portal | -2,000.00 | 1.7200 | -3,440.00    | Corporate Action - Other Cash Payable Account | Custody Client Cash Account                      |
