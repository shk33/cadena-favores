class AddOfferToServiceArrangements < ActiveRecord::Migration
  def change
    add_reference :service_arrangements, :offer, index: true
  end
end
