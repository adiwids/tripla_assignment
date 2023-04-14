class SleepCyclesHistoryQuery
  attr_reader :owner, :collection

  def self.call(owner:, filters: {})
    new(owner).fetch(filters: filters)
  end

  def initialize(owner)
    @owner = owner
    @collection = SleepCycle.includes(:user).completed.latest
  end

  def fetch(filters: {})
    query = if filters[:include_followings]
      collection.distinct
                .joins(followed_users_including_owner_join_sql)
    else
      collection.where(sleep_cycles: { user_id: owner.id })
    end

    query
  end

  private

  def followed_users_including_owner_join_sql
    <<-SQL
      INNER JOIN (
        #{owner.follow_relations.approved.select(:follower_id, :followed_id).to_sql}
      ) AS followed_users
        ON followed_users.followed_id = sleep_cycles.user_id
          OR followed_users.follower_id = sleep_cycles.user_id
    SQL
  end
end
