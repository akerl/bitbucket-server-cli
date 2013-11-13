
module Atlassian
  module Util
    module TextUtil
      def convert_branch_name_to_sentence(branch_name)
        return '' if branch_name.nil?

        branch_name = branch_name.to_s
        return '' if branch_name.empty?

        issue_key_regex = /([A-Z]{1,10}-\d+)/
        branch_components = branch_name.split(issue_key_regex);

        parts = branch_components.each_with_index.map { |value, index| 
          (index % 2 === 0) ? value.gsub(/[\-_]/, ' ') : value
        }

        to_sentence_case(parts.join(''))
      end

      def to_sentence_case(str)
        return '' if str.nil?

        str = str.to_s
        return '' if str.empty?

        str[0].upcase + str.slice(1, str.length)
      end
    end
  end
end