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
      @latest_created = FactoryBot.create(:sleep_cycle, :active)
      travel_to Time.now - 1.day do
        @previous_created = FactoryBot.create(:sleep_cycle, :inactive)
      end
    end

    describe '.active' do
      let(:subject) { described_class.active }

      it { expect(described_class.respond_to?(:active)).to be_truthy }

      it 'returns only active sleep cycles' do
        ids = subject.pluck(:id)
        expect(ids).to include(@latest_created.id)
        expect(ids).not_to include(@previous_created.id)
      end
    end

    describe '.inactive' do
      let(:subject) { described_class.inactive }

      it { expect(described_class.respond_to?(:inactive)).to be_truthy }

      it 'returns only inactive sleep cycles' do
        ids = subject.pluck(:id)
        expect(ids).to include(@previous_created.id)
        expect(ids).not_to include(@latest_created.id)
      end
    end

    describe '.latest' do
      let(:subject) { described_class.latest }

      it { expect(described_class.respond_to?(:latest)).to be_truthy }

      it 'returns sleep cycle records order from the latest created' do
        expect(subject.map(&:id)).to match_array([@latest_created.id, @previous_created.id])
      end
    end

    describe '.completed' do
      let(:subject) { described_class.completed }

      before do
        @empty_inactive = FactoryBot.create(:sleep_cycle, :empty_inactive)
      end

      it 'returns only inactive sleep cycles history with actual wake up time' do
        ids = subject.map(&:id)
        expect(ids.size).to eq(1)
        expect(ids).to include(@previous_created.id)
        expect(ids).not_to include(@empty_inactive.id)
      end
    end
  end
end
