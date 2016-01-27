class IngredientsController < ApplicationController
  #respond_to :html, :xml, :json
  before_action :is_used_by_other, only: [:edit, :update, :destroy]
  
  def index
    if params.has_key?(:recipe_type_id)
      @ingredients_scope = Ingredient
        .joins(type: :recipe_types)
        .where('ingredient_types_recipe_types.recipe_type_id = ?', params[:recipe_type_id])
    else
      @ingredients_scope = Ingredient.all
    end

    if params.has_key?(:recipe_id)
      @recipe = Recipe.find(params[:recipe_id])
    end

    respond_to do |format|
      format.html
      format.json { 
        @ingredients = []
        @ingredients_scope.find_each do |i|
          if params.has_key?(:recipe_id)
            selected = !@recipe.ingredients.find_by_id(i.id).nil?
          else
            selected = false
          end
          @ingredients << {
            id: i.id,
            name: i.name,
            ingredient_type_id: i.ingredient_type_id,
            stock: i.quantity_in_stock(current_user),
            selected: selected}
        end
        render :json => @ingredients }
    end
  end

  def show
    begin
      @ingredient = Ingredient.find(params[:id])
    rescue #ActiveRecord::RecordNotFound  
      redirect_to ingredients_path
      return
    end
    w = Warehouse.new('ingredient_for_user', {user: current_user, ingredient: @ingredient})
    @containers = w.list
  end 

  def new
    @ingredient = Ingredient.new
    init_form
  end

  def edit
    init_form
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

    def init_form
      @ingredient_types = IngredientType.order(:name)
    end

    def is_used_by_other
      @ingredient = Ingredient.find(params[:id])
      if @ingredient.used_by_other_users?(current_user) and (current_user.role.rank  > 2) then
        redirect_to :back, 
          :flash => { :error => "Vous ne pouvez modifier cet ingrédient car il est utilisé par d'autres utilisateurs" }
      end
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :ingredient_type_id, :density, :scope, :recipe_type_id)
    end


end
