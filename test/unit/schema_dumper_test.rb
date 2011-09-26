require 'helper'

class SchemaDumperTest < ActiveSupport::TestCase
  
  class SequenceDefinition < Struct.new(:name, :options); end
  
  class MockConnection
    DEFAULT_OPTIONS = {
      :increment => 1,
      :min       => 1,
      :max       => 2_000_000,
      :start     => 1,
      :cache     => 5,
      :cycle     => true
    }
    
    def sequences
      ['seq_t_user', 'seq_t_item'].map do |name|
        SequenceDefinition.new(name, DEFAULT_OPTIONS)
      end
    end
  end
  
  class MockStream
    attr_accessor :output
    def initialize; @output = []; end
    def puts(str = ""); @output << str; end
    def to_s; @output.join("\n"); end
  end
  
  class MockSchemaDumper
    def initialize(connection)
      @connection = connection
    end
    
    def header(stream)
      stream.puts '# Fake Schema Header'
    end
    
    def tables(stream)
      stream.puts '# (No Tables)'
    end
    
    def dump(stream)
      header(stream)
      tables(stream)
      trailer(stream)
      stream
    end
    
    def trailer(stream)
      stream.puts '# Fake Schema Trailer'
    end
    
    include PgSequencer::SchemaDumper
  end
  
  test "should output all sequences in correct order" do
    @conn = MockConnection.new
    @stream = MockStream.new
    MockSchemaDumper.new(@conn).dump(@stream)
    
    expected_output = <<-SCHEMAEND
# Fake Schema Header
# (No Tables)
  add_sequence "seq_t_item", :increment => 1, :min => 1, :max => 2000000, :start => 1, :cache => 5, :cycle => true
  add_sequence "seq_t_user", :increment => 1, :min => 1, :max => 2000000, :start => 1, :cache => 5, :cycle => true

# Fake Schema Trailer
SCHEMAEND

    assert_equal(expected_output.strip, @stream.to_s)
  end
  
end
