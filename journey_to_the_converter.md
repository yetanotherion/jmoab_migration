# Conversion issues

Maven is based on poms (xml).
Four main features to factorize build logic:
* `<properties>` xml elements can be interpolated with those.
* `<parents>` child can import/override what's defined in parents
* `<dependencyManagement>/<pluginManagement>` factorize `<dependency>/<plugin>` definitions
* `<profiles>`: part of the poms can be redefined/overridden based on conditions:
  * static: file system content
  * dynamic: property values

Issues:
* Ensure properties are defined when using them (Gradle fails, Maven does not)
* Translate build logic factorization
  * Plugin translation: need to have the effective plugin to translate it
  * Computing effective pom is necessary for [plugins](https://confluence.criteois.com/display/RP/PluginManagement)
*
