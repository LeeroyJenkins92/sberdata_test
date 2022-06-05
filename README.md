##  SBERDATA TEST CASE ##
# This is infrastructure part:

clone this project:

$: sudo git clone  https://github.com/LeeroyJenkins92/sberdata_test.git

# prepare terraform:

TIPS: Dont forget to replace VARS to your data in provider block (main.tf)

TIPS: Also you should replace path to your meta.txt in main.tf. 

Generate ssh-key (private and public part). Enter your public key thumbprint to your meta.txt file.

TIPS: Your ssh key should be RSA with length 4096 and format PEM. Jenkins package installation dont work with keys weakest than that.

For example: ssh-keygen -t rsa -b 4096 -m PEM

$: cd ./sberdata_test/Terraform

$: sudo terraform apply

After success creation of infrastructure, you will see public IP address of VM1 in your shell stdout. Copy that and replace in your ansible hosts file.

# deploy jenkins:

TIPS: Ensure that you have installed python and ansible

$: cd ../

$: sudo ansible-playbook -b ./jenkins.yml -vvv

Finally after success of ansible job, follow the web link http://*your-vm1-public-ip*:8080 and finish the installation process.
