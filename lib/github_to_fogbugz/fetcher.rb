module GithubToFogbugz

  class Fetcher

    attr_reader :client, :repo

    def initialize(repo_name, access_token)
      @repo_name = repo_name
      @client = ::Octokit::Client.new :access_token => access_token
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
          puts "fetching issue ##{index}"
          yield GhIssue.new(@client.issue(@repo_name, index))
          index += 1
        rescue Octokit::NotFound
          puts "404 Not Found for issue ##{index}, stopping"
          break
        end
      end
    end

  end

end
