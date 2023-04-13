require 'rails_helper'

RSpec.describe Following, type: :model do
  let(:subject) { FactoryBot.build(:following, follower: follower, followed: followed) }
  let(:follower) { FactoryBot.create(:tom) }
  let(:followed) { FactoryBot.create(:jerry) }

  context 'association' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:followed).class_name('User') }
  end

  context 'scopes' do
    before do
      @approved = FactoryBot.create(:following, follower: follower)
      @requested = FactoryBot.create(:following, :requested, follower: follower)
    end

    describe '.requested' do
      let(:subject) { described_class.requested }

      it { expect(described_class.respond_to?(:requested)).to be_truthy }

      it 'returns only unapproved following request' do
        ids = subject.map(&:id)
        expect(ids).to include(@requested.id)
        expect(ids).not_to include(@approved.id)
      end
    end

    describe '.approved' do
      let(:subject) { described_class.approved }

      it { expect(described_class.respond_to?(:approved)).to be_truthy }

      it 'returns only approved following request' do
        ids = subject.map(&:id)
        expect(ids).to include(@approved.id)
        expect(ids).not_to include(@requested.id)
      end
    end
  end
end
