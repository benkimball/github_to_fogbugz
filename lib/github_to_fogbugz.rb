require "dotenv"
Dotenv.load

require "octokit"
require "faraday-http-cache"
require "fogbugz"
require "redcarpet"

require "github_to_fogbugz/version"
require "github_to_fogbugz/gh_resource"
require "github_to_fogbugz/gh_comment"
require "github_to_fogbugz/gh_event"
require "github_to_fogbugz/gh_issue"
require "github_to_fogbugz/fetcher"
require "github_to_fogbugz/shover"

Octokit.middleware = Faraday::RackBuilder.new do |builder|
  # builder.response :logger
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

module GithubToFogbugz

  class DoIt

    def self.to_it(limit_or_range=nil)
      shover = Shover.new
      Fetcher.new.each_issue(limit_or_range) do |issue|
        puts "processing #{issue.number}"
        begin
          shover.create_case issue
        rescue => e
          puts "problem with #{issue.number}"
        end
        sleep 1
      end
    end

  end

end
