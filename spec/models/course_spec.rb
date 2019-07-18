require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    describe '#email' do
      let(:course) { build(:course, email: 'weirdemail@') }

      it 'is not valid' do
        expect(course).not_to be_valid
      end
    end
  end
end
