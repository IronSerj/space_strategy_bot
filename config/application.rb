require 'yaml'
require 'erb'

APPLICATION_SETTINGS = YAML.load(ERB.new(File.read(File.expand_path('../application.yml', __FILE__))).result)