class UsersController < ApplicationController

  def create
    @user = User.create(
      cid:    session['devise.vatsim.cid'],
      name_first:   session['devise.vatsim.name_first'],
      name_last:    session['devise.vatsim.name_last'],
      email:        session['devise.vatsim.email'],
      rating:       session['devise.vatsim.rating']['short'],
      reg_date:     session['devise.vatsim.reg_date'],
    )

    sign_in_and_redirect @user
  end

  def new
    @user = User.new
  end

end
