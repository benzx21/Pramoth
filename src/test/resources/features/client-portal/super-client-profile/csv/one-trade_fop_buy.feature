@Client
@Regression
Feature: Client portal

  Scenario Outline: CSV - Single trade FOP buy v1...v4 in Trades, Ledger Postings and Securities Positions screens (Super Client)

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME   | VenueId   | ExchangeId | SettlementPlaceCode     | ACCRUED_INTEREST | SwiftCounterpartyName | CounterpartyLocalCustodianBic | CounterpartyLocalCustodianAccountNumber | CounterpartyAccountNumber | CounterpartyCode | COUNTERPARTY_BIC | IntermediaryBank | PlaceOfSafekeepingCode | Registration | Comment                  | StampStatusCode | NumberOfDaysAccrued | FREE_FORMAT_TEXT | NUMBER_OF_DAYS_ACCRUED | INTERMEDIARIES | PARTIAL_SETTLEMENT_ALLOWED | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | ClientSubAccount | Side        | Quantity        | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | <settlementplacecode01> | VenueID01 | Testexid01 | <settlementplacecode01> | 5.26             | CPTYName01            | CPTYLocal02                   | CPTYLocalCustAccNumber02                | 123                       | CPTY             | CPTY1234568      | InterBank02      | Place02                | REG02        | csv upload client portal | Stamp02         | 1                   | TRUE             | 10                     | Intermediaries | FALSE                      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <subAccount>     | <direction> | <tradeQuantity> | <settMethod>      | @date(<settDate>) | <settCountry>     | @default() | @default()        |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v1"
    And validate snapshot "c-trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code  | Depot Bank  |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode> | <depotBank> |

    Given navigation to "Security Positions" page
    When search on "Security Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name               | Operator | Value                     |
      | CustX Account Name | Equals   | <clientCode>-<subAccount> |
    Then snapshot dataset "Securities Positions" as "c-security_position_v1"
    And validate snapshot "c-security_position_v1" on
      | COB Date          | CustX Account Name        | Client Code  | Master Account            | Sub Account  | Perspective | Perspective Code | ISIN   | Depot       | Security              | Asset Type     | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy  | Indicative COB Price | Fx Rate (Indicative ccy to Base ccy) | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | @date(<settDate>) | <clientCode>-<subAccount> | <clientCode> | <clientMasterAccountName> | <subAccount> | CUSTODIAN   | <depotBank>      | <isin> | <depotCode> | <securityDescription> | <securityType> | YES               | <qty>           | <qty>                | 0               | <securityCcy>  | <baseCcy> | <secPriceT>          | <secFxRateT>                         | <qty*price>                        | <qty*price*secFxRateT>       |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name                       | Operator | Value                                     |
      | Source Allocation Trade ID | Equals   | @context(LAST_SOURCE_ALLOCATION_TRADE_ID) |
    Then snapshot dataset "Trades" as "trade_v1"
    And validate snapshot "trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code  |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode> |
    And set param "LAST_CUSTX_TRADE_ID" from dataset "trade_v1" with "CustX Trade ID" row 0

    Given navigation to "Securities Positions" page
    When search on "Securities Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Securities Positions" as "security_position_v1"
    And validate snapshot "security_position_v1" on
      | COB Date          | Client Code  | Master Account            | Sub Account  | Perspective | Perspective Code | ISIN   | Depot       | Security              | Asset Type     | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy  | Indicative COB Price | Fx Rate (Indicative ccy to Base ccy) | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CUSTODIAN   | <depotBank>      | <isin> | <depotCode> | <securityDescription> | <securityType> | YES               | <qty>           | <qty>                | 0               | <baseCcy>      | <baseCcy> | <secPriceT>          | 1.0000                               | <qty*price*secFxRateT>             | <qty*price*secFxRateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CLIENT      | <clientCode>     | <isin> | [empty]     | <securityDescription> | <securityType> | YES               | <qty>           | <qty>                | 0               | <securityCcy>  | <baseCcy> | <secPriceT>          | <secFxRateT>                         | <qty*price>                        | <qty*price*secFxRateT>       |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v1"
    And validate snapshot "ledger_posting_v1" on
      | Posting Date | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name     | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | @date(T)     | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <deb_sec_unSett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | @date(T)     | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <cre_sec_unSett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |
    Then snapshot dataset "Trades" as "trade_v2"
    And validate snapshot "trade_v1" against "trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    Given navigation to "Securities Positions" page
    When search on "Securities Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Securities Positions" as "security_position_v2"
    And validate snapshot "security_position_v1" against "security_position_v2" on
      | Ops | COB Date | Client Code | Master Account | Sub Account | Perspective | Perspective Code | ISIN  | Depot | Security | Asset Type | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | @same           | @same                | <qty>           | @same          | @same    | @same                              | @same                        |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | @same           | @same                | <qty>           | @same          | @same    | @same                              | @same                        |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v2"
    And validate snapshot "ledger_posting_v1" against "ledger_posting_v2" on
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name   | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <deb_sec_sett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <cre_sec_sett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v2"
    And validate snapshot "c-trade_v1" against "c-trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    Given navigation to "Security Positions" page
    When search on "Security Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name               | Operator | Value                     |
      | CustX Account Name | Equals   | <clientCode>-<subAccount> |
    Then snapshot dataset "Securities Positions" as "c-security_position_v2"
    And validate snapshot "c-security_position_v1" against "c-security_position_v2" on
      | Ops | COB Date | CustX Account Name | Client Code | Master Account | Asset Type | ISIN  | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Unsettled Trades? | Indicative Ccy | Base Ccy | Indicative COB Price | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) | Fx Rate (Indicative ccy to Base ccy) |
      | ~   | @same    | @same              | @same       | @same          | @same      | @same | @same           | @same                | <qty>           | NO                | @same          | @same    | @same                | @same                              | @same                        | @same                                |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value     |
      | Settlement Status | UNSETTLED |
    Then snapshot dataset "Trades" as "trade_v3"
    And validate snapshot "trade_v2" against "trade_v3" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | [empty]          | @same                   | 3             | @same              | UNSETTLED         | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    Given navigation to "Securities Positions" page
    When search on "Securities Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Securities Positions" as "security_position_v3"
    And validate snapshot "security_position_v2" against "security_position_v3" on
      | Ops | COB Date | Client Code | Master Account | Sub Account | Perspective | Perspective Code | ISIN  | Depot | Security | Asset Type | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | @same           | @same                | 0               | @same          | @same    | @same                              | @same                        |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | @same           | @same                | 0               | @same          | @same    | @same                              | @same                        |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v3"
    And validate snapshot "ledger_posting_v2" against "ledger_posting_v3" on
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name   | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <cre_sec_sett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <deb_sec_sett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v3"
    And validate snapshot "c-trade_v2" against "c-trade_v3" on
      | Ops | Trade Sub-Type | Actual Sett Date | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | [empty]          | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | @same              | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | UNSETTLED         | @same  | @same       | @same          | @same      | 3             |

    Given navigation to "Security Positions" page
    When search on "Security Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name               | Operator | Value                     |
      | CustX Account Name | Equals   | <clientCode>-<subAccount> |
    Then snapshot dataset "Securities Positions" as "c-security_position_v3"
    And validate snapshot "c-security_position_v2" against "c-security_position_v3" on
      | Ops | COB Date | CustX Account Name | Client Code | Master Account | Asset Type | ISIN  | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Unsettled Trades? | Indicative Ccy | Base Ccy | Indicative COB Price | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) | Fx Rate (Indicative ccy to Base ccy) |
      | ~   | @same    | @same              | @same       | @same          | @same      | @same | @same           | @same                | 0               | YES               | @same          | @same    | @same                | @same                              | @same                        | @same                                |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "c-trade_v4"
    And validate snapshot "c-trade_v3" against "c-trade_v4" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @same            | @same                    | @same                                    | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | CANCELLED          | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | @same             | @same  | @same       | @same          | @same      | 4             |

    Given navigation to "Security Positions" page
    When search on "Security Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name               | Operator | Value                     |
      | CustX Account Name | Equals   | <clientCode>-<subAccount> |
    Then snapshot dataset "Securities Positions" as "c-security_position_v4"
    And validate snapshot "c-security_position_v3" against "c-security_position_v4" on
      | Ops | COB Date | CustX Account Name | Client Code | Master Account | Asset Type | ISIN  | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Unsettled Trades? | Indicative Ccy | Base Ccy | Indicative COB Price | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) | Fx Rate (Indicative ccy to Base ccy) |
      | ~   | @same    | @same              | @same       | @same          | @same      | @same | 0               | 0                    | @same           | NO                | @same          | @same    | @same                | 0.00                               | 0.00                         | @same                                |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "trade_v4"
    And validate snapshot "trade_v3" against "trade_v4" on
      | Ops | CustX Trade ID | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same            | @same                   | 4             | CANCELLED          | @same             | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    Given navigation to "Securities Positions" page
    When search on "Securities Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Securities Positions" as "security_position_v4"
    And validate snapshot "security_position_v3" against "security_position_v4" on
      | Ops | COB Date | Client Code | Master Account | Sub Account | Perspective | Perspective Code | ISIN  | Depot | Security | Asset Type | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | @same           | @same          | @same    | 0.00                               | 0.00                         |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | @same           | @same          | @same    | 0.00                               | 0.00                         |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v4"
    And validate snapshot "ledger_posting_v3" against "ledger_posting_v4" on
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name     | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same             | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <cre_sec_unSett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <deb_sec_unSett_gl> | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

    Examples:
      ######################################  CONFIG  ############################################## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | c-env             | c-username   | c-password | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType          | subAccount                    | baseCcy | direction | legalEntityCode | clientCode  | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCountry | settlementplacecode01 | depotBank | depotCode    | tradeQuantity | qty   | secPriceT | secFxRateT | qty*price  | qty*price*secFxRateT | cre_sec_unSett_gl                 | deb_sec_unSett_gl                      | cre_sec_sett_gl                        | deb_sec_sett_gl |
      | client-defaultEnv | JohnDoeCPfop | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | FOP        | Client Securities Fop | CP:SFL-AUD-AUS:FOP:T-2:BUY:FI | AUD     | BUY       | SFL             | CP_FOP_Auto | CP_Auto_Testing_FOP     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | USA         | ACLRAU2S              | BNY       | BNYDepotCode | 1000          | 1,000 | 173.0000  | 1.7200     | 173,000.00 | 297,560.00           | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
      | client-defaultEnv | JohnDoeCPfop | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-1       | T        | FOP        | Client Securities Fop | CP:SFL-AUD-GBR:FOP:T-1:BUY:FI | AUD     | BUY       | SFL             | CP_FOP_Auto | CP_Auto_Testing_FOP     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | FRA         | ACLRAU2S              | BNY       | BNYDepotCode | 1000          | 1,000 | 173.0000  | 1.7200     | 173,000.00 | 297,560.00           | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
      | client-defaultEnv | JohnDoeCPfop | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T         | T        | FOP        | Client Securities Fop | CP:SFL-AUD-AUS:FOP:T:BUY:FI   | AUD     | BUY       | SFL             | CP_FOP_Auto | CP_Auto_Testing_FOP     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | FRA         | ACLRAU2S              | BNY       | BNYDepotCode | 1000          | 1,000 | 173.0000  | 1.7200     | 173,000.00 | 297,560.00           | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
      | client-defaultEnv | JohnDoeCPfop | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | FOP        | Client Securities Fop | CP:SFL-AUD-FRA:FOP:T-2:BUY:EQ | AUD     | BUY       | SFL             | CP_FOP_Auto | CP_Auto_Testing_FOP     | SFL        | NL0000235190 | EQUITY       | AIRBUS              | EUR         | USA         | BAGHGHAC              | BNY       | BNYDepotCode | 1000          | 1,000 | 0.7713    | 1.7200     | 771.30     | 1,326.64             | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
      | client-defaultEnv | JohnDoeCPfop | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-1       | T        | FOP        | Client Securities Fop | CP:SFL-AUD-FRA:FOP:T-1:BUY:EQ | AUD     | BUY       | SFL             | CP_FOP_Auto | CP_Auto_Testing_FOP     | SFL        | NL0000235190 | EQUITY       | AIRBUS              | EUR         | USA         | BAGHGHAC              | BNY       | BNYDepotCode | 1000          | 1,000 | 0.7713    | 1.7200     | 771.30     | 1,326.64             | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
      | client-defaultEnv | JohnDoeCPfop | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T         | T        | FOP        | Client Securities Fop | CP:SFL-AUD-BEL:FOP:T:BUY:EQ   | AUD     | BUY       | SFL             | CP_FOP_Auto | CP_Auto_Testing_FOP     | SFL        | NL0000235190 | EQUITY       | AIRBUS              | EUR         | USA         | BAGHGHAC              | BNY       | BNYDepotCode | 1000          | 1,000 | 0.7713    | 1.7200     | 771.30     | 1,326.64             | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |


