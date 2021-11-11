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
puts response
puts response.symbol_score_sum
puts response.symbol_metric_score_sum
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
```ruby
rpsamd = Rspamd::Client.new
email = 'bad_email'
response = rspamd.fuzzy_del(email)
```

### learn_spam(email, **options)
```ruby
rpsamd = Rspamd::Client.new
email = 'bad_email'
response = rspamd.learn_spam(email)
```

### learn_ham(email, **options)
```ruby
rpsamd = Rspamd::Client.new
email = 'bad_email'
response = rspamd.learn_ham(email)
```

### errors(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.errors()
```

### stat(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.stat()
```

### stat_reset(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.stat_reset()
```

### graph(type, **options)
```ruby
rpsamd = Rspamd::Client.new
type = 'special_type'
response = rspamd.graph(type)
```

### history(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.history()
```

### history_reset(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.history_reset()
```

### actions(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.actions()
```

### symbols(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.symbols()
```

### maps(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.maps()
```

### neighbors(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.neighbors()
```

### get_map(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.get_map()
```

### fuzzy_del_hash(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.fuzzy_del_hash()
```

### plugins(**options)
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.plugins()
```

### ping
```ruby
rpsamd = Rspamd::Client.new
response = rspamd.ping()
```
