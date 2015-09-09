class SessionsController < ApplicationController
    
    def create
      
      
      auth = Authorization.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
        if auth
            session[:user_id] = auth.id
            #@workspace = @client.workspaces.find_all.first
           
            @user = User.find(auth.id)
            if @user.token != auth_hash.credentials.token
                @user.update(token: auth_hash.credentials.token, expires_at: auth_hash.credentials.expires_at)
            end
            if @user.refresh_token != auth_hash.credentials.refresh_token
                @user.update(refresh_token: auth_hash.credentials.refresh_token)
            end
            redirect_to dashboard_path
            #render :text => "Welcome back #{auth_hash.credentials.refresh_token}! You are already signed up."
        else
            user = User.new :name => auth_hash.info.name,
                            :email => auth_hash.info.email,
                            :token => auth_hash.credentials.token,
                            :refresh_token => auth_hash.credentials.refresh_token,
                            :expires_at => auth_hash.credentials.expires_at
            user.authorizations.build   :provider => auth_hash.provider,
                                        :uid => auth_hash.uid
            user.save
            
            render :text => "Hi #{user.name}! You've signed up."
      
        end
    end
    
    protected
    
    def auth_hash
        request.env['omniauth.auth']
    end
    
end
