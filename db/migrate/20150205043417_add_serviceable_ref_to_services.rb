class AddServiceableRefToServices < ActiveRecord::Migration
  def change
    add_reference :services, :serviceable, polymorphic: true, index: true
  end
end
