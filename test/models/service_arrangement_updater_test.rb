require 'test_helper'

class ServiceArrangementUpdaterTest < ActiveSupport::TestCase
  def setup
    @service_arrangement = service_arrangements :one
    @user = users :main_user
    @updater  = ServiceArrangementUpdater.new @service_arrangement.id, @user
  end

  test "should be a valid update" do
    assert @updater.valid_update?
  end

  test "should update" do
    @updater.update
    #Verifies the arrangement is closed
    arrangement = @updater.service_arrangement
    assert arrangement.completed?
    #Verifies the poins are transferred
    transaction = @updater.points_transaction
    assert_equal 50 , transaction.sender.balance.frozen_points
    assert_equal 450, transaction.sender.balance.total_points
    assert_equal 50 , transaction.receiver.balance.usable_points
    assert_equal 50 , transaction.receiver.balance.total_points
  end
end