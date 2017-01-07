require 'test_helper'

class RecipeTypeTest < ActiveSupport::TestCase
  
  test "Add Recipe Type" do
    r = RecipeType.new
    r.name = 'Recipe Type test'
    assert r.save
  end
  
  test "Not delete if recipes" do
    rt = recipe_types(:three)
    assert_not rt.destroy
  end
  
  test "recipes user enable" do
    u = users(:one)

    #recipes list
    rl = {}
    rlp = {
      r_uo_to: { fixt: :one, v_base: :one, 
        comment: 'user = one, type = one'},
      r_uo_tn: { fixt: :two, v_base: :two, 
        comment: 'user = one, type = not one'},
      r_un_to: { fixt: :not_one, v_base: :recipe_not_one_ingredient_not_validated, 
        comment: 'user = not one, type = one, not user enable'},
    }
    .each { |k, r|
      rt = recipes(r[:fixt])
      rt.variant_base_id = variants(r[:v_base]).id
      rt.save
      rl[k] = rt
    }
    
    #recipe type list (target)
    rtl = recipe_types(:one).recipes_user_enable(u)

    assert_includes rtl, rl[:r_uo_to], rlp[:r_uo_to][:comment]
    assert_not_includes rtl, rl[:r_uo_tn], rlp[:r_uo_tn][:comment]
    assert_not_includes rtl, rl[:r_un_to], rlp[:r_un_to][:comment]
    
  end
  
  test "Density" do
    rt_d_09 = recipe_types(:density_09)
    rt_no_d = recipe_types(:no_density)
    assert rt_d_09.density == 90, 'not get self density'
    assert rt_no_d.density == 100, 'not get default density' 
  end
  
end
