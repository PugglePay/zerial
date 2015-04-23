# Zerial

Serializer/Deserializer tools

## Installation

Add this line to your application's Gemfile:

    gem 'zerial'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zerial

## Usage

A serializer is an object with 4 methods: `to_json`, `as_json`, `from_json` and `from_loaded_json`.

`to_json` and `from_json` are the main entry points of the
serializer/deserializer, and `as_json` and `from_loaded_json` are
intermediate processing methods.

See examples in `spec/lib/zerial`

## TODO

* Remove dependency on ActiveSupport

## Contributing

1. Fork it ( https://github.com/[my-github-username]/zerial/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
