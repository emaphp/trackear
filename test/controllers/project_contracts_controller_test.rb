require 'test_helper'

class ProjectContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_contract = project_contracts(:one)
  end

  test "should get index" do
    get project_contracts_url
    assert_response :success
  end

  test "should get new" do
    get new_project_contract_url
    assert_response :success
  end

  test "should create project_contract" do
    assert_difference('ProjectContract.count') do
      post project_contracts_url, params: { project_contract: {  } }
    end

    assert_redirected_to project_contract_url(ProjectContract.last)
  end

  test "should show project_contract" do
    get project_contract_url(@project_contract)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_contract_url(@project_contract)
    assert_response :success
  end

  test "should update project_contract" do
    patch project_contract_url(@project_contract), params: { project_contract: {  } }
    assert_redirected_to project_contract_url(@project_contract)
  end

  test "should destroy project_contract" do
    assert_difference('ProjectContract.count', -1) do
      delete project_contract_url(@project_contract)
    end

    assert_redirected_to project_contracts_url
  end
end
