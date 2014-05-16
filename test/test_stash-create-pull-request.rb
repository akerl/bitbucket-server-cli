require 'helper'

include Atlassian::Stash
include Atlassian::Stash::Git

class TestStashCreatePullRequest < Minitest::Test

  context "#parse_proxy" do
    setup do
      @cpr = CreatePullRequest.new nil
    end

    context 'when proxy_conf is nil' do
      should 'returns [nil, nil]' do
        assert_equal [nil, nil], @cpr.send(:parse_proxy, nil)
      end
    end

    context 'when proxy_conf is blank' do
      should 'returns [nil, nil]' do
        assert_equal [nil, nil], @cpr.send(:parse_proxy, "")
      end
    end

    context 'when proxy_conf is "proxy.example.com"' do
      should 'returns ["proxy.example.com", nil]' do
        assert_equal ["proxy.example.com", nil], @cpr.send(:parse_proxy, "proxy.example.com")
      end
    end

    context 'when proxy_conf is "proxy.example.com:8080"' do
      should 'returns ["proxy.example.com", 8080]' do
        assert_equal ["proxy.example.com", 8080], @cpr.send(:parse_proxy, "proxy.example.com:8080")
      end
    end

    context 'when proxy_conf is "proxy.example.com:foo"' do
      should 'returns ["proxy.example.com", nil]' do
        assert_equal ["proxy.example.com", nil], @cpr.send(:parse_proxy, "proxy.example.com:foo")
      end
    end
  end

  context '#title_and_description' do
    setup do
      @cpr = CreatePullRequest.new nil
      def @cpr.title_from_branch; 'title_from_branch'; end
      def @cpr.git_commit_messages; 'git_commit_messages'; end
      @options = Struct.new(:title, :description)
    end

    context 'with no options' do
      should 'sets default title and description' do
        title, descr = @cpr.send(:title_and_description, @options.new(nil, nil))
        assert_equal title, 'title_from_branch'
        assert_equal descr, 'git_commit_messages'
      end
    end

    context 'with title option' do
      should 'sets custom title and default description' do
        title, descr = @cpr.send(:title_and_description, @options.new('custom title', nil))
        assert_equal title, 'custom title'
        assert_equal descr, 'git_commit_messages'
      end
    end

    context 'with description option' do
      should 'sets default title and custom description' do
        title, descr = @cpr.send(:title_and_description, @options.new(nil, 'custom description'))
        assert_equal title, 'title_from_branch'
        assert_equal descr, 'custom description'
      end
    end

    context 'with both title and description options' do
      should 'sets custom title and description' do
        title, descr = @cpr.send(:title_and_description, @options.new('custom title', 'custom description'))
        assert_equal title, 'custom title'
        assert_equal descr, 'custom description'
      end
    end
  end
end