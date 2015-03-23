require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new name: "Example user", email: "user@example.com" ,
            password: "foobar", password_confirmation: "foobar"
    @user.profile = Profile.new 
    @user.balance = Balance.new 
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be valid" do
    @user.name = '       '
    assert_not @user.valid?
  end

  test "email should be valid" do
    @user.email = '       '
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*256
    assert_not @user.valid?
  end

  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase 
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end


  test "should not have a nil profile" do
    assert_not @user.profile.nil?
  end

  test "should not have a nil balance" do
    assert_not @user.balance.nil?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,'')    
  end

  test "should follow and unfollow a user" do
    main_user = users :main_user
    one       = users :one
    assert_not main_user.following?(one)
    main_user.follow(one)
    assert main_user.following?(one)
    main_user.unfollow(one)
    assert_not main_user.following?(one)
  end

  test "search by tag should return all users when tag is not provided" do
    assert_equal User.search_by_tag(nil), User.all
  end

end