puts 'pg_sequencer railtie'

module PgSequencer
  class Railtie < Rails::Railtie
    initializer "pg_sequencer.load_adapter" do
      puts "pg_sequencer.load_adapter"
      
      ActiveSupport.on_load :active_record do
        require 'pg_sequencer/connection_adapters/postgresql_adapter'
        puts "loaded activerecord"
        
        ActiveRecord::ConnectionAdapters.module_eval do
          include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
        end
      
        ActiveRecord::SchemaDumper.class_eval do
          include PgSequencer::SchemaDumper
        end
        
      end

  #     if defined?(ActiveRecord::Migration::CommandRecorder)
  #       ActiveRecord::Migration::CommandRecorder.class_eval do
  #         include PgSequencer::Migration::CommandRecorder
  #       end
  #     end
  # 
  #     # PgSequencer::Adapter.load!
  #   end
  
    end # initializer
  end
end