FROM ruby:2.7.2

RUN apt-get update && apt-get install -y \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

RUN gem install bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY package* ./
RUN yarn

COPY . .
