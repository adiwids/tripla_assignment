require 'rails_helper'

RSpec.describe AuthenticateTokenService, type: :service do
  describe '.call' do
    let(:subject) { described_class.call(token: token) }
    let(:user) { FactoryBot.create(:user) }
    let(:token) { generate_token(user) }

    context 'with valid encrypted token' do
      it 'returns authenticated user' do
        expect(subject).to eql(user)
      end
    end

    context 'with unrecognized user token' do
      let(:user) { FactoryBot.build_stubbed(:user) }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with invalid token' do
      let(:token) { Digest::SHA256.hexdigest({ 'uid' => user.id, 'nm' => user.name }.to_json) }

      it { expect { subject}.to raise_error(ArgumentError) }
    end

    context 'with empty token' do
      let(:token) { '' }

      it { expect { subject}.to raise_error(ArgumentError) }
    end
  end
end
