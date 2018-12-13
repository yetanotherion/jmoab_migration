class: center
# What is that?

![jmoab_full](imgs/jmoab_full.png)

---

class: center
# What is that?

![jmoab_zoom](imgs/zoom.png)

---
# State of JMOAB with maven

- March 2017
  - 239 repositories
  - 652 projects
  - 2h+ for a new change in the JMOAB to be deployable
  - 3h for a presubmit on parent-poms

---
# State of JMOAB with maven

- .side[![repositories](imgs/legacyPipelineRepos.png)]March 2017
  - 239 repositories
  - 652 projects
  - 2h+ for a new change in the JMOAB to be deployable
  - 3h for a presubmit on parent-poms
  - pipeline driven by dependency graph
.center[![design](imgs/legacyPipeline.png)]

---
# Why changing? It works!
--

- 239 repositories
- 652 projects
- 2h+ for a new change in the JMOAB to be deployable
- 3h for a presubmit on parent-poms
- pipeline driven by dependency graph

---
# Why changing? It works!

- 239 repositories
- 652 projects
- .red[2h+ for a new change in the JMOAB to be deployable]
- .red[3h for a presubmit on parent-poms]
- pipeline driven by dependency graph

.center[![compiling](imgs/compiling.png)]
---
# Why changing? It works!

- 239 repositories
- 652 projects
- .red[2h+ for a new change in the JMOAB to be deployable]
- .red[3h for a presubmit on parent-poms]
- pipeline driven by dependency graph
- .red[poms are not maintainable]

???
To Ion
---
