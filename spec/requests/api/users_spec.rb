require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:token) { 'validtoken' }
  let(:current_user) { FactoryBot.create(:user) }

  describe 'GET /api/users' do
    let(:subject) do
      get '/api/users', headers: { 'Authorization' => "Bearer #{token}", 'Accept' => 'application/json' }
    end

    before { FactoryBot.create_list(:user, 2) }

    context 'with authenticated access' do
      it 'returns success response with list of users data' do
        stub_authenticated_token(token, current_user) do
          subject
          expect(response).to have_http_status(:ok)
          data = json_response['data']
          expect(data).to be_any
          expect(data.first.keys).to match_array(%w[id type attributes])
          expect(data.first['type']).to eq('user')
          expect(data.first['attributes'].keys).to match_array(%w[name is_following is_followed])
        end
      end
    end

    context 'unauthenticated access' do
      it 'returns error response' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json_response.keys).to match_array(%w[message])
      end
    end
  end

  describe 'POST /api/users/{id}/follow' do
    let(:subject) do
      post "/api/users/#{user.id}/follow", headers: { 'Authorization' => "Bearer #{token}", 'Accept' => 'application/json' }
    end
    let(:user) { FactoryBot.create(:jerry) }

    context 'with authenticated access' do
      context 'and target user not followed yet' do
        before do
          expect(current_user.follow_relations.where(followed_id: user.id)).to be_empty
        end

        it 'returns success response with relation data' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.keys).to match_array(%w[id type attributes relationships])
            expect(data['type']).to eq('following')
            expect(data['attributes'].keys).to match_array(%w[status created_at updated_at])
            expect(data['relationships'].keys).to match_array(%w[followed follower])
            expect(data['relationships']['followed']['data']['type']).to eq('user')
          end
        end
      end

      context 'and target user already followed' do
        before do
          FactoryBot.create(:following, :approved, follower: current_user, followed: user)
        end

        it 'returns success response without content' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:no_content)
            expect(response.body).to be_blank
          end
        end
      end

      context 'and target user not found' do
        let(:user) { FactoryBot.build_stubbed(:user) }

        it 'returns not found error response' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:not_found)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end

      context 'and target user is current user itself' do
        let(:user) { current_user }

        it 'returns bad request error response' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:bad_request)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end
    end

    context 'with unauthenticated access' do
      it 'returns error response' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json_response.keys).to match_array(%w[message])
      end
    end
  end
end
