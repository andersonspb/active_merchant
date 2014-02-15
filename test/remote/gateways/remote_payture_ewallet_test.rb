require 'test_helper'

class RemotePaytureEwalletTest < Test::Unit::TestCase

  def setup
    @gateway = PaytureEwalletGateway.new(fixtures(:payture))

    @credit_card = credit_card('1234123412341234', {:month => 12, :year => 2015, :verification_value => 123})
    @success_card_without_3ds = credit_card('4111111111111112', {:month => 12, :year => 2015, :verification_value => 123})
    @declined_card = credit_card('4000300011112220')
    @user_login = '1'
    @user_password = '123'

    @options = {
      :order_id => '1',
      :billing_address => address,
      :description => 'Store Purchase'
    }

    delete_user
  end

  def test_successful_register_user
    assert response = @gateway.register_user(:user_login => @user_login, :user_password => @user_password)
    assert_success response
    assert_equal @user_login, response.params['user_login']
    @gateway.delete_user(:user_login => @user_login)
  end

  def test_successful_delete_user
    @gateway.register_user(:user_login => @user_login, :user_password => @user_password)
    assert response = @gateway.delete_user(:user_login => @user_login)
    assert_success response
    assert_equal @user_login, response.params['user_login']
  end

  def test_successful_register_card
    @gateway.register_user(:user_login => @user_login, :user_password => @user_password)
    assert response = @gateway.register_card(@credit_card, {:user_login => @user_login, :user_password => '123'})
    assert_success response
    assert_equal @user_login, response.params['user_login']
    assert_equal '123412xxxxxx1234', response.params['card_name']
    assert response.params['card_id'].present?, 'card_id should be present'
    @gateway.delete_user(:user_login => @user_login)
  end

  def test_successful_pay
    @gateway.register_user(:user_login => @user_login, :user_password => @user_password)
    response = @gateway.register_card(@success_card_without_3ds, {:user_login => @user_login, :user_password => @user_password})
    puts response.inspect
    card_id = response.params['card_id']
    response = @gateway.pay(1, {:user_login => @user_login, :user_password => @user_password, :card_id => card_id, :order_id => 1, :security_code => 123, :user_ip => '192.168.0.1'})
    puts response.params
    @gateway.delete_user(:user_login => @user_login)
  end

  protected

  def delete_user
    @gateway.delete_user(:user_login => @user_login)
  end
end
