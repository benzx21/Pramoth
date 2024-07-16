package custx.utilities;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;
import custx.constants.Utility;
import lombok.extern.slf4j.Slf4j;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static custx.constants.Utility.LOAD_TIME_ELEMENT;
import static custx.utilities.PageUtils.sleep;

@Slf4j
public class GridUtils {
    public static final String FILTER_NAME = "Name";
    public static final String FILTER_OPERATOR = "Operator";
    public static final String FILTER_VALUE = "Value";
    public static final String FILTER_CONDITION = "Condition";
    public static final String FILTER_OTHER_OPERATOR = "Other Operator";
    public static final String FILTER_OTHER_VALUE = "Other Value";
    public static final String FILTER_ORDER = "Order";
    public static final String FILTER_ORDER_DESC = "DESC";

    public static final String FUNCTION_DATE = "@date";
    public static final String FUNCTION_CONTEXT = "@context";

    private static final String GRID_LOCATOR_HEADERS = "div.ag-header-container > div";
    private static final String GRID_LOCATOR_COLUMNS = "div.ag-header-cell";
    private static final String GRID_LOCATOR_HORIZONTAL_SCROLLBAR = "div.ag-body-horizontal-scroll-viewport";
    private static final String GRID_LOCATOR_CELLS = "div.ag-cell";
    private static final String GRID_LOCATOR_CHECKBOX = "div.ag-pinned-left-cols-container > div";

    private static void showAllColumns(final Locator gridLocator) {
        final Locator gridColumns = gridLocator.getByRole(AriaRole.TAB, new Locator.GetByRoleOptions().setName("Columns"));
        final Locator gridToggleAllCheckbox = gridLocator.getByRole(AriaRole.CHECKBOX, new Locator.GetByRoleOptions().setName("Toggle Select All Columns"));

        gridColumns.click();
        gridLocator.getByRole(AriaRole.TEXTBOX, new Locator.GetByRoleOptions().setName("Filter Columns Input")).fill("");
        sleep(LOAD_TIME_ELEMENT);
        gridToggleAllCheckbox.check();
        sleep(LOAD_TIME_ELEMENT);
        gridColumns.click();
    }

    /**
     * Reset the horizontal scroll bar of the grid to the beginning.
     *
     * @param scrollLocator the scrollbar locator
     */
    private static void resetScrollColumns(final Locator scrollLocator) {
        if (scrollLocator.count() > 0 && scrollLocator.isVisible()) {
            while (scrollLocator.boundingBox().x != scrollLocator.locator("div.ag-body-horizontal-scroll-container").boundingBox().x) {
                scrollLocator.click(new Locator.ClickOptions().setPosition(0, 0));
            }
            sleep(LOAD_TIME_ELEMENT);
        }
    }

    /**
     * Scroll the next set of columns into the virtual view.
     *
     * @param scrollLocator the scrollbar locator
     */
    private static void scrollColumns(final Locator scrollLocator) {
        scrollLocator.click(new Locator.ClickOptions().setPosition(scrollLocator.boundingBox().width - 1, 0));
        sleep(LOAD_TIME_ELEMENT);
    }

    /**
     * Apply the following column filters on the grid.
     *
     * @param page        the page
     * @param gridLocator the grid to be filtered on the page
     * @param filterMap   the filters
     * @param contextMap  the context parameters
     */
    public static void setGridFilters(
            final Page page, final Locator gridLocator, Map<String, Map<String, String>> filterMap,
            final Map<String, String> contextMap) {
        final Locator headersLocator = gridLocator.locator(GRID_LOCATOR_HEADERS);
        final Locator scrollLocator = gridLocator.locator(GRID_LOCATOR_HORIZONTAL_SCROLLBAR).first();
        final Locator filterOptionsLocator = page.locator("span[aria-label='general']");
        final Locator filterContentLocator = page.locator("span[aria-label='filter']");
        final Locator filterPickerLocator = page.locator("div.ag-picker-field >> nth=0 >> div[ref='eDisplayField'] >> nth=0");
        final Locator filterOperatorLocator = page.locator("div[aria-label='Select Field'] > div");
        final Locator filterValueLocator = page.locator("div.ag-filter-body >> nth=0 >> input[ref='eInput'] >> nth=0");
        final Locator filterConditionLocator = page.locator("div.ag-filter-condition >> nth=0 >> div[ref='eLabel']");
        final Locator filterOtherValueLocator = page.locator("div.ag-filter-body >> nth=1 >> input[ref='eInput'] >> nth=0");
        final Locator filterButtonsLocator = page.locator("div.ag-filter-apply-panel >> nth=0 >> button[ref='applyFilterButton'] >> nth=0");

        final Set<String> unknownFilters = new HashSet<>(filterMap.keySet());

        showAllColumns(gridLocator);
        resetScrollColumns(scrollLocator);

        final Map<String, String> columnReferenceMap = new HashMap<>();

        int nonProcessingCount = 0;

        while (nonProcessingCount < 3) {
            int prevProcessedColumnCount = columnReferenceMap.size();

            final Locator columnsLocator = headersLocator.locator(GRID_LOCATOR_COLUMNS);
            int columnCount = columnsLocator.count();

            // Enrich the header reference data
            for (int i = 0; i < columnCount; i++) {
                final Locator columnLocator = columnsLocator.nth(i);
                final String columnId = columnLocator.getAttribute("col-id");
                final String label = columnLocator.innerText();

                columnReferenceMap.put(columnId, label);

                // Check if the column needs a filter applied.
                if (unknownFilters.contains(label)) {
                    unknownFilters.remove(label);

                    final Map<String, String> filter = filterMap.get(label);
                    final String operator = filter.get(FILTER_OPERATOR);

                    // Check column values
                    if (operator != null && !operator.isBlank()) {
                        columnLocator.locator("div.ag-cell-label-container >> span[ref='eMenu']").click();
                        filterContentLocator.click();//Since is the first filter we need to go to the filter tab

                        filterPickerLocator.click();
                        filterOperatorLocator.
                                getByText(operator, new Locator.GetByTextOptions().setExact(true))
                                .click();

                        String value = filter.get(FILTER_VALUE);
                        String filterValue = resolveFilterValue(value, filterMap, label, contextMap);
                        filterValueLocator.fill(filterValue);

                        if (filter.containsKey(FILTER_OTHER_VALUE)) {
                            filterConditionLocator.getByText(filter.get(FILTER_CONDITION)).click();

                            value = filter.get(FILTER_OTHER_VALUE);
                            filterValue = resolveFilterValue(value, filterMap, label, contextMap);
                            filterOtherValueLocator.fill(filterValue);
                        }

                        if (filterButtonsLocator.count() > 0) {
                            filterButtonsLocator.click();
                        }

                        PageUtils.waitForLoad(page);

                        PageUtils.screenCapture("Filter on " + label);

                        //Since is the las filter we need to reset the filter tab
                        filterOptionsLocator.click();
                        //To close the filter modal
                        filterOptionsLocator.click();
                    }

                    // Check column is ordered, ASC or DESC
                    final String order = filter.get(FILTER_ORDER);

                    if (order != null && !order.isBlank()) {
                        columnLocator.locator("div.ag-cell-label-container >> div[ref='eLabel']").first().click();

                        if (FILTER_ORDER_DESC.equals(order)) {
                            columnLocator.locator("div.ag-cell-label-container >> div[ref='eLabel']").first().click();
                        }
                    }

                    //Reset column count since applying a filter can decrease the count
                    columnCount = columnsLocator.count();
                }

                if (unknownFilters.isEmpty()) {
                    //empty filters means we apply all
                    break;
                }
            }

            if (!scrollLocator.isVisible()) {
                // no scroll bar means we have all the data
                break;
            }

            if (unknownFilters.isEmpty()) {
                //empty filters means we apply all
                break;
            }

            scrollColumns(scrollLocator);

            nonProcessingCount =
                    (prevProcessedColumnCount == columnReferenceMap.size()) ? nonProcessingCount + 1 : 0;
        }

        if (unknownFilters.size() > 0) {
            throw new IllegalStateException("Filters could not be applied: " + unknownFilters);
        }
    }

    private static String resolveFilterValue(String value, Map<String, Map<String, String>> filterMap,
                                             String label, final Map<String, String> contextMap) {
        if (value == null) {
            throw new IllegalStateException("Invalid filter: " + filterMap);
        }

        String filterValue = value;

        if (filterValue.startsWith(FUNCTION_DATE)) {
            filterValue = FormatUtils.resolveDateValue(label, filterValue, Utility.DATE_FORMAT_DDMMMYYYY);
        } else if (filterValue.startsWith(FUNCTION_CONTEXT)) {
            final String contextName =
                    filterValue.replace(FUNCTION_CONTEXT, "").replace("(", "")
                            .replace(")", "").trim();
            filterValue = contextMap.get(contextName);

            if (filterValue == null) {
                throw new IllegalStateException("Invalid \"" + contextName + "\" + filter: " + filterMap);
            }
        } else if (filterValue.contains(FUNCTION_DATE)) {
            filterValue = FormatUtils.replaceDateValue(filterValue);
        }

        return filterValue;
    }

    /**
     * Extract all the cell data from the specified AG Virtual grid. AG grids need to be scrolled to bring into focus
     * Cell not visible and part of the virtual dataset.
     *
     * @param page        the page
     * @param gridLocator the grid locator on the page
     * @return return the data extracted from the grid
     */
    public static List<Map<String, String>> getDatasetFromGrid(final Page page, final Locator gridLocator) {
        final Locator headersLocator = gridLocator.locator(GRID_LOCATOR_HEADERS);
        final Locator dataLocator = gridLocator.locator("div.ag-center-cols-container").first().locator("div.ag-row");
        final Locator scrollLocator = gridLocator.locator(GRID_LOCATOR_HORIZONTAL_SCROLLBAR).first();
        final int rowCount = dataLocator.count();

        if (rowCount == 0) {
            log.warn("Grid is empty:{}", rowCount);
            return new ArrayList<>();
        }

        log.info("Reading {} rows", rowCount);

        showAllColumns(gridLocator);
        resetScrollColumns(scrollLocator);

        final List<Map<String, String>> dataset = IntStream.range(0, rowCount)
                .mapToObj(i -> new HashMap<String, String>())
                .collect(Collectors.toList());

        final Map<String, String> columnReferenceMap = new HashMap<>();

        int nonProcessingCount = 0;

        while (nonProcessingCount < 3) {
            int prevProcessedColumnCount = columnReferenceMap.size();

            final Locator columnsLocator = headersLocator.locator(GRID_LOCATOR_COLUMNS);
            final int columnCount = columnsLocator.count();

            // Enrich the header reference data
            for (int i = 0; i < columnCount; i++) {
                final Locator columnLocator = columnsLocator.nth(i);
                final String columnId = columnLocator.getAttribute("col-id");
                final String label = columnLocator.innerText();

                columnReferenceMap.put(columnId, label);
            }

            // Get the rows
            for (int i = 0; i < rowCount; i++) {
                final Locator rowLocator = dataLocator.nth(i);
                final Locator cellsLocator = rowLocator.locator(GRID_LOCATOR_CELLS);
                final int cellCount = cellsLocator.count();

                for (int j = 0; j < cellCount; j++) {
                    final Locator cellLocator = cellsLocator.nth(j);
                    final String columnId = cellLocator.getAttribute("col-id");
                    final String columnRawValue = cellLocator.innerText();
                    final String columnName = columnReferenceMap.getOrDefault(columnId, columnId);
                    final String columnValue = (columnRawValue == null) ? null : columnRawValue.trim();
                    if (!dataset.get(i).containsKey(columnName)) {
                        dataset.get(i).put(columnName, columnValue);
                    }
                }
            }

            if (!scrollLocator.isVisible()) {
                // no scroll bar means we have all the data
                break;
            }

            scrollColumns(scrollLocator);

            nonProcessingCount =
                    (prevProcessedColumnCount == columnReferenceMap.size()) ? nonProcessingCount + 1 : 0;
        }

        log.info("Field Data Values: " + dataset);
        return dataset;
    }

    /**
     * Select the specified row in the grid.
     *
     * @param page        the page
     * @param gridLocator the grid locator on the page
     * @param rowNo       the row number
     */
    public static void selectRow(final Page page, final Locator gridLocator, final int rowNo) {
        final Locator dataLocator = gridLocator.locator("div.ag-center-cols-container > div.ag-row");
        final int rowCount = dataLocator.count();

        if (rowCount == 0) {
            throw new IllegalStateException("No row " + rowNo + " to select");
        }

        final Locator rowLocator = dataLocator.nth(rowNo);

        final Locator cellsLocator = rowLocator.locator(GRID_LOCATOR_CELLS);
        final int cellCount = cellsLocator.count();

        if (cellCount == 0) {
            throw new IllegalStateException("No cells on row " + rowNo + " to select");
        }

        cellsLocator.first().click();
    }

    /**
     * Click checkbox of all rows in the grid.
     *
     * @param page        the page
     * @param gridLocator the grid locator on the page
     */
    public static void checkboxAllRows(final Page page, final Locator gridLocator) {
        final Locator dataLocator = gridLocator.locator("div.ag-center-cols-container > div.ag-row");
        final int rowCount = dataLocator.count();

        if (rowCount == 0) {
            throw new IllegalStateException("No rows to select");
        }

        final Locator cellSelectAll = gridLocator.locator("div.ag-pinned-left-header >> input[type='checkbox']");
        cellSelectAll.click();
    }

    /**
     * Click checkbox of first rows in the grid.
     *
     * @param page        the page
     * @param gridLocator the grid locator on the page
     */
    public static void checkboxFirstRows(final Page page, final Locator gridLocator, final List<String> values) {
        final Locator dataLocator = gridLocator.locator("div.ag-center-cols-container > div.ag-row");
        final int rowCount = dataLocator.count();

        if (rowCount == 0) {
            throw new IllegalStateException("No rows to unselect");
        }

        for (String value : values) {
            final Locator rowLocator = dataLocator.filter(new Locator.FilterOptions().setHasText(value)).first();
            int rowIndex = Integer.parseInt(rowLocator.getAttribute("row-index"));

            final Locator cellSelect = gridLocator.locator(GRID_LOCATOR_CHECKBOX).nth(rowIndex).locator("input[type='checkbox']");
            cellSelect.click();
        }
    }

    /**
     * Click button of specify row in the grid.
     *
     * @param page        the page
     * @param button      the button text
     * @param gridLocator the grid locator on the page
     * @param row         the row on the grid
     */
    public static void clickButtonRow(final Page page, final String button, final Locator gridLocator, final int row) {
        final Locator dataLocator = gridLocator.locator("div.ag-pinned-right-cols-container > div.ag-row");
        final int rowCount = dataLocator.count();

        if (rowCount == 0 || rowCount < row) {
            throw new IllegalStateException("No rows to select");
        }

        final Locator rowLocator = dataLocator.nth(row);

        final Locator cellSelect = rowLocator.getByRole(AriaRole.BUTTON, new Locator.GetByRoleOptions().setName(button));
        cellSelect.click();
    }

}
