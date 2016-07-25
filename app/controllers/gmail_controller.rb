class GmailController < ApplicationController

  require 'google/api_client'

  def redirect

      client = Signet::OAuth2::Client.new({
        client_id: Figaro.env.GOOGLE_API_CLIENT_ID,
        client_secret: Figaro.env.GOOGLE_API_CLIENT_SECRET,
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        scope: 'https://www.googleapis.com/auth/gmail.readonly',
        redirect_uri: 'http://localhost:3000/gmail/callback' #url_for(:action => :index)

      })

      redirect_to client.authorization_uri.to_s

  end

  # Paul Massardo
  # created notice
  # Modified by lalala
  # the issue was blah blah
  def callback

      client = Signet::OAuth2::Client.new({
      client_id: Figaro.env.GOOGLE_API_CLIENT_ID,
      client_secret: Figaro.env.GOOGLE_API_CLIENT_SECRET,
      scope: 'https://www.googleapis.com/auth/gmail.readonly',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: 'http://localhost:3000/gmail/callback',
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

    redirect_to url_for(:action => :labels)

  end

  def labels

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
      parameters: {userId: 'me', includeSpamTrash: false}
    )

    @messages = results.data.threads


    @full_messages =[]
    # get one message
    @full_messages << google_api_client.execute!(
        api_method: gmail_api.users.messages.get,
        parameters: {userId: 'me', id: results.data.threads[0].id}
      )

      # emailBytes = Base64.decode64(@full_messages[0].data.payload.parts[0].body.data);
      #
      # @email = emailBytes.unpack('C*').pack('U*')

      @url = "https://mail.google.com/mail/u/0/#" + @full_messages[0].data.labelIds[0].downcase + "/" + @full_messages[0].data.id


# binding.pry


    # results.data.threads.each { |x|
    #
    #   logger.debug x.id
    #
    #   @full_messages << google_api_client.execute!(
    #     api_method: gmail_api.users.messages.get,
    #     parameters: {userId: 'me', id: x.id}
    #   )
    #
    # }


    # the_result = google_api_client.execute!(
    #   api_method: gmail_api.users.messages.get,
    #   parameters: {userId: 'me', id: '1560af47483f07f4'}
    # )



    # @full_messages[0].data.id
    # @full_messages[0].data.snippet
    # @full_messages[0].data.labelIds
    # @full_messages[0].data.payload
    # @full_messages[0].data.payload.headers - array
    # @full_messages[0].data.payload.headers[0] - DeliveredTo name value
    # @full_messages[0].data.payload.headers[1] - Recieved name value
    # @full_messages[0].data.payload.headers[2] - X-Recieved
    # @full_messages[0].data.payload.headers[9] - date time
    # @full_messages[0].data.payload.headers[10] - from text
    # @full_messages[0].data.payload.headers[11] - to text
    # @full_messages[0].data.payload.headers[12] - subject
    # @full_messages[0].data.payload.headers[13] - MIME-Version
    # @full_messages[0].data.payload.headers[14] - content type
    #
    # @full_messages[0].data.payload.body.size - size
    # @full_messages[0].data.payload.parts[0].partId
    # @full_messages[0].data.payload.parts[0].mimeType
    # @full_messages[0].data.payload.parts[0].filename
    # @full_messages[0].data.payload.parts[0].headers[0].name content type
    # @full_messages[0].data.payload.parts[0].headers[1].name transfers encoding
    # @full_messages[0].data.payload.parts[0].body.size
    # @full_messages[0].data.payload.parts[0].body.data
    #
    # @full_messages[0].data.payload.parts[1].partId
    # @full_messages[0].data.payload.parts[1].mimeType
    # @full_messages[0].data.payload.parts[1].filename
    # @full_messages[0].data.payload.parts[1].headers[0].name content type
    # @full_messages[0].data.payload.parts[1].headers[1].name transfers encoding
    # @full_messages[0].data.payload.parts[1].body.size
    # @full_messages[0].data.payload.parts[1].body.data




  end

end

# DATA:{"messages"=>[{"id"=>"156002f11873243d", "threadId"=>"156002f11873243d"}], "resultSizeEstimate"=>1}
# DATA:{"labels"=>[{"id"=>"CATEGORY_PERSONAL", "name"=>"CATEGORY_PERSONAL", "type"=>"system"}]
# DATA:{"threads"=>[{"id"=>"156002f11873243d", "snippet"=>"Hey ibuyvacations, Here are some people we think you might like to follow: Luis Rodriguez @luistweeto Follow Jeff Jamison @CBS11JeffJam Follow em @EmilyBryen Follow Settings | Help | Opt-out This email", "historyId"=>"7578"}], "resultSizeEstimate"=>1}
