module Nunes
  class Tracer
    class Tag
      def self.from_hash(hash)
        return [] if hash.nil? || hash.empty?
        hash.map { |key, value| new(key, value) }
      end

      attr_reader :key, :value

      def initialize(key, value)
        @key = key.to_sym
        @value = value
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
