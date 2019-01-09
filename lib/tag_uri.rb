# encoding: UTF-8

require 'addressable/uri'

# Implementation of tag URI's.
# @see http://tools.ietf.org/html/rfc4151
module TagURI

  class Error < StandardError; end
  class ArgumentError < Error; end

  # @param [Hash] opts
  # @option opts [String] host The host portion e.g. http://example.com. If the host portion is not given then it is assumed that `self` will provide it.
  # @option opts [String] slug The slugged name e.g. this-is-my-first-post.
  # @option opts [String] prefix Anything you wish to tack on before the slug in the path e.g. for /posts/this-is-my-first-post pass in `prefix: "/posts"`. If a prefix is not given then it will not be added to the string.
  # @option opts [Time] created_at The time the resource was created. If a created_at time is not given then it is assumed that `self` will provide it.
  # @return [String]
  # @example
  #   class Posts < Sequel::Model # or whatever ORM you're using.
  #   end
  #   post = Post.create #…
  #   post.slug # => "this-is-my-first-post"
  #   TagURI.create host: "http://example.com", prefix: "posts", slug: post.slug, created_at: post.created_at
  def self.create( created_at: Time.now, prefix:"", slug:, host: )
    fail ArgumentError if host.nil? || host.empty?
    fail ArgumentError if slug.nil? || slug.empty?
    
    host = "https://#{host}" unless host =~ %r{^.+\://.+$}
    uri = Addressable::URI.parse File.join( host, prefix, slug )
    uri.scheme = "tag"
    uri.host = "#{uri.host},#{created_at.strftime "%F"}:"
    uri.to_s.sub(%r{://}, ":")
  end
end
