# Description
- This repository using for provisioning AWS Resources by using Terraform and Ansible
- URL For Demo App : <http://52.77.244.194:3000>
# Architecture Diagram
![Infrastructure](https://personalbucketan.s3-ap-southeast-1.amazonaws.com/TVV_Architecture.png)

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
1. cd to ansible directory 
2. for running the playbook, run the command below
```sh
bash workspace_ansible_playbook production tvv initial_app.yml
```
-----
# Bonus
- I use gitlab CI/CD for building docker image and deployment.
- I will send you for gitlab user which is have the permission to trigger the pipelines.
- Main Repositry still on GitHub <https://github.com/thamrongvorakul/demo-nodejs-mongodb-rest>, I just use gitlab mirroring to synchronize.
- CI/CD is a GITLAB's feature.

### Good to know
1. Gitlab will take some time to synchronize from github.

### How to use "BUILD" job and how does it works?
1. Go to the project and click on CI/CD > pipelines ( image below )
![Menu](https://personalbucketan.s3-ap-southeast-1.amazonaws.com/pipeline_menu.png)
2. Should the pipeline from your changes ( image below ) by click on the pipeline ID ( the 2nd column )
![Menu](https://personalbucketan.s3-ap-southeast-1.amazonaws.com/pipeline.png)
3. ** Job BUILD will get triggered automatically and push the docker image to gitlab repository (image below)
![Menu](https://personalbucketan.s3-ap-southeast-1.amazonaws.com/stage.png)
![Menu](https://personalbucketan.s3-ap-southeast-1.amazonaws.com/registry.png)

### How to use "DEPLOY" job and how dose it works?
1. Deploy job will not get trigger automatically it is not a good pracice to deploy everytime when code has changed. So you have to run it manaully by clicking on that play button.
2. Job will run the terraform to force the docker on EC2 for recreating the container.
3. You can try yourself by just change some label text for the source code, push to github and then back to gitlab pipeline and run.
4. Access to <http://52.77.244.194:3000> again and you gonna see your changes.
