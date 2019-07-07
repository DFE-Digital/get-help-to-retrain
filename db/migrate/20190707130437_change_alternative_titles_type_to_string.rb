class ChangeAlternativeTitlesTypeToString < ActiveRecord::Migration[5.2]
  def change
    change_column :job_profiles, :alternative_titles, :string, array: false, null: true, default: nil, using: "(array_to_string(ARRAY[alternative_titles], ', '))"
  end
end
