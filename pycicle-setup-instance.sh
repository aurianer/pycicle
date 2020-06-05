#!/usr/bin/env bash

set -euxo

pycicle_root=$SCRATCH/pycicle
instance_name=$1
build_type=$2
pull_request=$3
instance_dir=instance-$instance_name
pushd $pycicle_root

mkdir $instance_dir
pushd $instance_dir

# To prevent the api token from being discovered
set +x
# Don't forget to set the permission on the .github_api_token to 400
github_token="\$(cat $HOME/.github_api_token)"
set -x

cat >run.sh <<EOL
#!/usr/bin/env bash

PYCICLE_GITHUB_TOKEN="$github_token" \
PYCICLE_ROOT=${pycicle_root}/${instance_dir} \
python2 pycicle/pycicle.py \
    --machine "daint-${instance_name}" \
    --project hpx \
    --build-type ${build_type} \
    --pull-request ${pull_request} \
    --debug-info
EOL

chmod +x run.sh

ln -s $APPS/UES/simbergm/src/pycicle/

mkdir src

mkdir repos
pushd repos
git clone https://github.com/STEllAR-GROUP/hpx.git
popd

mkdir build
touch build/emptyfile

popd
popd
