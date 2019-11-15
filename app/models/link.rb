class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  def gist?
    url.include?('gist.github.com')
  end

  def gist_id
    url.sub('https://gist.github.com/', '')
  end
end
