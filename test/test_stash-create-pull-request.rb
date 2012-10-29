require 'helper'

include Atlassian::Stash
include Atlassian::Stash::Git

class TestStashCreatePullRequest < Test::Unit::TestCase
  
	should "extract project key and repo slug from Stash remote" do
		remote = "https://sruiz@stash-dev.atlassian.com/scm/STASH/stash.git"
	    cpr = CreatePullRequest.new nil
	    ri = cpr.extract_repository_info remote
	    assert_equal 'STASH', ri.projectKey
	    assert_equal 'stash', ri.slug
	end

	should "extracting project key and repo slug from non stash url raises exception" do
	    remote = "git@bitbucket.org:sebr/atlassian-stash-rubygem.git"
	    cpr = CreatePullRequest.new nil
	    assert_raise(RuntimeError) { cpr.extract_repository_info remote }
	end


	should "repo with hyphes" do
		remote = "https://sruiz@stash-dev.atlassian.com/scm/s745h/stash-repository.git"
	    cpr = CreatePullRequest.new nil
	    ri = cpr.extract_repository_info remote
	    assert_equal 's745h', ri.projectKey
	    assert_equal 'stash-repository', ri.slug
	end
end
