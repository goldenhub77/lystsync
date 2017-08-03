class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.order("name DESC")
      else
        nil
      end
    end
  end

  def index?
    user.admin? || user == record
  end

  def show?
    # REFACTOR WHEN FRIENDS FEATURE COMPLETED
    #security deactivated until friend feature built
    true
  end

  def collaborations?
    user.admin? || user == record
  end

  def lists?
    user.admin? || user == record
  end
end
