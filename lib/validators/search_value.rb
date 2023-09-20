# frozen_string_literal: true

module Validators
  class SearchValue
    include Dry::Monads[:result]

    def call(type:, value:)
      Parsers::SearchValue
        .call(type:, value:)
        .to_result(
          Errors::InvalidSearchValue.new(
            "INVALID TYPE FOR SEARCH TERM: #{value}"
          )
        )
    end
  end
end
