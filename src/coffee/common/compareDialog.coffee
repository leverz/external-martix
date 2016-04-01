#@2016.03.03
#基金对比弹窗模块#
define "compareDialog",(require,exports)->
    mustache  = require "mustache"

    #全局配置#
    CODE_LIST = []
    CONFIG    =
        SELF:""
        TYPE:""
        COMPANY:""
        MANAGER:""

    #操作函数#
    action =
        #arr ->json#
        parseJson: (arr)->
            data =
                key:item for item in arr
        #重置搜索条件#
        resetSearch:->
            CONFIG.SELF = ""
            CONFIG.TYPE = ""
            CONFIG.COMPANY = ""
            CONFIG.MANAGER = ""

    #模板#
    tpl =
        dialog:
             """
            <div id="mask"></div>
            <div id="comapre-dialog" class="clearfix">
                <div class="top">
                    基金对比
                    <div class="search">
                        <input type="text" class="keywords" placeholder="搜索要对比的基金名称或代码">
                        <a href="javascript:void(0);" class="search-btn png"></a>
                    </div>
                </div>

                <div class="left">
                    <ul class="list">
                        <li class="item my-choice" data-type="choice">
                            <div class="name" data-type>我的自选列表<span class="png"></span></div>
                            <ul id="choice-list">
                            </ul>
                        </li>
                        <li class="item fund-type" data-type="fund">
                            <div class="name">证监会基金分类标准 <span class="active png"></span></div>
                            <ul id="type-list" class="clearfix">
                                <li>货币型</li>
                                <li>债券型</li>
                            </ul>
                        </li>
                        <li class="item fund-company" data-type="company">
                            <div class="name">基金管理公司分类标准 <span class="png"></span></div>
                            <ul id="company-list" class="company-list"></ul>
                        </li>
                        
                    </ul>
                </div>
                <div class="middle">
                    <div class="title">候选基金列表</div>
                    <ul class="fund-list clearfix"></ul>
                </div>
                <div class="right">
                    <div class="title">对比列表</div>
                    <ul class="compare-list clearfix"></ul>
                    <a href="javascript:void(0);" class="btn confirm">确定</a>
                    <a href="javascript:void(0);" class="btn cancel">取消</a>
                </div>
                <div class="close png"></div>
            </div>
            """
        selfLi:"""
            {{#company}}<li>{{.}}</li>{{/company}}
            {{#noData}}<li class="no">暂无自选基金</li>{{/noData}}
        """
        companyLi:"""{{#company}}<li>{{.}}</li>{{/company}}"""
        managerLi:"""{{#managers}}<li>{{.}}</li>{{/managers}}"""
        fundLi:
            """
            {{#fundlist}}
                <li code="{{fundcode}}">
                    <div class="fund-name">{{fundname}}</div>
                    <div class="fund-code">{{fundcode}}</div>
                    <a href="javascript:void(0);" class="add-compare">加入对比</a>
                </li>
            {{/fundlist}}
            """
        deleteLi:
            """<li code="{{code}}"><div>{{name}}</div><span class="delete png"></span></li>"""
    #请求接口#
    request =
        #获取左侧菜单数据#
        getMenu:->
            #获取基金公司#
            $.ajax
                url:"/filter/company"
                type:'get'
                dataType:'json'
                success:(res)->
                    if +res.code is 0
                        html = mustache.render tpl.companyLi,res
                        $(".company-list").append html
                    else
                        $.toast res.msg
            #获取基金经理#
            $.ajax
                url:"/filter/managerlist"
                type:'get'
                dataType:'json'
                success:(res)->
                    if +res.code is 0
                        html = mustache.render tpl.managerLi,res
                        $("#manager-list").append html
                    else
                        $.toast res.msg
        #搜索基金#
        searchFund: (data)->
            $.ajax
                url: "/filter/fundlist"
                type:'get'
                dataType:'json'
                data: data
                success:(res)->
                    if +res.code is 0
                        hasInCompare = [] # 已加入对比的基金code
                        $(".compare-list li").each( ->
                            hasInCompare.push $(this).attr("code")
                        )
                        html = mustache.render tpl.fundLi,res
                        $(".fund-list").html html
                        if(hasInCompare.length isnt 0)# 对比列表存在基金
                            hasInCompare.map (one)->
                                $(".fund-list li[code=#{one}]").hide()
                    else
                        $.toast res.msg

    #事件监听#
    listener =
        body: $ "body"
        init: ->
            @toggleMenu()
            @changeType()
            @searchFund()
            @addCompare()
            @delteFund()
            @delteAllFund()
            @submitCompare()
            @closeDialog()
        #手风琴menu#
        toggleMenu: ->
            @body.on "click",".left .name",()->
                self = $ this
                parentLi = self.parent()
                $(".name").removeClass "active"
                self.addClass "active"
                type = parentLi.data "type"
                if type is "choice"
                    data =
                        type:"self"
                        para: host
                        filter:""
                    $(".item li").removeClass("active")
                    request.searchFund data
                else
                    self.find("span").addClass "active"
                    parentLi.siblings().find("span").removeClass "active"
                    parentLi.siblings().find("ul").slideUp()
                    parentLi.find("ul").slideDown()
        #改变左侧类型#
        changeType: ->
            @body.on "click",".item li",->
                self =  $ this
                type = self.parent("ul").attr "id"
                $(".item li").removeClass("active")
                self.addClass("active")
                data =
                    para:self.text()
                    filter:""
                action.resetSearch()
                switch type
                    when "choice-list"
                        CONFIG.SELF = self.text()
                        data.type = "self"
                    when "type-list"
                        CONFIG.TYPE = self.text()
                        data.type = "fund"
                    when "company-list"
                        CONFIG.COMPANY = self.text()
                        data.type = "company"
                request.searchFund data
        #搜索基金#
        searchFund: ->
            @body.on "click",".search-btn",->
                value = $(".keywords").val()
                bool = (CONFIG.SELF is "") and (CONFIG.TYPE is "") and (CONFIG.COMPANY is "") and (CONFIG.MANAGER is "")
                data =
                    filter:value
                if (value is "") and bool then return
                if bool
                    data.type = "all"
                if CONFIG.TYPE isnt ""
                    data.type = "fund"
                    data.para = CONFIG.TYPE
                if CONFIG.COMPANY isnt ""
                    data.type = "company"
                    data.para = CONFIG.COMPANY
                if CONFIG.MANAGER isnt ""
                    data.type = "manager"
                    data.para = CONFIG.MANAGER
                request.searchFund data
        #加入对比#
        addCompare: ->
            @body.off "click",".add-compare"
            @body.on "click",".add-compare",->
                self = $ this
                companyList =  $ ".compare-list" # 对比列表
                fundList = $ ".fund-list" # 候选基金列表
                keywords = $ ".keywords"
                data =
                    name:self.siblings(".fund-name").text()
                    code:self.siblings(".fund-code").text()
                html = mustache.render tpl.deleteLi,data
                if companyList.find("li").length is 6
                    $.toast "最多可添加6支基金对比"
                else
                    self.parent().hide()
                    CODE_LIST.push data.code
                    companyList.append html
                    # fundList.html ""
                    # keywords.val ""
        #删除基金#
        delteFund: ->
            @body.on "click",".delete",->
                parentLi = $(this).parent()
                code = parentLi.attr "code"
                parentLi.remove()
                $(".fund-list").find("""li[code=#{code}]""").show()
                CODE_LIST.splice($.inArray(code,CODE_LIST),1,'')
        #删除全部基金#
        delteAllFund: ->
            @body.on "click",".cancel",->
                $(".compare-list li").remove()
                $(".fund-list li").show()
                CODE_LIST = []
        #提交对比#
        submitCompare: ->
            @body.on "click",".confirm",->
                compareLi = $(".compare-list").find("li")
                switch compareLi.length
                    when 0
                        $.toast "请先添加对比"
                    when 1
                        $.toast "至少需添加2支基金对比"
                    else
                        codeList = ($(item).attr("code") for item in compareLi)
                        $("body .close").trigger "click"
                        window.open "http://matrix.sofund.com//fund/compare?code=" + codeList.join ","

        #关闭弹框#
        closeDialog: ->
            @body.on "click",".close",->
                $("#mask").remove()
                $("#comapre-dialog").remove()
                $('body').css('overflow-y','auto')
                action.resetSearch()
    init = ->
        $("body").append(tpl.dialog).css('overflow-y','hidden')
        listener.init()
        request.getMenu()

    init:init
