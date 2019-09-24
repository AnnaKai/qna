class AnswersController < ApplicationController
  def create
    if answer.save
      redirect_to(answer.question, notice: 'Your answer has been successfully created.')
    else
      render 'questions/show'
    end
  end

  def new
  end

  private

  def answer
    @answer = question.answers.build(body: params[:body])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :question

end
