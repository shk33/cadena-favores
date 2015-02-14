require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  def setup
    @service = Service.new title: "Valid title", description: "valid description" ,
            cost: "100"
  end

  test "should be valid" do
    assert @service.valid?
  end

  test "title should be valid" do
    @service.title = '       '
    assert_not @service.valid?
  end

  test "description should be valid" do
    @service.description = '       '
    assert_not @service.valid?
  end

  test "cost should not be greater or equal than zero" do
    @service.cost = '-123'
    assert_not @service.valid?
  end

  test "cost should be numeric and an integer" do
    @service.cost = 'Not a number'
    assert_not @service.valid?

    @service.cost = '12.456'
    assert_not @service.valid?
  end

end
