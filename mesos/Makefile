STACKNAME := kevinl-mesos
SSH_KEY := kevinl

deploy:
	aws cloudformation create-stack \
		--stack-name $(STACKNAME) \
		--template-body file://./cluster.cf \
		--region $(AWS_REGION) \
		--parameters ParameterKey=KeyName,ParameterValue=$(SSH_KEY)

delete:
	aws cloudformation delete-stack \
		--stack-name $(STACKNAME) \
		--region $(AWS_REGION)
