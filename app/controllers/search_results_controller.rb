class SearchResultsController < ApplicationController
  def index
    authorize! :read, @results
    respond_with(@results = Search.make_search(params[:query], params[:subject]))
  end
end