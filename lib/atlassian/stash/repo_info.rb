require 'git'

module Atlassian
  module Stash
    class RepoInfo
      def initialize(config, projectKey, slug)
        @config = config
        @projectKey = projectKey
        @slug = slug
      end

      def projectKey
        @projectKey
      end

      def slug
        @slug
      end

      def repoPath
        uri = URI.parse(@config["stash_url"])
        repoPath = uri.path + '/projects/' + @projectKey + '/repos/' + @slug
        repoPath
      end

      def repoUrl(suffix, branch)
        uri = URI.parse(@config["stash_url"])
        path = repoPath + (suffix.nil? ? '' : '/' + suffix)
        uri.path = path
        
        if (!branch.nil? and !branch.empty?)
            q = uri.query || ''
            q = q + (q.empty? ? '' : '&') + 'at=' + branch unless branch.nil?
            uri.query = q
        end

        uri.to_s
      end

      def self.create (config, remote=nil)
        config = Hash.new if config.nil?
        remote = config["remote"] if (remote.nil? || remote.empty?)
        remoteUrl = Atlassian::Stash::Git.get_remote_url(remote)

        if remoteUrl.nil?
          remotes = Atlassian::Stash::Git.get_remotes
          if remotes.empty?
            raise "No git remotes found, could not determine Stash project URL"
          else
            remote = Atlassian::Stash::Git::DEFAULT_REMOTE if (remote.nil? || remote.empty?)
            raise "Could not find requested git remote '#{remote}'. Remotes found: \r\n" + remotes
          end
        end

        if !m = remoteUrl.match(/[\/:]([a-zA-Z~][a-zA-Z0-9_\-\.]*)\/([[:alnum:]][\w\-\.]*).git$/)
          raise "Repository does not seem to be hosted in Stash; Remote url: " + remoteUrl          
        end
        
        return RepoInfo.new(config, m[1], m[2])
      end
    end
  end
end
