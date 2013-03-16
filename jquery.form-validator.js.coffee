(($) ->
  $.fn.validateForm = ( options ) ->

    settings = $.extend(
      showRequired          : "<span style=\"color:#CB4721;\"> *</span>"
      requiredLocation      : "label"
      errorMessageLocation  : ".error-message"
      errorStyles           : "input.validation-error { border-color: #CB4721; } label.validation-error { color: #CB4721; } .validation-error { color: #CB4721; } "
      errorMsgStyles        : "{placeholder} { padding: 1em 1.2em 0.6em; line-height: 1.5em; margin: 1em 0; display: none; color: #CB4721; border: 1px solid #FBD3C6; background-color: #FDE4E1; border-radius: 4px; }"
      msgMinLength          : false
      msgMaxLength          : false
      msgInvalidEmail       : false
      msgInvalidPhone       : false
      msgPhoneMinLength     : false
      msgPhoneMaxLength     : false
    , options)

    # Set "this" for reference elsewhere
    self = @

    addStyles         = ->
      styles = new String
      styles += settings.errorStyles unless settings.errorStyles == false
      styles += settings.errorMsgStyles.replace("{placeholder}", settings.errorMessageLocation) unless settings.errorStyles == false || settings.errorMessageLocation == false
      $("<style>#{styles}</style>").appendTo "head" unless styles.length == 0
    
    placeRequired     = ( _e ) ->
      required = _e.data("required")
      _e.prevAll( settings.requiredLocation ).append( settings.showRequired ) if settings.showRequired && required != false

    getLabel          = ( _e ) ->
      dataLabel = _e.data("label")
      label = _e.prevAll("label").html()
      label.replace(settings.showRequired, "")
      label = dataLabel || label.replace(settings.showRequired, "")


    validateString    = ( _e ) ->
      err = checkLength _e
      return err if err

    validateEmail     = ( _e ) ->
      err = checkLength _e
      return err if err

      val     = _e.val()
      match   = val.match("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")

      unless match
        err =
          element   : _e
          message   : settings.msgInvalidEmail || "Invalid Email"
        return err

    validateCheckBox  = ( _e ) ->
      label   = _e.data("label") || getLabel( _e )
      unless _e.prop("checked")
        err =
          element   : _e
          message   : if settings.msgCheckBox then settings.msgCheckBox else "#{label} must be checked"

    validatePassword  = ( _e ) ->
      err = checkLength _e
      return err if err

    validatePhone     = ( _e ) ->
      _e.val _e.val().replace(/[A-Za-z$-]/g, "")
      _e.data("minlength", "10")
      _e.data("maxlength", "10")

      err = checkLength _e, true
      return err if err

    validateNumber    = ( _e ) ->
      val     = _e.val()
      match   = /^[0-9a-zA-Z]+$/.test(val)
      label   = getLabel( _e )

      unless match
        err =
          element   : _e
          message   : "#{label} must be a number"

    checkLength       = ( _e, phone=false ) ->
      return false if _e.data("required") == false

      length     = _e.val().length
      maxLength  = _e.data("maxlength") || false
      minLength  = _e.data("minlength") || false
      label      = _e.data("label")     || _e.prevAll("label").html().replace(settings.showRequired, "")
      
      if length == 0
        err =
          element   : _e
          message   :  "#{label} cannot be empty"
        return err
      else if maxLength && maxLength < length
        err =
          element   : _e
          message   : if phone && settings.msgPhoneMaxLength then settings.msgPhoneMaxLength else if phone then "Phone number must be 10 digits" else if settings.msgMaxLength then settings.msgMaxLength else "#{label} is too long (#{length} > #{maxLength})"
        return err
      else if minLength && minLength > length
        err =
          element   : _e
          message   : if phone && settings.msgPhoneMinLength then settings.msgPhoneMinLength else if phone then "Phone number must be 10 digits" else if settings.msgMinLength then settings.msgMinLength else "#{label} is too short (#{length} > #{minLength})"
        return err
      else
        return false


    checkType         = ( _e ) ->
      type = _e.data("validate")

      switch type
        when "string"     then validateString   _e
        when "number"     then validateNumber   _e
        when "email"      then validateEmail    _e
        when "check_box"  then validateCheckBox _e
        when "password"   then validatePassword _e
        when "phone"      then validatePhone    _e

    showError         = ( err, message ) ->
      err.element.addClass "validation-error"
      err.element.prevAll( settings.requiredLocation ).addClass "validation-error"

      message.append("<div>#{err.message}</div>").show()

    # Add default styles to head
    addStyles()

    # Add required mark to labels
    self.find("[data-validate]").each ->
      placeRequired $(this)

    # Hijack the submit form and validate required fields
    self.on "submit", (e) ->
      self = $(this)
      
      errMsg = $(settings.errorMessageLocation)
      errMsg.empty().hide()

      error = []

      self.find("[data-validate]").each ->
        $(this).removeClass "validation-error"
        $(this).prevAll( settings.requiredLocation ).removeClass "validation-error"

        res = checkType( $(this) )
        error.push res if res

      console.log(error)

      if error.length > 0
        showError err, errMsg for err in error

        return false

      return true

) jQuery