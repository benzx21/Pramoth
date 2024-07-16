@Admin
@Regression
Feature: Admin portal

  Scenario Outline: MT544 Validate Swift settle of FOP BUY trough v1...v4 in Trades, Securities Positions, Ledger Postings screens

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | TRADE_SUBTYPE  | ClientSubAccount | Side        | Quantity        | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | DEPOT_BANK  | DEPOT_CODE  | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <settMethod>      | @date(<settDate>) | <settCountry>     | <depotBank> | <depotCode> | @default() | @default()        |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name                       | Operator | Value                                     |
      | Source Allocation Trade ID | Equals   | @context(LAST_SOURCE_ALLOCATION_TRADE_ID) |
    Then snapshot dataset "Trades" as "trade_v1"
    And validate snapshot "trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price  | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Depot Code  |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | 0.0000 | 0.00              | 0.00                | [empty]                      | [empty]        | USD             | [empty]            | <baseCcy>     | 0.00                     | [empty]                    | [empty]                                  | <settMethod> | <subAccount> | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <depotCode> |
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

    Given navigation to "Ledger Postings" page
    When search on "Ledger Postings" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    When filter on "Ledger Postings" by
      | Name                    | Operator | Value        |
      | Client Sub Account Name | Equals   | <subAccount> |
    Then snapshot dataset "Ledger Postings" as "ledger_posting_v1"
    And validate snapshot "ledger_posting_v1" on
      | Posting Date | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name     | Source           | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | @date(T)     | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <deb_sec_unSett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | @date(T)     | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <cre_sec_unSett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

    When swift inbound
    """
  {1:F01PARBFRPPDXXX0001000000}{2:I544IGLUGB2LXXXXN}{3:{108:ISI419039CJAF000}}{4:
  :16R:GENL
  :20C::SEME//@context(LAST_CUSTODIAN_TRADE_REF)
  :23G:NEWM
  :16R:LINK
  :20C::RELA//@context(LAST_CUSTODIAN_TRADE_REF)
  :16S:LINK
  :16S:GENL
  :16R:TRADDET
  :98A::TRAD//@date(<tradeDate>)
  :98A::ESET//@date(<settDate>)
  :35B:ISIN <isin>
  BEGV 10/22/31
  :16S:TRADDET
  :16R:FIAC
  :36B::ESTT//UNIT/@amount(<tradeQuantity>)
  :97A::SAFE//41329000010000464070K
  :97A::CASH//41329000010000464070K
  :16S:FIAC
  :16R:SETDET
  :22F::SETR//TRAD
  :16R:SETPRTY
  :95R::DEAG/ECLR/93391
  :16S:SETPRTY
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
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @same                    | @same                      | @same                                    | AUTO_MATCHED      | PARC                          |

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
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name   | Source           | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <deb_sec_sett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <cre_sec_sett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

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
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name   | Source           | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same             | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <cre_sec_sett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <deb_sec_sett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |

    Given navigation to "Trades" page
    When search on "Trades" by
      | CustX Trade ID                |
      | @context(LAST_CUSTX_TRADE_ID) |
    And select on "Trades" row 0
    And click "Cancel" "button"
    And submit dialog "Confirm Cancellation" using "Confirm" button
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
      | Ops | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type | Credit Or Debit | Cash or Security | Direction   | GL Account Name     | Source           | Quantity    | Cash Currency | Currency | Settlement Currency | ISIN   | Security Description  | Depot/Nostro Code |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | =   | @same        | @same             | @same                   | @same          | @same           | @same            | @same       | @same               | @same            | @same       | @same         | @same    | @same               | @same  | @same                 | @same             |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | DEBIT           | SECURITY         | <direction> | <cre_sec_unSett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |
      | +   | @date(T)     | @date(<settDate>) | <subAccount>            | <tradeSubType> | CREDIT          | SECURITY         | <direction> | <deb_sec_unSett_gl> | ADMIN_CSV_UPLOAD | @abs(<qty>) | [empty]       | [empty]  | [empty]             | <isin> | <securityDescription> | <depotCode>       |


    Examples:
      ##############  CONFIG  ############## *******************************************************************************************************************************************  TRADE  ****************************************************************************************************************************************** ###### Formatted(Amounts) ###### *** Aggregations(Expected results) *** ##################################################################     GL ACCOUNT NAMES     ##################################################################
      | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType          | subAccount                        | baseCcy | direction | legalEntityCode | clientCode             | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCountry | depotBank | depotCode    | tradeQuantity | qty   | secPriceT | secFxRateT | qty*price  | qty*price*secFxRateT | cre_sec_unSett_gl                 | deb_sec_unSett_gl                      | cre_sec_sett_gl                        | deb_sec_sett_gl |
      | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | FOP        | Client Securities Fop | AP:csv:SFL-GBP-BEL:FOP:T-2:BUY:FI | GBP     | BUY       | SFL             | Auto_Swift_Full_Settle | Auto_Swift_Settle_Full  | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | USA         | BNY       | BNYDepotCode | 1000          | 1,000 | 173.0000  | 1.9200     | 173,000.00 | 332,160.00           | Custody Client Securities Account | Market Securities 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
