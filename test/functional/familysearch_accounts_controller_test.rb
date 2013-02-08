require 'test_helper'

class FamilysearchAccountsControllerTest < ActionController::TestCase
  setup do
    @familysearch_account = familysearch_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:familysearch_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create familysearch_account" do
    assert_difference('FamilysearchAccount.count') do
      post :create, familysearch_account: { password: @familysearch_account.password, session_id: @familysearch_account.session_id, session_update: @familysearch_account.session_update, user_id: @familysearch_account.user_id, username: @familysearch_account.username }
    end

    assert_redirected_to familysearch_account_path(assigns(:familysearch_account))
  end

  test "should show familysearch_account" do
    get :show, id: @familysearch_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @familysearch_account
    assert_response :success
  end

  test "should update familysearch_account" do
    put :update, id: @familysearch_account, familysearch_account: { password: @familysearch_account.password, session_id: @familysearch_account.session_id, session_update: @familysearch_account.session_update, user_id: @familysearch_account.user_id, username: @familysearch_account.username }
    assert_redirected_to familysearch_account_path(assigns(:familysearch_account))
  end

  test "should destroy familysearch_account" do
    assert_difference('FamilysearchAccount.count', -1) do
      delete :destroy, id: @familysearch_account
    end

    assert_redirected_to familysearch_accounts_path
  end
end
