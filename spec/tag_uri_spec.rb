# encoding: UTF-8

require 'spec_helper'
require 'time'
require 'ostruct'
require_relative "../lib/tag_uri.rb"

describe "Generating a tag uri" do
  let(:url) { "http://diveintomark.org/archives/2004/05/27/howto-atom-linkblog" }
  let(:slug) { "howto-atom-linkblog" }
  let(:created_at) { Time.parse "2004/05/27" }
  let(:host) { "diveintomark.org" }
  let(:prefix) { "/archives/2004/05/27" }
  let(:expected) { "tag:diveintomark.org,2004-05-27:/archives/2004/05/27/howto-atom-linkblog" }
  let(:model) { OpenStruct.new created_at: created_at, slug: slug }

  context "Given arguments" do
    context "That are valid" do
      subject { TagURI.create prefix: prefix, host: host, created_at: model.created_at, slug: model.slug }
      it { should == expected }
    end
    context "That are not valid" do
      it "raises" do
        expect { TagURI.create prefix: prefix, host: nil, created_at: model.created_at, slug: model.slug }.to raise_error TagURI::ArgumentError
      end
    end
  end
end