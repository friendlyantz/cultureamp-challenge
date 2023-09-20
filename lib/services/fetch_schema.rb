# frozen_string_literal: true

require 'dry/monads'

module Services
  class FetchSchema
    include Dry::Monads[:try, :result]

    def call(record:)
      case record
      in 'users' | 'surveys' => matched_record
        Try { Schema.const_get(matched_record.upcase) }
          .to_result
          .or(Failure(
                Errors::UnknownSchema.new("schema not found for #{record} record")
              ))
      else
        Failure(
          Errors::UnknownSchema.new("unknown #{record} record")
        )
      end
    end
  end
end
