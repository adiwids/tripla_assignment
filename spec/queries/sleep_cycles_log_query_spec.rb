require 'rails_helper'

RSpec.describe SleepCyclesLogQuery do
  before(:all) do
    @owner = FactoryBot.create(:user)
    @tom = FactoryBot.create(:tom)
    @jerry = FactoryBot.create(:jerry)
    @bella = FactoryBot.create(:bella)
    # owner is following jerry
    FactoryBot.create(:following, :approved, follower: @owner, followed: @jerry)
    # owner has requested to follow on bella, but not approved yet
    FactoryBot.create(:following, :requested, follower: @owner, followed: @bella)

    # all users's sleep cycles
    travel_to Time.zone.now - 2.days do
      @owner_completed1 = FactoryBot.create(:sleep_cycle, :waken_up, user: @owner)
      @tom_completed1 = FactoryBot.create(:sleep_cycle, :waken_up, user: @tom)
    end

    travel_to Time.zone.now - 1.days do
      @owner_completed2 = FactoryBot.create(:sleep_cycle, :waken_up, user: @owner)
      @jerry_completed1 = FactoryBot.create(:sleep_cycle, :waken_up, user: @jerry)
      @bella_completed1 = FactoryBot.create(:sleep_cycle, :waken_up, user: @bella)
    end

    @owner_ongoing = FactoryBot.create(:sleep_cycle, :active, user: @owner)
    @jerry_ongoing = FactoryBot.create(:sleep_cycle, :active, user: @jerry)
    @bella_ongoing = FactoryBot.create(:sleep_cycle, :waken_up, user: @bella)
    @tom_ongoing = FactoryBot.create(:sleep_cycle, :waken_up, user: @tom)
  end

  describe '.call' do
    let(:subject) { described_class.call(owner: owner, filters: filters) }
    let(:owner) { @owner }
    let(:filters) { {} }

    context 'when fetching only owned sleep cycles log' do
      it "returns current owner's completed sleep cycles log ordered descendingly by creation time" do
        ordered_ids = subject.map(&:id)
        expected_ids = [
          @owner_ongoing.id,
          @owner_completed2.id,
          @owner_completed1.id
        ]
        expect(ordered_ids).to match_array(expected_ids)
      end
    end

    context "when fetching owned including it's followed users's log" do
      let(:filters) { { include_followings: true } }

      it "returns current owner's sleep cycles and followed user's log ordered descendingly by creation time" do
        ordered_ids = subject.map(&:id)
        expected_ids = [
          @jerry_ongoing.id,
          @owner_ongoing.id,
          @jerry_completed1.id,
          @owner_completed2.id,
          @owner_completed1.id
        ]
        expect(ordered_ids).to match_array(expected_ids)
      end
    end

    context "when fetching owned sleep cycles including followed users's history" do
      let(:filters) { { include_followings: true, only_completed: true } }

      it "returns current owner's sleep cycles and followed user's history ordered descendingly by creation time" do
        ordered_ids = subject.map(&:id)
        expected_ids = [
          @jerry_completed1.id,
          @owner_completed2.id,
          @owner_completed1.id
        ]
        expect(ordered_ids).to match_array(expected_ids)
      end
    end
  end
end
