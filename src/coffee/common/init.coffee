#@2016.03.03
define "common",(require,exports)->
    compare = require "compareDialog"
    filter  = require "filter"
    contact = require "contact"
    dataLoad = require "downloadData"


    #操作函数#
    action =
        #根据屏宽是否展示菜单#
        dealBar: ()->
            winWidth = window.innerWidth
            if winWidth > 1450
                $(".l-side, .r-side").addClass "active"
            else
                listener.showMenu()
        #控制滚动速度#
        ctrlSpeed: (dom)->
            speed = null
            scrollTop = $("html,body").scrollTop()
            top = dom.offset().top - scrollTop
            winH = window.innerHeight/2
            if top<winH
                speed = +top
            else
                speed = 1000
            speed
    #请求接口#
    request =
        moduleView: (scope)->
            url = ""
            code = scope
            if location.href.indexOf("/fund/detail") isnt -1
                url  = "fund/detail/blacklist"
            else
                url = "fundManager/blacklist"
                code = scope - 100
                code = if code>8 then code-1 else code
            $.ajax
                url:"http://matrix.sofund.com/"+url
                type:'post'
                dataType:'json'
                data:
                    scope:code
                success:(res)->

        #退出登陆#
        loginout: ()->
            $.ajax
                url:"/logout"
                type:'get'
                dataType:'json'
                success:(res)->
                    if +res.code is 0
                        location.reload()
                    else
                        $.toast res.msg

    #事件监听#
    listener =
        init:->
            @rightSider()
            @leftSider()
            @headerMenu()
            @showCode()
            @contactBox()
            @downloadTable()
            @downloadData()
            @loginout()

        #登陆登出功能
        loginout:->
            $(".loginout").on "click",->
                request.loginout()
        #二维码显示
        showCode:->
            $(".wechat").hover ()->
                $(".codeBack").show()
            ,()->
                $(".codeBack").hide()
        #联系客服
        contactBox:->
            $('.contact').off('click').on 'click',->
                contact.init()
        #菜单的展示#
        showMenu:->
            #左侧#
            $(".l-side").hover ()->
                $(this).stop().animate({"z-index": 99,"opacity": 1,"left": 0})
            ,()->
                $(this).stop().animate({"z-index": 1,"opacity": 0.4,"left": "-80px"})
                $(this).find(".downloadH2").remove()
                $(this).find(".downloadSide").remove()
                $(this).find(".bottomA").remove()
            #右侧#
            $(".r-side").hover ()->
                $(this).stop().animate({"z-index": 99,"opacity": 1,"right": 0})
            ,()->
                $(this).stop().animate({"z-index": 1,"opacity": 0.4,"right": "-160px"})

        #右侧menu#
        rightSider:->
            $('.side-list').find('li').off('click').on 'click',()->
                self = $(this)
                locate = $('.' + self.data("id"))
                top = locate.offset().top - 80
                speed  = action.ctrlSpeed locate
                $("body,html").animate {"scrollTop":top},speed
            $('.side-list').find('li i').off('click').on 'click',(e)->
                e.stopPropagation()
                self = $ this
                parentLi = self.parent()
                code = parentLi.data "code"
                locate = $('.' + parentLi.data("id"))
                self.toggleClass "active"
                if self.hasClass("active")
                    locate.slideDown()
                else
                    locate.slideUp()
                request.moduleView code
        #左侧menu#
        leftSider:->
            #基金对比#
            $('.compare').off('click').on 'click',()->
                compare.init()
                hostNames = location.href.split("?")[0]
                FundDetail = hostNames.indexOf('/fund/detail') isnt -1
                if(FundDetail)
                    $(".compare-list").append(
                        """<li code="#{fundCode}">
                                <div>#{fundName}</div>
                                <span class="delete png"></span>
                            </li>
                        """
                    )
            #基金筛选#
            $('.filter').off('click').on 'click',()->
                filter.init()

        # 右侧 图标数据导出
        downloadTable:->
            $(".l-side").off("click").on "click",".down-title i",(e)-> # 标题点击
                self = $ this
                nextI = self.parents(".down-title").next().find("li").find("i")
                listTitle1 = self.parents(".down-title").siblings(".listTitle1")
                listTitle2 = self.parents(".down-title").siblings(".listTitle2")
                baseTitle = self.parents(".down-title").siblings(".baseTitle")
                e.stopPropagation()
                if(self.hasClass("active"))
                    self.removeClass("active")
                    nextI.removeClass("active")

                else
                    self.addClass("active")
                    nextI.addClass("active")

            .on 'click',".down-list li i",(e)-> # 列表项点击
                e.stopPropagation()
                self = $ this
                prevI = self.parents(".down-list").prev().find("i")
                if(self.hasClass("active"))
                    self.removeClass("active")
                else
                    self.addClass("active")
                    if(!prevI.hasClass("active"))
                        prevI.addClass("active")


        #数据下载按钮
        downloadData:->
            $(".down-data").off("click").on "click",->
                dataLoad.init()
        #顶部menu选中
        headerMenu:->
            $(".header ul").off("click").on "click","a",()->
                $(this).addClass("active").parent().siblings().find("a").removeClass("active")

    init = ->
        listener.init()
        action.dealBar()

    init:init
