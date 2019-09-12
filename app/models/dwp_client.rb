class DwpClient
  def search(payload)
    response = connection.get('search?'.concat(payload.merge(api_key: api_key, api_id: api_id).to_query)).body

    JSON.parse(response)
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
      faraday.response :logger, ::Logger.new(STDOUT), bodies: true
      faraday.adapter Faraday.default_adapter
    end
  end
end
