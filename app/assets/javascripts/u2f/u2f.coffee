# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->

  # U2F Error Handling
  #
  class U2FError
    constructor: (errorCode, u2fFlowType) ->
      @errorCode      = errorCode
      @message        = @message.bind(@)
      @httpsDisabled  = window.location.protocol != 'https:'
      @u2fFlowType    = u2fFlowType;

    message: ->
      if @errorCode == window.u2f.ErrorCodes.BAD_REQUEST and @httpsDisabled
        return 'U2F only works with HTTPS-enabled websites. Contact your webmaster for details.'
      else if @errorCode == window.u2f.ErrorCodes.DEVICE_INELIGIBLE
        if @u2fFlowType == 'authenticate'
          return 'This device has not been registered with us.'
        if @u2fFlowType == 'register'
          return 'This device has already been registered with us.'
      return 'There was a problem communicating with your device.'

  # U2F Authentication
  #
  if $('#js-authenticate-u2f').length
    class U2FAuthenticate
      constructor: (container, u2fParams, fallbackButton, fallbackUI) ->
        @appId          = u2fParams.app_id
        @challenge      = u2fParams.challenge
        @signRequests   = u2fParams.sign_requests
        @fallbackButton = fallbackButton

        @container  = container

        @renderNotSupported   = @renderNotSupported.bind(@)
        @renderAuthenticated  = @renderAuthenticated.bind(@)
        @renderError          = @renderError.bind(@)
        @renderInProgress     = @renderInProgress.bind(@)
        @renderTemplate       = @renderTemplate.bind(@)
        @authenticate         = @authenticate.bind(@)

        if(@fallbackButton)
          @fallbackButton.addEventListener('click', @switchToFallbackUI.bind(@))

        @templates = {
          notSupported:   '#js-authenticate-u2f-not-supported',
          setup:          '#js-authenticate-u2f-setup',
          inProgress:     '#js-authenticate-u2f-in-progress',
          error:          '#js-authenticate-u2f-error',
          authenticated:  '#js-authenticate-u2f-authenticated'
        }

      start: ->
        if (@isU2FSupported())
          return @renderInProgress()
        @renderNotSupported()

      isU2FSupported: ->
        return window.u2f

      authenticate: ->
        u2f.sign @appId, @challenge, @signRequests, ((_this) ->
          (response) ->
            if response.errorCode
              error = new U2FError(response.errorCode, 'authenticate')
              return _this.renderError(error)
            _this.renderAuthenticated JSON.stringify(response)
        )(this), 10

      renderAuthenticated: (deviceResponse) ->
        console.log 'authenticated'
        console.log deviceResponse
        console.log @form
        @renderTemplate('authenticated')
        $('#js-device-response').val(deviceResponse)
        $('#js-login-u2f-form').submit()
#        @fallbackButton.classList.add('hidden')

      renderError: (error) ->
        @renderTemplate 'error',
          error_message: error.message()
          error_code:    error.errorCode
        return $('#js-u2f-try-again').on('click', @renderInProgress)

      renderInProgress: ->
        @renderTemplate('inProgress')
        return @authenticate()

      renderNotSupported: ->
        @renderTemplate('notSupported')

      renderTemplate: (name, params) ->
        @container.html($(@templates[name]).html())
        if name == 'error'
          $('#js-u2f-error-message').html(params['error_message'] + " {Error Code: " + params['error_code'] + "}")

    authenticate = new U2FAuthenticate($('#js-authenticate-u2f'), gon.u2f)
    authenticate.start()

  # U2F Device Registration
  #
  if $('#js-register-u2f').length
    class U2FRegister
      constructor: (container, u2fParams) ->
        @appId              = u2fParams.app_id
        @registerRequests   = u2fParams.register_requests
        @signRequests       = u2fParams.sign_requests

        @container          = container
        @renderError        = @renderError.bind(@)
        @renderInProgress   = @renderInProgress.bind(@)
        @renderNotSupported = @renderNotSupported.bind(@)
        @renderSetup        = @renderSetup.bind(@)

        @templates = {
          notSupported: '#js-register-u2f-not-supported',
          setup:        '#js-register-u2f-setup',
          inProgress:   '#js-register-u2f-in-progress',
          error:        '#js-register-u2f-error',
          registered:   '#js-register-u2f-registered'
        }
        return

      start: ->
        if (@isU2FSupported())
          return @renderSetup()
        @renderNotSupported()

      isU2FSupported: ->
        return window.u2f

      register: ->
        u2f.register @appId, @registerRequests, @signRequests, ((_this) ->
          (response) ->
            if response.errorCode
              error = new U2FError(response.errorCode, 'register')
              return _this.renderError(error)
            _this.renderRegistered JSON.stringify(response)
        )(this), 10

      renderError: (error) ->
        @renderTemplate 'error',
          error_message: error.message()
          error_code:    error.errorCode
        return $('#js-u2f-try-again').on('click', @renderSetup)

      renderInProgress: ->
        @renderTemplate('inProgress')
        return @register()

      renderNotSupported: ->
        @renderTemplate('notSupported')

      renderRegistered: (deviceResponse) ->
        @renderTemplate('registered')
        return @container.find('#js-device-response').val(deviceResponse)

      renderSetup: ->
        @renderTemplate('setup')
        return $('#js-setup-u2f-device').on('click', @renderInProgress)

      renderTemplate: (name, params) ->
        @container.html($(@templates[name]).html())
        if name == 'error'
          $('#js-u2f-error-message').html(params['error_message'] + " {Error Code: " + params['error_code'] + "}")


    register = new U2FRegister($('#js-register-u2f'), gon.u2f)
    register.start()

