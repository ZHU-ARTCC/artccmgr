# OmniAuth VATSIM

OmniAuth::Strategies::Vatsim is an OmniAuth strategy for authenticating with 
the VATSIM SSO with OAuth1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-vatsim'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-vatsim

## Usage

Add the strategy to your ```Gemfile```:

```ruby
gem 'omniauth-vatsim'
```

Or you can pull it directly from github:

```ruby
gem 'omniauth-vatsim', git: 'https://github.com/jvoss/omniauth-vatsim.git'
```

### RSA-SHA1 (Recommended)
#### IMPORTANT NOTE 
An issue with OAuth-Ruby v0.5.1 requires the consumer secret to
be set with RSA-SHA1. Unfortunately that means it must be set to the 
contents of an unencrypted (no passphrase) private key file! In my examples
below, I suggest a way to do this in memory while still keeping a passphrase
on the key.

Specifically the issue lies [here](https://github.com/oauth-xx/oauth-ruby/blob/v0.5.1/lib/oauth/signature/rsa/sha1.rb) 
at line 37. It does not matter if a private key is specified in the consumer, it 
always will instantiate a new private key object.

For a Rails application, create an initializer ```config/initializers/omniauth.rb```:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  private_key = OpenSSL::PKey::RSA.new(IO.read('<PRIVATE KEY FILENAME>'), ENV['key_passphrase'])

  provider :vatsim, 'Consumer Key', private_key.to_pem, 
     site: 'https://cert.vatsim.net/sso',
     signature_method: 'RSA-SHA1',
     private_key: private_key
end
```

For a Rails application using [Devise](https://github.com/plataformatec/devise), modify ```config/initializers/devise.rb```:

```ruby
private_key = OpenSSL::PKey::RSA.new(IO.read('<PRIVATE KEY FILENAME>'), ENV['key_passphrase'])

config.omniauth :vatsim, 'Consumer Key', private_key, 
  client_options: {
    site: 'https://cert.vatsim.net/sso',
    signature_method: 'RSA-SHA1',
    private_key: private_key
  }
```

For Sinatra you would add:

```ruby
use Rack::Session::Cookie

private_key = OpenSSL::PKey::RSA.new(IO.read('<PRIVATE KEY FILENAME>'), ENV['key_passphrase'])

use OmniAuth::Builder do
  provider :vatsim, 'Consumer Key', private_key, 
    site: 'https://cert.vatsim.net/sso'
    signature_method: 'RSA-SHA1',
    private_key: private_key
end
```

### HMAC-SHA1

For a Rails application, create an initializer ```config/initializers/omniauth.rb```:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vatsim, 'Consumer Key', 'Consumer Secret', site: 'https://cert.vatsim.net/sso'
end
```

For a Rails application using [Devise](https://github.com/plataformatec/devise), modify ```config/initializers/devise.rb```:

```ruby
config.omniauth :vatsim, 'Consumer Key', 'Consumer Secret', client_options: {site: 'https://cert.vatsim.net/sso'}
```

For Sinatra you would add:

```ruby
use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :vatsim, 'Consumer Key', 'Consumer Secret', site: 'https://cert.vatsim.net/sso'
end
```

## Sample Auth Hash

```
{
  "provider"=>"vatsim",
  "uid"=>"1300011",
  "info"=>{
    "id"=>"1300011",
    "name_first"=>"11th",
    "name_last"=>"Test",
    "rating"=>{
      "id"=>"11", 
      "short"=>"SUP", 
      "long"=>"Supervisor", 
      "GRP"=>"Supervisor"
    },
    "pilot_rating"=>{
      "rating"=>"22",
      "2"=>{
        "id"=>2, 
        "short"=>"P2", 
        "long"=>"Flight Fundamentals"
      },
      "4"=>{
        "id"=>4,
        "short"=>"P3",
        "long"=>"VFR Pilot"
      },
      "16"=>{
        "id"=>16, 
        "short"=>"P5", 
        "long"=>"Advanced IFR Pilot"
       }
     },
     "email"=>"noreply@vatsim.net",
     "experience"=>"N",
     "reg_date"=>"2014-05-14 17:17:26",
     "country"=>{
       "code"=>"GB", "name"=>"United Kingdom"
     },
     "region"=>{
       "code"=>"EUR", "name"=>"Europe"
     },
     "division"=>{
       "code"=>"GBR", "name"=>"United Kingdom"
     },
     "subdivision"=>{
       "code"=>nil, "name"=>nil
     }
   }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jvoss/omniauth-vatsim.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
