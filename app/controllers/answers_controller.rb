class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(body: params[:body], author: current_user, question_id: question.id)
  end

  def update
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      head :forbidden
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'You have successfully deleted your answer'
    else
      redirect_to question_path(answer.question), notice: 'You\'re not eligible to delete that answer'
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
