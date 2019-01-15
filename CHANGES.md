# CH CH CH CHANGES #

## Otherwise known as the changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## Unreleased


## [v2.0.0] - Tuesday the 15th of January, 2019

### Added

- Started using [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

### Changed

- Expanded the use of the library beyond just atom.
- Added lots more tests.
- The API now adheres more to the terms used in the RFC.
- Tried to keep the laziness factor available.
- Removed the old `TagURI.create` API (the major version change means it's a breaking change).
- Tried to get TagURI::URI closer to the Ruby stdlib's URI API. More could probably be done here.
- Improved the docs by adding specs that mirror the examples given.
- Git tags will now be signed by GPG too (look in my gists for Keybase or go to [http://keybase.io/iainb](http://keybase.io/iainb) to get the key).


## [v1.0.1] - Sunday the 14th of June, 2015

- Improved the docs.


## [v1.0.0] - Sunday the 14th of June, 2015

- Updated to use Ruby v2's keywords.
- Bumped to v1.0.0 as a semver release.


## [v0.0.3] - Wednesday the 27th of February, 2013

- Since the Github repo is called tag-uri (because a hypen is clearer in a URL) I've added tag-uri.rb and taguri.rb to the lib to require the library in case anyone uses the wrong name.


## [v0.0.2] - Wednesday the 27th of February, 2013

- Changed to be a class method, as if it's mixed in to a model then the model will likely want to use that name for the field.
- Changed the module name, it should all be uppercase so now it is.