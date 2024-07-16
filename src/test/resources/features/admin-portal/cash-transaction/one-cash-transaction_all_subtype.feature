@Admin
@Regression
Feature: Admin portal

  Scenario Outline: Validate All trade sub type cash Transaction v1 on Cash Positions on Admin and Client portal

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And clear data for "<subAccount>"
    And FX rates from file ./src/test/resources/test-data/FxRates.csv

    Given navigation to "CSV Loader" page
    Then "CASH" CSV is uploaded successfully
      | FILE_TYPE | TRADE_STATUS | INTERMEDIARY_BANK | CounterpartyCode | CounterpartyBic | VALUE_DATE    | CLIENT_CODE  | CLIENT_MASTER_ACCOUNT_NAME | ClientSubAccount | SIDE    | LEGAL_ENTITY_CODE | AMOUNT | CURRENCY | COMMENT                              | TRADE_SUBTYPE                      | NOSTRO_BANK  | NOSTRO_CODE  | TraderId   | CustodianTradeRef |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 1      | JPY      | Test comment CT via csv Admin portal | Client Cash                        | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 2      | JPY      | Test comment CT via csv Admin portal | Client Cash Depot Dividend         | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 4      | JPY      | Test comment CT via csv Admin portal | Client Cash Claim Dividend         | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 8      | JPY      | Test comment CT via csv Admin portal | Client Cash Depot Coupon           | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 16     | JPY      | Test comment CT via csv Admin portal | Client Cash Claim Coupon           | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 32     | JPY      | Test comment CT via csv Admin portal | Client Cash Depot Corp Action      | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 64     | JPY      | Test comment CT via csv Admin portal | Client Cash Claim Corp Action      | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 128    | JPY      | Test comment CT via csv Admin portal | Stonex Safekeeping Transaction Fee | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 256    | JPY      | Test comment CT via csv Admin portal | Client Safekeeping Transaction Fee | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 512    | JPY      | Test comment CT via csv Admin portal | Safekeeping Transaction Fee P & L  | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 1024   | JPY      | Test comment CT via csv Admin portal | Stonex Safekeeping Portfolio Fee   | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 2048   | JPY      | Test comment CT via csv Admin portal | Client Safekeeping Portfolio Fee   | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 4096   | JPY      | Test comment CT via csv Admin portal | Safekeeping Portfolio Fee P & L    | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 8192   | JPY      | Test comment CT via csv Admin portal | Stonex Safekeeping Other Fee       | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 16384  | JPY      | Test comment CT via csv Admin portal | Client Safekeeping Other Fee       | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 32768  | JPY      | Test comment CT via csv Admin portal | Safekeeping Other Fee P & L        | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 65536  | JPY      | Test comment CT via csv Admin portal | Stonex Safekeeping Interest        | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 131072 | JPY      | Test comment CT via csv Admin portal | Client Safekeeping Interest        | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 262144 | JPY      | Test comment CT via csv Admin portal | Safekeeping Interest P & L         | <nostroBank> | <nostroCode> | @default() | @default()        |
      | CASH      | NEW          | BAML              | A123465798       | A1234567891     | @date(<date>) | <clientCode> | <clientMasterAccountName>  | <subAccount>     | RECEIVE | SFL               | 524288 | JPY      | Test comment CT via csv Admin portal | Operational Error P & L            | <nostroBank> | <nostroCode> | @default() | @default()        |

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective:   | COB Date           |
      | @option(~Any~) | @date(<valueDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "cash_position_v1"
    And validate snapshot "cash_position_v1" on
      | Perspective | Ccy       | Nostro       | Settled Balance | Pending Credits | Pending Debits |
      | Local       | <ccy>     | [empty]      | 0.00            | 149,887.00      | 0.00           |
      | Local       | <ccy>     | <nostroCode> | 0.00            | 75,007.00       | 0.00           |
      | Pref        | <baseCcy> | [empty]      | 0.00            | 257,805.64      | 0.00           |
      | Pref        | <baseCcy> | <nostroCode> | 0.00            | 129,012.04      | 0.00           |
      | Entity      | USD       | [empty]      | 0.00            | 257,805.64      | 0.00           |
      | Entity      | USD       | <nostroCode> | 0.00            | 129,012.04      | 0.00           |

    Given authentication on "<c-env>" with credentials "<c-username>" "<c-password>"

    Given navigation to "Cash Positions" page
    When search on "Cash Positions" by
      | Perspective: | COB Date           |
      | @option(ALL) | @date(<valueDate>) |
    When filter on "Cash Positions" by
      | Name        | Operator | Value        |
      | Sub Account | Equals   | <subAccount> |
    Then snapshot dataset "Cash Positions" as "c-cash_position_v1"
    And validate snapshot "c-cash_position_v1" on
      | COB Date           | Client Code  | Master Acc Name           | Sub Account  | Perspective | Ccy       | Settled Balance | Pending Credits | Pending Debits | Total Cash (Settled + Pending) |
      | @date(<valueDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Local       | <ccy>     | 0.00            | 149,887.00      | 0.00           | 149,887.00                     |
      | @date(<valueDate>) | <clientCode> | <clientCode>-<subAccount> | <subAccount> | Pref        | <baseCcy> | 0.00            | 257,805.64      | 0.00           | 257,805.64                     |

    Examples:
      | c-env             | c-username   | c-password | env              | username | password    | date | clientCode | clientMasterAccountName | valueDate | subAccount                   | ccy | baseCcy | nostroCode     | nostroBank |
      | client-defaultEnv | JohnDoeCPall | custx11*   | admin-defaultEnv | JohnDoe  | Password11* | T    | JPM        | JPM                     | T         | JPM:SFL-AUD-BEL:AllCTSubType | JPY | AUD     | CITINostroCode | CITI       |