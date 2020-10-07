# Upload config/master.key file to server
namespace :deploy do
  namespace :check do
    after :deploy, :restart_puma do
      on roles(:app) do
        invoke 'puma:status'
        invoke 'puma:start'
      end
    end
  end
end
