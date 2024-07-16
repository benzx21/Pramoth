Feature: Local test

  Scenario Outline:

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv
    And Security prices from file ./src/test/resources/test-data/Prices.csv

    Given navigation to "CSV Loader" page
    Then "TRADE" CSV is uploaded successfully
      | FILE_TYPE | TradeCountryPerformed | TRADE_STATUS | SETTLEMENT_PLACE_NAME | SettlementPlaceCode | swift_counterparty_code | COUNTERPARTY_BIC | LegalEntityCode   | ClientCode   | ClientMasterAccountName   | BrokerCode   | TradeDate          | Isin   | SecurityType   | SecurityDescription   | TRADE_SUBTYPE  | ClientSubAccount | Side        | Quantity        | Price        | Currency | Amount   | SETTLEMENT_METHOD | SettlementDate    | SettlementCountry | SettlementCurrency | NOSTRO_BANK  | NOSTRO_CODE  | DEPOT_BANK  | DEPOT_CODE  | NET_CONSIDERATION  | TraderId   | CustodianTradeRef |
      | TRADE     | UK                    | NEW          | CREST                 | CRSTGB22            | SCC01                   | 01234567ABC      | <legalEntityCode> | <clientCode> | <clientMasterAccountName> | <brokerCode> | @date(<tradeDate>) | <isin> | <securityType> | <securityDescription> | <tradeSubType> | <subAccount>     | <direction> | <tradeQuantity> | <tradePrice> | <ccy>    | <amount> | <settMethod>      | @date(<settDate>) | <settCountry>     | <settCcy>          | <nostroBank> | <nostroCode> | <depotBank> | <depotCode> | <netConsideration> | @default() | @default()        |

    Given navigation to "Trades" page
    When filter on "Trades" by
      | Name                       | Operator | Value                                     |
      | Source Allocation Trade ID | Equals   | @context(LAST_SOURCE_ALLOCATION_TRADE_ID) |
    Then snapshot dataset "Trades" as "trade_v1"
    And validate snapshot "trade_v1" on
      | Actual Sett Date | Settlement Days Overdue | Trade Version | Is Late Settlement? | CustX Trade Status | Settlement Status | Swift Link Status | Quantity    | Price   | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Currency | Entity Cash Amount   | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) | DVP/FOP      | Sub Account  | Trade Currency | Direction   | Settlement Country | Asset Type     | Trade Sub-Type | Security Description  | ISIN   | Nostro Code  | Depot Code  |
      | [empty]          | [empty]                 | 1             | ✖                   | NEW                | UNSETTLED         | NOT_LINKED        | @abs(<qty>) | <price> | @abs(<netCons>)   | <amt>               | @abs(<netCons*ratePref>)     | <fxRate>       | USD             | @abs(<netCons*rate>) | <baseCcy>     | 0.00                     | 0.00                       | 0.00                                     | <settMethod> | <subAccount> | <ccy>          | <direction> | <settCountry>      | <securityType> | <tradeSubType> | <securityDescription> | <isin> | <nostroCode> | <depotCode> |
    And set param "LAST_CUSTODIAN_TRADE_REF" from dataset "trade_v1" with "Custodian Trade Ref" row 0

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
  :94B::TRAD//EXCH/XXXX
  :98A::TRAD//@date(<tradeDate>)
  :98A::ESET//@date(<settDate>)
  :90B::DEAL//ACTU/USD93,
  :35B:ISIN <isin>
  Google Inc.
  :16S:TRADDET
  :16R:FIAC
  :36B::ESTT//FAMT/@amount(<tradeQuantity>)
  :97A::SAFE//41329000010000464070K
  :97A::CASH//41329000010000464070K
  :94F::SAFE//ICSD/MGTCBEBEXXX
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
  :98A::VALU//@date(<tradeDate>)
  :16S:AMT
  :16S:SETDET
  -}
  """

    Given wait for 3000 msecs
    Then snapshot dataset "Trades" as "trade_v2"
    And validate snapshot "trade_v1" against "trade_v2" on
      | Ops | CustX Trade ID | Custodian Trade Ref | Actual Sett Date  | Settlement Days Overdue | Trade Version | CustX Trade Status | Settlement Status | Quantity | Price | Net Consideration | Gross Consideration | Net Consideration (Pref Ccy) | Entity FX Rate | Entity Cash Amount | Cash Pref CCY | Actual Settlement Amount | Entity Settled Cash Amount | Partially Settled Cash Amount (Pref CCY) |
      | ~   | @same          | @same               | @date(<settDate>) | @same                   | 2             | AMENDED            | SETTLED           | @same    | @same | @same             | @same               | @same                        | @same          | @same              | @same         | @abs(<netCons>)          | @abs(<netCons*rate>)       | @abs(<netCons*ratePref>)                 |

    Examples:
      | env        | username | password    | tradeDate | settDate | settMethod | tradeSubType        | subAccount                     | baseCcy | direction | comp_direction | legalEntityCode | clientCode | clientMasterAccountName | brokerCode | isin         | securityType | securityDescription | securityCcy | settCcy | nostroBank | nostroCode    | settCountry | depotBank | depotCode     | tradeQuantity | tradePrice | ccy | amount | netConsideration | qty   | price   | amt       | netCons    | fxRate | netCons*rate | netCons*ratePref | secPriceT | secFxRateT | netCons*rateT | netCons*ratePrefT | deb_netCons | deb_netCons*rateT | deb_netCons*ratePrefT | cre_netCons | cre_netCons*rateT | cre_netCons*ratePrefT | qty*price  | qty*price*secFxRateT | cre_cash_unSett_gl               | deb_cash_unSett_gl          | cre_sec_unSett_gl                 | deb_sec_unSett_gl                      | cre_cash_sett_gl | deb_cash_sett_gl                 | cre_sec_sett_gl                        | deb_sec_sett_gl |
      | admin-dev5 | JohnDoe  | Password11* | T-2       | T        | DVP        | Client Market Trade | JPM:SFL-USD-AUS:DVP:T-2:BUY:FI | USD     | BUY       | PAY            | SFL             | JPM        | JPM                     | SFL        | BE0000352618 | FIXED_INCOME | BEGV 10/22/31       | EUR         | USD     | BNPP       | DVPBUYFINCT-2 | USA         | BNPP      | DVPBUYFIDCT-2 | 1000          | 10         | USD | 10000  | 10001            | 1,000 | 10.0000 | 10,000.00 | -10,001.00 | 1.0000 | -10,001.00   | -10,001.00       | 173.0000  | 1.9200     | -10,001.00    | -10,001.00        | -10,001.00  | -10,001.00        | -10,001.00            | 0.00        | 0.00              | 0.00                  | 173,000.00 | 332,160.00           | Market Cash 'In Transit' Account | Custody Client Cash Account | Custody Client Securities Account | Market Securities 'In Transit' Account | Nostro Account   | Market Cash 'In Transit' Account | Market Securities 'In Transit' Account | Depot Account   |
