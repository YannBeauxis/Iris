class RecipesController < ApplicationController
  load_and_authorize_resource
  before_action :get_list
  before_action :check_user, except: [:index, :show, :new, :create, :edit, :update, :destroy]

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
    @recipe.user = current_user

    if @recipe.save
      #redirect_to recipes_path
      redirect_to recipe_path(@recipe)
    else
      flash[:message] = 'Impossible de créer la recette'
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

    if current_user != @recipe.user then
      
      flash[:message] = "Vous n'avez pas les autorisations nécessaires"
      redirect_to recipe_path(@recipe)
    
    else

      ingredient_order = ['ingredient_types.name_short','name asc']
  
      @ingredient_candidates = @recipe.ingredient_candidates.order(ingredient_order)
  
      render 'ingredient_candidates'
      #render plain: @ingredient_candidates.inspect
      
    end
    
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

  def duplicate_variant
    variant_origin = Variant.find(params[:variant_id])
    @recipe = Recipe.find(params[:recipe_id])

    v = @recipe.duplicate_variant(variant_origin, params[:variant_name])
    
    redirect_to recipe_variant_path(@recipe,v)
    
  end

  private

   def get_list
     @recipe_types = RecipeType.all
     @recipes = Recipe.all
   end

    def init_form
      @recipe_types = RecipeType.order(:name)
    end

  def check_user
    @recipe = Recipe.find(params[:recipe_id])
    if current_user != @recipe.user and !current_user.admin? then
      flash[:message] = "Vous n'avez pas les autorisations nécessaires"
      redirect_to recipe_path(@recipe)
    end
  end

    def recipe_params
      params.require(:recipe).permit(:name,:recipe_type_id, :ingredient_id, :variant_id, :variant_name)
    end

   #def duplicate_variant_params
   #   params.require(:recipe).permit(:recipe_id, :variant_id, :variant_name)
   #end

end
