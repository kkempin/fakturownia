# encoding: utf-8
module Fakturownia
  module API

    # Get JSON-formatted invoice based on invoice id (from Fakturownia)
    def self.invoice invoice_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice_id}.json"
      response = self.make_get_request(endpoint)

      (response.code == '200') ? JSON.parse(response.body) : nil 
    end

    # Get JSON-formatted invoice based on order id
    def self.invoice_by_order_id order_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices"
      response = self.make_get_request(endpoint, { :oid => order_id })

      (response.code == '200') ? JSON.parse(response.body) : nil 
    end

    # Get JSON-formatted invoices based from given period
    # Available periods = [:all, :this_month, :last_month, :this_year, :last_year, :more]
    # If period = :more than date_from and date_to has to be set
    def self.invoices period, date_from = nil, date_to = nil
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices.json?period=#{period}"
      additional_params = { :period => period }
      if period.to_s == 'more'
        additional_params[:date_from] = date_from
        additional_params[:date_to] = date_to
      end
      response = self.make_get_request(endpoint, additional_params)

      (response.code == '200') ? JSON.parse(response.body) : nil 
    end

    # Get invoice PDF based on invoice id
    def self.pdf invoice_id
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice_id}.pdf"
      response = self.make_get_request(endpoint)
       
      (response.code == '200') ? response.body : nil
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
      (response.code == '201') ? JSON.parse(response.body) : nil
    end


    # Update invoice
    # invoice_id - id of invoice from fakturownia
    def self.update invoice_id, invoice_json
      endpoint = "https://#{Fakturownia.account_name}.fakturownia.pl/invoices/#{invoice.fakturownia_id}.json"
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

      (response.code == '201') ? JSON.parse(response.body) : nil
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
