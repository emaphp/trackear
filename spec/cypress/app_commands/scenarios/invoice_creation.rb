user = CypressOnRails::SmartFactoryWrapper.create(
  :user,
  email: 'invoice@email.com',
  password: 'test123456',
  first_name: 'john',
  last_name: 'doe'
)

project = CypressOnRails::SmartFactoryWrapper.create(
  :project,
  name: 'Testing project'
)

project_contract = CypressOnRails::SmartFactoryWrapper.create(
  :project_contract,
  user: user,
  project: project,
  project_rate: 42,
  user_rate: 42,
  active_from: Date.today,
  ends_at: Date.today + 100.years,
  activity: 'Creator',
  is_admin: true
)

activity_track = CypressOnRails::SmartFactoryWrapper.create(
  :activity_track,
  description: 'Lorem ipsum',
  from: DateTime.now.beginning_of_month,
  to: DateTime.now.beginning_of_month + 30.minutes,
  project_contract: project_contract,
  project_rate: project_contract.project_rate,
  user_rate: project_contract.user_rate,
)
