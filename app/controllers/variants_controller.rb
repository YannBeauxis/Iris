class VariantsController < ApplicationController
  before_action :get_recipe
  before_action :check_user, except: [:index, :show, :edit, :update, :destroy]
  
  def index
    @variants = Variant.all
  end

  def show
    @variant = Variant.find(params[:id])
    @ingredients = @variant.ingredients
    @ingredient_types = @variant.ingredient_types
  end 

  def new
    @variant = Variant.new
    @form_action = 'create'
    @form_method = 'post'
  end

  def edit
    @variant = Variant.find(params[:id])
    @form_action = 'update'
    @form_method = 'patch'
  end

  def create

    @variant = Variant.new(variant_params)
    @variant.ingredients = @recipe.ingredients
    @recipe.variants << @variant

    if @recipe.save
      redirect_to edit_recipe_variant_path(@recipe,@variant)
    else
      render 'new'
      #render plain: 'Erreur'
    end
  end

  def update
    @variant = Variant.find(params[:id])

    if @variant.update(variant_params)
      @variant.update_proportions
      redirect_to edit_recipe_variant_path(@recipe,@variant)
    else
      render 'edit'
    end
  end

  def destroy
    @variant = Variant.find(params[:id])
    @variant.destroy
 
    redirect_to recipe_path(@recipe)
  end

  def duplicate
    @variant_origin = Variant.find(params[:variant_id])
    duplicate_params = {user_id: current_user}
    duplicate_params[:name] =  variant_params[:name] if variant_params.has_key?(:name)
    @variant = @variant_origin.duplicate(duplicate_params)
    redirect_to edit_recipe_variant_path(@recipe,@variant)
  end

  def change_ingredients
    @variant = Variant.find(params[:variant_id])
    @variant = @variant.change_ingredients(user_id: current_user,ingredients_ids: change_ingredients_params[:ingredients_ids])
    redirect_to recipe_path(@recipe)
  end

  def update_proportions
    @variant = Variant.find(params[:variant_id])


    update_proportions_params[:proportion_attributes].each do |up|
       p = Proportion.find(up[:id])
       p.value = up[:value]
       p.save
    end

    @variant.update_proportions

    redirect_to edit_recipe_variant_path(@recipe,@variant)
  end

  private

  def get_recipe
    @recipe_types = RecipeType.all
    @recipes = Recipe.all
    @recipe = Recipe.find(params[:recipe_id])
  end
  
  def check_user
    #if (current_user != @recipe.user) and !current_user.admin? then
    if cannot?(:update, @variant) then
      flash[:message] = "Vous n'avez pas les autorisations nécessaires"
      redirect_to recipe_path(@recipe)
    end
  end
  
  def variant_params
    params.require(:variant).permit(:name)
  end

  def change_ingredients_params
    params.require(:variant).permit(ingredients_ids: [])
  end

  def update_proportions_params
    params.require(:variant).permit(:id, proportion_attributes: [:id, :value])
  end

end
