class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :load_answer, only: :show
  before_action :load_subscribtion, only: :show

  include Voted

  authorize_resource

  def index
    respond_with(@questions = Question.all.page(params[:page]))
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    @question.update(questions_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_answer
    @answer = @question.answers.build
  end

  def load_subscribtion
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
