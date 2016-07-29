class OauthController < ApplicationController

  require 'google/api_client'

  class User_test

    attr_accessor :user_name
    attr_accessor :twitter
    attr_accessor :gmail
    attr_accessor :outlook
    attr_accessor :github

    def initialize(user_name,twitter = false, gmail=false, outlook = false, github=false )
      @user_name = user_name
      @twitter = twitter
      @gmail = gmail
      @outlook = outlook
      @github = github
    end

  end

  def redirect

    @user = User_test.new('joe',false, false, false, true )
    #
    if (@user.outlook)

      login = get_login_url

      redirect_to login

    end

    if (@user.github)

      # create a  new
      client = Octokit::Client.new()

      # create the URL to redirect the user
      # to allow/deny authorizations
      url_for_client_authorization = client.authorize_url(Figaro.env.GITHUB_CLIENT_ID, {scope: 'notifications'})

      # call the authorization url
      redirect_to url_for_client_authorization

    end

    if (@user.gmail)

      client = Signet::OAuth2::Client.new({
        client_id: Figaro.env.GOOGLE_API_CLIENT_ID,
        client_secret: Figaro.env.GOOGLE_API_CLIENT_SECRET,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        scope: 'https://www.googleapis.com/auth/gmail.readonly',
        redirect_uri: 'http://localhost:3000/oauth/callback?provider=google' #url_for(:action => :index)

      })

      redirect_to client.authorization_uri.to_s

    end

  end

  # Paul Massardo
  def callback_outlook

    callback_handler('outlook')

  end

  # Paul Massardo
  def callback

    callback_handler(params[:provider])

  end

  def results

    provider = params[:provider]

    logger.debug 'results - found' + params[:provider]

    if provider == 'github'

      saveGitHubMessages()

    elsif provider == 'google'

      saveGmailMessages()

    elsif provider == 'outlook'

      saveOutlookMessages()

    end

end


  private

  def saveGmailMessages

    google_api_client = Google::APIClient.new({
      application_name: 'Scrol'
    })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: Figaro.env.GOOGLE_API_CLIENT_ID,
      client_secret: Figaro.env.GOOGLE_API_CLIENT_SECRET,
      access_token: session[:access_token]
    })

    gmail_api = google_api_client.discovered_api('gmail', 'v1')

    results = google_api_client.execute!(
      api_method: gmail_api.users.threads.list,
      parameters: {userId: "me", is: "unread", includeSpamTrash: false}
    )

    @threads = results

    @messages = []

    results.data.threads.each do |thread|

      # check if the thread has already been saved
      if not Message.exists?(message_id: thread.id)

        # if it has not been saved
        # get the message from gmail
        msg = google_api_client.execute!(
              api_method: gmail_api.users.messages.get,
              parameters: {userId: 'me', id: thread.id}
            )

          # save it
          message = Message.new()
          message.snippet = msg.data.snippet
          message.url = "https://mail.google.com/mail/u/0/#" + msg.data.labelIds[0].downcase + "/" + msg.data.id
          message.message_type = 'text'
          message.body = msg
          message.source = 'gmail'
          message.message_id = msg.data.id

          msg.data.payload.headers.each do |header|

            if header.name == 'X-Received'

              message.timestamp = DateTime.parse(header.value[header.value.index(';')+1,(header.value.length -  header.value.index(';'))].strip)

            elsif header.name == 'Subject'

              message.title = header.value

            end

          end

          message.save

          @messages << message

        end

    end

  end

  def saveGitHubMessages

      cached_token = session[:access_token]

      client = Octokit::Client.new(
        {client_id: Figaro.env.GITHUB_CLIENT_ID,
        client_secret: Figaro.env.GITHUB_CLIENT_SECRET})

      client.check_application_authorization cached_token

      client = Octokit::Client.new ({access_token: cached_token})

      client.user

      msgs = client.notifications({all: true, since: '2012-10-09T23:39:01Z'})  # .map { |m| m[:notifications] }

      @messages = []

      msgs.each do |msg|

        if not Message.exists?(message_id: msg.id)

          message = Message.new()
          message.snippet = msg.subject.type + ' ' + msg.repository.owner.login + ' ' + msg.repository.name + ' ' + msg.subject.title
          message.url = msg.repository.html_url
          message.message_type = 'text'
          message.body = msg
          message.source = 'github'
          message.message_id = msg.id
          message.timestamp = msg.updated_at
          message.title = msg.subject.type + ' ' +  msg.repository.owner.login + ' ' + msg.repository.name

          message.save

          @messages<<message

        end

      end

    end

  # method to get outlook email messages based on
  # current user settings
  def saveOutlookMessages

    token = session[:azure_access_token]
    email = session[:user_email]

    # If a token is present in the session, get messages from the inbox
    conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
      # Outputs to the console
      faraday.response :logger
      # Uses the default Net::HTTP adapter
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get do |request|

      # Get messages from the inbox
      # Sort by ReceivedDateTime in descending orderby
      # Get the first 20 results
      request.url '/api/v2.0/Me/Messages?$orderby=ReceivedDateTime desc&$select=ReceivedDateTime,Subject,ReplyTo,Weblink,BodyPreview,From&$top=20'

      request.headers['Authorization'] = "Bearer #{token}"

      request.headers['Accept'] = "application/json"

      request.headers['X-AnchorMailbox'] = email

    end

    # Assign the resulting value to the @messages
    # variable to make it available to the view template.
    msgs = JSON.parse(response.body)['value']

    @messages = []

    msgs.each do |msg|

      if not Message.exists?(message_id: msg['Id'])

        message = Message.new()
        message.snippet = msg['BodyPreview']
        message.url = msg['WebLink']
        message.message_type = 'text'
        message.body = msg
        message.source = 'outlook'
        message.message_id = msg['Id']
        message.timestamp = msg['ReceivedDateTime']
        message.title = msg['Subject']

        message.save

        @messages << message

      end

    end

  end


  def callback_handler(provider)

    if provider == 'outlook'

      logger.debug provider + '- provider'

      logger.debug "auth - gettoken" + params[:code]

      token = get_token_from_code params[:code]

      session[:azure_access_token] = token.token

      session[:user_email] = get_email_from_id_token token.params['id_token']

      # redirect_to mail_index_url

      redirect_to oauth_results_path('outlook')

    elsif provider == 'google'

      logger.debug provider + '- provider'

        client = Signet::OAuth2::Client.new({
        client_id: Figaro.env.GOOGLE_API_CLIENT_ID,
        client_secret: Figaro.env.GOOGLE_API_CLIENT_SECRET,
        scope: 'https://www.googleapis.com/auth/gmail.readonly',
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        redirect_uri: 'http://localhost:3000/oauth/callback?provider=google',
        code: params[:code]
      })

      logger.debug params.inspect + ' - params'

      client.grant_type='authorization_code'

      response = client.fetch_access_token!
      refresh_token = client.refresh_token

      logger.debug refresh_token.inspect + ' - refresh token'

      logger.debug response.inspect + ' - access_token'

      session[:access_token] = response['access_token']

      session[:refresh_token] = refresh_token

      # redirect_to github_results_git_path

      # redirect_to url_for(:action => :labels)
      # redirect_to gmail_labels_path

      redirect_to oauth_results_path('google')

    elsif provider == 'github'

      logger.debug "start - auth git yup"

      # get the session code from the params
      # the was returned from git
      session_code = params[:code] #request.env['rack.request.query_hash']['code']

      # exchange the session_code for the authorization
      # code to be used for this sessiom
      result = Octokit.exchange_code_for_token(session_code, Figaro.env.GITHUB_CLIENT_ID, Figaro.env.GITHUB_CLIENT_SECRET)

      session[:access_token] = result[:access_token]

      logger.debug result.inspect + "end - auth git yup"

      # redirect_to github_results_git_path
      redirect_to oauth_results_path('github')

    end

  end


end


# def callback_outlook
#
#   logger.debug "auth - gettoken" + params[:code]
#
#   token = get_token_from_code params[:code]
#
#   session[:azure_access_token] = token.token
#
#   session[:user_email] = get_email_from_id_token token.params['id_token']
#
#   redirect_to mail_index_url
#
# end

# def callback
#
#   logger.debug "start - auth git yup"
#
#   # get the session code from the params
#   # the was returned from git
#   session_code = params[:code] #request.env['rack.request.query_hash']['code']
#
#   # exchange the session_code for the authorization
#   # code to be used for this sessiom
#   result = Octokit.exchange_code_for_token(session_code, Figaro.env.GITHUB_CLIENT_ID, Figaro.env.GITHUB_CLIENT_SECRET)
#
#   session[:access_token] = result[:access_token]
#
#   logger.debug result.inspect + "end - auth git yup"
#
#   redirect_to github_results_git_path
#
# end

# def results_git
#
#   cached_token = session[:access_token]
#
#   client = Octokit::Client.new(
#     {client_id: Figaro.env.GITHUB_CLIENT_ID,
#     client_secret: Figaro.env.GITHUB_CLIENT_SECRET})
#
#     client.check_application_authorization cached_token
#
#     client = Octokit::Client.new ({access_token: cached_token})
#
#     client.user
#
#     results = client.notifications({all: true, since: '2012-10-09T23:39:01Z'})  # .map { |m| m[:notifications] }
#
#     @messages = []
#
#     results.each do |msg|
#
#       message = Message.new()
#       message.snippet = msg.subject.type + ' ' + msg.repository.owner.login + ' ' + msg.repository.name + ' ' + msg.subject.title
#       message.url = msg.repository.html_url
#       message.message_type = 'text'
#       message.body = msg
#       message.source = 'github'
#       message.message_id = msg.id
#       message.timestamp = msg.updated_at
#       message.title = msg.subject.type + ' ' +  msg.repository.owner.login + ' ' + msg.repository.name
#
#       message.save
#
#       @messages<<message
#
#     end
#
# end
