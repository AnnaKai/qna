class AnswersController < ApplicationController
  def create
    answer.author = current_user
    if answer.save
      redirect_to(answer.question, notice: 'Your answer has been successfully created.')
    else
      render 'questions/show'
    end
  end

  def new
  end

  def destroy
    answer.destroy
    redirect_to question_path(question), notice: 'You have successfully deleted your answer'
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new(body: params[:body], question: question)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
