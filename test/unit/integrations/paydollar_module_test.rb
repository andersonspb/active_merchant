require 'test_helper'

class PaydollarModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_notification_method
    assert_instance_of Paydollar::Notification, Paydollar.notification('name=cody')
  end
end
