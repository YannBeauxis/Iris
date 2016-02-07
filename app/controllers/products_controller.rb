class ProductsController < ApplicationController
  before_action :get_list
  before_action :check_user, except: [:index, :show, :edit, :update, :destroy]
  
  def index
    @products = @recipe.products.where('products.user_id = ?', current_user)
    render json: @products.to_json#(:include => { :variant => { :only => [:id, :name] } })
  end 

  def show
    @product = Product.find(params[:id])
    @product.quantities.compute_prices(current_user)
    @variant = @product.variant
    @ingredients = @recipe.ingredients
    @ingredient_types = @recipe.ingredient_types
  end 

  def new
    @recipe = Recipe.find(params[:recipe_id])
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
    @variant = @product.variant
    @variants = @product.recipe.variants
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    @variant = @product.variant#Variant.find(id: params[:variant_id])
    @variant.products << @product

    success = @product.save && @variant.save
    @product.consume_stock if (success && params[:consume_stock])

    render :json => { :success => success }
  
    #if @variant.save
    #  redirect_to recipe_product_path(@recipe,@product)
    #else
    #  render 'new'
    #end
  end

  def update
    @product = Product.find(params[:id])
    render :json => { :success => @product.update(product_params) }
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    
    render :json => { :success => @product.destroy }
    
    #redirect_to recipe_path(@recipe)
  end

  private


    def get_list
      @recipe_types = RecipeType.all
      @recipes = Recipe.all
      @recipe = Recipe.find(params[:recipe_id])
    end
    
    def check_user
      @recipe = Recipe.find(params[:recipe_id])
    #if (current_user != @recipe.user) and !current_user.admin? then
      if cannot?(:update, @recipe) then
        flash[:message] = "Vous n'avez pas les autorisations nécessaires"
        redirect_to recipe_path(@recipe)
      end
    end
  
    def product_params
      params.require(:product).permit(
          :variant_id, :volume, :container, 
          :description, :production_date, :expiration_date,
          :consume_stock
      )
    end


end
