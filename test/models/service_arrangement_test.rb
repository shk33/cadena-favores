require 'test_helper'

class ServiceArrangementTest < ActiveSupport::TestCase
  setup do 
    @arrangement = service_arrangements :one
  end

  test "should be valid" do
    assert @arrangement.valid?
  end

  test "should have a client" do
    @arrangement.client = nil
    assert_not @arrangement.valid?
  end

  test "should have a server" do
    @arrangement.server = nil
    assert_not @arrangement.valid?
  end

  test "should have a end_date" do
    @arrangement.end_date = nil
    assert_not @arrangement.valid?
  end

  test "start_date cannot be in the past" do
    @arrangement.start_date = Date.today - 2 
    assert_not @arrangement.valid?
  end

  test "end_date cannot be in the past of start_date" do
    @arrangement.end_date = Date.today # star_date is Date.today +2
    assert_not @arrangement.valid?
  end

  test "should have a start_date" do
    @arrangement.start_date = nil
    assert_not @arrangement.valid?
  end

  test "should have an offer" do
    @arrangement.offer = nil
    assert_not @arrangement.valid?
  end

  test "client can review arrangement" do
    user = users :main_user
    assert @arrangement.can_review? user
  end

end
