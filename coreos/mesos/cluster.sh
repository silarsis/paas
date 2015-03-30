#!/bin/bash -e
#
# Tools to manage a deployed cluster

REGION=ap-southeast-2
STACK_NAME="kevinl-coreos"
export FLEETCTL_TUNNEL=$(aws ec2 describe-instances --region=${REGION} --filters="Name=tag-value,Values=${STACK_NAME}" | grep PublicDnsName | cut -d\" -f4 | grep -v '^$' | head -1)

fleet_url() {
  curl -s https://api.github.com/repos/coreos/fleet/releases | grep browser_download_url | grep `uname -s | awk '{ print tolower($0) }'`-amd64 | head -1 | awk -F': ' '{ print $2 }' | sed 's/^"\(.*\)"$/\1/'
}

fleet_filename() {
  echo fleet_url | rev | cut -d/ -f1 | rev
}

fleet_dir() {
  basename $(basename fleet_filename .zip) .tar.gz
}

# Public methods beyond here

install_fleetctl() {
  exit 1 # Not working yet, ported from Makefile
  rm -rf fleet_dir
  curl -#LO fleet_url
  tar zxf fleet_filename
  rm fleet_filename
  mv $(find fleet_dir/ -iname fleetctl) ./fleetctl
  rm -rf fleet_dir
}

fleet_deploy() {
  mkdir -p deployed
  cp mesos-*.service deployed/
  sed -i s/\<ZK_IP\>/${FLEETCTL_TUNNEL}/ deployed/mesos-*.service
  ./fleetctl destroy deployed/mesos-*.service
  ./fleetctl submit deployed/mesos-*.service
  ./fleetctl load deployed/mesos-*.service
  ./fleetctl list-units
}

fleet_start() {
  ./fleetctl stop deployed/mesos-*.service
  ./fleetctl start deployed/mesos-*.service
  ./fleetctl list-units
}

fleet_status() {
  ./fleetctl list-units
}

fleet_env() {
  echo "export FLEETCTL_TUNNEL=${FLEETCTL_TUNNEL}"
}

fleet_ssh() {
  ssh core@${FLEETCTL_TUNNEL}
}

case $1 in
  ssh)
    fleet_ssh
    ;;
  env)
    fleet_env
    ;;
  status)
    fleet_status
    ;;
  start)
    fleet_start
    ;;
  deploy)
    fleet_deploy
    ;;
esac
