class AnswersController < ApplicationController
  def create
    question = Question.find(params[:question_id])
    answer = question.answers.build(body: params[:body])
    if answer.save
      redirect_to(answer.question)
    else
      render :new
    end
  end

  def new
  end
end
