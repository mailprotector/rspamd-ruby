# frozen_string_literal: true

require 'rspamd/version'
require 'rspamd/errors'
require 'rspamd/reply'
require 'httparty'

module Rspamd
  include HTTParty
  base_uri ENV.fetch('RSPAMD_URL', 'http://localhost:11334')

  AVAILABLE_HEADERS = {
    deliver_to: 'Deliver-To',
    ip: 'IP',
    helo: 'Helo',
    hostname: 'Hostname',
    flags: 'Flags',
    from: 'From',
    queue_id: 'Queue-Id',
    raw: 'Raw',
    rcpts: 'Rcpt',
    pass: 'Pass',
    subject: 'Subject',
    user: 'User',
    message_length: 'Message-Length',
    settings_id: 'Settings-ID',
    settings: 'Settings',
    user_agent: 'User-Agent'
  }.freeze

  AVAILABLE_FLAGS = %w[
    pass_all
    groups
    zstd
    no_log
    milter
    profile
    body_block
    ext_urls
    skip
    skip_process
  ].freeze

  def self.scan(data, **options)
    Reply.new(push('/checkv2', data, **options))
  end

  def self.fuzzy_add(data, **options)
    push('/fuzzyadd', data, **options)
  end

  def self.fuzzy_del(data, **options)
    push('/fuzzydel', data, **options)
  end

  def self.learn_spam(data, **options)
    push('/learnspam', data, **options)
  end

  def self.learn_ham(data, **options)
    push('/learnham', data, **options)
  end

  def self.errors(**options)
    fetch('/errors', **options)
  end

  def self.stat(**options)
    fetch('/stat', **options)
  end

  def self.stat_reset(**options)
    fetch('/statreset', **options)
  end

  def self.graph(type, **options)
    fetch("/graph?type=#{type}", **options)
  end

  def self.history(**options)
    fetch('/history', **options)
  end

  def self.history_reset(**options)
    fetch('/historyreset', **options)
  end

  def self.actions(**options)
    fetch('/actions', **options)
  end

  def self.symbols(**options)
    fetch('/symbols', **options)
  end

  def self.maps(**options)
    fetch('/maps', **options)
  end

  def self.neighbors(**options)
    fetch('/neighbors', **options)
  end

  def self.get_map(**options)
    fetch('/getmap', **options)
  end

  def self.fuzzy_del_hash(**options)
    fetch('/fuzzydelhash', **options)
  end

  def self.plugins(**options)
    fetch('/plugins', **options)
  end

  def self.ping
    fetch('/ping')
  end

  private_class_method def self.prepare_flags(flags)
    (Rspamd::AVAILABLE_FLAGS & flags.split(',')).join(',')
  end

  private_class_method def self.prepare_headers(options)
    headers = []

    headers << { 'User-Agent' => ENV.fetch('RSPAMD_USER_AGENT', 'rspamd-ruby') }

    options.each do |key, value|
      next unless AVAILABLE_HEADERS.key?(key)

      case key
      when :flags
        headers << { "#{AVAILABLE_HEADERS[key]}": prepare_flags(value) }
      when :raw
        headers << { "#{AVAILABLE_HEADERS[key]}": (value == true ? 'yes' : 'no') }
      when :recipients
        recipients.each do |recipient|
          headers << { "#{AVAILABLE_HEADERS[key]}": recipient }
        end
      else
        headers << { "#{AVAILABLE_HEADERS[key]}": value }
      end
    end
    headers
  end

  private_class_method def self.fetch(route, **options)
    headers = prepare_headers options
    response = get(route, headers: headers, format: :json)

    raise InvalidResponseError, "Invalid Rspamd API Response - URI:/#{url} - #{response['error']}" unless response.success?

    begin
      JSON.parse(response.body) if response.body.is_a? String
    rescue JSON::ParserError
      response.body
    end
  end

  private_class_method def self.push(route, body = nil, **options)
    headers = prepare_headers options
    response = post(route, headers: headers, body: body, format: :json)

    raise InvalidResponseError, "Invalid Rspamd API Response - URI:/#{url} - #{response['error']}" unless response.success?

    begin
      JSON.parse(response.body) if response.body.is_a? String
    rescue JSON::ParserError
      response.body
    end
  end
end
