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

--

__Classpath computations__

|        | Set scope of transitive dependencies | provided | exclude | Version conflict solver | BOM import (chd-root/aws) |
|--------|:------------------------------------:|:-----------------------------:|
| Gradle | Not supported                        | [spring provides a plugin](https://github.com/spring-gradle-plugins/propdeps-plugin), but different semantics | Different semantics [GRADLE-1473](https://github.com/gradle/gradle/issues/1473) | Different algorithm | Supported in a version that appeared during the migration

---
# Conversion issues

Being semantically equivalent is very expensive. We choose to limit the scope
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
| Gradle | DONE          | DONE calling  DelayedPlugin / `delayed` when necessary |


--
__Classpath computations__

|        | Set scope of transitive dependencies | provided | exclude | Version conflict solver | BOM import (chd-root/aws) |
|--------|:------------------------------------:|:-----------------------------:|
| Gradle | Heuristics                           | Use [spring's plugin](https://github.com/spring-gradle-plugins/propdeps-plugin) | NOT DONE | 2 pass conversion | Heuristic until gradle 4.6


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

# Conversion examples: dependencies in parents
repo/parquet-macros/pom.xml

```xml
<parent>
  ...
  <artifactId>bdp-parent</artifactId> <!-- repo/pom.xml -->
  ...
</parent>
<dependencies>
    <!-- scala -->
    <dependency>
      <groupId>org.scala-lang</groupId>
      <artifactId>scala-reflect</artifactId>
    </dependency>
    <dependency>
      <groupId>org.scala-lang</groupId>
      <artifactId>scala-library</artifactId>
    </dependency>
    <dependency>
      <groupId>com.twitter</groupId>
      <artifactId>scalding-core_${scala.version.short}</artifactId>
    </dependency>
    ...
```

---

# Conversion examples: dependencies in parents
repo/parquet-macros/parent.gradle

```groovy
apply from: repoFile('parent.gradle') // scala_version_short = "2.11"

dependencies {
    compile libraries["org.scala-lang:scala-reflect"]
    compile libraries["org.scala-lang:scala-library"]
    compile libraries["com.twitter:scalding-core_${scala_version_short}"]
    ...
}
```

--

```groovy
apply from: repoFile('parquet-macros/parent.gradle')
ext {
   scala_version_short = "2.12"
}
```

--

scalding-core version?

---

# Conversion examples: dependencies in parents
repo/parquet-macros/parent.gradle

```groovy
delayed {
    dependencies {
        compile libraries["org.scala-lang:scala-reflect"]
        compile libraries["org.scala-lang:scala-library"]
        compile libraries["com.twitter:scalding-core_${scala_version_short}"]
    }
}
```

---

# Conversion examples: pluginManagement in parents

repo/pom.xml
```xml
<groupId>com.criteo.hadoop</groupId>
<artifactId>bdp-parent</artifactId>
 <build>
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>net.alchim31.maven</groupId>
          <artifactId>scala-maven-plugin</artifactId>
          <configuration>
            <recompileMode>all</recompileMode>
            <args>
              <arg>-target:jvm-1.7</arg>
            </args>
            <javacArgs>
              <javacArg>-source</javacArg>
              <javacArg>1.7</javacArg>
              <javacArg>-target</javacArg>
              <javacArg>1.7</javacArg>
            </javacArgs>
          </configuration>
          ...
```
---

# Conversion examples: pluginManagement in parents

repo/scala.gradle
```groovy
compileScala.scalaCompileOptions.additionalParameters = ["-target:jvm-1.7"]
compileTestScala.scalaCompileOptions.additionalParameters = ["-target:jvm-1.7"]
```

---

# Conversion examples: pluginManagement in parents
repo/parquet-macros/pom.xml

```xml
<parent>
  ...
  <artifactId>bdp-parent</artifactId>
  ...
</parent>
 <artifactId>parquet-macros-parent</artifactId>
 <build>
   <pluginManagement>
     <plugins>
       <plugin>
         <groupId>net.alchim31.maven</groupId>
         <artifactId>scala-maven-plugin</artifactId>
         <configuration>
           <compilerPlugins>
             <compilerPlugin>
               <groupId>org.scalamacros</groupId>
               <artifactId>paradise_${scala.version}</artifactId>
               <version>2.1.0</version>
             </compilerPlugin>
           </compilerPlugins>
         </configuration>
         ...
```
---

# Conversion examples: pluginManagement in parents

repo/parquet-macros/scala.gradle
```groovy
/* from pluginManagement of repo/parquet-macros/pom.xml */
configurations {
    scalaPlugin {
        transitive = false
    }
}

dependencies {
    scalaPlugin "org.scalamacros:paradise_${scala_version}:2.1.0"
}
String scalaPluginOption = "-Xplugin:${configurations.scalaPlugin.singleFile.path}"


def additionalParameters = ["-target:jvm-1.7", // from pluginManagement of repo/pom.xml
                            scalaPluginOption]

compileScala.scalaCompileOptions.additionalParameters = additionalParameters
compileTestScala.scalaCompileOptions.additionalParameters = additionalParameters
```

---

# Conversion examples: pluginManagement in parents
repo/langoustine-run/build.gradle:

```groovy
apply from: repoFile('scala.gradle')
```

repo/parquet-macros/parquet-macros_2.11/build.gradle:

```groovy
apply from: repoFile('parquet-macros/parent.gradle')
apply from: repoFile('parquet-macros/scala.gradle')

ext {
    artifactId = "parquet-macros_2.11"
    groupId = "com.criteo.hadoop"
    scala_version = scala211_version
    scala_version_short = "2.11"
}

```

--

scalamacros version?

---

# Conversion examples: pluginManagement in parents
repo/langoustine-run/build.gradle:

```groovy
apply from: repoFile('scala.gradle')
```

repo/parquet-macros/parquet-macros_2.11/build.gradle:

```groovy
apply from: repoFile('parquet-macros/parent.gradle')
ext {
    artifactId = "parquet-macros_2.11"
    groupId = "com.criteo.hadoop"
    scala_version = scala211_version
    scala_version_short = "2.11"
}

apply from: repoFile('parquet-macros/scala.gradle')
```
???

To Ion next slide.

---
