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
      travel_to Time.zone.now - 10.days do
        FactoryBot.create(:sleep_cycle, :waken_up, user: current_user)
      end
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
            expect(data.size).to eq(4)
            expect(data.first.keys).to match_array(%w[id type attributes relationships])
            expect(data.first['type']).to eq('sleep_cycle')
            expect(data.first['attributes'].keys).to match_array(%w[set_wake_up_time actual_wake_up_time duration_seconds status created_at])
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
            expect(data.size).to eq(3)
          end
        end
      end

      context "fetching current user and it's followed users's sleep cycles history ranked by duration since past week" do
        let(:subject) do
          get "/api/user/sleep_cycles",
              params: { only_completed: true, include_followings: true, order_by: 'duration desc', since: (Time.zone.now - 7.days).iso8601 },
              headers: { 'Accept' => 'application/json', 'Authorization' => "Bearer #{token}" }
        end

        it "returns current user and followed user's sleep cycles completed log" do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.size).to eq(3)
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

  describe "POST /api/user/sleep_cycles" do
    let(:subject) do
      post "/api/user/sleep_cycles",
           params: request_params,
           headers: { 'Accept' => 'application/json',
                      'Content-Type' => 'application/json',
                      'Authorization' => "Bearer #{token}" }
    end
    let(:request_params) do
      {
        sleep_cycle: {
          set_wake_up_time: set_wake_up_time
        }
      }.to_json
    end
    let(:now_jakarta) do
      allow(Time).to receive(:now).and_return(Time.new.in_time_zone('Asia/Jakarta'))

      Time.now
    end
    let(:set_wake_up_time) { (now_jakarta + 8.hours).iso8601 }

    context 'with authenticated access' do
      context 'no active cycle exists' do
        it 'returns success and created sleep cycle data' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.keys).to match_array(%w[id type attributes relationships])
            expect(data['type']).to eq('sleep_cycle')
            expect(data['attributes'].keys).to match_array(%w[set_wake_up_time actual_wake_up_time duration_seconds status created_at])
            expect(data['relationships'].keys).to include('user')
          end
        end
      end

      context 'active cycle exists' do
        before { FactoryBot.create(:sleep_cycle, :active, user: current_user) }

        it 'returns forbidden error message' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:forbidden)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end

      context 'without set wake up time parameter' do
        let(:set_wake_up_time) { nil }

        it 'returns unprocessable entity error response' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end

      context 'with empty parameter' do
        let(:request_params) { {}.to_json }

        it 'returns bad request error response' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:bad_request)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end

      context 'with different date time format' do
        let(:set_wake_up_time) { (now_jakarta + 8.hours).rfc3339 }

        it 'returns success response and save wake up time in UTC with ISO8601 format' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data['attributes']['set_wake_up_time']).to eq(DateTime.parse(set_wake_up_time).in_time_zone('UTC').iso8601(3))
          end
        end
      end

      context 'with non-standard date time format' do
        let(:set_wake_up_time) { (now_jakarta + 8.hours).strftime('%F %T') }

        it 'returns success response and save wake up time in UTC with ISO8601 format' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data['attributes']['set_wake_up_time']).to eq(DateTime.parse(set_wake_up_time).in_time_zone('UTC').iso8601(3))
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

  describe "PUT /api/user/sleep_cycles" do
    let(:subject) do
      put "/api/user/sleep_cycles",
          params: request_params,
          headers: { 'Accept' => 'application/json',
                     'Content-Type' => 'application/json',
                     'Authorization' => "Bearer #{token}" }
    end
    let(:request_params) do
      {
        sleep_cycle: {
          actual_wake_up_time: actual_wake_up_time
        }
      }.to_json
    end
    let(:now_jakarta) do
      allow(Time).to receive(:now).and_return(Time.new.in_time_zone('Asia/Jakarta'))

      Time.now
    end
    let(:actual_wake_up_time) { (now_jakarta + 8.hours).iso8601 }

    context 'with authenticated access' do
      context 'active cycle exists' do
        before { FactoryBot.create(:sleep_cycle, :active, user: current_user) }

        it 'returns success response and completed cycle data' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:ok)
            data = json_response['data']
            expect(data.keys).to match_array(%w[id type attributes relationships])
            expect(data['type']).to eq('sleep_cycle')
            expect(data['attributes'].keys).to match_array(%w[set_wake_up_time actual_wake_up_time duration_seconds status created_at])
            expect(data['relationships'].keys).to include('user')
            expect(data['attributes']['actual_wake_up_time']).to eq(DateTime.parse(actual_wake_up_time).in_time_zone('UTC').iso8601(3))
            expect(data['attributes']['duration_seconds']).not_to be_zero
          end
        end
      end

      context 'no active cycle exists' do
        before do
          expect(current_user.sleep_cycles.active).to be_empty
        end

        it 'returns not found error message' do
          stub_authenticated_token(token, current_user) do
            subject
            expect(response).to have_http_status(:not_found)
            expect(json_response.keys).to match_array(%w[message])
          end
        end
      end
    end

    context 'with invalid wake up time parameter' do
      let(:actual_wake_up_time) { Time.zone.yesterday.iso8601 }

      before { FactoryBot.create(:sleep_cycle, :active, user: current_user) }

      it 'returns unprocessable entity error response' do
        stub_authenticated_token(token, current_user) do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response.keys).to match_array(%w[message])
        end
      end
    end

    context 'with empty parameter' do
      let(:request_params) { {}.to_json }

      before { FactoryBot.create(:sleep_cycle, :active, user: current_user) }

      it 'returns bad request error response' do
        stub_authenticated_token(token, current_user) do
          subject
          expect(response).to have_http_status(:bad_request)
          expect(json_response.keys).to match_array(%w[message])
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
