require 'rails_helper'

RSpec.describe SleepCycle, type: :model do
  let(:subject) { FactoryBot.build(:sleep_cycle) }

  context 'association' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:set_wake_up_time) }
  end
end
