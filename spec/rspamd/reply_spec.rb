# frozen_string_literal: true

require './lib/rspamd/reply'
# require "pry"

RSpec.describe Rspamd::Reply do
  describe 'convert' do
    let(:response) do
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

    it 'converts from json hash correctly' do
      reply = Rspamd::Reply.new(response)
      expect(reply.is_skipped).to eq(false)
      expect(reply.score).to eq(11.9)
      expect(reply.required_score).to eq(12.0)
      expect(reply.action).to eq('quarantine')
      expect(reply.messages).to eq({})
      expect(reply.message_id).to eq('undef')
      expect(reply.time_real).to eq(0.003247)
      expect(reply.milter).to eq({ 'remove_headers' => { 'X-Spam' => 0 } })

      reply.symbols.each do |sym, _i|
        expect(sym.name).to eq(response['symbols'][sym.name]['name'])
        expect(sym.score).to eq(response['symbols'][sym.name]['score'])
        expect(sym.metric_score).to eq(response['symbols'][sym.name]['metric_score'])
        expect(sym.description).to eq(response['symbols'][sym.name]['description'])
        expect(sym.options).to eq(response['symbols'][sym.name]['options'])
      end
    end

    it '.convert #total_score' do
      reply = Rspamd::Reply.new(response)
      expect(reply.total_score).to eq(11.9)
    end

    it '.convert #total_metric_score' do
      reply = Rspamd::Reply.new(response)
      expect(reply.total_metric_score).to eq(11.9)
    end
  end
end
