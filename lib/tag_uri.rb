# encoding: UTF-8

require 'addressable/uri'

# Implementation of tag URI's.
# @see http://tools.ietf.org/html/rfc4151
module TagUri

  class Error < StandardError; end
  class ArgumentError < Error; end

  DEFAULT_FAILURE_BLOCK = ->(x) {
    fail ArgumentError, "The TagUri#tag_uri method requires a host, a slug, and a created_at time to work. Please check they're provided, as #{x} was nil."
  }

  # @param [Hash] opts
  # @option opts [String] host The host portion e.g. http://example.com. If the host portion is not given then it is assumed that `self` will provide it.
  # @option opts [String] slug The slugged name e.g. this-is-my-first-post. If a slug is not given then it is assumed that `self` will provide it.
  # @option opts [String] prefix Anything you wish to tack on before the slug in the path e.g. for /posts/this-is-my-first-post pass in "prefix". If a prefix is not given then it will not be added to the string.
  # @option opts [Time] created_at The time the resource was created. If a created_at time is not given then it is assumed that `self` will provide it.
  # @return [String]
  # @example
  #   class Posts
  #     include TagUri
  #   end
  #   post = Post.create #…
  #   post.slug # => "this-is-my-first-post"
  #   post.tag_uri host: "http://example.com", prefix: "posts"
  def tag_uri( opts={}, &failure_block )
    opts = opts.dup
    opts[:host] ||= self.host
    opts[:slug] ||= self.slug
    opts[:created_at] ||= self.created_at
    opts[:prefix] ||= ""
    opts.each do |k,v|
      if v.nil?  
        failure_block ||= DEFAULT_FAILURE_BLOCK
        failure_block.call k.to_s
      end
    end
    opts[:host] = "https://#{opts[:host]}" unless opts[:host] =~ %r{^.+\://.+$} #
    url = File.join opts[:host], opts[:prefix], opts[:slug]
    uri = Addressable::URI.parse url
    uri.scheme = "tag"
    uri.host = "#{uri.host},#{opts[:created_at].strftime "%F"}:"
    uri.to_s.sub(%r{://}, ":")
  end
end