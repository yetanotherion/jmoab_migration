# JMOAB: from mvn to gradle

---

# Agenda

1. When is a build system annoying?

2. Make, Bazel (Google), Buck (FB), Pants (Twitter) and gradle

3. Maven to gradle converter: isn't it just parsing xml?

4. Migration strategy

---

# When is a build system annoying?

--

In Jan 2018,

![moab_jmoab](imgs/moab_jmoab_jan_2018.png)

![moab_jmoab_pre](imgs/moab_jmoab_pre_jan_2018.png)

---

# When is a build system annoying?

--
[CEA/FramaC](http://gallium.inria.fr/~scherer/events/jbuilder-design-session-sep-09-2017/slides-bobot-frama-C.pdf)

![cea_frama_c_makefile](imgs/cea_frama_c_makefile.png)

---


# Towards en Efficient JMOAB?

Kick-off Aug 2017: make the build of the jmoab fast

* [jmoab_artifacts](http://moab.criteois.lan/.filer/graphs/jmoab_artifacts)
* [jmoab_repo](http://moab.criteois.lan/.filer/graphs/dependencies/)

SLO
* jmoab-presubmit: < 30 min
* jmoab-build: < 30 min

---

# Bazel (Google) vs Buck (FB), Pants (Twitter)

[Build systems à la carte/Microsoft research](https://www.microsoft.com/en-us/research/uploads/prod/2018/03/build-systems-a-la-carte.pdf)

```
Build systems (such as Make) are big, complicated, and used by every software
developer on the planet. But they are a sadly unloved part of the software
ecosystem, very much a means to an end, and seldom the focus of attention.
```

--

```
For years Make dominated, but more recently the challenges of scale have
driven large software firms like Microsoft, Facebook and Google to develop their
own build systems, exploring new points in the design space.
```
--

[bazel_faq](https://bazel.build/faq.html)

```
Bazel is a tool that automates software builds and tests.
```

--

```
Pants, Buck: Both tools were created and developed by ex-Googlers at Twitter and Foursquare,
and Facebook respectively. They have been modeled after Bazel, but their feature
sets are different, so they aren't viable alternatives for us.
```
--

```
A long time ago, Google built its software using large, generated Makefiles.
These led to slow and unreliable builds, which began to interfere with our developers'
productivity and the company's agility. Bazel was a way to solve these problems.
```

---

# Bazel/Buck/Pants vs Make/Mvn/Gradle

How to ensure maintainability?
* Widespread solution: provide a more or less expressive DSL.
```
Gradle: Bazel configuration files are much more structured than Gradle's,
letting Bazel understand exactly what each action does.
This allows for more parallelism and better reproducibility.
Make, Ninja: These tools give very exact control over what commands
get invoked to build files, but it's up to the user to write rules that are correct.
Users interact with Bazel on a higher level
```

How to build fast? (a.k.a why mvn *is* not fast)
* Use a DAG of tasks to:

 * leverage parallelization
 * don't rebuild if not necessary
```
Ant and Maven: Ant and Maven are primarily geared toward Java, while Bazel
handles multiple languages. Bazel encourages subdividing codebases in smaller
reusable units, and can rebuild only ones that need rebuilding. This speeds
up development when working with larger codebases.
```

---

# Sbt

* Would be nice to have something that does more than scala/java.
* Twitter uses Pants over Sbt for scala.
* Linkedin migrated sbt to gradle and reports 400% of improvement
https://engineering.linkedin.com/blog/2018/07/how-we-improved-build-time-by-400-percent

---

# Let's choose one

Bazel looks like the tool having the most solid foundations. But

* limited scala support
* asks to explicit all transitive dependencies (no version conflict resolution)
* how to convert the [~45 plugin in maven](https://confluence.criteois.com/display/RP/Maven+plugins+and+their+Gradle+equivalent)
* open source more active in gradle than in bazel (for now)


---

# Let's migrate

* 10% of Sergei Lebedev for testfwk/webservice: worked but needed manual porting of pom modifications.
* [Mixed maven/gradle](https://confluence.criteois.com/pages/viewpage.action?pageId=326303105): does not work in IntelliJ
* Patrick Bruneton: let's try a big bang migration with automated conversion
[Feasibility](https://confluence.criteois.com/display/RP/Feasibility+of+maven+to+gradle+automated+translation):
 * 637 pom.xml, (now about 1000 with scala 2.10/2.11)
 * 50 reviews merged per week on pom.xml
 * which features of maven we need in the jmoab?
 * which features of maven we need to convert?

---
# Maven to gradle converter:

* Maven is based on poms. A pom is an xml tree of elements whose value can be interpolated with properties. We focused the translation on these elements:
  * properties
  * dependencyManagement/dependency
  * pluginManagement/plugin

* Maven permits to factorize builds with properties and:
 * parent: child can override existing elements
 * profiles: can override existing elements based on statically or dynamically evaluated
   values: (fileExists/propertyEquals/etc)

* Maven computes an effective pom (once all overrides /merges are done) and execute tasks based on the pom.

How to convert ?

---
# Maven to gradle converter
