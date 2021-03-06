class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      cannot :read, User
      can :get_table, Ingredient
    end

    can :manage, User, :id => user.id

    if user.role.rank  <= 3 #Permissions for 'producteur'
      can :manage, Recipe, :user_id => user.id
      can :manage, [Variant, Product], :user_id => user.id#:recipe => {:user_id => user.id}
      can :create, [Variant, Product] #additional conditions in controller
      can :manage, Container, :user_id => user.id
      can :manage, Ingredient
      if user.role.rank == 3
        cannot :destroy, Ingredient, :validated => true
      end
    end
 
    if user.role.rank <= 2 #Permissions for 'gerant'
      can :manage, [IngredientType, RecipeType]
    end

    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
