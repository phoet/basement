require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  it "handles requests" do
    get :index
  end
end
