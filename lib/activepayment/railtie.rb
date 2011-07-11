module ActivePayment
  class Railtie < Rails::Railtie

    initializer "setup payment" do
      config_file = Rails.root.join("config", "activepayment.yml")
      if config_file.file?
        ActivePayment::Wirecard::Gateway.config = YAML.load(ERB.new(config_file.read).result)[Rails.env]
      end
    end

    initializer "warn when configuration is missing" do
      config.after_initialize do
        unless Rails.root.join("config", "activepayment.yml").file?
          puts "\nActivePayment config not found. Create a config file at: config/activepayment.yml"
        end
      end
    end

  end
end