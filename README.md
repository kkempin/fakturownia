# Fakturownia

This gem provides integration with polish invoicing system www.fakturownia.pl

## Installation

Add this line to your application's Gemfile:

    gem 'fakturownia'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fakturownia

Execute:

	$ bundle install
	$ rails generate fakturownia:install


After installation you have to set two options in config/initializers/fakturownia.rb

* api\_token - after register in fakturownia.pl you will have this token
* account\_name - after login to fakturownia.pl is a first part of URL

## Usage

Get invoice based in invoice ID provided after creation from fakturownia.pl:

    Fakturownia::API.invoice(123456)

Get invoices from given time period:

    Fakturownia::API.invoices(period, date_from, date_to)

where:

* period is one of the [:all, :this\_month, :last\_month, :this\_year, :last\_year, :more]. If period = :more than date\_from and date\_to has to be set
* date\_from and date\_to - dates


Get invoice as a PDF:

    Fakturownia::API.pdf(123456)


Add new invoice:

    Fakturownia::API.create(invoice_json)

where invoice\_json is a hash with invoice data.


Update previously added invoice with invoice\_id from fakturownia.pl:

    Fakturownia::API.update(invoice_id, invoice_json)


Delete previously added invoice with invoice\_id from fakturownia.pl: 

    Fakturownia::API.delete(invoice_id)



More details in API requests and invoice JSON structure: https://app.fakturownia.pl/api

## TODO

* tests
* products
* clients
* payments

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This gem is licensed under the MIT License.
