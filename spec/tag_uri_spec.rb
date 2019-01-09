# encoding: UTF-8

require 'spec_helper'
require 'time'
require 'ostruct'
require_relative "../lib/tag_uri.rb"

shared_examples "Given arguments" do

  context "Given arguments" do
    context "That are valid" do
      When(:tag_uri) { TagURI.create prefix: prefix, host: host, created_at: model.created_at, slug: model.slug }
      Then { tag_uri == expected }
    end
    context "That are not valid" do
      it "raises" do
        expect { TagURI.create prefix: prefix, host: nil, created_at: model.created_at, slug: model.slug }.to raise_error TagURI::ArgumentError
      end
    end
  end
end

describe "Generating a tag uri" do
  context "diveintomark atom tag" do
    Given(:url) { "http://diveintomark.org/archives/2004/05/27/howto-atom-linkblog" }
    Given(:slug) { "howto-atom-linkblog" }
    Given(:created_at) { Time.parse "2004/05/27" }
    Given(:host) { "diveintomark.org" }
    Given(:prefix) { "/archives/2004/05/27" }
    Given(:expected) { "tag:diveintomark.org,2004-05-27:/archives/2004/05/27/howto-atom-linkblog" }
    Given(:model) { OpenStruct.new created_at: created_at, slug: slug }
    include_examples "Given arguments"
  end
  context "Sandro's dog tag" do
    Given(:url) { "sandro@hawke.org" }
    Given(:slug) { "Taiko" }
    Given(:created_at) { Time.parse "2001-06-05" }
    Given(:host) { "hawke.org" }
    Given(:prefix) { nil }
    Given(:expected) { " tag:sandro@hawke.org,2001-06-05:Taiko" }
    Given(:model) { OpenStruct.new created_at: created_at, slug: slug }
    include_examples "Given arguments"
  end
end