# frozen_string_literal: true

require "./lib/rspamd"
# require "pry"
RSpec.describe Rspamd do
  it "has a version number" do
    expect(Rspamd::VERSION).not_to be nil
  end

  it "has available headers" do
    expect(Rspamd::AVAILABLE_HEADERS).not_to be nil
  end

  it "has available flags" do
    expect(Rspamd::AVAILABLE_FLAGS).not_to be nil
  end
end
