class SleepCyclesLogQuery
  attr_reader :owner, :collection

  def self.call(owner:, filters: {})
    new(owner).fetch(filters: filters)
  end

  def initialize(owner)
    @owner = owner
    @collection = SleepCycle.includes(:user).latest
  end

  def fetch(filters: {})
    query = filters[:only_completed] ? collection.completed : collection
    query = query.reorder(order_by(filters)) if filters[:order_by]

    query = if filters[:include_followings]
      query.distinct.joins(followed_users_including_owner_join_sql)
                    .where("sleep_cycles.user_id = :user_id OR followed_users.follower_id = :user_id", user_id: owner.id)
    else
      query.where(sleep_cycles: { user_id: owner.id })
    end

    query = query.where('sleep_cycles.created_at >= ?', filters[:since]) if filters[:since]

    query
  end

  private

  def followed_users_including_owner_join_sql
    <<-SQL
      LEFT OUTER JOIN (
        #{Following.approved.select(:follower_id, :followed_id).to_sql}
      ) AS followed_users ON followed_users.followed_id = sleep_cycles.user_id
    SQL
  end

  def order_by(filters)
    column, direction = filters[:order_by].to_s.split(/\s/, 2)
    case column
    when 'duration'
      "sleep_cycles.duration_seconds #{direction}"
    else
      'sleep_cycles.id asc'
    end
  end
end
