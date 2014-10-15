

module Atlassian
  module Stash
    module Git

      DEFAULT_REMOTE="origin"

      def get_current_branch
        %x(git symbolic-ref HEAD)[/refs\/heads\/(.*)/, 1]
      end

      def is_in_git_repository?
        system('git rev-parse')
      end

      def get_remotes
        %x(git remote -v)
      end

      def get_remote_url(remote = DEFAULT_REMOTE)
        remotes = get_remotes
        return nil if remotes.empty?
        origin = remotes.split("\n").collect { |r| r.strip }.grep(/^#{remote}.*\(push\)$/).first
        return nil if origin.nil?
        URI.extract(origin).first
      end

      def ensure_within_git!
        if is_in_git_repository?
          yield
        else
          raise "fatal: Not a git repository"
        end
      end

      def create_git_alias
        %x(git config --global alias.create-pull-request "\!sh -c 'stash pull-request \\$0'")
      end

      def get_repo_root_directory
        %x(git rev-parse --show-toplevel)
      end
    end
  end
end
