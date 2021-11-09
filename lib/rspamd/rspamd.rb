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

module Rspamd
  def self.checkv2(headers, data)
    HttpWrapper.push("checkv2", headers, data)
  end

  def self.fuzzy_add(headers, data)
    HttpWrapper.push("fuzzyadd", headers, data)
  end

  def self.fuzzy_del(headers, data)
    HttpWrapper.push("fuzzydel", headers, data)
  end

  def self.learn_spam(headers, data)
    HttpWrapper.push("learnspam", headers, data)
  end

  def self.learn_ham(headers, data)
    HttpWrapper.push("learnham", headers, data)
  end

  def self.errors(headers)
    HttpWrapper.fetch("errors", headers)
  end

  def self.stat(headers)
    HttpWrapper.fetch("stat", headers)
  end

  def self.stat_reset(headers)
    HttpWrapper.fetch("statreset", headers)
  end

  def self.graph(headers, type)
    HttpWrapper.fetch("graph?type=#{type}", headers)
  end

  def self.history(headers)
    HttpWrapper.fetch("history", headers)
  end

  def self.history_reset(headers)
    HttpWrapper.fetch("historyreset", headers)
  end

  def self.actions(headers)
    HttpWrapper.fetch("actions", headers)
  end

  def self.symbols(headers)
    HttpWrapper.fetch("symbols", headers)
  end

  def self.maps(headers)
    HttpWrapper.fetch("maps", headers)
  end

  def self.neighbors(headers)
    HttpWrapper.fetch("neighbors", headers)
  end

  def self.get_map(headers)
    HttpWrapper.fetch("getmap", headers)
  end

  def self.fuzzy_del_hash(headers)
    HttpWrapper.fetch("fuzzydelhash", headers)
  end

  def self.plugins(headers)
    HttpWrapper.fetch("plugins", headers)
  end

  def self.ping
    HttpWrapper.fetch("ping")
  end
end
