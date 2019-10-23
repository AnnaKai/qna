class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    alias has_a belongs_to
  end
end
