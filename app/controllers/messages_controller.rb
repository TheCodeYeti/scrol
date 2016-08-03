class MessagesController < ApplicationController
  require 'google/api_client'

  def index
    @messages = current_user.messages
  end

  def show
    @message = messages.find(params[:id])
  end

  def import

    user = User.find(params[:user_id])

    user.authentications.each do |authentication|

      access_token = authentication.oauth_token

      case authentication.provider
      when 'google'
        saveGmailMessages(user, access_token)

      when 'github'
        saveGitHubMessages(user, access_token)
      end

      when 'twitter'
        saveTwitterMessages(user, access_token)
      end

    end

    render :index
  end

  private

  def saveGmailMessages(user, access_token)

    google_api_client = Google::APIClient.new({
      application_name: 'Scrol'
    })

    google_api_client.authorization = Signet::OAuth2::Client.new({
      client_id: Figaro.env.GOOGLE_API_CLIENT_ID,
      client_secret: Figaro.env.GOOGLE_API_CLIENT_SECRET,
      access_token: access_token
    })

    gmail_api = google_api_client.discovered_api('gmail', 'v1')

    results = google_api_client.execute!(
      api_method: gmail_api.users.threads.list,
      parameters: {userId: "me", is: "unread", includeSpamTrash: false}
    )

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
        message.user = user

        msg.data.payload.headers.each do |header|

          if header.name == 'X-Received'

            message.timestamp = DateTime.parse(header.value[header.value.index(';')+1,(header.value.length -  header.value.index(';'))].strip)

          elsif header.name == 'Subject'

            message.title = header.value

          end

        end

        message.save

      end

    end

  end

  def saveGitHubMessages(user, access_token)

    client = Octokit::Client.new(
      {client_id: Figaro.env.GITHUB_CLIENT_ID,
      client_secret: Figaro.env.GITHUB_CLIENT_SECRET})

    client.check_application_authorization access_token

    client = Octokit::Client.new ({access_token: access_token})

    client.user

    msgs = client.notifications({all: true, since: '2012-10-09T23:39:01Z'})  # .map { |m| m[:notifications] }

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
        message.user = user

        message.save

      end

    end

  end

  def saveTwitterMessages(user, access_token)

  end


end
