set(PYCICLE_MACHINE "pycicle")
set(PYCICLE_HTTP TRUE)
set(PYCICLE_JOB_LAUNCH "slurm")
set(PYCICLE_BUILD_TYPE "Debug")

set(LOCAL_ROOT          "/apps/daint/UES/simbergm/local")
set(CMAKE_VER           "3.12.0")
set(CLANG_VER           "4.0")
set(CXX_STD             "11")
set(BOOST_VER           "1.61.0")
set(TCMALLOC_VER        "2.7")
set(HWLOC_VER           "1.11.11")
set(CLANG_ROOT          "${LOCAL_ROOT}/llvm-${CLANG_VER}")
set(BOOST_ROOT          "${LOCAL_ROOT}/boost-${BOOST_VER}-clang-${CLANG_VER}-c++${CXX_STD}-release")
set(HWLOC_ROOT          "${LOCAL_ROOT}/hwloc-${HWLOC_VER}-clang-${CLANG_VER}")
set(TCMALLOC_ROOT       "${LOCAL_ROOT}/gperftools-${TCMALLOC_VER}-clang-${CLANG_VER}")
set(CFLAGS              "-fPIC")
set(CXXFLAGS            "-fPIC -march=native -mtune=native -Wno-unused-command-line-argument -stdlib=libc++ -nostdinc++ -I${CLANG_ROOT}/include/c++/v1 -L${CLANG_ROOT}/lib -Wl,-rpath,${CLANG_ROOT}/lib,-lsupc++")
set(LDFLAGS             "")
set(LDCXXFLAGS          "${LDFLAGS} -stdlib=libc++ -L${CLANG_ROOT}/lib -Wl,-rpath,${CLANG_ROOT}/lib,-lsupc++")

set(PYCICLE_BUILD_STAMP "clang-oldest")

set(CTEST_SITE "cray(daint)")
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_TEST_TIMEOUT "200")
set(BUILD_PARALLELISM  "32")
string(CONCAT CTEST_BUILD_OPTIONS ${CTEST_BUILD_OPTIONS}
    "\"-DCMAKE_CXX_FLAGS=${CXXFLAGS}\" "
    "\"-DCMAKE_C_FLAGS=${CFLAGS}\" "
    "\"-DCMAKE_EXE_LINKER_FLAGS=${LDCXXFLAGS}\" "
    "  -DHPX_WITH_CXX${CXX_STD}=ON "
    "  -DHPX_WITH_NATIVE_TLS=ON "
    "  -DHPX_WITH_MALLOC=system "
    "  -DTCMALLOC_ROOT=${TCMALLOC_ROOT} "
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
    "  -DHPX_WITH_COMPILER_WARNINGS_AS_ERRORS=OFF "
    "  -DHPX_WITH_PARCELPORT_MPI=OFF "
    "  -DHPX_WITH_SPINLOCK_DEADLOCK_DETECTION=ON "
    "  -DHPX_WITH_THREAD_SCHEDULERS=\"abp-priority;local;static-priority;static\" "
    "  -DHPX_WITH_MAX_CPU_COUNT= "
    "  -DDART_TESTING_TIMEOUT:STRING=200 "
    "  -DHPX_WITH_CXX11_ALIGNAS=OFF "
)

# Add a random delay
execute_process(COMMAND "bash" "-c" "echo -n $(( RANDOM % (12 * 60) ))"
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

#export HPXRUN_RUNWRAPPER=srun
"
)
