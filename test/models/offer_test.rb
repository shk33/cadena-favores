require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  def setup
    user = users :main_user
    @offer = Offer.new
    @offer.user = users :main_user
    @offer.service_request = service_requests :two
  end

  test "should be valid" do
    assert @offer.valid?
  end

  test "should have user" do
    @offer.user = nil
    assert_not @offer.valid?
  end

  test "should have a service_request" do
    @offer.service_request = nil
    assert_not @offer.valid?
  end

  test "should not accept a invalid offer" do
    assert_not @offer.accept nil
  end
end
