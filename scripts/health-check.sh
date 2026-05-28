#!/bin/bash

ALB_DNS=$1
MAX_RETRIES=10
RETRY_INTERVAL=10

if [ -z "$ALB_DNS" ]; then
  echo "Usage: ./health-check.sh <alb-dns-name>"
  exit 1
fi

echo "Running health check on $ALB_DNS..."

for i in $(seq 1 $MAX_RETRIES); do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://$ALB_DNS/health)
  if [ "$HTTP_CODE" = "200" ]; then
    echo "Health check passed! Status: $HTTP_CODE"
    exit 0
  fi
  echo "Attempt $i/$MAX_RETRIES failed with status $HTTP_CODE. Retrying in ${RETRY_INTERVAL}s..."
  sleep $RETRY_INTERVAL
done

echo "Health check failed after $MAX_RETRIES attempts!"
exit 1