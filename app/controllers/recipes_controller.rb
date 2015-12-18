class RecipesController < ApplicationController
  load_and_authorize_resource
  before_action :check_user, except: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index
    @columns = [{method: 'product_count' }]
    @columns_header = ['#produits']
    if params[:scope] == 'My' then
      @recipes = @recipes.where(user: current_user)
      @recipe_types = RecipeType.joins(:recipes)
                  .where('user_id = ' + current_user.id.to_s).uniq
    else
      @recipes = Recipe.all
      @recipe_types = RecipeType.all
      @columns << {name: 'Propriétaire', method: 'user_name' }
      @columns_header << 'Propriétaire'
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @variants = @recipe.variants
    @products = @recipe.products
    @ingredients = @recipe.ingredients
    @ingredient_types = @recipe.ingredient_types
    
    @product = @recipe.product_reference
    @product.quantities.compute_prices(current_user) if  !@product.nil?
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
    
      ingredient_order = ['ingredient_types.name_short','name asc']
  
      @ingredient_candidates = @recipe.ingredient_candidates.order(ingredient_order)
  
      render 'ingredient_candidates'
    
  end
 
  def add_ingredient

    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.find(params[:ingredient_id])

    @recipe.ingredients << @ingredient
    @recipe.save

    redirect_to recipe_path(@recipe)

  end

  def delete_list
    @recipe = Recipe.find(params[:recipe_id])
    @ingredients = @recipe.ingredients
  end

  def delete_ingredient

    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.find(params[:ingredient_id])
    @recipe.ingredients.delete(@ingredient)
    @recipe.save

    redirect_to recipe_path(@recipe)

  end

  def duplicate_variant
    #p params
    #render plain: params
    variant_origin = Variant.find(params[:variant_id])
    @recipe = Recipe.find(params[:recipe_id])


    v = @recipe.duplicate_variant(variant_origin, params[:variant_name])
    
    redirect_to recipe_variant_path(@recipe,v)
    
  end

  private

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
      p = [:name,:recipe_type_id, :ingredient_id, :variant_id, :variant_name]
      if current_user.admin? then
        p << :user_id
      end
      params.require(:recipe).permit(p)
    end

end
