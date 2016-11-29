require File.expand_path('../boot', __FILE__)

require 'boto/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Boto.groups)

module BotoExample
  class Application < Boto::Application
    config.adapter = Clients::Telegram.new
  end
end

Foxy.env = Boto.env
