#! /bin/bash
AWS_ID=$1
BUCKET=$2
REGION=$3
TAG=$4 
REPOSITORY=$AWS_ID.dkr.ecr.$REGION.amazonaws.com
FULL_IMAGE_NAME=$REPOSITORY/$CIRCLE_PROJECT_REPONAME
if [ "$TAG" == "latest" ]; then
    ENV_NAME=$CIRCLE_PROJECT_REPONAME-env-staging
else 
    ENV_NAME=$CIRCLE_PROJECT_REPONAME-env-production
fi

aws configure set region $REGION 

eval `aws ecr get-login --no-include-email `            
docker build -t $CIRCLE_PROJECT_REPONAME:$TAG . 
docker tag $CIRCLE_PROJECT_REPONAME:$TAG $FULL_IMAGE_NAME:$TAG 
aws ecr create-repository --repository-name $CIRCLE_PROJECT_REPONAME
docker push $FULL_IMAGE_NAME:$TAG 

sed -i Dockerrun.aws.json -e "s/<TAG>/$TAG/" -e "s/<IMAGE_NAME>/$REPOSITORY\/$CIRCLE_PROJECT_REPONAME/" 
FILENAME=$TAG-Dockerrun.aws.json
cp Dockerrun.aws.json $FILENAME
S3_PATH="s3://$BUCKET/$CIRCLE_PROJECT_REPONAME/$FILENAME"
aws s3 cp $FILENAME $S3_PATH


# Run aws command to create a new EB application with label
aws elasticbeanstalk create-application-version --application-name $CIRCLE_PROJECT_REPONAME  --version-label $TAG --source-bundle S3Bucket=hellomd-eb-deploy,S3Key=$CIRCLE_PROJECT_REPONAME/$FILENAME
aws elasticbeanstalk update-environment --application-name $CIRCLE_PROJECT_REPONAME --environment-name $ENV_NAME --version-label $TAG