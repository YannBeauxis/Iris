require 'test_helper'

class ContainersControllerTest < ActionController::TestCase
  
  test  "cannot_create_if_ingredient_not_user_enable" do
    
    u = users(:one)
    sign_in u

    # Can create if ingredient validated
    i = ingredients(:not_one)
    i_conts = i.containers.count
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients/" + i.id.to_s + "/containers"        
    post(:create, {
       ingredient_id: i, container: {quantity_init: 10 , quantity_actual: 10, price: 10}})
    c = Container.find_by_id(assigns(:container).id)
    #assert_not c.nil?, 'should can create container of validated ingredients'
    assert i.reload.containers.count == i_conts +1 
    
    # Cannot create if ingredient not validated
    i = ingredients(:not_one_not_validated)
    i_conts = i.containers.count
    @request.headers["HTTP_REFERER"] = "http://test.host/ingredients/" + i.id.to_s + "/containers"        
    post(:create, {
       ingredient_id: i, container: {quantity_init: 20 , quantity_actual: 20, price: 20}})
    c = Container.find_by_id(assigns(:container).id)
    assert i.reload.containers.count == i_conts
    
  end
  
end
