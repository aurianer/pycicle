set(PYCICLE_MACHINE "pycicle")
set(PYCICLE_HTTP TRUE)
set(PYCICLE_JOB_LAUNCH "slurm")
set(PYCICLE_BUILD_TYPE "Debug")

set(LOCAL_ROOT          "/apps/daint/UES/simbergm/local")
set(CMAKE_VER           "3.12.0")
set(CLANG_VER           "8.0")
set(CXX_STD             "17")
set(BOOST_VER           "1.69.0")
set(TCMALLOC_VER        "2.7")
set(HWLOC_VER           "2.0.3")
set(CLANG_ROOT          "${LOCAL_ROOT}/llvm-${CLANG_VER}")
set(BOOST_ROOT          "${LOCAL_ROOT}/boost-${BOOST_VER}-clang-${CLANG_VER}-c++${CXX_STD}-debug")
set(HWLOC_ROOT          "${LOCAL_ROOT}/hwloc-${HWLOC_VER}-clang-${CLANG_VER}")
set(TCMALLOC_ROOT       "${LOCAL_ROOT}/gperftools-${TCMALLOC_VER}-clang-${CLANG_VER}")
set(CFLAGS              "")
set(CXXFLAGS            "${CFLAGS} -fsanitize=address -fno-omit-frame-pointer -Wno-unused-command-line-argument -stdlib=libc++ -nostdinc++ -I${CLANG_ROOT}/include/c++/v1 -L${CLANG_ROOT}/lib -Wl,-rpath,${CLANG_ROOT}/lib")
set(LDFLAGS             "")
set(LDCXXFLAGS          "${LDFLAGS} -fsanitize=address -stdlib=libc++ -L${CLANG_ROOT}/lib -Wl,-rpath,${CLANG_ROOT}/lib")

set(PYCICLE_BUILD_STAMP "clang-asan")

set(CTEST_SITE "cray(daint)")
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_TEST_TIMEOUT "200")
set(BUILD_PARALLELISM  "32")
string(CONCAT CTEST_BUILD_OPTIONS ${CTEST_BUILD_OPTIONS}
    "\"-DCMAKE_CXX_FLAGS=${CXXFLAGS}\" "
    "\"-DCMAKE_C_FLAGS=${CFLAGS}\" "
    "\"-DCMAKE_EXE_LINKER_FLAGS=${LDCXXFLAGS}\" "
    "  -DHPX_WITH_CXX${CXX_STD}=ON "
    "  -DHPX_WITH_MALLOC=system "
    "  -DHWLOC_ROOT=${HWLOC_ROOT} "
    "  -DBOOST_ROOT=${BOOST_ROOT} "
    "  -DHPX_WITH_EXAMPLES=ON "
    "  -DHPX_WITH_TESTS=ON "
    "  -DHPX_WITH_TESTS_BENCHMARKS=ON "
    "  -DHPX_WITH_TESTS_EXTERNAL_BUILD=OFF "
    "  -DHPX_WITH_TESTS_HEADERS=OFF "
    "  -DHPX_WITH_TESTS_REGRESSIONS=ON "
    "  -DHPX_WITH_TESTS_UNIT=ON "
    "  -DHPX_WITH_DEPRECATION_WARNINGS=OFF "
    "  -DHPX_WITH_COMPILER_WARNINGS=ON "
    "  -DHPX_WITH_COMPILER_WARNINGS_AS_ERRORS=ON "
    "  -DHPX_WITH_PARCELPORT_MPI=OFF "
    "  -DHPX_WITH_NETWORKING=ON "
    "  -DHPX_WITH_SPINLOCK_DEADLOCK_DETECTION=ON "
    "  -DHPX_WITH_MAX_CPU_COUNT=128 "
    "  -DHPX_WITH_SANITIZERS=ON "
    "  -DHPX_WITH_STACK_OVERFLOW_DETECTION=OFF "
)

# Add a random delay
execute_process(COMMAND "bash" "-c" "echo -n $(( RANDOM % (1 * 60) ))"
    OUTPUT_VARIABLE BEGIN_DELAY_MINUTES)

set(PYCICLE_JOB_SCRIPT_TEMPLATE "#!/bin/bash
#SBATCH --job-name=hpx-${PYCICLE_PR}-${PYCICLE_BUILD_STAMP}
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --constraint=mc
#SBATCH --partition=normal
#SBATCH --begin=now+${BEGIN_DELAY_MINUTES}minutes

export CRAYPE_LINK_TYPE=dynamic

module load   daint-mc
module load   CMake/${CMAKE_VER}

export CFLAGS=\"${CFLAGS}\"
export CXXFLAGS=\"${CXXFLAGS}\"
export LDFLAGS=\"${LDFLAGS}\"
export LDCXXFLAGS=\"${LDCXXFLAGS}\"
export CC=\"${CLANG_ROOT}/bin/clang\"
export CXX=\"${CLANG_ROOT}/bin/clang++\"
export CPP=\"${CLANG_ROOT}/bin/clang -E\"
export ASAN_SYMBOLIZER_PATH=${CLANG_ROOT}/bin/llvm-symbolizer

#export HPXRUN_RUNWRAPPER=srun
"
)
