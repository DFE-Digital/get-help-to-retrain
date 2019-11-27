class AddFeedbackSurveyTable < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_surveys do |t|
      t.boolean :page_useful, null: false
      t.text :message

      t.timestamps
    end
  end
end
