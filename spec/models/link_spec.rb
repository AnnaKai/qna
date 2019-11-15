require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist?' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/lorenadl/a1eb26efdf545b4b2b9448086de3961d') }
    let!(:google_link) { build(:link, url: 'google.com') }

    it { expect(gist_link).to be_gist }
    it { expect(google_link).to_not be_gist }
  end

end
