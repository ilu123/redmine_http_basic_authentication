require 'account_helper'

module RedmineHttpBasicAuthenticationAccountPatch
      def self.included(base)
        base.send(:include, AccountController)
        base.class_eval do
          unloadable
            alias_method_chain :login, :http_basic
			alias_method_chain :logout, :http_basic
        end
      end

    # Instance methods are here
    module AccountController
		def logout_with_http_basic()
			if User.current.anonymous?
			elsif request.post?
				logout_user
			end
			render :text => "You session is now over, please <a href=\"javascript:window.open('', '_self', '');window.close();\">close your tab/window</a>"
		end
		
        def login_with_http_basic()
			
			if User.current.logged?
				# is the user already logged ?
				redirect_back_or_default my_page_path
				return
			else 
				if request.env['HTTP_AUTHORIZATION']
					if user = authenticate_with_http_basic { |u, p| 
						params[:username] = u 
						params[:password] = p 
						user = User.try_to_login(u,p)
					} 
						#Let redmine do the correct authentication (session stuff)
						authenticate_user unless user.nil?
					else
						request_http_basic_authentication
					end
				else 
					request_http_basic_authentication
					return
				end
			end
			 
		end 
	end
end