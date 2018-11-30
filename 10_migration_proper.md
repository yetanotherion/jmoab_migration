# Industrialize migration

* Jobs emulating all cases, bugs found when maven depends on gradle.
* Schedule the migration from the leaves.
* Topo-sort computed, changes continuously generated /rebased on non migrated leaves only.
* Find owner of each repo...
* Build-services members assign themselves to one repo:
  * Take contact with devlead
  * Training
  * Manual fixes, participate in integration test debugging.
* How to test:
  * tools for comparing produced artifacts
  * tools for comparing test results/numbers ("what? 0 tests in my maven project? I was SURE I had some")
* issues: scala compatibility issues, migrate existing tools (cuttle), IntelliJ integration, __classpath__ order.

---

# Stacktrace cluedo

```
SLF4J: See also http://www.slf4j.org/codes.html#log4jDelegationLoop for more details.
Exception in thread "main" java.lang.ExceptionInInitializerError
    at java.lang.Class.forName0(Native Method)
    at java.lang.Class.forName(Class.java:264)
    at org.slf4j.impl.Log4jLoggerFactory.<clinit>(Log4jLoggerFactory.java:48)
    at org.slf4j.impl.StaticLoggerBinder.<init>(StaticLoggerBinder.java:72)
    at org.slf4j.impl.StaticLoggerBinder.<clinit>(StaticLoggerBinder.java:45)
    at org.slf4j.LoggerFactory.bind(LoggerFactory.java:143)
    at org.slf4j.LoggerFactory.performInitialization(LoggerFactory.java:122)
    at org.slf4j.LoggerFactory.getILoggerFactory(LoggerFactory.java:378)
    at org.slf4j.LoggerFactory.getLogger(LoggerFactory.java:328)
    at org.slf4j.LoggerFactory.getLogger(LoggerFactory.java:349)
    at com.criteo.hadoop.garmadon.agent.EventAgent.<clinit>(EventAgent.java:31)
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke(Method.java:498)
    at sun.instrument.InstrumentationImpl.loadClassAndStartAgent(InstrumentationImpl.java:386)
    at sun.instrument.InstrumentationImpl.loadClassAndCallPremain(InstrumentationImpl.java:401)
Caused by: java.lang.IllegalStateException: Detected both log4j-over-slf4j.jar AND slf4j-log4j12.jar on the class path, preempting StackOverflowError. See also http://www.slf4j.org/codes.html#log4jDelegationLoop for more details.
    at org.apache.log4j.Log4jLoggerFactory.<clinit>(Log4jLoggerFactory.java:51
```

---
# Stacktrace cluedo

```
java.lang.Exception: java.lang.IncompatibleClassChangeError: Implementing class
    at com.twitter.inject.server.EmbeddedTwitterServer$$anonfun$runNonExitingMain$1.apply$mcV$sp(EmbeddedTwitterServer.scala:637)
    at com.twitter.inject.server.EmbeddedTwitterServer$$anonfun$runNonExitingMain$1.apply(EmbeddedTwitterServer.scala:624)
    at com.twitter.inject.server.EmbeddedTwitterServer$$anonfun$runNonExitingMain$1.apply(EmbeddedTwitterServer.scala:624)
    at com.twitter.util.Try$.apply(Try.scala:15)
    at com.twitter.util.ExecutorServiceFuturePool$$anon$4.run(FuturePool.scala:140)
    at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
    at java.util.concurrent.FutureTask.run(FutureTask.java:266)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
    at java.lang.Thread.run(Thread.java:745)
```
group:"com.typesafe.scala-logging", module: "scala-logging_2.11"

---
# Stacktrace cluedo

```
Cause: java.lang.AbstractMethodError: com.criteo.uc.webserver.controllers.AnnotateControllerTest.com$twitter$inject$Logging$_setter_$com$twitter$inject$Logging$$guiceAwareLogger_$eq(Lgrizzled/slf4j/Logger;)V
  at com.twitter.inject.Logging$class.$init$(Logging.scala:131)
  ...
```

group:"com.twitter.inject", module:"inject-core_2.11"

---
# Stacktrace cluedo

```
I 1129 09:39:59.406 THREAD1: Serving admin http on 0.0.0.0/0.0.0.0:57001
java.lang.NoSuchFieldError: WRITE_DURATIONS_AS_TIMESTAMPS
        at com.fasterxml.jackson.datatype.joda.ser.DurationSerializer.<init>(DurationSerializer.java:28)
        at com.fasterxml.jackson.datatype.joda.ser.DurationSerializer.<init>(DurationSerializer.java:25)
        at com.fasterxml.jackson.datatype.joda.JodaModule.<init>(JodaModule.java:45)
...
        at com.criteo.hosting.http.CriteoHttpServer.nonExitingMain(CriteoHttpServer.scala:8)
        at com.twitter.app.App$class.main(App.scala:141)
        at com.criteo.hosting.http.CriteoHttpServer.main(CriteoHttpServer.scala:8)
        at com.criteo.langoustine.app.LangoustineLauncher$class.main(LangoustineLauncher.scala:34)
        at com.criteo.langoustine.app.FastLangoustineLauncher.main(FastLangoustineLauncher.scala:35)
        at com.criteo.enterprise.alpha.langoustine.AlphaApp.main(AlphaApp.scala)
Exception thrown in main on startup
...
FATAL: LoadService: failed to instantiate 'com.twitter.finagle.stats.HostMetricsExporter' for the requested service 'com.twitter.finagle.http.HttpMuxHandler'
com.fasterxml.jackson.databind.JsonMappingException: Jackson version is too old 2.4.4
...

```
(jackson versions to align)

---

# Stacktrace cluedo
```
May 21, 2018 6:24:06 AM io.opencensus.implcore.trace.export.SpanExporterImpl$Worker onBatchExport
WARNING: Exception thrown by the service export io.opencensus.exporter.trace.stackdriver.StackdriverTraceExporter
java.lang.VerifyError: Bad type on operand stack
Exception Details:
Location:
com/google/api/AnnotationsProto.registerAllExtensions(Lcom/google/protobuf/ExtensionRegistryLite;)V @4: invokevirtual
Reason:
Type 'com/google/protobuf/GeneratedMessage$GeneratedExtension' (current frame, stack[1]) is not assignable to 'com/google/protobuf/
Current Frame:
bci: @4
flags: { }
locals: { 'com/google/protobuf/ExtensionRegistryLite' }
stack: { 'com/google/protobuf/ExtensionRegistryLite', 'com/google/protobuf/GeneratedMessage$GeneratedExtension' }
Bytecode:
0x0000000: 2ab2 0003 b600 04b1

at com.google.devtools.cloudtrace.v2.TraceProto.<clinit>(TraceProto.java:198)
...
```

---

# Stacktrace cludo
```
Exception in thread "main" java.lang.NoClassDefFoundError: Could not initialize class org.apache.hadoop.conf.Configuration
	at org.apache.hadoop.security.UserGroupInformation.ensureInitialized(UserGroupInformation.java:304)
	at org.apache.hadoop.security.UserGroupInformation.loginUserFromSubject(UserGroupInformation.java:891)
	at org.apache.hadoop.security.UserGroupInformation.getLoginUser(UserGroupInformation.java:857)
	at org.apache.hadoop.security.UserGroupInformation.getCurrentUser(UserGroupInformation.java:724)
	at com.criteo.cuttle.contrib.yarn.ApplicationMaster.<init>(ApplicationMaster.scala:36)
	at com.criteo.cuttle.contrib.yarn.ApplicationMaster$.main(ApplicationMaster.scala:104)
	at com.criteo.cuttle.contrib.yarn.ApplicationMaster.main(ApplicationMaster.scala)
 ```
---


# Stacktrace cludo

Anyone has one of netty?

---
