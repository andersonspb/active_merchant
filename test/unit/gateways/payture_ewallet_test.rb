require 'test_helper'

class PaytureEwalletTest < Test::Unit::TestCase
  def setup
    @gateway = PaytureEwalletGateway.new(
                 :login => 'login',
                 :password => 'password'
               )

    @credit_card = credit_card
    @amount = 100

    @options = {
      :order_id => '1',
      :billing_address => address,
      :description => 'Store Purchase'
    }
  end

  def test_successful_register_user
    @gateway.expects(:ssl_post).returns(successful_register_user_response)

    assert response = @gateway.register_user(:user_login => '123@ya.ru', :user_password => '12345')
    assert_instance_of Response, response
    assert_success response

    # Replace with authorization number from the successful response
    assert_equal '123@ya.ru', response.params['user_login']
  end

  def test_successful_register_card
    @gateway.expects(:ssl_post).returns(successful_register_card_response)

    assert response = @gateway.register_card(@credit_card)
    assert_instance_of Response, response
    assert_success response
    assert_equal '40252318-de07-4853-b43d-4b67f2cd2077', response.params['card_id']
  end

  def test_successful_purchase
    @gateway.expects(:ssl_post).returns(successful_purchase_response)

    params = {:card_id => '123',
      :order_id => 'hr1234',
      :security_code => '321',
      :user_ip => '231.32.13.123'}

    assert response = @gateway.purchase(1300, params)
    assert_instance_of Response, response
    assert_success response

    # Replace with authorization number from the successful response
    assert_equal '123@dom.com', response.params['user_login']
  end

  private

  # Place raw successful response from gateway here
  def successful_purchase_response
  end

  # Place raw failed response from gateway here
  def failed_purchase_response
  end

  def successful_register_user_response
    '<Register Success="True" VWUserLgn="123@ya.ru" />'
  end

  def successful_register_card_response
    '<Add VWUserLgn="123@dom.com" Success="True" CardName="4111111112" CardId="40252318-de07-4853-b43d-4b67f2cd2077" />'
  end

  def successful_purchase_response
    '<Pay VWUserLgn="123@dom.com" OrderId="hr1234" Success="True" Amount="1300" />'
  end
end
