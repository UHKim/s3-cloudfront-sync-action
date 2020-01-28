#!/bin/sh

set -e

# set default region to us-east-1
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# checking ENVs to configure aws cli

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not specified."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not specified."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not specified."
  exit 1
fi

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT.
if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

# aws configure is needed.
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${DEST_DIR} \
                --profile s3-sync-action \
                --no-progress \
                ${ENDPOINT_APPEND}"



if [ -n "$AWS_CLOUDFRONT_DIST_ID" ]; then
  #check cloudfront path
  if [ -z "$AWS_CLOUDFRONT_INVALIDATE_PATH" ]; then
    AWS_CLOUDFRONT_INVALIDATE_PATH="/*"
  fi
  sh -c "aws cloudfront create-invalidation \
                --profile s3-sync-action \
                --distribution-id $AWS_CLOUDFRONT_DIST_ID \
                --paths $AWS_CLOUDFRONT_INVALIDATE_PATH"
fi


# remove used credential.
aws configure --profile s3-sync-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF