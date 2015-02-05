class RemoveTagTypeFromService < ActiveRecord::Migration
  def change
    remove_column :services, :taggable_type, :string
  end
end
