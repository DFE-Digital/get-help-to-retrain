class JobProfileSkill < PrimaryActiveRecordBase
  belongs_to :job_profile
  belongs_to :skill

  def self.update_rarity
    rarity_ranking = select(:skill_id,
                            'count(1) as times_occurring',
                            'rank() over (order by count(1)) as rarity_rank').group(:skill_id)

    rarity_ranking.all.each do |row|
      Skill.update(row.skill_id, rarity: row.rarity_rank)
    end
  end
end
