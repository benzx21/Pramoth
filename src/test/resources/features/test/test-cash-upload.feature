Feature: Local test

  Scenario Outline:

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
      | @date(T)     | @date(<valueDate>)     | [empty]           | UNSETTLED         | NEW                | <clientCode> | <clientMasterAccountName> | <subAccount> | <nostroCode> | <nostroBank> | <legalEntityCode>           | <tradeSubType> | <direction> | @abs(<amt>) | <ccy>    | 0.00                | @abs(<amt*rate>)                 | <baseCcy>          | <fxRate> | A123465798        | A1234567891      | <comment> | BAML              | ADMIN_CSV_UPLOAD |
    And set param "LAST_CUSTX_CASH_TRANS_ID" from dataset "cash_transaction_v1" with "CustX Cash Trans ID" row 0

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

    Examples:
      | env        | username | password    | valueDate | tradeSubType | subAccount                        | baseCcy | direction | legalEntityCode | clientCode | clientMasterAccountName | nostroBank | nostroCode        | ccy | amount | comment              | amt       | fxRate | amt*rate | amt*ratePref | deb_amt   | deb_amt*rateT | deb_amt*ratePrefT | cre_amt | cre_amt*rateT | cre_amt*ratePrefT | cre_cash_unSett_gl             | deb_cash_unSett_gl          | cre_cash_sett_gl | deb_cash_sett_gl               |
      | admin-dev5 | JohnDoe  | Password11* | T         | Client Cash  | JPM:SFL-AUD-BEL:CC:PAY:UNSETTv1:T | AUD     | PAY       | SFL             | JPM        | JPM                     | BNPP       | CCPAYUNSETTv1-NCT | GBP | 1000   | CT from admin portal | -1,000.00 | 0.8200 | -820.00  | -820.00      | -1,000.00 | -820.00       | -820.00           | 0.00    | 0.00          | 0.00              | Free Cash 'In Transit' Account | Custody Client Cash Account | Nostro Account   | Free Cash 'In Transit' Account |
