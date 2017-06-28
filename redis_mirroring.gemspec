# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_mirroring/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_mirroring"
  spec.version       = RedisMirroring::VERSION
  spec.authors       = ['yoshitsugu_fujii']
  spec.email         = ['4429.fujii@gmailcom']

  spec.summary       = %q{単一キーを元にRedisに値が格納されていればRedisから取得し、なければDatabaseから取得}
  spec.description   = %q{
    単一キーをもとにDatabaseのデータをリストとしてredisに保存します。
    取得時にはRedisに値が格納されていればRedisから取得し、なければDatabaseを検索します。
  }
  spec.homepage      = "https://github.com/YoshitsuguFujii/redis_mirroring.git"
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
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry-byebug'

  #spec.add_dependency 'elasticsearch-model'
end
