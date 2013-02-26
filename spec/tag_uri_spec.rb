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
  let(:model) { 
    o = OpenStruct.new created_at: created_at, slug: slug
    o.extend TagUri
    warn "o.respond_to? :tag_uri #{o.respond_to? :tag_uri}"
    o
  }
  subject { model }
  it { should respond_to :tag_uri }
  context "Given arguments" do
    context "That are valid" do
      subject { model.tag_uri prefix: prefix, host: host }
      it { should == expected }
    end
    context "That are not valid" do
      it "raises" do
        expect { model.tag_uri prefix: prefix, host: nil }.to raise_error TagUri::ArgumentError
      end
    end
  end
end