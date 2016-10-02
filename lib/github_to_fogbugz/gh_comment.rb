module GithubToFogbugz

  class GhComment < GhResource

    def user; @resource[:user][:login].downcase; end
    def created_at; @resource[:created_at]; end
    def updated_at; @resource[:updated_at]; end
    def body; @resource[:body]; end

  end

end
