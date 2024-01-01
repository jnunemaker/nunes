module Nunes
  class Tracer
    class Tag
      def self.from_hash(hash)
        return [] if hash.nil? || hash.empty?
        hash.map { |key, value| new(key, value) }
      end

      attr_reader :key, :value

      def initialize(key, value)
        raise ArgumentError, "Nunes tag key is required" if key.nil? || key.empty?
        raise ArgumentError, "Nunes tag value is required" if value.nil? || value.to_s.strip.empty?
        @key = key.to_sym
        @value = case value
        when Symbol
          value.to_s
        when TrueClass, FalseClass, Numeric, String
          value
        else
          raise ArgumentError, "Nunes tag value must be a true, false, Numeric, String or Symbol"
        end

      end

      def eql?(other)
        self.class.eql?(other.class) &&
          @key == other.key &&
          @value == other.value
      end
      alias_method :==, :eql?
    end
  end
end
