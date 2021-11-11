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

## Available Headers

| Headers           | Description |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Deliver-To        | Defines actual delivery recipient of message. Can be used for personalized statistics and for user specific options    |
| IP	              | Defines IP from which this message is received                                                                         |
| Helo	            | Defines SMTP helo                                                                                                      |
| Hostname	        | Defines resolved hostname                                                                                              |
| Flags	            | Supported from version 2.0: Defines output flags as a commas separated list                                            |
| From	            | Defines SMTP mail from command data                                                                                    |
| Queue-Id	        | Defines SMTP queue id for message (can be used instead of message id in logging)                                       |
| Raw	              | If set to yes, then Rspamd assumes that the content is not MIME and treat it as raw data                               |
| Rcpt	            | Defines SMTP recipient (there may be several Rcpt headers)                                                             |
| Pass	            | If this header has all value, all filters would be checked for this message                                            |
| Subject	          | Defines subject of message (is used for non-mime messages)                                                             |
| User	            | Defines username for authenticated SMTP client                                                                         |
| Message-Length	  | Defines the length of message excluding the control block                                                              |
| Settings-ID	      | Defines settings id to apply                                                                                           |
| Settings	        | Defines list of rules (settings apply part) as raw json block to apply                                                 |
| User-Agent	      | Defines user agent (special processing if it is rspamc)                                                                |
| MTA-Tag	          | MTA defined tag (can be used in settings)                                                                              |
| MTA-Name	        | Defines MTA name, used in Authentication-Results routines                                                              |
| TLS-Cipher	      | Defines TLS cipher name                                                                                                |
| TLS-Version	      | Defines TLS version                                                                                                    |
| TLS-Cert-Issuer	  | Defines Cert issuer, can be used in conjunction with client_ca_name in proxy worker                                    |
| URL-Format	      | Supported from version 1.9: return all URLs and email if this header is extended                                       |
| Filename          |                                                                                                                        |


## Available Flags

| Flags             | Description                                             |
| ----------------- | ------------------------------------------------------- |
| pass_all          | pass all filters                                        |
| groups            | return symbols groups                                   |
| zstd              | compressed input/output                                 |
| no_log            | do not log task                                         |
| milter            | apply milter protocol related hacks                     |
| profile           | profile performance for this task                       |
| body_block        | accept rewritten body as a separate part of reply       |
| ext_urls          | extended urls information                               |
| skip              | skip all filters processing                             |
| skip_process      | skip mime parsing/processing                            |

## Methods

The email parameter is the email we want to perform scans on.

The **options is where we can set the HTTP Headers and HTTP Query String, every key/value passed into the options parmameter will be sent as Headers.
To set HTTP Query Parameters, we can pass in params:String to the options.

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

##

![alt text](https://i1.wp.com/mailprotector.com/wp-content/uploads/2020/03/cropped-logo-2x.png)

[About Mailprotector](https://mailprotector.com/about-mailprotector)
