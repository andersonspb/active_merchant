require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paydollar

        class Notification < ActiveMerchant::Billing::Integrations::Notification

          def complete?
            status = 'Completed'
          end

          def item_id
            params['Ref']
          end

          def currency
            CURRENCY_MAP.key(@most_recent_record["cur"])
          end

          def gross
            @most_recent_record["amt"]
          end

          def transaction_id
            @most_recent_record["payRef"]
          end

          def status
            uri = URI.parse(ActiveMerchant::Billing::Integrations::Paydollar.api_url)
            form = {
              merchantId: @options[:credential1],
              loginId: @options[:credential3],
              password: @options[:credential4],
              actionType: 'Query',
              orderRef: @params["Ref"]
            }
            response = Net::HTTP.post_form(uri, form)
            records = Hash.from_xml(response.body)["records"]["record"]
            @most_recent_record = if records.kind_of?(Array)
                                   records.sort_by! {|rec| rec["payRef"]}
                                   records[-1]
                                 else
                                   records
                                 end
            return 'Failed' if @most_recent_record.nil?
            case @most_recent_record["orderStatus"]
              when 'Accepted' then 'Completed'
              else 'Failed'
            end
          end

          def acknowledge(authcode = nil)
            params.has_key?("Ref")
          end

        end
      end
    end
  end
end
