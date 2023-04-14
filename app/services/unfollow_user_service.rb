class UnfollowUserService
  attr_reader :requester, :target, :object

  def self.call(requester:, target:)
    new(requester, target).unfollow!
  end

  def initialize(requester, target)
    raise ArgumentError.new unless requester&.persisted? && target&.persisted?
    raise ArgumentError.new if requester&.id == target&.id

    @requester = requester
    @target = target
    @object = requester.follow_relations.find_by(followed_id: target.id)
  end

  def unfollow!
    raise StandardError.new unless object

    object.destroy

    self
  end
end
