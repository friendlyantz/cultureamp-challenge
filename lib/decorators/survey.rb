# frozen_string_literal: true

module Decorators
  class Survey
    class << self
      def call(survey)
        string = ''

        string += "==============\n"
        string += "* Survey for Employee #{survey.send(:'Employee Id')}\n"
        string += decorate_survey_data(survey)

        string += "--- Submitter:\n"
        string += decorate_user(survey.linked_submitter)

        string
      end

      private

      def decorate_survey_data(survey)
        string = ''
        value_mappings = Schema::SURVEYS.keys.map { |attr| [attr, survey[attr.to_sym]] }

        value_mappings.each { |(attr, value)| string += "#{attr.ljust(130, '.')} #{value}\n" }

        string
      end

      def decorate_user(user)
        return '' if user.nil?

        string = ''
        string += ''.rjust(3) + ' name:'.ljust(10) + " #{user[:name]}\n"
        string
      end
    end
  end
end
