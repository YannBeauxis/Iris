class ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :get_list

  def index
    @products = Product.all
  end 

  def show
    @product = Product.find(params[:id])
    @variant = @product.variant
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

    def product_params
      params.require(:product).permit(:name, :variant_id, :volume, :detail)
    end


end
