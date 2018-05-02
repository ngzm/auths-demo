FROM ruby:latest
MAINTAINER ngzm<nk.ngzm@gmail.com>

# setup apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y apt-transport-https

# install nodejs and yarn which is required by rails
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nodejs
RUN apt-get install -y curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# setup application
ADD ./auths-demo /usr/src/app/
RUN mkdir -p /usr/src/app/tmp/pids
RUN cd /usr/src/app && bundle install --without test development

# define production environments
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES 1
ENV RAILS_RELATIVE_URL_ROOT='/auths'

# setup glink application
RUN cd /usr/src/app && rails assets:precompile

# start glink application
EXPOSE 3000
WORKDIR /usr/src/app
CMD ["puma", "-C", "config/puma.rb"]
