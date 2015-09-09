class PagesController < ApplicationController
    
    def index
        if session[:user_id]
            @user = User.find(session[:user_id])
            redirect_to dashboard_path
        end
    end
    
    def auth
        @auth = Authorization.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
        @workspace = auth_hash
        session[:user_id] = @auth.id
    end
    
    def dashboard
        @user = User.find(session[:user_id])
        if @user.expires_at.to_i > Time.now.to_i
            client = Asana::Client.new do |c|
               c.authentication :access_token, @user.token
            end
        else
            client = Asana::Client.new do |c|
                c.authentication :oauth2, @user.refresh_token
            end
        end
        @workspace = client.workspaces.find_by_id(ENV['TITAN_WORKSPACE_ID'])
        @projects = client.projects.find_all(workspace: ENV['TITAN_WORKSPACE_ID'])
       
    end
    
    def projects
        
        @user = User.find(session[:user_id])
        client = Asana::Client.new do |c|
           c.authentication :access_token, @user.token
        end
        @workspace = client.workspaces.find_by_id(ENV['TITAN_WORKSPACE_ID'])
        @projects = client.projects.find_all(workspace: ENV['TITAN_WORKSPACE_ID'])
        
    end
    
    protected
    
    def auth_hash
        request.env['omniauth.auth']
    end
end
