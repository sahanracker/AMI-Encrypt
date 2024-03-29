#!/bin/bash

 ## 
 #
 # 1. Create the instance using Market place AMI given in the parameters of Region,AMI_ID and the AMI Name
 # 2. Create AMI copy from the instance
 # 3. Terminate the instance
 # 4. Create encrypted AMI
 # 5. Degister unencrypted AMI
 # For more info visit https://github.com/sahanracker/AMI-Encrypt
 # Script created by sksa1846(Sahan Perera) CloudEnginer II, Rackspace EMEA

set -e

export AWS_DEFAULT_REGION=$1
MARKETPLACE_AMI=$2
NAME=$3
## Run Instance from Base AMI
echo "Creating instance from marketplace AMI $MARKETPLACE_AMI"
INSTANCE=`aws ec2 run-instances --image-id $MARKETPLACE_AMI --count 1 --instance-type t2.micro --query 'Instances[0].InstanceId'`
INSTANCE=`sed -e 's/^"//' -e 's/"$//' <<<"$INSTANCE"`
echo "Waiting for instance $INSTANCE to be running and status OK..."
aws ec2 wait instance-status-ok --instance-ids $INSTANCE

echo "Creating account AMI copy"
AMI_COPY=`aws ec2 create-image --instance-id $INSTANCE --name "$MARKETPLACE_AMI Copy for $NAME" --query 'ImageId'`
AMI_COPY=`sed -e 's/^"//' -e 's/"$//' <<<"$AMI_COPY"`

echo "Waiting for AMI COPY $AMI_COPY to be available..."
aws ec2 wait image-available --image-ids $AMI_COPY

echo "Terminating unencrypted instance..."
TERMINATION=`aws ec2 terminate-instances --instance-ids $INSTANCE`

echo "Creating Encrypted AMI"
AMI_ENC=`aws ec2 copy-image --source-image-id $AMI_COPY --name "$NAME-Encrypted" --encrypted --source-region $AWS_DEFAULT_REGION --region $AWS_DEFAULT_REGION --query 'ImageId'`
AMI_ENC=`sed -e 's/^"//' -e 's/"$//' <<<"$AMI_ENC"`

echo "Waiting for Encrypted AMI $AMI_ENC to be available..."
aws ec2 wait image-available --image-ids $AMI_ENC

echo "Delete unencrypted AMI Copy"
REMOVED=`aws ec2 deregister-image --image-id $AMI_COPY`

aws ec2 wait instance-terminated --instance-ids $INSTANCE
echo "Your new AMI is baked with the name '$NAME-Encrypted' is available as --> $AMI_ENC"
