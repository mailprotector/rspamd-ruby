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

  class Client
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
      url = "#{@base_url}/#{route}"
      url += "?#{options[:params]}" unless options[:params].nil?
      options.delete :params
      headers = check_headers options
      response = HTTParty.get(url, headers: headers, format: :json)

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
      response = HTTParty.post(url, headers: headers, body: body, format: :json)

      raise StandardError, "Invalid RSpamD API Response - URI:/#{url}" unless response.success?

      begin
        body = JSON.parse(response.body) if response.body.is_a? String
        ResponseTypes.convert(body)
      rescue JSON::ParserError
        response.body
      end
    end
  end
end
