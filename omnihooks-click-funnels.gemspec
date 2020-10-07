# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omnihooks-click-funnels/version'

Gem::Specification.new do |spec|
  spec.name          = "omnihooks-click-funnels"
  spec.version       = Omnihooks::ClickFunnels::VERSION
  spec.authors       = ["Karl Falconer"]
  spec.email         = ["karl@getdropstream.com"]

  spec.summary       = %q{Omnihooks Strategy for ClickFunnels Webhooks}
  spec.description   = %q{Omnihooks Strategy for ClickFunnels Webhooks}
  spec.homepage      = "https://github.com/dropstream/omnihooks-click-funnels"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]
  spec.add_dependency 'omnihooks', '~> 0.1.0'
  spec.add_dependency 'multi_json', '~> 1.12'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
