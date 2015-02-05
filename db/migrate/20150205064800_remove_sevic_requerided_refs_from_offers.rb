class RemoveSevicRequeridedRefsFromOffers < ActiveRecord::Migration
  def change
    remove_reference :offers, :required_service, index: true
  end
end
