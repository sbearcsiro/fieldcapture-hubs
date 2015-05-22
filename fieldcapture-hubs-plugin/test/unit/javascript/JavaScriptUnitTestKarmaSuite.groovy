package javascript

import de.is24.util.karmatestrunner.junit.KarmaTestSuiteRunner
import org.junit.runner.RunWith

/**
 * Runs jasmine tests using karma (via the Karma Test Runner plugin).
 */
@RunWith(KarmaTestSuiteRunner.class)
@KarmaTestSuiteRunner.KarmaConfigPath("test/unit/javascript/karma.ci.conf.js")
class JavaScriptUnitTestKarmaSuite {
}
