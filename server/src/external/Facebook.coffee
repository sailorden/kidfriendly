
passport = require('passport')
FacebookStrategy = require('passport-facebook')

class Facebook
  appId: '***REMOVED***'
  appSecret: '***REMOVED***'

  # map of user_id -> facebook token. These are tokens that we've received through passport
  # oauth. Used for displaying on /admin page
  recentTokenForUser: {}

  constructor: ->
    @user = depend('dao/user')
    @http = depend('Http')

    passportOptions =
      clientID: @appId
      clientSecret: @appSecret

    passport.use new FacebookStrategy passportOptions, (accessToken, refreshToken, profile, done) =>
      @findOrCreateFromPassport(profile)
      .then (user) =>
        @recentTokenForUser[user.user_id] = accessToken
        done(null, user)
      .catch (err) =>
        done(err)

    passport.serializeUser (user, done) ->
      done(null, user.user_id)

    passport.deserializeUser (id, done) =>
      @user.findById(id)
      .then (user) -> done(null, user)
      .catch (err) -> done(err)

  findOrCreateFromPassport: (profile) ->
    console.log("Facebook.findOrCreateFromPassport: #{JSON.stringify(profile)}")
    email = profile.emails?[0]?.value
    if not email?
      throw new Error("Email not found")

    @user.findOne((query) -> query.where({email}))
    .then (user) =>
      if user?
        console.log("Found user: #{JSON.stringify(user)}")
        return user

      console.log("findOrCreateFromPassport: creating user for email #{email}")
      @user.insert
        email: email

  validateToken: (token) ->
    url = "https://graph.facebook.com/me?access_token=#{token}"
    @http.request(url: url)
    .then (data) =>
      if data.error?
        throw data.error

      @findOrCreateFromToken(data)

  findOrCreateFromToken: (data) ->
    @user.find((query) -> query.where({facebook_id:data.id}))
    .then (users) =>
      existing = users[0]

      if existing?
        # TODO: We could update the user's email here?
        return existing

      where = (query) -> query.where({email:data.email})
      isNewUser = false

      @user.modifyOrInsert where, (user) =>
        if user.original?
          # Link with an existing user. At the time of this writing (may 2015), linking with an
          # existing user is very rare, it can only happen for users created by using the /admin
          # page. 99% of users will be created with a facebook id.
          console.log("facebook: linking existing user #{user.original.user_id} to facebook id #{data.id}")
          user.facebook_id = data.id
        else
          console.log("facebook: creating new user for facebook id #{data.id}")
          user.first_name = data.first_name
          user.last_name = data.last_name
          user.email = data.email
          user.facebook_id = data.id
          isNewUser = true

      .then (user) ->
        if isNewUser
          console.log("facebook: created new user #{user.user_id} for facebook id #{data.id}")
        user

provide.class(Facebook)
