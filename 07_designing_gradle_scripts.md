# Designing for gradle

### Features:
   - should be reminescent of existing maven toolkit
   - auto discovery of projects
   - partial checkout (developer use case)
   - support generation from converter
   - versioned inside the MOAB


--

### Plugins!
   - MoabWorkspacePlugin / MoabModulePlugin
   - LibraryManagementPlugin / DelayedPlugin (Bis)
   - BfsPlugin
   - SeedsPlugin

???
- BfsPlugin: tooling for managing workspace (init, checkout, refresh)
- MoabWorkspacePlugin: tooling for auto discovery of projects, partial checkouts, publication
- LibraryManagementPlugin/DelayedPlugin: maven like dependency constraints declaration for easier conversion
- SeedsPlugin: easily run tasks on client projects

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

---
