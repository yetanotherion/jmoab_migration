# Industrialize migration


* Jobs emulating all cases, bugs found when maven depends on gradle: Schedule the migration from the leaves.

--

* Topo-sort computed, changes continuously generated /rebased on non migrated leaves only.

--
* Find owner of each repo...

--

* Build-services members assign themselves to one repo:
  * Take contact with devlead
  * Training
  * Manual fixes, participate in integration test debugging.

--

* Maven/Gradle comparison tooling:

  * diff artifacts
  * test results/numbers ("what? 0 tests in my maven project? I was SURE I had some")

--

* issues: scala compatibility, IntelliJ integration...

--
  * .red[__classpath__ __order__]

---
class: center
# Industrialize migration


![topo_sort](imgs/topo-sort.png)

---

class: center
# Industrialize migration


![conversion_change_comments](imgs/conversion_change_comments.png)

---

class: center
# Industrialize migration


![conversion_change](imgs/conversion_change.png)

---


class: center
# Industrialize migration


![conversion_please_diff_publish](imgs/conversion_please_diff_publish.png)

---

class: center
# Industrialize migration


![conversion_diff_first](imgs/conversion_diff_first.png)

---
