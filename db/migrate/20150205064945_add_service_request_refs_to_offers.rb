class AddServiceRequestRefsToOffers < ActiveRecord::Migration
  def change
    add_reference :offers, :service_request, index: true
  end
end
