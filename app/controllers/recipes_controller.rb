class RecipesController < ApplicationController

  before_action :get_list

  def index
  end

  def show
    @recipe = Recipe.find(params[:id])
  end 

  def new
    @recipe = Recipe.new
    init_form
  end

  def edit
    init_form
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      #redirect_to recipes_path
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end

  def update
     @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
 
    redirect_to recipes_path
  end

  def ingredient_candidates

    @recipe = Recipe.find(params[:recipe_id])

    ingredient_order = ['ingredient_types.name_short','name asc']

    @ingredient_candidates = @recipe.ingredient_candidates.order(ingredient_order)

    render 'ingredient_candidates'
    #render plain: @ingredient_candidates.inspect
  end
 
  def add_ingredient

    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.find(params[:ingredient_id])

    @recipe.ingredients << @ingredient
    @recipe.save

    redirect_to recipe_path(@recipe)

  end


  def delete_ingredient

    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.find(params[:ingredient_id])
    @recipe.ingredients.delete(@ingredient)
    @recipe.save

    redirect_to recipe_path(@recipe)

  end


  private

   def get_list
     @recipe_types = RecipeType.all
     @recipes = Recipe.all
   end

    def init_form
      @recipe_types = RecipeType.order(:name)
    end

    def recipe_params
      params.require(:recipe).permit(:name,:recipe_type_id)
    end
end
