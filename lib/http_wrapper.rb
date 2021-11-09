# frozen_string_literal: true

require "httparty"

module HttpWrapper
  include HTTParty
  base_uri ENV.fetch("RSPAMD_URL", "http://localhost:11334").to_s

  def self.fetch(url, headers = nil, params = nil)
    url += "?#{params}" unless params.nil?
    response = get("/#{url}", headers: headers, format: :json)

    raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

    begin
      body = JSON.parse(response.body) if response.body.is_a? String
      ResponseTypes.convert(body)
    rescue JSON::ParserError
      response.body
    end
  end

  def self.push(url, headers = nil, body = nil, params = nil)
    url += "?#{params}" unless params.nil?
    response = post("/#{url}", headers: headers, body: body, format: :json)

    raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

    begin
      body = JSON.parse(response.body) if response.body.is_a? String
      ResponseTypes.convert(body)
    rescue JSON::ParserError
      response.body
    end
  end
end
