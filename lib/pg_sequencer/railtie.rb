module PgSequencer
  class Railtie < Rails::Railtie
  #   initializer "pg_sequencer.load_adapter" do
  #     ActiveSupport.on_load :active_record do
  #       ActiveRecord::ConnectionAdapters.module_eval do
  #         include PgSequencer::ConnectionAdapters::SchemaStatements
  #         include PgSequencer::ConnectionAdapters::SchemaDefinitions
  #       end
  #     end
  #     
  #     ActiveRecord::SchemaDumper.class_eval do
  #       include PgSequencer::SchemaDumper
  #     end
  #     
  #     if defined?(ActiveRecord::Migration::CommandRecorder)
  #       ActiveRecord::Migration::CommandRecorder.class_eval do
  #         include PgSequencer::Migration::CommandRecorder
  #       end
  #     end
  # 
  #     # PgSequencer::Adapter.load!
  #   end
  # end
  end
end