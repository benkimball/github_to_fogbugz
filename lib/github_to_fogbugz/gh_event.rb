module GithubToFogbugz

  class GhEvent < GhResource

    def user; @resource[:actor][:login].downcase; end
    def created_at; @resource[:created_at]; end
    def event; @resource[:event]; end

  end

end
