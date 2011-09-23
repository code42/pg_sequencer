require 'helper'
require 'pg_sequencer/connection_adapters/postgresql_adapter'

class PostgreSQLAdapterTest < ActiveSupport::TestCase
  include PgSequencer::ConnectionAdapters::PostgreSQLAdapter
  
  test 'create sequence without options' do
    puts "*" * 80
    assert_equal("CREATE SEQUENCE things", create_sequence_sql('things'))
  end
end
