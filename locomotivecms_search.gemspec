$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'locomotive/search/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'locomotivecms_search'
  s.version     = Locomotive::Search::VERSION
  s.authors     = ['Didier Lafforgue']
  s.email       = ['didier@nocoffee.fr']
  s.homepage    = 'https://www.locomotivecms.com'
  s.summary     = 'The LocomotiveCMS search enables advanced search functionalities for each site'
  s.description = 'The LocomotiveCMS search automatically indexes the content of each site. Search engine supported: Algolia'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails',           '>= 5.1.6', '< 6'
  s.add_dependency 'algoliasearch',   '~> 1.27.5'
  s.add_dependency 'elasticsearch',   '~> 7.15.0'
end
