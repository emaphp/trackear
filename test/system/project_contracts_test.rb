# frozen_string_literal: true

require 'application_system_test_case'

class ProjectContractsTest < ApplicationSystemTestCase
  setup do
    @project_contract = project_contracts(:one)
  end

  test 'visiting the index' do
    visit project_contracts_url
    assert_selector 'h1', text: 'Project Contracts'
  end

  test 'creating a Project contract' do
    visit project_contracts_url
    click_on 'New Project Contract'

    click_on 'Create Project contract'

    assert_text 'Project contract was successfully created'
    click_on 'Back'
  end

  test 'updating a Project contract' do
    visit project_contracts_url
    click_on 'Edit', match: :first

    click_on 'Update Project contract'

    assert_text 'Project contract was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Project contract' do
    visit project_contracts_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Project contract was successfully destroyed'
  end
end
