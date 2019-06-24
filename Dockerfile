FROM ruby:2.6-alpine as assets

ENV RAILS_ENV production
ENV NODE_ENV production
ENV BUILD_PACKAGES build-base nodejs yarn tzdata postgresql-dev

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk add --update $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

# Generate Assets
WORKDIR /app
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install --clean --without "development"
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
RUN bundle exec rails webpacker:compile SECRET_KEY_BASE=stubbed

FROM ruby:2.6-alpine

ENV RAILS_ENV production
ENV RACK_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV NODE_ENV production
ENV BUILD_PACKAGES nodejs yarn tzdata libpq

RUN apk add --update $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN apk add openssh \
     && echo "root:Docker!" | chpasswd 
COPY sshd_config /etc/ssh/


WORKDIR /app
COPY . ./
COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /app/public/packs /app/public/packs
COPY --from=assets /app/public/assets /app/public/assets
CMD bundle exec rails server -b 0.0.0.0


