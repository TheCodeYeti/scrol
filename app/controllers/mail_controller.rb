class MailController < ApplicationController
  def index
    token = session[:azure_access_token]
    email = session[:user_email]

    if token

      # If a token is present in the session, get messages from the inbox
      conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
        # Outputs to the console
        faraday.response :logger
        # Uses the default Net::HTTP adapter
        faraday.adapter  Faraday.default_adapter
      end

      response = conn.get do |request|

      # binding.pry

        # Get messages from the inbox
        # Sort by ReceivedDateTime in descending orderby
        # Get the first 20 results
        request.url '/api/v2.0/Me/Messages?$orderby=ReceivedDateTime desc&$select=ReceivedDateTime,Subject,ReplyTo,Weblink,From&$top=20'
        # binding.pry
        request.headers['Authorization'] = "Bearer #{token}"
        # binding.pry
        request.headers['Accept'] = "application/json"
        # binding.pry
        request.headers['X-AnchorMailbox'] = email
        # binding.pry
        # binding.pry

      end

      # binding.pry


      # Assign the resulting value to the @messages
      # variable to make it available to the view template.
      @messages = JSON.parse(response.body)['value']

    else

      # If no token, redirect to the root url so user
      # can sign in.
      redirect_to root_url

    end
  end
end
