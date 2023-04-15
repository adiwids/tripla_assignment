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
end
