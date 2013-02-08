class TreesController < ApplicationController
  before_filter :require_login

  # GET /trees
  # GET /trees.json
  def index
    @trees = current_user.trees.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trees }
    end
  end

  # GET /trees/1
  # GET /trees/1.json
  def show
    @tree = find_tree(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tree }
    end
  end

  # GET /trees/new
  # GET /trees/new.json
  def new
    @tree = Tree.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tree }
    end
  end

  # GET /trees/1/edit
  def edit
    @tree = find_tree(params[:id])
  end

  # POST /trees
  # POST /trees.json
  def create
    @tree = current_user.trees.build(params[:tree])

    respond_to do |format|
      if @tree.save
        format.html { redirect_to @tree, notice: 'Tree was successfully created.' }
        format.json { render json: @tree, status: :created, location: @tree }
      else
        format.html { render action: "new" }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trees/1
  # PUT /trees/1.json
  def update
    @tree = find_tree(params[:id])

    respond_to do |format|
      if @tree.update_attributes(params[:tree])
        format.html { redirect_to @tree, notice: 'Tree was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1
  # DELETE /trees/1.json
  def destroy
    @tree = find_tree(params[:id])
    @tree.destroy

    respond_to do |format|
      format.html { redirect_to trees_url }
      format.json { head :no_content }
    end
  end

  def sync
    @tree = find_tree(params[:id])
    if logged_in?
      fs_account = current_user.familysearch_account
      unless fs_account.nil?
        if fs_account.fetch_session_id?
          @tree = fs_account.fetch_tree()
        end
      end
    end
  end
  
  protected

  def find_tree(id)
    begin
      return current_user.trees.find(id)
    rescue ActiveRecord::RecordNotFound
      redirect_to trees_path, notice: "Couldn't find tree with id '"+params[:id]+"'."
    end
  end
end
