require 'test_helper'

class ServiceArrangementTest < ActiveSupport::TestCase
  setup do 
    @arrangements = service_arrangements :one
  end

  test "should be valid" do
    assert @arrangements.valid?
  end

  test "should have a client" do
    @arrangements.client = nil
    assert_not @arrangements.valid?
  end

  test "should have a server" do
    @arrangements.server = nil
    assert_not @arrangements.valid?
  end

  test "should have a end_date" do
    @arrangements.end_date = nil
    assert_not @arrangements.valid?
  end

  test "should have a start_date" do
    @arrangements.start_date = nil
    assert_not @arrangements.valid?
  end

  test "should have an offer" do
    @arrangements.offer = nil
    assert_not @arrangements.valid?
  end

end
