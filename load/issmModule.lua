-- help
help([[
]])

-- system variables

-- local variables
local ModuleRoot = "@ISSM_DIR"
local INSTALL_TRIANGLE = @INSTALL_TRIANGLE
local INSTALL_PETSC = @INSTALL_PETSC

-- whatis
whatis("module name: "..myModuleName())
whatis("module version: "..myModuleVersion())
whatis("full module name: "..myModuleFullName())
whatis("module root: "..ModuleRoot)

-- dependencies
prereq("gcc")
prereq("openmpi")

if INSTALL_TRIANGLE == 0
then
  load("libtriangle")
else
  prepend_path("LD_LIBRARY_PATH", ModuleRoot.."/externalpackages/triangle/install/lib")
end
if INSTALL_PETSC == 0
then
  prereq("PETSc")
else
  prepend_path("LD_LIBRARY_PATH", ModuleRoot.."/externalpackages/petsc/install")
end
load("papi")
--load("matlab/R2020b")

-- environment
prepend_path("PATH", pathJoin(ModuleRoot, "bin"))
setenv("ISSM_DIR", ModuleRoot)
setenv("ISSM_ROOT", ModuleRoot)

-- messages
LmodMessage("Lmod: ", mode().."ing ", myModuleName().." ", myModuleVersion())
local ISSM_DIR = os.getenv("ISSM_DIR")
LmodMessage("ISSM directory is "..ISSM_DIR)

