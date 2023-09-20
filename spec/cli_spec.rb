require "cli"

RSpec.describe CLI do
  it "parses the input file and writes to the output stream" do
    args = ["../../example-data/survey.csv", "participation"]

    output = StringIO.new

    expected_output = <<~EOF
      Participation

      Participants: 6
      Submitted: 5 (83.3%)
    EOF

    CLI.new.call(arguments: args, out: output)

    expect(output.read).to eq(expected_output)
  end
end
