# Description
This repository using for provisioning AWS Resources by using Terraform and Ansible

# Architecture Diagram
![alt text](https://personalbucketan.s3-ap-southeast-1.amazonaws.com/TVV_Architecture.png)

# Source Code description
#### 1. Terraform
- For provisioning all of the resoureces on AWS (personal account).
- SSH to server requires keypair (.pem) and due to this is a sensitive information, I will send you directly in the email who contacted to me.
- After provision main resource is EC2 instance ( App instance and DB instance )
- App and DB open port 22 for source 0.0.0.0/0 but it does not mean everyone who know the ip will be able to connect there, they still need a keypair to ssh.

### How to execute the Terraform
1. cd to terraform/production directory 
2. for planning, run the command below
```sh
terraform plan -var-file=vars/tvv.tfvars
```
3. for applying, run the command below
```sh
bash terraform_apply tvv
```
#### 2. Ansible
- To initial the demo application on App Instance with Docker 
- To initial mongoDB on DB Instance with Docker

### How to execute the Ansible
1. cd to terraform/production directory 
2. for running the playbook, run the command below
```sh
bash workspace_ansible_playbook production tvv initial_app.yml
```

# Bonus
- I also done for the Bonus part (CI/CD for build and deployment) with the assignment, please take a look on README github  <https://github.com/thamrongvorakul/demo-nodejs-mongodb-rest>
