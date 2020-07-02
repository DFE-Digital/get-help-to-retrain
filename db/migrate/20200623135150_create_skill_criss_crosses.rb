class CreateSkillCrissCrosses < ActiveRecord::Migration[6.0]
  def change
    create_view :skill_criss_crosses
  end
end
