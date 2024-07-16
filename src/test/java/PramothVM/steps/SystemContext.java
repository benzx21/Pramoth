package PramothVM.steps;

import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

/**
 * Systme parameters accessible to all scenario/features
 */
public class SystemContext {

    // Create a context parameter store per thread
    static final Map<String, Set<String>> contextParams = new HashMap<>();

    /**
     * Find the first parameter value if one exists, otherwise null.
     *
     * @param name name of parameters
     * @return return the first value or null
     */
    public static String getParamValue(final String name) {
        final Set<String> values = contextParams.get(name);

        return values.stream().findFirst().orElse(null);
    }

    /**
     * Check for a parameter value
     *
     * @param name  the parameter name
     * @param value the value that should exist
     * @return return true whn the parameter is found
     */
    public static synchronized boolean hasParamValue(final String name, final String value) {
        final Set<String> values = contextParams.get(name);

        if (values == null) {
            return false;
        }

        return values.contains(value);
    }

    /**
     * Check for a parameter key
     *
     * @param name the parameter name
     * @return return true whn the parameter key is found
     */
    public static synchronized boolean hasParam(final String name) {
        return contextParams.containsKey(name);
    }

    /**
     * Return all parameter values
     *
     * @param name the parameter name
     * @return return the values found
     */
    public static synchronized Set<String> getParamValues(final String name) {
        return contextParams.get(name);
    }

    /**
     * Add value to the parameter to existing list of values
     *
     * @param name  the parameter name
     * @param value the value to add
     */
    public static synchronized void addParamValue(final String name, final String value) {
        if (!contextParams.containsKey(name)) {
            contextParams.put(name, new LinkedHashSet<>());
        }

        final Set<String> values = contextParams.get(name);

        values.add(value);
    }

    /**
     * Remove the parameter value when it exists as one of the values.
     *
     * @param name  the parameter name
     * @param value the value to remove
     */
    public static synchronized void removeParamValue(final String name, final String value) {
        if (!contextParams.containsKey(name)) {
            return;
        }

        final Set<String> values = contextParams.get(name);

        values.remove(value);

        if (values.isEmpty()) {
            contextParams.remove(name);
        }
    }
}
