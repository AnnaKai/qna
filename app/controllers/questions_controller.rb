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
    user_question = Question.find(params[:id])
    if current_user.author_of?(user_question)
      if user_question.update(question_params)
        redirect_to question
      else
        render :edit
      end
    else
      redirect_to questions_path(question), notice: 'You\'re not eligible to edit that question'
    end
  end

  def destroy
    if current_user.author_of?(question)
      user_question.destroy
      redirect_to questions_path, notice: 'You have successfully deleted your question'
    else
      redirect_to question_path(question), notice: 'You\'re not eligible to delete that question'
    end
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
    params.require(:question).permit(:title, :body, :best_answer_id)
  end
end
