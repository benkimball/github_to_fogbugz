module GithubToFogbugz

  class GhResource

    # where +resource+ is a Sawyer resource (returned by Octokit)
    def initialize(resource); @resource = resource; end
    def rels; @resource.rels; end

  end

end
