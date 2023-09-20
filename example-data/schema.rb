# frozen_string_literal: true

require 'ice_nine'

module Schema
  IceNine.deep_freeze(
    USERS = {
      '_id' => { type: 'Integer', 'primary_key' => true },
      'email' => { type: 'String' }
    }.freeze
  )

  # rubocop:disable Metrics/LineLength
  IceNine.deep_freeze(
    SURVEYS = {
      'Email ' => { type: 'String' },
      'Employee Id' => { type: 'String' },
      'Submission time' => { type: 'Time' },
      'I like the kind of work I do.' => { type: 'String' },
      'In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.' =>
      { type: 'String' },
      'We are working at the right pace to meet our goals.' => { type: 'String' },
      'I feel empowered to get the work done for which I am responsible.' => { type: 'String' },
      'I am appropriately involved in decisions that affect my work.' => { type: 'String' },
      # '_id' => { type: 'String', 'primary_key' => true },
      'employee_id' => { type: 'String' },
      'submitted_at' => { type: 'Time' }
      # 'q1' => { type: 'Integer' },
      # 'q2' => { type: 'Integer' },
      # 'q3' => { type: 'Integer' },
      # 'q4' => { type: 'Integer' },
      # 'q5' => { type: 'Integer' },
      # 'q6' => { type: 'Integer' },
      # 'q7' => { type: 'Integer' },
      # 'q8' => { type: 'Integer' },
      # 'q9' => { type: 'Integer' },
      # 'q10' => { type: 'Integer' },
      # 'tags' => { type: 'Array[String]' },
      # 'complete' => { type: 'Boolean' },
      # 'due_at' => { type: 'Time' }
    }.freeze
  )
  # rubocop:enable Metrics/LineLength
end
