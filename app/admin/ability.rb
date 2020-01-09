class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    if user.roles.include?('management')
      can :manage, :all
    elsif user.roles.include?('readwrite')
      can :manage, :all
      cannot :manage, UserPersonalData
    elsif user.roles.include?('read')
      can :read, :all
      cannot :read, UserPersonalData
    end
  end
end
