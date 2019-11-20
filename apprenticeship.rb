require 'net/http'

uri = URI('https://apis.apprenticeships.sfa.bis.gov.uk/reference/frameworks')


request = Net::HTTP::Get.new(uri.request_uri)
# Request headers
request['Ocp-Apim-Subscription-Key'] = ENV['APPRENTICESHIP_KEY']
# Request body
request.body = "{body}"

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body