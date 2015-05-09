require_relative 'init'
require 'fakes-rspec'
require_relative 'require_util'

class FakeRequest
  attr_reader :request

  class PathInfo
    include Initializer

    initializer :path_info, :request_method
  end

  def initialize(path=nil, method=:get)
    @request = PathInfo.new(path, method)
    @path = path
  end

  def []=(key, value)
    env[key] = value
  end

  def env
    @env ||= {}
  end
end

RSpec.configure do |config|
  config.before(:each) do
    if (respond_to?(:use_test_settings))
      ::Settings.configure do |config|
        config.change_setting_resolver_to do |key|
          TestSettings::SETTINGS_FACTORY.create(key)
        end
      end
    end

  end
  config.after(:each) do 
    if (respond_to?(:use_test_settings))
      @target_klass = nil
      TestSettings::SETTINGS_FACTORY.clear
      ::Utilities::SETTINGS_CONFIGURATION.call
    end
  end
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Require.non_spec_files.in("support/vcr")
Require.non_spec_files.in("support")
Require.only_specs.in("lib")
Require.only_specs.in("v1")
