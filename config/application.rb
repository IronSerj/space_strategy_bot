ROOT = File.expand_path('../..', __FILE__)

require 'yaml'
require 'erb'
require 'bundler'
require "#{ROOT}/app/bot"

Bundler.require
APPLICATION_SETTINGS = YAML.load(ERB.new(File.read("#{ROOT}/config/application.yml")).result)

class Application
  SLEEP_INTERVAL = 2

	def self.launch
    Client.new(Bot.new).run
  rescue Client::ConnectionIsLostError
    sleep SLEEP_INTERVAL
    retry
	end
end
