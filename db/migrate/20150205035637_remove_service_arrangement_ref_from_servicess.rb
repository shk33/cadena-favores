class RemoveServiceArrangementRefFromServicess < ActiveRecord::Migration
  def change
    remove_reference :services, :service_arrangement, index: true
  end
end
