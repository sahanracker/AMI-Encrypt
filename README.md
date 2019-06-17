# AMI-Encrypt

## AMI-Encrypt setting up root encrypted AMI 

##How to use

NOTE: You need to export the AWS environment you need to create the AMI before running this shell script.
```
faws env
```

Run the script with following arguments in the terminal (Linux,Mac)
```
git clone git@github.com:sahanracker/AMI-Encrypt.git
cd AMI-Encrypt
sh aws-ami-encryptor.sh <REGION> <MARKETPLACE_AMI_ID> <CUSTOM_AMI_NAME>
```

#Please find below example
```
sh aws-ami-encryptor.sh eu-west-2 ami-0f8e3bd4713dc814e Rax-Amzn-2018-06-17
Creating instance from marketplace AMI ami-0f8e3bd4713dc814e
Waiting for instance i-0322a3c6a4cb252dd to be running and status OK...
Creating account AMI copy
Waiting for AMI COPY ami-0d16062874f9ee0ed to be available...
Terminating unencrypted instance...
Creating Encrypted AMI
Waiting for Encrypted AMI ami-0d09d38aa3d904240 to be available...
Deleting unneeded AMI Copy
Your new AMI is baked with the name 'Rax-Amzn-2018-06-17 Encrypted' is available as --> ami-0d09d38aa3d904240
```
