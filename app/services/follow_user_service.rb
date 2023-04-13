class FollowUserService
  attr_reader :requester, :target, :object

  def self.call(requester:, target:)
    new(requester, target).follow!
  end

  def initialize(requester, target)
    raise ArgumentError.new unless requester&.persisted? && target&.persisted?

    @requester = requester
    @target = target
  end

  def follow!
    raise ArgumentError.new if requester.id == target.id

    @object = check_or_build_relation
    if object.new_record?
      object.approved! if @object.save && auto_approved_enabled?
    end

    self
  end

  private

  def check_or_build_relation
    requester.follow_relations.where(followed_id: target.id).first_or_initialize
  end

  # TODO: change or remove if following approval rules defined
  def auto_approved_enabled?
    true
  end
end
