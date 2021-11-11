# frozen_string_literal: true

require "./lib/rspamd/client"
require "./lib/rspamd/response_types"
# require "pry"
RSpec.describe Rspamd::Client do
  context "instance methods" do
    describe ".checkv2" do
      let(:response_body) { '{"test": "ing"}' }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(Rspamd::Client).to receive(:post).and_return(post_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.checkv2(body)
      end

      it "calls the push method" do
        headers = {}
        expect(Rspamd::Client).to have_received(:post).with(
          "http://localhost:11334/checkv2",
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe "#fuzzy_add" do
      let(:response_body) { '{"test": "ing"}' }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:post).and_return(post_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.fuzzy_add(body)
      end

      it "calls the push method" do
        headers = {}
        expect(Rspamd::Client).to have_received(:post).with(
          "http://localhost:11334/fuzzyadd",
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe "#fuzzy_del" do
      let(:response_body) { '{"test": "ing"}' }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:post).and_return(post_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.fuzzy_del(body)
      end

      it "calls the push method" do
        headers = {}
        expect(Rspamd::Client).to have_received(:post).with(
          "http://localhost:11334/fuzzydel",
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe "#learn_spam" do
      let(:response_body) { '{"test": "ing"}' }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:post).and_return(post_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.learn_spam(body)
      end

      it "calls the push method" do
        headers = {}
        expect(Rspamd::Client).to have_received(:post).with(
          "http://localhost:11334/learnspam",
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe "#learn_ham" do
      let(:response_body) { '{"test": "ing"}' }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:post).and_return(post_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.learn_ham(body)
      end

      it "calls the push method" do
        headers = {}
        expect(Rspamd::Client).to have_received(:post).with(
          "http://localhost:11334/learnham",
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe "#errors" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.errors(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/errors",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#stat" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.stat(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/stat",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#stat_reset" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.stat_reset(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/statreset",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#graph" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.graph("testtype", Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/graph?type=testtype",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#history" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.history(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/history",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#history_reset" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.history_reset(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/historyreset",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#actions" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.actions(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/actions",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#symbols" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.symbols(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/symbols",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#maps" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.maps(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/maps",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#neighbors" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.neighbors(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/neighbors",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#get_map" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.get_map(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/getmap",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#fuzzy_del_hash" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.fuzzy_del_hash(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/fuzzydelhash",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#plugins" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.plugins(Subject: "test")
      end

      it "calls the push method" do
        headers = { Subject: "test" }
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/plugins",
          { format: :json, headers: headers }
        )
      end
    end

    describe "#ping" do
      let(:response_body) { '{"test": "ing"}' }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd::Client.new }
      let(:body) { "body" }

      before do
        allow(Rspamd::Client).to receive(:get).and_return(get_double)
        allow(ResponseTypes).to receive(:convert).and_return(response_body)
        rspamd.ping
      end

      it "calls the push method" do
        expect(Rspamd::Client).to have_received(:get).with(
          "http://localhost:11334/ping",
          { format: :json, headers: {} }
        )
      end
    end
  end
end
