require 'rails_helper'
require 'support/tasks'

RSpec.describe 'data_import:sample_admin_data' do
  it 'creates random feedback surveys' do
    expect { task.execute }.to change(FeedbackSurvey, :count).by(10)
  end

  it 'creates random user personal data' do
    expect { task.execute }.to change(UserPersonalData, :count).by(10)
  end
end
