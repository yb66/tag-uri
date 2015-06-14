require "bundler/gem_tasks"


task :default => "spec"


desc "(Re-) generate documentation and place it in the docs/ dir."
task :doc => :"doc:yard"  
namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['-odoc/', '--no-private']
  end

  desc "Docs including private methods."
  YARD::Rake::YardocTask.new(:all) do |t|
    t.files   = ['lib/**/*.rb']
    t.options = ['-odoc/']
  end
    
  desc "How to use the docs."
  task :usage do
    puts "Open the index.html file in the doc directory to read them. Does not include methods marked private unless you ran the 'all' version (you'll only need these if you plan to hack on the library itself)."
  end
end


require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb"
end