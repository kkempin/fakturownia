# encoding: utf-8
module Fakturownia
  module API

    # Get JSON-formatted invoice based on invoice id (from Fakturownia)
    def self.invoice invoice_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice_id}.json"
      response = self.make_get_request(endpoint)

      JSON.parse(response.body)
    end

    # Get JSON-formatted invoice based on order id
    def self.invoice_by_order_id order_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices.json"
      response = self.make_get_request(endpoint, { :oid => order_id })

      JSON.parse(response.body)
    end

    # Get JSON-formatted invoices based from given period
    # Available periods = [:all, :this_month, :last_month, :this_year, :last_year, :more]
    # If period = :more than date_from and date_to has to be set
    def self.invoices period_or_params, date_from = nil, date_to = nil
      params = if period_or_params.is_a?(Hash)
        period_or_params.symbolize_keys
      else
        {
          period: period_or_params,
          date_from: date_from,
          date_to: date_to
        }
      end

      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices.json"
      if params[:period].to_s != "more"
        params.delete(:date_from)
        params.delete(:date_to)
      end
      response = self.make_get_request(endpoint, params)

      JSON.parse(response.body)
    end

    # Get invoice PDF based on invoice id
    def self.pdf invoice_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice_id}.pdf"
      response = self.make_get_request(endpoint)

      response.body
    end

    # Create new invoice
    def self.create invoice_json
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices.json"
      uri = URI.parse(endpoint)

      json_params = {
        "api_token" => Fakturownia.api_token,
        "invoice" => invoice_json
      }

      request = Net::HTTP::Post.new(uri.path)
      request.body = JSON.generate(json_params)
      request["Content-Type"] = "application/json"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.start {|h| h.request(request)}
      JSON.parse(response.body)
    end

    # Update invoice
    # invoice_id - id of invoice from fakturownia
    def self.update invoice_id, invoice_json
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice_id}.json"
      uri = URI.parse(endpoint)

      json_params = {
        "api_token" => Fakturownia.api_token,
        "invoice" => invoice_json
      }

      request = Net::HTTP::Put.new(uri.path)
      request.body = JSON.generate(json_params)
      request["Content-Type"] = "application/json"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.start {|h| h.request(request)}

      JSON.parse(response.body)
    end


    # Delete invoice
    def self.delete invoice_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice_id}.json"
      uri = URI.parse(endpoint)
      whole_url = uri.path + "?api_token=#{Fakturownia.api_token}"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.delete(whole_url)
    end


    # Get all clients in XML
    def self.clients
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/clients.xml"
      response = self.make_get_request(endpoint)

      response.body
    end

    # Get client based on client_id
    # Return in XML
    def self.client client_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/clients/#{client_id}.xml"
      response = self.make_get_request(endpoint)

      response.body
    end

    # Get client based on email and password
    # Return in XML
    def self.client_by_email_and_password email, password
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/clients/check"
      response = self.make_get_request(endpoint, { :email => email, :password => password })

      (response.code == '200' and response.body.to_s != 'brak klienta') ? response.body : nil
    end


    # Make GET request returning response
    def self.make_get_request endpoint, additional_params = {}
      uri = URI.parse(endpoint)
      whole_url = uri.path + "?api_token=#{Fakturownia.api_token}"
      additional_params.each_pair do |k, v|
        whole_url += "&#{k}=#{v}"
      end

      request = Net::HTTP::Get.new(whole_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.start {|h| h.request(request)}
    end

  end
end
