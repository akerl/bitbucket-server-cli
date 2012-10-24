require 'json'
require 'net/http'
require 'net/https'
require 'uri'

module Atlassian
  module Stash
    class CreatePullRequestResource
      attr_accessor :resource

      def initialize(projectKey, slug, title, description, source, target)
        repository = {
        'slug' => slug,
        'project' => {
          'key' => projectKey
          }
        }
        fromRef = {
          'id' => source,
          'repository' => repository
        }
        toRef = {
          'id' => target,
          'repository' => repository
        }
        @resource = {
          'title' => title,
          'fromRef' => fromRef,
          'toRef' => toRef
        }
      end
    end

    class CreatePullRequest

      RepoInfo = Struct.new(:projectKey, :slug)

      def extract_repository_info
        output = `git remote -v`.split(/\n/)[0].split(/\t/)[1]
        matchData = output.match(/scm\/(\w+)\/(\w+).git/)

        RepoInfo.new(matchData[1], matchData[2])
      end

      def generate_pull_request_title(source, target)
        output = %x(git log --reverse --format=%s #{target}..#{source}).split(/\n/)[0]
        output || 'Merge \'%s\' into \'%s\'' % [source, target]
      end


      def create_pull_request(source, target)
        puts "Creating PR from #{source} to #{target}"

        Process.exit if not target or not source

        repoInfo = extract_repository_info
        title = generate_pull_request_title source, target
        description = ''

        resource = CreatePullRequestResource.new(repoInfo.projectKey, repoInfo.slug, title, description, source, target).resource

        uri = URI.parse(StashGitConfig::StashUrl)
        prPath = uri.path + '/projects/' + repoInfo.projectKey + '/repos/' + repoInfo.slug + '/pull-requests'

        req = Net::HTTP::Post.new(prPath, initheader = {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
        req.basic_auth StashGitConfig::User, StashGitConfig::Password
        req.body = resource.to_json
        http = Net::HTTP.new(uri.host, uri.port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = true
        response = http.start {|http| http.request(req) }

        if response.code != 201
          responseBody = JSON.parse(response.body)
          if responseBody['errors']
            puts responseBody['errors'][0]['message']
          elsif responseBody['message']
            puts responseBody['message']
          else
            puts 'An unknown error occurred'
            puts response.code
            puts response.body
          end
        else
          responseBody = JSON.parse(response.body)
          prUrl = uri.path + responseBody['id']
          puts "Pull request created successfully: " + prUrl
        end

      end
    end
  end
end
