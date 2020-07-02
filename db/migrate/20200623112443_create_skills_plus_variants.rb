class CreateSkillsPlusVariants < ActiveRecord::Migration[6.0]
  def change
    create_view :skills_plus_variants
  end
end
