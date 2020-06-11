set(PYCICLE_MACHINE "pycicle")
set(PYCICLE_HTTP TRUE)
set(PYCICLE_JOB_LAUNCH "slurm")
set(PYCICLE_BUILD_TYPE "Debug")

set(LOCAL_ROOT          "/apps/daint/UES/simbergm/local")
set(GCC_VER             "7.5.0")
set(CXX_STD             "14")
set(BOOST_VER           "1.61.0")
set(HWLOC_VER           "1.11.5")
set(GCC_ROOT            "${LOCAL_ROOT}/gcc-${GCC_VER}")
set(BOOST_ROOT          "${LOCAL_ROOT}/boost-${BOOST_VER}-gcc-${GCC_VER}-c++${CXX_STD}-debug")
set(HWLOC_ROOT          "${LOCAL_ROOT}/hwloc-${HWLOC_VER}-gcc-${GCC_VER}")
set(CFLAGS              "")
set(CXXFLAGS            "-Wno-unused-command-line-argument -nostdinc++ -I${GCC_ROOT}/include/c++/${GCC_VER} -I${GCC_ROOT}/include/c++/${GCC_VER}/x86_64-unknown-linux-gnu -I${GCC_ROOT}/include/c++/${GCC_VER}/x86_64-pc-linux-gnu -L${GCC_ROOT}/lib64 -Wl,-rpath,${GCC_ROOT}/lib64")
set(LDFLAGS             "")
set(LDCXXFLAGS          "-L${GCC_ROOT}/lib64")

set(PYCICLE_BUILD_STAMP "gcc-oldest")

set(CTEST_SITE "cray(daint)")
set(CTEST_CMAKE_GENERATOR "Ninja")
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
    "  -DHPX_WITH_GENERIC_CONTEXT_COROUTINES=ON "
    "  -DHPX_WITH_EXAMPLES=ON "
    "  -DHPX_WITH_TESTS=ON "
    "  -DHPX_WITH_TESTS_BENCHMARKS=ON "
    "  -DHPX_WITH_TESTS_EXTERNAL_BUILD=ON "
    "  -DHPX_WITH_TESTS_HEADERS=OFF "
    "  -DHPX_WITH_TESTS_REGRESSIONS=ON "
    "  -DHPX_WITH_TESTS_UNIT=ON "
    "  -DHPX_WITH_DEPRECATION_WARNINGS=OFF "
    "  -DHPX_WITH_COMPILER_WARNINGS=ON "
    "  -DHPX_WITH_COMPILER_WARNINGS_AS_ERRORS=ON "
    "  -DHPX_WITH_PARCELPORT_MPI=OFF "
    "  -DHPX_WITH_SPINLOCK_DEADLOCK_DETECTION=ON "
    "  -DHPX_WITH_MAX_CPU_COUNT=128 "
    "  -DDART_TESTING_TIMEOUT:STRING=200 "
)
    #"  -DTCMALLOC_ROOT=${TCMALLOC_ROOT} "
    #"  -DHPX_WITH_PAPI=ON "
    #"  -DHPX_WITH_APEX=ON "
    #"  -DHPX_WITH_SPINLOCK_DEADLOCK_DETECTION=ON "
    #"  -DHPX_WITH_THREAD_BACKTRACE_ON_SUSPENSION=ON "
    #"  -DHPX_WITH_THREAD_DESCRIPTION_FULL=ON "
    #"  -DHPX_WITH_THREAD_CREATION_AND_CLEANUP_RATES=ON "
    #"  -DHPX_WITH_THREAD_IDLE_RATES=ON "
    #"  -DHPX_WITH_THREAD_QUEUE_WAITTIME=ON "

# Add a random delay
execute_process(COMMAND "bash" "-c" "echo -n $(( RANDOM % (10 * 60) ))"
    OUTPUT_VARIABLE BEGIN_DELAY_MINUTES)

set(PYCICLE_JOB_SCRIPT_TEMPLATE "#!/bin/bash
#SBATCH --job-name=hpx-${PYCICLE_PR}-${PYCICLE_BUILD_STAMP}
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --constraint=mc
#SBATCH --partition=normal
#SBATCH --begin=now+${BEGIN_DELAY_MINUTES}minutes

export CRAYPE_LINK_TYPE=dynamic

module load   daint-mc
module load   CMake
module unload perftools-base
module load   papi

export CFLAGS=\"${CFLAGS}\"
export CXXFLAGS=\"${CXXFLAGS}\"
export LDFLAGS=\"${LDFLAGS}\"
export LDCXXFLAGS=\"${LDCXXFLAGS}\"
export CXX=${GCC_ROOT}/bin/g++
export CC=${GCC_ROOT}/bin/gcc
export PATH=/apps/daint/UES/simbergm/spack/opt/spack/cray-cnl7-haswell/gcc-8.3.0/ninja-1.10.0-dcy5yzzldhss6wycy2ejjwj7o75dfddz/bin/:$PATH

#export HPXRUN_RUNWRAPPER=srun
"
)
