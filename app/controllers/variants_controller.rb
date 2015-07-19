class VariantsController < ApplicationController
  before_action :get_recipe

  def index
    @variants = Variant.all
  end

  def show
    @variant = Variant.find(params[:id])
    #@variant.clean_proportion
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
    @recipe.variants << @variant

    if @recipe.save
      #@variant.update_proportions
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

  def destroyd
    @variant = Variant.find(:id)
    @variant.destroy
 
    redirect_to recipe_variants_path(@recipe)
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

    def variant_params
      params.require(:variant).permit(:name)
    end

    def update_proportions_params
      params.require(:variant).permit(:id, proportion_attributes: [:id, :value])
    end

end
