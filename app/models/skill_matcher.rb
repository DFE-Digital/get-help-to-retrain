require 'benchmark'

class SkillMatcher
  class << self
    def recommend_jobs_from(skill_ids)
      Benchmark.measure do
        job_profile_ids = JobProfileSkill.where(skill_id: skill_ids).pluck(:job_profile_id)

        results = JobProfile.where(id: job_profile_ids).map do |job_profile|
          match_score = match_score_between(skill_ids, job_profile.skills.pluck(:id))

          {
            name: job_profile.name,
            description: job_profile.description,
            salary_min: job_profile.salary_min,
            salary_max: job_profile.salary_max,
            match_score: match_score.round(2)
          }
        end.sort_by {|hash| -hash[:match_score]}

        puts results
      end
    end

    # Group by skill_id to find out the occurence of wach skill in job profiles and also sort DESC by number of job profiles
    def group_by_skill_ids
      JobProfileSkill.group(:skill_id)
                     .count.sort_by{|_k, v| -v}
                     .map{|arr| hash ||= {}; hash[arr[0]] = arr[1]; hash;}
    end

    # Helper method to pluck directly the skill ids from the collection returned by group_by_skill_ids
    def pluck_skill_ids_by_frequency(size)
      SkillMatcher.group_by_skill_ids.map{|a| a.keys }.flatten.first(size)
    end

    # Raw skill match score
    def match_score_between(user_skills, job_skills)
      ((user_skills & job_skills).size.to_f / user_skills.size) * 100.0
    end

    def main
      puts 'Active record skill id match - user feeds in first 5 most freq skills...'
      recommend_jobs_from(pluck_skill_ids_by_frequency(5))

      # puts 'Active record skill id match - user feeds in first 100 most freq skills...'
      # recommend_jobs_from(pluck_skill_ids_by_frequency(100))

      # puts 'Active record skill id match - all skills...'
      # recommend_jobs_from(pluck_skill_ids_by_frequency(Skill.count))
    end
  end
end
