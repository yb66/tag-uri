# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tag_uri/version'

Gem::Specification.new do |gem|
  gem.name          = "tag_uri"
  gem.version       = TagURI::VERSION
  gem.authors       = ["Iain Barnett"]
  gem.email         = ["helpful-iain@theprintedbird.com"]
  gem.description   = %q{An implementation of tag URI's.
  See http://tools.ietf.org/html/rfc4151}
  gem.summary       = %q{Instead of using a permalink as the id for an Atom feed entry (or anything else you'd use a permalink for), use a tag URI.}
  gem.homepage      = "https://github.com/yb66/tag-uri"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency("addressable")
  gem.required_ruby_version = '~> 2.0'
end
