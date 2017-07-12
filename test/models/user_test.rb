require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user=User.new(name:"example", email:"user@example.com",
          password:"foobar", password_confirmation:"foobar")
  end

  test "should be valid" do
   assert @user.valid?, "#{@user.inspect} should be valid"
  end
  
  test "name should be present" do
    @user.name="  "
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email=" "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?, "#{@user.name} should not be too long"
  end
  test "email should not be too long" do
    @user.email = "a" * 244 +"@example.com"
    assert_not @user.valid?,"#{@user.email} should not be too long"
  end
  
 test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
    test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com user@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

    test "email should be unique" do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      @user.save
      assert_not duplicate_user.valid?
      #通ってしまうbecause both are unique. so need to make it not case_sensitive
  end
    test "email is downcase" do
      mixed_case = "Foo@ExaMple.CoM"
      @user.email = mixed_case
      @user.save
      assert_equal mixed_case.downcase, @user.reload.email, "@user.email is #{@user.email}"
  end
  
    test "password should be present(nonblank)" do
      @user.password = @user.password_confirmation =" "*6
      assert_not @user.valid?
    end
    
    test "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a"*5
      assert_not @user.valid?
    end
    
    
  
  # test "the truth" do
  #   assert true
  # end
end