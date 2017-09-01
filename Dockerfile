FROM alpine

RUN apk add --no-cache py-pip docker bash git openssh
RUN pip install awscli docker-compose

RUN mkdir /deploy
COPY script.sh /deploy/script.sh
