module Fakturownia
  module Generators
    class InstallGenerator < Rails::Generators::Base
      @@root = File.expand_path("../../templates", __FILE__)
      source_root @@root

      desc "Copy files ..."

      def copy_initializer
        template "fakturownia.rb", "config/initializers/fakturownia.rb"
      end
    end
  end
end
