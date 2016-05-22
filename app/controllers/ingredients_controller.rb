class IngredientsController < ApplicationController
  #respond_to :html, :xml, :json
  before_action :select_ingredient, only: [:edit, :update, :destroy]
  
  def index
    if params.has_key?(:recipe_type_id)
      @ingredients_scope = Ingredient
        .joins(type: :recipe_types)
        .where('ingredient_types_recipe_types.recipe_type_id = ?', params[:recipe_type_id])
    else
      @ingredients_scope = Ingredient.user_enable(current_user)
    end

    if params.has_key?(:variant_id)
      @variant = Variant.find(params[:variant_id])
    end

    respond_to do |format|
      format.html
      format.json { 
        @ingredients = []
        @ingredients_scope.find_each do |i|
          if params.has_key?(:variant_id)
            selected = !@variant.ingredients.find_by_id(i.id).nil?
          else
            selected = false
          end
          @ingredients << {
            id: i.id,
            name: i.name,
            ingredient_type_id: i.ingredient_type_id,
            mesure_unit: i.type.mesure_unit,
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
    @edit_type = true
    @edit_name = true
  end

  def edit
    init_form
    @edit_type = false
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.user = current_user

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
    @ingredient.destroy
 
    redirect_to ingredients_path
  end

  private

    def init_form
      @ingredient_types = IngredientType.order(:name)
      @can_edit_density = current_user.role.rank <= 2  
    end

    def select_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    def ingredient_params
      result = params.require(:ingredient).permit(
        :name, :name_latin, :ingredient_type_id, :density, 
        :scope, :recipe_type_id, :variant_id, :description)
      result[:density] = result[:density].to_f * 100.0 if result.has_key?(:density)
      result[:name_latin] = nil if result[:name_latin] == ""
      result
    end


end
