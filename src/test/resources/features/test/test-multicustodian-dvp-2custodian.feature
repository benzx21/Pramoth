@Client

Feature: Client portal

  Scenario Outline: CSV - Validate single trade DVP trough v1...v4 in Trades, Securities Positions and Cash Positions screens (Super Client)

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SettlementPlaceCode     | SETTLEMENT_PLACE_NAME | CounterpartyAccountNumber | COUNTERPARTY_BIC | CounterpartyCode | CounterpartyLocalCode | CustodianLocalCodeType | CounterpartyLocalCustodianAccountNumber | CounterpartyLocalCustodianBic | CounterpartyName | VenueId | ExchangeId | IntermediaryBank  | Comment                  | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | ClientSubAccount | Side        | Quantity        | Price        | Currency | Amount   | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NET_CONSIDERATION  | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | <settlementplacecode01> | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <netConsideration> | @default() | @default()        |
      | TRADE     | UK                    | NEW          | <settlementplacecode02> | ADSEAEA1              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <netConsideration> | @default() | @default()        |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name                     | Operator | Value                   |
      | Place of Settlement Code | Equals   | <settlementplacecode01> |
      | Sub Account              | Equals   | <subAccount>            |
    Then snapshot dataset "Trades" as "cust01_c-trade_v1"
    And validate snapshot "cust01_c-trade_v1" on
      | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type     | Cash Pref CCY | Client Code  | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank    | Depot Code    | Direction   | DVP/FOP      | Gross Consideration | Is Late Settlement? | ISIN   | Legal Entity Code (Custody) | Master Account            | Price   | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank    | Nostro Code    | Quantity    | Settlement Status | Source            | Sub Account  | Trade Currency | Trade Date         | Trade Version |
      | <tradeSubType> | [empty]          | 0.00                     | 0.00                                     | <securityType> | <baseCcy>     | <clientCode> | @date(<settDate>)     | 123456789                   | CPTYBIC1234      | CPTYCode          | CPTYLocalCode           | CustLocalCodeType         | CPTYLocalCustAccNumber                      | CPTYLocBIC1                      | CPTYName          | NEW                | <depotBank01> | <depotCode01> | <direction> | <settMethod> | <amt>               | ✖                   | <isin> | <legalEntityCode>           | <clientMasterAccountName> | <price> | <netCons>         | @abs(<netCons*ratePref>)     | <nostroBank01> | <nostroCode01> | @abs(<qty>) | UNSETTLED         | CLIENT_CSV_UPLOAD | <subAccount> | <ccy>          | @date(<tradeDate>) | 1             |
    And set param "CUST01_CUSTX_TRADE_ID" from dataset "cust01_c-trade_v1" with "CustX Trade ID" row 0

    When filter on "Trades" by
      | Name                     | Operator | Value                   |
      | Place of Settlement Code | Equals   | <settlementplacecode02> |
      | Sub Account              | Equals   | <subAccount>            |
    Then snapshot dataset "Trades" as "cust02_c-trade_v1"
    And validate snapshot "cust02_c-trade_v1" on
      | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type     | Cash Pref CCY | Client Code  | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank    | Depot Code    | Direction   | DVP/FOP      | Gross Consideration | Is Late Settlement? | ISIN   | Legal Entity Code (Custody) | Master Account            | Price   | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank    | Nostro Code    | Quantity    | Settlement Status | Source            | Sub Account  | Trade Currency | Trade Date         | Trade Version |
      | <tradeSubType> | [empty]          | 0.00                     | 0.00                                     | <securityType> | <baseCcy>     | <clientCode> | @date(<settDate>)     | 123456789                   | CPTYBIC1234      | CPTYCode          | CPTYLocalCode           | CustLocalCodeType         | CPTYLocalCustAccNumber                      | CPTYLocBIC1                      | CPTYName          | NEW                | <depotBank02> | <depotCode02> | <direction> | <settMethod> | <amt>               | ✖                   | <isin> | <legalEntityCode>           | <clientMasterAccountName> | <price> | <netCons>         | @abs(<netCons*ratePref>)     | <nostroBank02> | <nostroCode02> | @abs(<qty>) | UNSETTLED         | CLIENT_CSV_UPLOAD | <subAccount> | <ccy>          | @date(<tradeDate>) | 1             |
    And set param "CUST02_CUSTX_TRADE_ID" from dataset "cust02_c-trade_v1" with "CustX Trade ID" row 0


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
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Local       | <ccy>     | 0.00            | <cre_netCons>           | <deb_netCons>           | <totalnetCons>                 |
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Pref        | <baseCcy> | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> | <totalnetCons*ratePrefT>       |


    Given authentication on "<env>" with credentials "<username>" "<password>"
    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_trade_v1"
    And validate snapshot "cust01_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount   | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code    | Depot Code    | Nostro Bank    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | @abs(<amt>)         | @abs(<netCons*ratePref>)     | <fxRate>       | USD             | @abs(<netCons*rate>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode01> | <depotCode01> | <nostroBank01> | <depotBank01> |

    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust02_trade_v1"
    And validate snapshot "cust02_trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount   | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code    | Depot Code    | Nostro Bank    | Depot Bank    |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | @abs(<amt>)         | @abs(<netCons*ratePref>)     | <fxRate>       | USD             | @abs(<netCons*rate>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode02> | <depotCode02> | <nostroBank02> | <depotBank02> |

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
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy>     | [empty]        | 0.00            | <cre_netCons>             | <deb_netCons>             |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy>     | <nostroCode01> | 0.00            | <cre_netCons01>           | <deb_netCons01>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | [empty]        | 0.00            | <cre_netCons*ratePrefT>   | <deb_netCons*ratePrefT>   |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | <nostroCode01> | 0.00            | <cre_netCons*ratePrefT01> | <deb_netCons*ratePrefT01> |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | [empty]        | 0.00            | <cre_netCons*rateT>       | <deb_netCons*rateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | <nostroCode01> | 0.00            | <cre_netCons*rateT01>     | <deb_netCons*rateT01>     |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy>     | <nostroCode02> | 0.00            | <cre_netCons02>           | <deb_netCons02>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | <nostroCode02> | 0.00            | <cre_netCons*ratePrefT02> | <deb_netCons*ratePrefT02> |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | <nostroCode02> | 0.00            | <cre_netCons*rateT02>     | <deb_netCons*rateT02>     |

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
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | Nostro Code | Depot Code | Nostro Bank | Depot Bank |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @abs(<netCons>)          | @abs(<netCons*rate>)       | @abs(<netCons*ratePref>)                 | @same       | @same      | @same       | @same      |


    Given navigation to "Trades" page
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
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | Nostro Code | Depot Code | Nostro Bank | Depot Bank |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @abs(<netCons>)          | @abs(<netCons*rate>)       | @abs(<netCons*ratePref>)                 | @same       | @same      | @same       | @same      |


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
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons>             | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons01>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*ratePrefT>   | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*ratePrefT01> | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*rateT>       | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*rateT01>     | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons02>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*ratePrefT02> | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <deb_netCons*rateT02>     | 0.00            | 0.00           |


    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_c-trade_v2"
    And validate snapshot "cust01_c-trade_v1" against "cust01_c-trade_v2" on
      | Ops | Trade Sub-Type | Actual Sett Date  | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @date(<settDate>) | @abs(<netCons>)          | @abs(<netCons*ratePref>)                 | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | AMENDED            | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | SETTLED           | @same  | @same       | @same          | @same      | 2             |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust02_c-trade_v2"
    And validate snapshot "cust02_c-trade_v1" against "cust02_c-trade_v2" on
      | Ops | Trade Sub-Type | Actual Sett Date  | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @date(<settDate>) | @abs(<netCons>)          | @abs(<netCons*ratePref>)                 | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | AMENDED            | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | SETTLED           | @same  | @same       | @same          | @same      | 2             |


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
      | Ops | COB Date | Client Code | Master Acc Name | Sub Account | Perspective | Ccy   | Settled Balance         | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <deb_netCons>           | 0.00            | 0.00           | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <deb_netCons*ratePrefT> | 0.00            | 0.00           | @same                          |

#######################################################v3#########################################################################################


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
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | Nostro Code | Depot Code | Nostro Bank | Depot Bank |
      | ~   | @same          | @same               | [empty]          | @same                   | 3             | @same              | UNSETTLED         | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | 0.00                     | 0.00                       | 0.00                                     | @same       | @same      | @same       | @same      |


    Given navigation to "Trades" page
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
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | Nostro Code | Depot Code | Nostro Bank | Depot Bank |
      | ~   | @same          | @same               | [empty]          | @same                   | 3             | @same              | UNSETTLED         | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | 0.00                     | 0.00                       | 0.00                                     | @same       | @same      | @same       | @same      |


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
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | <qty>           | <qty>                | 0               | @same          | @same    | @same                              | @same                        |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | <qty>           | <qty>                | 0               | @same          | @same    | @same                              | @same                        |
      | ~   | @same    | @same       | @same          | @same       | @same       | @same            | @same | @same | @same    | @same      | YES               | <totalqty>      | <totalqty>           | 0               | @same          | @same    | @same                              | @same                        |

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
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons>             | <deb_netCons>             |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons01>           | <deb_netCons01>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT>   | <deb_netCons*ratePrefT>   |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT01> | <deb_netCons*ratePrefT01> |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT>       | <deb_netCons*rateT>       |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT01>     | <deb_netCons*rateT01>     |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons02>           | <deb_netCons02>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT02> | <deb_netCons*ratePrefT02> |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT02>     | <deb_netCons*rateT02>     |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_c-trade_v3"
    And validate snapshot "cust01_c-trade_v2" against "cust01_c-trade_v3" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | [empty]          | 0.00                     | 0.00                                     | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | @same              | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | UNSETTLED         | @same  | @same       | @same          | @same      | 3             |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust02_c-trade_v3"
    And validate snapshot "cust02_c-trade_v2" against "cust02_c-trade_v3" on
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
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | 0.00            | <cre_netCons>           | <deb_netCons>           | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> | @same                          |

#######################################################v4#########################################################################################

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "cust01_c-trade_v4"
    And validate snapshot "cust01_c-trade_v3" against "cust01_c-trade_v4" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @same            | @same                    | @same                                    | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                                       | @same                            | @same             | CANCELLED          | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | @same             | @same  | @same       | @same          | @same      | 4             |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST02_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "cust02_c-trade_v4"
    And validate snapshot "cust02_c-trade_v3" against "cust02_c-trade_v4" on
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

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                  |
      | @context(CUST01_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "cust01_trade_v4"
    And validate snapshot "cust01_trade_v3" against "cust01_trade_v4" on
      | Ops | CustX Trade ID | Actual Sett Date | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same            | @same                   | 4             | CANCELLED          | @same             | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    |

    Given navigation to "Trades" page
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
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | 0.00            | 0.00           |

    Examples:
      ##############  CONFIG  ############## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | c-env             | c-username   | c-password | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType        | subAccount                    | baseCcy | direction | comp_direction | legalEntityCode | clientCode  | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCcy | settCountry | nostroBank01 | nostroCode01   | depotBank01 | depotCode01   | nostroBank02 | nostroCode02  | depotBank02 | depotCode02  | tradeQuantity | tradePrice | ccy | amount | netConsideration | qty   | price  | amt        | netCons    | totalnetCons | totalnetCons*ratePrefT | fxRate | netCons*rate | netCons*ratePref | secPriceT | secFxRateT | netCons*rateT | netCons*ratePrefT | deb_netCons | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons | cre_netCons*rateT | cre_netCons*ratePrefT | cre_netCons01 | cre_netCons*rateT01 | cre_netCons*ratePrefT01 | deb_netCons01 | deb_netCons*rateT01 | deb_netCons*ratePrefT01 | deb_netCons02 | deb_netCons*rateT02 | deb_netCons*ratePrefT02 | cre_netCons02 | cre_netCons*rateT02 | cre_netCons*ratePrefT02 | qty*price  | qty*price*secFxRateT | totalqty*price | totalqty*price*secFxRateT | cre_cash_unSett_gl               | deb_cash_unSett_gl          | cre_sec_unSett_gl                 | deb_sec_unSett_gl                      | cre_cash_sett_gl | deb_cash_sett_gl                 | cre_sec_sett_gl                        | deb_sec_sett_gl | settlementplacecode01 | settlementplacecode02 | totalqty |
      | client-defaultEnv | JohnDoeCPdvp | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | CP:SFL-EUR-AUS:DVP:T-2:BUY:FI | EUR     | BUY       | PAY            | SFL             | CP_DVP_Auto | CP_Auto_Testing_DVP     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | USD     | USA         | CITI         | CITTNostroCode | CITI        | CITIDepotCode | JPM          | JPMNostroCode | JPM         | JPMDepotCode | 1000          | 1          | USD | 10000  | 10001            | 1,000 | 1.0000 | -10,000.00 | -10,001.00 | -20,002.00   | -19,201.92             | 1.0000 | -10,001.00   | -9,700.97        | 173.0000  | 0.5000     | -10,001.00    | -19,201.92        | -20,002.00  | -20,002.00        | -19,201.92            | 0.00        | 0.00              | 0.00                  | 0.00          | 0.00                | 0.00                    | -10,001.00    | -10,001.00          | -9,600.96               | -10,001.00    | -10,001.00          | -9,600.96               | 0.00          | 0.00                | 0.00                    | 173,000.00 | 86,500.00            | 346,000.00     | 173,000.00                | Market Cash 'In Transit' Account | Custody Client Cash Account | Custody Client Securities Account | Market Securities 'In Transit' Account | Nostro Account   | Market Cash 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   | ACLRAU2S              | ADSEAEA1              | 2,000    |
