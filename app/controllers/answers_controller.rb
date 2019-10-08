class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.create(body: params[:body], author: current_user, question_id: question.id)
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(answer)
      user_answer.destroy
      redirect_to question_path(question), notice: 'You have successfully deleted your answer'
    else
      redirect_to question_path(question), notice: 'You\'re not eligible to delete that answer'
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def user_answer
    @answer = current_user.answers.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :user_answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
