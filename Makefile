STACKNAME := kjl
CF_FILENAME := stack.template

deploy:
	aws cloudformation create-stack \
		--stack-name $(STACKNAME) \
		--template-body file://$(CF_FILENAME) \
		--region $(AWS_REGION) \
		--parameters file://params.json

delete:
	aws cloudformation delete-stack \
		--stack-name $(STACKNAME) \
		--region $(AWS_REGION)

update:
	aws cloudformation update-stack \
		--stack-name $(STACKNAME) \
		--template-body file://$(CF_FILENAME) \
		--region $(AWS_REGION) \
		--parameters file://params.json
