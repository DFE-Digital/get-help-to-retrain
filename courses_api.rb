require 'net/http'
require 'pry'

def request(body)
  uri = URI('https://pp.api.nationalcareers.service.gov.uk/coursedirectory/findacourse/coursesearch')

  request = Net::HTTP::Post.new(uri.request_uri)
  # Request headers
  request['Content-Type'] = 'application/json-patch+json'
  # Request headers
  request['Ocp-Apim-Subscription-Key'] = '<use your own>'
  # Request body
  request.body = body

  response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
  end

  JSON.parse(response.body)
end

def payload(term, start)
  "{
    \"subjectKeyword\": \"#{term}\",
    \"qualificationLevels\": [
      \"X\", \"E\", \"1\", \"2\"
    ],
    \"start\": #{start}
  }"
end

def payload_with_start_date(term, start, start_date)
  "{
    \"subjectKeyword\": \"#{term}\",
    \"qualificationLevels\": [
      \"X\", \"E\", \"1\", \"2\"
    ],
    \"start\": #{start},
    \"startDateFrom\": \"#{start_date}\"
  }"
end

def filter_by(term, collection)
  collection.select{|c| c['courseName'].downcase.include?(term) || c['qualificationCourseTitle'].downcase.include?(term)}
end

def prompt(term, collection)
  final_data = filter_by(term, collection)
  puts "Courses containing '#{term}' in either courseName or qualificationCourseTitle: #{final_data.size}"
  if final_data.size > 0
    puts "    Examples:"
    final_data.first(3).each do |c|
      puts "   - courseName: #{c['courseName']}, qualificationCourseTitle: #{c['qualificationCourseTitle']}\n"
    end
  end
end

def report(term, in_future: false)
  results = in_future ? request(payload_with_start_date(term, 0, "#{Time.now.strftime('%Y-%m-%d')}T00:00:00Z")) : request(payload(term, 0))

  puts "CRITERIA: #{term.upcase} courses with qualificationLevels: X, E, 1, 2 #{in_future ? "starting from: #{Time.now.strftime('%Y-%m-%d')}T00:00:00Z" : ""}:\n"
  puts "Total from payload: #{results['total']}"

  pages = (results['total'] / 1000.0).ceil

  final_results = []

  for i in 0..pages - 1
    payload = in_future ? payload_with_start_date(term, i*1000, "#{Time.now.strftime('%Y-%m-%d')}T00:00:00Z") : payload(term, i*1000)
    results = request(payload)
    final_results += results['results']
  end

  puts "Total from aggregated pages: #{final_results.size}"

  prompt('aroma',final_results)
  prompt('beauty', final_results)
  prompt('catering', final_results)
  prompt('sport', final_results)
  prompt('barber', final_results)
  prompt('fashion', final_results)
  prompt('a level', final_results.reject{|c| c['courseName'].include?('AQA Level') || c['courseName'].include?('Dementia Level') || c['courseName'].include?('Diploma Level')})
  prompt('social', final_results)
  prompt('esol', final_results)
  prompt('efl', final_results)
  prompt('english for speakers of other languages', final_results)
  prompt('gcse', final_results)
  prompt('resolution', final_results)
  prompt('resolving', final_results)

  puts("\n\n\n")
end

report('math')
report('english')
report('esol')
report('math', in_future: true)
report('english', in_future: true)
report('esol', in_future: true)
report('esol, english for speakers of other languages')
report('\"english for speakers of other languages\"')
