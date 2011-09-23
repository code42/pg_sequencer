require 'pg_sequencer/connection_adapters/postgresql_adapter'

module PgSequencer
end

require 'pg_sequencer/railtie' if defined?(Rails)