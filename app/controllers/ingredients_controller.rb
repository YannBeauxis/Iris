class IngredientsController < ApplicationController
  #load_and_authorize_resource  
  before_action :is_used_by_other, only: [:edit, :update, :destroy]
  
  def index
    if params[:scope] == 'My' then
      @ingredients = Ingredient.joins(:containers)
                        .where('user_id = ' + current_user.id.to_s).uniq
      @ingredient_types = IngredientType.joins(ingredients: :containers)
                        .where('user_id = ' + current_user.id.to_s).uniq
    else
      @ingredients = Ingredient.all
      @ingredient_types = IngredientType.all
    end
  end

  def show
    @ingredient = Ingredient.find(params[:id])
    w = Warehouse.new('ingredient_for_user', {user: current_user, ingredient: @ingredient})
    @containers = w.list
  end 

  def new
    @ingredient = Ingredient.new
  end

  def edit

  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to @ingredient
    else
      render 'new'
    end
  end

  def update
 
    if @ingredient.update(ingredient_params)
      redirect_to @ingredient
    else
      render 'edit'
    end
  end

  def destroy
    #@ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
 
    redirect_to ingredients_path
  end

  private

    def is_used_by_other
      @ingredient = Ingredient.find(params[:id])
      if (@ingredient.other_users_count(current_user) > 0) and (current_user.role.rank  > 2) then
        redirect_to :back, 
          :flash => { :error => "Vous ne pouvez modifier cet ingrédient car il est utilisé par d'autres utilisateurs" }
      end
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :ingredient_type_id, :density, :scope)
    end


end
