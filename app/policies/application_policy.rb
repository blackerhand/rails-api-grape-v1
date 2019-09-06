class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def login_required!
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    true
  end

  def owner_required
    login_required! && user.id == record.try(:user_id)
  end

  def enabled_required(record_obj = record)
    raise ActiveRecord::RecordNotFound, "Couldn't find #{record_obj.class} with 'id'=#{record_obj.id}" if record_obj.try(:disabled?)

    true
  end
end
