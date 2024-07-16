@Admin
#@Regression
Feature: Admin portal

  Scenario Outline: Validate basic upload of Spire trade

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | TRADE_SUBTYPE  | ClientSubAccount | Side        | Quantity        | Price        | Currency | Amount   | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NOSTRO_BANK  | NOSTRO_CODE  | DEPOT_BANK  | DEPOT_CODE  | NET_CONSIDERATION  | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | CREST                 | ACLRAU2S            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <nostroBank> | <nostroCode> | <depotBank> | <depotCode> | <netConsideration> | @default() | @default()        |

    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | TRADE_SUBTYPE              | ClientSubAccount | Quantity               | Price        | Currency | Amount               | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NOSTRO_BANK  | NOSTRO_CODE  | DEPOT_BANK  | DEPOT_CODE  | NET_CONSIDERATION              | TraderId   | SOURCE_OF_FINANCING_TRADE_ID | SOURCE_OF_FINANCING_PARENT_TRADE_ID | CustodianTradeRef | GROSS_DIV_PERCENT |
      | TRADE     | UK                    | NEW          | CREST                 | ACLRAU2S            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <spireTradeSubTypeOn>      | <subAccount>     | <spireQuantityOn>      | <spirePrice> | <ccy>    | <spireamountOn>      | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <nostroBank> | <nostroCode> | <depotBank> | <depotCode> | <spirenetConsiderationOn>      | @default() | 1                            | 1                                   | @default()        | 2.1231            |
      | TRADE     | UK                    | NEW          | CREST                 | ACLRAU2S            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <spireTradeSubTypeClosing> | <subAccount>     | <spireQuantityClosing> | <spirePrice> | <ccy>    | <spireamountClosing> | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <nostroBank> | <nostroCode> | <depotBank> | <depotCode> | <spirenetConsiderationClosing> | @default() | 1                            | 1                                   | @default()        | 2.1231            |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name           | Operator | Value                 |
      | Sub Account    | Equals   | <subAccount>          |
      | Trade Sub-Type | Equals   | <spireTradeSubTypeOn> |
    Then snapshot dataset "Trades" as "trade_v1"
    And validate snapshot "trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity           | Price        | Net Consideration      | Gross Consideration | Net Consideration (Pref Ccy)    | Entity FX Rate | Entity Currency | Entity Cash Amount          | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction          | Settlement Country | Asset Type     | Trade Sub-Type        | Security Description  | ISIN   | Nostro Code  | Depot Code  | Source of Financing Trade ID | Source of Financing Parent Trade ID |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<spireqtyOn>) | <spireprice> | @abs(<spirenetConsOn>) | <spireamtOn>        | @abs(<spirenetConsOn*ratePref>) | <fxRate>       | USD             | @abs(<spirenetConsOn*rate>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <spiredirectionOn> | <settCountry>      | <securityType> | <spireTradeSubTypeOn> | <securityDescription> | <isin> | <nostroCode> | <depotCode> | 1                            | 1                                   |
    And set param "CUSTX_TRADE_ID_Spire01" from dataset "trade_v1" with "CustX Trade ID" row 0

    When filter on "Trades" by
      | Name           | Operator | Value                      |
      | Sub Account    | Equals   | <subAccount>               |
      | Trade Sub-Type | Equals   | <spireTradeSubTypeClosing> |
    Then snapshot dataset "Trades" as "trade_v1"
    And validate snapshot "trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity                | Price        | Net Consideration           | Gross Consideration | Net Consideration (Pref Ccy)         | Entity FX Rate | Entity Currency | Entity Cash Amount               | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction               | Settlement Country | Asset Type     | Trade Sub-Type             | Security Description  | ISIN   | Nostro Code  | Depot Code  | Source of Financing Trade ID | Source of Financing Parent Trade ID |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<spireqtyClosing>) | <spireprice> | @abs(<spirenetConsClosing>) | <spireamtClosing>   | @abs(<spirenetConsClosing*ratePref>) | <fxRate>       | USD             | @abs(<spirenetConsClosing*rate>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <spiredirectionClosing> | <settCountry>      | <securityType> | <spireTradeSubTypeClosing> | <securityDescription> | <isin> | <nostroCode> | <depotCode> | 1                            | 1                                   |
    And set param "CUSTX_TRADE_ID_Spire02" from dataset "trade_v1" with "CustX Trade ID" row 0

    Given navigation to "Securities Positions" page
    When search on "Securities Positions" by
      | COB Date          |
      | @date(<settDate>) |
    When filter on "Securities Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Securities Positions" as "security_position_v1"
    And validate snapshot "security_position_v1" on
      | COB Date          | Client Code  | Master Account            | Sub Account  | Perspective | Perspective Code | Position Type | ISIN   | Depot       | Security              | Asset Type     | Unsettled Trades? | Traded Quantity | Contractual Sett Qty | Actual Sett Qty | Indicative Ccy | Base Ccy  | Indicative COB Price | Fx Rate (Indicative ccy to Base ccy) | Current MTM Value (Underlying Ccy) | Current MTM Value (Base Ccy) |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CUSTODIAN   | <depotBank>      | [empty]       | <isin> | <depotCode> | <securityDescription> | <securityType> | YES               | <qty01>         | <qty01>              | 0               | <baseCcy>      | <baseCcy> | <secPriceT>          | 1.0000                               | <qty*price*secFxRateT>             | <qty*price*secFxRateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CLIENT      | <clientCode>     | [empty]       | <isin> | [empty]     | <securityDescription> | <securityType> | YES               | <qty01>         | <qty01>              | 0               | <securityCcy>  | <baseCcy> | <secPriceT>          | <secFxRateT>                         | <qty*price>                        | <qty*price*secFxRateT>       |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CUSTODIAN   | <depotBank>      | Repo          | <isin> | <depotCode> | <securityDescription> | <securityType> | YES               | <spireqty>      | <spireqty>           | 0               | <baseCcy>      | <baseCcy> | <secPriceT>          | 1.0000                               | <spireqty*price*secFxRateT>        | <spireqty*price*secFxRateT>  |
      | @date(<settDate>) | <clientCode> | <clientMasterAccountName> | <subAccount> | CLIENT      | <clientCode>     | Repo          | <isin> | [empty]     | <securityDescription> | <securityType> | YES               | <spireqty>      | <spireqty>           | 0               | <securityCcy>  | <baseCcy> | <secPriceT>          | <secFxRateT>                         | <spireqty*price>                   | <spireqty*price*secFxRateT>  |

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
      | CustX Trade ID                   |
      | @context(CUSTX_TRADE_ID_Spire01) |
    Then snapshot dataset "Ledger Postings" as "spire01_ledger_posting_v1"
    And validate snapshot "spire01_ledger_posting_v1" on
      | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type        | Credit Or Debit | Cash or Security | Direction               | GL Account Name      | Source           | Quantity           | Cash/Security Amount | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeOn> | DEBIT           | SECURITY         | <spiredirectionOn>      | <deb_sec_unSett_gl>  | ADMIN_CSV_UPLOAD | @abs(<spireqtyOn>) | <spireqtydpOn>       | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeOn> | CREDIT          | SECURITY         | <spiredirectionOn>      | <cre_sec_unSett_gl>  | ADMIN_CSV_UPLOAD | @abs(<spireqtyOn>) | <spireqtydpOn>       | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeOn> | CREDIT          | CASH             | <comp_spiredirectionOn> | <cre_cash_unSett_gl> | ADMIN_CSV_UPLOAD | [empty]            | <spireamtOn>         | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeOn> | DEBIT           | CASH             | <comp_spiredirectionOn> | <deb_cash_unSett_gl> | ADMIN_CSV_UPLOAD | [empty]            | <spireamtOn>         | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |


    When search on "Ledger Postings" by
      | CustX Trade ID                   |
      | @context(CUSTX_TRADE_ID_Spire02) |
    Then snapshot dataset "Ledger Postings" as "spire02_ledger_posting_v1"
    And validate snapshot "spire02_ledger_posting_v1" on
      | Posting Date | Value Date        | Client Sub Account Name | Trade Sub-Type             | Credit Or Debit | Cash or Security | Direction                    | GL Account Name      | Source           | Quantity                | Cash/Security Amount | Cash Currency | Currency | Settlement Currency | ISIN    | Security Description  | Depot/Nostro Code |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeClosing> | DEBIT           | SECURITY         | <spiredirectionClosing>      | <cre_sec_unSett_gl>  | ADMIN_CSV_UPLOAD | @abs(<spireqtyClosing>) | <spireqtydpClosing>  | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeClosing> | CREDIT          | SECURITY         | <spiredirectionClosing>      | <deb_sec_unSett_gl>  | ADMIN_CSV_UPLOAD | @abs(<spireqtyClosing>) | <spireqtydpClosing>  | [empty]       | [empty]  | [empty]             | <isin>  | <securityDescription> | <depotCode>       |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeClosing> | CREDIT          | CASH             | <comp_spiredirectionClosing> | <deb_cash_unSett_gl> | ADMIN_CSV_UPLOAD | [empty]                 | <spireamtClosing>    | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |
      | @date(T)     | @date(<settDate>) | <subAccount>            | <spireTradeSubTypeClosing> | DEBIT           | CASH             | <comp_spiredirectionClosing> | <cre_cash_unSett_gl> | ADMIN_CSV_UPLOAD | [empty]                 | <spireamtClosing>    | <ccy>         | <ccy>    | <settCcy>           | [empty] | [empty]               | <nostroCode>      |

    Examples:
      ##############  CONFIG  ############## ********************************************************************************************************************************************************************************************  TRADE  ******************************************************************************************************************************************************************************************** ############  Formatted(Amounts)  ########### *************************************  Aggregations(Expected results)  ************************************* ############################################################################################################################################     GL ACCOUNT NAMES     ############################################################################################################################################
      | env              | username | password    | tradeDate | settDate | settMethod | tradeSubType        | spireTradeSubTypeOn | spireTradeSubTypeClosing | subAccount                  | baseCcy | direction | spiredirectionOn | spiredirectionClosing | comp_direction | comp_spiredirectionOn | comp_spiredirectionClosing | legalEntityCode | clientCode        | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCcy | nostroBank | nostroCode    | settCountry | depotBank | depotCode    | tradeQuantity | spireQuantityOn | spireQuantityClosing | tradePrice | spirePrice | ccy | amount | spireamountOn | spireamountClosing | netConsideration | spirenetConsiderationOn | spirenetConsiderationClosing | qty   | qty01 | spireqty | spireqtyOn | spireqtyClosing | spireqtydpOn | spireqtydpClosing | spireprice | spireamtOn | spireamtClosing | spirenetConsOn | spirenetConsClosing | fxRate | spirenetConsOn*rate | spirenetConsClosing*rate | spirenetConsOn*ratePref | spirenetConsClosing*ratePref | secPriceT | secFxRateT | deb_netCons | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons | cre_netCons*rateT | cre_netCons*ratePrefT | qty*price  | qty*price*secFxRateT | spireqty*price | spireqty*price*secFxRateT | cre_cash_unSett_gl          | deb_cash_unSett_gl               | cre_sec_unSett_gl                      | deb_sec_unSett_gl                 | cre_cash_sett_gl | deb_cash_sett_gl                 | cre_sec_sett_gl                        | deb_sec_sett_gl |
      | admin-defaultEnv | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | Repo On Leg         | Repo Closing Leg         | Auto:Spire:Repo:dvp:T-2:buy | AUD     | BUY       | SELL             | BUY                   | PAY            | RECEIVE               | PAY                        | SFL             | Auto_Spire_Trades | Auto_Spire_DVP          | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | JPY     | BNY        | BNYNostroCode | JPN         | BNY       | BNYDepotCode | 1000          | 100             | 50                   | 10         | 10         | JPY | 10000  | 1000          | 500                | 10001            | 1000                    | 500                          | 1,000 | 950   | 50       | 100        | 50              | 100.00       | 50.00             | 10.0000    | 1,000.00   | 500.00          | 1,000.00       | 500.00              | 1.7400 | 1,740.00            | 870.00                   | 1,740.00                | 870.00                       | 173.0000  | 1.7200     | -10,501.00  | -18,061.72        | -18,061.72            | 1,000.00    | 1,720.00          | 1,720.00              | 164,350.00 | 282,682.00           | 8,650.00       | 14,878.00                 | Custody Client Cash Account | Market Cash 'In Transit' Account | Market Securities 'In Transit' Account | Custody Client Securities Account | Nostro Account   | Market Cash 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
