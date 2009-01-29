# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm             :activerecord
use_test            :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '799104a7f56904b0c7163665024e4f72cb89e6be'  # required for cookie session store
  c[:session_id_key] = '_./_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  require File.join( File.dirname(__FILE__), '..', 'lib', 'poor_mans_memecache')
end
 
Merb::BootLoader.after_app_loads do
  Time::DATE_FORMATS[:us_date] = "%D"
  
  Merb::Cache.setup do
    unless exists?(:default)
      register(:default, Merb::Cache::FileStore, :dir => Merb.root / :tmp / :cache) 
    end   
  end
end