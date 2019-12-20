class AddRarityToSkills < ActiveRecord::Migration[6.0]
  def change
    add_column :skills, :rarity, :integer
    add_index :skills, :rarity
  end
end
