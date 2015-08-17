class AdministrationController < ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check

    def users
      @users = User.all
    end
    
    def containers
      @containers = Container.all
    end

    def recipes
      @recipes = Recipe.all
    end

end