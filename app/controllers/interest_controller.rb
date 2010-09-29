class InterestController < ApplicationController
  def index
  end

  def curriculum
  end
  
  def curriculum_pdf
    type = params[:type]
    respond_to do |format|
      format.pdf do
        render  :pdf => "curriculum_#{type}.pdf",
                :template => "interest/_curriculum_#{type}.html.haml",
                :layout => "pdf"
      end
    end
  end

  def employer
  end
end
