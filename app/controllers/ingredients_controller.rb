class IngredientsController < ApplicationController
  #load_and_authorize_resource  
  #before_action :get_list
  
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
    @containers = @ingredient.containers.where(user: current_user)
  end 

  def new
    @ingredient = Ingredient.new
  end

  def edit
    @ingredient = Ingredient.find(params[:id])
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
    @ingredient = Ingredient.find(params[:id])
 
    if @ingredient.update(ingredient_params)
      redirect_to @ingredient
    else
      render 'edit'
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
 
    redirect_to ingredients_path
  end

  private

    def get_list
      #@ingredients = Ingredient.all.sort_by {|i| [i.type,i.name] }
      @ingredients = Ingredient.all
      @ingredient_types = IngredientType.all.sort_by {|it| -1*it.ingredients.count }
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :ingredient_type_id, :density, :scope)
    end


end
