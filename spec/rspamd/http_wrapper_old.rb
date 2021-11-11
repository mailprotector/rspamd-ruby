# frozen_string_literal: true

require "./lib/http_wrapper"
require "./lib/rspamd/response_types"
# require "pry"

RSpec.describe HttpWrapper do
  context ".fetch" do
    context "succeeds" do
      describe "with valid json" do
        let(:response_body) { '{"test": "ing"}' }
        let(:get_double) { instance_double(HTTParty::Response, body: response_body) }

        before do
          allow(get_double).to receive(:body).and_return(response_body)
          allow(get_double).to receive(:success?).and_return(true)
          allow(get_double).to receive(:code).and_return(200)
          allow(HttpWrapper).to receive(:get).and_return(get_double)
          allow(ResponseTypes).to receive(:convert).and_return(true)
        end

        it "calls the get method with the correct params" do
          response = described_class.fetch("test", { 'test_header': "test" }, "sandwich=true")
          expect(HttpWrapper).to have_received(:get).with("/test?sandwich=true", { format: :json, headers: { test_header: "test" } })
          expect(response).to eq(true)
        end
      end

      describe "with invalid json" do
        let(:response_body) { "pong" }
        let(:get_double) { instance_double(HTTParty::Response, body: response_body) }

        before do
          allow(get_double).to receive(:body).and_return(response_body)
          allow(get_double).to receive(:success?).and_return(true)
          allow(get_double).to receive(:code).and_return(200)
          allow(HttpWrapper).to receive(:get).and_return(get_double)
        end

        it "calls the get method with the correct params" do
          response = described_class.fetch("ping", { 'test_header': "test" }, "sandwich=true")
          expect(HttpWrapper).to have_received(:get).with("/ping?sandwich=true", { format: :json, headers: { test_header: "test" } })
          expect(response).to eq("pong")
        end
      end
    end

    context "fails" do
      describe "with valid json and response.success? false" do
        let(:response_body) { '{"test": "ing"}' }
        let(:get_double) { instance_double(HTTParty::Response, body: response_body) }

        before do
          allow(get_double).to receive(:body).and_return(response_body)
          allow(get_double).to receive(:success?).and_return(false)
          allow(get_double).to receive(:code).and_return(200)
          allow(HttpWrapper).to receive(:get).and_return(get_double)
        end

        it "calls the get method with the correct params" do
          described_class.fetch("test", { 'test_header': "test" }, "sandwich=true")
        rescue StandardError => e
          expect(HttpWrapper).to have_received(:get).with("/test?sandwich=true", { format: :json, headers: { test_header: "test" } })
          expect(e.message).to eq("Invalid RSpamD API Response - URI:/test?sandwich=true")
        end
      end
    end
  end

  context ".push" do
    context "succeeds" do
      describe "with valid json" do
        let(:response_body) { '{"test": "ing"}' }
        let(:post_double) { instance_double(HTTParty::Response, body: response_body) }
        let(:body) { "body" }

        before do
          allow(post_double).to receive(:body).and_return(response_body)
          allow(post_double).to receive(:success?).and_return(true)
          allow(post_double).to receive(:code).and_return(200)
          allow(HttpWrapper).to receive(:post).and_return(post_double)
          allow(ResponseTypes).to receive(:convert).and_return(true)
        end

        it "calls the post method with the correct params" do
          response = described_class.push("test", { 'test_header': "test" }, body, "sandwich=true")
          expect(HttpWrapper).to have_received(:post).with("/test?sandwich=true", { format: :json, headers: { test_header: "test" }, body: body })
          expect(response).to eq(true)
        end
      end

      describe "with invalid json" do
        let(:response_body) { "pong" }
        let(:post_double) { instance_double(HTTParty::Response, body: response_body) }
        let(:body) { "body" }

        before do
          allow(post_double).to receive(:body).and_return(response_body)
          allow(post_double).to receive(:success?).and_return(true)
          allow(post_double).to receive(:code).and_return(200)
          allow(HttpWrapper).to receive(:post).and_return(post_double)
        end

        it "calls the post method with the correct params" do
          response = described_class.push("ping", { 'test_header': "test" }, body, "sandwich=true")
          expect(HttpWrapper).to have_received(:post).with("/ping?sandwich=true", { format: :json, headers: { test_header: "test" }, body: body })
          expect(response).to eq("pong")
        end
      end
    end

    context "fails" do
      describe "with valid json and response.success? false" do
        let(:response_body) { '{"test": "ing"}' }
        let(:post_double) { instance_double(HTTParty::Response, body: response_body) }
        let(:body) { "body" }

        before do
          allow(post_double).to receive(:body).and_return(response_body)
          allow(post_double).to receive(:success?).and_return(false)
          allow(post_double).to receive(:code).and_return(200)
          allow(HttpWrapper).to receive(:post).and_return(post_double)
        end

        it "calls the post method with the correct params" do
          described_class.push("test", { 'test_header': "test" }, body, "sandwich=true")
        rescue StandardError => e
          expect(HttpWrapper).to have_received(:post).with("/test?sandwich=true", { format: :json, headers: { test_header: "test" }, body: body })
          expect(e.message).to eq("Invalid RSpamD API Response - URI:/test?sandwich=true")
        end
      end
    end
  end
end
