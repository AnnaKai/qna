class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question has been successfully created.'
    else
      render :new
    end
  end

  def update
    if user_question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    user_question.destroy
    redirect_to questions_path, notice: 'You have successfully deleted your question'
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def user_question
    @question = current_user.questions.find(params[:id])
  end

  helper_method :question, :user_question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
