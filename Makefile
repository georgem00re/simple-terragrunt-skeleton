include .env

cloudformation-deploy-stack:
	aws cloudformation deploy \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --template-file ./cloudformation-templates/main.yml \
	  --capabilities CAPABILITY_NAMED_IAM \
	  --region $(AWS_REGION) \
      --profile $(AWS_PROFILE) \
      --parameter-overrides \
          RepositoryName=$(REPOSITORY_NAME) \
          RepositoryOwner=$(ORGANISATION_NAME) \

cloudformation-delete-stack:
	aws cloudformation delete-stack \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --region $(AWS_REGION) \
	  --profile $(AWS_PROFILE)

cloudformation-get-terraform-state-bucket-name:
	aws cloudformation describe-stacks \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --query "Stacks[0].Outputs[?OutputKey=='TerraformStateBucketName'].OutputValue" \
	  --output text \
	  --region $(AWS_REGION) \
	  --profile $(AWS_PROFILE)

cloudformation-get-terraform-state-lock-table-name:
	aws cloudformation describe-stacks \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --query "Stacks[0].Outputs[?OutputKey=='TerraformStateLockTableName'].OutputValue" \
	  --output text \
	  --region $(AWS_REGION) \
	  --profile $(AWS_PROFILE)
