HOST := ec2-54-66-151-123.ap-southeast-2.compute.amazonaws.com

deploy-master:
	fleetctl --tunnel $(HOST) \
		load master.service

ssh:
	ssh core@$(HOST)
