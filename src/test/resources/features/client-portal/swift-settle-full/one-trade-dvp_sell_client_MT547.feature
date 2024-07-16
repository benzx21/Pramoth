@Client
@Regression
Feature: Client portal

  Scenario Outline: CSV: Swift Settle SELL MT547 - Single Trade DVP v1...v4 in Trades, Ledger Postings and Securities Positions screens via Client profile

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SettlementPlaceCode | SETTLEMENT_PLACE_NAME | CounterpartyAccountNumber | COUNTERPARTY_BIC | CounterpartyCode | CounterpartyLocalCode | CustodianLocalCodeType | CounterpartyLocalCustodianAccountNumber | CounterpartyLocalCustodianBic | CounterpartyName | VenueId | ExchangeId | IntermediaryBank  | Comment                  | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | ClientSubAccount | Side        | Quantity        | Price        | Currency | Amount   | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NOSTRO_BANK  | NOSTRO_CODE  | DEPOT_BANK  | DEPOT_CODE  | NET_CONSIDERATION  | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | ACLRAU2S            | ACLRAU2S              | 123456789                 | CPTYBIC1234      | CPTYCode         | CPTYLocalCode         | CustLocalCodeType      | CPTYLocalCustAccNumber                  | CPTYLocBIC1                   | CPTYName         | VenueID | XEQT       | EUROCLEAR BELGIUM | csv upload client portal | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <nostroBank> | <nostroCode> | <depotBank> | <depotCode> | <netConsideration> | @default() | @default()        |

    Given authentication on "<c-env>" with credentials "<c1-username>" "<c1-password>"

    Given navigation to "Trades" page
    And click "Pending Trades" "tab"
    When filter on "Pending Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    And select on "Pending Trades" row 0
    And click "Approve" "button"

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v1"
    And validate snapshot "c-trade_v1" on
      | Trade Sub-Type | Actual Sett Date | Actual Settlement Amount | Partially Settled Cash Amount (Pref CCY) | Asset Type     | Cash Pref CCY | Client Code  | Contractual Sett Date | Counterparty Account Number | Counterparty BIC | Counterparty Code | Counterparty Local Code | Custodian Local Code Type | Counterparty Local Custodian Account Number | Counterparty Local Custodian Bic | Counterparty Name | CustX Trade Status | Depot Bank  | Depot Code  | Direction   | DVP/FOP      | Gross Consideration | Is Late Settlement? | ISIN   | Legal Entity Code (Custody) | Master Account            | Price   | Net Consideration | Net Consideration (Pref Ccy) | Nostro Bank  | Nostro Code  | Quantity    | Settlement Status | Source            | Sub Account  | Trade Currency | Trade Date         | Trade Version |
      | <tradeSubType> | [empty]          | 0.00                     | 0.00                                     | <securityType> | <baseCcy>     | <clientCode> | @date(<settDate>)     | 123456789                   | CPTYBIC1234      | CPTYCode          | CPTYLocalCode           | CustLocalCodeType         | CPTYLocalCustAccNumber                      | CPTYLocBIC1                      | CPTYName          | NEW                | <depotBank> | <depotCode> | <direction> | <settMethod> | <amt>               | ✖                   | <isin> | <legalEntityCode>           | <clientMasterAccountName> | <price> | <netCons>         | @abs(<netCons*ratePref>)     | <nostroBank> | <nostroCode> | @abs(<qty>) | UNSETTLED         | CLIENT_CSV_UPLOAD | <subAccount> | <ccy>          | @date(<tradeDate>) | 1             |
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
    When filter on "Trades" by
      | Name           | Operator | Value                         |
      | CustX Trade ID | Equals   | @context(LAST_CUSTX_TRADE_ID) |
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
      | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name      | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <deb_sec_unSett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <cre_sec_unSett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <cre_cash_unSett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <deb_cash_unSett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    When swift inbound
    """
{1:F01PARBFRPPDXXX0001000000}{2:I547IGLUGB2LXXXXN}{3:{108:ISI419041B2P9000}}{4:
:16R:GENL
:20C::SEME//@context(LAST_CUSTODIAN_TRADE_REF)
:23G:NEWM
:98C::PREP//20220210072512
:16R:LINK
:13A::LINK//543
:20C::RELA//@context(LAST_CUSTODIAN_TRADE_REF)
:16S:LINK
:16S:GENL
:16R:TRADDET
:94B::TRAD//EXCH/XXXX
:98A::TRAD//@date(<tradeDate>)
:98A::ESET//@date(<settDate>)
:90B::DEAL//ACTU/<settCcy>@amount(<tradePrice>)
:35B:ISIN <isin>
PORSCHE AUTOM.HLDG VZO
:16S:TRADDET
:16R:FIAC
:36B::ESTT//UNIT/@amount(<tradeQuantity>)
:97A::SAFE//41329000010000464070K
:97A::CASH//41329000010000464070K
:94F::SAFE//CUST/PARBGB2LXXX
:16S:FIAC
:16R:SETDET
:22F::SETR//TRAD
:16R:SETPRTY
:95R::REAG/CRST/ATMAY
:16S:SETPRTY
:16R:SETPRTY
:95P::BUYR//SNGRGB21XXX
:16S:SETPRTY
:16R:SETPRTY
:95P::PSET//CRSTGB22XXX
:16S:SETPRTY
:16R:AMT
:19A::ESTT//<settCcy>@amount(<netCons>)
:98A::VALU//@date(<settDate>)
:16S:AMT
:16S:SETDET
-}
  """

    Given wait for 3000 msecs


    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
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
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name    | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <deb_sec_sett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <cre_sec_sett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <cre_cash_sett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <deb_cash_sett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v2"
    And validate snapshot "c-trade_v1" against "c-trade_v2" on
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
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name    | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same              | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <cre_sec_sett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <deb_sec_sett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <deb_cash_sett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <cre_cash_sett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Trades" as "c-trade_v3"
    And validate snapshot "c-trade_v2" against "c-trade_v3" on
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
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction        | GL Account Name      | Source            | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same            | @same                | @same             | @same       | @same         | @same    | @same               | @same   | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction>      | <cre_sec_unSett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction>      | <deb_sec_unSett_gl>  | CLIENT_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | CASH             | <comp_direction> | <deb_cash_unSett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | CASH             | <comp_direction> | <cre_cash_unSett_gl> | CLIENT_CSV_UPLOAD | [empty]     | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |


    Examples:
      ##############  CONFIG  ############## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | c-env             | c-username                 | c-password | c1-username                 | c1-password | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType        | subAccount                         | baseCcy | direction | comp_direction | legalEntityCode | clientCode             | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCcy | nostroBank | nostroCode    | settCountry | depotBank | depotCode    | tradeQuantity | tradePrice | ccy | amount | netConsideration | qty    | price  | amt    | netCons  | fxRate | netCons*rate | netCons*ratePref | secPriceT | secFxRateT | netCons*rateT | netCons*ratePrefT | deb_netCons | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons | cre_netCons*rateT | cre_netCons*ratePrefT | qty*price | qty*price*secFxRateT | cre_cash_unSett_gl          | deb_cash_unSett_gl               | cre_sec_unSett_gl                      | deb_sec_unSett_gl                 | cre_cash_sett_gl                 | deb_cash_sett_gl | cre_sec_sett_gl | deb_sec_sett_gl                        |
      | client-defaultEnv | JohnDoeCPSwiftSettleClient | custx11*   | JohnDoeCPSwiftSettleClient2 | custx11*    | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | CP:csv:SFL-GBP-BEL:DVP:T-2:SELL:EQ | GBP     | SELL      | RECEIVE        | SFL             | Auto_Swift_Full_Settle | Auto_Swift_Settle_Full  | SFL        | NL0000235190 | EQUITY       | AIRBUS              | EUR         | EUR     | BNY        | BNYNostroCode | FRA         | BNY       | BNYDepotCode | 1000          | 1          | EUR | 999    | 1000             | -1,000 | 1.0000 | 999.00 | 1,000.00 | 1.9400 | 1,940.00     | 1,940.00         | 0.7713    | 1.9200     | 1,920.00      | 1,920.00          | 0.00        | 0.00              | 0.00                  | 1,000.00    | 1,920.00          | 1,920.00              | -771.30   | -1,480.90            | Custody Client Cash Account | Market Cash 'In Transit' Account | Market Securities 'In Transit' Account | Custody Client Securities Account | Market Cash 'In Transit' Account | Nostro Account   | Depot Account   | Market Securities 'In Transit' Account |
