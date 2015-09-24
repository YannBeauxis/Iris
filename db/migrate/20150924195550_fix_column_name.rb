class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :containers, :volume_init, :quantity_init
    rename_column :containers, :volume_actual, :quantity_actual
  end
end
