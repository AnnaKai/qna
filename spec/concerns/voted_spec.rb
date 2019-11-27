shared_examples "voted controller" do

  let(:class_model) { described_class.controller_name.singularize.to_sym }
  let(:user)          { create(:user) }
  let!(:votable) { create(class_model)  }

  describe 'POST #vote_up' do
    context 'authenticated user' do
      context 'votes for others\' votables' do
        before { login(create(:user)) }

        it 'votes successfully' do
          expect { post :vote_up, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
          expect(votable.votes.last.value).to eq(1)
        end

        it 'renders json' do
          post :vote_up, params: { id: votable }, format: :json
          json_response = JSON.parse(response.body)

          expect(json_response['value']).to eq 1
        end

        it "can not vote twice" do
          2.times { post :vote_up, params: { id: votable }, format: :json }
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['value']).to eq ["You can't vote twice"]
        end
      end

      context 'author of the votable' do
        before { login(votable.author) }

        it "can not vote" do
          expect { post :vote_up, params: { id: votable }, format: :json }.to_not change(votable.votes, :count)
        end

        it 'gets 422 status' do
          post :vote_up, params: { id: votable }, format: :json

          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe 'POST #vote_down' do
    context 'authenticated user' do
      context 'votes for others\' votables' do
        before { login(user) }

        it 'votes successfully' do
          expect { post :vote_down, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
          expect(votable.votes.last.value).to eq(-1)
        end

        it 'renders json' do
          post :vote_down, params: { id: votable }, format: :json
          json_response = JSON.parse(response.body)

          expect(json_response['value']).to eq(-1)
        end

        it "can not vote twice" do
          2.times { post :vote_up, params: { id: votable }, format: :json }
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['value']).to eq ["You can't vote twice"]
        end
      end

      context 'author of the votable' do
        before { login(votable.author) }
        it "can't vote" do
          expect { post :vote_down, params: { id: votable }, format: :json }.to_not change(votable.votes, :count)
        end

        it 'gets 422 status' do
          post :vote_up, params: { id: votable }, format: :json

          expect(response).to have_http_status(422)
        end
      end
    end

    context 'unauthenticated user' do
      it "can't vote" do
        expect { post :vote_up, params: { id: votable }, format: :json }.to_not change(votable.votes, :count)
      end

      it '401 status' do
        post :vote_up, params: { id: votable }, format: :json

        expect(response).to have_http_status(401)
      end
    end
  end
end
