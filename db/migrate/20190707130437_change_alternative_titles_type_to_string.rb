class ChangeAlternativeTitlesTypeToString < ActiveRecord::Migration[5.2]
  def up
    change_column :job_profiles, :alternative_titles, :string, array: false, null: true, default: nil, using: "(array_to_string(ARRAY[alternative_titles], ', '))"
  end

  def down
    change_column :job_profiles, :alternative_titles, :string, array: true, default: [], using: "(string_to_array(alternative_titles, ', ', '{}'))"
  end
end
