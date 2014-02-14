require File.dirname(__FILE__) + '/paydollar/helper.rb'
require File.dirname(__FILE__) + '/paydollar/notification.rb'
require File.dirname(__FILE__) + '/paydollar/return.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paydollar

        CURRENCY_MAP = {
            'PHP' => '608',
            'USD' => '840',
            'HKD' => '344',
            'SGD' => '702',
            'CNY' => '156',
            'JPY' => '392',
            'TWD' => '901',
            'AUD' => '036',
            'EUR' => '978',
            'GBP' => '826',
            'CAD' => '124',
            'MOP' => '446',
            'THB' => '764',
            'MYR' => '458',
            'IDR' => '360',
            'KRW' => '410',
            'SAR' => '682',
            'NZD' => '554',
            'AED' => '784',
            'BND' => '096',
        }

        mattr_accessor :production_url, :test_url, :api_production_url, :api_test_url
        self.production_url = 'https://www.paydollar.com/b2c2/eng/payment/payForm.jsp'
        self.test_url = 'https://test.paydollar.com/b2cDemo/eng/payment/payForm.jsp'
        self.api_production_url = 'https://www.paydollar.com/b2c2/eng/merchant/api/orderApi.jsp'
        self.api_test_url = 'https://test.paydollar.com/b2cDemo/eng/merchant/api/orderApi.jsp'

        def self.service_url
          case ActiveMerchant::Billing::Base.integration_mode
          when :production
            self.production_url
          when :test
            self.test_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.api_url
          case ActiveMerchant::Billing::Base.integration_mode
          when :production
            self.api_production_url
          when :test
            self.api_test_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.notification(post, options = {})
          Notification.new(post, options)
        end

        def self.return(query_string, options = {})
          Return.new(query_string, options)
        end

        def self.sign(fields, secret)
          Digest::SHA1.hexdigest(fields.push(secret).join('|'))
        end

      end
    end
  end
end
