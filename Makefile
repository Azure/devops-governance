init-dev:
	. ./.env.dev
	terraform init -backend-config=backends/dev.hcl

init-prod:
	. ./.env
	terraform init -backend-config=backends/prod.hcl

plan-dev:
	terraform plan -var-file=environments/dev.tfvars -out plan.tfplan

plan-prod:
	terraform plan -var-file=environments/prod.tfvars -out plan.tfplan

apply:
	terraform apply plan.tfplan