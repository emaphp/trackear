class ProjectService
    def self.clients_from_project(project)
        client_ids = project.project_contracts.where(activity: 'Owner').select(:user_id)
        User.where(id: client_ids)
    end
end