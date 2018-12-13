# Conversion issues

__Build logic factorization__


|        | properties | dependencyManagement | pluginManagement | profiles |
|--------|:----------:|:--------------------:|:----------------:|:--------:|
| Gradle | ext        | [spring provides a plugin](https://github.com/spring-gradle-plugins/dependency-management-plugin) but performance cost                | Not supported             | Not supported     |

--

__Dynamic workspace__

  * Should build when dependencies are checkout or not
  * Gradle's [composite builds](https://docs.gradle.org/current/userguide/composite_builds.html)
     not expressive enough yet for the jmoab [RP-3174](https://jira.criteois.com/browse/RP-3174)

---
# Conversion issues

__Evaluation of expressions__

|        | effective pom | lazy evaluation |
|--------|:-------------:|:-----------------------------:|
| Gradle | Not supported   | Not supported ([GRADLE-1080](https://github.com/gradle/gradle/issues/1080))                     |

???
effective pom = the POM computed by maven by aggregating all parent poms and executing profiles

--

__Classpath computations__

|        | Set scope of transitive dependencies | provided | exclude | Version conflict solver | BOM import (chd-root/aws) |
|--------|:------------------------------------:|:-----------------------------:|
| Gradle | Not supported                        | [spring provides a plugin](https://github.com/spring-gradle-plugins/propdeps-plugin), but different semantics | Different semantics [GRADLE-1473](https://github.com/gradle/gradle/issues/1473) | Different algorithm | Supported in a version that appeared during the migration

---
# Conversion issues

Being semantically equivalent is very expensive. We chose to limit the scope
of what is done automatically

__Build logic factorization__

|        | properties | dependencyManagement | pluginManagement | profiles |
|--------|:----------:|:--------------------:|:----------------:|:--------:|
| Gradle | ext        | LibraryManagementPlugin / `libraries` ([springsDepMgmt](https://github.com/spring-gradle-plugins/dependency-management-plugin) is more expressive but slower) | Compute all used effective poms, translate in external gradle files (harder than expected due to [GRADLE-1262](https://github.com/gradle/gradle/issues/1262))             | Support CI use case only (no dynamic profile)  |
--

__Dynamic workspace__

  * MoabWorkspacePlugin / `moabDependencies`

---
# Conversion issues

__Evaluation of expressions__

|        | effective pom | lazy evaluation |
|--------|:-------------:|:-----------------------------:|
| Gradle | __DONE__          | __DONE__ calling  DelayedPlugin / `delayed` when necessary |


--
__Classpath computations__

|        | Set scope of transitive dependencies | provided | exclude | Version conflict solver | BOM import (chd-root/aws) |
|--------|:------------------------------------:|:-----------------------------:|
| Gradle | Heuristics                           | Use [spring's plugin](https://github.com/spring-gradle-plugins/propdeps-plugin) | __NOT DONE__ | 2 pass conversion | Heuristic until gradle 4.6


---

# Conversion examples: a generated build.gradle
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <parent>
    <groupId>com.criteo.pom</groupId>
    <artifactId>cuttle-parent</artifactId>
    <version>1.0-SNAPSHOT</version>
    <relativePath>../../../../parent-poms/parent-poms/cuttle-parent/pom.xml</relativePath>
  </parent>
  <groupId>com.criteo.xdrichtimeline</groupId>
  <artifactId>xdrichtimeline-cuttle</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>jar</packaging>
  <properties>
    <!-- Main -->
    <app.main.class>com.criteo.hadoop.prospecting.cuttle.Application</app.main.class>
  </properties>
  <dependencies>
    <!-- Internal utils shared between cuttles -->
    <dependency>
      <groupId>com.criteo.xdrichtimeline</groupId>
      <artifactId>xdrichtimeline-cuttle-utils</artifactId>
    </dependency>
...
```
---

# Conversion examples: a generated build.gradle

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

# Conversion examples: a generated build.gradle

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
# Conversion examples: a generated build.gradle

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
