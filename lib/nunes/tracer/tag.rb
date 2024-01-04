module Nunes
  class Tracer
    class Tag
      def self.from_hash(hash)
        return [] if hash.nil? || hash.empty?

        hash.map { |key, value| new(key, value) }
      end

      attr_reader :key, :value

      def initialize(key, value)
        raise ArgumentError, 'Nunes tag key is required' if key.nil? || key.empty?

        @key = key.to_sym

        raise ArgumentError, "Nunes tag value is required for #{key.inspect}" if value.nil? || value.to_s.strip.empty?

        @value = case value
                 when Symbol
                   value.to_s
                 when TrueClass, FalseClass, Numeric, String
                   value
                 else
                   raise ArgumentError,
                         "Nunes tag value must be a true, false, Numeric, String or Symbol (was #{value.inspect})"
                 end
      end

      def eql?(other)
        self.class.eql?(other.class) &&
          @key == other.key &&
          @value == other.value
      end
      alias == eql?
    end
  end
end
