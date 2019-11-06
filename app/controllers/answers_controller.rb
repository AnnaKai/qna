class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    if params[:answer][:files].present?
      params[:answer][:files].each do |file|
        @answer.files.attach(file)
      end
    end
    @answer.save
  end

  def update
    if current_user.author_of?(answer)
      if params[:answer][:files].present?
        params[:answer][:files].each do |file|
          answer.files.attach(file)
        end
      end
      answer.update(answer_params)
      @question = answer.question
    end
  end

  def best
    answer.best! if current_user.author_of?(answer.question)
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

end
