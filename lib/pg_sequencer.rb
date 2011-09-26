require 'active_support/all'

module PgSequencer
  extend ActiveSupport::Autoload
  autoload :SchemaDumper
  
  module ConnectionAdapters
  end
end

require 'pg_sequencer/railtie' if defined?(Rails)