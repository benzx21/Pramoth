@Client
@Regression
Feature: Client portal

  Scenario Outline: Modal - Single trade FOP BUY v1...v4 in Trades, Ledger Postings and Securities Positions screens (Client)

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "Trades" page
    And click "Pending Trades" "tab"
    And click "Add Trade" "button"
    And submit dialog "Create Trade" using "Create" button with inputs
      | Name                                | Value                     |
      | Custom Reference                    | @default()                |
      | Master Account Name: *              | <clientMasterAccountName> |
      | Sub Account: *                      | <subAccount>              |
      | FOP                                 | true                      |
      | ISIN: *                             | <isin>                    |
      | Direction: *                        | <direction>               |
      | Trade Quantity: *                   | <tradeQuantity>           |
      | Trade Date: *                       | @date(<tradeDate>)        |
      | Contractual Sett Date: *            | @date(<settDate>)         |
      | Settlement Country                  | <settCountry>             |
      | Place of Settlement Code: *         | <settlementplacecode01>   |
      | Execution Venue ID                  | VenueID                   |
      | Execution Exchange ID               | XEQT                      |
      | Intermediary Bank                   | EUROCLEAR BELGIUM         |
      | Counterparty Code                   | CPTYCode                  |
      | Counterparty Name                   | CPTYName                  |
      | Counterparty BIC: *                 | CPTYBIC1234               |
      | Counterparty Local Custodian BIC: * | CPTYLocBIC1               |
      | Counterparty Account Number: *      | 123456789                 |
      | Counterparty Local Code             | CPTYLocalCode             |
      | Custodian Local Code Type           | CustLocalCodeType         |

    And click "Add Trade" "button"
    And submit dialog "Create Trade" using "Create" button with inputs
      | Name                                | Value                     |
      | Custom Reference                    | @default()                |
      | Master Account Name: *              | <clientMasterAccountName> |
      | Sub Account: *                      | <subAccount>              |
      | ISIN: *                             | <isin>                    |
      | Direction: *                        | <direction>               |
      | Trade Quantity: *                   | <tradeQuantity>           |
      | Trade Date: *                       | @date(<tradeDate>)        |
      | Contractual Sett Date: *            | @date(<settDate>)         |
      | Settlement Country                  | <settCountry>             |
      | Place of Settlement Code: *         | <settlementplacecode02>   |
      | Execution Venue ID                  | VenueID                   |
      | Execution Exchange ID               | XEQT                      |
      | Intermediary Bank                   | EUROCLEAR BELGIUM         |
      | Counterparty Code                   | CPTYCode                  |
      | Counterparty Name                   | CPTYName                  |
      | Counterparty BIC: *                 | CPTYBIC1234               |
      | Counterparty Local Custodian BIC: * | CPTYLocBIC1               |
      | Counterparty Account Number: *      | 123456789                 |
      | Counterparty Local Code             | CPTYLocalCode             |
      | Custodian Local Code Type           | CustLocalCodeType         |

    Given authentication on "<c-env>" with credentials "<c1-username>" "<c1-password>"

    Given navigation to "Trades" page
    And click "Pending Trades" "tab"
    When filter on "Pending Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode01> |
    And select on "Pending Trades" row 0
    And click "Approve" "button"

    When filter on "Pending Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode02> |
    And select on "Pending Trades" row 0
    And click "Approve" "button"

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode01> |
    Then snapshot dataset "Trades" as "c_cust01_trade_v1"
    And validate snapshot "c_cust01_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode01> | <depotBank01> |
    And set param "CUST01_CUSTX_TRADE_ID" from dataset "c_cust01_trade_v1" with "CustX Trade ID" row 0

    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode02> |
    Then snapshot dataset "Trades" as "c_cust02_trade_v1"
    And validate snapshot "c_cust02_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode02> | <depotBank02> |
    And set param "CUST02_CUSTX_TRADE_ID" from dataset "c_cust02_trade_v1" with "CustX Trade ID" row 0

    Given navigation to "Security Positions" page
    When search on "Security Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name               | Operator | Value                     |
      | CustX Account Name | Equals   | <clientCode>-<subAccount> |
    Then snapshot dataset "Securities Positions" as "c-security_position_v1"
    And validate snapshot "c-security_position_v1" on
      | COB Date          | CustX Account Name        | Client Code  | Master Account            | Sub Account  | ISIN   | Security              | Asset Type     | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy  | Indicative COB Price | Fx Rate (Indicative ccy to Base ccy) | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | @date(<settDate>) | <clientCode>-<subAccount> | <clientCode> | <clientMasterAccountName> | <subAccount> | <isin> | <securityDescription> | <securityType> | YES               | <totalqty>      | <totalqty>           | 0               | <securityCcy>  | <baseCcy> | <secPriceT>          | <secFxRateT>                         | <totalqty*price>                   | <totalqty*price*secFxRateT>  |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_trade_v1"
    And validate snapshot "cust01_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode01> | <depotBank01> |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust02_trade_v1"
    And validate snapshot "cust02_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode02> | <depotBank02> |

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

   #############################################################v2#################################################################

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

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust01_trade_v2"
    And validate snapshot "c_cust01_trade_v1" against "c_cust01_trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust02_trade_v2"
    And validate snapshot "c_cust02_trade_v1" against "c_cust02_trade_v2" on
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
      | ~   | @same    | @same              | @same       | @same          | @same      | @same | @same           | @same                | <totalqty>      | NO                | @same          | @same    | @same                | @same                              | @same                        | @same                                |

   #############################################################v3#################################################################

    Given authentication on "<env>" with credentials "<username>" "<password>"

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


    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust01_trade_v3"
    And validate snapshot "c_cust01_trade_v2" against "c_cust01_trade_v3" on
      | Ops | Trade Sub-Type | Actual Sett Date | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | [empty]          | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | @same              | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | UNSETTLED         | @same  | @same       | @same          | @same      | 3             |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust02_trade_v3"
    And validate snapshot "c_cust02_trade_v2" against "c_cust02_trade_v3" on
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

    #############################################################v4#################################################################

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "c_cust01_trade_v4"
    And validate snapshot "c_cust01_trade_v3" against "c_cust01_trade_v4" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @same            | @same                    | @same                                    | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | CANCELLED          | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | @same             | @same  | @same       | @same          | @same      | 4             |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "c_cust02_trade_v4"
    And validate snapshot "c_cust02_trade_v3" against "c_cust02_trade_v4" on
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
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_trade_v4"
    And validate snapshot "cust01_trade_v3" against "cust01_trade_v4" on
      | Ops | CustX Trade ID | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same            | @same                   | 4             | CANCELLED          | @same             | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | @same           | @same          | @same    | 0.00                               | 0.00                         |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | @same           | @same          | @same    | 0.00                               | 0.00                         |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | NO                | 0               | 0                    | @same           | @same          | @same    | 0.00                               | 0.00                         |


    Examples:
      ######################################  CONFIG  ############################################## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | c-env             | c-username         | c-password | c1-username         | c1-password | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType          | subAccount                                   | baseCcy | direction | clientCode         | clientMasterAccountName    | isin         | securityType | securityDescription | securityCcy | settCountry | settlementplacecode01 | settlementplacecode02 | depotBank01 | depotCode01   | depotBank02 | depotCode02  | tradeQuantity | qty   | totalqty | secPriceT | secFxRateT | totalqty*price | totalqty*price*secFxRateT | qty*price*secFxRateT |
      | client-defaultEnv | JohnDoeCPfopClient | custx11*   | JohnDoeCPfopClient2 | custx11*    | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | FOP        | Client Securities Fop | CP:CLIENT:Mod:SFL-EUR-BEL:FOP:BUY:2Custodian | EUR     | BUY       | CP_CLIENT_FOP_Auto | CP_Auto_Testing_Client_FOP | NL0000235190 | EQUITY       | AIRBUS              | EUR         | FRA         | ACLRAU2S              | BAGHGHAC              | CITI        | CITIDepotCode | BNY         | BNYDepotCode | 1000          | 1,000 | 2,000    | 0.7713    | 0.5000     | 1,542.60       | 771.30                    | 385.65               |
