FROM circleci/node:10

ENV PATH /home/circleci/.yarn/bin:$PATH
RUN yarn config set prefix $HOME/.yarn
RUN yarn global add @sentry/cli
