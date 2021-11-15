# frozen_string_literal: true

require './lib/rspamd'

RSpec.describe Rspamd do
  context 'constants' do
    it 'has a version number' do
      expect(Rspamd::VERSION).not_to be nil
    end

    it 'has available headers' do
      expect(Rspamd::AVAILABLE_HEADERS).not_to be nil
    end

    it 'has available flags' do
      expect(Rspamd::AVAILABLE_FLAGS).not_to be nil
    end
  end

  context 'class methods' do
    describe '#scan' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:new).and_return(response_body)
        rspamd.scan(body)
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:post).with(
          '/checkv2',
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe '#fuzzy_add' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        rspamd.fuzzy_add(body)
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:post).with(
          '/fuzzyadd',
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe '#fuzzy_del' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        rspamd.fuzzy_del(body)
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:post).with(
          '/fuzzydel',
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe '#learn_spam' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        rspamd.learn_spam(body)
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:post).with(
          '/learnspam',
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe '#learn_ham' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.learn_ham(body)
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:post).with(
          '/learnham',
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe '#errors' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.errors(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/errors',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#stat' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.stat(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/stat',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#stat_reset' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.stat_reset(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/statreset',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#graph' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.graph('testtype', Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/graph?type=testtype',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#history' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.history(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/history',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#history_reset' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.history_reset(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/historyreset',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#actions' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.actions(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/actions',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#symbols' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.symbols(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/symbols',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#maps' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.maps(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/maps',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#neighbors' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.neighbors(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/neighbors',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#get_map' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.get_map(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/getmap',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#fuzzy_del_hash' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.fuzzy_del_hash(Subject: 'test')
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/fuzzydelhash',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#plugins' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.plugins
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/plugins',
          { format: :json, headers: headers }
        )
      end
    end

    describe '#ping' do
      let(:response_body) { { "test": 'ing' } }
      let(:get_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:get).and_return(get_double)
        allow(Rspamd::Reply).to receive(:convert).and_return(response_body)
        Rspamd.ping
      end

      it 'calls the push method' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }]
        expect(Rspamd).to have_received(:get).with(
          '/ping',
          { format: :json, headers: headers }
        )
      end
    end
  end

  context 'private methods' do
    describe 'prepare_flags' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:new).and_return(response_body)
        Rspamd.scan(body, flags: 'badflag,badflag2,pass_all,groups')
      end

      it 'removes bad flags' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }, { Flags: 'pass_all,groups' }]
        expect(Rspamd).to have_received(:post).with(
          '/checkv2',
          { body: body, format: :json, headers: headers }
        )
      end
    end

    describe 'prepare_headers' do
      let(:response_body) { { "test": 'ing' } }
      let(:post_double) { instance_double(HTTParty::Response, body: response_body, success?: true) }
      let(:rspamd) { Rspamd }
      let(:body) { 'body' }

      before do
        allow(Rspamd).to receive(:post).and_return(post_double)
        allow(Rspamd::Reply).to receive(:new).and_return(response_body)
        Rspamd.scan(body, subject: 'test', "Bad-Header": false)
      end

      it 'removes bad headers' do
        headers = [{ 'User-Agent' => 'rspamd-ruby' }, { Subject: 'test' }]
        expect(Rspamd).to have_received(:post).with(
          '/checkv2',
          { body: body, format: :json, headers: headers }
        )
      end
    end
  end
end
