# frozen_string_literal: true

require "./lib/rspamd/response_types"
# require "pry"

RSpec.describe Rspamd::ResponseTypes do
  describe "convert" do
    let(:parsed_json) do
      JSON.parse('{
        "is_skipped": false,
        "score": 11.900000,
        "required_score": 12.0,
        "action": "quarantine",
        "symbols": {
            "MIME_TRACE": {
                "name": "MIME_TRACE",
                "score": 0.0,
                "metric_score": 0.0,
                "options": [
                    "0:+"
                ]
            },
            "MISSING_FROM": {
                "name": "MISSING_FROM",
                "score": 2.0,
                "metric_score": 2.0,
                "description": "Missing From: header"
            },
            "MISSING_TO": {
                "name": "MISSING_TO",
                "score": 2.0,
                "metric_score": 2.0,
                "description": "To header is missing"
            },
            "MISSING_SUBJECT": {
                "name": "MISSING_SUBJECT",
                "score": 2.0,
                "metric_score": 2.0,
                "description": "Subject header is missing"
            },
            "MISSING_DATE": {
                "name": "MISSING_DATE",
                "score": 1.0,
                "metric_score": 1.0,
                "description": "Message date is missing"
            },
            "RCVD_COUNT_ZERO": {
                "name": "RCVD_COUNT_ZERO",
                "score": 0.0,
                "metric_score": 0.0,
                "description": "Message has no Received headers",
                "options": [
                    "0"
                ]
            },
            "DMARC_NA": {
                "name": "DMARC_NA",
                "score": 0.0,
                "metric_score": 0.0,
                "description": "No DMARC record",
                "options": [
                    "No From header"
                ]
            },
            "R_DKIM_NA": {
                "name": "R_DKIM_NA",
                "score": 0.0,
                "metric_score": 0.0,
                "description": "Missing DKIM signature"
            },
            "MIME_GOOD": {
                "name": "MIME_GOOD",
                "score": -0.100000,
                "metric_score": -0.100000,
                "description": "Known content-type",
                "options": [
                    "text/plain"
                ]
            },
            "HFILTER_HOSTNAME_UNKNOWN": {
                "name": "HFILTER_HOSTNAME_UNKNOWN",
                "score": 2.500000,
                "metric_score": 2.500000,
                "description": "Unknown client hostname (PTR or FCrDNS verification failed)"
            },
            "MISSING_MID": {
                "name": "MISSING_MID",
                "score": 2.500000,
                "metric_score": 2.500000,
                "description": "Message id is missing"
            }
          },
          "messages": {},
          "message-id": "undef",
          "time_real": 0.003247,
          "milter": {
              "remove_headers": {
                  "X-Spam": 0
              }
          }
      }')
    end

    it "converts from json hash correctly" do
      response = Rspamd::ResponseTypes.convert(parsed_json)
      expect(response.is_skipped).to eq(false)
      expect(response.score).to eq(11.9)
      expect(response.required_score).to eq(12.0)
      expect(response.action).to eq("quarantine")
      expect(response.messages).to eq({})
      expect(response.message_id).to eq("undef")
      expect(response.time_real).to eq(0.003247)
      expect(response.milter).to eq({ "remove_headers" => { "X-Spam" => 0 } })

      response.symbols.each do |sym, _i|
        expect(sym.name).to eq(parsed_json["symbols"][sym.name]["name"])
        expect(sym.score).to eq(parsed_json["symbols"][sym.name]["score"])
        expect(sym.metric_score).to eq(parsed_json["symbols"][sym.name]["metric_score"])
        expect(sym.description).to eq(parsed_json["symbols"][sym.name]["description"])
        expect(sym.options).to eq(parsed_json["symbols"][sym.name]["options"])
      end
    end

    it ".convert #symbol_score_sum" do
      response = Rspamd::ResponseTypes.convert(parsed_json)
      expect(response.symbol_score_sum).to eq(11.9)
    end

    it ".convert #symbol_metric_score_sum" do
      response = Rspamd::ResponseTypes.convert(parsed_json)
      expect(response.symbol_metric_score_sum).to eq(11.9)
    end
  end
end
