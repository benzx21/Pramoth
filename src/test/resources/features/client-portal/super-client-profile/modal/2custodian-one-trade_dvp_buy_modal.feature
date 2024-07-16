@Client
@Regression
Feature: Client portal

  Scenario Outline: Modal - Validate multi custodian DVP trough v1...v4 in Trades, Securities Positions, Cash Positions (Super Client)

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
      | ISIN: *                             | <isin>                    |
      | Direction: *                        | <direction>               |
      | Trade Quantity: *                   | <tradeQuantity>           |
      | Price: *                            | <tradePrice>              |
      | Trade Date: *                       | @date(<tradeDate>)        |
      | Contractual Sett Date: *            | @date(<settDate>)         |
      | Settlement Currency: *              | <settCcy01>               |
      | Settlement Country                  | <settCountry01>           |
      | Place of Settlement Code: *         | <settlementplacecode01>   |
      | Gross Consideration: *              | <amount>                  |
      | Net Consideration: *                | <netConsideration>        |
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
      | Price: *                            | <tradePrice>              |
      | Trade Date: *                       | @date(<tradeDate>)        |
      | Contractual Sett Date: *            | @date(<settDate>)         |
      | Settlement Currency: *              | <settCcy02>               |
      | Settlement Country                  | <settCountry02>           |
      | Place of Settlement Code: *         | <settlementplacecode02>   |
      | Gross Consideration: *              | <amount>                  |
      | Net Consideration: *                | <netConsideration>        |
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

    And click "Trade Activity" "tab"
    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode01> |
    Then snapshot dataset "Trades" as "c_cust01_trade_v1"
    And validate snapshot "c_cust01_trade_v1" on
      | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type     | Cash Pref CCY | Client Code  | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank    | Depot Code    | Direction   | DVP/FOP      | Gross Consideration | Is Late Settlement? | ISIN   | Legal Entity Code (Custody) | Master Account            | Price   | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank    | Nostro Code    | Quantity    | Settlement Status | Source    | Sub Account  | Trade Currency | Trade Date         | Trade Version |
      | <tradeSubType> | [empty]          | 0.00                     | 0.00                                     | <securityType> | <baseCcy>     | <clientCode> | @date(<settDate>)     | 123456789                   | CPTYBIC1234      | CPTYCode          | CPTYLocalCode           | CustLocalCodeType         | [empty]                                     | CPTYLocBIC1                      | CPTYName          | NEW                | <depotBank01> | <depotCode01> | <direction> | <settMethod> | <amt>               | ✖                   | <isin> | <legalEntityCode>           | <clientMasterAccountName> | <price> | <netCons>         | @abs(<netCons*ratePref01>)   | <nostroBank01> | <nostroCode01> | @abs(<qty>) | UNSETTLED         | CLIENT_UI | <subAccount> | <ccy01>        | @date(<tradeDate>) | 1             |
    And set param "CUST01_CUSTX_TRADE_ID" from dataset "c_cust01_trade_v1" with "CustX Trade ID" row 0

    When filter on "Trades" by
      | Name        | Operator | Value         |
      | Sub Account | Equals   | <subAccount>  |
      | Depot Code  | Equals   | <depotCode02> |
    Then snapshot dataset "Trades" as "c_cust02_trade_v1"
    And validate snapshot "c_cust02_trade_v1" on
      | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type     | Cash Pref CCY | Client Code  | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank    | Depot Code    | Direction   | DVP/FOP      | Gross Consideration | Is Late Settlement? | ISIN   | Legal Entity Code (Custody) | Master Account            | Price   | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank    | Nostro Code    | Quantity    | Settlement Status | Source    | Sub Account  | Trade Currency | Trade Date         | Trade Version |
      | <tradeSubType> | [empty]          | 0.00                     | 0.00                                     | <securityType> | <baseCcy>     | <clientCode> | @date(<settDate>)     | 123456789                   | CPTYBIC1234      | CPTYCode          | CPTYLocalCode           | CustLocalCodeType         | [empty]                                     | CPTYLocBIC1                      | CPTYName          | NEW                | <depotBank02> | <depotCode02> | <direction> | <settMethod> | <amt>               | ✖                   | <isin> | <legalEntityCode>           | <clientMasterAccountName> | <price> | <netCons>         | @abs(<netCons*ratePref02>)   | <nostroBank02> | <nostroCode02> | @abs(<qty>) | UNSETTLED         | CLIENT_UI | <subAccount> | <ccy02>        | @date(<tradeDate>) | 1             |
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
      | COB Date          | CustX Account Name        | Client Code  | Master Account            | Asset Type     | ISIN   | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Unsettled Trades? | Indicative Ccy | Base Ccy  | Indicative COB Price | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) | Fx Rate (Indicative ccy to Base ccy) |
      | @date(<settDate>) | <clientCode>-<subAccount> | <clientCode> | <clientMasterAccountName> | <securityType> | <isin> | <totalqty>      | <totalqty>           | 0               | YES               | <securityCcy>  | <baseCcy> | <secPriceT>          | <totalqty*price>                   | <totalqty*price*secFxRateT>  | <secFxRateT>                         |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date          |
      | @option(ALL) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v1"
    And validate snapshot "c-cash_position_v1" on
      | COB Date          | Client Code  | Master Acc Name           | Sub Account  | Perspective | Ccy       | Settled Balance | Pending Credits         | Pending Debits          | Total Cash (Settled + Pending) |
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Local       | <ccy01>   | 0.00            | <cre_netCons01>         | <deb_netCons01>         | <netCons01>                    |
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Pref        | <baseCcy> | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> | <netCons*ratePrefT>            |
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Local       | <ccy02>   | 0.00            | <cre_netCons02>         | <deb_netCons02>         | <netCons02>                    |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_trade_v1"
    And validate snapshot "cust01_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate   | Entity Currency | Entity Cash Amount     | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code    | Depot Code    | Nostro BanK    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | @abs(<amt>)         | @abs(<netCons*ratePref01>)   | <entityfxRate01> | USD             | @abs(<netCons*rate01>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy01>        | <direction> | <settCountry01>    | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode01> | <depotCode01> | <nostroBank01> | <depotBank01> |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust02_trade_v1"
    And validate snapshot "cust02_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate   | Entity Currency | Entity Cash Amount     | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code    | Depot Code    | Nostro BanK    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | @abs(<amt>)         | @abs(<netCons*ratePref02>)   | <entityfxRate02> | USD             | @abs(<netCons*rate02>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy02>        | <direction> | <settCountry02>    | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode02> | <depotCode02> | <nostroBank02> | <depotBank02> |

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

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust01_trade_v2"
    And validate snapshot "c_cust01_trade_v1" against "c_cust01_trade_v2" on
      | Ops | Trade Sub-Type | Actual Sett Date  | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @date(<settDate>) | @abs(<netCons>)          | @abs(<netCons*ratePref01>)               | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | AMENDED            | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | SETTLED           | @same  | @same       | @same          | @same      | 2             |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust02_trade_v2"
    And validate snapshot "c_cust02_trade_v1" against "c_cust02_trade_v2" on
      | Ops | Trade Sub-Type | Actual Sett Date  | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @date(<settDate>) | @abs(<netCons>)          | @abs(<netCons*ratePref02>)               | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | AMENDED            | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | SETTLED           | @same  | @same       | @same          | @same      | 2             |

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

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date          |
      | @option(ALL) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v2"
    And validate snapshot "c-cash_position_v1" against "c-cash_position_v2" on
      | Ops | COB Date | Client Code | Master Acc Name | Sub Account | Perspective | Ccy   | Settled Balance     | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <netCons01>         | 0.00            | 0.00           | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <netCons*ratePrefT> | 0.00            | 0.00           | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <netCons02>         | 0.00            | 0.00           | @same                          |



      ################################################################v3##################################################################################


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



    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust01_trade_v3"
    And validate snapshot "c_cust01_trade_v2" against "c_cust01_trade_v3" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | [empty]          | 0.00                     | 0.00                                     | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | @same              | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | UNSETTLED         | @same  | @same       | @same          | @same      | 3             |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "c_cust02_trade_v3"
    And validate snapshot "c_cust02_trade_v2" against "c_cust02_trade_v3" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | [empty]          | 0.00                     | 0.00                                     | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | @same              | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | UNSETTLED         | @same  | @same       | @same          | @same      | 3             |

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

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date          |
      | @option(ALL) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v3"
    And validate snapshot "c-cash_position_v2" against "c-cash_position_v3" on
      | Ops | COB Date | Client Code | Master Acc Name | Sub Account | Perspective | Ccy   | Settled Balance | Pending Credits         | Pending Debits          | Total Cash (Settled + Pending) |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | 0.00            | <cre_netCons01>         | <deb_netCons01>         | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | 0.00            | <cre_netCons02>         | <deb_netCons02>         | @same                          |


    ################################################################v4#################################################################################

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

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date          |
      | @option(ALL) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v4"
    And validate snapshot "c-cash_position_v3" against "c-cash_position_v4" on
      | Ops | COB Date | Client Code | Master Acc Name | Sub Account | Perspective | Ccy   | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | @same           | 0.00            | 0.00           | 0.00                           |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | @same           | 0.00            | 0.00           | 0.00                           |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | @same           | 0.00            | 0.00           | 0.00                           |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    Then snapshot dataset "Trades" as "cust01_trade_v4"
    And validate snapshot "cust01_trade_v3" against "cust01_trade_v4" on
      | Ops | CustX Trade ID | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same            | @same                   | 4             | CANCELLED          | @same             | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
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
      ##############  CONFIG  ############## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | c-env             | c-username   | c-password | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType        | subAccount                        | baseCcy | direction | legalEntityCode | clientCode  | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settlementplacecode01 | settlementplacecode02 | settCcy01 | ccy01 | settCcy02 | ccy02 | nostroBank01 | nostroCode01  | nostroBank02 | nostroCode02   | settCountry01 | settCountry02 | depotBank01 | depotCode01  | depotBank02 | depotCode02   | tradeQuantity | tradePrice | amount | netConsideration | qty   | totalqty | price  | amt     | netCons   | netCons*ratePref | entityfxRate01 | entityfxRate02 | netCons*rate01 | netCons*ratePref01 | netCons*rate02 | netCons*ratePref02 | secPriceT | secFxRateT | qty*price*secFxRateT | totalqty*price | totalqty*price*secFxRateT | netCons*ratePrefT | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons01 | cre_netCons02 | cre_netCons*rateT | cre_netCons*rateT01 | cre_netCons*rateT02 | cre_netCons*ratePrefT | cre_netCons*ratePrefT02 | cre_netCons*ratePrefT01 | netCons01 | netCons02 | deb_netCons01 | deb_netCons02 | deb_netCons*rateT01 | deb_netCons*rateT02 | deb_netCons*ratePrefT01 | deb_netCons*ratePrefT02 |
      | client-defaultEnv | JohnDoeCPdvp | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | CP:Mod:SFL-EUR-BEL:DVP:2Custodian | EUR     | BUY       | SFL             | CP_DVP_Auto | CP_Auto_Testing_DVP     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | ADSEAEA1              | BAZAZMLU              | USD       | USD   | EUR       | EUR   | BNY          | BNYNostroCode | CITI         | CITINostroCode | USA           | FRA           | BNY         | BNYDepotCode | CITI        | CITIDepotCode | 1000          | 1          | 999    | 1001             | 1,000 | 2,000    | 1.0000 | -999.00 | -1,001.00 | 970.97           | 1.0000         | 1.9400         | 1,001.00       | 970.97             | 1,941.94       | 1,001.00           | 173.0000  | 0.5000     | 86,500.00            | 346,000.00     | 173,000.00                | -1,961.96         | -2,922.92         | -1,961.96             | 0.00          | 0.00          | 0.00              | 0.00                | 0.00                | 0.00                  | 0.00                    | 0.00                    | -1,001.00 | -1,001.00 | -1,001.00     | -1,001.00     | -1,001.00           | -1,921.92           | -960.96                 | -1,001.00               |
