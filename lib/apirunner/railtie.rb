require 'apirunner'
require 'rails' if defined?(Rails) and Rails.version.match(/^3.+/)

module Apirunner
  if defined?(Rails) and Rails.version.match(/^3.+/)
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/api.rake"
      end
    end
  end
end
