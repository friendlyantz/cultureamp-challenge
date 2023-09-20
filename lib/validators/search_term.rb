# frozen_string_literal: true

module Validators
  class SearchTerm
    class << self
      include Dry::Monads[:result]

      def call(possible_terms:, search_term:)
        if possible_terms.include?(search_term)
          Success()
        else
          Failure(
            Errors::UnknownSearchTerm.new(
              "INVALID SEARCH TERM: #{search_term}"
            )
          )
        end
      end
    end
  end
end
