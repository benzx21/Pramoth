@Admin
@Regression
Feature: Admin portal

  Scenario Outline: Validate multi custodian DVP trough v1...v4 in Trades, Securities Positions, Cash Positions screens

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | TRADE_SUBTYPE  | ClientSubAccount | Side        | Quantity        | Price        | Currency | Amount   | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NOSTRO_BANK    | NOSTRO_CODE    | DEPOT_BANK    | DEPOT_CODE    | NET_CONSIDERATION  | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry01>   | <settCcy01>        | <nostroBank01> | <nostroCode01> | <depotBank01> | <depotCode01> | <netConsideration> | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | ACLRAU2S            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry02>   | <settCcy02>        | <nostroBank02> | <nostroCode02> | <depotBank02> | <depotCode02> | <netConsideration> | @default() | @default()        |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode01> |
    Then snapshot dataset "Trades" as "cust01_trade_v1"
    And validate snapshot "cust01_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate   | Entity Currency | Entity Cash Amount     | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code    | Depot Code    | NOSTRO_BANK    | DEPOT_BANK    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | <amt>               | @abs(<netCons*ratePref01>)   | <entityfxRate01> | USD             | @abs(<netCons*rate01>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <direction> | <settCountry01>    | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode01> | <depotCode01> | <nostroBank01> | <depotBank01> |
    And set param "CUST01_CUSTX_TRADE_ID" from dataset "cust01_trade_v1" with "CustX Trade ID" row 0

    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode02> |
    Then snapshot dataset "Trades" as "cust02_trade_v1"
    And validate snapshot "cust02_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate   | Entity Currency | Entity Cash Amount     | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code    | Depot Code    | NOSTRO_BANK    | DEPOT_BANK    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | <amt>               | @abs(<netCons*ratePref02>)   | <entityfxRate02> | USD             | @abs(<netCons*rate02>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <direction> | <settCountry02>    | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode02> | <depotCode02> | <nostroBank02> | <depotBank02> |
    And set param "CUST02_CUSTX_TRADE_ID" from dataset "cust02_trade_v1" with "CustX Trade ID" row 0

    Given navigation to "Securities Positions" page
    When search on "Securities Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Securities Positions" as "security_position_v1"
    And validate snapshot "security_position_v1" on
      | COB Date          | Client Code  | Master Account            | Sub Account  | Perspective | Perspective Code | ISIN   | Depot         | Security              | Asset Type     | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy  | Indicative COB Price | Fx Rate (Indicative ccy to Base ccy) | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CUSTODIAN   | <depotBank01>    | <isin> | <depotCode01> | <securityDescription> | <securityType> | YES               | <qty>           | <qty>                | 0               | <baseCcy>      | <baseCcy> | <secPriceT>          | 1.0000                               | <qty*price*secFxRateT>             | <qty*price*secFxRateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CUSTODIAN   | <depotBank02>    | <isin> | <depotCode02> | <securityDescription> | <securityType> | YES               | <qty>           | <qty>                | 0               | <baseCcy>      | <baseCcy> | <secPriceT>          | 1.0000                               | <qty*price*secFxRateT>             | <qty*price*secFxRateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CLIENT      | <clientCode>     | <isin> | [empty]       | <securityDescription> | <securityType> | YES               | <totalqty>      | <totalqty>           | 0               | <securityCcy>  | <baseCcy> | <secPriceT>          | <secFxRateT>                         | <totalqty*price>                   | <totalqty*price*secFxRateT>  |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v1"
    And validate snapshot "cash_position_v1" on
      | COB Date          | Client Code  | Master Acc                | Sub Account  | Perspective | Ccy       | Nostro         | Settled Balance | Pending Credits           | Pending Debits            |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy01>   | [empty]        | 0.00            | <cre_netCons01>           | <deb_netCons01>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy02>   | [empty]        | 0.00            | <cre_netCons02>           | <deb_netCons02>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | [empty]        | 0.00            | <cre_netCons*rateT>       | <deb_netCons*rateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | [empty]        | 0.00            | <cre_netCons*ratePrefT>   | <deb_netCons*ratePrefT>   |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy01>   | <nostroCode01> | 0.00            | <cre_netCons01>           | <deb_netCons01>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy02>   | <nostroCode02> | 0.00            | <cre_netCons02>           | <deb_netCons02>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | <nostroCode01> | 0.00            | <cre_netCons*rateT01>     | <deb_netCons*rateT01>     |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | <nostroCode02> | 0.00            | <cre_netCons*rateT02>     | <deb_netCons*rateT02>     |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | <nostroCode01> | 0.00            | <cre_netCons*ratePrefT01> | <deb_netCons*ratePrefT01> |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | <nostroCode02> | 0.00            | <cre_netCons*ratePrefT02> | <deb_netCons*ratePrefT02> |

##############################################################v2##################################################################################


    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |
    Then snapshot dataset "Trades" as "cust01_trade_v2"
    And validate snapshot "cust01_trade_v1" against "cust01_trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @abs(<netCons>)          | @abs(<netCons*rate01>)     | @abs(<netCons*ratePref01>)               |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name                   | Value      |
      | Settlement Status      | SETTLED    |
      | Actual Settlement Date | <settDate> |
    Then snapshot dataset "Trades" as "cust02_trade_v2"
    And validate snapshot "cust02_trade_v1" against "cust02_trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @abs(<netCons>)          | @abs(<netCons*rate02>)     | @abs(<netCons*ratePref02>)               |


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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | @same           | @same                | <totalqty>      | @same          | @same    | @same                              | @same                        |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v2"
    And validate snapshot "cash_position_v1" against "cash_position_v2" on
      | Ops | COB Date | Client Code | Master Acc | Sub Account | Perspective | Ccy   | Nostro | Settled Balance           | Pending Credits | Pending Debits |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons01>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons02>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*rateT>       | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*ratePrefT>   | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons01>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons02>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*rateT01>     | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*rateT02>     | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*ratePrefT01> | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*ratePrefT02> | 0.00            | 0.00           |

###############################################################v3##################################################################################

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value     |
      | Settlement Status | UNSETTLED |
    Then snapshot dataset "Trades" as "cust01_trade_v3"
    And validate snapshot "cust01_trade_v2" against "cust01_trade_v3" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | [empty]          | @same                   | 3             | @same              | UNSETTLED         | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | 0.00                     | 0.00                       | 0.00                                     |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Manually Settle" "button"
    And submit dialog "Manual Settlement" using "Save" button with inputs
      | Name              | Value     |
      | Settlement Status | UNSETTLED |
    Then snapshot dataset "Trades" as "cust02_trade_v3"
    And validate snapshot "cust02_trade_v2" against "cust02_trade_v3" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | [empty]          | @same                   | 3             | @same              | UNSETTLED         | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | 0.00                     | 0.00                       | 0.00                                     |

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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | @same           | @same                | 0               | @same          | @same    | @same                              | @same                        |


    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v3"
    And validate snapshot "cash_position_v2" against "cash_position_v3" on
      | Ops | COB Date | Client Code | Master Acc | Sub Account | Perspective | Ccy   | Nostro | Settled Balance | Pending Credits           | Pending Debits            |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons01>           | <deb_netCons01>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons02>           | <deb_netCons02>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT>       | <deb_netCons*rateT>       |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT>   | <deb_netCons*ratePrefT>   |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons01>           | <deb_netCons01>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons02>           | <deb_netCons02>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT01>     | <deb_netCons*rateT01>     |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT02>     | <deb_netCons*rateT02>     |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT01> | <deb_netCons*ratePrefT01> |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT02> | <deb_netCons*ratePrefT02> |

################################################################v4#################################################################################

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "cust01_trade_v4"
    And validate snapshot "cust01_trade_v3" against "cust01_trade_v4" on
      | Ops | CustX Trade ID | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same            | @same                   | 4             | CANCELLED          | @same             | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "cust02_trade_v4"
    And validate snapshot "cust02_trade_v3" against "cust02_trade_v4" on
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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | 0               | @same          | @same    | 0.00                               | 0.00                         |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | 0               | @same          | @same    | 0.00                               | 0.00                         |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | 0               | @same          | @same    | 0.00                               | 0.00                         |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v4"
    And validate snapshot "cash_position_v3" against "cash_position_v4" on
      | Ops | COB Date | Client Code | Master Acc | Sub Account | Perspective | Ccy   | Nostro | Settled Balance | Pending Credits | Pending Debits |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | @same           | 0.00            | 0.00           |

    Examples:
      ##############  CONFIG  ############## ********************************************************************************************************************************************************************************************  TRADE  ******************************************************************************************************************************************************************************************** ############  Formatted(Amounts)  ########### *************************************  Aggregations(Expected results)  ************************************* ############################################################################################################################################     GL ACCOUNT NAMES     ############################################################################################################################################
      | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType        | subAccount                     | baseCcy | direction | legalEntityCode | clientCode | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCcy01 | settCountry01 | settCcy02 | settCountry02 | nostroBank01 | nostroCode01   | depotBank01 | depotCode01   | nostroBank02 | nostroCode02  | depotBank02 | depotCode02  | tradeQuantity | tradePrice | ccy | ccy01 | ccy02 | amount | netConsideration | qty   | price   | amt       | netCons   | entityfxRate01 | entityfxRate02 | netCons*rate01 | netCons*ratePref01 | netCons*rate02 | netCons*ratePref02 | secPriceT | secFxRateT | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons*rateT | cre_netCons*ratePrefT | cre_netCons01 | cre_netCons*rateT01 | cre_netCons*ratePrefT01 | deb_netCons01 | deb_netCons*rateT01 | deb_netCons*ratePrefT01 | deb_netCons02 | deb_netCons*rateT02 | deb_netCons*ratePrefT02 | cre_netCons02 | cre_netCons*rateT02 | cre_netCons*ratePrefT02 | qty*price*secFxRateT | totalqty*price | totalqty*price*secFxRateT | totalqty |
      | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | JPM:SFL-AUD-GBR:DVP:2Custodian | AUD     | BUY       | SFL             | JPM        | JPM                     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | USD       | USA           | EUR       | FRA           | CITI         | CITINostroCode | CITI        | CITIDepotCode | BNY          | BNYNostroCode | BNY         | BNYDepotCode | 1000          | 10         | USD | USD   | EUR   | 10000  | 10001            | 1,000 | 10.0000 | 10,000.00 | 10,001.00 | 1.0000         | 1.9400         | 10,001.00      | 17,401.74          | -19,401.94     | 17,401.74          | 173.0000  | 1.7200     | -29,202.92        | -34,403.44            | 0.00              | 0.00                  | 0.00          | 0.00                | 0.00                    | -10,001.00    | -10,001.00          | -17,201.72              | -10,001.00    | -19,201.92          | -17,201.72              | 0.00          | 0.00                | 0.00                    | 297,560.00           | 346,000.00     | 595,120.00                | 2,000    |
