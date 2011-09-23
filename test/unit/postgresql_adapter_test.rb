require 'helper'
require 'pg_sequencer/connection_adapters/postgresql_adapter'

class PostgreSQLAdapterTest < ActiveSupport::TestCase
  include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
  
  test 'create sequence without options should generate proper sql' do
    assert_equal("CREATE SEQUENCE things", create_sequence_sql('things'))
    assert_equal("CREATE SEQUENCE blahs", create_sequence_sql('blahs'))
  end
  
  test "removing a sequence by name" do
    assert_equal("DROP SEQUENCE seq_users", remove_sequence_sql('seq_users'))
    assert_equal("DROP SEQUENCE seq_items", remove_sequence_sql('seq_items'))
  end
  
end
