# encoding: UTF-8

require 'spec_helper'
require 'time'
require_relative "../lib/tag_uri.rb"

describe "Generating a tag uri", :time_sensitive do

  context "THE MOST BASIC WAY" do
    When(:tag_uri) {
      TagURI::URI.new authority_name: "helpful-iain@theprintedbird.com",
                      date: "2019-01-09",
                      specific: "My slippers"
    }
    Then { tag_uri.to_s == "tag:helpful-iain@theprintedbird.com,2019-01-09:My%20slippers"}
  end


  context "ANOTHER MOST BASIC WAY" do
    When(:tag_uri) {
      TagURI::URI.new email: "helpful-iain@theprintedbird.com",
                      date: "2019-01-09",
                      specific: "My slippers"
    }
    Then { tag_uri.to_s == "tag:helpful-iain@theprintedbird.com,2019-01-09:My%20slippers"}
  end

  context "(NOT TO FLOG A DEAD HORSE BUT) ANOTHER MOST BASIC WAY" do
    When(:tag_uri) {
      TagURI::URI.new domain: "theprintedbird.com",
                      date: "2019-01-09",
                      specific: "My slippers"
    }
    Then { tag_uri.to_s == "tag:theprintedbird.com,2019-01-09:My%20slippers"}
  end

  context "YOU HAVE A WEB LINK TO AN ARTICLE ABOUT BEESWAX (WHY NOT?) AND YOU'RE FEELING LAZY", :time_sensitive do
    When(:tag_uri) {
      TagURI::URI.new uri: "http://www.example.com/posts/beeswax#bees"
    }
    Then { tag_uri.to_s == "tag:www.example.com,2018-03-11:/posts/beeswax#bees"}
    And  { tag_uri.scheme == "tag" }
    And  { tag_uri.authority_name == "www.example.com" }
    And  { tag_uri.date == TIME_NOW }
    And  { tag_uri.specific == "/posts/beeswax" }
    And  { tag_uri.fragment == "bees" }
  end

  context "Some of the examples on the internet" do
    context "diveintomark atom tag" do
      Given(:url) { "http://diveintomark.org/archives/2004/05/27/howto-atom-linkblog" }
      Given(:specific) { "/archives/2004/05/27/howto-atom-linkblog" }
      Given(:date) { Time.strptime "2004/05/27", "%Y/%m/%d" }
      Given(:authority_name) { "diveintomark.org" }
      Given(:prefix) { "/archives/2004/05/27" }
      Given(:expected) { "tag:diveintomark.org,2004-05-27:/archives/2004/05/27/howto-atom-linkblog" }
      Given(:fragment) { "" }
      context "identity" do
        context "by string" do
          When(:tag_uri) { TagURI::URI.new uri: expected }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == authority_name }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
        context "by uri" do
          When(:tag_uri) { TagURI::URI.new uri: TagURI::URI.new(uri: expected) }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == authority_name }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
      end
      context "authority_name given" do
        context "That is valid" do
          When(:tag_uri) { TagURI::URI.new  uri: url,
                                            authority_name: authority_name }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == authority_name }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
        context "That is not valid" do
          it "should fail, tagged by TagURI" do
            expect { TagURI::URI.new uri: url,
                                     authority_name: "NOT_A_DOMAIN_NAME"
                    }.to raise_error TagURI::ArgumentError
          end
        end
      end
      context "date given" do
        context "That is valid" do
          When(:tag_uri) { TagURI::URI.new  uri: url,
                                            date: date }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == authority_name }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
        
        context "That is not valid" do
          date = "Not a date"
          it "should throw an error (tagged by the library)" do
            expect { TagURI::URI.new  uri: url, date: date }.to raise_error TagURI::ArgumentError
          end
        end
      end
      context "specific given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          specific: specific }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == date }
        And  { tag_uri.specific       == specific }
        And  { tag_uri.fragment       == fragment }
      end
      context "email given" do
        context "That is valid" do
          Given(:email) { "alice@example.org" }
          When(:tag_uri) { TagURI::URI.new  uri: url,
                                            email: email }
          Then { tag_uri.to_s           == expected.sub(authority_name, email) }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == email }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
        context "That is not valid" do
          it "should fail, tagged by TagURI" do
            expect { TagURI::URI.new uri: url,
                                     email: "NOT_AN_EMAIL_ADDRESS"
                    }.to raise_error TagURI::ArgumentError
          end
        end
      end

      context "domain given" do
        context "That is valid" do
          Given(:domain) { "diveintomark.org" }
          When(:tag_uri) { TagURI::URI.new  uri: url,
                                            domain: domain }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == domain }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
        context "That is not valid" do
          it "should fail, tagged by TagURI" do
            expect { TagURI::URI.new uri: url,
                                     domain: "NOT_A_DOMAIN_NAME"
                    }.to raise_error TagURI::ArgumentError
          end
        end
      end

      context "No authority_name or domain or email given" do
        context "But the URI has valid one of those" do
          When(:tag_uri) { TagURI::URI.new  uri: url }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == authority_name }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
      end
    end
    context "Sandro's dog tag" do
      Given(:url) { "sandro@hawke.org" }
      Given(:authority_name) { "sandro@hawke.org" }
      Given(:specific) { "Taiko" }
      Given(:date) { Time.parse "2001-06-05" }
      Given(:expected) { "tag:sandro@hawke.org,2001-06-05:Taiko" }
      Given(:fragment) { "" }
      context "identity" do
        When(:tag_uri) { TagURI::URI.new uri: expected }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == date }
        And  { tag_uri.specific       == specific }
        And  { tag_uri.fragment       == fragment }
      end
      context "authority_name given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          authority_name: authority_name }
        Given(:expected) { "tag:sandro@hawke.org,2018-03-11:sandro@hawke.org" }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == TIME_NOW }
        And  { tag_uri.specific       == authority_name }
        And  { tag_uri.fragment       == fragment }
      end
      context "date given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          date: date }
        Given(:expected) { "tag:sandro@hawke.org,2001-06-05:sandro@hawke.org" }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == date }
        And  { tag_uri.specific       == authority_name }
        And  { tag_uri.fragment       == fragment }
      end
      context "specific given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          specific: specific }
        Given(:expected) { "tag:sandro@hawke.org,2018-03-11:Taiko" }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == TIME_NOW }
        And  { tag_uri.specific       == specific }
        And  { tag_uri.fragment       == fragment }
      end
      context "No authority_name or domain or email given" do
        context "But the URI has valid one of those" do
          When(:tag_uri) { TagURI::URI.new  uri: url, specific: specific, date: date }
          Then { tag_uri.to_s           == expected }
          And  { tag_uri.scheme         == "tag" }
          And  { tag_uri.authority_name == authority_name }
          And  { tag_uri.date           == date }
          And  { tag_uri.specific       == specific }
          And  { tag_uri.fragment       == fragment }
        end
      end
    end
  end
  context "And one I made up because I was listening to Beeswax by Nirvana at the time" do
    context "Beeswax" do
      Given(:url) { "http://example.com/2019-01-09/beeswax#bees" }
      Given(:specific) { "beeswax" }
      Given(:date) { Time.parse "2019-01-08" }
      Given(:authority_name) { "example.com" }
      Given(:expected) { "tag:example.com,2019-01-08:beeswax#bees" }
      Given(:fragment) { "bees" }
      context "identity" do
        When(:tag_uri) { TagURI::URI.new uri: expected }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == date }
        And  { tag_uri.specific       == specific }
        And  { tag_uri.fragment       == fragment }
      end
      context "authority_name given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          authority_name: authority_name }
        Given(:expected) { "tag:example.com,2019-01-09:/2019-01-09/beeswax#bees" }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == Time.parse("2019-01-09") }
        And  { tag_uri.specific       == "/2019-01-09/beeswax" }
        And  { tag_uri.fragment       == fragment }
      end
      context "date given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          date: date }
        Given(:expected) { "tag:example.com,2019-01-08:/2019-01-09/beeswax#bees" }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == date }
        And  { tag_uri.specific       == "/2019-01-09/beeswax" }
        And  { tag_uri.fragment       == fragment }
      end
      context "fragment given" do
        When(:tag_uri) { TagURI::URI.new  uri: url,
                                          fragment: "bees" }
        Given(:expected) { "tag:example.com,2019-01-09:/2019-01-09/beeswax#bees" }
        Then { tag_uri.to_s           == expected }
        And  { tag_uri.scheme         == "tag" }
        And  { tag_uri.authority_name == authority_name }
        And  { tag_uri.date           == Time.parse("2019-01-09") }
        And  { tag_uri.specific       == "/2019-01-09/beeswax" }
        And  { tag_uri.fragment       == fragment }
      end
    end
  end
end

describe "Validating a tag" do
  context "A valid tag" do
    Given(:a_tag) { "tag:diveintomark.org,2004-05-27:/archives/2004/05/27/howto-atom-linkblog" }
    When(:tag_uri) { TagURI::URI.new uri: a_tag }
    Then { tag_uri.valid? }
  end
  context "An invalid tag" do
    Given(:a_tag) { "tag:,2004-05-27:/archives/2004/05/27/howto-atom-linkblog" }
    When(:tag_uri) { TagURI::URI.new uri: a_tag }
    Then { !tag_uri.valid? }
  end
end


SHOULD = []
SHOULD_NOT = []
pn = Spec_dir.join("support/fixtures/urls.txt")

pn.each_line do |line|
  line.chomp!
  next if line.nil? or line.empty?
  if ~ /^SHOULD MATCH\:/ ... ~ /^END/ # flip flop be bop
    SHOULD << line unless $~ or ~ /^SHOULD MATCH\:/
  else
    SHOULD_NOT << line unless  ~ /^SHOULD NOT MATCH\:/
  end
end


describe "TagURI::URI::DNSNAME" do

  SHOULD.each do |uri|
    context "#{uri}" do
      When(:match) { /^#{TagURI::URI::DNSNAME}$/ =~ uri }
      Then { match }
    end
  end

  SHOULD_NOT.each do |uri|
    context "#{uri}" do
      When(:match) { /^#{TagURI::URI::DNSNAME}$/ =~ uri }
      Then { !match }
    end
  end
end