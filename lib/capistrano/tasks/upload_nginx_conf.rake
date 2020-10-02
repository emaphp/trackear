# Upload nginx conf to server
namespace :deploy do
  namespace :check do
    before :linked_files, :upload_nginx_conf do
      on roles(:app) do
        invoke 'puma:nginx_config'
      end
    end
  end
end
