package custx.steps;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FeatureContext {

    // Create a context parameter store per thread
    static final ThreadLocal<Map<String, String>> contextParams = ThreadLocal.withInitial(HashMap::new);

    // Create a context parameter store per thread
    static final ThreadLocal<Map<String, List<Map<String, String>>>> contextDatasets = ThreadLocal.withInitial(HashMap::new);

    /**
     * Return a parameter value specific to that feature run.
     *
     * @param name the parameter name
     * @return return the value
     */
    public static String getParam(final String name) {
        return contextParams.get().get(name);
    }

    /**
     * Set the paramter value for the feature run.
     *
     * @param name  the parameter name
     * @param value the parameter value
     */
    public static void setParam(final String name, final String value) {
        contextParams.get().put(name, value);
    }

    /**
     * Return a map of request parameters for the feature run.
     *
     * @param names the names
     * @return return the map of found parameters
     */
    public static Map<String, String> getParams(final String... names) {
        Map<String, String> paramMap = new HashMap<>();

        for (String name : names) {
            String value = getParam(name);

            if (value != null) {
                paramMap.put(name, value);
            }
        }

        return paramMap;
    }

    /**
     * Return the dataset fo the specified feature run.
     *
     * @param name the name of the dataset
     * @return return the dataset or null
     */
    public static List<Map<String, String>> getDataset(final String name) {
        return contextDatasets.get().get(name);
    }

    /**
     * Set the dataset for the feature run.
     *
     * @param name    the name of the dataset, i.e. trade_v1
     * @param dataset the dataset
     */

    public static void setDataset(final String name, final List<Map<String, String>> dataset) {
        contextDatasets.get().put(name, dataset);
    }

}
