# frozen_string_literal: true

require "./lib/rspamd/rspamd"
require "./lib/rspamd/response_types"
# require "pry"

RSpec.describe Rspamd do
  let(:fetch_double) { double("fetch") }
  let(:push_double) { double("push") }

  before do
    allow(HttpWrapper).to receive(:fetch).and_return(fetch_double)
    allow(HttpWrapper).to receive(:push).and_return(push_double)
  end

  it "has a version number" do
    expect(Rspamd::VERSION).not_to be nil
  end

  describe ".checkv2" do
    it "calls the push method" do
      headers = {}
      body = "body"
      described_class.checkv2(headers, body)
      expect(HttpWrapper).to have_received(:push).with("checkv2", headers, body)
    end
  end

  describe ".fuzzy_add" do
    it "calls the push method" do
      headers = {}
      body = "body"
      described_class.fuzzy_add(headers, body)
      expect(HttpWrapper).to have_received(:push).with("fuzzyadd", headers, body)
    end
  end

  describe ".fuzzy_del" do
    it "calls the push method" do
      headers = {}
      body = "body"
      described_class.fuzzy_del(headers, body)
      expect(HttpWrapper).to have_received(:push).with("fuzzydel", headers, body)
    end
  end

  describe ".learn_spam" do
    it "calls the push method" do
      headers = {}
      body = "body"
      described_class.learn_spam(headers, body)
      expect(HttpWrapper).to have_received(:push).with("learnspam", headers, body)
    end
  end

  describe ".learn_ham" do
    it "calls the push method" do
      headers = {}
      body = "body"
      described_class.learn_ham(headers, body)
      expect(HttpWrapper).to have_received(:push).with("learnham", headers, body)
    end
  end

  describe ".errors" do
    it "calls the fetch method" do
      headers = {}
      described_class.errors(headers)
      expect(HttpWrapper).to have_received(:fetch).with("errors", headers)
    end
  end

  describe ".stat" do
    it "calls the fetch method" do
      headers = {}
      described_class.stat(headers)
      expect(HttpWrapper).to have_received(:fetch).with("stat", headers)
    end
  end

  describe ".stat_reset" do
    it "calls the fetch method" do
      headers = {}
      described_class.stat_reset(headers)
      expect(HttpWrapper).to have_received(:fetch).with("statreset", headers)
    end
  end

  describe ".graph" do
    it "calls the fetch method" do
      headers = {}
      type = "type"
      described_class.graph(headers, type)
      expect(HttpWrapper).to have_received(:fetch).with("graph?type=type", headers)
    end
  end

  describe ".history" do
    it "calls the fetch method" do
      headers = {}
      described_class.history(headers)
      expect(HttpWrapper).to have_received(:fetch).with("history", headers)
    end
  end

  describe ".history_reset" do
    it "calls the fetch method" do
      headers = {}
      described_class.history_reset(headers)
      expect(HttpWrapper).to have_received(:fetch).with("historyreset", headers)
    end
  end

  describe ".actions" do
    it "calls the fetch method" do
      headers = {}
      described_class.actions(headers)
      expect(HttpWrapper).to have_received(:fetch).with("actions", headers)
    end
  end

  describe ".symbols" do
    it "calls the fetch method" do
      headers = {}
      described_class.symbols(headers)
      expect(HttpWrapper).to have_received(:fetch).with("symbols", headers)
    end
  end

  describe ".maps" do
    it "calls the fetch method" do
      headers = {}
      described_class.maps(headers)
      expect(HttpWrapper).to have_received(:fetch).with("maps", headers)
    end
  end

  describe ".neighbors" do
    it "calls the fetch method" do
      headers = {}
      described_class.neighbors(headers)
      expect(HttpWrapper).to have_received(:fetch).with("neighbors", headers)
    end
  end

  describe ".get_map" do
    it "calls the fetch method" do
      headers = {}
      described_class.get_map(headers)
      expect(HttpWrapper).to have_received(:fetch).with("getmap", headers)
    end
  end

  describe ".fuzzy_del_hash" do
    it "calls the fetch method" do
      headers = {}
      described_class.fuzzy_del_hash(headers)
      expect(HttpWrapper).to have_received(:fetch).with("fuzzydelhash", headers)
    end
  end

  describe ".plugins" do
    it "calls the fetch method" do
      headers = {}
      described_class.plugins(headers)
      expect(HttpWrapper).to have_received(:fetch).with("plugins", headers)
    end
  end

  describe ".ping" do
    it "calls the fetch method" do
      described_class.ping
      expect(HttpWrapper).to have_received(:fetch).with("ping")
    end
  end
end
