class AddReferencesToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :imageable, polymorphic: true, index: true
    add_reference :profiles, :taggable,  polymorphic: true, index: true
  end
end
