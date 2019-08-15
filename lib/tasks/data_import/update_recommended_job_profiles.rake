# rubocop:disable Metrics/BlockLength, Metrics/LineLength
namespace :data_import do
  # bin/rails data_import:update_recommended_job_profiles
  desc 'Sets correct recommended value for all job profiles'
  task update_recommended_job_profiles: :environment do
    print 'Updating recommended flag for all job profiles'
    if JobProfile.any?
      non_recommended_jobs = JobProfile.where(slug: %w[
                                                astronaut
                                                naturopath
                                                psychiatrist
                                                vet
                                                art-therapist
                                                sport-and-exercise-psychologist
                                                geoscientist
                                                naval-architect
                                                botanist
                                                dentist
                                                data-analyst-statistician
                                                audiologist
                                                archaeologist
                                                dance-movement-psychotherapist
                                                ornithologist
                                                forensic-psychologist
                                                psychologist
                                                play-therapist
                                                consumer-scientist
                                                astronomer
                                                nutritionist
                                                chiropractor
                                                research-and-development-manager
                                                cognitive-behavioural-therapist
                                                environmental-consultant
                                                medical-herbalist
                                                music-therapist
                                                paediatrician
                                                nutritional-therapist
                                                zoologist
                                                palaeontologist
                                                dental-hygienist
                                                ecologist
                                                surgeon
                                                pharmacologist
                                                dispensing-optician
                                                dramatherapist
                                                materials-engineer
                                                gp
                                                anaesthetist
                                                critical-care-technologist
                                                orthoptist
                                                pathologist
                                                geneticist
                                                oceanographer
                                                sports-scientist
                                                pharmacist
                                                speech-and-language-therapist
                                                climate-scientist
                                                archivist
                                                ergonomist
                                                clinical-psychologist
                                                hospital-doctor
                                                oil-and-gas-operations-manager
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
