require 'rails_helper'

RSpec.describe FindACourseService do
  let(:service) {
    described_class.new(
      api_key: 'test',
      api_base_url: 'https://valid-url.com'
    )
  }

  describe '#search' do
    xit 'Must do something'
  end

  describe '#details' do
    xit 'Must do something'
  end
end
