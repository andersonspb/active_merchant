#encoding: utf-8

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaytureEwalletGateway < Gateway

      ERROR_CODES = {
        'NONE' =>	'Операция выполнена без ошибок',
        'ACCESS_DENIED' =>	'Доступ с текущего IP или по указанным параметрам запрещен',
        'AMOUNT_ERROR' =>	'Неверно указана сумма транзакции',
        'AMOUNT_EXCEED' => 'Сумма транзакции превышает доступный остаток средств на выбранном счете',
        'API_NOT_ALLOWED' => 'Данный API не разрешен к использованию',
        'COMMUNICATE_ERROR' => 'Ошибка возникла при передаче данных в МПС',
        'DUPLICATE_ORDER_ID' => 'Номер заказа уже использовался ранее',
        'DUPLICATE_CARD' => 'Карта уже зарегистрирована',
        'DUPLICATE_USER' => 'Пользователь уже зарегистрирован',
        'EMPTY_RESPONSE' => 'Ошибка процессинга',
        'FORMAT_ERROR' => 'Неверный формат переданных данных',
        'FRAUD_ERROR' => 'Недопустимая транзакция согласно настройкам антифродового фильтра',
        'FRAUD_ERROR_BIN_LIMIT' => 'Превышен лимит по карте(BINу, маске) согласно настройкам антифродового фильтра',
        'FRAUD_ERROR_BLACKLIST_BANKCOUNTRY' => 'Страна данного BINа находится в черном списке или не находится в списке допустимых стран',
        'FRAUD_ERROR_BLACKLIST_AEROPORT' => 'Аэропорт находится в черном списке',
        'FRAUD_ERROR_BLACKLIST_USERCOUNTRY' => 'Страна данного IP находится в черном списке или не находится в списке допустимых стран',
        'FRAUD_ERROR_CRITICAL_CARD' => 'Номер карты(BIN, маска) внесен в черный список антифродового фильтра',
        'FRAUD_ERROR_CRITICAL_CUSTOMER' => 'IP-адрес внесен в черный список антифродового фильтра',
        'ILLEGAL_ORDER_STATE' => 'Попытка выполнения недопустимой операции для текущего состояния платежа',
        'INTERNAL_ERROR' => 'Неправильный формат транзакции с точки зрения сети',
        'INVALID_FORMAT' => 'Неправильный формат транзакции с точки зрения сети',
        'ISSUER_CARD_FAIL' => 'Банк-эмитент запретил интернет транзакции по карте',
        'ISSUER_FAIL' => 'Владелец карты пытается выполнить транзакцию, которая для него не разрешена банком-эмитентом, либо внутренняя ошибка эмитента',
        'ISSUER_LIMIT_FAIL' => 'Предпринята попытка, превышающая ограничения банка-эмитента на сумму или количество операций в определенный промежуток времени',
        'ISSUER_LIMIT_AMOUNT_FAIL' => 'Предпринята попытка выполнить транзакцию на сумму, превышающую (дневной) лимит, заданный банком-эмитентом',
        'ISSUER_LIMIT_COUNT_FAIL' => 'Превышен лимит на число транзакций: клиент выполнил максимально разрешенное число транзакций в течение лимитного цикла и пытается провести еще одну',
        'ISSUER_TIMEOUT' => 'Нет связи с банком эмитентом',
        'LIMIT_EXCHAUST' => 'Время или количество попыток, отведенное для ввода данных, исчерпано',
        'MERCHANT_RESTRICTION' => 'Превышен лимит Магазина или транзакции запрещены Магазину',
        'NOT_ALLOWED' => 'Отказ эмитента проводить транзакцию. Чаще всего возникает при запретах наложенных на карту',
        'OPERATION_NOT_ALLOWED' => 'Действие запрещено',
        'ORDER_NOT_FOUND' => 'Не найдена транзакция',
        'ORDER_TIME_OUT' => 'Время платежа (сессии) истекло',
        'PROCESSING_ERROR' => 'Ошибка функционирования системы, имеющая общий характер. Фиксируется платежной сетью или банком-эмитентом',
        'PROCESSING_TIME_OUT' => 'Таймаут в процессинге',
        'REAUTH_NOT_ALOWED' => 'Изменение суммы авторизации не может быть выполнено',
        'REFUND_NOT_ALOWED' => 'Возврат не может быть выполнен',
        'REFUSAL_BY_GATE' => 'Отказ шлюза в выполнении операции',
        'RETRY_LIMIT_EXCEEDED' => 'Превышено допустимое число попыток произвести возврат (Refund)',
        'THREE_DS_FAIL' => 'Невозможно выполнить 3DS транзакцию',
        'THREE_DS_TIME_OUT' => 'Срок действия транзакции был превышен к моменту ввода данных карты',
        'USER_NOT_FOUND' => 'Пользователь не найден',
        'WRONG_CARD_INFO' => 'Введены неверные параметры карты',
        'WRONG_CARD_PAN' => 'Неверный номер карты',
        'WRONG_CARDHOLDER_NAME' => 'Недопустимое имя держателя карты',
        'WRONG_PARAMS' => 'Неверный набор или формат параметров',
        'WRONG_PAY_INFO' => 'Некорректный параметр PayInfo (неправильно сформирован или нарушена криптограмма)',
        'WRONG_AUTH_CODE' => 'Неверный код активации',
        'WRONG_CARD' => 'Переданы неверные параметры карты, либо карта в недопустимом состоянии',
        'WRONG_CONFIRM_CODE' => 'Неверный код подтверждения',
        'WRONG_USER_PARAMS' => 'Пользователь с такими параметрами не найден'}

      PAYTURE_ATTRS = {
        :card_number => 'CardNumber',
        :card_security_code => 'SecureCode',
        :card_name => 'CardName',
        :card_id => 'CardId',
        :exp_month => 'EMonth',
        :exp_year => 'EYear',
        :card_holder => 'CardHolder',
        :user_login => 'VWUserLgn',
        :user_password => 'VWUserPsw',
        :phone => 'PhoneNumber',
        :success => 'Success',
        :error_code => 'ErrCode',
        :order_id => 'OrderId',
        :amount => 'Amount',
        :security_code => 'SecureCode',
        :user_ip => 'IP',
        :confirm_code => 'ConfirmCode',
        :custom_fields => 'CustomFields',
        :password => 'Password'
      }


      self.test_url = 'https://sandbox.payture.com/vwapi/'
      self.live_url = 'https://live.payture.com/vwapi/'

      # The countries the gateway supports merchants from as 2 digit ISO country codes
      self.supported_countries = ['RU']

      # The card types supported by the payment gateway
      self.supported_cardtypes = [:visa, :master, :american_express, :discover]

      # The homepage URL of the gateway
      self.homepage_url = 'http://www.payture.ru/'

      # The name of the gateway
      self.display_name = 'Payture'

      def initialize(options = {})
        requires!(options, :login, :password)
        super
      end

      def register_user(options = {})
        post = {}
        add_user(post, options)
        commit('Register', post)
      end

      def delete_user(options = {})
        post = {}
        post[:user_login] = options[:user_login]
        post[:password] = @options[:password]
        commit('Delete', post)
      end

      def register_card(card, options = {})
        post = {}
        add_user(post, options)
        add_credit_card(post, card, options)
        commit('Add', post)
      end

      def delete_card(options = {})
        post = {}
        add_user(post, options)
        post[:card_id] = options[:card_id]
        commit('Remove', post)
      end

      def get_card_list(options = {})
        post = {}
        add_user(post, options)
        commit('GetList', post)
      end

      def pay(amount, options = {})
        post = {}
        post[:amount] = amount
        add_user(post, options)
        post[:card_id] = options[:card_id]
        post[:order_id] = options[:order_id]
        post[:security_code] = options[:security_code]
        post[:user_ip] = options[:user_ip]
        (post[:confirm_code] = options[:confirm_code]) if options[:confirm_code].present?
        (post[:custom_fields] = options[:custom_fields]) if options[:custom_fields].present?
        commit('Pay', post)
      end

      private

      def exp_month(card)
        "%02d" % card.expiry_date.month
      end

      def exp_year(card)
        "%02d" % card.expiry_date.year
      end

      def add_customer_data(post, options)
      end

      def add_address(post, creditcard, options)
      end

      def add_invoice(post, options)
      end

      def add_credit_card(post, creditcard, options = {})
        post[:card_number]   = creditcard.number
        post[:card_security_code]  = creditcard.verification_value if creditcard.verification_value?
        post[:exp_month]   = exp_month(creditcard)
        post[:exp_year] = exp_year(creditcard)
        post[:card_holder]  = creditcard.first_name + ' ' + creditcard.last_name
      end

      def add_user(post, options)
        post[:user_login] = options[:user_login]
        post[:user_password] = options[:user_password]
      end

      def url
        return test? ? self.test_url : self.live_url
      end

      def success?(response)
        response[:success] == true
      end

      def commit(action, parameters)
        url_with_action = url + action
        puts url_with_action
        data = ssl_post(url_with_action, post_data(parameters))
        response = parse(data)
        message = message_from(response)
        return Response.new(success?(response), message, response)
      end

      def parse(body)
        hash = Hash.from_xml(body)
        hash = hash[hash.keys.first]
        translated_hash = {}
        hash.each do |key, val|
          translated_hash[PAYTURE_ATTRS.key(key)||key] = normalize(val)
        end
        return translated_hash
      end

      # Make a ruby type out of the response string
      def normalize(value)
        case value.downcase
          when "true"   then true
          when "false"  then false
          when ""       then nil
          when "null"   then nil
          else value
        end
      end

      def message_from(results)
        results[:success] == false && results[:error_code].present? ? ERROR_CODES[results[:error_code]] : ''
      end

      def post_data(parameters = {})
        data = parameters.map { |key, val| "#{PAYTURE_ATTRS[key]}=#{val.to_s}"}.join(";")
        puts "DATA: #{data}"
        data = CGI.escape(data)
        str = "VWID=#{@options[:login]}&DATA=#{data}"
        return str
      end

    end
  end
end

