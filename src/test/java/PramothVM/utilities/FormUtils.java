package PramothVM.utilities;

import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.options.AriaRole;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import java.time.chrono.IsoChronology;
import java.time.format.DateTimeFormatterBuilder;
import java.time.format.FormatStyle;
import java.util.*;

import static PramothVM.constants.Utility.DATE_FORMAT_YYYYMMDD;
import static PramothVM.constants.Utility.LOAD_TIME_ELEMENT;


public class FormUtils {
    public static final String FORM_INPUT_NAME = "Name";
    public static final String FORM_INPUT_VALUE = "Value";

    public static final String FUNCTION_DATE = "@date";
    public static final String FUNCTION_CONTEXT = "@context";

    /**
     * Edit the form with the specified values.
     *
     * @param page        the page
     * @param formLocator the form location
     * @param inputMap    the input names and new values
     * @param contextMap  the context parameters
     */
    public static void setInputValues(
            final Page page, final Locator formLocator, final Map<String, Map<String, String>> inputMap,
            final Map<String, String> contextMap) {

        final Locator entryFieldsLocator = formLocator.locator("div.entryField");
        final int entryFieldCount = entryFieldsLocator.count();
        final List<String> entryFieldLabels = new LinkedList<>();
        final Set<String> nonFoundInputNames = new LinkedHashSet<>(inputMap.keySet());

        if (entryFieldCount == 0) {
            Assertions.fail("Form has no entry fields to set.");
        }

        for (int i = 0; i < entryFieldCount; i++) {
            final Locator entryFieldLocator = entryFieldsLocator.nth(i);
            final Locator labelsLocator = entryFieldLocator.locator("label");

            if (labelsLocator.count() == 0) {
                Assertions.fail("Form has an entry field[" + i + "] with no label.");
            }

            final String label = labelsLocator.first().innerText();

            if (label != null) {
                final String fieldName = (label.endsWith(":")) ? label.substring(0, label.length() - 1) : label;

                entryFieldLabels.add(fieldName);

                if (inputMap.containsKey(fieldName)) {
                    // Found a label
                    nonFoundInputNames.remove(fieldName);

                    // Update the value
                    final Map<String, String> input = inputMap.get(fieldName);
                    String value = input.get(FORM_INPUT_VALUE);

                    final Locator inputCheck = entryFieldLocator.locator("zero-checkbox");

                    if (inputCheck.count() > 0) {
                        inputCheck.click();

                        continue;
                    }

                    final Locator inputText = entryFieldLocator.locator("input");

                    if (inputText.count() > 0) {
                        final String inputTextType = inputText.getAttribute("type");
                        final String inputPlaceHolder = inputText.getAttribute("placeholder");

                        String dateFormatPattern = null;

                        if ("date".equalsIgnoreCase(inputTextType)) {
                            // for the GITHUB action box we need to find the default dateformat
                            dateFormatPattern = DateTimeFormatterBuilder
                                    .getLocalizedDateTimePattern(FormatStyle.SHORT, null,
                                            IsoChronology.INSTANCE, Locale.getDefault());
                            value = FormatUtils.resolveDateValue(label, value, DATE_FORMAT_YYYYMMDD);
                        }

                        inputText.focus();
                        inputText.fill(value);

                        // Issue with OBSERVABLE not being fire on an update, so force via KEY-PRESS
                        if ("date".equalsIgnoreCase(inputTextType)) {
                            final String[] dateParts = value.split("-");
                            final String year = dateParts[0];
                            final String month = StringUtils.leftPad(dateParts[1], 2, "0");
                            final String day = StringUtils.leftPad(dateParts[2], 2, "0");

                            page.keyboard().type("0");
                            page.waitForTimeout(LOAD_TIME_ELEMENT);

                            if (dateFormatPattern != null && dateFormatPattern.startsWith("M")) {
                                page.keyboard().type(month);
                                page.waitForTimeout(LOAD_TIME_ELEMENT);
                                page.keyboard().type(day);
                                page.waitForTimeout(LOAD_TIME_ELEMENT);
                                page.keyboard().type(year);
                            } else if (dateFormatPattern != null && dateFormatPattern.startsWith("yy")) {
                                page.keyboard().type(year);
                                page.waitForTimeout(LOAD_TIME_ELEMENT);
                                page.keyboard().type(month);
                                page.waitForTimeout(LOAD_TIME_ELEMENT);
                                page.keyboard().type(day);
                            } else {
                                page.keyboard().type(day);
                                page.waitForTimeout(LOAD_TIME_ELEMENT);
                                page.keyboard().type(month);
                                page.waitForTimeout(LOAD_TIME_ELEMENT);
                                page.keyboard().type(year);
                            }
                        }

                        page.waitForTimeout(LOAD_TIME_ELEMENT);
                        continue;
                    }

                    final Locator inputOption = entryFieldLocator.locator("zero-select");

                    if (inputOption.count() > 0) {
                        inputOption.click();
                        inputOption.locator("zero-option[value='" + value + "']").click();

                        continue;
                    }


                    Assertions.fail("Form has entry field[" + label + "] not supported.");
                }
            }
        }

        if (nonFoundInputNames.size() > 0) {
            Assertions.fail("Could no find input names " + nonFoundInputNames + " within the form fields: " + entryFieldLabels);
        }
    }

    /**
     * Submit the form.
     *
     * @param page        the page
     * @param formLocator the form location
     * @param button      the button to submit
     */
    public static void submit(final Page page, final Locator formLocator, final String button) {
        final Locator buttonLocator =  page.getByRole(AriaRole.BUTTON, new Page.GetByRoleOptions().setName(button));

        if (!buttonLocator.isVisible()) {
            Assertions.fail("Button \"" + button + "\" cannot be found to be actioned.");
        }

        if (buttonLocator.isDisabled()) {
            Assertions.fail("Button \"" + button + "\" not in correct state to be actioned.");
        }

        buttonLocator.click();

        PageUtils.waitForNotifyClose(page);
    }
}
