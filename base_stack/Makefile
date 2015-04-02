STACKNAME := kjlcoreos
CF_FILENAME := stack.json
AWS_REGION := ap-southeast-2

deploy:
	./generate_params.rb
	aws cloudformation create-stack \
		--stack-name $(STACKNAME) \
		--template-body file://$(CF_FILENAME) \
		--region $(AWS_REGION) \
		--parameters file://params.json

destroy:
	aws cloudformation delete-stack \
		--stack-name $(STACKNAME) \
		--region $(AWS_REGION)

update:
	aws cloudformation update-stack \
		--stack-name $(STACKNAME) \
		--template-body file://$(CF_FILENAME) \
		--region $(AWS_REGION) \
		--parameters file://params.json

info:
	aws cloudformation describe-stacks --stack-name $(STACKNAME) --region $(AWS_REGION)

params.json:
	./generate_params.rb
