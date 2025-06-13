default:
	git pull
	terraform init
	terraform apply -auto-approve

ansible:
	ansible-playbook i {{app_name}}-interval.devops24.shop, -e ansible_user=ec2-user -e ansible_password=DevOps321 main.yml

terraform-vault:
	cd misc/
	terraform init
	terraform apply -auto-approve -var vault_token=$(vault_token)