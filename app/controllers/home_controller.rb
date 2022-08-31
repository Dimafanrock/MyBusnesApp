class HomeController < ApplicationController
    skip_before_action :authenticate_user!, only: [:homepage]

    def homepage
    end

    def dashboard
    end
    
end
