class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_subscription, only: :destroy

  authorize_resource

  def create
    respond_with(@subscription = @question.subscriptions.create(user: current_user)) unless current_user.subscribed?(@question)
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end
end
