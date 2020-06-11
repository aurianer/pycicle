set(PYCICLE_MACHINE "pycicle")
set(PYCICLE_HTTP TRUE)
set(PYCICLE_JOB_LAUNCH "slurm")
set(PYCICLE_BUILD_TYPE "Debug")


set(LOCAL_ROOT          "/apps/daint/UES/simbergm/local")
set(CMAKE_VER           "3.12.0")
set(GCC_VER             "7.3.0")
set(CXX_STD             "14")
set(BOOST_VER           "1.70.0")
set(TCMALLOC_VER        "2.7")
set(HWLOC_VER           "2.0.1")
set(CUDA_VER            "9.2.148_3.19-6.0.7.1_2.1__g3d9acc8")
set(BOOST_ROOT          "${LOCAL_ROOT}/boost-${BOOST_VER}-gcc-${GCC_VER}-c++${CXX_STD}-debug")
set(HWLOC_ROOT          "${LOCAL_ROOT}/hwloc-${HWLOC_VER}-gcc-${GCC_VER}")
set(TCMALLOC_ROOT       "${LOCAL_ROOT}/gperftools-${TCMALLOC_VER}-gcc-${GCC_VER}")
set(CFLAGS              "")
set(CXXFLAGS            "")
set(LDFLAGS             "")
set(LDCXXFLAGS          "${LDFLAGS}")

set(PYCICLE_BUILD_STAMP "gcc-cuda")

set(CTEST_SITE "cray(daint)")
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_TEST_TIMEOUT "200")
set(BUILD_PARALLELISM  "32")
string(CONCAT CTEST_BUILD_OPTIONS ${CTEST_BUILD_OPTIONS}
    "\"-DCMAKE_CXX_FLAGS=${CXXFLAGS}\" "
    "\"-DCMAKE_C_FLAGS=${CFLAGS}\" "
    "\"-DCMAKE_EXE_LINKER_FLAGS=${LDCXXFLAGS}\" "
    "  -DHPX_WITH_CXX${CXX_STD}=ON "
    "  -DHPX_WITH_CUDA=ON "
    "  -DHPX_WITH_NATIVE_TLS=ON "
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
    "  -DHPX_WITH_MAX_CPU_COUNT=128 "
    "  -DDART_TESTING_TIMEOUT:STRING=200 "
)

# Add a random delay
execute_process(COMMAND "bash" "-c" "echo -n $(( RANDOM % (6 * 60) ))"
    OUTPUT_VARIABLE BEGIN_DELAY_MINUTES)

set(PYCICLE_JOB_SCRIPT_TEMPLATE "#!/bin/bash
#SBATCH --job-name=hpx-${PYCICLE_PR}-${PYCICLE_BUILD_STAMP}
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --constraint=gpu
#SBATCH --partition=normal
#SBATCH --begin=now+${BEGIN_DELAY_MINUTES}minutes

export CRAYPE_LINK_TYPE=dynamic

module load daint-gpu
module switch PrgEnv-cray PrgEnv-gnu
module switch gcc gcc/${GCC_VER}
module load CMake/${CMAKE_VER}
module load cudatoolkit/${CUDA_VER}

export CFLAGS=\"${CFLAGS}\"
export CXXFLAGS=\"${CXXFLAGS}\"
export LDFLAGS=\"${LDFLAGS}\"
export LDCXXFLAGS=\"${LDCXXFLAGS}\"
export CXX=`which CC`
export CC=`which cc`

#export HPXRUN_RUNWRAPPER=srun
"
)
