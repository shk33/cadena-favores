require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  def setup
    arrangement = service_arrangements :two
    user = users :main_user
    @review = Review.new
    @review.rating = 5
    @review.description = "A valid description"
    @review.user = user
    @review.service_arrangement = arrangement

  end

  test "should be valid" do
    assert @review.valid?
  end

  test "should have rating" do
    @review.rating = nil
    assert_not @review.valid?
  end

  test "should have a valid rating" do
    @review.rating = 10
    assert_not @review.valid?
    @review.rating = -1
    assert_not @review.valid?
  end

  test "should have a description" do
    @review.description = nil
    assert_not @review.valid?
  end

  test "should have a user" do
    @review.user = nil
    assert_not @review.valid?
  end
end
