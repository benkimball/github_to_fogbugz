# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_to_fogbugz/version'

Gem::Specification.new do |spec|
  spec.name          = "github_to_fogbugz"
  spec.version       = GithubToFogbugz::VERSION
  spec.authors       = ["Ben Kimball"]
  spec.email         = ["github@benkimball.com"]

  spec.summary       = %q{Imports GitHub issues into FogBugz On Demand.}
  spec.description   = %q{Wraps the GitHub and FogBugz APIs to copy issues from GitHub and insert them as new cases in FogBugz. Probably very fragile, and fairly customized for my specific use case, but may be helpful to those looking for a starting place.}
  spec.homepage      = "https://github.com/benkimball/github_to_fogbugz"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency 'octokit'             # talk to github easily
  spec.add_dependency 'faraday-http-cache'  # cache github responses
  spec.add_dependency 'ruby-fogbugz'        # talk to fogbugz easily
  spec.add_dependency 'dotenv'              # load config from .env file
  spec.add_dependency 'redcarpet'           # convert GH markdown to FB html

end
