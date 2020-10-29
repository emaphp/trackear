user = CypressOnRails::SmartFactoryWrapper.create(
  :user,
  email: 'project-activty@email.com',
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
