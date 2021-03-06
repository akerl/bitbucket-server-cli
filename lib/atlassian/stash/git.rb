

module Atlassian
  module Stash
    module Git

      DEFAULT_REMOTE="origin"

      def get_current_branch
        %x(git symbolic-ref HEAD)[/refs\/heads\/(.*)/, 1]
      end

      def get_branches()
        all = %x{git branch --no-color -a}.gsub("*","").gsub(" ", "").split("\n")
        all.select{|x| not x.include? "->"}
      end

      def is_branch?(match)
        all = get_branches
        not all.select{|x| x == match}.empty?
      end

      def is_in_git_repository?
        system('git rev-parse')
      end

      def get_remotes
        %x(git remote -v)
      end

      def get_remote(branch = nil)
        remote_branch = %x(git rev-parse --abbrev-ref --symbolic-full-name #{branch}@{u} 2>/dev/null)
        remote = remote_branch.split('/').first
        remote == "" ? nil : remote
      end

      def get_remote_url(remote=nil)
        remotes = get_remotes
        return nil if remotes.empty?

        remote = DEFAULT_REMOTE if remote.nil? || remote.empty?

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
        %x(git config --global alias.create-pull-request "\!sh -c 'stash pull-request \\$0 \\$@'")
      end

      def get_repo_root_directory
        %x(git rev-parse --show-toplevel)
      end
    end
  end
end
