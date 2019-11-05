#!/usr/bin/env bash

set -euxo

pycicle_root=$SCRATCH/pycicle
instance_name=$1
build_type=$2
pull_request=$3
instance_dir=instance-$instance_name
pushd $pycicle_root

mkdir -p $instance_dir
pushd $instance_dir

cat >run.sh <<EOL
#!/usr/bin/env bash

# Activate the python virtual environment so that it find the github package
activate pycicle
# Rk: activate is a local bash function

PYCICLE_GITHUB_TOKEN="<insert token here>" \
PYCICLE_ROOT=${pycicle_root}/${instance_dir} \
python3 pycicle/pycicle.py \
    --machine "daint-${instance_name}" \
    --project hpx \
    --build-type ${build_type} \
    --pull-request ${pull_request} \
    --debug-info
EOL

chmod +x run.sh

ln -s $HOME/projects/pycicle/

mkdir src

mkdir -p repos
pushd repos
git clone https://github.com/STEllAR-GROUP/hpx.git
popd

mkdir -p build
touch build/emptyfile

popd
popd
