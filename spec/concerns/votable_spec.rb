shared_examples 'votable model' do
  let(:class_model) { described_class.name.underscore.to_sym }
  let(:user) { create(:user) }
  let(:votable) { create(class_model) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let!(:votes_up) { create_list(:vote, 4, user: user, votable: votable, value: 1) }
    let!(:votes_down) { create_list(:vote, 2, user: user, votable: votable, value: -1) }

    it { expect(votable.rating).to eq 2 }
  end
end
