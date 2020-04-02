[![Build Status](https://dfe-ssp.visualstudio.com/S108-Get-Help-To-Retrain/_apis/build/status/DFE-Digital.get-help-to-retrain?branchName=master)](https://dfe-ssp.visualstudio.com/S108-Get-Help-To-Retrain/_build/latest?definitionId=182&branchName=master)
# Get Help to Retrain

## Prerequisites

- Ruby 2.6.5
- PostgreSQL
- NodeJS 12.14.x
- Yarn 1.16.x

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas, and seed with test data
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Running specs, linter(without auto correct) and annotate models and serializers
```
bundle exec rake
```

## Running specs
```
bundle exec rspec
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


## Database Setup
The setup consists of two databases, the primary database, which contains modifiable data for job profiles and skills, and the restricted database which contains user relevant data.

Migrations relevant to the primary database reside in the `db/migrate` folder, while the restricted database migrations in `db/restricted_migrate`. See `database.yml` for more details

To run the setup for each database separately append the name of the database to the command, example:

```
db:create:restricted
db:migrate:restricted
```
If general commands are run without appending the name, setup is done for both databases and migrations.

## Importing data

### Scraped content
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

If job profiles have been previously scraped and `content` is populated, it's possible to run the following rake task to refresh the persisted job profile attributes (e.g. name, description, skills, salary_min, salary_max etc.):

```bash
  bundle exec rails data_import:refresh_job_profiles
```

### Recommended job profiles
The service is intended for users without degrees, so should not recommend future job roles that require a degree level qualification. Job profiles include a `recommended` attribute for this purpose, that is respected by the skills matcher when computing matches.

The list of job profiles that require a degree has been manually curated by reviewing each of the current job roles scraped from NCS site. A rake task allows setting the recommended attribute correctly for known job profiles. Any new job profiles that are discovered during subsequent scraping will be excluded by default, but can manually be recommended via the admin interface.

Once job profiles have been scraped from NCS, run the relevant rake task (a one off exercise):

```bash
  bundle exec rails data_import:update_recommended_job_profiles
```

### Skills rarity
The skills are each associated with one or more job profiles and used to generate matching job profiles within the skills matcher. When job profiles have the same number of shared skills and identical growth prospects, then skills rarity (or ranked rareness) is used to further order skills matcher results. The rarity score is precalculated and held against each skill by running the rake task:

```bash
  bundle exec rails data_import:update_skills_rarity
```

### Additional job profile data
Growth information and SOC codes for job profiles are imported via an Excel spreadsheet and used to update specific attributes of existing job profiles matched by name (i.e. these must have been previously imported by running the scraping tasks). Copy the relevant spreadsheet locally and then run rake task:

```bash
  bundle exec rails "data_import:import_job_growth['Job growth 05082019.xlsx']"
```

Hidden alternative titles and Job Profile Specialism for job profiles are used to improve search results and are imported via an Excel spreadsheet. This updates existing job profiles matched by slug so job profiles must have been previously imported by running the scraping tasks. Copy the relevant spreadsheet locally and then run the rake task:

```bash
  bundle exec rails "data_import:import_job_additional_data['JobProfileAdditionalData.xlsx']"
```

Hierarchy and Sector keywords for job profiles are used to improve search results and are imported via an Excel spreadsheet. This updates existing job profiles matched by name and alternative title so job profiles must have been previously imported by running the scraping tasks. Copy the relevant spreadsheet locally and then run the rake task:

```bash
  bundle exec rails "data_import:import_search_job_profiles['job_profile_word_count_with_alternatives_v3.xlsx']"
```

These tasks will produce console output detailing any job profiles that were not found and stats for job profiles that are missing information. The rake tasks can be run multiple times without issue but will throw an error if used in production mode.

## Feedback surveys and user personal data

Test data for both `FeedbackSurvey` and `UserPersonalData` models can be setup by running this rake task:

```bash
  bundle exec rails data_import:sample_admin_data
```

***Note*** this appends further random data each time the rake task is called

## Documentation
### Database schema
A database schema diagram can be generated by running:

```bash
bundle exec rails erd
```

This will output two files named `primary_erd.pdf` and 'restricted_erd.pdf` corresponding to the two databases. These files should not be added to git as they can be generated on demand.

Graphviz also needs to be installed (`brew install graphviz`) for this to work. For more details see: https://github.com/voormedia/rails-erd
