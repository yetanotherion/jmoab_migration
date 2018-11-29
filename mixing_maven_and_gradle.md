# Mixing maven and gradle (April 2017)

How others did
* [Braintree/gradle to bazel](https://www.pgrs.net/2015/09/01/migrating-from-gradle-to-Idea/):
  * 20 projects
  * [BazelDeps](https://github.com/johnynek/bazel-deps) tool to migrate (no factorization of build logic though)
  * ended-up migration manually
* [Linkedin/sbt to gradle](https://engineering.linkedin.com/blog/2018/07/how-we-improved-build-time-by-400-percent)
  * 330 Play apps
  * 2015: migrate everything: fail
  * 2016: put one app in production learn from there
  * migrate everything manually (2 years)
* [Redfin/mvn to bazel](https://redfin.engineering/we-switched-from-maven-to-bazel-and-builds-got-10x-faster-b265a7845854)
  * 300 maven projects (java/javascript only)
  * mix of auto/manual fixes

---
# Mixing maven and gradle (April 2017)
First try
[mvn and gradle in the jmoab](https://confluence.criteois.com/pages/viewpage.action?pageId=326303105)

* Avoids big bang integration/distributes migration/validation
But,
* no cross-repo in IDE
* requires temporary development in BFS
* no vision on how the script files will look like in the end.

NOGO
---
