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

Some people use a permalink for this, but we all know that permalinks change, so use a tag URI instead. See the following articles for a bit more info:

- [IBM developer works, Managing XML data: Tag URIs](http://www.ibm.com/developerworks/library/x-mxd6/index.html)
- [Tag URI](http://taguri.org)
- [How to make a good ID in Atom](http://web.archive.org/web/20110514113830/http://diveintomark.org/archives/2004/05/28/howto-atom-id)

You don't have to just use it with Atom, it's also useful anywhere that a non-tied-to-location URI might make sense. As one of the linked articles states:

> Tag URIs finally let URIs do what they were meant to do: identify without implying any sort of location or behavior that they don't have. They're easy to create, they're human legible, they work with existing systems, they're an open standard, and they don't have any backward compatibility issues. What's not to like?


## Installation

Add this line to your application's Gemfile:

    gem 'tag_uri'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tag_uri

## Usage

    require 'tag_uri'

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
