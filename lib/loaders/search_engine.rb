# frozen_string_literal: true

require 'dry/monads/do'

module Loaders
  class SearchEngine
    class << self
      include Dry::Monads::Do.for(:call)
      include Dry::Monads[:try, :result]

      def call(output:, load_paths:)
        Dry::Monads::Do.call do
          output.puts('Loading data...')
          data = Dry::Monads::Do.bind load_input_data(load_paths)
          output.puts('Finished loading data!')

          output.puts('Initializing application...')
          search_engine = Dry::Monads::Do.bind ::SearchEngine.init(
            survey_csv: data[:survey_csv]
          )
          output.puts('Finished initializing application!')
          output.puts('==================================')
          output.puts('Welcome to CultureAmp Search')
          Success(search_engine)
        end
      end

      private

      def load_input_data(load_paths)
        Try[Errno::ENOENT] do
          {
            survey_csv: File.read(load_paths[:surveys])
          }
        end.to_result
      end
    end
  end
end
