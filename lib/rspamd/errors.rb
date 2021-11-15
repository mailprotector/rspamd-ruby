# frozen_string_literal: true

module Rspamd
  class RspamdError < RuntimeError; end

  class InvalidFlagError < RspamdError; end

  class InvalidResponseError < RspamdError; end

  class InvalidOptionError < RspamdError; end
end
