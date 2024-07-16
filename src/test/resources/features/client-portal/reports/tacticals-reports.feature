@Report
@Client
@Regression
Feature: Client portal

  Scenario Outline: Validate Tactical client reports on Daily Cash Positions

    Given authentication on "client-defaultEnv" with credentials "JohnDoeCPReportDVP" "custx11*"
    And clear data for "CP:csv:SFL-AUD-BEL:DVP:T-2"
    And clear data for "CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ"
    And clear data for "CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI"
    And clear data for "CP:csv:SFL-AUD-BEL:CT:T-2:PAY"
    And clear data for "CP:Mod:SFL-AUD-BEL:CT:T-2"
    And clear data for "CP:Mod:SFL-AUD-BEL:CT:T-2:REC"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SettlementPlaceCode | SETTLEMENT_PLACE_NAME | CounterpartyAccountNumber | COUNTERPARTY_BIC | CounterpartyCode | CounterpartyLocalCode | CustodianLocalCodeType | CounterpartyLocalCustodianAccountNumber | CounterpartyLocalCustodianBic | CounterpartyName | VenueId | ExchangeId | IntermediaryBank  | Comment                  | LegalEntityCode | ClientCode   | ClientMasterAccountName   | BrokerCode | TradeDate     | Isin         | SecurityType | SecurityDescription | ClientSubAccount                  | Side | Quantity | Price | Currency | Amount | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NET_CONSIDERATION | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | CP:csv:SFL-AUD-BEL:DVP:T-2        | SELL | 500      | 10    | JPY      | 5000   | DVP               | @date(<settDate>) | JPN               | JPY                | 5000              | @default() | @default()        |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | CP:csv:SFL-AUD-BEL:DVP:T-2        | BUY  | 500      | 10    | JPY      | 5000   | DVP               | @date(<settDate>) | JPN               | JPY                | 5000              | @default() | @default()        |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | CP:csv:SFL-AUD-BEL:DVP:T-2        | SELL | 500      | 10    | JPY      | 5000   | DVP               | @date(<settDate>) | JPN               | JPY                | 5000              | @default() | @default()        |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | CP:csv:SFL-AUD-BEL:DVP:T-2        | BUY  | 500      | 10    | JPY      | 5000   | DVP               | @date(<settDate>) | JPN               | JPY                | 5000              | @default() | @default()        |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ | BUY  | 500      | 10    | GBP      | 5000   | DVP               | @date(<settDate>) | GBR               | GBP                | 5000              | @default() | @default()        |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | SFL             | <clientCode> | <clientMasterAccountName> | SFL        | @date(<date>) | NL0000235190 | EQUITY       | AIRBUS              | CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ | BUY  | 500      | 10    | GBP      | 5000   | DVP               | @date(<settDate>) | GBR               | GBP                | 5000              | @default() | @default()        |
#    Then "CASH" CSV is uploaded successfully
#      | FILE_TYPE | TRADE_STATUS | INTERMEDIARY_BANK | CounterpartyAccountNumber | COUNTERPARTY_BIC | CounterpartyCode | VALUE_DATE    | CLIENT_CODE  | CLIENT_MASTER_ACCOUNT_NAME | ClientSubAccount              | SIDE | LEGAL_ENTITY_CODE | AMOUNT | CURRENCY | COMMENT                               | TRADE_SUBTYPE | NOSTRO_BANK | NOSTRO_CODE    | TraderId   | CustodianTradeRef |
#      | CASH      | NEW          | BAML              | 123456789                 | CPTYBIC1234      | CPTYCode         | @date(<date>) | <clientCode> | <clientMasterAccountName>  | CP:csv:SFL-AUD-BEL:CT:T-2:PAY | PAY  | SFL               | 1000   | EUR      | Test comment CT via csv Client portal | Client Cash   | CITI        | CITINostroCode | @default() | @default()        |
#      | CASH      | NEW          | BAML              | 123456789                 | CPTYBIC1234      | CPTYCode         | @date(<date>) | <clientCode> | <clientMasterAccountName>  | CP:csv:SFL-AUD-BEL:CT:T-2:PAY | PAY  | SFL               | 1000   | EUR      | Test comment CT via csv Client portal | Client Cash   | CITI        | CITINostroCode | @default() | @default()        |

    Given navigation to "Trades" page
    And click "Pending Trades" "tab"
    And click "Add Trade" "button"
    And submit dialog "Create Trade" using "Create" button with inputs
      | Name                                | Value                              |
      | Custom Reference                    | @default()                         |
      | Master Account Name: *              | <clientMasterAccountName>          |
      | Sub Account: *                      | CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI |
      | ISIN: *                             | BE0000352618                       |
      | Direction: *                        | SELL                               |
      | Trade Quantity: *                   | 500                                |
      | Price: *                            | 10                                 |
      | Trade Date: *                       | @date(<date>)                      |
      | Contractual Sett Date: *            | @date(<settDate>)                  |
      | Settlement Currency: *              | GBP                                |
      | Settlement Country                  | GBR                                |
      | Place of Settlement Code: *         | ACLRAU2S                           |
      | Gross Consideration: *              | 5000                               |
      | Net Consideration: *                | 5000                               |
      | Execution Venue ID                  | VenueID                            |
      | Execution Exchange ID               | XEQT                               |
      | Intermediary Bank                   | EUROCLEAR BELGIUM                  |
      | Counterparty Code                   | CPTYCode                           |
      | Counterparty Name                   | CPTYName                           |
      | Counterparty BIC: *                 | CPTYBIC1234                        |
      | Counterparty Local Custodian BIC: * | CPTYLocBIC1                        |
      | Counterparty Account Number: *      | 123456789                          |
      | Counterparty Local Code             | CPTYLocalCode                      |
      | Custodian Local Code Type           | CustLocalCodeType                  |
    And click "Add Trade" "button"
    And submit dialog "Create Trade" using "Create" button with inputs
      | Name                                | Value                              |
      | Custom Reference                    | @default()                         |
      | Master Account Name: *              | <clientMasterAccountName>          |
      | Sub Account: *                      | CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI |
      | ISIN: *                             | BE0000352618                       |
      | Direction: *                        | SELL                               |
      | Trade Quantity: *                   | 500                                |
      | Price: *                            | 10                                 |
      | Trade Date: *                       | @date(<date>)                      |
      | Contractual Sett Date: *            | @date(<settDate>)                  |
      | Settlement Currency: *              | GBP                                |
      | Settlement Country                  | GBR                                |
      | Place of Settlement Code: *         | ACLRAU2S                           |
      | Gross Consideration: *              | 5000                               |
      | Net Consideration: *                | 5000                               |
      | Execution Venue ID                  | VenueID                            |
      | Execution Exchange ID               | XEQT                               |
      | Intermediary Bank                   | EUROCLEAR BELGIUM                  |
      | Counterparty Code                   | CPTYCode                           |
      | Counterparty Name                   | CPTYName                           |
      | Counterparty BIC: *                 | CPTYBIC1234                        |
      | Counterparty Local Custodian BIC: * | CPTYLocBIC1                        |
      | Counterparty Account Number: *      | 123456789                          |
      | Counterparty Local Code             | CPTYLocalCode                      |
      | Custodian Local Code Type           | CustLocalCodeType                  |

#    Given navigation to "Cash Transactions" page
#    And click "Pending Cash" "tab"
#    And click "Add Cash Entry" "button"
#    And submit dialog "Create Cash Entry" using "Create" button with inputs
#      | Name                           | Value                     |
#      | Custom Reference               | @default()                |
#      | Master Account Name: *         | <clientMasterAccountName> |
#      | Sub Account: *                 | CP:Mod:SFL-AUD-BEL:CT:T-2 |
#      | Direction: *                   | RECEIVE                   |
#      | Net Consideration: *           | 5000                      |
#      | Currency: *                    | GBP                       |
#      | Contractual Value Date: *      | @date(<settDate>)         |
#      | Nostro Bank: *                 | CITI                      |
#      | Counterparty Code              | CPTYCode                  |
#      | Counterparty BIC: *            | CPTYBIC1234               |
#      | Counterparty Account Number: * | 123456789                 |
#    And click "Add Cash Entry" "button"
#    And submit dialog "Create Cash Entry" using "Create" button with inputs
#      | Name                           | Value                     |
#      | Custom Reference               | @default()                |
#      | Master Account Name: *         | <clientMasterAccountName> |
#      | Sub Account: *                 | CP:Mod:SFL-AUD-BEL:CT:T-2 |
#      | Direction: *                   | RECEIVE                   |
#      | Net Consideration: *           | 5000                      |
#      | Currency: *                    | GBP                       |
#      | Contractual Value Date: *      | @date(<settDate>)         |
#      | Nostro Bank: *                 | CITI                      |
#      | Counterparty Code              | CPTYCode                  |
#      | Counterparty BIC: *            | CPTYBIC1234               |
#      | Counterparty Account Number: * | 123456789                 |
#    And click "Add Cash Entry" "button"
#    And submit dialog "Create Cash Entry" using "Create" button with inputs
#      | Name                           | Value                     |
#      | Custom Reference               | @default()                |
#      | Master Account Name: *         | <clientMasterAccountName> |
#      | Sub Account: *                 | CP:Mod:SFL-AUD-BEL:CT:T-2 |
#      | Direction: *                   | PAY                       |
#      | Net Consideration: *           | 5000                      |
#      | Currency: *                    | GBP                       |
#      | Contractual Value Date: *      | @date(<settDate>)         |
#      | Nostro Bank: *                 | CITI                      |
#      | Counterparty Code              | CPTYCode                  |
#      | Counterparty BIC: *            | CPTYBIC1234               |
#      | Counterparty Account Number: * | 123456789                 |
#    And click "Add Cash Entry" "button"
#    And submit dialog "Create Cash Entry" using "Create" button with inputs
#      | Name                           | Value                     |
#      | Custom Reference               | @default()                |
#      | Master Account Name: *         | <clientMasterAccountName> |
#      | Sub Account: *                 | CP:Mod:SFL-AUD-BEL:CT:T-2 |
#      | Direction: *                   | PAY                       |
#      | Net Consideration: *           | 5000                      |
#      | Currency: *                    | GBP                       |
#      | Contractual Value Date: *      | @date(<settDate>)         |
#      | Nostro Bank: *                 | CITI                      |
#      | Counterparty Code              | CPTYCode                  |
#      | Counterparty BIC: *            | CPTYBIC1234               |
#      | Counterparty Account Number: * | 123456789                 |
#    And click "Add Cash Entry" "button"
#    And submit dialog "Create Cash Entry" using "Create" button with inputs
#      | Name                           | Value                         |
#      | Custom Reference               | @default()                    |
#      | Master Account Name: *         | <clientMasterAccountName>     |
#      | Sub Account: *                 | CP:Mod:SFL-AUD-BEL:CT:T-2:REC |
#      | Direction: *                   | RECEIVE                       |
#      | Net Consideration: *           | 5000                          |
#      | Currency: *                    | JPY                           |
#      | Contractual Value Date: *      | @date(<settDate>)             |
#      | Nostro Bank: *                 | CITI                          |
#      | Counterparty Code              | CPTYCode                      |
#      | Counterparty BIC: *            | CPTYBIC1234                   |
#      | Counterparty Account Number: * | 123456789                     |
#    And click "Add Cash Entry" "button"
#    And submit dialog "Create Cash Entry" using "Create" button with inputs
#      | Name                           | Value                         |
#      | Custom Reference               | @default()                    |
#      | Master Account Name: *         | <clientMasterAccountName>     |
#      | Sub Account: *                 | CP:Mod:SFL-AUD-BEL:CT:T-2:REC |
#      | Direction: *                   | RECEIVE                       |
#      | Net Consideration: *           | 5000                          |
#      | Currency: *                    | JPY                           |
#      | Contractual Value Date: *      | @date(<settDate>)             |
#      | Nostro Bank: *                 | CITI                          |
#      | Counterparty Code              | CPTYCode                      |
#      | Counterparty BIC: *            | CPTYBIC1234                   |
#      | Counterparty Account Number: * | 123456789                     |

    Given authentication on "admin-defaultEnv" with credentials "JohnDoe" "Password11*"

    Given navigation to "Trades" page
    When search on "Trades" by
      | Client Code  |
      | <clientCode> |

    When filter on "Trades" by
      | Name        | Operator | Value                      |
      | Sub Account | Equals   | CP:csv:SFL-AUD-BEL:DVP:T-2 |
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
      | Name        | Operator | Value                              |
      | Sub Account | Equals   | CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

    When filter on "Trades" by
      | Name        | Operator | Value                             |
      | Sub Account | Equals   | CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |

#    Given navigation to "Cash Transactions" page
#
#    And click "Pending Cash" "tab"
#
#    When filter on "Pending Cash" by
#      | Name        | Operator | Value                         |
#      | Sub Account | Equals   | CP:csv:SFL-AUD-BEL:CT:T-2:PAY |
#    And click button "Approve" on "Pending Cash" 0 row
#
#    When filter on "Pending Cash" by
#      | Name        | Operator | Value                     |
#      | Sub Account | Equals   | CP:Mod:SFL-AUD-BEL:CT:T-2 |
#    And click button "Approve" on "Pending Cash" 0 row
#
#    And click "Cash Transactions" "tab"
#    When search on "Cash Transactions" by
#      | Client Code  |
#      | <clientCode> |
#
#    When filter on "Cash Transactions" by
#      | Name        | Operator | Value                         |
#      | Sub Account | Equals   | CP:csv:SFL-AUD-BEL:CT:T-2:PAY |
#    And select on "Cash Transactions" row 0
#    And click "Manually Settle" "button"
#    And submit dialog "Manual Settlement" using "Save" button with inputs
#      | Name              | Value      |
#      | Settlement Status | SETTLED    |
#      | Actual Value Date | <settDate> |
#
#    When filter on "Cash Transactions" by
#      | Name        | Operator | Value                     |
#      | Sub Account | Equals   | CP:Mod:SFL-AUD-BEL:CT:T-2 |
#    And select on "Cash Transactions" row 0
#    And click "Manually Settle" "button"
#    And submit dialog "Manual Settlement" using "Save" button with inputs
#      | Name              | Value      |
#      | Settlement Status | SETTLED    |
#      | Actual Value Date | <settDate> |
#    And select on "Cash Transactions" row 1
#    And click "Manually Settle" "button"
#    And submit dialog "Manual Settlement" using "Save" button with inputs
#      | Name              | Value      |
#      | Settlement Status | SETTLED    |
#      | Actual Value Date | <settDate> |
#
#    When filter on "Cash Transactions" by
#      | Name        | Operator | Value                         |
#      | Sub Account | Equals   | CP:Mod:SFL-AUD-BEL:CT:T-2:REC |
#    And select on "Cash Transactions" row 0
#    And click "Manually Settle" "button"
#    And submit dialog "Manual Settlement" using "Save" button with inputs
#      | Name              | Value      |
#      | Settlement Status | SETTLED    |
#      | Actual Value Date | <settDate> |

    And execute "EVENT_EXPORT_CASH_POSITIONS_TACTICAL_REPORT" report on
      | AS_AT_DATE | @dateDR(<settDate>) |

    Given authentication on "client-defaultEnv" with credentials "JohnDoeCPReportDVP" "custx11*"

    Given navigation to "Reports" page
    And click "Client Statements" "tab"

    When filter on "Client Statements" by
      | Name | Operator | Value                                                           |
      | Name | Equals   | DailyCashPositions_CP:csv:SFL-AUD-BEL:DVP:T-2_@dateDRS(T-1).csv |
    And select on "Client Statements" row 0
    And download "DailyCashPositions_CSV-DVP-T-2_@dateDRS(T-1).csv" file
    Then snapshot dataset "DailyCashPositions_CSV-DVP-T-2_@dateDRS(T-1).csv" file as "sett_cash_pos_CSV-DVP-T-2_v1"
    And validate snapshot "sett_cash_pos_CSV-DVP-T-2_v1" on
      | COB Date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Client Code  | Master Acc Name           | Sub Account                | Perspective | Ccy     | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | @date(<settDate>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | <clientCode> | <clientMasterAccountName> | CP:csv:SFL-AUD-BEL:DVP:T-2 | Local       | JPY     | .00             | 5,000.00        | -5,000.00      | .00                            |
      | @date(<settDate>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | <clientCode> | <clientMasterAccountName> | CP:csv:SFL-AUD-BEL:DVP:T-2 | Pref        | AUD     | .00             | 8,650.00        | -8,650.00      | .00                            |
      | The values or prices attributes to the investments in this report are provided to you for information and internal purposes only and are not intended for use for any other purpose, including financial disclosure, marketing, reporting (regulatory or otherwise) or the determination of net asset value or for use by any third party. StoneX Financial Ltd is authorised and regulated by the Financial Conduct Authority [FRN: 446717]. Registered in England & Wales with Company Number 5616586 | [empty]      | [empty]                   | [empty]                    | [empty]     | [empty] | [empty]         | [empty]         | [empty]        | [empty]                        |

    When filter on "Client Statements" by
      | Name | Operator | Value                                                                  |
      | Name | Equals   | DailyCashPositions_CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ_@dateDRS(T-1).csv |
    And select on "Client Statements" row 0
    And download "DailyCashPositions_CSV-DVP-T-2-BUY-EQ_@dateDRS(T-1).csv" file
    Then snapshot dataset "DailyCashPositions_CSV-DVP-T-2-BUY-EQ_@dateDRS(T-1).csv" file as "sett_cash_pos_CSV-DVP-T-2-BUY-EQ_v1"
    And validate snapshot "sett_cash_pos_CSV-DVP-T-2-BUY-EQ_v1" on
      | COB Date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Client Code  | Master Acc Name           | Sub Account                       | Perspective | Ccy     | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | @date(<settDate>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | <clientCode> | <clientMasterAccountName> | CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ | Local       | GBP     | -5,000.00       | .00             | -5,000.00      | -10,000.00                     |
      | @date(<settDate>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | <clientCode> | <clientMasterAccountName> | CP:csv:SFL-AUD-BEL:DVP:T-2:BUY:EQ | Pref        | AUD     | -4,150.00       | .00             | -4,150.00      | -8,300.00                      |
      | The values or prices attributes to the investments in this report are provided to you for information and internal purposes only and are not intended for use for any other purpose, including financial disclosure, marketing, reporting (regulatory or otherwise) or the determination of net asset value or for use by any third party. StoneX Financial Ltd is authorised and regulated by the Financial Conduct Authority [FRN: 446717]. Registered in England & Wales with Company Number 5616586 | [empty]      | [empty]                   | [empty]                           | [empty]     | [empty] | [empty]         | [empty]         | [empty]        | [empty]                        |

    When filter on "Client Statements" by
      | Name | Operator | Value                                                                   |
      | Name | Equals   | DailyCashPositions_CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI_@dateDRS(T-1).csv |
    And select on "Client Statements" row 0
    And download "DailyCashPositions_MOD-DVP-T-2-SELL-FI_@dateDRS(T-1).csv" file
    Then snapshot dataset "DailyCashPositions_MOD-DVP-T-2-SELL-FI_@dateDRS(T-1).csv" file as "sett_cash_pos_MOD-DVP-T-2-SELL-FI_v1"
    And validate snapshot "sett_cash_pos_MOD-DVP-T-2-SELL-FI_v1" on
      | COB Date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Client Code  | Master Acc Name           | Sub Account                        | Perspective | Ccy     | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | @date(<settDate>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | <clientCode> | <clientMasterAccountName> | CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI | Local       | GBP     | 5,000.00        | 5,000.00        | .00            | 10,000.00                      |
      | @date(<settDate>)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | <clientCode> | <clientMasterAccountName> | CP:Mod:SFL-AUD-BEL:DVP:T-2:SELL:FI | Pref        | AUD     | 4,150.00        | 4,150.00        | .00            | 8,300.00                       |
      | The values or prices attributes to the investments in this report are provided to you for information and internal purposes only and are not intended for use for any other purpose, including financial disclosure, marketing, reporting (regulatory or otherwise) or the determination of net asset value or for use by any third party. StoneX Financial Ltd is authorised and regulated by the Financial Conduct Authority [FRN: 446717]. Registered in England & Wales with Company Number 5616586 | [empty]      | [empty]                   | [empty]                            | [empty]     | [empty] | [empty]         | [empty]         | [empty]        | [empty]                        |

#    When filter on "Client Statements" by
#      | Name | Operator | Value                                                              |
#      | Name | Equals   | DailyCashPositions_CP:csv:SFL-AUD-BEL:CT:T-2:PAY_@dateDRS(T-1).csv |
#    And select on "Client Statements" row 0
#    And download "DailyCashPositions_CSV-CT-T-2-PAY_@dateDRS(T-1).csv" file
#    Then snapshot dataset "DailyCashPositions_CSV-CT-T-2-PAY_@dateDRS(T-1).csv" file as "sett_cash_pos_CSV-CT-T-2-PAY_v1"
#    And validate snapshot "sett_cash_pos_CSV-CT-T-2-PAY_v1" on
#      | COB Date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Client Code | Master Acc Name | Sub Account | Perspective | Ccy     | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
#      | The values or prices attributes to the investments in this report are provided to you for information and internal purposes only and are not intended for use for any other purpose, including financial disclosure, marketing, reporting (regulatory or otherwise) or the determination of net asset value or for use by any third party. StoneX Financial Ltd is authorised and regulated by the Financial Conduct Authority [FRN: 446717]. Registered in England & Wales with Company Number 5616586 | [empty]     | [empty]         | [empty]     | [empty]     | [empty] | [empty]         | [empty]         | [empty]        | [empty]                        |
#
#    When filter on "Client Statements" by
#      | Name | Operator | Value                                                          |
#      | Name | Equals   | DailyCashPositions_CP:Mod:SFL-AUD-BEL:CT:T-2_@dateDRS(T-1).csv |
#    And select on "Client Statements" row 0
#    And download "DailyCashPositions_MOD-CT-T-2_@dateDRS(T-1).csv" file
#    Then snapshot dataset "DailyCashPositions_MOD-CT-T-2_@dateDRS(T-1).csv" file as "sett_cash_pos_MOD-CT-T-2_v1"
#    And validate snapshot "sett_cash_pos_MOD-CT-T-2_v1" on
#      | COB Date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Client Code | Master Acc Name | Sub Account | Perspective | Ccy     | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
#      | The values or prices attributes to the investments in this report are provided to you for information and internal purposes only and are not intended for use for any other purpose, including financial disclosure, marketing, reporting (regulatory or otherwise) or the determination of net asset value or for use by any third party. StoneX Financial Ltd is authorised and regulated by the Financial Conduct Authority [FRN: 446717]. Registered in England & Wales with Company Number 5616586 | [empty]     | [empty]         | [empty]     | [empty]     | [empty] | [empty]         | [empty]         | [empty]        | [empty]                        |
#
#    When filter on "Client Statements" by
#      | Name | Operator | Value                                                              |
#      | Name | Equals   | DailyCashPositions_CP:Mod:SFL-AUD-BEL:CT:T-2:REC_@dateDRS(T-1).csv |
#    And select on "Client Statements" row 0
#    And download "DailyCashPositions_MOD-CT-T-2-REC_@dateDRS(T-1).csv" file
#    Then snapshot dataset "DailyCashPositions_MOD-CT-T-2-REC_@dateDRS(T-1).csv" file as "sett_cash_pos_MOD-CT-T-2-REC_v1"
#    And validate snapshot "sett_cash_pos_MOD-CT-T-2-REC_v1" on
#      | COB Date                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Client Code | Master Acc Name | Sub Account | Perspective | Ccy     | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
#      | The values or prices attributes to the investments in this report are provided to you for information and internal purposes only and are not intended for use for any other purpose, including financial disclosure, marketing, reporting (regulatory or otherwise) or the determination of net asset value or for use by any third party. StoneX Financial Ltd is authorised and regulated by the Financial Conduct Authority [FRN: 446717]. Registered in England & Wales with Company Number 5616586 | [empty]     | [empty]         | [empty]     | [empty]     | [empty] | [empty]         | [empty]         | [empty]        | [empty]                        |

    Examples:
      | date | settDate | clientCode             | clientMasterAccountName       |
      | T-2  | T-1      | Client_Tactical_Report | Client_Portal_Tactical_Report |
