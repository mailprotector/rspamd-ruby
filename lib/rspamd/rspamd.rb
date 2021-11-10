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
    }

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
    }

    def check_flags flags
      flags_array = flags.split(',')
      accepted_flags = flags_array.select do |f|
        next true unless AVAILABLE_FLAGS[f.to_sym].nil?

        puts "Rpamd error - #{f} is not a valid flag"
        next false
      end
      if flags_array.count != accepted_flags.count
        puts 'Flags that were accepted:'
        puts accepted_flags if accepted_flags.count > 0
        puts 'none' if accepted_flags.count == 0
        puts 'All available flags are:'
        puts AVAILABLE_FLAGS.keys
      end
      accepted_flags.join(',')
    end

    def check_headers headers
      og_length = headers.size
      accepted_headers = headers.select do |k,v|
        next true unless AVAILABLE_HEADERS[k].nil?

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
        puts AVAILABLE_HEADERS.keys
      end
      accepted_headers
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
