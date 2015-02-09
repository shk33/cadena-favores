require 'test_helper'

class BalanceTest < ActiveSupport::TestCase
  def setup
    @balance = balances(:one)
  end

  test "should be valid" do
    assert @balance.valid?
  end

  test "should have zero usable points" do
    assert_equal @balance.usable_points , 0 
  end

  test "should have zero frozen points" do
    assert_equal @balance.frozen_points , 0 
  end

  test "should have zero total points" do
    assert_equal @balance.total_points , 0 
  end
end
