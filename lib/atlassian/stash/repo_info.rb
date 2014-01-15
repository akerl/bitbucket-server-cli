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

      def self.create (config, url = get_remote_url)
        if m = url.match(/\/([a-zA-Z~][a-zA-Z0-9_]*)\/([[:alnum:]][\w\-\.]*).git$/)
          return RepoInfo.new(config, m[1], m[2])
        end
        raise "Repository does not seem to be hosted in Stash; Remote url: " + url
      end
    end
  end
end