require 'helper'
require 'pg_sequencer/connection_adapters/postgresql_adapter'

class PostgreSQLAdapterTest < ActiveSupport::TestCase
  include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
  
  test 'create sequence without options should generate proper sql' do
    assert_equal("CREATE SEQUENCE things", create_sequence_sql('things'))
    assert_equal("CREATE SEQUENCE blahs", create_sequence_sql('blahs'))
  end
  
end
