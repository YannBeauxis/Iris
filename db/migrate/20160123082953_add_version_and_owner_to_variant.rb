class AddVersionAndOwnerToVariant < ActiveRecord::Migration
  def change
    add_reference :variants, :user, index: true
    add_foreign_key :variants, :users
    Variant.find_each do |v|
      v.user = v.recipe.user
      v.save
    end
    change_table :variants do |t|
      t.column :description, :string
      t.column :archived, :boolean
      t.column :next_version_id, :integer
    end
  end
end
