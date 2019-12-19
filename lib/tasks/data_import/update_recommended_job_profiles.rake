# rubocop:disable Metrics/BlockLength, Metrics/LineLength
namespace :data_import do
  # bin/rails data_import:update_recommended_job_profiles
  desc 'Sets correct recommended value for all job profiles'
  task update_recommended_job_profiles: :environment do
    print 'Updating recommended flag for all job profiles'
    if JobProfile.any?
      non_recommended_jobs = JobProfile.where(slug: %w[
                                                advertising-art-director
                                                advertising-media-buyer
                                                aid-worker
                                                anaesthetist
                                                archaeologist
                                                archivist
                                                art-therapist
                                                astronaut
                                                astronomer
                                                audiologist
                                                barrister
                                                biochemist
                                                botanist
                                                boxer
                                                celebrant
                                                chiropractor
                                                civil-service-manager
                                                climate-scientist
                                                clinical-psychologist
                                                cognitive-behavioural-therapist
                                                consumer-scientist
                                                court-legal-adviser
                                                criminologist
                                                critical-care-technologist
                                                crown-prosecutor
                                                dance-movement-psychotherapist
                                                data-analyst-statistician
                                                dental-hygienist
                                                dentist
                                                dispensing-optician
                                                dramatherapist
                                                ecologist
                                                environmental-consultant
                                                ergonomist
                                                film-critic
                                                forensic-psychologist
                                                geneticist
                                                geoscientist
                                                gp
                                                headteacher
                                                health-play-specialist
                                                health-visitor
                                                hospital-doctor
                                                materials-engineer
                                                medical-herbalist
                                                medical-illustrator
                                                motorsport-engineer
                                                music-therapist
                                                nanotechnologist
                                                naturopath
                                                naval-architect
                                                nutritional-therapist
                                                nutritionist
                                                oceanographer
                                                oil-and-gas-operations-manager
                                                operational-researcher
                                                optometrist
                                                ornithologist
                                                orthoptist
                                                osteopath
                                                paediatrician
                                                palaeontologist
                                                patent-attorney
                                                pathologist
                                                pharmacist
                                                pharmacologist
                                                physician-associate
                                                physicist
                                                play-therapist
                                                psychiatrist
                                                psychologist
                                                research-and-development-manager
                                                research-scientist
                                                royal-navy-officer
                                                school-nurse
                                                seismologist
                                                sonographer
                                                speech-and-language-therapist
                                                sport-and-exercise-psychologist
                                                sports-scientist
                                                surgeon
                                                technical-textiles-designer
                                                test-lead
                                                translator
                                                vet
                                                zoologist
                                                european-union-official
                                              ])

      JobProfile.update_all(recommended: true)
      non_recommended_jobs.update_all(recommended: false)

      print "#{JobProfile.count} job profiles, #{JobProfile.recommended.count} recommended, #{JobProfile.excluded.count} excluded"
    else
      print 'No job profiles setup - please import sitemap first'
    end
  end
end
# rubocop:enable Metrics/BlockLength, Metrics/LineLength
