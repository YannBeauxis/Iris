class ContainersController < ApplicationController
  #load_and_authorize_resource

  before_action :get_list

  #def index
  #  @containers = Container.find_by ingredient_id: :ingredient_id
  #end

  #def show
  #  @container = Container.find(params[:id])
  #end 

  def new
    #@ingredient = Ingredient.find(params[:ingredient_id])
    @container = @ingredient.containers.new
  end

  def edit
    #@ingredient = Ingredient.find(params[:ingredient_id])
    @container = Container.find(params[:id])
  end

  def create
    #@ingredient = Ingredient.find(params[:ingredient_id])
    @container = @ingredient.containers.new(container_params)
    @container.user = current_user

    if @container.save
      redirect_to @ingredient
    else
      render 'new'
    end
  end

  def update
    #@ingredient = Ingredient.find(params[:ingredient_id])
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
    
    #redirect_to edit_ingredient_container_path(@ingredient,@container)
    redirect_to @ingredient
  end

  def destroy
    #@ingredient = Ingredient.find(params[:ingredient_id])
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
      p = [:ingredient, :volume_init, :volume_actual, :price]
      if current_user.admin? then
        p << :user_id
      end
      params.require(:container).permit(p)
    end
    
    def update_with_mass_params
      params.require(:container).permit(:id, :mass)
    end
end
