require 'helper'
require 'pg_sequencer/connection_adapters/postgresql_adapter'

class PostgreSQLAdapterTest < ActiveSupport::TestCase
  include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
  
  context "creating sequences" do
    
    context "without options" do
      should "generate the proper SQL" do
        assert_equal("CREATE SEQUENCE things", create_sequence_sql('things'))
        assert_equal("CREATE SEQUENCE blahs", create_sequence_sql('blahs'))
      end
    end
    
    context "with options" do
      context "for :increment" do
        should "include 'INCREMENT BY' in the SQL" do
          assert_equal("CREATE SEQUENCE things INCREMENT BY 1", create_sequence_sql('things', :increment => 1))
          assert_equal("CREATE SEQUENCE things INCREMENT BY 2", create_sequence_sql('things', :increment => 2))
        end
        
        should "not include the option if nil value specified" do
          assert_equal("CREATE SEQUENCE things", create_sequence_sql('things', :increment => nil))
        end
      end
      
      context "for :min" do
        should "include 'MINVALUE' in the SQL if specified" do
          assert_equal("CREATE SEQUENCE things MINVALUE 1", create_sequence_sql('things', :min => 1))
          assert_equal("CREATE SEQUENCE things MINVALUE 2", create_sequence_sql('things', :min => 2))
        end
        
        should "not include 'MINVALUE' in SQL if set to nil" do
          assert_equal("CREATE SEQUENCE things", create_sequence_sql('things', :min => nil))
        end
        
        should "set 'NO MINVALUE' if :min specified as false" do
          assert_equal("CREATE SEQUENCE things NO MINVALUE", create_sequence_sql('things', :min => false))
        end
      end
      
      context "for :max" do
        should "include 'MAXVALUE' in the SQL if specified" do
          assert_equal("CREATE SEQUENCE things MAXVALUE 1", create_sequence_sql('things', :max => 1))
          assert_equal("CREATE SEQUENCE things MAXVALUE 2", create_sequence_sql('things', :max => 2))
        end
        
        should "not include 'MAXVALUE' in SQL if set to nil" do
          assert_equal("CREATE SEQUENCE things", create_sequence_sql('things', :max => nil))
        end
        
        should "set 'NO MAXVALUE' if :min specified as false" do
          assert_equal("CREATE SEQUENCE things NO MAXVALUE", create_sequence_sql('things', :max => false))
        end
      end
      
      context "for :start" do
        should "include 'START WITH' in SQL if specified" do
          assert_equal("CREATE SEQUENCE things START WITH 1", create_sequence_sql('things', :start => 1))
          assert_equal("CREATE SEQUENCE things START WITH 2", create_sequence_sql('things', :start => 2))
          assert_equal("CREATE SEQUENCE things START WITH 500", create_sequence_sql('things', :start => 500))
        end
        
        should "not include 'START WITH' in SQL if specified as nil" do
          assert_equal("CREATE SEQUENCE things", create_sequence_sql('things', :start => nil))
        end
      end
      
      context "for :cache" do
        should "include 'CACHE' in SQL if specified" do
          assert_equal("CREATE SEQUENCE things CACHE 1", create_sequence_sql('things', :cache => 1))
          assert_equal("CREATE SEQUENCE things CACHE 2", create_sequence_sql('things', :cache => 2))
          assert_equal("CREATE SEQUENCE things CACHE 500", create_sequence_sql('things', :cache => 500))
        end
      end
      
      context "for :cycle" do
        should "include 'CYCLE' option if specified" do
          assert_equal("CREATE SEQUENCE things CYCLE", create_sequence_sql('things', :cycle => true))
        end
        
        should "include 'NO CYCLE' option if set as false" do
          assert_equal("CREATE SEQUENCE things NO CYCLE", create_sequence_sql('things', :cycle => false))
        end
        
        should "not include 'CYCLE' statement if specified as nil" do
          assert_equal("CREATE SEQUENCE things", create_sequence_sql('things', :cycle => nil))
        end
      end

      should "be correct" do
        options = {
          :increment => 1,
          :min       => 1,
          :max       => 2_000_000,
          :start     => 1,
          :cache     => 5,
          :cycle     => true
        }
        
        assert_equal(
          "CREATE SEQUENCE things INCREMENT BY 1 MINVALUE 1 MAXVALUE 2000000 START WITH 1 CACHE 5 CYCLE",
          create_sequence_sql("things", options)
        )
      end
    end
    
    
  end
  
  context "dropping sequences" do
    should "generate the proper SQL" do
      assert_equal("DROP SEQUENCE seq_users", remove_sequence_sql('seq_users'))
      assert_equal("DROP SEQUENCE seq_items", remove_sequence_sql('seq_items'))
    end
  end
  
end
