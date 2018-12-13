# Nearing the end

???
To Manu

--
- What has changed:
   - Criteo code gained some more weight:
      - ~~239~~ 304 repositories
      - ~~652~~ 953 projects
   - 74% of repositories migrated


--

- What about our goals?
   - Reduce the duration of JMOAB-build to less than 30 minutes.

--
.green[YES]
--

   - Reduce the duration of JMOAB-pre-submit to less than 30 minutes (worst case scenario).

--
.red[NO]
--

      - 95pt almost <span class="green">YES</span>
--
   - Make JMOAB-build and JMOAB-pre-submit scale with respect to the code base size.

--
.green[YES]
--

   - Pave the way for later improvements (i.e. choose a build tool which can be easily customized and is actively maintained)
--

      - if gradle will support distributed builds <span class="green">YES</span>
--
      - else: gradle to bazel? <div class="side">(uber: [okbuck](https://github.com/uber/okbuck)) ![no_kidding](imgs/no_kidding.jpg)</div>

---
