# frozen_string_literal: true

unless defined?(Zeitwerk)
  require 'zeitwerk'
  loader = Zeitwerk::Loader.new
  loader.push_dir('lib')
  loader.push_dir('example-data')
  loader.setup
end

class CLI
  def call(arguments: ARGV, out: $stdout, err: $stderr)
    # Your implementation starts here
  end
end
