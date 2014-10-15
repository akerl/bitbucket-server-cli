require 'helper'

include Atlassian::Stash
include Atlassian::Stash::Git

class TestGit < Minitest::Test

	should "extract remote with ssh remote" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns(
				"origin	ssh://git@stash.atlassian.com:7999/STASH/stash.git (fetch)
				origin	ssh://git@stash.atlassian.com:7999/STASH/stash.git (push)"
				)
		assert_equal 'ssh://git@stash.atlassian.com:7999/STASH/stash.git', Atlassian::Stash::Git.get_remote_url
	end

	should "extract push remote with different fetch and push urls" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns(
				"origin	ssh://git@github.com/~sebr/stash.git (fetch)
				origin	ssh://git@stash.atlassian.com:7999/STASH/stash.git (push)"
				)
		assert_equal 'ssh://git@stash.atlassian.com:7999/STASH/stash.git', Atlassian::Stash::Git.get_remote_url
	end

	should "extract remote with http remote" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns(
				"origin     http://adam@sonoma:7990/stash/scm/QA/stash.git (fetch)
				origin     http://adam@sonoma:7990/stash/scm/QA/stash.git (push)"
				)
		assert_equal 'http://adam@sonoma:7990/stash/scm/QA/stash.git', Atlassian::Stash::Git.get_remote_url
	end

	should "extract remote with multiple remote urls" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns(
				"bitbucket	git@bitbucket.org:atlassian/stash-command-line-tools.git (fetch)
				bitbucket	git@bitbucket.org:atlassian/stash-command-line-tools.git (push)
				kostya  http://admin@kostya:7990/scm/CA/cylon.git (fetch)
				kostya  http://admin@kostya:7990/scm/CA/cylon.git (push)
				local   http://delirium:7990/git/STASH/stash.git (fetch)
				local   http://delirium:7990/git/STASH/stash.git (push)
				origin  ssh://git@stash.atlassian.com:7999/STASH/stash.git (fetch)
				origin  ssh://git@stash.atlassian.com:7999/STASH/stash.git (push)
				seb     http://adam@sonoma:7990/stash/scm/QA/stash.git (fetch)
				seb     http://adam@sonoma:7990/stash/scm/QA/stash.git (push)
				upstream        http://github-enterprise-11-10/stash/stash.git (fetch)
				upstream        http://github-enterprise-11-10/stash/stash.git (push)")
		assert_equal 'ssh://git@stash.atlassian.com:7999/STASH/stash.git', Atlassian::Stash::Git.get_remote_url
	end

	should "extract custom remote with multiple remote urls" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns(
				"bitbucket	git@bitbucket.org:atlassian/stash-command-line-tools.git (fetch)
				bitbucket	git@bitbucket.org:atlassian/stash-command-line-tools.git (push)
				kostya  http://admin@kostya:7990/scm/CA/cylon.git (fetch)
				kostya  http://admin@kostya:7990/scm/CA/cylon.git (push)
				local   http://delirium:7990/git/STASH/stash.git (fetch)
				local   http://delirium:7990/git/STASH/stash.git (push)
				origin  ssh://git@stash.atlassian.com:7999/STASH/stash.git (fetch)
				origin  ssh://git@stash.atlassian.com:7999/STASH/stash.git (push)
				upstream  ssh://git@stash.atlassian.com:7999/ATLASSIAN/stash.git (fetch)
				upstream  ssh://git@stash.atlassian.com:7999/ATLASSIAN/stash.git (push)
				seb     http://adam@sonoma:7990/stash/scm/QA/stash.git (fetch)
				seb     http://adam@sonoma:7990/stash/scm/QA/stash.git (push)
				upstream        http://github-enterprise-11-10/stash/stash.git (fetch)
				upstream        http://github-enterprise-11-10/stash/stash.git (push)")
		assert_equal 'ssh://git@stash.atlassian.com:7999/ATLASSIAN/stash.git', Atlassian::Stash::Git.get_remote_url('upstream')
	end

	should "repo with no remotes returns nil" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns("")
		assert_equal nil, Atlassian::Stash::Git.get_remote_url
	end

	should "repo with unfound remote returns nil" do
		Atlassian::Stash::Git.stubs(:get_remotes).returns(
				"bitbucket	git@bitbucket.org:atlassian/stash-command-line-tools.git (fetch)
				bitbucket	git@bitbucket.org:atlassian/stash-command-line-tools.git (push)"
		)
		assert_equal nil, Atlassian::Stash::Git.get_remote_url('origin')
	end
end