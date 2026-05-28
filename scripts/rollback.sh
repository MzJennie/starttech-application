#!/bin/bash
set -e

ASG_NAME=${1:-"starttech-asg"}
AWS_REGION=${2:-"us-east-1"}
ECR_REPO=${3:-"starttech-backend"}

echo "Rolling back deployment..."

REFRESH_ID=$(aws autoscaling describe-instance-refreshes \
  --auto-scaling-group-name $ASG_NAME \
  --region $AWS_REGION \
  --query 'InstanceRefreshes[0].InstanceRefreshId' \
  --output text)

if [ "$REFRESH_ID" != "None" ]; then
  echo "Cancelling current refresh: $REFRESH_ID"
  aws autoscaling cancel-instance-refresh \
    --auto-scaling-group-name $ASG_NAME \
    --region $AWS_REGION
fi

echo "Rollback initiated. Previous instances will be restored."
echo "Monitor ASG status in AWS Console."