class ContainersController < ApplicationController
  #load_and_authorize_resource

  before_action :get_list

  def new
    @container = @ingredient.containers.new
  end

  def edit
    @container = Container.find(params[:id])
  end

  def create
    @container = @ingredient.containers.new(container_params)
    @container.user = current_user

    if @container.save
      redirect_to @ingredient
    else
      render 'new'
    end
  end

  def update
    @container = Container.find(params[:id])
 
    if @container.update(container_params)
      redirect_to @ingredient
    else
      render 'edit'
    end
  end

  def update_with_mass
    @container = Container.find(params[:container_id])
    mass = update_with_mass_params[:mass].to_f
    @container.update_with_mass(mass)
    
    redirect_to @ingredient
  end

  def destroy
    @container = Container.find(params[:id])
    @container.destroy
 
    redirect_to @ingredient
  end

  private

    def get_list
      @ingredient = Ingredient.find(params[:ingredient_id])
      @ingredients = Ingredient.all
      @ingredient_types = IngredientType.all.sort_by {|it| -1*it.ingredients.count }
    end

    def container_params
      p = [:ingredient, :quantity_init, :quantity_actual, :price]
      if current_user.admin? then
        p << :user_id
      end
      params.require(:container).permit(p)
    end
    
    def update_with_mass_params
      params.require(:container).permit(:id, :mass)
    end
end
