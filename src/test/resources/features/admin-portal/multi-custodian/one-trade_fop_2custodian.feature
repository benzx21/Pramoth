@Admin
@Regression
Feature: Admin portal

  Scenario Outline: Validate multi custodian  FOP trough v1...v4 in Trades, Securities Positions screen

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | TRADE_SUBTYPE  | ClientSubAccount | Side        | Quantity        | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | DEPOT_BANK    | DEPOT_CODE    | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <settMethod>      | @date(<settDate>) | <settCountry01>   | <depotBank01> | <depotCode01> | @default() | @default()        |
      | TRADE     | UK                    | NEW          | CREST                 | ACLRAU2S            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <settMethod>      | @date(<settDate>) | <settCountry02>   | <depotBank02> | <depotCode02> | @default() | @default()        |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode01> |
    Then snapshot dataset "Trades" as "cust01_trade_v1"
    And validate snapshot "cust01_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry01>    | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode01> | <depotBank01> |
    And set param "CUST01_CUSTX_TRADE_ID" from dataset "cust01_trade_v1" with "CustX Trade ID" row 0


    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode02> |
    Then snapshot dataset "Trades" as "cust02_trade_v1"
    And validate snapshot "cust02_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry02>    | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode02> | <depotBank02> |
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

#############################################################v2##############################################################
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
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | @same           | @same                | <totalqty>      | @same          | @same    | @same                              | @same                        |

#############################################################v3##############################################################
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
      | ~   | @same          | @same               | [empty]          | @same                   | 3             | @same              | UNSETTLED         | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |


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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | @same           | @same                | 0               | @same          | @same    | @same                              | @same                        |

#############################################################v4##############################################################

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


    Examples:
      ##############  CONFIG  ############## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType          | subAccount                     | baseCcy | direction | legalEntityCode | clientCode | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCountry01 | settCountry02 | depotBank01 | depotCode01  | depotBank02 | depotCode02   | tradeQuantity | qty   | totalqty | secPriceT | secFxRateT | qty*price  | totalqty*price | qty*price*secFxRateT | totalqty*price*secFxRateT | cre_sec_unSett_gl                 | deb_sec_unSett_gl                      | cre_sec_sett_gl                        | deb_sec_sett_gl |
      | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | FOP        | Client Securities Fop | JPM:SFL-AUD-GBR:FOP:2Custodian | AUD     | BUY       | SFL             | JPM        | JPM                     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | JPN           | FRA           | JPM         | JPMDepotCode | CITI        | CITIDepotCode | 1000          | 1,000 | 2,000    | 173.0000  | 1.7200     | 173,000.00 | 346,000.00     | 297,560.00           | 595,120.00                | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
