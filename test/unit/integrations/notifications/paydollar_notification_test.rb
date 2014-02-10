require 'test_helper'

class PaydollarNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @paydollar = Paydollar::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @paydollar.complete?
    assert_equal "", @paydollar.status
    assert_equal "", @paydollar.transaction_id
    assert_equal "", @paydollar.item_id
    assert_equal "", @paydollar.gross
    assert_equal "", @paydollar.currency
    assert_equal "", @paydollar.received_at
    assert @paydollar.test?
  end

  def test_compositions
    assert_equal Money.new(3166, 'USD'), @paydollar.amount
  end

  # Replace with real successful acknowledgement code
  def test_acknowledgement

  end

  def test_send_acknowledgement
  end

  def test_respond_to_acknowledge
    assert @paydollar.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    ""
  end
end
