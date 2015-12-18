class IngredientTypesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_list

  def index
    #respond_to do |format|
    #  format.json { render :json => @ingredient_types }
    #  format.html
    #end
    respond_with(@ingredient_types)
  end

  def show
    @ingredient_type = IngredientType.find(params[:id])
    @container_references = @ingredient_type.container_references
    respond_to do |format|
      format.json { render :json => @ingredient_type }
      format.html
    end
  end 

  def new
    @ingredient_type = IngredientType.new
  end

  def edit
    @ingredient_type = IngredientType.find(params[:id])
  end

  def create
    @ingredient_type = IngredientType.new(ingredient_type_params)

    if @ingredient_type.save
      redirect_to @ingredient_type
    else
      render 'new'
    end
  end

  def update
    @ingredient_type = IngredientType.find(params[:id])
 
    if @ingredient_type.update(ingredient_type_params)
      redirect_to @ingredient_type
    else
      render 'edit'
    end
  end

  def destroy
    @ingredient_type = IngredientType.find(params[:id])
    @ingredient_type.destroy
 
    redirect_to ingredient_types_path
  end

  private

    def get_list
      @ingredient_types = IngredientType.all
      @ingredients = Ingredient.all
    end

    def ingredient_type_params
      params.require(:ingredient_type).permit(:name,:name_short, :mesure_unit, :density)
    end

end
