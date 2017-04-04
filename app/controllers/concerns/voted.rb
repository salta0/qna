module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_reset]
  end


  def model_klass
    controller_name.classify.constantize
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote(1, current_user.id) unless current_user.voted?(@votable)
    render_json
  end

  def vote_down
    authorize! :vote_up, @votable
    @votable.vote(-1, current_user.id) unless current_user.voted?(@votable)
    render_json
  end

  def vote_reset
    authorize! :vote_reset, @votable
    @votable.reset(current_user.id)
    render_json
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_json
    render json: {
      item_id: @votable.id, rating: @votable.rating,
      voted: current_user.voted?(@votable),
      name: @votable.class.name.downcase.pluralize
    }
  end
end
