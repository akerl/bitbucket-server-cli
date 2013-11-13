require 'json'
require 'net/https'
require 'uri'
require 'git'
require 'launchy'

module Atlassian
  module Stash
    class CreatePullRequestResource
      attr_accessor :resource

      def initialize(projectKey, slug, title, description, reviewers, source, target)
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
          'description' => description,
          'fromRef' => fromRef,
          'toRef' => toRef
        }

        @resource["reviewers"] = reviewers.collect { |r|
            {
              'user' => {
                'name' => r
              }
            }
        } unless reviewers.empty?
      end
    end

    class CreatePullRequest

      RepoInfo = Struct.new(:projectKey, :slug)

      def initialize(config)
        @config = config
      end

      def extract_repository_info (url = get_remote_url)
        if m = url.match(/\/([a-zA-Z~][a-zA-Z0-9_]*)\/([[:alnum:]][\w\-\.]*).git$/)
          return RepoInfo.new(m[1], m[2])
        end
        raise "Repository does not seem to be hosted in Stash"
      end

      def create_pull_request(source, target, reviewers, options)
        Process.exit if not target or not source

        @source = source
        @target = target

        repoInfo = extract_repository_info

        resource = CreatePullRequestResource.new(repoInfo.projectKey, repoInfo.slug, title, description, reviewers, @source, @target).resource

        username = @config["username"]
        password = @config["password"]
        proxy_addr, proxy_port = parse_proxy(@config["proxy"])

        username = ask("Username: ") unless @config["username"]
        password = ask("Password: ") { |q| q.echo = '*' } unless @config["password"]

        uri = URI.parse(@config["stash_url"])
        prPath = uri.path + '/projects/' + repoInfo.projectKey + '/repos/' + repoInfo.slug + '/pull-requests'
        prPath = uri.query.nil? ? "#{prPath}" : "#{prPath}?#{uri.query}"

        req = Net::HTTP::Post.new(prPath, {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
        req.basic_auth username, password
        req.body = resource.to_json
        http = Net::HTTP.new(uri.host, uri.port, proxy_addr, proxy_port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = uri.scheme.eql?("https")

        response = http.start {|conn| conn.request(req) }

        if not response.is_a? Net::HTTPCreated
          responseBody = JSON.parse(response.body)
          if responseBody['errors']
            responseBody['errors'].collect { |error|
              puts error['message']
              if error['reviewerErrors']
                error['reviewerErrors'].collect { |revError|
                  puts revError['message']
                }
              end
            }
          elsif responseBody['message']
            puts responseBody['message']
          else
            puts 'An unknown error occurred.'
            puts response.code
            puts response.body
          end
        else
          responseBody = JSON.parse(response.body)
          prUri = uri.clone
          prUri.path = prPath + '/' + responseBody['id'].to_s
          puts prUri.to_s

          if @config["open"] || options.open
            Launchy.open prUri.to_s
          end
        end
      end

      private

      def title
        git_commit_messages.lines.first || "Merge '#{@source}' into '#{@target}'"
      end

      def description
        git_commit_messages
      end

      def git_commit_messages
        @commit_messages ||= `git log --reverse --format=%s #{@target}..#{@source}`
      end

      def parse_proxy(conf)
        return nil, nil unless conf

        addr, port = conf.split(":")
        if port =~ /\d+/
          port = port.to_i
        else
          port = nil
        end
        [addr, port]
      end
    end
  end
end

