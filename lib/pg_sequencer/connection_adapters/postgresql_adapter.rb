module PgSequencer
  module ConnectionAdapters
    module PostgreSQLAdapter
      
      def add_sequence(name, options = {})
        # actually execute the SQL to add a sequence
      end
      
      
      # CREATE [ TEMPORARY | TEMP ] SEQUENCE name [ INCREMENT [ BY ] increment ]
      #     [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
      #     [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
      def create_sequence_sql(name, options = {})
        sql = "CREATE SEQUENCE #{name}"
        sql
      end
      
    end
  end
end

# todo: add JDBCAdapter?
[:PostgreSQLAdapter].each do |adapter|
  begin
    ActiveRecord::ConnectionAdapters.const_get(adapter).class_eval do
      include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
    end
  rescue
  end
end