#!/bin/bash
set -e

ASG_NAME=${1:-"starttech-asg"}
AWS_REGION=${2:-"us-east-1"}

echo "Starting rolling deployment to ASG: $ASG_NAME"

aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $ASG_NAME \
  --region $AWS_REGION \
  --preferences '{"MinHealthyPercentage": 50, "InstanceWarmup": 60}'

echo "Waiting for deployment to complete..."
while true; do
  STATUS=$(aws autoscaling describe-instance-refreshes \
    --auto-scaling-group-name $ASG_NAME \
    --region $AWS_REGION \
    --query 'InstanceRefreshes[0].Status' \
    --output text)
  echo "Status: $STATUS"
  if [ "$STATUS" = "Successful" ]; then
    echo "Deployment successful!"
    break
  elif [ "$STATUS" = "Failed" ] || [ "$STATUS" = "Cancelled" ]; then
    echo "Deployment failed!"
    exit 1
  fi
  sleep 30
done