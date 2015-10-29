require 'helper'

include Atlassian::Stash
include Atlassian::Stash::Git

class TestStashRepoInfo < Minitest::Test

  context "Extract repository info" do
    should "extract project key and repo slug from Stash remote" do
      Atlassian::Stash::Git.stubs(:get_remotes).returns("origin https://sruiz@stash-dev.atlassian.com/scm/STASH/stash.git (push)")

      ri = RepoInfo.create({})
      assert_equal 'STASH', ri.projectKey
      assert_equal 'stash', ri.slug
    end

    should "extracting project key and repo slug from SSH remote" do
      Atlassian::Stash::Git.stubs(:get_remotes).returns("origin sruiz@stash-dev.atlassian.com:STASH/stash.git (push)")

      ri = RepoInfo.create({})
      assert_equal 'STASH', ri.projectKey
      assert_equal 'stash', ri.slug
    end

    should "repo with hyphes" do
      Atlassian::Stash::Git.stubs(:get_remotes).returns("origin https://sruiz@stash-dev.atlassian.com/scm/s745h/stash-repository.git (push)")
      
      ri = RepoInfo.create({})
      assert_equal 's745h', ri.projectKey
      assert_equal 'stash-repository', ri.slug
    end

    should "extracting project key and repo slug from SSH remote with special repository url" do
      Atlassian::Stash::Git.stubs(:get_remotes).returns("origin https://sruiz@stash-dev.atlassian.com/project.name/stash-repository.git (push)")
      
      ri = RepoInfo.create({})
      assert_equal 'project.name', ri.projectKey
      assert_equal 'stash-repository', ri.slug
    end    
  end

  context "Create repo url" do
    setup do 
      Atlassian::Stash::Git.stubs(:get_remotes).returns("origin https://sruiz@stash-dev.atlassian.com/scm/STASH/stash.git (push)")
    end

    should "create expected repo path" do
      config = {
        'stash_url' => 'https://www.stash.com'
      }
      ri = RepoInfo.create config
      assert_equal '/projects/STASH/repos/stash', ri.repoPath
    end

    should "create expected repo path with context" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config
      assert_equal '/foo/projects/STASH/repos/stash', ri.repoPath
    end

    should "create expected repo path with context and query" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config
      assert_equal '/foo/projects/STASH/repos/stash', ri.repoPath
    end

    should "create expected repo url with no suffix or branch" do
      config = {
        'stash_url' => 'https://www.stash.com'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/projects/STASH/repos/stash', ri.repoUrl(nil, nil)
    end

    should "create expected repo url with context" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash', ri.repoUrl(nil, nil)
    end

    should "create expected repo url with context, branch and filePath" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/browse/path/to/file?at=develop', ri.repoUrl('browse', 'develop', filePath: 'path/to/file')
    end

    should "create expected repo url with context, branch, filePath and lineNumber" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/browse/path/to/file?at=develop#1337', ri.repoUrl('browse', 'develop', filePath: 'path/to/file', lineNumber: 1337)
    end

    should "create expected repo url with path and branch" do
      config = {
        'stash_url' => 'https://www.stash.com/foo'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/commits?at=develop', ri.repoUrl('commits', 'develop')
    end

    should "create expected repo url with context, query, path and branch" do
      config = {
        'stash_url' => 'https://www.stash.com/foo?git=ftw'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/commits?git=ftw&at=develop', ri.repoUrl('commits', 'develop')
    end

    should "create expected repo url with context, query, path, branch and filePath" do
      config = {
        'stash_url' => 'https://www.stash.com/foo?git=ftw'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/browse/path/to/file?git=ftw&at=develop', ri.repoUrl('browse', 'develop', filePath: 'path/to/file')
    end

    should "create expected repo url with context, query, branch, filePath and lineNumber" do
      config = {
        'stash_url' => 'https://www.stash.com/foo?git=ftw'
      }
      ri = RepoInfo.create config
      assert_equal 'https://www.stash.com/foo/projects/STASH/repos/stash/browse/path/to/file?git=ftw&at=develop#1337', ri.repoUrl('browse', 'develop', filePath: 'path/to/file', lineNumber: 1337)
    end
  end
end
