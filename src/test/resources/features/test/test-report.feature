Feature: Local test

  Scenario Outline:

    Given authentication on "<env>" with credentials "<username>" "<password>"
    And execute "EVENT_EXPORT_SETTLED_SECURITY_POSITIONS_EOD" report

    Given navigation to "Trades" page
    When search on "Trades" by
      | Client Code  |
      | <clientCode> |
    When filter on "Trades" by
      | Name        | Operator | Value                  | Condition | Other Operator | Other Value            |
      | Sub Account | Contains | AP:SFL-GBP-BEL:DVP:T-2 | OR        | Contains       | AP:SFL-GBP-BEL:FOP:T-2 |
    #Since the UI doesn't active the AutoSettle button when click all checkbox
    And select on "Trades" row 0
    #
    And checkbox on "Trades" all rows
    And checkbox on "Trades" first rows
      | AP:SFL-GBP-BEL:DVP:T-2:SELL:FI |

    Given navigation to "Report Browser" page
    And click "<category>" "tab"
    When search on "Report Browser" by
      | Report Type     | COB Date      |
      | @option(<type>) | @date(<date>) |
    When filter on "Report Browser" by
      | Name                   | Operator | Value      |
      | Report Name (Filename) | Equals   | <filename> |
    And download "<filename>" file
    Then snapshot dataset "<filename>" file as "report_v1"
    And validate snapshot "report_v1" on
      | As Of Date     | Sub Account Name                | Master Account Name | Client Code | Position Type | Security Description  | Depot Account  | ISIN         | Actual Settled Quantity |
      | @dateD(<date>) | JPM:SFL-AUD-GBR:FOP:T-2:SELL:FI | JPM                 | JPM         | [empty]       | BEGV 10/22/31         | FOPSELLFIDCT-2 | BE0000352618 | -1000                   |
      | @dateD(<date>) | JPM:SFL-USD-AUS:FOP:T-2:BUY:FI  | JPM                 | JPM         | [empty]       | BEGV 10/22/31         | FOPBUYFIDCT-2  | BE0000352618 | 1000                    |

    Examples:
      | env              | username | password    | category      | type                                                  | date | filename                                               |
      | admin-defaultEnv | JohnDoe  | Password11* | Admin Reports | CustX - (DUCO) Daily Settled Security Position Report | T-1  | DUCO-EODSettledSecurityPositionsRecReport-20240219.csv |
