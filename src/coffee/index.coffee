#@2016.03.03
#首页#
define "index",(require,exports)->
    mustache = require "mustache"
    trend    = require "trend"

    #数据下载的两个全局变量
    FILE = 0 #全局文件类型变量
    TABS = ""#list选中的checkbox所代表的参数

    #全局配置#
    PAGE_INDEX   = 1
    PAGE_SIZE    = 30
    SORT_BY      = 999
    DIRECTION    = 1         #0升序 1降序
    PARAM        = ''        #序列化form表单参数
    IS_LOADING   = false     #是否正在加载基金列表#
    CACHE_TH     = ''        #缓存表头，排序失败重置
    TABLE_H      = null      #表格默认高度

    #全局 季度项 Quarter
    QUARTER_ALL = []

    #模板#
    tpl =
        #基金列表#
        fundTR: """
            {{#data}}
                <tr>
                    <td data-code="{{fundCode}}"><a class="fund-name" href="http://matrix.sofund.com/fund/detail?code={{fundCode}}" target="_blank">{{fundName}}</a></td>
                    <td>{{fundCode}}</td>
                    <td>{{yieldMoth1}}%</td>
                    <td>{{yieldMoth3}}%</td>
                    <td>{{yield}}%</td>
                    <td>{{sharpeIndex}}</td>
                    <td>{{volitality}}%</td>
                    <td>{{drawback}}</td>
                    <td>{{fundScale}}亿</td>
                    <td>{{limitDay}}</td>
                    <td>{{instPosRatio}}%</td>
                    <td class="btn-watch"><i class="watchit{{selfFlag}}"></i></td>
                </tr>
            {{/data}}
        """
        #基金首页列表
        indexFund : """
                    <div class="downloadBox">
                        <div class="dTitle clearfix">
                            <div class="dTitleText">数据下载</div>
                            <i class="dIcon dBoxClose"></i>
                        </div>
                        <div class="listContent">
                            <ul>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundIncome"> <label for="fundIncome">基金收益指标</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                            <input type="checkbox" id="fundYe1"> <label for="fundYe1">近1月</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundYe3"> <label for="fundYe3">近3月</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundYe12"> <label for="fundYe12">近1年</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundSharp"> <label for="fundSharp">夏普指数</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundRisk"> <label for="fundRisk">风险指标</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundBo"> <label for="fundBo">波动率</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundBack"> <label for="fundBack">最大回撤</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundLiu"> <label for="fundLiu">流动性</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundSize"> <label for="fundSize">基金规模</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundLimi"> <label for="fundLimi">当日申购限额</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundJigou"> <label for="fundJigou">机构青睐</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundBili"> <label for="fundBili">机构持仓比例</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                            </ul> 
                        </div>
                        <div class="dFooter">
                            <span class="dDownloads dDownload dButton">确认下载</span>
                            <span class="dCancle dButton">取消</span>
                        </div>
                    </div>
                    <div class="mask"></div>
                    """

    #操作函数#
    action =
        #屏幕缩放#
        resizeScreen:->
            mainH = window.innerHeight - 60
            chartH = $(".chart-box").height()
            $(".left-filter").height(mainH-30)
            $(".data-table").height(mainH-chartH)
            TABLE_H = $(".data-table").height()
        #拼接url参数#
        concatParam:()->
            json = [
                "&page=",
                PAGE_INDEX,
                "&pageSize=",
                PAGE_SIZE,
                "&sortedBy=",
                SORT_BY,
                "&sortedDirection=",
                DIRECTION
            ]
            PARAM + json.join("")
        #重置全局变量#
        resetParam:->
            PAGE_INDEX = 1
            PAGE_SIZE = 30
            SORT_BY = 999
            DIRECTION = ''
        #滚动加载#
        scrollLoad:->
            dataTable = $(".data-table")
            scrollTop = dataTable.scrollTop()
            docHeight = dataTable.find("table").height()
            lock = true
            $(".headFix").remove()
            #根据scoll高度是否吸顶表头#
            if (scrollTop > 42) and ($(".headFix").length is 0) and lock
                head = dataTable.find("thead").prop("outerHTML")
                table = """<table class="headFix">#{head}<tbody></tbody></table>"""
                dataTable.append(table).find("thead").eq(1).removeClass(".headItem")#.find("tr").eq(0).hide()
                $(".headFix").find('tr').eq(0).css('background','#202427')
                $.each $(".headItem th"),(i)->
                    $(".headFix").find("thead tr").eq(1).find("th").eq(i).width $(this).width()
                lock = false
            else if scrollTop < 42
                    $(".headFix").remove()
                    lock = true

            if IS_LOADING then return
            if docHeight-scrollTop-600 < 30
                IS_LOADING = true
                PAGE_INDEX++;
                request.getFund(0,0)
        #基金排序#
        fundSort:(sortTag,self,thIndex)->
            switch sortTag
                when "","sort-up"
                    self.removeClass("sort-up").addClass "sort-down"
                    DIRECTION = 1
                when "sort-down"
                    self.removeClass("sort-down").addClass "sort-up"
                    DIRECTION = 0
            SORT_BY = self.data "sort"
            PAGE_INDEX = 1
            request.getFund(1,0,thIndex)



        #数据下载相关函数
        differentiate:()->
            FILE = 7
            $("body").append(tpl.indexFund).css('overflow-y','hidden')
            $(".father-input input:first-child").click ->
                _self = $(this)
                action.selected(_self)
        closeDialog :->
            $(".downloadBox").remove()
            $(".mask").remove()
            $('body').css('overflow-y','auto')
        cancle :->
            $(".downloadBox").remove()
            $(".mask").remove()
            $('body').css('overflow-y','auto')
        selected :(self) ->
            if self.prop("checked") is true
                self.siblings().find("input").prop("checked",true)
            else
                self.siblings().find("input").prop("checked",false)
        #接口函数参照文档
        downloadData :(id)->
            data = 
                file : FILE
                tabs : TABS
            window.open "http://matrix.sofund.com/download/excelnew?"+$.param(data)+"&"+PARAM
            $(".downloadBox").remove()
            $(".mask").remove()
            $('body').css('overflow-y','auto')


    #请求接口#
    request =
        #获取基金#
        getFund: (isSort,isFilter,thIndex)->
            url = "/filter/find/fund?" + action.concatParam()
            $.ajax
                url:url
                type:'get'
                dataType:'json'
                async:false
                success:(res)->
                    if (+res.code is 0) and res.list.length
                        if PAGE_INDEX > res.pageCount then return
                        data =
                            data:res.list
                            drawback:->
                                if @maxDrawback is '0' || '0.00' then '--' else @maxDrawback
                            selfFlag:->
                                if @addFlag then ' watching' else ''
                            # chenStar:->
                            #     if @morningstarScore is 0 then '--' else tpl.chenStar
                            # yinStar:->
                            #     if @galaxyScore is 0 then '--' else tpl.yinStar
                        html = mustache.render(tpl.fundTR,data)
                        if isSort or isFilter
                            $("#fundList").html(html)
                            $(".time-select").html ""
                            $(".compare-select").attr("data-code","CGB1Y").html "对比标的"
                        else
                            $("#fundList").append(html)
                        IS_LOADING = false
                        fundCode  = $("tbody td:first").data "code"
                        if isSort or isFilter 
                            trend.init(fundCode)
                            $('#fundList tr').each (i,n)->
                                $(n).find('td').eq(thIndex).css('color','#ced6e1')
                    else
                        if isSort then $("thead").html CACHE_TH
                        $.toast "暂无数据"
        #添加自选#
        addSelf: (data,selfBtn)->
            $.ajax
                url:"/fund/userfund/add"
                type:'get'
                dataType:'json'
                data: data
                success:(res)->
                    if +res.code is 0
                        selfBtn.addClass "watching"
                    else
                        $.toast res.msg
        #取消自选#
        cancelSelf: (data,selfBtn)->
            $.ajax
                url:"/fund/userfund/del"
                type:'get'
                dataType:'json'
                data: data
                success:(res)->
                    if +res.code is 0
                        selfBtn.removeClass "watching"
                    else
                        $.toast res.msg

    #事件监听#
    listener =
        init:->
            @changeFundType()
            @filterBtn()
            @loadFund()
            @selfOption()
            @fundSort()
            @fundChart()
            @toggleChart()
            @winResize()
            @close()
            @cancle()
            @download()
        #改变基金类型筛选基金#
        changeFundType:->
            $(".fund-type").on "change",->
                $(".submit-filter").trigger "click"
                $(".down-data").off("click").on "click",->
                    action.differentiate()
        #提交筛选#
        filterBtn:->
            $(".submit-filter").on "click",->
                PARAM = $("form").serialize()
                request.getFund 0,1
                $(".down-data").off("click").on "click",->
                    action.differentiate()
        #滚动加载基金#
        loadFund:->
            $(".data-table").on "scroll",->
                action.scrollLoad()
        #自选操作#
        selfOption:->
            $("tbody").on "click",".watchit",->
                self = $(this)
                parent = self.parents("tr")
                data =
                    code:parent.find("td:first").data "code"
                if self.hasClass("watching")
                    request.cancelSelf data,self
                else
                    data.fundName = parent.find(".fund-name").text()
                    request.addSelf data,self
        #基金列表排序#
        fundSort:->
            $(".data-table").on "click","thead th",(e)->
                e.stopPropagation()
                self = $(this)
                CACHE_TH = $("thead").html()
                $(".data-table").scrollTop 0
                if self.parents(".headFix")
                    #将吸顶head的排序标记传给原表头#
                    self = $("thead").eq(0).find("tr").eq(1).find("th").eq(self.index())
                self.siblings().removeClass("sort-up sort-down")
                sortTag =$.trim(self.attr("class").replace("cursor",""))
                thIndex = self.index()
                action.fundSort sortTag,self,thIndex
        #当前点击基金净值走势#
        fundChart:->
            $("table").on "click","tbody tr",(e)->
                e.stopPropagation()
                $('table tr:even').css("background-color","#202427")
                $('table tr:odd').css("background-color","#292f33")
                $(this).css("background-color","#343c42")
                trend.init $(this).find('.fund-name').parent().data("code")
        #收起走势图#
        toggleChart:->
            $(".tabs-icon").on "click",->
                self = $(this)
                dataTable = $(".data-table")
                chartWrap = $(".chart-wrap")
                self.toggleClass "up"
                if self.hasClass("up")
                    dataTable.animate "height": (TABLE_H + 265)
                    chartWrap.animate("height": 0).children().hide()
                else
                    chartWrap.children().show()
                    chartWrap.animate "height": "265px"
                    dataTable.animate "height": TABLE_H
        #浏览器改变动态计算#
        winResize:->
            $(window).resize ->
                action.resizeScreen()


        #数据下载弹窗的相关方法
        close :->
            $("body").on "click",".dBoxClose",->
                action.closeDialog()

        cancle :->
            $("body").on "click",".dCancle",->
                action.cancle()

        download :->
            $("body").off("click",".dDownloads").on "click",".dDownloads",->
                fatherInput = $(".father-input")
                #构建tabs参数
                for i in [0...fatherInput.length]
                    strings = i+":"
                    childInput = fatherInput.eq(i).find(".child-input input:checked")
                    if childInput.length !=0
                        for j in [0...childInput.length]
                            indexs = fatherInput.eq(i).find(".child-input input").index childInput.eq(j)
                            nums = indexs+1
                            if j == childInput.length - 1
                                strings += nums
                            else
                                strings += nums+","

                        if i == fatherInput-1
                            TABS += (strings)
                        else
                            TABS += (strings+";")

                action.downloadData()



    init = ->
        $.menuActive(1)
        $.selfChoose()
        listener.init()
        #第一次手动触发筛选获取基金列表#
        $(".submit-filter").trigger "click"
        action.resizeScreen()

        #默认首项tr为选中态
        $('#fundList').find('tr').eq(0).css("background-color","#343c42")
        $(".down-data").off("click").on "click",->
            action.differentiate()
        
        



    init:init
