desc 'Generate Entity-Relationship diagrams for primary and restricted models'
task erd: :environment do
  # Explicitly list models to include on each diagram
  primary_models = [JobProfile, Category, Skill, JobProfileCategory, JobProfileSkill, Course]
  restricted_models = [User, Session, Passwordless::Session]

  primary_options = {
    title: 'Get help to retrain primary data model',
    filename: 'primary_erd',
    only: primary_models.map(&:name)
  }

  restricted_options = {
    title: 'Get help to retrain restricted data model',
    filename: 'restricted_erd',
    only: restricted_models.map(&:name)
  }

  puts 'Generating Entity-Relationship Diagrams...'

  require 'rails_erd/diagram/graphviz'
  RailsERD::Diagram::Graphviz.create(primary_options)
  RailsERD::Diagram::Graphviz.create(restricted_options)

  puts 'Done! Saved diagrams.'
end
