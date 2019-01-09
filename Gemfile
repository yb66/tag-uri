RUBY_ENGINE = 'ruby' unless defined? RUBY_ENGINE
source 'https://rubygems.org'

# Specify your gem's dependencies in tag_uri.gemspec
gemspec

gem "rake"

group :development do
  gem "yard"
  gem "maruku"
  unless RUBY_ENGINE == 'jruby' || RUBY_ENGINE == "rbx"
    gem "pry-byebug"
    gem "rb-readline"
  end
end

group :test do
  gem "rspec"
  gem "rspec-its"
  gem "rspec-given"
  gem "simplecov"
end
