# frozen_string_literal: true

# Deliver-To	         Defines actual delivery recipient of message. Can be used for personalized statistics and for user specific options.
# IP	                 Defines IP from which this message is received.
# Helo	               Defines SMTP helo
# Hostname	           Defines resolved hostname

# Flags	Supported from version 2.0: Defines output flags as a commas separated list:
# pass_all:           pass all filters
# groups:             return symbols groups
# zstd:               compressed input/output
# no_log:             do not log task
# milter:             apply milter protocol related hacks
# profile:            profile performance for this task
# body_block:         accept rewritten body as a separate part of reply
# ext_urls:           extended urls information
# skip:               skip all filters processing
# skip_process:       skip mime parsing/processing

# From	              Defines SMTP mail from command data
# Queue-Id	          Defines SMTP queue id for message (can be used instead of message id in logging).
# Raw	                If set to yes, then Rspamd assumes that the content is not MIME and treat it as raw data.
# Rcpt	              Defines SMTP recipient (there may be several Rcpt headers)
# Pass	              If this header has all value, all filters would be checked for this message.
# Subject	            Defines subject of message (is used for non-mime messages).
# User	              Defines username for authenticated SMTP client.
# Message-Length	    Defines the length of message excluding the control block.
# Settings-ID	        Defines settings id to apply.
# Settings	          Defines list of rules (settings apply part) as raw json block to apply.
# User-Agent	        Defines user agent (special processing if it is rspamc).
# MTA-Tag	            MTA defined tag (can be used in settings).
# MTA-Name	          Defines MTA name, used in Authentication-Results routines.
# TLS-Cipher	        Defines TLS cipher name.
# TLS-Version	        Defines TLS version.
# TLS-Cert-Issuer	    Defines Cert issuer, can be used in conjunction with client_ca_name in proxy worker.
# URL-Format	        Supported from version 1.9: return all URLs and email if this header is extended.
# Filename

require_relative "version"
require "httparty"

module Rspamd
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    BASE_URL = ENV.fetch("RSPAMD_URL", "http://localhost:11334").to_s

    AVAILABLE_HEADERS = [
      'Deliver-To',
      'IP',
      'Helo',
      'Hostname',
      'Flags',
      'From',
      'Queue-Id',
      'Raw',
      'Rcpt',
      'Pass',
      'Subject',
      'User',
      'Message-Length',
      'Settings-ID',
      'Settings',
      'User-Agent',
      'MTA-Tag',
      'MTA-Name',
      'TLS-Cipher',
      'TLS-Version',
      'TLS-Cert-Issuer',
      'URL-Format',
      'Filename',
    ]

    AVAILABLE_FLAGS = [
      'pass_all',
      'groups',
      'zstd',
      'no_log',
      'milter',
      'profile',
      'body_block',
      'ext_urls',
      'skip',
      'skip_process'
    ]

    def check_flags flags
      flags_array = flags.split(',')
      flags_count = flags_array.count
      flags.split(',').each do |f|
        unless AVAILABLE_FLAGS.include? f
          flags_array.delete f
          puts "Rpamd error - #{f} is not a valid flag"
        end
      end
      if flags_count != flags_array.count
        puts 'Flags that were accepted:'
        puts flags_array if flags_array.count > 0
        puts 'none' if flags_array.count == 0
        puts 'All available flags are:'
        puts AVAILABLE_FLAGS
      end
      flags_array.join(',')
    end

    def check_headers headers
      og_length = headers.size
      headers.each do |k,v|
        if k.to_s == 'Flags'
          headers[:Flags] = check_flags headers[:Flags]
          headers.delete(:Flags) if headers[:Flags] == ''
        end

        unless AVAILABLE_HEADERS.include? k.to_s
          headers.delete(k)
          puts "Rpamd error - #{k.to_s} is not a valid header"
        end
      end
      if og_length != headers.size
        puts 'Headers that were accepted:'
        puts headers
        puts 'All available headers are:'
        puts AVAILABLE_HEADERS
      end
      headers
    end

    def fetch(route, **options)
      url = "#{BASE_URL}/#{route}"
      url += "?#{options[:params]}" unless options[:params].nil?
      options.delete :params
      check_headers options
      response = HTTParty.get(url, headers: options, format: :json)

      raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

      begin
        body = JSON.parse(response.body) if response.body.is_a? String
        ResponseTypes.convert(body)
      rescue JSON::ParserError
        response.body
      end
    end

    def push(route, body = nil, **options)
      url = "#{BASE_URL}/#{route}"
      url += "?#{options[:params]}" unless options[:params].nil?
      options.delete :params
      check_headers options
      response = HTTParty.post(url, headers: options, body: body, format: :json)

      raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

      begin
        body = JSON.parse(response.body) if response.body.is_a? String
        ResponseTypes.convert(body)
      rescue JSON::ParserError
        response.body
      end
    end
  end

  class HttpWrapper
    include Rspamd
  end

  def self.checkv2(data, **options)
    HttpWrapper.push("checkv2", data, **options)
  end

  def self.fuzzy_add(data, **options)
    HttpWrapper.push("fuzzyadd", data, **options)
  end

  def self.fuzzy_del(data, **options)
    HttpWrapper.push("fuzzydel", data, **options)
  end

  def self.learn_spam(data, **options)
    HttpWrapper.push("learnspam", data, **options)
  end

  def self.learn_ham(data, **options)
    HttpWrapper.push("learnham", data, **options)
  end

  def self.errors(**options)
    HttpWrapper.fetch("errors", **options)
  end

  def self.stat(**options)
    HttpWrapper.fetch("stat", **options)
  end

  def self.stat_reset(**options)
    HttpWrapper.fetch("statreset", **options)
  end

  def self.graph(type, **options)
    HttpWrapper.fetch("graph?type=#{type}", **options)
  end

  def self.history(**options)
    HttpWrapper.fetch("history", **options)
  end

  def self.history_reset(**options)
    HttpWrapper.fetch("historyreset", **options)
  end

  def self.actions(**options)
    HttpWrapper.fetch("actions", **options)
  end

  def self.symbols(**options)
    HttpWrapper.fetch("symbols", **options)
  end

  def self.maps(**options)
    HttpWrapper.fetch("maps", **options)
  end

  def self.neighbors(**options)
    HttpWrapper.fetch("neighbors", **options)
  end

  def self.get_map(**options)
    HttpWrapper.fetch("getmap", **options)
  end

  def self.fuzzy_del_hash(**options)
    HttpWrapper.fetch("fuzzydelhash", **options)
  end

  def self.plugins(**options)
    HttpWrapper.fetch("plugins", **options)
  end

  def self.ping
    HttpWrapper.fetch("ping")
  end
end
