class ProductsController < ApplicationController
  before_action :get_list
  before_action :check_user, except: [:index, :show, :edit, :update, :destroy]
  
  def index
    @products = Product.all
  end 

  def show
    @product = Product.find(params[:id])
    @variant = @product.variant
    @product.evaluate_proportions
  end 

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
    @variant = @product.variant
  end

  def create
    @product = Product.new(product_params)
    @variant = @product.variant#Variant.find(id: params[:variant_id])
    @variant.products << @product

    if @variant.save
      redirect_to recipe_product_path(@recipe,@product)
    else
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])
 
    if @product.update(product_params)
      redirect_to recipe_product_path(@recipe,@product)
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
 
    redirect_to recipe_products_path(@recipe)
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
      params.require(:product).permit(:name, :variant_id, :volume, :detail)
    end


end
