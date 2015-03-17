require 'json'
require 'net/https'
require 'uri'
require 'git'
require 'launchy'

include Atlassian::Util::TextUtil

module Atlassian
  module Stash
    class CreatePullRequestResource
      attr_accessor :resource

      def initialize(sourceRepoInfo, targetRepoInfo, title, description, reviewers, source, target)
        src_repository = {
        'slug' => sourceRepoInfo.slug,
        'project' => {
          'key' => sourceRepoInfo.projectKey
          }
        }
        target_repository = {
        'slug' => targetRepoInfo.slug,
        'project' => {
          'key' => targetRepoInfo.projectKey
          }
        }
        fromRef = {
          'id' => source,
          'repository' => src_repository
        }
        toRef = {
          'id' => target,
          'repository' => target_repository
        }
        @resource = {
          'title' => title,
          'fromRef' => fromRef,
          'toRef' => toRef
        }

        @resource["description"] = description unless description.empty?

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

      def initialize(config)
        @config = config
      end

      def create_pull_request(source, target, reviewers, options)
        Process.exit if not target or not source

        @source = source
        @target = target

        @source_ref = source
        if options.src_remote and not options.src_remote.empty?
          @source_ref = options.src_remote + "/" + @source_ref
        end

        @target_ref = target
        if options.target_remote and not options.target_remote.empty?
          @target_ref = options.target_remote + "/" + @target_ref
        end

        srcRepoInfo = RepoInfo.create(@config, options.src_remote)
        targetRepoInfo = RepoInfo.create(@config, options.target_remote)

        title, description = title_and_description(options)

        resource = CreatePullRequestResource.new(srcRepoInfo, targetRepoInfo, title, description, reviewers, @source, @target).resource

        username = @config["username"]
        password = @config["password"]
        proxy_addr, proxy_port = parse_proxy(@config["proxy"])

        username = ask("Username: ") unless @config["username"]
        password = ask("Password: ") { |q| q.echo = '*' } unless @config["password"]

        uri = URI.parse(@config["stash_url"])
        prPath = targetRepoInfo.repoPath + '/pull-requests'

        req = Net::HTTP::Post.new(uri.query.nil? ? "#{prPath}" : "#{prPath}?#{uri.query}", {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
        req.basic_auth username, password
        req.body = resource.to_json
        http = Net::HTTP.new(uri.host, uri.port, proxy_addr, proxy_port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE if @config["ssl_no_verify"]
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
          prUri.query = uri.query
          puts prUri.to_s

          if @config["open"] || options.open
            Launchy.open prUri.to_s
          end
        end
      end

      private

      def title_from_branch
        convert_branch_name_to_sentence(@source) || "Merge '#{@source}' into '#{@target}'"
      end

      def git_commit_messages
        @commit_messages ||= `git log --no-color --reverse --format=%s #{@target_ref}..#{@source_ref}`
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

      def title_and_description(options)
        descr = (options.description or git_commit_messages)
        title = (options.title or title_from_branch)

        [title, descr]
      end
    end
  end
end

