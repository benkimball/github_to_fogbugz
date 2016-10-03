module GithubToFogbugz

  class Fetcher

    attr_reader :client, :repo

    def initialize
      @repo_name = ENV["GITHUB_REPO"]
      @client = Octokit::Client.new :access_token => ENV["GITHUB_ACCESS_TOKEN"]
      @timeouts = 0
    end

    def each_issue(limit_or_range=nil)
      index = 1
      limit = nil
      if limit_or_range
        if limit_or_range.respond_to? :first
          index = limit_or_range.first
          limit = limit_or_range.last
        else
          limit = limit_or_range
        end
      end

      while limit.nil? || (index <= limit) do
        begin
          puts index
          yield issue(index)
          index += 1
        rescue Octokit::NotFound
          break
        end
      end
    end

    def issue(id)
      i = GhIssue.new(@client.issue(@repo_name, id))
      @timeouts = 0
      i
    rescue Faraday::TimeoutError => e
      @timeouts += 1
      raise e if @timeouts > 5
      puts "github api timeout"
      sleep 10
      issue(id)
    end

  end

end
