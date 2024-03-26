PROFILE="teste_tecnico"
KEY_NAME="my-key"
BUCKET="cubos-test"

# set keys of aws
awslocal configure --profile $PROFILE

awslocal ec2 create-key-pair --region us-east-1 --profile $PROFILE --key-name $KEY_NAME --query 'KeyMaterial' --output text | tee key.pem
sudo chmod 400 key.pem

awslocal s3api create-bucket --profile $PROFILE --bucket $BUCKET --region us-east-1
awslocal s3api --region us-east-1 --profile $PROFILE put-object --bucket $BUCKET --key .env_backend --body .env_backend
awslocal s3api --region us-east-1 --profile $PROFILE put-object --bucket $BUCKET --key .env_compose --body .env_compose

