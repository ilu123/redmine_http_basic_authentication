Redmine::Plugin.register :redmine_http_basic_authentication do
  name 'Redmine Http Basic Authentication plugin'
  author 'Philippe Buergisser'
  description 'This plugin can perform HTTP authentication for login'
  version '0.0.1'
  url 'http://github.com/pburgisser/redmine_http_basic_authentication'
  author_url 'http://github.com/pburgisser/redmine_http_basic_authentication'
  
  ActionDispatch::Callbacks.to_prepare do
  # use require_dependency if you plan to utilize development mode
    require 'redmine_http_basic_authentication_account_patch'	
 end
end

RedmineApp::Application.config.after_initialize do
# now we should include this module in ApplicationHelper module
        unless AccountController.include? RedmineHttpBasicAuthenticationAccountPatch
            AccountController.send(:include, RedmineHttpBasicAuthenticationAccountPatch)
        end
end
