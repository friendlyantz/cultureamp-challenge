# frozen_string_literal: true

unless defined?(Zeitwerk)
  require 'zeitwerk'
  loader = Zeitwerk::Loader.new
  loader.push_dir('lib')
  loader.inflector.inflect('cli' => 'CLI')
  loader.push_dir('example-data')
  loader.setup
end

LOAD_PATHS = {
  surveys: 'example-data/survey.csv'
}.freeze

class App
  def initialize(
    load_paths: LOAD_PATHS,
    output: Renderers::Printer.new,
    input: $stdin
  )
    Loaders::UiInterfaceErrors.call(output:) do
      search_engine = Dry::Monads::Do.bind Loaders::SearchEngine.call(output:, load_paths:)

      Loaders::CLI
        .new(search_engine:, input:, output:)
        .call
    end
  end
end
