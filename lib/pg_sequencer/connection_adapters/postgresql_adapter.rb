module PgSequencer
  module ConnectionAdapters
    module PostgreSQLAdapter
      
      def add_sequence(name, options = {})
        execute create_sequence_sql(name, options)
      end
      
      # CREATE [ TEMPORARY | TEMP ] SEQUENCE name [ INCREMENT [ BY ] increment ]
      #     [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
      #     [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
      #
      # create_sequence "seq_user",
      #   :increment => 1,
      #   :min       => (1|false),
      #   :max       => (20000|false),
      #   :start     => 1,
      #   :cache     => 5,
      #   :cycle     => true
      def create_sequence_sql(name, options = {})
        sql = "CREATE SEQUENCE #{name}"
        sql << " INCREMENT BY #{options[:increment]}" if options[:increment]
        
        sql << case options[:min]
        when nil then ""
        when false then " NO MINVALUE"
        else " MINVALUE #{options[:min]}"
        end
        
        sql << case options[:max]
        when nil then ""
        when false then " NO MAXVALUE"
        else " MAXVALUE #{options[:max]}"
        end
        
        sql << " START WITH #{options[:start]}" if options[:start]
        sql << " CACHE #{options[:cache]}" if options[:cache]
        
        sql << case options[:cycle]
        when nil then ""
        when false then " NO CYCLE"
        else " CYCLE"
        end
        
        sql
      end
      
      def remove_sequence_sql(name)
        "DROP SEQUENCE #{name}"
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