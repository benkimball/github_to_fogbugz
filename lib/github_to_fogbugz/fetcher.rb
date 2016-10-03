module GithubToFogbugz

  class Fetcher

    attr_reader :client, :repo

    def initialize
      @repo_name = ENV["GITHUB_REPO"]
      @client = Octokit::Client.new :access_token => ENV["GITHUB_ACCESS_TOKEN"]
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
          yield issue(index)
          index += 1
        rescue Octokit::NotFound
          break
        end
      end
    end

    def issue(id)
      GhIssue.new(@client.issue(@repo_name, id))
    end

  end

end
