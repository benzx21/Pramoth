@Admin
#@Regression #currently failing due to TQ-7745
Feature: Admin portal

  Scenario Outline: Validate single cash trough v1...v4 in Cash Transactions and Ledger Postings screens

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
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v2"
    And validate snapshot "ledger_posting_v1" against "ledger_posting_v2" on
      | Ops | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name    | Cash/Security Amount | Currency |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | +   | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <cre_cash_sett_gl> | @abs(<amt>)          | <ccy>    |
      | +   | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <deb_cash_sett_gl> | @abs(<amt>)          | <ccy>    |

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
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v3"
    And validate snapshot "ledger_posting_v2" against "ledger_posting_v3" on
      | Ops | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name    | Cash/Security Amount | Currency |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same              | @same                | @same    |
      | +   | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <deb_cash_sett_gl> | @abs(<amt>)          | <ccy>    |
      | +   | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <cre_cash_sett_gl> | @abs(<amt>)          | <ccy>    |

    Given navigation to "Cash Transactions" page
    When search on "Cash Transactions" by
      | CustX Cash Trans ID                |
      | @context(LAST_CUSTX_CASH_TRANS_ID) |
    And select on "Cash Transactions" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v4"
    And validate snapshot "cash_transaction_v3" against "cash_transaction_v4" on
      | Ops | Booking Date | Contractual Value Date | Actual Value Date | Settlement Status | Transaction Status | Client code | Master account | Sub Account | Nostro Code | Nostro Bank | Legal Entity Code (Custody) | Trade Sub-Type | Direction | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate | Counterparty Code | Counterparty BIC | Comment | Intermediary Bank | Source |
      | ~   | @same        | @same                  | @same             | @same             | CANCELLED          | @same       | @same          | @same       | @same       | @same       | @same                       | @same          | @same     | @same       | @same    | @same               | @same                            | @same              | @same   | @same             | @same            | @same   | @same             | @same  |

    Given navigation to "Ledger Postings" page
    When filter on "Ledger Postings" by
      | Name          | Operator | Value                              |
      | Cash Trans ID | Equals   | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v4"
    And validate snapshot "ledger_posting_v3" against "ledger_posting_v4" on
      | Ops | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name      | Cash/Security Amount | Currency |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | =   | @same              | @same          | @same           | @same            | @same       | @same                | @same                | @same    |
      | +   | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <deb_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |
      | +   | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <cre_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |

    Examples:
      ##############  CONFIG  ############## ***************************************************************************************************************  TRADE  ************************************************************************************************************** # Formatted(Amounts) # * Aggregations(Expected results) * ###################################     GL ACCOUNT NAMES     ##################################
      | env              | username | password    | valueDate | tradeSubType                  | subAccount                           | baseCcy | direction | legalEntityCode | clientCode | clientMasterAccountName | nostroBank | nostroCode    | ccy | amount | comment              | amt       | fxRate | amt*ratePref | cre_cash_unSett_gl                            | deb_cash_unSett_gl                               | cre_cash_sett_gl                                 | deb_cash_sett_gl                              |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Dividend    | JPM:SFL-AUD-BEL:CCDDIV:PAY:SETTv2:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | GBP | 2000   | CT from admin portal | -2,000.00 | 0.8200 | -1,640.00    | Dividends Payable Account                     | Custody Client Cash Account                      | Nostro Account                                   | Dividends Payable Account                     |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Dividend    | JPM:SFL-AUD-BEL:CCDDIV:REC:SETTv2:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | GBP | 2000   | CT from admin portal | 2,000.00  | 0.8200 | 1,640.00     | Custody Client Cash Account                   | Dividends Receivable Account                     | Dividends Receivable Account                     | Nostro Account                                |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Dividend    | JPM:SFL-JPY-GBR:CCCLDIV:PAY:CANCv4:T | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Dividends Payable Account                     | Custody Client Cash Account                      | Nostro Account                                   | Dividends Payable Account                     |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Dividend    | JPM:SFL-JPY-GBR:CCCLDIV:REC:CANCv4:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Dividends Receivable Account                     | Dividends Receivable Account                     | Nostro Account                                |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Corp Action | JPM:SFL-JPY-GBR:CCCLCA:PAY:CANCv4:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Corporate Action - Other Cash Payable Account | Custody Client Cash Account                      | Nostro Account                                   | Corporate Action - Other Cash Payable Account |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Corp Action | JPM:SFL-JPY-GBR:CCCLCA:REC:CANCv4:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Corporate Action - Other Cash Receivable Account | Corporate Action - Other Cash Receivable Account | Nostro Account                                |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Coupon      | JPM:SFL-JPY-GBR:CCDCPN:PAY:CANCv4:T  | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Coupons Payable Account                       | Custody Client Cash Account                      | Nostro Account                                   | Coupons Payable Account                       |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Coupon      | JPM:SFL-JPY-GBR:CCDCPN:REC:CANCv4:T  | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Coupons Receivable Account                       | Coupons Receivable Account                       | Nostro Account                                |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Coupon      | JPM:SFL-EUR-GBR:CCCLCPN:PAY:CANCv4:T | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | EUR | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Coupons Payable Account                       | Custody Client Cash Account                      | Nostro Account                                   | Coupons Payable Account                       |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Claim Coupon      | JPM:SFL-EUR-GBR:CCCLCPN:REC:CANCv4:T | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | EUR | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Coupons Receivable Account                       | Coupons Receivable Account                       | Nostro Account                                |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Corp Action | JPM:SFL-JPY-GBR:CCDCA:PAY:CANCv4:T   | AUD     | PAY       | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | -2,000.00 | 1.7200 | -3,440.00    | Corporate Action - Other Cash Payable Account | Custody Client Cash Account                      | Nostro Account                                   | Corporate Action - Other Cash Payable Account |
      | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash Depot Corp Action | JPM:SFL-JPY-GBR:CCDCA:REC:CANCv4:T   | AUD     | RECEIVE   | SFL             | JPM        | JPM                     | BNY        | BNYNostroCode | JPY | 2000   | CT from admin portal | 2,000.00  | 1.7200 | 3,440.00     | Custody Client Cash Account                   | Corporate Action - Other Cash Receivable Account | Corporate Action - Other Cash Receivable Account | Nostro Account                                |
