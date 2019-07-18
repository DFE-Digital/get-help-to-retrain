require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    let(:course) { build(:course, email: 'weirdemail@') }

    describe '#email' do
      context 'when the email is invalid' do
        it 'resource is not valid' do
          expect(course).not_to be_valid
        end
      end
    end
  end
end
