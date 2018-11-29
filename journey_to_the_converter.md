# Conversion issues

Maven is based on poms (xml).
Four main features to factorize build logic:
* &lt properties &gt: xml elements can be interpolated with those.
* &lt parents &gt: child can import/override what's defined in parents
* &lt dependencyManagement &gt/&lt pluginManagement &gt: factorize &lt dependency &gt/&lt plugin &gt definitions
* &lt profiles &gt: part of the poms can be redefined/overridden based on conditions:
  * static: file system content
  * dynamic: property values

Issues:
* Ensure properties are defined when using them (Gradle fails, Maven does not)
* Translate build logic factorization
  * Plugin translation: need to have the effective plugin to translate it
  * Computing effective pom is necessary for [plugins](https://confluence.criteois.com/display/RP/PluginManagement)
*
