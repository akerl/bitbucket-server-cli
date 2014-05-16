require 'helper'

include Atlassian::Stash
include Atlassian::Stash::Git

class TestStashRepoInfo < Minitest::Test

  context "Extract repository info" do
    should "extract project key and repo slug from Stash remote" do
      remote = "https://sruiz@stash-dev.atlassian.com/scm/STASH/stash.git"
      ri = RepoInfo.create nil, remote
      assert_equal 'STASH', ri.projectKey
      assert_equal 'stash', ri.slug
    end

    should "extracting project key and repo slug from non stash url raises exception" do
      remote = "git@bitbucket.org:sebr/atlassian-stash-rubygem.git"
      assert_raises(RuntimeError) { RepoInfo.create nil, remote }
    end

    should "repo with hyphes" do
      remote = "https://sruiz@stash-dev.atlassian.com/scm/s745h/stash-repository.git"
      ri = RepoInfo.create nil, remote
      assert_equal 's745h', ri.projectKey
      assert_equal 'stash-repository', ri.slug
    end
  end

  context "Create repo url" do
    setup do 
      @remote = "https://sruiz@stash-dev.atlassian.com/scm/STASH/stash.git"
    end

    should "create expected repo path" do
      config = {
        'stash_url' => 'https://www.stash.com'
      }
      ri = RepoInfo.create config, @remote
      assert_equal '/projects/STASH/repos/stash', ri.repoPath
    end

    should "create expected repo path with context" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config, @remote
      assert_equal '/foo/projects/STASH/repos/stash', ri.repoPath
    end

    should "create expected repo path with context and query" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config, @remote
      assert_equal '/foo/projects/STASH/repos/stash', ri.repoPath
    end

    should "create expected repo url with no suffix or branch" do
      config = {
        'stash_url' => 'https://www.stash.com'
      }
      ri = RepoInfo.create config, @remote
      assert_equal 'https://www.stash.com/projects/STASH/repos/stash', ri.repoUrl(nil, nil)
    end

    should "create expected repo url with context" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config, @remote
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash', ri.repoUrl(nil, nil)
    end

    should "create expected repo url with path and branch" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config, @remote
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/commits?at=develop', ri.repoUrl('commits', 'develop')
    end

    should "create expected repo url with context, query, path and branch" do
      config = {
        'stash_url' => 'https://www.stash.com/foo?git=ftw'
      }
      ri = RepoInfo.create config, @remote
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/commits?git=ftw&at=develop', ri.repoUrl('commits', 'develop')
    end
  end
end