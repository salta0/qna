require 'rails_helper'

describe 'Search' do
  it "make search for all" do
    expect(ThinkingSphinx).to receive(:search).with("query")
    Search.make_search("query", "all")
  end

  %w(question answer comment user).each do |subject|
    it "make search for #{subject}" do
      expect(ThinkingSphinx).to receive(:search).with("query", {classes: ["#{subject}".classify.constantize]})
      Search.make_search("query", "#{subject}")
    end
  end

  it "doesn't make search with blank query" do
    expect(ThinkingSphinx).to_not receive(:search)
    Search.make_search("", "all")
  end

  it "doesn't make search with invalid subject" do
    expect(ThinkingSphinx).to_not receive(:search)
    Search.make_search("query", "something")
  end
end
