class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :set_best]
  before_action :find_question, only: :create
  before_action :set_question, only: [:update, :set_best]

  include Voted

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @answer.set_best
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_question
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit( :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
