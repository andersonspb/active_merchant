module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paydollar
        class Return < ActiveMerchant::Billing::Integrations::Return

          def success?
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
            @most_recent_record.nil? || @most_recent_record["orderStatus"] == 'Accepted'
          end

        end
      end
    end
  end
end
