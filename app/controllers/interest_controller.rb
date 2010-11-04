class InterestController < ApplicationController
  
  layout :check_layout
  
  def index
  end

  def curriculum
  end
  
  def curriculum_pdf
    @document_partial = params[:type]
    respond_to do |format|
      format.pdf do
        data = DocRaptor.create(:name => "#{@document_partial}.pdf", :document_content => render_to_string, :document_type => "pdf", :prince_options => {:baseurl => 'http://www.phoet.de'})
        send_data data, :type => 'application/pdf', :filename => "#{@document_partial}.pdf"
      end
      format.html
    end
  end

  def employer
  end
  
  private 
  
  def check_layout
    action_name == 'curriculum_pdf' ? 'pdf' : 'default'
  end
  
end
