#!/bin/bash

# Navigate to the Terraform directory and run Terraform commands
echo "Running Terraform..."
cd /home/ubuntu/Headway/terraform
terraform init   # Initialize Terraform
terraform apply  # Apply the Terraform configuration

# Check if Terraform applied successfully
if [ $? -eq 0 ]; then
    echo "Terraform ran successfully."
else
    echo "Terraform failed."
    exit 1
fi

# Navigate to the Ansible directory and run Ansible playbook
echo "Running Ansible..."
cd /home/ubuntu/Headway/ansible
ansible-playbook -i inventory --private-key=key.pem jenkins.yml

# Check if Ansible ran successfully
if [ $? -eq 0 ]; then
    echo "Ansible ran successfully."
else
    echo "Ansible failed."
    exit 1
fi

echo "Both Terraform and Ansible ran successfully."