require 'rails_helper'

RSpec.describe SearchResultsController, type: :controller do

  describe "GET #index" do
    %w(question answer comment user all).each do |subject|
      it "search #{subject}" do
        expect(Search).to receive(:make_search).with("query", "#{subject}")
        get :index, query: "query", subject: "#{subject}"
      end
    end
  end
end
