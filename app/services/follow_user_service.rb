class FollowUserService
  class SelfFollowError < HttpError::BadRequestError; end

  attr_reader :requester, :target, :object, :new_relation

  def self.call(requester:, target:)
    new(requester, target).follow!
  end

  def initialize(requester, target)
    raise ArgumentError.new unless requester&.persisted? && target&.persisted?

    @requester = requester
    @target = target
    @new_relation = false
  end

  def follow!
    raise SelfFollowError.new if requester.id == target.id

    @object = check_or_build_relation
    if object.new_record?
      @new_relation = true
      object.approved! if @object.save && auto_approved_enabled?
    end

    self
  end

  def new_relation?
    !!new_relation
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
