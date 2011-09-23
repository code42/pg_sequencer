require 'test_helper'

require 'pg_sequencer/connection_adapters/postgresql_adapter'

class PgSequencer::ConnectionAdapters::PostgreSQLAdapterTest < ActiveSupport::TestCase
  include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
  
  test 'create sequence without options' do
    assert_equal("CREATE SEQUENCE things", create_sequence_sql('things'))
  end
end
