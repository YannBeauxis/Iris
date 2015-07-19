class ContainerReferencesController < ApplicationController
  before_action :get_list
  
  def index
    @container_references = @ingredient_type.container_references
  end

  def new
    @container_reference = ContainerReference.new
  end

  def edit
    @container_reference = ContainerReference.find(params[:id])
  end

  def create
    @container_reference = ContainerReference.new(container_reference_params)
    @ingredient_type.container_references << @container_reference
    
    if @container_reference.save
      redirect_to ingredient_type_path(@ingredient_type)
    else
      render 'new'
    end
  end

  def update
    @container_reference = ContainerReference.find(params[:id])
 
    if @container_reference.update(container_reference_params)
      redirect_to ingredient_type_path(@ingredient_type)
    else
      render 'edit'
    end
  end

  def destroy
    @container_reference = ContainerReference.find(params[:id])
    @container_reference.destroy
 
    redirect_to ingredient_type_path(@ingredient_type)
  end

  def get_list
    @ingredient_type = IngredientType.find(params[:ingredient_type_id])
  end

  def container_reference_params
    params.require(:container_reference).permit(:ingredient_type_id, :volume, :mass)
  end

end
