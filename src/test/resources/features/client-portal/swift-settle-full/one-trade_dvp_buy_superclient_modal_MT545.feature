@Client
@Regression
Feature: Client portal

  Scenario Outline: Swift Settle BUY MT545 Modal DVP trough v1...v4 in Trades, Securities Positions, Cash Positions and Ledger Postings screens (Super Client)

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
      | Settlement Currency: *              | <ccy>                     |
      | Settlement Country                  | <settCountry>             |
      | Place of Settlement Code: *         | ACLRAU2S                  |
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
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v1"
    And validate snapshot "c-trade_v1" on
      | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type     | Cash Pref CCY | Client Code  | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank  | Depot Code  | Direction   | DVP/FOP      | Gross Consideration | Is Late Settlement? | ISIN   | Legal Entity Code (Custody) | Master Account            | Price   | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank  | Nostro Code  | Quantity    | Settlement Status | Source    | Sub Account  | Trade Currency | Trade Date         | Trade Version |
      | <tradeSubType> | [empty]          | 0.00                     | 0.00                                     | <securityType> | <baseCcy>     | <clientCode> | @date(<settDate>)     | 123456789                   | CPTYBIC1234      | CPTYCode          | CPTYLocalCode           | CustLocalCodeType         | CPTYLocBIC1                      | CPTYName          | NEW                | <depotBank> | <depotCode> | <direction> | <settMethod> | <amt>               | ✖                   | <isin> | <legalEntityCode>           | <clientMasterAccountName> | <price> | <netCons>         | @abs(<netCons*ratePref>)     | <nostroBank> | <nostroCode> | @abs(<qty>) | UNSETTLED         | CLIENT_UI | <subAccount> | <ccy>          | @date(<tradeDate>) | 1             |
    And set param "LAST_CUSTX_TRADE_ID" from dataset "c-trade_v1" with "CustX Trade ID" row 0


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
      | @date(<settDate>) | <clientCode>-<subAccount> | <clientCode> | <clientMasterAccountName> | <securityType> | <isin> | <qty>           | <qty>                | 0               | YES               | <securityCcy>  | <baseCcy> | <secPriceT>          | <qty*price>                        | <qty*price*secFxRateT>       | <secFxRateT>                         |

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
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Local       | <ccy>     | 0.00            | <cre_netCons>           | <deb_netCons>           | <netCons>                      |
      | @date(<settDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Pref        | <baseCcy> | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> | <netCons*ratePrefT>            |

    Given authentication on "<env>" with credentials "<username>" "<password>"

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "trade_v1"
    And validate snapshot "trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount   | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code  | Depot Code  |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | @abs(<amt>)         | @abs(<netCons*ratePref>)     | <fxRate>       | USD             | @abs(<netCons*rate>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode> | <depotCode> |
    And set param "LAST_CUSTX_TRADE_ID" from dataset "trade_v1" with "CustX Trade ID" row 0
    And set param "LAST_CUSTODIAN_TRADE_REF" from dataset "trade_v1" with "Custodian Trade Ref" row 0

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

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v1"
    And validate snapshot "cash_position_v1" on
      | COB Date          | Client Code  | Master Acc                | Sub Account  | Perspective | Ccy       | Nostro       | Settled Balance | Pending Credits         | Pending Debits          |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy>     | [empty]      | 0.00            | <cre_netCons>           | <deb_netCons>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Local       | <ccy>     | <nostroCode> | 0.00            | <cre_netCons>           | <deb_netCons>           |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | [empty]      | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Pref        | <baseCcy> | <nostroCode> | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | [empty]      | 0.00            | <cre_netCons*rateT>     | <deb_netCons*rateT>     |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | Entity      | USD       | <nostroCode> | 0.00            | <cre_netCons*rateT>     | <deb_netCons*rateT>     |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v1"
    And validate snapshot "ledger_posting_v1" on
      | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name      | Source    | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <deb_sec_unSett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <cre_sec_unSett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <cre_cash_unSett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <deb_cash_unSett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |


    When swift inbound
    """
  {1:F01PARBFRPPDXXX0001000000}{2:I545IGLUGB2LXXXXN}{3:{108:ISI419041A5GD000}}{4:
  :16R:GENL
  :20C::SEME//@context(LAST_CUSTODIAN_TRADE_REF)
  :23G:NEWM
  :16R:LINK
  :13A::LINK//541
  :20C::RELA//@context(LAST_CUSTODIAN_TRADE_REF)
  :16S:LINK
  :16S:GENL
  :16R:TRADDET
 :98A::TRAD//@date(<tradeDate>)
  :98A::ESET//@date(<settDate>)
  :90B::DEAL//ACTU/<settCcy>@amount(<tradePrice>)
  :35B:ISIN <isin>
  Google Inc.
  :16S:TRADDET
  :16R:FIAC
  :36B::ESTT//UNIT/@amount(<tradeQuantity>)
  :97A::SAFE//41329000010000464070K
  :97A::CASH//41329000010000464070K
  :16S:FIAC
  :16R:SETDET
  :22F::SETR//TRAD
  :16R:SETPRTY
  :95R::DEAG/CEDE/71208
  :16S:SETPRTY
  :16R:SETPRTY
  :95P::SELL//FETALULLISV
  :16S:SETPRTY
  :16R:SETPRTY
  :95P::PSET//CEDELULLXXX
  :16S:SETPRTY
  :16R:AMT
  :19A::ESTT//<settCcy>@amount(<netCons>)
  :16S:AMT
  :16S:SETDET
  -}
  """

    Given wait for 3000 msecs

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    Then snapshot dataset "Trades" as "trade_v2"
    And validate snapshot "trade_v1" against "trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | Swift Link Status | Settlement Instruction Status |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @abs(<netCons>)          | @abs(<netCons*rate>)       | @abs(<netCons*ratePref>)                 | AUTO_MATCHED      | PARC                          |


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

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v2"
    And validate snapshot "cash_position_v1" against "cash_position_v2" on
      | Ops | COB Date | Client Code | Master Acc | Sub Account | Perspective | Ccy   | Nostro | Settled Balance     | Pending Credits | Pending Debits |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <netCons>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <netCons>           | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <netCons*ratePrefT> | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <netCons*ratePrefT> | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <netCons*rateT>     | 0.00            | 0.00           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | <netCons*rateT>     | 0.00            | 0.00           |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v2"
    And validate snapshot "ledger_posting_v1" against "ledger_posting_v2" on
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name    | Source    | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <deb_sec_sett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <cre_sec_sett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <cre_cash_sett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <deb_cash_sett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v2"
    And validate snapshot "c-trade_v1" against "c-trade_v2" on
      | Ops | Trade Sub-Type | Actual Sett Date  | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @date(<settDate>) | @abs(<netCons>)          | @abs(<netCons*ratePref>)                 | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                            | @same             | AMENDED            | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | SETTLED           | @same  | @same       | @same          | @same      | 2             |

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
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <netCons>           | 0.00            | 0.00           | @same                          |
      | ~   | @same    | @same       | @same           | @same       | @same       | @same | <netCons*ratePrefT> | 0.00            | 0.00           | @same                          |

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

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date          |
      | @option(~Any~) | @date(<settDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v3"
    And validate snapshot "cash_position_v2" against "cash_position_v3" on
      | Ops | COB Date | Client Code | Master Acc | Sub Account | Perspective | Ccy   | Nostro | Settled Balance | Pending Credits         | Pending Debits          |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons>           | <deb_netCons>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons>           | <deb_netCons>           |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*ratePrefT> | <deb_netCons*ratePrefT> |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT>     | <deb_netCons*rateT>     |
      | ~   | @same    | @same       | @same      | @same       | @same       | @same | @same  | 0.00            | <cre_netCons*rateT>     | <deb_netCons*rateT>     |

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v3"
    And validate snapshot "ledger_posting_v2" against "ledger_posting_v3" on
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name    | Source    | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <cre_sec_sett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <deb_sec_sett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <deb_cash_sett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <cre_cash_sett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v3"
    And validate snapshot "c-trade_v2" against "c-trade_v3" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | [empty]          | 0.00                     | 0.00                                     | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                            | @same             | @same              | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | UNSETTLED         | @same  | @same       | @same          | @same      | 3             |

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

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
    Then snapshot dataset "Trades" as "c-trade_v4"
    And validate snapshot "c-trade_v3" against "c-trade_v4" on
      | Ops | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type | Cash Pref CCY | Client Code | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank | Depot Code | Direction | DVP/FOP | Gross Consideration | Is Late Settlement? | ISIN  | Legal Entity Code (Custody) | Master Account | Price | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank | Nostro Code | Quantity | Settlement Status | Source | Sub Account | Trade Currency | Trade Date | Trade Version |
      | ~   | @same          | @same            | @same                    | @same                                    | @same      | @same         | @same       | @same                 | @same                       | @same            | @same             | @same                   | @same                     | @same                            | @same             | CANCELLED          | @same      | @same      | @same     | @same   | @same               | @same               | @same | @same                       | @same          | @same | @same             | @same                        | @same       | @same       | @same    | @same             | @same  | @same       | @same          | @same      | 4             |

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

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v4"
    And validate snapshot "ledger_posting_v3" against "ledger_posting_v4" on
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name      | Source    | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same     | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <cre_sec_unSett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <deb_sec_unSett_gl>  | CLIENT_UI | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <deb_cash_unSett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <cre_cash_unSett_gl> | CLIENT_UI | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    Examples:
      ##############  CONFIG  ############## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | c-env             | c-username           | c-password | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType        | subAccount                        | baseCcy | direction | comp_direction | legalEntityCode | clientCode             | clientMasterAccountName | isin         | securityType | securityDescription | securityCcy | settCcy | nostroBank | nostroCode    | settCountry | depotBank | depotCode    | tradeQuantity | tradePrice | ccy | amount | netConsideration | qty   | price  | amt        | netCons    | fxRate | netCons*rate | netCons*ratePref | secPriceT | secFxRateT | netCons*rateT | netCons*ratePrefT | deb_netCons | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons | cre_netCons*rateT | cre_netCons*ratePrefT | qty*price  | qty*price*secFxRateT | cre_cash_unSett_gl               | deb_cash_unSett_gl          | cre_sec_unSett_gl                 | deb_sec_unSett_gl                      | cre_cash_sett_gl | deb_cash_sett_gl                 | cre_sec_sett_gl                        | deb_sec_sett_gl |
      | client-defaultEnv | JohnDoeCPSwiftSettle | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | CP:mod:SFL-GBP-BEL:DVP:T-2:BUY:FI | GBP     | BUY       | PAY            | SFL             | Auto_Swift_Full_Settle | Auto_Swift_Settle_Full  | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | JPY     | BNY        | BNYNostroCode | JPN         | BNY       | BNYDepotCode | 1000          | 1          | JPY | 10000  | 10001            | 1,000 | 1.0000 | -10,000.00 | -10,001.00 | 1.7400 | -17,401.74   | -4,200.42        | 173.0000  | 1.9200     | -17,201.72    | -4,100.41         | -10,001.00  | -17,201.72        | -4,100.41             | 0.00        | 0.00              | 0.00                  | 173,000.00 | 332,160.00           | Market Cash 'In Transit' Account | Custody Client Cash Account | Custody Client Securities Account | Market Securities 'In Transit' Account | Nostro Account   | Market Cash 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
