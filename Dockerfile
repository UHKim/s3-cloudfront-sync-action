FROM python:3.8-alpine

LABEL "com.github.actions.name"="S3 Cloudfront Sync"
LABEL "com.github.actions.description"="Sync a directory to S3 & invalidate cloudfront"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="orange"

LABEL version="0.1.0"
LABEL repository="https://github.com/uhkim/s3-cloudfront-sync-action"
LABEL homepage="https://unnakim.info/"
LABEL maintainer="Unna Kim <work@unnakim.info>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.17.9'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]