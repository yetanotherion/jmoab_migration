# Lessons learned

- If you think a one shot deal is possible, you've not searched enough for the alternative
- Look for better governance in build scripts
   - know your build
   - prevent technical debt
- Communicate better

.center[![classroom](imgs/classroom.jpg)]
???
- in maven pom files, the logic behind dependency exclusion or relocation is mostly unknown to anyone, making it very hard to change.
- Build files can have very expensive tech-debt
   - most of the cost
     - reverse-engineering what was copy/pasted was not
     - classpath ordering issues

---
