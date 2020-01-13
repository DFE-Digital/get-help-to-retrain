class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    if user.has_role?('management')
      can :manage, :all
    elsif user.has_role?('readwrite')
      can :manage, :all
      cannot :manage, UserPersonalData
    elsif user.has_role?('read')
      can :read, :all
      cannot :read, UserPersonalData
    end
  end
end
