# Upload config/master.key file to server
namespace :deploy do
  namespace :check do
    before :linked_files, :upload_env do
      on roles(:app) do
        upload! 'env.yml', "#{shared_path}/env.yml"
      end
    end
  end
end
