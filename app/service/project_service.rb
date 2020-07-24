# frozen_string_literal: true

class ProjectService
  def self.clients_from_project(project)
    client_ids = project.project_contracts.where(activity: 'Client').select(:user_id)
    User.where(id: client_ids)
  end
end
