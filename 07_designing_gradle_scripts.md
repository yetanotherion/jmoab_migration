# Designing for gradle

### Features:
   - should be reminescent of existing maven toolkit
   - auto discovery of projects
   - partial checkout (developer use case)
   - support generation from converter
   - versioned inside the MOAB


--

### Plugins!
   - BfsPlugin
   - MoabWorkspacePlugin / MoabModulePlugin
   - LibraryManagementPlugin
   - SeedsPlugin

???
- BfsPlugin: tooling for managing workspace (init, checkout, refresh)
- MoabWorkspacePlugin: tooling for auto discovery of projects, partial checkouts, publication
- LibraryManagementPlugin/DelayedPlugin: maven like dependency constraints declaration for easier conversion
- SeedsPlugin: easily run tasks on client projects

---
