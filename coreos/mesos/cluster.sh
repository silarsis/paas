#!/bin/bash -e
#
# Tools to manage a deployed cluster

REGION=ap-southeast-2
STACK_NAME="kevinl-coreos"
FLEETCTL="/usr/local/home/silarsis/git/paas/coreos/mesos/fleetctl"
export FLEETCTL_TUNNEL=$(aws ec2 describe-instances --region=${REGION} --filters="Name=tag-value,Values=${STACK_NAME}" | grep PublicDnsName | cut -d\" -f4 | grep -v '^$' | head -1)

[ -z "${FLEETCTL_TUNNEL}" ] && { echo "No instance available, exiting"; exit 1; }

fleet_url() {
  curl -s https://api.github.com/repos/coreos/fleet/releases | grep browser_download_url | grep `uname -s | awk '{ print tolower($0) }'`-amd64 | head -1 | awk -F': ' '{ print $2 }' | sed 's/^"\(.*\)"$/\1/'
}

fleet_filename() {
  echo fleet_url | rev | cut -d/ -f1 | rev
}

zookeeper_ip() {
  ../fleetctl list-units | grep zookeeper | awk '{ print $2 }' | cut -d'/' -f2
}

marathon_public_ip() {
  ${FLEETCTL} list-machines -fields="machine,metadata" | grep $(${FLEETCTL} list-units -fields=unit,machine | grep marathon | awk '{ print $2 }' | cut -d'.' -f1) | awk '{ print $2 }' | cut -d'=' -f2
}

wait_for() {
  until ${FLEETCTL} list-units | grep "$1" | grep running; do
    echo "Waiting for $1..."
    sleep 1
  done
}

fleet_dir() {
  basename $(basename fleet_filename .zip) .tar.gz
}

marathon_url() {
  echo "http://$(marathon_public_ip):8080/"
}

load_start_unit() {
  set -x
  ${FLEETCTL} submit $1
  ${FLEETCTL} load $1
  ${FLEETCTL} start $1
  set +x
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
  rm -rf deployed
  mkdir -p deployed
  cp mesos-*.service deployed/
  pushd deployed
  fleet_destroy
  load_start_unit "mesos-zookeeper.service"
  wait_for "zookeeper"
  ZK_IP=$(zookeeper_ip)
  sed -i s/\<ZK_IP\>/${ZK_IP}/ mesos-master.service
  load_start_unit "mesos-master.service"
  wait_for "master"
  sed -i s/\<ZK_IP\>/${ZK_IP}/ mesos-slave.service
  load_start_unit "mesos-slave.service"
  sed -i s/\<ZK_IP\>/${ZK_IP}/ mesos-marathon.service
  load_start_unit "mesos-marathon.service"
  popd
  ./fleetctl list-units
  echo "Marathon available on $(marathon_url)"
}

fleet_start() {
  pushd deployed
  ../fleetctl stop mesos-*.service
  ../fleetctl start mesos-zookeeper.service
  ../fleetctl start mesos-*.service
  popd
  ./fleetctl list-units
}

fleet_destroy() {
  pushd deployed
  ../fleetctl destroy mesos-*.service
  popd
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

marathon_deploy() {
  pushd jobs
  curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" $(marathon_url)v2/apps -d @$1
  popd
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
  deploy)
    fleet_deploy
    ;;
  run)
    marathon_deploy $2
    ;;
  url)
    echo $(marathon_url)
    ;;
  destroy)
    fleet_destroy
    ;;
  *)
    echo "Unrecognised command"
    echo "ssh, env, url, status, deploy, run"
    exit 1
    ;;
esac
