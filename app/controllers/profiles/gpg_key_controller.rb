# frozen_string_literal: true

class Profiles::GpgKeyController < ApplicationController
  before_action :authenticate_user!
  after_action  :verify_authorized, except: :destroy

  def create
    @gpg_key = GpgKey.new(user: current_user)
    authorize @gpg_key

    if @gpg_key.update_attributes(permitted_attributes(@gpg_key))
      redirect_to profile_gpg_key_path,
                  notice: 'Your GPG/PGP key has been saved'
    else
      flash.now[:alert] = 'Unable to GPG/PGP key'
      render :show
    end
  end

  def destroy
    @gpg_key = current_user.gpg_key
    authorize @gpg_key unless @gpg_key.nil?

    if @gpg_key.nil?
      redirect_to profile_path,
                  notice: 'Your email encryption is already disabled'
    elsif @gpg_key.destroy
      redirect_to profile_path, notice: 'Your GPG/PGP key has been removed'
    else
      redirect_to profile_path, alert: 'Unable to remove your GPG/PGP key'
    end
  end

  def show
    @gpg_key = current_user.gpg_key
    @gpg_key = GpgKey.new(user: current_user) if @gpg_key.nil?
    authorize @gpg_key
  end
end
