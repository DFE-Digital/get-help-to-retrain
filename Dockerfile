FROM ruby:2.6.5-alpine as assets

ENV RAILS_ENV production
ENV NODE_ENV production
ENV BUILD_PACKAGES build-base nodejs yarn tzdata postgresql-dev git

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk add --update $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

# Generate Assets
WORKDIR /app
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle config force_ruby_platform true
RUN bundle config build.sassc --disable-march-tune-native
RUN bundle install --clean --force --without "development test" \
     && rm -rf /usr/local/bundle/cache/*.gem \
     && find /usr/local/bundle/gems/ -name "*.c" -delete \
     && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
RUN bundle exec rails assets:precompile SECRET_KEY_BASE=stubbed

FROM ruby:2.6.5-alpine

ENV RAILS_ENV production
ENV RACK_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV NODE_ENV production
ENV BUILD_PACKAGES nodejs yarn tzdata libpq

ARG GIT_SHA="unknown"
ENV GIT_SHA=${GIT_SHA}

RUN apk add --update $BUILD_PACKAGES && \
    rm -rf /var/cache/apk/*

WORKDIR /app
COPY . ./
COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /app/public/packs /app/public/packs
COPY --from=assets /app/public/assets /app/public/assets
COPY startup.sh ./
RUN ["chmod", "+x", "/app/startup.sh"]
CMD /app/startup.sh
