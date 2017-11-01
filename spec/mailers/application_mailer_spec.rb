require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do

  before :each do
    @mailer = ApplicationMailer.new
  end

  it 'defines the default sender address' do
    expect(@mailer.default_params[:from]).to eq 'from@example.com'
  end

end