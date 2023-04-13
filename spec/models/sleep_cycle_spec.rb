require 'rails_helper'

RSpec.describe SleepCycle, type: :model do
  let(:subject) { FactoryBot.build(:sleep_cycle) }

  context 'association' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:set_wake_up_time) }
  end

  context 'scopes' do
    before do
      @active_cycle = FactoryBot.create(:sleep_cycle, :active)
      @inactive_cycle = FactoryBot.create(:sleep_cycle, :inactive)
    end

    describe '.active' do
      let(:subject) { described_class.active }

      it { expect(described_class.respond_to?(:active)).to be_truthy }

      it 'returns only active sleep cycles' do
        ids = subject.pluck(:id)
        expect(ids).to include(@active_cycle.id)
        expect(ids).not_to include(@inactive_cycle.id)
      end
    end

    describe '.inactive' do
      let(:subject) { described_class.inactive }

      it { expect(described_class.respond_to?(:inactive)).to be_truthy }

      it 'returns only inactive sleep cycles' do
        ids = subject.pluck(:id)
        expect(ids).to include(@inactive_cycle.id)
        expect(ids).not_to include(@active_cycle.id)
      end
    end
  end
end
