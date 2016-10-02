module GithubToFogbugz

  class GhIssue < GhResource

    def number; @resource[:number]; end
    def title; @resource[:title]; end
    def user; @resource[:user][:login].downcase; end
    def labels; @resource[:labels].map {|l| l[:name] }; end
    def state; @resource[:state]; end
    def created_at; @resource[:created_at]; end
    def updated_at; @resource[:updated_at]; end
    def closed_at; @resource[:closed_at]; end
    def body; @resource[:body]; end
    def assignees; @resource[:assignees].map {|a| a[:login].downcase }; end
    def num_comments; @resource[:comments]; end

    def comments
      @comments ||= begin
        @resource.rels[:comments].get.data.map {|c| GhComment.new(c) }
      end
    end

    def events
      @events ||= begin
        @resource.rels[:events].get.data.map {|e| GhEvent.new(r) }
      end
    end

  end

end
