require 'rails_helper'

RSpec.describe UnfollowUserService, type: :service do
  let(:user) { FactoryBot.create(:tom) }

  describe '.call' do
    context 'when already followed both approved or not' do
      let(:jerry) { FactoryBot.create(:jerry) }
      let(:bella) { FactoryBot.create(:bella) }

      before do
        @requested = FactoryBot.create(:following, :requested, follower: user, followed: jerry)
        @approved = FactoryBot.create(:following, :approved, follower: user, followed: bella)
      end

      it 'removes follow relations to target' do
        expect(user.follow_relations.count).to eq(2)
        expect { described_class.call(requester: user, target: jerry) }.to change { user.follow_relations.count }.from(2).to(1)
        expect { described_class.call(requester: user, target: bella) }.to change { user.follow_relations.count }.from(1).to(0)
      end
    end

    context 'when not followed yet' do
      let(:subject) { described_class.call(requester: user, target: target_user) }
      let(:target_user) { FactoryBot.create(:user) }

      it { expect { subject }.to raise_error(StandardError) }
    end

    context 'with not persisted requester' do
      let(:subject) { described_class.call(requester: user, target: target_user) }
      let(:user) { FactoryBot.build(:user) }
      let(:target_user) { FactoryBot.create(:user) }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with not persisted target' do
      let(:subject) { described_class.call(requester: user, target: target_user) }
      let(:user) { FactoryBot.create(:user) }
      let(:target_user) { FactoryBot.build(:user) }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with target same as requester' do
      let(:subject) { described_class.call(requester: user, target: target_user) }
      let(:user) { FactoryBot.build(:user) }
      let(:target_user) { user }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end
