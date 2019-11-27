require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it do
    should validate_inclusion_of(:value)
     .in_array([-1, 1])
     .with_message("You can't vote twice")
  end

  describe '#vote_up' do
    let(:user) { create(:user) }
    let(:votable) { create(:question) }

    it { expect(described_class.vote_up(user, votable)).to be_an_instance_of(Vote) }

    it 'returns nil if revote' do
      create(:vote, user: user, votable: votable, value: -1)
      expect(described_class.vote_up(user, votable)).to be_nil
    end

    context 'can upvote others\' votable entity' do
      it { expect { described_class.vote_up(user, votable).save }.to change(votable, :rating).by(1) }

      it 'can vote when votable entity has rating' do
        create(:vote, user: create(:user), votable: votable, value: 1)
        expect { described_class.vote_up(user, votable).save }.to change(votable, :rating).by(1)
      end
    end

    context 'can not vote for their own votable entity' do
      let(:votable) { create(:question, author: user) }

      it { expect { described_class.vote_up(user, votable).save }.to_not change(votable, :rating) }
    end
  end

  describe '#vote_down' do
    let(:user) { create(:user) }
    let(:votable) { create(:question) }

    it { expect(described_class.vote_up(user, votable)).to be_an_instance_of(Vote) }

    it 'returns nil if revote' do
      create(:vote, user: user, votable: votable, value: 1)
      expect(described_class.vote_down(user, votable)).to be_nil
    end

    context 'can downvote others\' votable entity' do
      it do
        expect { described_class.vote_down(user, votable).save }.to change(votable, :rating).by(-1)
      end

      it 'has rating to downvote' do
        create(:vote, user: create(:user), votable: votable, value: 1)
        expect { described_class.vote_down(user, votable).save }.to change(votable, :rating).by(-1)
      end
    end

    context 'author of the votable entity' do
      let(:votable) { create(:question, author: user) }

      it { expect { described_class.vote_down(user, votable).save }.to_not change(votable, :rating) }
      it 'has error messages' do
        vote = described_class.vote_down(user, votable)
        vote.valid?
        expect(vote.errors[:user]).to include("Author can't vote")
      end
    end
  end
end
