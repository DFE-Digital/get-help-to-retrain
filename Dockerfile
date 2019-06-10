FROM ruby:2.6-alpine as assets

ENV RAILS_ENV production
ENV BUILD_PACKAGES build-base nodejs yarn tzdata postgresql-dev

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk add --update $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

# Generate Assets
WORKDIR /app
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install --clean --without "test development"
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
RUN bundle exec rails webpacker:compile SECRET_KEY_BASE=stubbed

# Install dependencies
FROM ruby:2.6-alpine as bundler
WORKDIR /app
COPY Gemfile Gemfile.lock .ruby-version ./
COPY --from=assets /usr/local/bundle /usr/local/bundle
RUN bundle install --clean --without "test development"

FROM ruby:2.6-alpine

ENV RAILS_ENV production
ENV RACK_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV NODE_ENV production
ENV BUILD_PACKAGES nodejs yarn tzdata libpq

RUN apk add --update $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY . ./
COPY --from=assets /app/public/packs /app/public/packs
COPY --from=bundler /usr/local/bundle /usr/local/bundle
CMD bundle exec puma -C config/puma.rb
