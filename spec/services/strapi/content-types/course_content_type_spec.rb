require 'rails_helper'

RSpec.describe Content::StrapiService do
  subject(:service) { described_class.new(authorization: 'Bearer test123') }

  let(:request_headers) {
    {
      'Content-Type' => 'application/json; charset=UTF-8',
      # 'Authorization' => 'Bearer test123'
    }
  }

  let(:response_body) {
    {
      :id => 1,
      :title => "courses near me",
      :apply => "Apply for a course by calling the course provider or visiting their website.",
      :no_results => "0 courses found\n\nGet help to retrain isn't offering courses in your local area yet.\n\nFind training in your local area using the [Find a course service](https://nationalcareers.service.gov.uk/find-a-course) from the National Careers Service\n\n## Try again using a different postcode\n\nYou could try\n- double checking your postcode\n- using a different postcode\n ",
      :created_at => "2020-02-20T15:09:11.055Z",
      :updated_at => "2020-02-20T15:09:11.055Z"
    }.to_json
  }

  let(:status) { 200 }

  describe 'courses' do
    before do
      stub_request(:get, Content::StrapiService::API_ENDPOINT + 'courses/1')
        .with(headers: request_headers)
        .to_return(body: response_body, status: status)
    end

    context 'when we ask for course search results content' do
      it 'Content in JSON format is returned and value for title is as expected' do
        course_content_type = Content::ContentTypes::CourseContentType.new(service)
        expect(course_content_type.content['title']).to eq('courses near me')
      end
    end

    context 'when we ask for the no courses content from course search results' do
      it 'returns correctly marked up content HTML' do
        course_content_type = Content::ContentTypes::CourseContentType.new(service)
        expect(course_content_type.content['no_results']).to eq('courses near me')
      end
    end
  end
end
