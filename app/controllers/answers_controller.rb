class AnswersController < ApplicationController
  def create
    answer = Answer.create!(question_id: params[:question_id], body: params[:body])
    redirect_to(answer.question)
  end
end
