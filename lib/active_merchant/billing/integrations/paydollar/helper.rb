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

        class Helper < ActiveMerchant::Billing::Integrations::Helper

          def initialize(order, account, options = {})
            @secret = options.delete(:credential2)
            super
            add_field('payType', options[:transaction_type] || 'N') # normal sale and not just auth
          end

          def form_fields
            @fields.merge("secureHash" => generate_secure_hash)
          end

          def generate_secure_hash
            signature_string = [@fields[mappings[:account]],
                                @fields[mappings[:order]],
                                @fields[mappings[:currency]],
                                @fields[mappings[:amount]],
                                @fields['payType'],
                                @secret].join('|')
            Digest::SHA1.hexdigest(signature_string)
          end

          def currency=(currency_code)
            code = CURRENCY_MAP[currency_code]
            raise StandardError, "Invalid currency code #{currency_code} specified" if code.nil?
            add_field(mappings[:currency], code)
          end

          mapping :account, 'merchantId'
          mapping :amount, 'amount'
          mapping :order, 'orderRef'
          mapping :currency, 'currCode'
          mapping :return_url, ['successUrl','failUrl']
          mapping :cancel_return_url, 'cancelUrl'
          mapping :description, 'remark'

        end
      end
    end
  end
end
