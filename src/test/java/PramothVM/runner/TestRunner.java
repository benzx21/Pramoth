package PramothVM.runner;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;

/**
 * @tag1 or @tag2 --> With or keyword, It will run the scenario if it has either one of tags.
 * @tag1 and @tag1 --> With and keyword, it will run the scenario if it has BOTH OF THE TAGS at the same time
 * @tag1 and not @tag1 --> With and not keyword, it will run the tags has first side, it will
 * EXCLUDE the scenarios that has the tag that comes after "and not"
 * <p>
 * This framework can execute by click play button here or,
 * executing mvn commands like;
 * mvn clean test,
 * mvn clean test -Dbrowser=<browser>,
 * mvn clean test -Dbrower=<browser> -Dset-viewport-width=<width> -Denv=<ENV>
 * mvn clean test -Dbrower=<browser> -Dcucumber.filter.tags="@smoke"
 * <p>
 * CLI command for running the codegen for neptune-UAT2
 * mvn exec:java -e -D exec.mainClass=com.microsoft.playwright.CLI -D exec.args="codegen https://custx.genesislab.global/"
 */
@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ConfigurationParameter(key = "cucumber.glue", value = "PramothVM.steps")
@ConfigurationParameter(key = "cucumber.plugin", value = "pretty, json:target/cucumber-report/cucumber.json, html:target/cucumber-report.html, rerun:target/rerun.txt, io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm")
@ConfigurationParameter(key = "cucumber.filter.tags", value = "@Regression")
public class TestRunner {
}