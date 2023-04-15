require 'rails_helper'

RSpec.describe "Sleep Cycles", type: :request do
  let(:token) { 'validtoken' }
  let(:current_user) { FactoryBot.create(:user) }

  describe "GET /api/user/sleep_cycles" do
    let(:subject) do
      get "/api/user/sleep_cycles", headers: { 'Accept' => 'application/json', 'Authorization' => "Bearer #{token}" }
    end
    let(:jerry) { FactoryBot.create(:jerry) }

    before do
      FactoryBot.create(:following, :approved, follower: current_user, followed: jerry)
      travel_to Time.zone.now - 1.day do
        # someone-else sleep cycle
        FactoryBot.create(:sleep_cycle, :waken_up)
        # followed user's history
        FactoryBot.create(:sleep_cycle, :waken_up, user: jerry)
        # self-owned history
        FactoryBot.create(:sleep_cycle, :waken_up, user: current_user)
      end
      # self-owned on-going cycle
      FactoryBot.create(:sleep_cycle, :active, user: current_user)
      # self-owned but inactivated and actual wake up time not set (incomplete)
      FactoryBot.create(:sleep_cycle, :empty_inactive, user: current_user)
    end

    context 'with authenticated access' do
      context "fetching all of current user's sleep cycles" do
        it "returns all current user's sleep cycles log" do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.size).to eq(3)
            expect(data.first.keys).to match_array(%w[id type attributes relationships])
            expect(data.first['type']).to eq('sleep_cycle')
            expect(data.first['attributes'].keys).to match_array(%w[set_wake_up_time actual_wake_up_time duration_miliseconds status created_at])
            expect(data.first['relationships'].keys).to include('user')
          end
        end
      end

      context "fetching current user and it's followed users's sleep cycles history ranked by duration" do
        let(:subject) do
          get "/api/user/sleep_cycles",
              params: { only_completed: true, include_followings: true, order_by: 'duration desc' },
              headers: { 'Accept' => 'application/json', 'Authorization' => "Bearer #{token}" }
        end

        it "returns current user and followed user's sleep cycles completed log" do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.size).to eq(2)
          end
        end
      end
    end

    context 'with unauthorized access' do
      it 'returns error response' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json_response.keys).to match_array(%w[message])
      end
    end
  end

  describe "GET /api/users/:user_id/sleep_cycles" do
    let(:subject) do
      get "/api/users/#{user.id}/sleep_cycles", headers: { 'Accept' => 'application/json', 'Authorization' => "Bearer #{token}" }
    end
    let(:user) { FactoryBot.create(:jerry) }

    context 'with authenticated access' do
      before do
        travel_to Time.zone.now - 1.day do
          # followed user's history
          FactoryBot.create(:sleep_cycle, :waken_up, user: user)
          # self-owned history
          FactoryBot.create(:sleep_cycle, :waken_up, user: current_user)
        end
        FactoryBot.create(:sleep_cycle, :active, user: user)
      end

      context "fetching all followed user's sleep cycles log" do
        before do
          FactoryBot.create(:following, :approved, follower: current_user, followed: user)
        end

        it "returns sleep cycles log created by followed user" do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.size).to eq(2)
          end
        end
      end

      context "fetching someone's sleep cycles log that current user don't follow" do
        it "returns not found error response" do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:not_found)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end

      context "fetching someone's sleep cycles log that doesn't exists" do
        let(:user) { FactoryBot.build_stubbed(:user) }

        it "returns not found error response" do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:not_found)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end
    end

    context 'with unauthorized access' do
      it 'returns error response' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json_response.keys).to match_array(%w[message])
      end
    end
  end
end
