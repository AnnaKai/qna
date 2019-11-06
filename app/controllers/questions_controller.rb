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
      if params[:question][:files].present?
        params[:question][:files].each do |file|
          @question.files.attach(file)
        end
      end
      redirect_to @question, notice: 'Your question has been successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(question)
      if params[:question][:files].present?
        params[:question][:files].each do |file|
          @question.files.attach(file)
        end
      end
      question.update(question_params)
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
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def user_question
    @question = current_user.questions.find(params[:id])
  end

  helper_method :question, :user_question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
