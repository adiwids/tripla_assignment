require 'rails_helper'

RSpec.describe FollowUserService, type: :service do
  describe '.call' do
    let(:subject) { described_class.call(requester: user, target: target_user) }
    let(:user) { FactoryBot.create(:tom) }
    let(:target_user) { FactoryBot.create(:jerry) }

    context 'with different target user' do
      context 'and not following' do
        # TODO: change default relation's status if auto-approved disabled
        it 'creates approved following relation to target user' do
          expect(user.follow_relations.approved).to be_empty
          expect { subject }.to change { user.follow_relations.approved.count }.from(0).to(1)
          expect(subject.object).to be_persisted
          expect(subject.object.followed_id).to eq(target_user.id)
          expect(user.followings.map(&:id)).to include(target_user.id)
          expect(target_user.followers.map(&:id)).to include(user.id)
        end
      end

      context 'and already followed' do
        before do
          @existing = FactoryBot.create(:following, follower: user, followed: target_user)
        end

        it 'does not add following relation with same target' do
          expect { subject }.not_to change { user.follow_relations.approved.count }
          expect(subject.object.id).to eq(@existing.id)
        end
      end
    end

    context 'with target is the same as requester' do
      let(:target_user) { user }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with not persisted requester' do
      let(:user) { FactoryBot.build(:tom) }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'with not persisted target user' do
      let(:target_user) { FactoryBot.build(:jerry) }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end
