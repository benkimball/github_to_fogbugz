module GithubToFogbugz

  class Fetcher

    attr_reader :client, :repo

    def initialize
      @repo_name = ENV["REPO"]
      @client = ::Octokit::Client.new :access_token => ENV["ACCESS_TOKEN"]
    end

    def each_issue(limit_or_range=nil)
      index = 1
      limit = nil
      if limit_or_range
        if limit_or_range.respond_to? :first
          index = limit_or_range.first
          limit_or_range = limit_or_range.last
        else
          limit = limit_or_range
        end
      end

      while limit.nil? || (index <= limit) do
        begin
          raw_issue = @client.issue(@repo_name, index)
        rescue Octokit::NotFound
          break
        end
        yield GhIssue.new(raw_issue)
        ix += 1
      end
    end

  end

end
