# Copyright (c) 2016 Code42, Inc.

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
require 'helper'

class SchemaDumperTest < ActiveSupport::TestCase

  class SequenceDefinition < Struct.new(:name, :options); end

  class MockConnection
    attr_accessor :sequences

    def initialize(sequences = [])
      @sequences = sequences
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

    def self.dump(conn, stream)
      new(conn).dump(stream)
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

  context "dumping the schema" do
    setup do
      @options = {
        :increment => 1,
        :min       => 1,
        :max       => 2_000_000,
        :start     => 1,
        :cache     => 5,
        :cycle     => true
      }

      @stream = MockStream.new
    end

    should "output all sequences correctly" do
      sequences = ['seq_t_user', 'seq_t_item'].map do |name|
        SequenceDefinition.new(name, @options)
      end

      @conn = MockConnection.new(sequences)

      expected_output = <<-SCHEMAEND
# Fake Schema Header
# (No Tables)
  create_sequence "seq_t_item", :increment => 1, :min => 1, :max => 2000000, :start => 1, :cache => 5, :cycle => true
  create_sequence "seq_t_user", :increment => 1, :min => 1, :max => 2000000, :start => 1, :cache => 5, :cycle => true

# Fake Schema Trailer
SCHEMAEND

      MockSchemaDumper.dump(@conn, @stream)
      assert_equal(expected_output.strip, @stream.to_s)
    end

    context "when min specified as false" do
      setup do
        sequences = ['seq_t_user', 'seq_t_item'].map do |name|
          SequenceDefinition.new(name, @options.merge(:min => false))
        end
        @conn = MockConnection.new(sequences)
      end

      should "properly quote false values in schema output" do
        expected_output = <<-SCHEMAEND
# Fake Schema Header
# (No Tables)
  create_sequence "seq_t_item", :increment => 1, :min => false, :max => 2000000, :start => 1, :cache => 5, :cycle => true
  create_sequence "seq_t_user", :increment => 1, :min => false, :max => 2000000, :start => 1, :cache => 5, :cycle => true

# Fake Schema Trailer
SCHEMAEND

        MockSchemaDumper.dump(@conn, @stream)
        assert_equal(expected_output.strip, @stream.to_s)
      end
    end
  end
end
