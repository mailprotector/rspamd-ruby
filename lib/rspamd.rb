# frozen_string_literal: true

require "rspamd/version"
require "rspamd/errors"
require "rspamd/reply"
require "httparty"

module Rspamd
  include HTTParty
  base_uri ENV.fetch("RSPAMD_URL", "http://localhost:11334").to_s

  AVAILABLE_HEADERS = {
    'Deliver-To': true,
    'IP': true,
    'Helo': true,
    'Hostname': true,
    'Flags': true,
    'From': true,
    'Queue-Id': true,
    'Raw': true,
    'Rcpt': true,
    'Pass': true,
    'Subject': true,
    'User': true,
    'Message-Length': true,
    'Settings-ID': true,
    'Settings': true,
    'User-Agent': true,
    'MTA-Tag': true,
    'MTA-Name': true,
    'TLS-Cipher': true,
    'TLS-Version': true,
    'TLS-Cert-Issuer': true,
    'URL-Format': true,
    'Filename': true
  }.freeze

  AVAILABLE_FLAGS = {
    'pass_all': true,
    'groups': true,
    'zstd': true,
    'no_log': true,
    'milter': true,
    'profile': true,
    'body_block': true,
    'ext_urls': true,
    'skip': true,
    'skip_process': true
  }.freeze

  def self.scan(data, **options)
    Reply.new(push("checkv2", data, **options))
  end

  def self.fuzzy_add(data, **options)
    push("fuzzyadd", data, **options)
  end

  def self.fuzzy_del(data, **options)
    push("fuzzydel", data, **options)
  end

  def self.learn_spam(data, **options)
    push("learnspam", data, **options)
  end

  def self.learn_ham(data, **options)
    push("learnham", data, **options)
  end

  def self.errors(**options)
    fetch("errors", **options)
  end

  def self.stat(**options)
    fetch("stat", **options)
  end

  def self.stat_reset(**options)
    fetch("statreset", **options)
  end

  def self.graph(type, **options)
    fetch("graph?type=#{type}", **options)
  end

  def self.history(**options)
    fetch("history", **options)
  end

  def self.history_reset(**options)
    fetch("historyreset", **options)
  end

  def self.actions(**options)
    fetch("actions", **options)
  end

  def self.symbols(**options)
    fetch("symbols", **options)
  end

  def self.maps(**options)
    fetch("maps", **options)
  end

  def self.neighbors(**options)
    fetch("neighbors", **options)
  end

  def self.get_map(**options)
    fetch("getmap", **options)
  end

  def self.fuzzy_del_hash(**options)
    fetch("fuzzydelhash", **options)
  end

  def self.plugins(**options)
    fetch("plugins", **options)
  end

  def self.ping
    fetch("ping")
  end

  def self.check_flags(flags)
    flags_array = flags.split(",")
    accepted_flags = flags_array.select do |f|
      next true unless Rspamd::AVAILABLE_FLAGS[f.to_sym].nil?

      next false
    end
    accepted_flags.join(",")
  end

  def self.check_headers(headers)
    accepted_headers = headers.select do |k, _v|
      next true unless Rspamd::AVAILABLE_HEADERS[k].nil?

      next false
    end

    unless accepted_headers[:Flags].nil?
      checked_flags = check_flags accepted_headers[:Flags]
      accepted_headers[:Flags] = checked_flags
      accepted_headers.delete(:Flags) if checked_flags == ""
    end
    accepted_headers
  end

  def self.fetch(route, **options)
    url = "/#{route}"
    url += "?#{options[:params]}" unless options[:params].nil?
    options.delete :params
    headers = check_headers options
    response = get(url, headers: headers, format: :json)

    raise InvalidResponseError, "Invalid Rspamd API Response - URI:/#{url} - #{response["error"]}" unless response.success?

    begin
      JSON.parse(response.body) if response.body.is_a? String
    rescue JSON::ParserError
      response.body
    end
  end

  def self.push(route, body = nil, **options)
    url = "/#{route}"
    url += "?#{options[:params]}" unless options[:params].nil?
    options.delete :params
    headers = check_headers options
    response = post(url, headers: headers, body: body, format: :json)

    raise InvalidResponseError, "Invalid Rspamd API Response - URI:/#{url} - #{response["error"]}" unless response.success?

    begin
      JSON.parse(response.body) if response.body.is_a? String
    rescue JSON::ParserError
      response.body
    end
  end
end
