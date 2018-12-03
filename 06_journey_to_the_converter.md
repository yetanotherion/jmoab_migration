# Conversion issues (Required?)

__Four main features to factorize build logic in Maven to translate__:
* `<properties>` xml elements can be interpolated with those.
* `<parents>` child can import/override what's defined in parents
* `<dependencyManagement>/<pluginManagement>` factorize `<dependency>/<plugin>` definitions
* `<profiles>`: part of the poms can be redefined/overridden based on conditions:
  * static: file system content
  * dynamic: property values

__Dependency management__:
* maven permits to set the scope of transitive dependencies (gradle does not)
* Exclude semantics is different [GRADLE-1473](https://github.com/gradle/gradle/issues/1473)
* No provided in gradle [spring provides a plugin](https://github.com/spring-gradle-plugins/propdeps-plugin),
  but semantics are different (TODO find link)
* Different algorithm to solve transitive dependencies version conficts.
* Need to support BOM import

---
# Conversion issues (Required?)
__Plugin management__:
* Plugins are not exactly equivalent (ex: minimize not available in the plugin to do uber jars)
* Maven plugins are configured in xml and executed accorded to the effective pom
* Gradle's plugin are configured with their own DSL that do not implement the algorithm to compute
  the effective pom.

__Classpath__:
* Maven permits to manage the order of jars in your classpath,
* Gradle does not.


---
# Conversion issues

Being semantically equivalent is very expensive. We choose to limit the scope
of what is done automatically. Choices:

--
* Support the CI use case only (no dynamic profile anymore)

--
* Be as gradle native as possible (limit custom / non official plugins)

--
* Implemented property interpreter + effective pom computer (plugins)

--
* 2 pass conversion to align version conflict resolution algorithms:
  * Generate gradle files
  * Compare mvn vs gradle versions
  * Generate blocks to align gradle version with the ones in mvn.

--
* Created custom plugins:
  * `libraries`: mimic maven property evaluation order
  * `moabDependencies`: Gradle [composite builds](https://docs.gradle.org/current/userguide/composite_builds.html)
     not expressive enough for the jmoab [RP-3174](https://jira.criteois.com/browse/RP-3174)

--
* Hope we can fix the remaining manually.

---

# Conversion example

```groovy
/* Plugins */
apply plugin: 'com.criteo.moab-module' // Custom
apply plugin: 'com.criteo.uberjar' // Custom
apply plugin: 'distribution' // Native
apply plugin: 'propdeps' // External
apply plugin: 'scala' // Native

apply from: parentPomsFile('cuttle-parent/parent.gradle') // include parent pom

/* Properties */
ext {
    artifactId = "xdrichtimeline-cuttle"
    groupId = "com.criteo.xdrichtimeline"
    app_main_class = "com.criteo.hadoop.prospecting.cuttle.Application"
}
```

---

# Conversion example

```groovy
/* Plugin Management */
apply from: parentPomsFile('cuttle-parent/junit.gradle')
apply from: parentPomsFile('cuttle-parent/scalatest.gradle')
apply from: repoFile('xdrichtimeline/setup_tar_with_cuttle_jars.gradle') // manual translation

/**
 * This block aims at enforcing the same version as when Maven resolved it.
 * The version that would have been selected by gradle is available at the
 * end of the line as commentary.
 * Feel free to keep the line or remove it.
 */
libraries {
    library "asm:asm:3.1" // 3.2
    library "javax.activation:activation:1.1.1" // 1.1
}

/* Internal dependencies */
moabDependencies {
    compile ":identification:xdevicetimeline:xdrichtimeline:xdrichtimeline-cuttle-utils"
    provided ":identification:xdevicetimeline:xdrichtimeline:cuttle-jars"
    compile ":cuttle:cuttle-criteo:cuttle-contrib"
}```

---
# Conversion example

```groovy
/* External dependencies */
dependencies {
    compile libraries["org.scala-lang:scala-library"] // dependencyManagement
    provided libraries["org.apache.hadoop:hadoop-yarn-client"]
    testCompile libraries["org.scalatest:scalatest_${scala_version_short}"]
}

/* Assembly plugin */
distTar {
    compression = compression.GZIP
    extension = "tar.gz"
    classifier = "bundle"
}

/* Shade plugin */
shadowJar {
    dependencies {
        include(dependency(".*:.*"))
    }
    append("reference.conf")
    transform(de.sebastianboegl.gradle.plugins.shadow.transformers.Log4j2PluginsFileTransformer)
    manifest {
        attributes("Main-Class": app_main_class)
    }
}
```
---
