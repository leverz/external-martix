define "searchFund",(require,exports)->

    #全局配置#
    PAGE_INDEX   = 1
    PAGE_SIZE    = 1000
    SORT_BY      = 999
    DIRECTION    = 1         #0升序 1降序
    PARAM        = ''        #序列化form表单参数
    IS_LOADING   = false     #是否正在加载基金列表#
    CACHE_TH     = ''        #缓存表头，排序失败重置
    TABLE_H      = null      #表格默认高度

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
                        html = ''
                        $.each res.list,(i,item)->
                            if item.addFlag
                                cVar = 'cancelLogo'
                            else
                                cVar = 'addLogo'

                            html += """
                                <tr>
                                    <td class="hasRight"><a href="/fund/detail?code=#{item.fundCode}" data-code="#{item.fundCode}" target="_blank">#{item.fundName}</td>
                                    <td class="hasRight">货币型</td>
                                    <td>#{item.yieldMoth1}%</td>
                                    <td>#{item.yieldMoth3}%</td>
                                    <td>#{item.yield}%</td>
                                    <td class="hasRight">#{item.sharpeIndex}</td>
                                    <td>#{item.volitality}%</td>
                                    <td class="hasRight">#{item.maxDrawback}</td>
                                    <td class="hasRight">#{item.fundScale}亿</td>
                                    <td class="hasRight">#{item.instPosRatio}%</td>
                                    <td class="chen chen#{item.galaxyScore}">--</td>
                                    <td class="hasRight chen#{item.morningstarScore} backDark">--</td>
                                    <td class="hasRight">
                                        <div class="handle">
                                            <i class="choose #{cVar}"></i>
                                        </div>
                                    </td>
                                </tr>
                            """

                            $('tbody').html(html)
        #添加自选#
        addSelf: (data,selfBtn)->
            $.ajax
                url:"/fund/userfund/add"
                type:'get'
                dataType:'json'
                data: data
                success:(res)->
                    if +res.code is 0
                        selfBtn.find('i').removeClass "addLogo"
                        selfBtn.find('i').addClass "cancelLogo"
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
                        selfBtn.find('i').removeClass "cancelLogo"
                        selfBtn.find('i').addClass "addLogo"
                    else
                        $.toast res.msg

    action = 

        #滚动加载#
        scrollLoad:->
            fundContent = $("#fund-content")
            scrollTop = $(document).scrollTop()
            docHeight = fundContent.find(".data-table").height()
            lock = true
            $(".headFix").remove()
            #根据scoll高度是否吸顶表头#
            if (scrollTop > 102) and ($(".headFix").length is 0) and lock
                head = fundContent.find("thead").prop("outerHTML")
                table = """<table class="headFix" style="position:fixed;top:60px;">#{head}<tbody></tbody></table>"""
                fundContent.append(table).find("thead").eq(1).removeClass(".headItem")#.find("tr").eq(0).hide()
                $(".headFix").find('tr').eq(0).css('background','#202427')
                $.each $(".headItem th"),(i)->
                    $(".headFix").find("thead tr").eq(1).find("th").eq(i).width $(this).width()
                lock = false
            else if scrollTop < 102
                $(".headFix").remove()
                lock = true


        #重置全局变量#
        resetParam:->
            PAGE_INDEX = 1
            PAGE_SIZE = 30
            SORT_BY = 999
            DIRECTION = ''
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
        #基金排序#
        fundSort:(sortTag,self,thIndex)->
            switch sortTag
                when "","sort-up"
                    self.removeClass("sort-up").addClass "sort-down"
                    self.siblings().removeClass 'active'
                    $('.down').siblings().removeClass 'active'
                    self.addClass 'active'
                    self.find('.down').addClass 'active'
                    DIRECTION = 1
                when "sort-down"
                    self.removeClass("sort-down").addClass "sort-up"
                    self.siblings().removeClass 'active'
                    $('.up').siblings().removeClass 'active'
                    self.addClass 'active'
                    self.find('.up').addClass 'active'
                    DIRECTION = 0
            SORT_BY = self.data "sort"
            PAGE_INDEX = 1
            request.getFund(1,0,thIndex)

    funList = 

        init:->
            @fundSort()
            @dataTable()
            @loadFund()
            @selfOption()

        #滚动加载基金#
        loadFund:->
            $(document).on "scroll",->
                action.scrollLoad()

        selfOption:->
            $("tbody").on "click",".handle",->
                self = $(this)
                parent = self.parents("tr")
                data =
                    code:parent.find("td:eq(0)").find('a').data "code"
                if self.find('i').hasClass("cancelLogo")
                    request.cancelSelf data,self
                else if self.find('i').hasClass("addLogo")
                    data.fundName = parent.find("td:eq(0)").find('a').text()
                    request.addSelf data,self

        #基金列表排序#
        fundSort:->
            $("#fund-content").on "click","thead th",(e)->
                e.stopPropagation()
                self = $(this)
                $(document).scrollTop 0
                if self.parent().find(".headFix")
                    #将吸顶head的排序标记传给原表头#
                    self = $("thead").eq(0).find("tr").eq(1).find("th").eq(self.index())
                
                self.siblings().removeClass("sort-up sort-down")

                sortTag =$.trim(self.attr("class").replace("sortCol","").replace("active",""))
                thIndex = self.index()

                action.fundSort sortTag,self,thIndex

        #拼接数据表格
        dataTable:->
            
            tableData = resultData
            html = ''

            $.each tableData.list,(i,item)->
                if item.addFlag
                    cVar = 'cancelLogo'
                else
                    cVar = 'addLogo'

                html += """
                    <tr>
                        <td class="hasRight"><a href="/fund/detail?code=#{item.fundCode}" data-code="#{item.fundCode}" target="_blank">#{item.fundName}</td>
                        <td class="hasRight">货币型</td>
                        <td>#{item.yieldMoth1}%</td>
                        <td>#{item.yieldMoth3}%</td>
                        <td>#{item.yield}%</td>
                        <td class="hasRight">#{item.sharpeIndex}</td>
                        <td>#{item.volitality}%</td>
                        <td class="hasRight">#{item.maxDrawback}</td>
                        <td class="hasRight">#{item.fundScale}亿</td>
                        <td class="hasRight">#{item.instPosRatio}%</td>
                        <td class="chen chen#{item.galaxyScore}">--</td>
                        <td class="hasRight chen#{item.morningstarScore} backDark">--</td>
                        <td class="hasRight">
                            <div class="handle">
                                <i class="choose #{cVar}"></i>
                            </div>
                        </td>
                    </tr>
                """

                $('tbody').html(html)

    init = ->
        $(document).scrollTop 0
        funList.init()


    init:init