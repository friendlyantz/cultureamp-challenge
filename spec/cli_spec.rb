# frozen_string_literal: true

require 'cli'

RSpec.describe CLI do
  it 'parses the input file and writes to the output stream' do
    pending
    args = ['../../example-data/survey.csv', 'participation']

    output = StringIO.new

    expected_output = <<~EXPECTED_OUTPUT
      Participation

      Participants: 6
      Submitted: 5 (83.3%)
    EXPECTED_OUTPUT

    CLI.new.call(arguments: args, out: output)

    expect(output.read).to eq(expected_output)
  end
end
