HOST := `aws ec2 describe-instances --region=ap-southeast-2 --filters="Name=tag-value,Values=kevinl-coreos"  | grep PublicDnsName | cut -d\" -f4 | head -1`

deploy:
	fleetctl --tunnel $(HOST) destroy mesos-*.service
	fleetctl --tunnel $(HOST) submit mesos-*.service
	fleetctl --tunnel $(HOST) load mesos-master.service
	fleetctl --tunnel $(HOST) load mesos-slave.service
	fleetctl --tunnel $(HOST) list-units

ssh:
	ssh core@$(HOST)
