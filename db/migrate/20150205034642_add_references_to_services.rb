class AddReferencesToServices < ActiveRecord::Migration
  def change
    add_reference :services, :imageable, polymorphic: true, index: true
    add_reference :services, :taggable,  polymorphic: true, index: true
  end
end
