# encoding: UTF-8

require 'rspec'
require 'rspec/its'
require 'rspec/given'
require 'timecop'
Spec_dir = Pathname( __dir__ )

if ENV["DEBUG"]
  require 'pry-byebug'
  binding.pry
end

# code coverage
require 'simplecov'
SimpleCov.start do
  add_filter "/vendor.noindex/"
  add_filter "/coverage/"
  add_filter "/bin/"
  add_filter "/spec/"
end


Dir[ File.join( Spec_dir, "/support/**/*.rb")].each do |f|
  require f
end

TIME_NOW = Time.parse "2018-03-11T06:49:16+00:00"
RSpec.configure do |config|

  config.before(:each, :time_sensitive => true) do
    Timecop.freeze TIME_NOW
  end

  config.after(:each, :time_sensitive => true) do
    Timecop.return
  end
end