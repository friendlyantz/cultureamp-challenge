# frozen_string_literal: true

require 'ice_nine'

module Schema
  IceNine.deep_freeze(
    USERS = {
      '_id' => { type: 'Integer', 'primary_key' => true },
      'email' => { type: 'String' }
    }.freeze
  )

  IceNine.deep_freeze(
    SURVEYS = {
      '_id' => { type: 'String', 'primary_key' => true },
      'employee_id' => { type: 'String' },
      'submitted_at' => { type: 'Time' },
      'q1' => { type: 'Integer' },
      'q2' => { type: 'Integer' },
      'q3' => { type: 'Integer' },
      'q4' => { type: 'Integer' },
      'q5' => { type: 'Integer' },
      'q6' => { type: 'Integer' },
      'q7' => { type: 'Integer' },
      'q8' => { type: 'Integer' },
      'q9' => { type: 'Integer' },
      'q10' => { type: 'Integer' },
      'tags' => { type: 'Array[String]' },
      'complete' => { type: 'Boolean' },
      'due_at' => { type: 'Time' }
    }.freeze
  )
end
