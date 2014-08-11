grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
//grails.project.war.file = "target/${appName}-${appVersion}.war"
grails.project.fork.run=false

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
        excludes 'xercesImpl'
    }
    legacyResolve = true
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve

    repositories {
        inherits true // Whether to inherit repository definitions from plugins

        grailsPlugins()
        grailsHome()
        grailsCentral()

        mavenLocal()
        mavenCentral()

        mavenRepo "http://maven.ala.org.au/repository/"

    }
    def springVersion = '3.2.9.RELEASE'
    def tomcatVersion = '7.0.54'
    def seleniumVersion = "2.21.0"
    def metadataExtractorVersion = "2.6.2"
    def imgscalrVersion = "4.2"
    def httpmimeVersion = "4.1.2"
    def jtsVersion = "1.8"
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes e.g.

        compile "com.drewnoakes:metadata-extractor:${metadataExtractorVersion}"
        compile "org.imgscalr:imgscalr-lib:${imgscalrVersion}"
        compile "org.apache.httpcomponents:httpmime:${httpmimeVersion}"
        compile "com.vividsolutions:jts:${jtsVersion}"
        compile "joda-time:joda-time:2.3"


        // needed by the cache plugin.
        compile "org.springframework:spring-aop:${springVersion}"
        compile "org.springframework:spring-expression:${springVersion}"
        compile group: 'au.org.ala',
                name: 'ala-cas-client',
                version:'2.1-SNAPSHOT',
                transitive:false


        // runtime 'mysql:mysql-connector-java:5.1.22'
        test "org.spockframework:spock-grails-support:0.7-groovy-2.0"
        test "org.gebish:geb-spock:0.9.3"
        test("org.seleniumhq.selenium:selenium-htmlunit-driver:$seleniumVersion") {
            exclude "xml-apis"
        }
        test("org.seleniumhq.selenium:selenium-chrome-driver:$seleniumVersion")
        test("org.seleniumhq.selenium:selenium-firefox-driver:$seleniumVersion")
    }

    plugins {
        runtime ":jquery:1.11.0.2"
        //compile ':asset-pipeline:1.8.3'
        // required by the cached-resources plugin
        runtime ":cache-headers:1.1.6"

        //runtime ":cached-resources:1.0"
        runtime ":rest:0.8" // Override the web-theme-plugin rest version.
        compile (":ala-web-theme:0.2.2") {
            exclude "rest"
        }
        runtime ":csv:0.3.1"
        runtime ":lesscss-resources:1.3.3"
        compile ":markdown:1.1.1"

        build ":tomcat:$tomcatVersion"

        compile ':cache:1.1.6'

        compile ":google-visualization:0.6.2"
        compile ":mail:1.0.6"

        compile ":excel-export:0.2.0"
        compile ":excel-import:1.0.1"

        test ":geb:0.9.3"
        test (":spock:0.7") {
            exclude "spock-grails-support"
        }
    }
}
