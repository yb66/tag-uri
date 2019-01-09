# encoding: UTF-8

require 'rspec'
require 'rspec/its'
require 'rspec/given'
Spec_dir = File.expand_path( File.dirname __FILE__ )

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
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

# RSpec.configure do |config|
# end
