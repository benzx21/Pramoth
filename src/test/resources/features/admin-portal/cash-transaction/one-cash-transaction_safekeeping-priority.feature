@Admin
#@Regression #currently failing due to TQ-7745
Feature: Admin portal

  Scenario Outline: Validate Client and Stonex Safekeeping account screen trough v2 and v3 in Cash Transactions and Ledger Postings

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

    Given navigation to "Cash Transactions" page
    When search on "Cash Transactions" by
      | CustX Cash Trans ID                |
      | @context(LAST_CUSTX_CASH_TRANS_ID) |
    And select on "Cash Transactions" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value       |
      | Settlement Status | SETTLED     |
      | Actual Value Date | <valueDate> |
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v2"
    And validate snapshot "cash_transaction_v1" against "cash_transaction_v2" on
      | Ops | Booking Date | Contractual Value Date | Actual Value Date  | Settlement Status | Transaction Status | Client code | Master account | Sub Account | Nostro Code | Nostro Bank | Legal Entity Code (Custody) | Trade Sub-Type | Direction | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate | Counterparty Code | Counterparty BIC | Comment | Intermediary Bank | Source |
      | ~   | @same        | @same                  | @date(<valueDate>) | SETTLED           | @same              | @same       | @same          | @same       | @same       | @same       | @same                       | @same          | @same     | @same       | @same    | @abs(<amt>)         | @same                            | @same              | @same   | @same             | @same            | @same   | @same             | @same  |

    Given navigation to "Ledger Postings" page
    When filter on "Ledger Postings" by
      | Name          | Operator | Value                              |
      | Cash Trans ID | Equals   | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v1"
    And validate snapshot "ledger_posting_v1" on
      | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name    | Cash/Security Amount | Currency |
      | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <cre_cash_sett_gl> | @abs(<amt>)          | <ccy>    |
      | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <deb_cash_sett_gl> | @abs(<amt>)          | <ccy>    |
    Given navigation to "Cash Transactions" page
    When search on "Cash Transactions" by
      | CustX Cash Trans ID                |
      | @context(LAST_CUSTX_CASH_TRANS_ID) |
    And select on "Cash Transactions" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value     |
      | Settlement Status | UNSETTLED |
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v3"
    And validate snapshot "cash_transaction_v2" against "cash_transaction_v3" on
      | Ops | Booking Date | Contractual Value Date | Actual Value Date | Settlement Status | Transaction Status | Client code | Master account | Sub Account | Nostro Code | Nostro Bank | Legal Entity Code (Custody) | Trade Sub-Type | Direction | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate | Counterparty Code | Counterparty BIC | Comment | Intermediary Bank | Source |
      | ~   | @same        | @same                  | [empty]           | UNSETTLED         | @same              | @same       | @same          | @same       | @same       | @same       | @same                       | @same          | @same     | @same       | @same    | 0.00                | @same                            | @same              | @same   | @same             | @same            | @same   | @same             | @same  |

    Given navigation to "Ledger Postings" page
    When filter on "Ledger Postings" by
      | Name          | Operator | Value                              |
      | Cash Trans ID | Equals   | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v2"
    And validate snapshot "ledger_posting_v1" against "ledger_posting_v2" on
      | Ops | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name    | Cash/Security Amount | Currency |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | +   | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <deb_cash_sett_gl> | @abs(<amt>)          | <ccy>    |
      | +   | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <cre_cash_sett_gl> | @abs(<amt>)          | <ccy>    |


    Examples:
      ##############  CONFIG  ############## ***************************************************************************************************************  TRADE  ************************************************************************************************************** # Formatted(Amounts) # * Aggregations(Expected results) * ###################################     GL ACCOUNT NAMES     ##################################

      | env              | username | password    | valueDate | tradeSubType                       | subAccount                          | baseCcy | direction | legalEntityCode | clientCode | clientMasterAccountName | nostroBank | nostroCode     | ccy | amount | comment              | amt       | fxRate | amt*ratePref | cre_cash_sett_gl                                 | deb_cash_sett_gl                                 |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Transaction Fee | JPM:SFL-AUD-FRA:CSTF:PAY:CANCv4:T   | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | EUR | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Custodian Safekeeping - Transaction Fees Account | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Transaction Fee | JPM:SFL-AUD-FRA:CSTF:REC:CANCv4:T   | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | EUR | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                      | Custodian Safekeeping - Transaction Fees Account |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Portfolio Fee   | JPM:SFL-AUD-GBR:CSPF:PAY:CANCv4:T   | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | GBP | 2000   | CT from admin portal | -2,000.00 | 0.8200 | -1,640.00    | Custodian Safekeeping - Portfolio Fees Account   | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Portfolio Fee   | JPM:SFL-AUD-GBR:CSPF:REC:CANCv4:T   | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | GBP | 2000   | CT from admin portal | 2,000.00  | 0.8200 | 1,640.00     | Custody Client Cash Account                      | Custodian Safekeeping - Portfolio Fees Account   |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Interest        | JPM:SFL-AUD-BEL:CSI:PAY:CANCv4:T    | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | USD | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Custodian Safekeeping - Interest Account         | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Interest        | JPM:SFL-AUD-BEL:CSI:REC:CANCv4:T    | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | USD | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                      | Custodian Safekeeping - Interest Account         |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Other Fee       | JPM:SFL-AUD-AUS:CSOF:PAY:CANCv4:T   | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | AUD | 2000   | CT from admin portal | -2,000.00 | 1.0000 | -2,000.00    | Custodian Safekeeping - Other Fees Account       | Custody Client Cash Account                      |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Safekeeping Other Fee       | JPM:SFL-AUD-AUS:CSOF:REC:CANCv4:T   | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode  | AUD | 2000   | CT from admin portal | 2,000.00  | 1.0000 | 2,000.00     | Custody Client Cash Account                      | Custodian Safekeeping - Other Fees Account       |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Transaction Fee | JPM:SFL-AUD-FRA:SSTF:PAY:UNSETTv3:T | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Nostro Account                                   | Custodian Safekeeping - Transaction Fees Account |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Transaction Fee | JPM:SFL-AUD-FRA:SSTF:REC:UNSETTv3:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custodian Safekeeping - Transaction Fees Account | Nostro Account                                   |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Portfolio Fee   | JPM:SFL-AUD-GBR:SSPF:PAY:UNSETTv3:T | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | GBP | 2000   | CT from admin portal | -2,000.00 | 0.8200 | -1,640.00    | Nostro Account                                   | Custodian Safekeeping - Portfolio Fees Account   |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Portfolio Fee   | JPM:SFL-AUD-GBR:SSPF:REC:UNSETTv3:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | GBP | 2000   | CT from admin portal | 2,000.00  | 0.8200 | 1,640.00     | Custodian Safekeeping - Portfolio Fees Account   | Nostro Account                                   |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Interest        | JPM:SFL-AUD-BEL:SSI:PAY:UNSETTv3:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Nostro Account                                   | Custodian Safekeeping - Interest Account         |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Interest        | JPM:SFL-AUD-BEL:SSI:REC:UNSETTv3:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | USD | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custodian Safekeeping - Interest Account         | Nostro Account                                   |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Other Fee       | JPM:SFL-AUD-AUS:SSOF:PAY:UNSETTv3:T | AUD     | PAY       | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | AUD | 2000   | CT from admin portal | -2,000.00 | 1.0000 | -2,000.00    | Nostro Account                                   | Custodian Safekeeping - Other Fees Account       |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Stonex Safekeeping Other Fee       | JPM:SFL-AUD-AUS:SSOF:REC:UNSETTv3:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | CITI       | CITINostroCode | AUD | 2000   | CT from admin portal | 2,000.00  | 1.0000 | 2,000.00     | Custodian Safekeeping - Other Fees Account       | Nostro Account                                   |
