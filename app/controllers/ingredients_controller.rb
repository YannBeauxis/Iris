class IngredientsController < ApplicationController
  respond_to :html, :xml, :json
  before_action :is_used_by_other, only: [:edit, :update, :destroy]
  
  def index
    
    if params[:scope] == 'My' then
      @ingredients = Ingredient.joins(:containers)
                        .where('user_id = ' + current_user.id.to_s).uniq
      @ingredient_types = IngredientType.joins(ingredients: :containers)
                        .where('user_id = ' + current_user.id.to_s).uniq
    else
      @ingredients = Ingredient.all
      @ingredient_types = IngredientType.all
    end
    
    respond_with(@ingredients)
    
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
  end

  def edit

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

  def get_table
    
    ct = CategoryTable.new(
      categories: {
        name: :type,
        collection: IngredientType.all},
      items: Ingredient.all,
      columns: [
        { id: 'price',
          header: 'prix',
          #category: {method: 'price_by_unit_display', method_params: current_user },
          item: {method: 'price_by_unit_display', params: current_user }},
        { id: 'recipes',
          header: '#recettes',
          item: {method: 'recipes_count', params: current_user }},
        { id: 'stock',
          header: 'stock',
          item: {method: 'quantity_in_stock', params: current_user }}]
    )
    
    render :json => ct.display_table
    
  end

  private

    def is_used_by_other
      @ingredient = Ingredient.find(params[:id])
      if @ingredient.used_by_other_users?(current_user) and (current_user.role.rank  > 2) then
        redirect_to :back, 
          :flash => { :error => "Vous ne pouvez modifier cet ingrédient car il est utilisé par d'autres utilisateurs" }
      end
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :ingredient_type_id, :density, :scope)
    end


end
