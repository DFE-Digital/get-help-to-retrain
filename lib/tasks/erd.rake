desc 'Generate Entity-Relationship diagrams for primary and restricted models'
task erd: :environment do
  Zeitwerk::Loader.eager_load_all
  primary_models = PrimaryActiveRecordBase.descendants
  restricted_models = RestrictedActiveRecordBase.descendants + [Passwordless::Session]

  primary_options = {
    title: 'No train, no gain primary data model',
    filename: 'primary_erd',
    only: primary_models.map(&:name)
  }

  restricted_options = {
    title: 'No train, no gain restricted data model',
    filename: 'restricted_erd',
    only: restricted_models.map(&:name)
  }

  puts 'Generating Entity-Relationship Diagrams...'

  RailsERD::Diagram::Graphviz.create(primary_options)
  RailsERD::Diagram::Graphviz.create(restricted_options)

  puts 'Done! Saved diagrams.'
end
