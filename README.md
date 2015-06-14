# TagUri

An implementation of tag URI's.
See http://tools.ietf.org/html/rfc4151

### Build status ###

Master branch:
[![Build Status](https://travis-ci.org/yb66/tag-uri.png?branch=master)](https://travis-ci.org/yb66/tag-uri)

## Why? ##

Because every Atom entry must have a globally unique ID, in the `id` element. 

* The ID must be a valid URI, as defined by RFC 2396.
* The ID must be globally unique, across all Atom feeds, everywhere, for all time. This part is actually easier than it sounds.
* The ID must never, ever change.

Some people use a permalink for this, but we all know that permalinks change, so use a tag URI instead. See http://web.archive.org/web/20110514113830/http://diveintomark.org/archives/2004/05/28/howto-atom-id for more.


## Installation

Add this line to your application's Gemfile:

    gem 'tag_uri'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tag_uri

## Usage

    require 'taguri'

Given a model:

    class Post < Sequel::Model # it doesn't have to be Sequel
    end

    post = Post.create title: "How to make a good ID in Atom"
    post.slug
    # => "howto-atom-linkblog"
    post.created_at
    # => 2004-05-27 00:00:00 0100
    
    TagURI.create prefix: "/archives/2004/05/27", host: "diveintomark.org", slug: post.slug, created_at: post.created_at
    # => "tag:diveintomark.org,2013-02-26:/archives/2004/05/27/howto-atom-linkblog"

Although you'll probably do something more like this:

    TagURI.create slug: post.slug, created_at: post.created_at prefix: prefix, host: request.host

or something like that.

## Versioning ##

This library uses [semver](http://semver.org).


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
