default:
	git pull
	terraform init
	terraform apply -auto-approve

ansible:
	ansible-playbook -i $(tool_name)-internal.devops24.shop, -e ansible_user=ec2-user -e ansible_password=DevOps321 -e tool_name=$(tool_name) main.yml

terraform-vault:
	cd misc/vault_secrets/
	terraform init
	terraform apply -auto-approve -var vault_token=$(vault_token)

dev-destroy:
	rm -rf .terraform
	terraform init -backend-config=env-dev/state.tfvars
	terraform destroy -auto-approve -var-file=env-dev/main.tfvars

terraform-install:
	sudo curl -L -o /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	sudo yum -y install terraform