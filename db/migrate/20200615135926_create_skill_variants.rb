class CreateSkillVariants < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_variants do |t|
      t.string :variant_name
      t.string :master_name
    end
  end
end
