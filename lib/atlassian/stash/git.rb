

module Atlassian
  module Stash
    module Git
      def get_current_branch
      %x(git symbolic-ref HEAD)[/refs\/heads\/(.*)/, 1]
      end

      def is_in_git_repository?
        system('git rev-parse')
      end

      def ensure_within_git!
        if is_in_git_repository?
          yield
        else
          raise "You must execute this command in a git repository"
        end
      end
    end
  end
end