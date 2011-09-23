require 'helper'
require 'pg_sequencer/connection_adapters/postgresql_adapter'

class PostgreSQLAdapterTest < ActiveSupport::TestCase
  include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
  
  setup do
    @options = {
      :increment => 1,
      :min       => 1,
      :max       => 2_000_000,
      :cache     => 5,
      :cycle     => true
    }
  end
  
  context "generating sequence option SQL" do
    context "for :increment" do
      should "include 'INCREMENT BY' in the SQL" do
        assert_equal(" INCREMENT BY 1", sequence_options_sql(:increment => 1))
        assert_equal(" INCREMENT BY 2", sequence_options_sql(:increment => 2))
      end
      
      should "not include the option if nil value specified" do
        assert_equal("", sequence_options_sql(:increment => nil))
      end
    end
    
    context "for :min" do
      should "include 'MINVALUE' in the SQL if specified" do
        assert_equal(" MINVALUE 1", sequence_options_sql(:min => 1))
        assert_equal(" MINVALUE 2", sequence_options_sql(:min => 2))
      end
      
      should "not include 'MINVALUE' in SQL if set to nil" do
        assert_equal("", sequence_options_sql(:min => nil))
      end
      
      should "set 'NO MINVALUE' if :min specified as false" do
        assert_equal(" NO MINVALUE", sequence_options_sql(:min => false))
      end
    end
    
    context "for :max" do
      should "include 'MAXVALUE' in the SQL if specified" do
        assert_equal(" MAXVALUE 1", sequence_options_sql(:max => 1))
        assert_equal(" MAXVALUE 2", sequence_options_sql(:max => 2))
      end
      
      should "not include 'MAXVALUE' in SQL if set to nil" do
        assert_equal("", sequence_options_sql(:max => nil))
      end
      
      should "set 'NO MAXVALUE' if :min specified as false" do
        assert_equal(" NO MAXVALUE", sequence_options_sql(:max => false))
      end
    end
    
    context "for :start" do
      should "include 'START WITH' in SQL if specified" do
        assert_equal(" START WITH 1", sequence_options_sql(:start => 1))
        assert_equal(" START WITH 2", sequence_options_sql(:start => 2))
        assert_equal(" START WITH 500", sequence_options_sql(:start => 500))
      end
      
      should "not include 'START WITH' in SQL if specified as nil" do
        assert_equal("", sequence_options_sql(:start => nil))
      end
    end
    
    context "for :cache" do
      should "include 'CACHE' in SQL if specified" do
        assert_equal(" CACHE 1", sequence_options_sql(:cache => 1))
        assert_equal(" CACHE 2", sequence_options_sql(:cache => 2))
        assert_equal(" CACHE 500", sequence_options_sql(:cache => 500))
      end
    end
    
    context "for :cycle" do
      should "include 'CYCLE' option if specified" do
        assert_equal(" CYCLE", sequence_options_sql(:cycle => true))
      end
      
      should "include 'NO CYCLE' option if set as false" do
        assert_equal(" NO CYCLE", sequence_options_sql(:cycle => false))
      end
      
      should "not include 'CYCLE' statement if specified as nil" do
        assert_equal("", sequence_options_sql(:cycle => nil))
      end
    end

    should "include all options" do
      assert_equal " INCREMENT BY 1 MINVALUE 1 MAXVALUE 2000000 START WITH 1 CACHE 5 CYCLE", sequence_options_sql(@options.merge(:start => 1))
    end
  end # generating sequence option SQL
  
  context "creating sequences" do
    context "without options" do
      should "generate the proper SQL" do
        assert_equal("CREATE SEQUENCE things", create_sequence_sql('things'))
        assert_equal("CREATE SEQUENCE blahs", create_sequence_sql('blahs'))
      end
    end
    
    context "with options" do
      should "include options at the end" do
        assert_equal("CREATE SEQUENCE things INCREMENT BY 1 MINVALUE 1 MAXVALUE 2000000 START WITH 1 CACHE 5 CYCLE", create_sequence_sql('things', @options.merge(:start => 1)))
      end
    end
  end # creating sequences
  
  context "altering sequences" do
    context "without options" do
      should "return a blank SQL statement" do
        assert_equal("", alter_sequence_sql('things'))
        assert_equal("", alter_sequence_sql('things', {}))
        assert_equal("", alter_sequence_sql('things', nil))
      end
    end
    
    context "with options" do
      
      should "include options at the end" do
        assert_equal("ALTER SEQUENCE things INCREMENT BY 1 MINVALUE 1 MAXVALUE 2000000 RESTART WITH 1 CACHE 5 CYCLE", alter_sequence_sql('things', @options.merge(:restart => 1)))
      end
    end
    
  end # altering sequences
  
  context "dropping sequences" do
    should "generate the proper SQL" do
      assert_equal("DROP SEQUENCE seq_users", drop_sequence_sql('seq_users'))
      assert_equal("DROP SEQUENCE seq_items", drop_sequence_sql('seq_items'))
    end
  end # dropping sequences
  
end
