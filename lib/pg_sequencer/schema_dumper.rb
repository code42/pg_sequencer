module PgSequencer
  module SchemaDumper
    extend ActiveSupport::Concern
    
    included do
      puts "schema_dumper included"
      alias_method_chain :tables, :sequences
    end
    
    def tables_with_sequences(stream)
      puts "tables_with_sequences"
      tables_without_sequences(stream)
      sequences(stream)
    end
    
    private
    def sequences(stream)
      sequence_statements = @connection.sequences.map do |sequence|
        # create_sequence "seq_user",
        #   :increment => 1,
        #   :min       => (1|false),
        #   :max       => (20000|false),
        #   :start     => 1,
        #   :cache     => 5,
        #   :cycle     => true
        statement_parts = [ ('add_sequence ') + sequence.name.inspect ]
        statement_parts << (':increment => ' + sequence.options[:increment].inspect)
        statement_parts << (':min => ' + sequence.options[:min].inspect)
        statement_parts << (':max => ' + sequence.options[:max].inspect)
        statement_parts << (':start => ' + sequence.options[:start].inspect)
        statement_parts << (':cache => ' + sequence.options[:cache].inspect)
        statement_parts << (':cycle => ' + sequence.options[:cycle].inspect)
        
        '  ' + statement_parts.join(', ')
      end
      
      stream.puts sequence_statements.sort.join("\n")
      stream.puts
    end
  end
end