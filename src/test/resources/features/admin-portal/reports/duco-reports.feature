@NeedsEmpty
@Report
@Admin
#@Regression
Feature: Admin portal

  Scenario Outline: Validate DUCO admin reports on EOD Settled Security Trade Report, EOD Settled Security Positions, EOD Settled Cash Transaction, EOD Settled Cash Balances report

    Given authentication on "admin-defaultEnv" with credentials "JohnDoe" "Password11*"
    And clear data for "AP:SFL-GBP-BEL:CT:T-2"
    And clear data for "AP:SFL-GBP-BEL:CT:T-2:REC"
    And clear data for "AP:SFL-GBP-BEL:CT:T-2:PAY"
    And clear data for "AP:SFL-GBP-BEL:DVP:T-2"
    And clear data for "AP:SFL-GBP-BEL:DVP:T-2:SELL:FI"
    And clear data for "AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ"
    And clear data for "AP:SFL-GBP-BEL:FOP:T-2"
    And clear data for "AP:SFL-GBP-BEL:FOP:T-2:SELL:FI"
    And clear data for "AP:SFL-GBP-BEL:FOP:T-2:BUY:EQ"
    And clear all data within
      | Table                     |
      | GENERATED_TACTICAL_REPORT |
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode | ClientCode   | ClientMasterAccountName   | BrokerCode | TradeDate     | Isin         | SecurityType | SecurityDescription | TRADE_SUBTYPE         | ClientSubAccount               | Side | Quantity | Price   | Currency | Amount  | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NOSTRO_BANK | NOSTRO_CODE   | DEPOT_BANK | DEPOT_CODE   | NET_CONSIDERATION | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Market Trade   | AP:SFL-GBP-BEL:DVP:T-2         | SELL | 500      | 10      | GBP      | 5000    | DVP               | @date(<settDate>) | GBR               | GBP                | BNY         | BNYNostroCode | BNY        | BNYDepotCode | 5000              | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Market Trade   | AP:SFL-GBP-BEL:DVP:T-2         | BUY  | 1000     | 10      | GBP      | 10000   | DVP               | @date(<settDate>) | GBR               | GBP                | BNY         | BNYNostroCode | BNY        | BNYDepotCode | 10001             | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | Client Market Trade   | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI | SELL | 1000     | 10      | JPY      | 10000   | DVP               | @date(<settDate>) | JPN               | JPY                | BNY         | BNYNostroCode | BNY        | BNYDepotCode | 10001             | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | Client Market Trade   | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI | SELL | 1000     | 10      | JPY      | 10000   | DVP               | @date(<settDate>) | JPN               | JPY                | BNY         | BNYNostroCode | BNY        | BNYDepotCode | 10001             | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Market Trade   | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ  | BUY  | 1000     | 10      | GBP      | 10000   | DVP               | @date(<settDate>) | GBR               | GBP                | BNY         | BNYNostroCode | BNY        | BNYDepotCode | 10001             | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Market Trade   | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ  | BUY  | 1000     | 10      | GBP      | 10000   | DVP               | @date(<settDate>) | GBR               | GBP                | BNY         | BNYNostroCode | BNY        | BNYDepotCode | 10001             | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Securities Fop | AP:SFL-GBP-BEL:FOP:T-2         | SELL | 2500     | [empty] | [empty]  | [empty] | FOP               | @date(<settDate>) | GBR               | [empty]            | [empty]     | [empty]       | BNY        | BNYDepotCode | [empty]           | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Securities Fop | AP:SFL-GBP-BEL:FOP:T-2         | BUY  | 5000     | [empty] | [empty]  | [empty] | FOP               | @date(<settDate>) | GBR               | [empty]            | [empty]     | [empty]       | BNY        | BNYDepotCode | [empty]           | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | Client Securities Fop | AP:SFL-GBP-BEL:FOP:T-2:SELL:FI | SELL | 2000     | [empty] | [empty]  | [empty] | FOP               | @date(<settDate>) | FRA               | [empty]            | [empty]     | [empty]       | BNY        | BNYDepotCode | [empty]           | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | Client Securities Fop | AP:SFL-GBP-BEL:FOP:T-2:SELL:FI | SELL | 1000     | [empty] | [empty]  | [empty] | FOP               | @date(<settDate>) | FRA               | [empty]            | [empty]     | [empty]       | BNY        | BNYDepotCode | [empty]           | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Securities Fop | AP:SFL-GBP-BEL:FOP:T-2:BUY:EQ  | BUY  | 3000     | [empty] | [empty]  | [empty] | FOP               | @date(<settDate>) | USA               | [empty]            | [empty]     | [empty]       | BNY        | BNYDepotCode | [empty]           | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | Client Securities Fop | AP:SFL-GBP-BEL:FOP:T-2:BUY:EQ  | BUY  | 1000     | [empty] | [empty]  | [empty] | FOP               | @date(<settDate>) | USA               | [empty]            | [empty]     | [empty]       | BNY        | BNYDepotCode | [empty]           | @default() | @default()        |
    Then "CASH" CSV is uploaded successfully
      | FILE_TYPE | TRADE_STATUS | INTERMEDIARY_BANK | CounterpartyCode | CounterpartyBic | VALUE_DATE    | CLIENT_CODE  | CLIENT_MASTER_ACCOUNT_NAME | ClientSubAccount          | SIDE    | LEGAL_ENTITY_CODE | AMOUNT | CURRENCY | COMMENT                               | TRADE_SUBTYPE | NOSTRO_BANK | NOSTRO_CODE   | TraderId   | CustodianTradeRef |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2     | RECEIVE | SFL               | 1000   | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2     | RECEIVE | SFL               | 2000   | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2     | PAY     | SFL               | 5000   | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2     | PAY     | SFL               | 3000   | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2:REC | RECEIVE | SFL               | 1000   | GBP      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2:REC | RECEIVE | SFL               | 2000   | GBP      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2:REC | RECEIVE | SFL               | 100    | GBP      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2:PAY | PAY     | SFL               | 2000   | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2:PAY | PAY     | SFL               | 3000   | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | AP:SFL-GBP-BEL:CT:T-2:PAY | PAY     | SFL               | 200    | EUR      | Test comment CT via csv Client portal | Client Cash   | BNY         | BNYNostroCode | @default() | @default()        |

    Given navigation to "Trades" page
    When search on "Trades" by
      | Client Code  |
      | <clientCode> |

    When filter on "Trades" by
      | Name        | Operator | Value                  |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:DVP:T-2 |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |
    And select on "Trades" row 1
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    When filter on "Trades" by
      | Name        | Operator | Value                          |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    When filter on "Trades" by
      | Name        | Operator | Value                         |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    When filter on "Trades" by
      | Name        | Operator | Value                  |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:FOP:T-2 |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |
    And select on "Trades" row 1
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    When filter on "Trades" by
      | Name        | Operator | Value                          |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:FOP:T-2:SELL:FI |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    When filter on "Trades" by
      | Name        | Operator | Value                         |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:FOP:T-2:BUY:EQ |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    Given navigation to "Cash Transactions" page
    When search on "Cash Transactions" by
      | Client Code  |
      | <clientCode> |

    When filter on "Cash Transactions" by
      | Name        | Operator | Value                 |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:CT:T-2 |
    And select on "Cash Transactions" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value      |
      | Settlement Status | SETTLED    |
      | Actual Value Date | <settDate> |
    And select on "Cash Transactions" row 2
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value      |
      | Settlement Status | SETTLED    |
      | Actual Value Date | <settDate> |

    When filter on "Cash Transactions" by
      | Name        | Operator | Value                     |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:CT:T-2:REC |
    And select on "Cash Transactions" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value      |
      | Settlement Status | SETTLED    |
      | Actual Value Date | <settDate> |
    And select on "Cash Transactions" row 1
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button

    When filter on "Cash Transactions" by
      | Name        | Operator | Value                     |
      | Sub Account | Equals   | AP:SFL-GBP-BEL:CT:T-2:PAY |
    And select on "Cash Transactions" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value      |
      | Settlement Status | SETTLED    |
      | Actual Value Date | <settDate> |
    And select on "Cash Transactions" row 1
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button

    Then wait for 3000 msecs

    And execute "EVENT_EXPORT_SETTLED_SECURITY_POSITIONS_EOD" report on
      | AS_AT_DATE | @dateDR(<settDate>) |
    And execute "EVENT_EXPORT_SETTLED_SECURITY_TRADES_EOD" report on
      | TRADE_DATE | @dateDR(T) |
    And execute "EVENT_EXPORT_SETTLED_CASH_TRANSACTIONS_EOD" report on
      | AS_AT_DATE | @dateDR(T) |
    And execute "EVENT_EXPORT_SETTLED_CASH_BALANCES_EOD" report on
      | AS_AT_DATE | @dateDR(<settDate>) |

    Given navigation to "Report Browser" page

    When search on "Report Browser" by
      | Report Type                                                    | COB Date          |
      | @option(CustX - (DUCO) Daily Settled Security Position Report) | @date(<settDate>) |
    When filter on "Report Browser" by
      | Name                   | Operator | Value                                                      |
      | Report Name (Filename) | Equals   | DUCO-EODSettledSecurityPositionsRecReport-@dateDR(T-1).csv |
    And download "DUCO-EODSettledSecurityPositionsRecReport-@dateDR(T-1).csv" file
    Then snapshot dataset "DUCO-EODSettledSecurityPositionsRecReport-@dateDR(T-1).csv" file as "sett_sec_positions_v1"
    And validate snapshot "sett_sec_positions_v1" on
      | As Of Date         | Sub Account Name               | Master Account Name       | Client Code  | Position Type | Security Description | Depot Account | ISIN         | Actual Settled Quantity |
      | @dateD(<settDate>) | AP:SFL-GBP-BEL:DVP:T-2         | <clientMasterAccountName> | <clientCode> | [empty]       | AIRBUS               | BNYDepotCode  | NL0000235190 | 500                     |
      | @dateD(<settDate>) | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI | <clientMasterAccountName> | <clientCode> | [empty]       | BEGV 10/22/31        | BNYDepotCode  | BE0000352618 | -1000                   |
      | @dateD(<settDate>) | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ  | <clientMasterAccountName> | <clientCode> | [empty]       | AIRBUS               | BNYDepotCode  | NL0000235190 | 1000                    |
      | @dateD(<settDate>) | AP:SFL-GBP-BEL:FOP:T-2         | <clientMasterAccountName> | <clientCode> | [empty]       | AIRBUS               | BNYDepotCode  | NL0000235190 | 2500                    |
      | @dateD(<settDate>) | AP:SFL-GBP-BEL:FOP:T-2:SELL:FI | <clientMasterAccountName> | <clientCode> | [empty]       | BEGV 10/22/31        | BNYDepotCode  | BE0000352618 | -2000                   |
      | @dateD(<settDate>) | AP:SFL-GBP-BEL:FOP:T-2:BUY:EQ  | <clientMasterAccountName> | <clientCode> | [empty]       | AIRBUS               | BNYDepotCode  | NL0000235190 | 3000                    |

    When search on "Report Browser" by
      | Report Type                                                 | COB Date |
      | @option(CustX - (DUCO) Daily Settled Security Trade Report) | @date(T) |
    When filter on "Report Browser" by
      | Name                   | Operator | Value                                                 |
      | Report Name (Filename) | Equals   | DUCO-EODSettledSecurityTradesRecReport-@dateDR(T).csv |
    And download "DUCO-EODSettledSecurityTradesRecReport-@dateDR(T).csv" file
    Then snapshot dataset "DUCO-EODSettledSecurityTradesRecReport-@dateDR(T).csv" file as "sett_sec_trades_v1"
    And validate snapshot "sett_sec_trades_v1" on
      | Posting Date | Value Date         | Legal Entity Code | Client Master Account     | Client Code  | Client Sub-Account Name        | Cash Trans ID | Adjustment ID | Trade Sub-Type        | GL Account Name | Depot/Nostro Code | Credit or Debit | Direction | Cash or Security | ISIN         | Security Description | Currency | Cash/Security Amount |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2         | [empty]       | [empty]       | Client Market Trade   | Depot Account   | BNYDepotCode      | CREDIT          | SELL      | SECURITY         | NL0000235190 | AIRBUS               | GBP      | 500.00               |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2         | [empty]       | [empty]       | Client Market Trade   | Depot Account   | BNYDepotCode      | DEBIT           | BUY       | SECURITY         | NL0000235190 | AIRBUS               | GBP      | 1,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI | [empty]       | [empty]       | Client Market Trade   | Depot Account   | BNYDepotCode      | CREDIT          | SELL      | SECURITY         | BE0000352618 | BEGV 10/22/31        | JPY      | 1,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ  | [empty]       | [empty]       | Client Market Trade   | Depot Account   | BNYDepotCode      | DEBIT           | BUY       | SECURITY         | NL0000235190 | AIRBUS               | GBP      | 1,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:FOP:T-2         | [empty]       | [empty]       | Client Securities Fop | Depot Account   | BNYDepotCode      | CREDIT          | SELL      | SECURITY         | NL0000235190 | AIRBUS               | [empty]  | 2,500.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:FOP:T-2         | [empty]       | [empty]       | Client Securities Fop | Depot Account   | BNYDepotCode      | DEBIT           | BUY       | SECURITY         | NL0000235190 | AIRBUS               | [empty]  | 5,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:FOP:T-2:SELL:FI | [empty]       | [empty]       | Client Securities Fop | Depot Account   | BNYDepotCode      | CREDIT          | SELL      | SECURITY         | BE0000352618 | BEGV 10/22/31        | [empty]  | 2,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:FOP:T-2:BUY:EQ  | [empty]       | [empty]       | Client Securities Fop | Depot Account   | BNYDepotCode      | DEBIT           | BUY       | SECURITY         | NL0000235190 | AIRBUS               | [empty]  | 3,000.00             |

    When search on "Report Browser" by
      | Report Type                                                   | COB Date |
      | @option(CustX - (DUCO) Daily Settled Cash Transaction Report) | @date(T) |
    When filter on "Report Browser" by
      | Name                   | Operator | Value                                                   |
      | Report Name (Filename) | Equals   | DUCO-EODSettledCashTransactionsRecReport-@dateDR(T).csv |
    And download "DUCO-EODSettledCashTransactionsRecReport-@dateDR(T).csv" file
    Then snapshot dataset "DUCO-EODSettledCashTransactionsRecReport-@dateDR(T).csv" file as "sett_cash_transaction_v1"
    And validate snapshot "sett_cash_transaction_v1" on
      | Posting Date | Value Date         | Legal Entity code | Client Master Account     | Client Code  | Client Sub Account Name        | Adjustment ID | Trade Sub-Type      | GL Account Name | Depot/Nostro Code | Credit or Debit | Direction | Cash or Security | ISIN    | Security Description | Currency | Cash/Security Amount |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2         | [empty]       | Client Market Trade | Nostro Account  | BNYNostroCode     | DEBIT           | RECEIVE   | CASH             | [empty] | [empty]              | GBP      | 5,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2         | [empty]       | Client Market Trade | Nostro Account  | BNYNostroCode     | CREDIT          | PAY       | CASH             | [empty] | [empty]              | GBP      | 10,001.00            |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI | [empty]       | Client Market Trade | Nostro Account  | BNYNostroCode     | DEBIT           | RECEIVE   | CASH             | [empty] | [empty]              | JPY      | 10,001.00            |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ  | [empty]       | Client Market Trade | Nostro Account  | BNYNostroCode     | CREDIT          | PAY       | CASH             | [empty] | [empty]              | GBP      | 10,001.00            |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:CT:T-2          | [empty]       | Client Cash         | Nostro Account  | BNYNostroCode     | DEBIT           | RECEIVE   | CASH             | [empty] | [empty]              | EUR      | 2,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:CT:T-2          | [empty]       | Client Cash         | Nostro Account  | BNYNostroCode     | CREDIT          | PAY       | CASH             | [empty] | [empty]              | EUR      | 3,000.00             |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:CT:T-2:REC      | [empty]       | Client Cash         | Nostro Account  | BNYNostroCode     | DEBIT           | RECEIVE   | CASH             | [empty] | [empty]              | GBP      | 100.00               |
      | @dateD(T)    | @dateD(<settDate>) | SFL               | <clientMasterAccountName> | <clientCode> | AP:SFL-GBP-BEL:CT:T-2:PAY      | [empty]       | Client Cash         | Nostro Account  | BNYNostroCode     | CREDIT          | PAY       | CASH             | [empty] | [empty]              | EUR      | 200.00               |

    When search on "Report Browser" by
      | Report Type                                               | COB Date          |
      | @option(CustX - (DUCO) Daily Settled Cash Balance Report) | @date(<settDate>) |
    When filter on "Report Browser" by
      | Name                   | Operator | Value                                                 |
      | Report Name (Filename) | Equals   | DUCO-EODSettledCashBalancesRecReport-@dateDR(T-1).csv |
    And download "DUCO-EODSettledCashBalancesRecReport-@dateDR(T-1).csv" file
    Then snapshot dataset "DUCO-EODSettledCashBalancesRecReport-@dateDR(T-1).csv" file as "sett_cash_balance_v1"
    And validate snapshot "sett_cash_balance_v1" on
      | As Of Date         | Nostro Account | Account Code                   | Master Account Name       | Client Code  | Actual Settled Amount | Local Currency |
      | @dateD(<settDate>) | BNYNostroCode  | AP:SFL-GBP-BEL:DVP:T-2         | <clientMasterAccountName> | <clientCode> | -5001.00              | GBP            |
      | @dateD(<settDate>) | BNYNostroCode  | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI | <clientMasterAccountName> | <clientCode> | 10001.00              | JPY            |
      | @dateD(<settDate>) | BNYNostroCode  | AP:SFL-GBP-BEL:DVP:T-2:BUY:EQ  | <clientMasterAccountName> | <clientCode> | -10001.00             | GBP            |

    Examples:
      | date | settDate | clientCode        | clientMasterAccountName  |
      | T-2  | T-1      | Admin_Duco_Report | Admin_Portal_Duco_Report |
