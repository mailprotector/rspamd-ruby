# rspamd-ruby
An Rspamd ruby client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspamd-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspamd-ruby

## Usage

Create an Rspamd::Client to use its methods

```ruby
rpsamd = Rspamd::Client.new
```

By default the client will try to use the ENV['RSPAMD_URL'] environment variable. If it doesn't find one it will use http://localhost:11334
Passing in a string to the Rspamd::Client allows you to define the RSPAMD_URL the client will connect to.

```ruby
custom_url = 'fancy_url'
rspamd = Rspamd::Client.new custom_url
```

## Methods

The email parameter is the email we want to perform scans on.

The **options is where we can set the HTTP Headers and HTTP Query String, every key/value passed into the options parmameter will be sent as Headers.
To set HTTP Query Parameters, we can pass in params: 'test=true&gravity=still_working'.

### scan (email, **options)
```ruby
rpsamd = Rspamd::Client.new
email = 'bad_email'
response = rspamd.scan(email, Rcpt: 'test@test.com', params: 'bad=param')
```
Response:
```ruby
<struct ResponseTypes::MESSAGE
 is_skipped=false,
 score=11.9,
 required_score=12.0,
 action="quarantine",
 symbols=[
   <struct ResponseTypes::SYMBOL
    name="MIME_TRACE",
    score=0.0,
    metric_score=0.0,
    description=nil,
    options=["0:+"]>
  ],
 messages={},
 message_id="undef",
 time_real=0.299173,
 milter={"remove_headers"=>{"X-Spam"=>0}}>
```

### fuzzy_add(email, **options)
```ruby
rpsamd = Rspamd::Client.new
email = 'bad_email'
response = rspamd.fuzzy_add(email)
```

### fuzzy_del(email, **options)

### learn_spam(email, **options)

### learn_ham(email, **options)

### errors(**options)

### stat(**options)

### stat_reset(**options)

### graph(type, **options)

### history(**options)

### history_reset(**options)

### actions(**options)

### symbols(**options)

### maps(**options)

### neighbors(**options)

### get_map(**options)

### fuzzy_del_hash(**options)

### plugins(**options)

### ping
