module HybridForest
  module Errors
    class InvalidStateError < StandardError
      def initialize(message = nil)
        super
      end
    end
  end
end
