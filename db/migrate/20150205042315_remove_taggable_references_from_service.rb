class RemoveTaggableReferencesFromService < ActiveRecord::Migration
  def change
    remove_reference :services, :taggable, index: true
  end
end
