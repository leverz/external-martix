#@2016.03.03
#登陆模块#
define "login",(require,exports)->
    #MD5 = require "md5"

    #请求接口#
    request =
        #提交登陆#
        submitLogin: (data)->
            $.ajax
                url:"/login"
                type:'post'
                dataType:'json'
                data: data
                success:(res)->
                    if +res.code is 0
                        $.toast "登陆成功",->
                            location.href = "/fund/home"
                    else
                        $.toast res.msg
    #事件监听#
    listener =
        #登陆#
        login: ->
            data =
                userName: $(".user-name").val()
                password: $(".password").val()
                keep: true
            request.submitLogin data
        event: ->
            #事件#
            $(".submit-login").on "click",->
                listener.login()
            $("input").on "keyup",(e)->
                #回车登陆#
                if e.keyCode is 13 then listener.login()
    init = ->
        $(".user-name").focus()
        $(".login-box").animate "top":0, 600
        listener.event()

    init:init
