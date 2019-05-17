FROM circleci/node:10

LABEL description="Newer image for building node.js / front projects on CircleCI"
LABEL maintainer="Jonathan Cardoso <jonathan@hellomd.com>"

ENV PATH /home/circleci/.yarn/bin:$PATH
RUN yarn config set prefix $HOME/.yarn
RUN yarn global add @sentry/cli
