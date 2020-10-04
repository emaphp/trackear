# Upload config/master.key file to server
namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app) do
        upload! 'config/master.key', "#{shared_path}/config/master.key"
      end
    end
  end
end
