module ActionPlanHelper
  APPRENTICESHIPS_URL = 'https://www.findapprenticeship.service.gov.uk/apprenticeships'.freeze

  def build_apprenticeships_url(job_name:, postcode: nil)
    build_uri = URI(APPRENTICESHIPS_URL)
    build_uri.query = URI.encode_www_form(query_values(job_name, postcode))
    build_uri.to_s
  end

  private

  def query_values(job_name, postcode)
    {
      'Keywords' => job_name.downcase,
      'Location' => outcode(postcode),
      'WithinDistance' => 20
    }.reject { |_k, v| v.blank? }
  end

  def outcode(postcode)
    return unless postcode

    UKPostcode.parse(postcode).outcode
  end
end
