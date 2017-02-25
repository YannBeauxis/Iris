class AdministrationController < ApplicationController
  before_action {@active_tab = 'admin'}
  skip_load_and_authorize_resource
  skip_authorization_check
  before_filter :custom_check
  
  def custom_check
    if user_signed_in?
      if !current_user.admin?
        redirect_to root_path, :alert => 'Vous devez-être administrateur pour accéder à cette page'
      end
    else
      authenticate_user!
    end
    
  end

    def users
      @users = User.all
    end

    def ingredients
      @ingredients = Ingredient.all
    end
    
    def containers
      @containers = Container.all
    end

    def recipes
      @recipes = Recipe.all
    end

    def variants
      @variants = Variant.all
    end

    def products
      @products = Product.all
    end

end