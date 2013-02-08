class FamilysearchAccountsController < ApplicationController
  before_filter :require_login
 
  def test_connection
    unless has_fsa?
      return redirect_to link_fsa_path
    end
  end

  # GET /familysearch_accounts/new
  # GET /familysearch_accounts/new.json
  def new
    @familysearch_account = FamilysearchAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @familysearch_account }
    end
  end

  # POST /familysearch_accounts
  # POST /familysearch_accounts.json
  def create
    if has_fsa?
      @familysearch_account = find_fsa
      @familysearch_account.username = params[:familysearch_account][:username]
      @familysearch_account.password = params[:familysearch_account][:password]
    else
      @familysearch_account = current_user.create_familysearch_account(params[:familysearch_account])
    end

    respond_to do |format|
      if @familysearch_account.save
        format.html { redirect_to test_fsa_connection_path, notice: 'Familysearch account was successfully created.' }
        format.json { render json: @familysearch_account, status: :created, location: @familysearch_account }
      else
        format.html { render action: "new" }
        format.json { render json: @familysearch_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /familysearch_accounts/1
  # DELETE /familysearch_accounts/1.json
  def destroy
    @familysearch_account = find_fsa
    @familysearch_account.destroy

    respond_to do |format|
      format.html { redirect_to link_fsa_path }
      format.json { head :no_content }
    end
  end

  def find_fsa
    begin
      return current_user.familysearch_account
    rescue ActiveRecord::RecordNotFound
      redirect_to connect_path, notice: "Couldn't find your familysearch.org credentials."
    end
  end
end
