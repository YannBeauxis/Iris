class ProportionsController < ApplicationController

  def update

    @proportion = Proportion.find(params[:id])
    @variant = Variant.find(params[:variant_id])
    @recipe = Recipe.find(params[:recipe_id])

    @proportion.value = @proportion.value.round(2)
    @proportion.update(proportion_params)
    @proportion.save

    redirect_to edit_recipe_variant_path(@recipe,@variant)

  end

  def proportion_params
    params.require(:proportion).permit(:value)
  end

end
