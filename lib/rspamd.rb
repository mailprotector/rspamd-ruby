# frozen_string_literal: true

require_relative "rspamd/version"

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
end
