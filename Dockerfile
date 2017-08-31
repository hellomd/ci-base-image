FROM alpine

RUN apk add --no-cache py-pip docker
RUN pip install awscli docker-compose

RUN mkdir /deploy
COPY script.sh /deploy/script.sh
