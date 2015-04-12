require 'rails_helper'

describe Api::SessionsController do

  describe "POST create" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
      @request_params = { user: {
        email: 'valid@email.com',
        password: 'password'
      }}
    end

    it 'returns the user token and email when valid credentials are provided' do
      FactoryGirl.create(:user, authentication_token: 'token')
      post :create, @request_params, @request_headers
      json_response = JSON.parse(response.body)
      expected_response = {"token"=>"token", "email"=>"valid@email.com"}
      expect(json_response).to eq expected_response
    end

    it 'returns nothing when invalid credentials are provided' do
      FactoryGirl.create(:user, password: 'differnt_password', authentication_token: 'token')
      post :create, @request_params, @request_headers
      expect(response.body).to eq 'Invalid email or password.'
    end
  end

end
