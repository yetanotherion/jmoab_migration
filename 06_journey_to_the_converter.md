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
  * LibraryManagementPlugin / `libraries`: dependency management
  * DelayedPlugin / `delayed`: evaluate expressions lazily
  * MoabWorkspacePlugin / `moabDependencies`: Gradle [composite builds](https://docs.gradle.org/current/userguide/composite_builds.html)
     not expressive enough for the jmoab [RP-3174](https://jira.criteois.com/browse/RP-3174)

---
