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
end