# TagURI

An implementation of tag URIs.
See http://tools.ietf.org/html/rfc4151

### Build status ###

Master branch:
[![Build Status](https://travis-ci.org/yb66/tag-uri.png?branch=master)](https://travis-ci.org/yb66/tag-uri)

## Why? ##

I originally wrote this because every Atom entry must have a globally unique ID, in the `id` element, and I was writing an atom feed.

* The ID must be a valid URI, as defined by RFC 2396.
* The ID must be globally unique, across all Atom feeds, everywhere, for all time. This part is actually easier than it sounds.
* The ID must never, ever change.

Some people use a permalink for this, but we all know that permalinks change, so use a tag URI instead. See the following articles for a bit more info:

- [IBM developer works, Managing XML data: Tag URIs](http://www.ibm.com/developerworks/library/x-mxd6/index.html)
- [Tag URI](http://taguri.org)
- [How to make a good ID in Atom](http://web.archive.org/web/20110514113830/http://diveintomark.org/archives/2004/05/28/howto-atom-id)

You don't have to just use it with Atom, it's also useful anywhere that a non-tied-to-location URI might make sense. As one of the linked articles states:

> Tag URIs finally let URIs do what they were meant to do: identify without implying any sort of location or behavior that they don't have. They're easy to create, they're human legible, they work with existing systems, they're an open standard, and they don't have any backward compatibility issues. What's not to like?


## Usage

    require 'tag_uri'

### THE MOST BASIC WAY

    tag_uri = TagURI::URI.new authority_name: "helpful-iain@theprintedbird.com",
                    date: "2019-01-09",
                    specific: "My slippers"

    tag_uri.to_s
    # => "tag:helpful-iain@theprintedbird.com,2019-01-09:My%20slippers"
    tag.authority_name
    # => "helpful-iain@theprintedbird.com"
    tag.date
    # => 2019-01-09 00:00:00 +0900 # You get a Time object back
    tag.specific "My slippers"

### ANOTHER MOST BASIC WAY

    TagURI::URI.new email: "helpful-iain@theprintedbird.com",
                    date: "2019-01-09",
                    specific: "My slippers"

    tag_uri.to_s
    # => "tag:helpful-iain@theprintedbird.com,2019-01-09:My%20slippers"
    tag.authority_name
    # => "helpful-iain@theprintedbird.com"
    tag.date
    # => 2019-01-09 00:00:00 +0900
    tag.specific "My slippers"

### (NOT TO FLOG A DEAD HORSE BUT) ANOTHER MOST BASIC WAY

    TagURI::URI.new domain: "theprintedbird.com",
                    date: "2019-01-09",
                    specific: "My slippers"

    tag_uri.to_s
    # => "tag:theprintedbird.com,2019-01-09:My%20slippers"
    tag.authority_name
    # => "theprintedbird.com"
    tag.date
    # => 2019-01-09 00:00:00 +0900
    tag.specific "My slippers"


### YOU HAVE A WEB LINK TO AN ARTICLE ABOUT BEESWAX (WHY NOT?) AND YOU'RE FEELING LAZY

    Don't be this lazy as you'll be letting a computer and my programming try to guess what you wanted. But…

    # Imagine it's the 2018-03-11 today, because today is the day that'll be
    # chosen for your tag date.
    tag_uri = TagURI::URI.new uri: "http://www.example.com/posts/beeswax#bees"

    tag_uri.to_s
    # => "tag:www.example.com,2018-03-11:/posts/beeswax#bees"
    tag_uri.authority_name
    # => "www.example.com"
    tag_uri.specific
    # => "/posts/beeswax"
    tag_uri.fragment # yes, you get fragments too!
    # => "bees"

Given a model:

    class Post < Sequel::Model # it doesn't have to be Sequel
    end

    post = Post.create title: "How to make a good ID in Atom"
    post.slug
    # => "howto-atom-linkblog"
    post.created_at
    # => 2004-05-27 00:00:00 0100
    post.prefix
    # => "/archives/2004/05/27/" # Why? It's up to you.

    tag_uri = TagURI::URI.new authority_name: request.host,
                    date: post.created_at,
                    specific: "#{post.prefix}#{slug}"

    tag_uri.to_s
    # => "tag:diveintomark.org,2013-02-26:/archives/2004/05/27/howto-atom-linkblog"

or something like that.


## Installation

Add this line to your application's Gemfile:

    gem 'tag_uri'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tag_uri

## Even better installation

I'm trying to be a [responsible citizen regarding security](https://keybase.io/iainb) so I've followed the [instructions here](https://guides.rubygems.org/security/) and created a [public certicate](https://gist.github.com/yb66/0fb0e3007de4d4279aeaf162e0ced40a#file-yb66-pem) and signed the gem, so you can install it via:

    gem cert --add <(curl -Ls https://gist.githubusercontent.com/yb66/0fb0e3007de4d4279aeaf162e0ced40a/raw/49466a801e1fd237fffe4658143a96c6cca6c961/yb66.pem)

    gem install tag_uri -P MediumSecurity

The MediumSecurity trust profile will verify signed gems, but allow the installation of unsigned dependencies.

If all of TagURI’s dependencies are signed you can use HighSecurity.

    gem install tag_uri -P HighSecurity

It's just one more [good reason](https://cfoc.org/rubygems-vulnerability-can-compel-installing-malware/) to get on to gem authors and ask them to sign their gems, and ask the Rubygems authors to be [proactive with security measures](https://github.com/rubygems/rubygems/issues/2496).

## Versioning ##

This library uses [semver](http://semver.org).


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
