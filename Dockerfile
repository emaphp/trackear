FROM ruby:2.6.6

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

WORKDIR /tmp

COPY Gemfile* ./
COPY package*.json ./

RUN gem install bundler
RUN bundle install

RUN yarn

RUN mkdir -p /var/www/app

COPY . /var/www/app
WORKDIR /var/www/app
