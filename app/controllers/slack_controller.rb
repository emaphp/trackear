# frozen_string_literal: true

class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def log
    # return render(status: '400', plain: 'Invalid request') unless SlackService.is_request_from_slack?(request)

    client = Slack::Web::Client.new

    info = client.users_info(user: params[:user_id])
    return render(status: '404', plain: 'User not found') unless info

    email = info.user.profile.email
    user = User.find_by(email: email)
    unless user
      return render(status: '404', plain: 'User with email #{email} not found')
      end

    text_splitted = params[:text].split(' ', 3)

    project_name = text_splitted[0]
    worked_time = text_splitted[1]
    description = text_splitted[2]

    project = user.projects.where('lower(name) = ?', project_name.downcase).first
    unless project
      return render(status: '404', plain: 'Project with name #{project_name} not found')
      end

    time = DateTime.parse(worked_time)

    active_contract = user.currently_active_contract_for(project)
    unless active_contract
      return render(status: '404', plain: 'No active contract found for project #{project_name}')
      end

    active_contract.activity_tracks.create(
      from: DateTime.now.in_time_zone('America/Argentina/Buenos_Aires') - (time.hour * 1.hour) - (time.minute * 1.minute),
      to: DateTime.now.in_time_zone('America/Argentina/Buenos_Aires'),
      description: description
    )
    render(plain: 'Logged successfully')
  end
end
