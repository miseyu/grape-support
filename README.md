# Grape::Support

grape project support library

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape-support'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape-support

## initialize
```ruby
  Grape::Support.setup do |config|
    config.distribute_lock_client = {
      host: '192.168.0.2',
      port: 6379,
      database: 1
    }
    config.auth_api_host_url = "#{Settings.api.auth.schema}://#{Settings.api.auth.host}:#{Settings.api.auth.port}"
  end
```

## Usage

### grape generator

```
$ bin/rails g grape:support:grape Hoge
```
