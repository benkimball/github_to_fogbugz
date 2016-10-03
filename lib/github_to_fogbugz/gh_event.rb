module GithubToFogbugz

  class GhEvent < GhResource

    def user; @resource[:actor][:login].downcase; end
    def created_at; @resource[:created_at]; end
    def event; @resource[:event]; end
    def commit_url; @resource[:commit_url]; end
    def assignee; @resource[:assignee][:login].downcase; end

    def assignment?
      event == "assigned"
    end

    def commit?
      (event == "referenced") && commit_url
    end

  end

end
