@Client
#@Regression # needs to be fixed when we get requirement for cash trans via client portal, till then commenting
Feature: Client portal

  Scenario Outline: CSV - Validate single cash RECEIVE trough v1...v2 cancel in Cash Transactions, Cash Positions and Ledger Postings screens (Super Client)

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv

    Given navigation to "CSV Loader" page
    Then "CASH" CSV is uploaded successfully
      | FILE_TYPE | TRADE_STATUS | INTERMEDIARY_BANK | CounterpartyAccountNumber | COUNTERPARTY_BIC | CounterpartyCode | VALUE_DATE         | CLIENT_CODE  | CLIENT_MASTER_ACCOUNT_NAME | ClientSubAccount | SIDE        | LEGAL_ENTITY_CODE | AMOUNT   | CURRENCY | COMMENT                               | TRADE_SUBTYPE  | NOSTRO_BANK  | TraderId   | CustodianTradeRef |
      | CASH      | NEW          | BAML              | 123456789                 | CPTYBIC1234      | CPTYCode         | @date(<valueDate>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | <direction> | <legalEntityCode> | <amount> | <ccy>    | Test comment CT via csv Client portal | <tradeSubType> | <nostroBank> | @default() | @default()        |

    Given navigation to "Cash Transactions" page
    When filter on "Cash Transactions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Transactions" as "c-cash_transaction_v1"
    And validate snapshot "c-cash_transaction_v1" on
      | Trade Sub-Type | Booking Date | Actual Value Date | Contractual Value Date | Currency | Settled Cash Amount | Preferred Currency | Client code  | Master account            | Sub Account  | Counterparty Account Number | Counterparty BIC | Counterparty Code | Transaction Status | Direction   | Legal Entity Code (Custody) | Cash Amount | Cash Amount (Preferred Currency) | Nostro Bank  | Nostro Code  | Settlement Status | Source            | Comment                               |
      | <tradeSubType> | @date(T)     | [empty]           | @date(<valueDate>)     | <ccy>    | 0.00                | <baseCcy>          | <clientCode> | <clientMasterAccountName> | <subAccount> | 123456789                   | CPTYBIC1234      | CPTYCode          | NEW                | <direction> | <legalEntityCode>           | <amt>       | <amt*ratePref>                   | <nostroBank> | <nostroCode> | UNSETTLED         | CLIENT_CSV_UPLOAD | Test comment CT via csv Client portal |
    And set param "LAST_CUSTX_CASH_TRANS_ID" from dataset "c-cash_transaction_v1" with "CustX Cash Trans ID" row 0

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date           |
      | @option(ALL) | @date(<valueDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v1"
    And validate snapshot "c-cash_position_v1" on
      | COB Date           | Client Code  | Master Acc Name           | Sub Account  | Perspective | Ccy       | Settled Balance | Pending Credits     | Pending Debits      | Total Cash (Settled + Pending) |
      | @date(<valueDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Local       | <ccy>     | 0.00            | <cre_amt>           | <deb_amt>           | <amt>                          |
      | @date(<valueDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Pref        | <baseCcy> | 0.00            | <cre_amt*ratePrefT> | <deb_amt*ratePrefT> | <amt*ratePref>                 |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Cash Transactions" page
    When filter on "Cash Transactions" by
      | Name                | Operator | Value                              |
      | Custodian Trade Ref | Equals   | @context(LAST_CUSTODIAN_TRADE_REF) |
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v1"
    And validate snapshot "cash_transaction_v1" on
      | Booking Date | Contractual Value Date | Actual Value Date | Settlement Status | Transaction Status | Client code  | Master account            | Sub Account  | Nostro Code  | Nostro Bank  | Legal Entity Code (Custody) | Trade Sub-Type | Direction   | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate  | Counterparty Code | Counterparty BIC | Comment                               | Intermediary Bank | Source            |
      | @date(T)     | @date(<valueDate>)     | [empty]           | UNSETTLED         | NEW                | <clientCode> | <clientMasterAccountName> | <subAccount> | <nostroCode> | <nostroBank> | <legalEntityCode>           | <tradeSubType> | <direction> | @abs(<amt>) | <ccy>    | 0.00                | @abs(<amt*ratePref>)             | <baseCcy>          | <fxRate> | CPTYCode          | CPTYBIC1234      | Test comment CT via csv Client portal | BAML              | CLIENT_CSV_UPLOAD |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date           |
      | @option(~Any~) | @date(<valueDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v1"
    And validate snapshot "cash_position_v1" on
      | Perspective | Ccy       | Nostro       | Settled Balance | Pending Credits     | Pending Debits      |
      | Local       | <ccy>     | [empty]      | 0.00            | <cre_amt>           | <deb_amt>           |
      | Local       | <ccy>     | <nostroCode> | 0.00            | <cre_amt>           | <deb_amt>           |
      | Pref        | <baseCcy> | [empty]      | 0.00            | <cre_amt*ratePrefT> | <deb_amt*ratePrefT> |
      | Pref        | <baseCcy> | <nostroCode> | 0.00            | <cre_amt*ratePrefT> | <deb_amt*ratePrefT> |
      | Entity      | USD       | [empty]      | 0.00            | <cre_amt*rateT>     | <deb_amt*rateT>     |
      | Entity      | USD       | <nostroCode> | 0.00            | <cre_amt*rateT>     | <deb_amt*rateT>     |

    Given navigation to "Ledger Postings" page
    When filter on "Ledger Postings" by
      | Name          | Operator | Value                              |
      | Cash Trans ID | Equals   | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v1"
    And validate snapshot "ledger_posting_v1" on
      | Value Date         | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name      | Cash/Security Amount | Currency |
      | @date(<valueDate>) | <tradeSubType> | CREDIT          | CASH             | <direction> | <cre_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |
      | @date(<valueDate>) | <tradeSubType> | DEBIT           | CASH             | <direction> | <deb_cash_unSett_gl> | @abs(<amt>)          | <ccy>    |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Cash Transactions" page
    When filter on "Cash Transactions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    And select on "Cash Transactions" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Cash Transactions" as "c-cash_transaction_v2"
    And validate snapshot "c-cash_transaction_v1" against "c-cash_transaction_v2" on
      | Ops | Trade Sub-Type | Booking Date | Actual Value Date | Contractual Value Date | Currency | Settled Cash Amount | Preferred Currency | Client code | Master account | Sub Account | Counterparty Account Number | Counterparty BIC | Counterparty Code | Transaction Status | Direction | Legal Entity Code (Custody) | Cash Amount | Cash Amount (Preferred Currency) | Nostro Bank | Nostro Code | Settlement Status | Source | Comment |
      | ~   | @same          | @same        | @same             | @same                  | @same    | @same               | @same              | @same       | @same          | @same       | @same                       | @same            | @same             | CANCELLED          | @same     | @same                       | @same       | @same                            | @same       | @same       | @same             | @same  | @same   |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date           |
      | @option(ALL) | @date(<valueDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v2"
    And validate snapshot "c-cash_position_v1" against "c-cash_position_v2" on
      | Ops | COB Date | Client Code | Master Acc Name | Sub Account | Perspective | Ccy   | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | @same           | 0.00            | 0.00           | 0.00                           |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | @same           | 0.00            | 0.00           | 0.00                           |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Cash Transactions" page
    When search on "Cash Transactions" by
      | CustX Cash Trans ID                |
      | @context(LAST_CUSTX_CASH_TRANS_ID) |
    Then snapshot dataset "Cash Transactions" as "cash_transaction_v2"
    And validate snapshot "cash_transaction_v1" against "cash_transaction_v2" on
      | Ops | Booking Date | Contractual Value Date | Actual Value Date | Settlement Status | Transaction Status | Client code | Master account | Sub Account | Nostro Code | Nostro Bank | Legal Entity Code (Custody) | Trade Sub-Type | Direction | Cash Amount | Currency | Settled Cash Amount | Cash Amount (Preferred Currency) | Preferred Currency | FX Rate | Counterparty Code | Counterparty BIC | Comment | Intermediary Bank | Source |
      | ~   | @same        | @same                  | @same             | @same             | CANCELLED          | @same       | @same          | @same       | @same       | @same       | @same                       | @same          | @same     | @same       | @same    | @same               | @same                            | @same              | @same   | @same             | @same            | @same   | @same             | @same  |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date           |
      | @option(~Any~) | @date(<valueDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v2"
    And validate snapshot "cash_position_v1" against "cash_position_v2" on
      | Ops | Perspective | Ccy   | Nostro | Settled Balance | Pending Credits | Pending Debits |
      | ~   | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |

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
      | c-env             | c-username       | c-password | env              | username | password    | valueDate | tradeSubType | subAccount                      | baseCcy | direction | legalEntityCode | clientCode    | clientMasterAccountName        | nostroBank | nostroCode    | ccy | amount | amt      | fxRate | amt*ratePref | deb_amt | deb_amt*rateT | deb_amt*ratePrefT | cre_amt  | cre_amt*rateT | cre_amt*ratePrefT | cre_cash_unSett_gl          | deb_cash_unSett_gl             |
      | client-defaultEnv | JohnDoeCPCTSuper | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T         | Client Cash  | CP:Csv:SFL-EUR-GBR:REC:CANCv2:T | EUR     | RECEIVE   | SFL             | CP_CT_CC_Auto | CP_Auto_Testing_CT_SuperClient | BNY        | BNYNostroCode | CHF | 1000   | 1,000.00 | 3.6200 | 3,620.00     | 0.00    | 0.00          | 0.00              | 1,000.00 | 3,620.00      | 3,620.00          | Custody Client Cash Account | Free Cash 'In Transit' Account |
