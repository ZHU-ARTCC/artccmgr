# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @groups = Group.all.order(:name)
    authorize @groups
  end

  def create
    authorize Group, :create?
    @group = Group.new

    if @group.update_attributes(permitted_attributes(@group))
      redirect_to groups_path, success: 'Group created'
    else
      flash.now[:alert] = 'Unable to create group'
      render :new
    end
  end

  def destroy
    authorize Group, :destroy?
    @group = policy_scope(Group).friendly.find(params[:id])

    if @group.destroy
      redirect_to groups_path, success: 'Group has been deleted'
    else
      flash[:alert] = 'Unable to delete group'
      render :edit
    end
  end

  def edit
    @group = policy_scope(Group).friendly.find(params[:id])
    authorize @group
  end

  def new
    @group = Group.new
    authorize @group
  end

  def update
    authorize Group, :update?
    @group = policy_scope(Group).friendly.find(params[:id])

    if @group.update_attributes(permitted_attributes(@group))
      redirect_to groups_path, success: 'Group has been updated'
    else
      flash.now[:alert] = 'Unable to update group'
      render :edit
    end
  end
end
