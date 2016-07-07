ROOT = File.expand_path('../..', __FILE__)

require 'yaml'
require 'erb'
require "#{ROOT}/app/bot"

APPLICATION_SETTINGS = YAML.load(ERB.new(File.read("#{ROOT}/config/application.yml")).result)

class Application

	def self.launch
		Bot.new.run
	end
end