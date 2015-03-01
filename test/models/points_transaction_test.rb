require 'test_helper'

class PointsTransactionTest < ActiveSupport::TestCase
  def setup
    @service_arrangement = service_arrangements :one
    @points_transaction  = PointsTransaction.new sender: users(:main_user),
                                receiver: users(:one),
                                service_arrangement: @service_arrangement,
                                amount: @service_arrangement.service.cost

  end

  test "should be valid" do
    assert @points_transaction.valid?
  end

  test "should have a amount" do
    @points_transaction.amount = nil
    assert_not @points_transaction.valid?
  end

  test "should have a sender" do
    @points_transaction.sender = nil
    assert_not @points_transaction.valid?
  end

  test "should have a receiver" do
    @points_transaction.receiver = nil
    assert_not @points_transaction.valid?
  end

  test "should have a service arrangement" do
    @points_transaction.service_arrangement = nil
    assert_not @points_transaction.valid?
  end

end
