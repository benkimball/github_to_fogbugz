module GithubToFogbugz

  class Fetcher

    attr_reader :client, :repo

    def initialize
      @repo_name = ENV["GITHUB_REPO"]
      @client = Octokit::Client.new({
        :login => ENV['GITHUB_USERNAME'],
        :password => ENV['GITHUB_PASSWORD']
      })
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
      puts "gathering #{index} through #{limit}"
      while limit.nil? || (index <= limit) do
        begin
          puts index
          yield issue(index)
          index += 1
        rescue Octokit::NotFound
          puts "Could not find issue #{index}; either it does not exist or authentication failed"
          break
        rescue Faraday::TimeoutError
          puts "GitHub API timeout error on issue #{index}: you may have hit your rate limit"
          puts rate_limit
        end
      end
    end

    def rate_limit
      rl = @client.rate_limit
      "#{rl.remaining} of #{rl.limit} requests remaining; resets in #{rl.resets_in} sec"
    rescue
      "Unable to retrieve rate limit"
    end

    def issue(id)
      GhIssue.new(@client.issue(@repo_name, id))
    end

  end

end
