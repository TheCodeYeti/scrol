
class GithubController < ApplicationController

  def redirect_git

    # create a  new
    client = Octokit::Client.new()

    # create the URL to redirect the user
    # to allow/deny authorizations
    url_for_client_authorization = client.authorize_url(Figaro.env.GITHUB_CLIENT_ID, {scope: 'notifications'})

    # call the authorization url
    redirect_to url_for_client_authorization

  end

  def callback_git

    logger.debug "start - git yup"

    # get the session code from the params
    # the was returned from git
    session_code = params[:code] #request.env['rack.request.query_hash']['code']

    # exchange the session_code for the authorization
    # code to be used for this sessiom
    result = Octokit.exchange_code_for_token(session_code, Figaro.env.GITHUB_CLIENT_ID, Figaro.env.GITHUB_CLIENT_SECRET)


    session[:access_token] = result[:access_token]

    logger.debug result.inspect + "end - git yup"

    redirect_to github_results_git_path

  end


  def results_git

    cached_token = session[:access_token]

    client = Octokit::Client.new(
      {client_id: Figaro.env.GITHUB_CLIENT_ID,
      client_secret: Figaro.env.GITHUB_CLIENT_SECRET})

      logger.debug cached_token + "end - access_token"
      # binding.pry

    begin

      client.check_application_authorization cached_token

      client = Octokit::Client.new ({access_token: cached_token})

      data = client.user

      # binding.pry

      # if client.scopes(session[:access_token]).include? 'notifications'
      #   @result = client.notifications.map { |m| m[:notifications] }
      # end

       @results = client.notifications({all: true, since: '2012-10-09T23:39:01Z'})  # .map { |m| m[:notifications] }

      # @result = client.emails.map { |m| m[:notifications] }

    rescue => e
      # request didn't succeed because the token was revoked so we
      # invalidate the token stored in the session and render the
      # index page so that the user can start the OAuth flow again
      session[:access_token] = nil
      # return authenticate!
    end

  end
end


# <!-- @result[0].id -->
# <!-- @result[0].subject.title - "Invitation to join spencerdossett/polihack from spencerdossett" -->
# <!-- @result[0].subject.type -  "RepositoryInvitation" SUBJECT -->
# <!-- @result[0].repository.name - polohack - repo name SUBJECT-->
# <!-- @result[0].repository.owner.login - repo owner FROM -->
# <!-- @result[0].updated_at - this seems to be created date -->
# <!-- @result[0].repository.html_url - repo url https://github.com/spencerdossett/polihack -->
