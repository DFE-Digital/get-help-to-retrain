require 'net/http'

class Apprenticeship
  def fetch_all()
    uri = URI('https://apis.apprenticeships.sfa.bis.gov.uk/vacancies/v1/apprenticeships/search?latitude=51.5074&longitude=0.1278&distanceInMiles=5&pageSize=10&pageNumbr=2&keywords=nurse')

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = ENV['APPRENTICESHIP_KEY']

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    puts JSON.parse(response.body)
  end

  def fetch(id)
    uri = URI("https://apis.apprenticeships.sfa.bis.gov.uk/vacancies/v1/apprenticeships/#{id}")

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = ENV['APPRENTICESHIP_KEY']

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    puts JSON.parse(response.body)
  end
end