class DwpClient
  def search(payload)
    response = connection.get('search?'.concat(payload.merge(api_key: api_key, api_id: api_id).to_query)).body

    json_response = JSON.parse(response)

    json_response['jobs']&.map do |job|
      puts "title: #{job['title']}, apply: https://findajob.dwp.gov.uk/apply/#{job['id']}, location: #{job['location']}, type: #{job['contract_type']}\n"
    end
  end

  private

  def api_base
    @api_base ||= 'https://findajob.dwp.gov.uk/api/'
  end

  def api_key
    ENV['DWP_API_KEY']
  end

  def api_id
    ENV['DWP_API_ID']
  end

  def connection
    @connection ||= Faraday.new(url: api_base) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end
end
