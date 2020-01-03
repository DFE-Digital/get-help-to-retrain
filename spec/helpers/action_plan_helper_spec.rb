require 'rails_helper'

RSpec.describe ActionPlanHelper do
  describe '.build_apprenticeships_url' do
    it 'returns target job and outcode in apprenticeship url' do
      expect(helper.build_apprenticeships_url(job_name: 'App developer', postcode: 'NW118QE')).to eq(
        'https://www.findapprenticeship.service.gov.uk/apprenticeships?Keywords=app+developer&Location=NW11&WithinDistance=20'
      )
    end

    it 'returns target job only if no postcode present in apprenticeship url' do
      expect(helper.build_apprenticeships_url(job_name: 'App developer')).to eq(
        'https://www.findapprenticeship.service.gov.uk/apprenticeships?Keywords=app+developer&WithinDistance=20'
      )
    end

    it 'returns target job only if postcode not valid in apprenticeship url' do
      expect(helper.build_apprenticeships_url(job_name: 'App developer', postcode: 'L10AsdfsdF')).to eq(
        'https://www.findapprenticeship.service.gov.uk/apprenticeships?Keywords=app+developer&WithinDistance=20'
      )
    end
  end
end
