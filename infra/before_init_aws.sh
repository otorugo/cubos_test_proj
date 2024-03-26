PROFILE="teste_tecnico"
KEY_NAME="my-key"
BUCKET="cubos-test"

# set keys of aws
aws configure --profile $PROFILE

aws ec2 create-key-pair --region us-east-1 --profile $PROFILE --key-name $KEY_NAME --query 'KeyMaterial' --output text | tee key.pem
sudo chmod 400 key.pem

aws s3api create-bucket --profile $PROFILE --bucket $BUCKET --region us-east-1
aws s3api --region us-east-1 --profile $PROFILE put-object --bucket $BUCKET --key .env_backend --body .env_backend
aws s3api --region us-east-1 --profile $PROFILE put-object --bucket $BUCKET --key .env_compose --body .env_compose

