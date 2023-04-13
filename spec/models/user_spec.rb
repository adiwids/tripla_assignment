require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { FactoryBot.build(:user) }

  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'association' do
    it { is_expected.to have_many(:sleep_cycles).dependent(:destroy) }
  end
end
