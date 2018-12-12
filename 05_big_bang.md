### Big bang (May 2017)

Idea:
* Use a converter that will be capable of converting all poms in one shot.
* Use two jmoab: one full maven, one full gradle compare the two until results are the same.
* Merge big-cross repo when everything is done

[Feasibility study](https://confluence.criteois.com/display/RP/Feasibility+of+maven+to+gradle+automated+translation)

--
* 637 pom.xml

--
* 50 reviews merged per week on pom

--
* must automate translation of plugins:
   * 47 plugins used in the JMOAB
   * 28 deemed indispensable

--

__GO__

---
layout: false
# Goals to reach

[JMOAB2 Kick-off (Aug/2017)](https://confluence.criteois.com/display/RP/Kick-off%3A+Towards+an+Efficient+JMOAB): JMOAB in gradle

--
 * JMOAB builds should be less than 30 minutes.

--
 * JMOAB presubmits should be less than 30 minutes (worst case scenario).

--
 * JMOAB jobs should scale with respect to the code base size.

--
 * Pave the way for later improvements (i.e. choose a build tool which can be easily customized and is actively maintained)

---
