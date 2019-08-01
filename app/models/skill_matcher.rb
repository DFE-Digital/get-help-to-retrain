require 'benchmark'

class SkillMatcher
  class << self
    def recommend_jobs_from(skill_ids)
      job_profile_ids = JobProfileSkill.where(skill_id: skill_ids).pluck(:job_profile_id)

      JobProfile.where(id: job_profile_ids).pluck(:name, :description, :salary_min, :salary_max, :alternative_titles)
    end

    # Group by skill_id to find out the occurence of wach skill in job profiles and also sort DESC by number of job profiles
    def group_by_skill_ids
      JobProfileSkill.group(:skill_id)
                     .count.sort_by{|_k, v| -v}
                     .map{|arr| hash ||= {}; hash[arr[0]] = arr[1]; hash;}
    end

    # Helper method to pluck directly the skill ids from the collection returned by group_by_skill_ids
    def pluck_skill_ids_by_frequency(size)
      SkillMatcher.group_by_skill_ids.map{ |a| a.keys }.flatten.first(size)
    end

    def main
      Benchmark.bm do |x|
        puts 'Active record skill id match - first 20 most freq skills...'
        x.report { recommend_jobs_from(pluck_skill_ids_by_frequency(20)) }

        puts 'Active record skill id match - first 100 most freq skills...'
        x.report { recommend_jobs_from(pluck_skill_ids_by_frequency(20)) }

        puts 'Active record skill id match - all skills...'
        x.report { recommend_jobs_from(pluck_skill_ids_by_frequency(Skill.count)) }
      end
    end
  end
end
