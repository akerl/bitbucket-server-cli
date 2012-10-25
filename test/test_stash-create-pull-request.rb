require 'helper'

include Atlassian::Stash
include Atlassian::Stash::Git

class TestStashCreatePullRequest < Test::Unit::TestCase
  
	should "extract project key and repo slug from Stash remote" do
		get_remote_url = "https://sruiz@stash-dev.atlassian.com/scm/STASH/stash.git"
	    cpr = CreatePullRequest.new nil
	    ri = cpr.extract_repository_info
	    assert_equal 'STASH', ri.projectKey
	    assert_equal 'stash', ri.slug
	end

	# should "extracting project key and repo slug from non stash url raises exception" do
	#     get_remote_url = "git@bitbucket.org:sebr/atlassian-stash-rubygem.git"
	#     cpr = CreatePullRequest.new nil
	#     assert_raise(RuntimeError) { cpr.extract_repository_info }
	# end
end
