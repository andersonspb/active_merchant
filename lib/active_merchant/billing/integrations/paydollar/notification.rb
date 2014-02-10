require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Paydollar
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def complete?
            params['']
          end

          def item_id
            params['']
          end

          def transaction_id
            params['']
          end

          def received_at
            params['']
          end

          def payer_email
            params['']
          end

          def receiver_email
            params['']
          end

          def security_key
            params['']
          end

          def gross
            params['']
          end

          def test?
            params[''] == 'test'
          end

          def status
            params['']
          end

          def acknowledge(authcode = nil)
            uri = URI.parse(Paydollar.api_url)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true

            request = Net::HTTP::Post.new(uri.path)
            request.basic_auth @options[:credential1], ''

            response = http.request(request)

            posted_json = JSON.parse(@raw).tap { |j| j.delete('currentTime') }
            parse(response.body)
            retrieved_json = JSON.parse(@raw).tap { |j| j.delete('currentTime') }

            posted_json == retrieved_json


            raise StandardError.new("Faulty Paydollar result: #{response.body}") unless ["AUTHORISED", "DECLINED"].include?(response.body)
            response.body == "AUTHORISED"
          end

          private

          def parse(post)
            @raw = post.to_s
            for line in @raw.split('&')
              key, value = *line.scan( %r{^([A-Za-z0-9_.-]+)\=(.*)$} ).flatten
              params[key] = CGI.unescape(value.to_s) if key.present?
            end
          end
        end
      end
    end
  end
end
