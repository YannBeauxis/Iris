class VariantsController < ApplicationController
  before_action :get_recipe
  before_action :check_user, except: [:index, :show, :new, :create, :edit, :update, :destroy]
  
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

    @variant = @recipe.variant_base.duplicate(user_id: current_user, name: variant_params[:name])
    #@variant.user = current_user
    #@variant.ingredients = @recipe.ingredients
    @variant.description = variant_params[:description]
    @recipe.variants << @variant

    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      flash[:alert] = "Erreur lors de la création de la variante"
      render 'new'
    end
  end

  def update
    @variant = Variant.find(params[:id])

    if @variant.update(variant_params)
      @variant.update_proportions
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end

  def destroy
    @variant = Variant.find(params[:id])
    if @variant.base?
      flash[:alert]  = "Une variante de base ne peut être supprimée"
      redirect_to recipe_path(@recipe)
    else
      @variant.destroy
      redirect_to recipe_path(@recipe)
    end
  end

  def duplicate
    duplicate_params = {user_id: current_user}
    duplicate_params[:name] =  variant_params[:name] if variant_params.has_key?(:name)
    @variant = @variant.duplicate(duplicate_params)
    redirect_to edit_recipe_variant_path(@recipe,@variant)
  end

  def change_ingredients_edit
    render 'change_ingredients'
  end

  def change_ingredients
    @variant = @variant.change_ingredients(
                   user_id: current_user,
                   ingredients_ids: params[:ingredients_ids]
                 )
    redirect_to recipe_path(@recipe)
  end

  def change_proportions_edit
    render 'change_proportions'
  end

  def change_proportions
    @variant = @variant.change_proportions(user_id: current_user,proportions: params[:proportions])
    redirect_to recipe_path(@recipe)
  end

  private

  def get_recipe
    @recipe_types = RecipeType.all
    @recipes = Recipe.all
    @recipe = Recipe.find(params[:recipe_id])
  end
  
  def check_user
    #if (current_user != @recipe.user) and !current_user.admin? then
    @variant = Variant.find(params[:variant_id])
    if cannot?(:update, @variant) then
      flash[:alert] = "Vous n'avez pas les autorisations nécessaires"
      redirect_to recipe_path(@recipe)
    end
  end
  
  def variant_params
    p = [:name, :description]
    p << [:archived, :next_version_id] if current_user.admin? 
    params.require(:variant).permit(p)
  end

  def change_ingredients_params
    params.require(:variant).permit(:variant_id, ingredients_ids: [])
  end

  def change_proportions_params
    params.require(:variant).permit(:id, proportions: [:id, :value])
  end

  def update_proportions_params
    params.require(:variant).permit(:id, proportion_attributes: [:id, :value])
  end

end
