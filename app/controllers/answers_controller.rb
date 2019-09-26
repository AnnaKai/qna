class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.new(body: params[:body], question: question, author: current_user)
    if @answer.save
      redirect_to(@answer.question, notice: 'Your answer has been successfully created.')
    else
      render 'questions/show'
    end
  end

  def destroy
    user_answer.destroy
    redirect_to question_path(question), notice: 'You have successfully deleted your answer'
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

end
