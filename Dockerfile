FROM ruby:2.4-alpine3.6

LABEL maintainer="Carson Page <wm@zhuartcc.org>"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.6/community/" >> /etc/apk/repositories
RUN apk update && apk add bash coreutils git nodejs postgresql-dev tzdata postgresql postgresql-contrib cmake sqlite-dev yarn build-base gcc abuild binutils
RUN gem install bundler --no-ri --no-rdoc
