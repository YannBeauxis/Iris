class RecipeTypesController < ApplicationController
  before_action :get_list

  def index
  end

  def show
    @recipe_type = RecipeType.find(params[:id])
    @recipes = @recipe_type.recipes.all
  end 

  def new
    @recipe_type = RecipeType.new
    init_form
  end

  def edit
    init_form
    @recipe_type = RecipeType.find(params[:id])
  end

  def create
    @recipe_type = RecipeType.new(recipe_type_params)

    if @recipe_type.save
      redirect_to @recipe_type
    else
      render 'new'
    end
  end

  def update
     @recipe_type = RecipeType.find(params[:id])

    if @recipe_type.update(recipe_type_params)
      redirect_to @recipe_type
    else
      render 'edit'
    end
  end

  def destroy
    @recipe_type = RecipeType.find(params[:id])
    @recipe_type.destroy
 
    redirect_to recipe_types_path
  end

  private

    def get_list
      @recipe_types = RecipeType.all
    end

    def init_form
      @ingredient_types = IngredientType.order(:name)
    end

    def recipe_type_params
      params.require(:recipe_type).permit(:name, {:ingredient_type_ids => []})
    end

end
