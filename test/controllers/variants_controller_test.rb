require 'test_helper'

class VariantsControllerTest < ActionController::TestCase

  test "update_variant_name" do
    u = users(:producteur)
    sign_in u
    v = variants(:proportions)
    r = v.recipe
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    patch(:update, {id: v, recipe_id: r, variant: {name: 'Name updated'}})
    v = Variant.find(v.id)
    assert v.name == 'Name updated', v.name
    #assert_redirected_to recipe_variant_path(v)
  end

  test "update_variant_name_owner_only" do
    u = users(:producteur_2)
    sign_in u
    v = variants(:proportions)
    r = v.recipe
    @request.headers["HTTP_REFERER"] = "http://test.host/recipes/" + r.id.to_s + "/variants"
    patch(:update, {id: v, recipe_id: r, variant: {name: 'Name updated 2'}})
    v = Variant.find(v.id)
    assert_not v.name == 'Name updated 2', v.name
    #assert_redirected_to recipe_path(r)
  end
  
  
end