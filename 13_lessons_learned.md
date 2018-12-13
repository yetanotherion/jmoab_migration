# Agenda

- **March-July 2017**: Coming up with the plan

- **August-December 2017**: Going for the big bang

- **December 2017**: a crisis of faith

- **January-June 2018**: new ideas

- **July 2018 - ?**: full scale migration

- .red[Lessons learned]
---
# Lessons learned

- If you think a one shot deal is possible, you've not searched long enough for the alternative

--
- What we learned about our code:

--
   - uber jars and package generation is a mess:
      - difficult to know what should be in and what should be out
      - exclusion logic often duplicated in many projects
--
   - class relocation happens quite often


--

- Look for better governance in build scripts
   - know your build
   - prevent technical debt

???
- in maven pom files, the logic behind dependency exclusion or relocation is mostly unknown to anyone, making it very hard to change.
- Build files can have very expensive tech-debt
   - most of the cost
     - reverse-engineering what was copy/pasted was not
     - classpath ordering issues
---
