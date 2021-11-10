# frozen_string_literal: true
require "httparty"

class Rspamd::Client
  include HTTParty

  def initialize rspamd_url = ENV.fetch("RSPAMD_URL", "http://localhost:11334").to_s
    @base_url = rspamd_url
  end

  def checkv2(data, **options)
    push("checkv2", data, **options)
  end

  def fuzzy_add(data, **options)
    push("fuzzyadd", data, **options)
  end

  def fuzzy_del(data, **options)
    push("fuzzydel", data, **options)
  end

  def learn_spam(data, **options)
    push("learnspam", data, **options)
  end

  def learn_ham(data, **options)
    push("learnham", data, **options)
  end

  def errors(**options)
    fetch("errors", **options)
  end

  def stat(**options)
    fetch("stat", **options)
  end

  def stat_reset(**options)
    fetch("statreset", **options)
  end

  def graph(type, **options)
    fetch("graph?type=#{type}", **options)
  end

  def history(**options)
    fetch("history", **options)
  end

  def history_reset(**options)
    fetch("historyreset", **options)
  end

  def actions(**options)
    fetch("actions", **options)
  end

  def symbols(**options)
    fetch("symbols", **options)
  end

  def maps(**options)
    fetch("maps", **options)
  end

  def neighbors(**options)
    fetch("neighbors", **options)
  end

  def get_map(**options)
    fetch("getmap", **options)
  end

  def fuzzy_del_hash(**options)
    fetch("fuzzydelhash", **options)
  end

  def plugins(**options)
    fetch("plugins", **options)
  end

  def ping
    fetch("ping")
  end

  private

  def check_flags flags
    flags_array = flags.split(',')
    accepted_flags = flags_array.select do |f|
      next true unless Rspamd::AVAILABLE_FLAGS[f.to_sym].nil?

      puts "Rpamd error - #{f} is not a valid flag"
      next false
    end
    if flags_array.count != accepted_flags.count
      puts 'Flags that were accepted:'
      puts accepted_flags if accepted_flags.count > 0
      puts 'none' if accepted_flags.count == 0
      puts 'All available flags are:'
      puts Rspamd::AVAILABLE_FLAGS.keys
    end
    accepted_flags.join(',')
  end

  def check_headers headers
    og_length = headers.size
    accepted_headers = headers.select do |k,v|
      next true unless Rspamd::AVAILABLE_HEADERS[k].nil?

      puts "Rpamd error - #{k.to_s} is not a valid header"
      next false
    end

    unless accepted_headers[:Flags].nil?
      checked_flags = check_flags accepted_headers[:Flags]
      accepted_headers[:Flags] = checked_flags
      accepted_headers.delete(:Flags) if checked_flags == ''
    end

    if og_length != accepted_headers.size
      puts 'Headers that were accepted:'
      puts accepted_headers
      puts 'All available headers are:'
      puts Rspamd::AVAILABLE_HEADERS.keys
    end
    accepted_headers
  end

  def fetch(route, **options)
    url = "#{@base_url}/#{route}"
    url += "?#{options[:params]}" unless options[:params].nil?
    options.delete :params
    headers = check_headers options
    response = self.class.get(url, headers: headers, format: :json)

    raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

    begin
      body = JSON.parse(response.body) if response.body.is_a? String
      ResponseTypes.convert(body)
    rescue JSON::ParserError
      response.body
    end
  end

  def push(route, body = nil, **options)
    url = "#{@base_url}/#{route}"
    url += "?#{options[:params]}" unless options[:params].nil?
    options.delete :params
    headers = check_headers options
    response = self.class.post(url, headers: headers, body: body, format: :json)

    raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

    begin
      body = JSON.parse(response.body) if response.body.is_a? String
      ResponseTypes.convert(body)
    rescue JSON::ParserError
      response.body
    end
  end
end
