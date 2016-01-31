class RecipesController < ApplicationController
  before_action :check_user, except: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { 
        @recipes = []
        Recipe.all.find_each do |r|
          @recipes << {
            id: r.id,
            name: r.name,
            recipe_type_id: r.recipe_type_id,
            owner: r.user.name,
            is_current_user: r.user == current_user}
        end
        render :json => @recipes }
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    @product_generator = product_generator
    @product = Product.new
  end 

  def product_generator
    result = {recipeId: @recipe.id, ingredientTypes: [], ingredients: [], variants: []}

    @recipe.ingredient_types.each do |i|
      result[:ingredientTypes] <<  { id: i.id, name: i.name}
    end
 
    @recipe.ingredients_all_variants.each do |i|
      result[:ingredients] <<  { id: i.id, name: i.name, ingredient_type_id: i.type.id}
    end
    
    product = Product.new do |p|
      p.volume = 100
    end
    @recipe.variants.each do |v|
      product.variant = v
      product.quantities.compute_prices(current_user)
      result[:variants] << product.quantities.product_generator(current_user)
    end
    result
  end

  def new
    @recipe = Recipe.new
    init_form
    @recipe_type_select = true
    @variant_base_select = false
  end

  def edit
    init_form
    @recipe = Recipe.find(params[:id])
    @variants = @recipe.variants
    @recipe_type_select = false
    @variant_base_select = (@variants.length > 1)
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      set_ingredients
      redirect_to recipe_path(@recipe)
    else
      flash[:alert] = 'Impossible de créer la recette'
      render 'new'
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    #set_ingredients
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)
    else
      flash[:alert] = 'Impossible de modifier la recette'
      render 'edit'
    end
  end

  def set_ingredients
    if params.has_key?(:ingredients_ids)
      @recipe.variant_base.ingredients = Ingredient.find(params[:ingredients_ids])
    else
       @recipe.variant_base.ingredients.delete_all
    end
    @recipe.variant_base.update_proportions
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path
  end

  def delete_list
    @recipe = Recipe.find(params[:recipe_id])
    @ingredients = @recipe.ingredients
  end

  def duplicate_variant
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
      flash[:alert] = "Vous n'avez pas les autorisations nécessaires"
      redirect_to recipe_path(@recipe)
    end
  end

    def recipe_params
      p = [:name,:recipe_type_id, {:ingredients_ids => []}, :variant_name, :variant_base_id]
      p << :variant_id if :action == 'create'
      if current_user.admin? then
        p << :user_id
      end
      params.require(:recipe).permit(p)
    end

end
