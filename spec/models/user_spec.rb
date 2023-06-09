require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { FactoryBot.build(:user) }

  context 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'association' do
    it { is_expected.to have_many(:sleep_cycles).dependent(:destroy) }
    # to follow relation
    it { is_expected.to have_many(:follow_relations).class_name('Following').with_foreign_key('follower_id').dependent(:destroy) }
    it { is_expected.to have_many(:accepted_following_requests).class_name('Following').with_foreign_key('follower_id').conditions(status: 'approved') }
    it { is_expected.to have_many(:followings).class_name('User').through(:accepted_following_requests).source(:followed) }
    # to be followed by relation
    it { is_expected.to have_many(:followed_relations).class_name('Following').with_foreign_key('followed_id').dependent(:destroy) }
    it { is_expected.to have_many(:accepted_being_followed_requests).class_name('Following').with_foreign_key('followed_id').conditions(status: 'approved') }
    it { is_expected.to have_many(:followers).class_name('User').through(:accepted_being_followed_requests).source(:follower) }
  end
end
