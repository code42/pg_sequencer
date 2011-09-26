module PgSequencer
  module SchemaDumper
    extend ActiveSupport::Concern
    
    included do
      alias_method_chain :tables, :sequences
    end
    
    def tables_with_sequences(stream)
      tables_without_sequences(stream)
      sequences(stream)
    end
    
    private
    def sequences(stream)
      sequence_statements = @connection.sequences.map do |sequence|
        statement_parts = [ ('create_sequence ') + sequence.name.inspect ]
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