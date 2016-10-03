module GithubToFogbugz

  # i'd rather know a shover than a pusher 'cause a pusher's a jerk
  class Shover

    FOGBUGZ_IDS = {
      'benkimball' => 2,
      'alexhardyliveoak' => 4,
      'loaadmin' => 5,
      'isaax' => 6,
      'srogers' => 7,
      'herestomwiththeweather' => 8,
      'smoothdaddy' => 11
    }
    UNASSIGNED = 3

    def initialize
      @client = Fogbugz::Interface.new({
        :token => ENV["FOGBUGZ_ACCESS_TOKEN"],
        :uri => ENV["FOGBUGZ_URI"]
      })
      @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, :no_intra_emphasis => true)
    end

    def fogbugz_user(name)
      FOGBUGZ_IDS[name] || UNASSIGNED
    end

    def if_not_exists(fb_case)
      result = @client.command :search, :q => fb_case
      if result && result["cases"] && result["cases"]["count"].to_i > 0
        puts "skipping case #{fb_case}: already exists"
      else
        yield
      end
    end

    def create_case(gh_issue)
      fb_case = 1000 + gh_issue.number.to_i
      if_not_exists(fb_case) do
        # create case
        puts "creating case #{fb_case}"
        result = @client.command :new, {
          :ixBug => fb_case,
          :dt => gh_issue.created_at.iso8601,
          :ixProject => 3,
          :sTags => ["github"],
          :sTitle => gh_issue.title,
          :ixPersonEditedBy => fogbugz_user(gh_issue.user),
          :sEvent => @markdown.render(gh_issue.body),
          :fRichText => 1
        }
        if (fb_case = result && result['case'] && result['case']['ixBug'])
          # store comments
          puts "comments"
          gh_issue.comments.each do |gh_comment|
            @client.command :edit, {
              :ixBug => fb_case,
              :sEvent => @markdown.render(gh_comment.body),
              :fRichText => 1,
              :ixPersonEditedBy => fogbugz_user(gh_comment.user),
              :dt => gh_comment.created_at.iso8601
            }
          end

          # store events (assignments and commits only)
          puts "events"
          gh_issue.events.each do |gh_event|
            if gh_event.commit?
              @client.command :edit, {
                :ixBug => fb_case,
                :sEvent => "Related commit: #{gh_event.commit_url}",
                :ixPersonEditedBy => fogbugz_user(gh_event.user),
                :dt => gh_event.created_at.iso8601
              }
            elsif gh_event.assignment?
              @client.command :edit, {
                :ixBug => fb_case,
                :ixPersonEditedBy => fogbugz_user(gh_event.user),
                :dt => gh_event.created_at.iso8601,
                :ixPersonAssignedTo => fogbugz_user(gh_event.assignee)
              }
            end
          end

          if gh_issue.state == "closed" && gh_issue.closed_at
            puts "resolve and close"
            @client.command :resolve, {
              :ixBug => fb_case,
              :dt => gh_issue.closed_at.iso8601
            }
            @client.command :close, {
              :ixBug => fb_case,
              :dt => gh_issue.closed_at.iso8601
            }
          end
        else
          raise "Error from Fogbugz API: #{result}"
        end
      end
    end

  end

end

