class AddAnswersToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :answers, :question, index: true, null: false
  end
end
