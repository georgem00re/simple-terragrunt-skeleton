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
	@aws cloudformation describe-stacks \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --query "Stacks[0].Outputs[?OutputKey=='TerraformStateBucketName'].OutputValue" \
	  --output text \
	  --region $(AWS_REGION) \
	  --profile $(AWS_PROFILE)

cloudformation-get-terraform-state-lock-table-name:
	@aws cloudformation describe-stacks \
	  --stack-name $(CLOUDFORMATION_STACK_NAME) \
	  --query "Stacks[0].Outputs[?OutputKey=='TerraformStateLockTableName'].OutputValue" \
	  --output text \
	  --region $(AWS_REGION) \
	  --profile $(AWS_PROFILE)

.PHONY: terragrunt-command
terragrunt-command:
	TF_STATE_BUCKET_NAME=$$(make --no-print-directory cloudformation-get-terraform-state-bucket-name); \
	TF_STATE_LOCK_TABLE_NAME=$$(make --no-print-directory cloudformation-get-terraform-state-lock-table-name); \
	cd infrastructure-live/$(ENV) && \
	AWS_PROFILE=$(AWS_PROFILE) \
	AWS_REGION=$(AWS_REGION) \
	TF_STATE_BUCKET_NAME=$$TF_STATE_BUCKET_NAME \
	TF_STATE_LOCK_TABLE_NAME=$$TF_STATE_LOCK_TABLE_NAME \
	terragrunt $(ACTION)

# --- STAGING ---
terragrunt-apply-staging:
	$(MAKE) terragrunt-command ACTION=apply ENV=staging

terragrunt-destroy-staging:
	$(MAKE) terragrunt-command ACTION=destroy ENV=staging

# --- PRODUCTION ---
terragrunt-apply-production:
	$(MAKE) terragrunt-command ACTION=apply ENV=production

terragrunt-destroy-production:
	$(MAKE) terragrunt-command ACTION=destroy ENV=production
