[![Build Status](https://dfe-ssp.visualstudio.com/S108-Get-Help-To-Retrain/_apis/build/status/DFE-Digital.get-help-to-retrain?branchName=master)](https://dfe-ssp.visualstudio.com/S108-Get-Help-To-Retrain/_build/latest?definitionId=182&branchName=master)
# Get Help to Retrain

## Prerequisites

- Ruby 2.6.1
- PostgreSQL
- NodeJS 8.11.x
- Yarn 1.12.x

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas, and seed with test data
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Whats included in this boilerplate?

- Rails 5.2 with Webpacker
- [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
- [GOV.UK Lint](https://github.com/alphagov/govuk-lint)
- RSpec
- Dotenv (managing environment variables)

## Running specs, linter(without auto correct) and annotate models and serializers
```
bundle exec rake
```

## Running specs
```
bundle exec rspec
```

## Running Cucumber/Capybara test
```
cucumber -p a-profile-name-from-cucumber-yml-file
```
Example: To run only tests with @bdd tag
```
cucumber -p bdd
```

## Linting

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec govuk-lint-ruby app config db lib spec Gemfile --format clang -a

or

bundle exec govuk-lint-sass app/webpacker/styles
```

## Security vulnerabilites scanner

Brakeman is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.

To get the report simply run:

```bash
  brakeman
```

or

```bash
  brakeman -o report.html
```
(if you want a report in a nicer format).

Please check https://brakemanscanner.org/docs/ for more details.


## Importing data

Job profiles, categories and skills are imported by screen scraping the National Careers Service "Explore My Careers" site (with consent).

The rake tasks assume no existing data is present. To clear any existing data (USE WITH CAUTION!) run:

```bash
  bundle exec rails db:drop db:create db:schema_load
```

To import the data into an empty database run:

```bash
  bundle exec rails data_import:import_sitemap
  bundle exec rails data_import:scrape_categories
  bundle exec rails data_import:scrape_job_profiles
```

Alternatively for development mode only, it's possible to create random data created using Faker and factories by running:

```bash
  bundle exec rails db:seed
```
