ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
require 'test/unit'
require File.expand_path(File.join(ENV['RAILS_ROOT'], '/config/environment.rb'))
require 'rails_generator'
require File.join(File.dirname(__FILE__), 'generator_test_helper')