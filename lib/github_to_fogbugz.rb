require "octokit"
require "faraday-http-cache"

require "github_to_fogbugz/version"
require "github_to_fogbugz/gh_resource"
require "github_to_fogbugz/gh_comment"
require "github_to_fogbugz/gh_event"
require "github_to_fogbugz/gh_issue"
require "github_to_fogbugz/fetcher"

Octokit.middleware = Faraday::RackBuilder.new do |builder|
  # builder.response :logger
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
