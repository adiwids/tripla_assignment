require 'rails_helper'

RSpec.describe SleepClockInService, type: :service do
  describe '.call' do
    let(:subject) { described_class.call(user: user, set_wake_up_time: set_wake_up_time) }
    let(:user) { FactoryBot.create(:user) }
    let(:set_wake_up_time) { Time.zone.now + 6.hours }

    it 'returns service instance' do
      expect(subject).to be_an_instance_of(described_class)
    end

    context 'with valid user and wake up time' do
      it 'creates active sleep cycle for user' do
        expect(user.sleep_cycles.active).to be_empty
        expect { subject }.to change { user.sleep_cycles.active.count }.from(0).to(1)
        expect(subject.object).to be_persisted
        expect(subject.object.date).to eq(subject.object.set_wake_up_time.to_date)
      end

      context 'when another active sleep cycle exist' do
        before { FactoryBot.create(:sleep_cycle, :active, user: user) }

        it { expect { subject }.to raise_error(described_class::RunningCycleError) }
      end
    end

    context 'with not persisted user' do
      let(:user) { FactoryBot.build(:user) }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'without giving set wake up time' do
      let(:set_wake_up_time) { nil }

      it 'does not create sleep cycle record and has error' do
        expect { subject }.not_to change { user.sleep_cycles.count }
        expect(subject.object).not_to be_persisted
        expect(subject.object.errors.key?(:set_wake_up_time)).to be_truthy
        expect(subject.object.errors.full_messages.first).to match(/can't be blank/)
      end
    end

    context 'with different timezone with server' do
      let(:now_utc) do
        allow(Time).to receive(:now).and_return(Time.new.in_time_zone('UTC'))

        Time.now
      end
      let(:now_jakarta) do
        allow(Time).to receive(:now).and_return(Time.new.in_time_zone('Asia/Jakarta'))

        Time.now
      end
      let(:set_wake_up_time) { now_jakarta + 8.hours }

      it 'saves set wake up time in UTC' do
        expected_wake_up_time = now_utc + 8.hours
        travel_to now_jakarta do
          subject
          object = SleepCycle.last
          expect(object.set_wake_up_time.to_datetime.to_fs(:db)).to eq(expected_wake_up_time.to_datetime.to_fs(:db))
        end
      end
    end
  end
end
