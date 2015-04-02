paas
====

Space for personal investigation into PaaS solutions

Notes:

This is all done on AWS, so we require the aws cli and sdk installed.
In addition, I'm predominantly using a coreos cluster as the testbed, so
fleetctl needs to be installed.

Notes for use:

* Install the aws cli
* run `aws configure` to enter access keys
* cd base_stack
* make deploy

Once a `make info` reports that the stack has been completed successfully,
you can do the following:

* cd ../coreos/mesos
* ./cluster.sh deploy

This will deploy mesos across the cluster you just deployed.

Once a `./cluster.sh status` shows the marathon unit as running successfully,
you can run `./cluster.sh marathon_url` and go to the url it returns.

To deploy a test something to mesos, you can run `./cluster.sh run nginx.json`
- that will run up 2 instances of an nginx server. Unfortunately there's no
simple way to get the web pages from that, but you can see and scale the
deployment through marathon, at least.
