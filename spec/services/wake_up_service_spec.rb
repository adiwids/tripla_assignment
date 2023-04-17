require 'rails_helper'

RSpec.describe WakeUpService, type: :service do
  describe '.call' do
    let(:subject) { described_class.call(user: user, actual_wake_up_time: actual_wake_up_time) }
    let(:object) { FactoryBot.create(:sleep_cycle, :active) }
    let(:user) { object.user }
    let(:actual_wake_up_time) { Time.zone.now + 6.hours }

    context 'when active sleep cycle exist' do
      before do
        allow_any_instance_of(User).to receive_message_chain(:sleep_cycles, :active, :latest, :first).and_return(object)
      end

      context 'with valid actual wake up time' do
        it 'updates actual wake up time' do
          subject
          object.reload
          expect(object.actual_wake_up_time.to_datetime.to_fs(:db)).to eq(actual_wake_up_time.to_datetime.to_fs(:db))
        end

        it 'calculates sleep duration in miliseconds' do
          expected_duration = (actual_wake_up_time - object.created_at).to_i
          expect { subject }.to change { object.duration_seconds }.from(0).to(expected_duration)
        end

        it 'deactivates cycle' do
          expect(object).to be_active
          subject
          object.reload
          expect(object).to be_inactive
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
          let(:actual_wake_up_time) { now_jakarta + 8.hours }

          it 'saves set wake up time in UTC' do
            expected_wake_up_time = now_utc + 8.hours
            travel_to now_jakarta do
              subject
              object.reload
              expect(object.actual_wake_up_time.to_datetime.to_fs(:db)).to eq(expected_wake_up_time.to_datetime.to_fs(:db))
            end
          end
        end
      end

      context 'with wake up time less than cycle date' do
        let(:actual_wake_up_time) { Time.zone.yesterday.beginning_of_day + 1.hours }

        it 'invalidates actual wake up time' do
          subject
          expect(object.errors.key?(:actual_wake_up_time)).to be_truthy
          expect(object.errors.full_messages.first).to match(/must be equal to or advance from date/)
        end
      end

      context 'without actual wake up time' do
        let(:actual_wake_up_time) { nil }

        it { expect{ subject }.to raise_error(ArgumentError) }
      end
    end
  end
end
