class DeleteNumberProducedFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :number_produced, :string
  end
end
