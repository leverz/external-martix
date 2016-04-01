#@2016.03.03
define "trend",(require,exports)->
    chart    = require "charts"
    mustache = require "mustache"
    FUND_CODE = ""

    #数据下载的两个全局变量
    FILE = 0 #全局文件类型变量
    TABS = ""#list选中的checkbox所代表的参数
    CODE = 0
    downChartsX = []
    quarters = "2013Q1,2013Q2,2013Q3,2013Q4,2014Q1,2014Q2,2014Q3,2014Q4,2015Q1,2015Q2,2015Q3,2015Q4,"
    #模板#
    tpl =
        timeList:"""
            {{#selectKeyList}}
                <li value="{{key}}">{{value}}</li>
            {{/selectKeyList}}
        """
        #基金详情页内容
        fundDetail :  """
                        
                    <div class="downloadBox">
                        <div class="dTitle clearfix">
                            <div class="dTitleText">数据下载</div>
                            <i class="dIcon dBoxClose"></i>
                        </div>
                        <div class="listContent">
                            <ul>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundInfo"> <label for="fundInfo">基金基本信息</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundAll"> <label for="fundAll">总览</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundData"> <label for="fundData">净值数据</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                            <input type="checkbox" id="fundLei"> <label for="fundLei">累计净值</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundDan"> <label for="fundDan">单位净值</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundDay"> <label for="fundDay">日涨跌幅</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
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
                                        <input type="checkbox" id="fundZeshi"> <label for="fundZeshi">择时能力</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundSunyi"> <label for="fundSunyi">择时损益</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundZichan"> <label for="fundZichan">资产配置</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundZi"> <label for="fundZi">资产配置</label>
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
                            <span class="dDownload dButton">确认下载</span>
                            <span class="dCancle dButton">取消</span>
                        </div>
                    </div>
                    <div class="mask"></div>

                    """
        
    #请求接口#
    request =
        #净值走势#
        trend: (month,type,compareCode,fundCode)->
            $.ajax
                url:"/fund/detail/chart"
                type:'get'
                dataType:'json'
                data:
                    fundCode:FUND_CODE
                    compareCode:compareCode
                    month:month
                    displayType:type
                success:(res)->
                    if +res.code is 0
                        timeSelect = $(".time-select")
                        action.renderChart res,type
                        if $(".compare-select").find("li").length is 0
                            action.renderCompareList res.b2CompareBaseList
                            action.renderRiskList()
                        #时间列表#
                        if timeSelect.find("li").length is 0
                            html = mustache.render tpl.timeList,res
                            if window.location.pathname == '/fund/detail'
                                timeSelect.html(html).find("li[value=12]").addClass('active').click()
                                $('.otherLi').eq(0).click()
                                $('body').click()
                            else
                                timeSelect.html(html).find("li[value=12]").addClass('active').click()
                        # $.toast res.msg


        #获取图表数据－基金详情页
        getChartData:(fundCode,compareCode,month,displayType)->
            $.ajax
                url:'/fund/detail/chart'
                type:'post'
                dataType:'json'
                data:
                    fundCode:fundCode
                    compareCode:compareCode
                    month:month
                    displayType:displayType
                success:(r)->
                    compareCodeList = []
                    compareNameList = []

                    if +r.code is 0
                        $('.charts-below').html ""

                        # if $(".compare-select").find("li").length is 0
                        #     chartList.forCompareList r.b2CompareBaseList

                        #过滤无数据图表
                        if !r.fundData || r.fundData[0].values.length is 0
                            $('.charts-below').html """<div class="nodata"></div>"""
                        else
                            $('.nodata').remove()
                            #修改图表样式
                            chart.charts.fundSizeOption.exporting = ""
                            chart.charts.singleCascadeOption.exporting = ""
                            chart.charts.callbackOption.exporting = ""
                            chart.charts.fundSizeOption.chart.backgroundColor = null
                            chart.charts.singleCascadeOption.chart.backgroundColor = null
                            chart.charts.callbackOption.chart.backgroundColor = null

                            if (displayType is 9) or (displayType is 10)
                                chart.charts.fundSizeOption.xAxis.categories = r.times

                                tag = if displayType is 9 then "亿元" else "%"
                                action.formatData chart.charts.fundSizeOption, tag
                                chart.charts.fundSizeOption.series[0].data = r.fundData[0].values
                                chart.charts.fundSizeOption.series[0].name = fundName
                                # if displayType isnt 9
                                #     action.setSeriesForBar chart.charts.fundSizeOption,r.compareData
                                chart.charts.fundSizeOption.chart.width = $('.charts-below').width() #图标宽度等于其父元素
                                if displayType is 9 
                                    chart.charts.fundSizeOption.xAxis.labels.rotation = '0'
                                else 
                                    chart.charts.fundSizeOption.xAxis.labels.rotation = ''

                                $('.charts-below').highcharts(chart.charts.fundSizeOption)
                                action.formatData chart.charts.fundSizeOption,"%"

                                #重置图表模版
                                chart.charts.fundSizeOption.series =  [
                                    name: 'Population'
                                    data: [34.4, 21.8, 20.1, 20, 19.6, 19.5, 19.1, 18.4, 18,
                                           17.3, 16.8, 15, 14.7, 14.5, 13.3, 12.8, 12.4, 11.8,
                                           11.7, 11.2]
                                ]

                            else if displayType is 8
                                #启用堆叠
                                action.dealType8(r)
                                # action.setSeriesForBar chart.charts.singleCascadeOption,r.compareData
                                chart.charts.singleCascadeOption.chart.width = $('.charts-below').width() #图标宽度等于其父元素
                                $('.charts-below').highcharts(chart.charts.singleCascadeOption)
                                setTimeout ->
                                    listener.assetHover()
                                ,800 

                            else
                                chart.charts.callbackOption.xAxis.categories = r.times
                                chart.charts.callbackOption.xAxis.tickInterval = Math.round(r.times.length/5)
                                chart.charts.callbackOption.series[0].data = r.fundData[0].values
                                chart.charts.callbackOption.series[0].name = fundName
                                action.setSeriesForBar chart.charts.callbackOption,r.compareData,r.times
                                chart.charts.callbackOption.chart.width = $('.charts-below').width() #图标宽度等于其父元素
                                $('.charts-below').highcharts(chart.charts.callbackOption)

                                #重置图表模版代码
                                chart.charts.callbackOption.series =  [
                                    {
                                        name: "新华基金A"
                                        data: [15, 17, 25, 29, 14]
                                    },
                                    {
                                        name: "国债收益率曲线"
                                        data: [15, 17, 25, 29, 14]
                                    }
                                ]                
    #操作函数#
    action =


        # 更改y轴 和提示框 单位
        formatData: (chart,tag)->
            # chart.tooltip.pointFormat = """<tr><td style="color:{series.color};padding:0">{series.name}: </td>
            #     <td style="padding:0"><b>{point.y:.4f}#{tag}</b></td></tr>"""
            chart.tooltip.pointFormat = """<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td><td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f}#{tag}</b></td></tr>"""
            chart.yAxis.labels.formatter = ->
            	this.value + tag
        #对比标的图表配置#
        setSeries: (chart,list)->
            if list is null
                return 
            else if list is undefined or Object.keys(list).length is 0
                chart.chart.type = 'area'
                 
                chart.plotOptions = area:
                        lineWidth: 1
                        states:
                            hover:
                                lineWidth: 1.5
                        marker:
                            enabled: false
                        fillColor:
                            linearGradient:
                                x1:0
                                y1:0
                                x2:0
                                y2:1
                            stops:[
                                [0,Highcharts.getOptions().colors[0]],
                                [1,Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                            ]
            else 
                chart.chart.type = 'spline'
                 
                chart.plotOptions = spline:
                    lineWidth: 1
                    states:
                        hover:
                            lineWidth: 1.5
                    marker:
                        enabled: false
                compareCode = $(".compare-select").attr("data-code").split(",")
                for i in [0...compareCode.length]
                    data =
                        name: compareCode[i]
                        data:list[compareCode[i]]
                    chart.series.push data

        #对比标的图表配置-柱状图-基金详情页
        setSeriesForBar: (chart,list,times)->
            if list is null then return

            if list is undefined
                chart.series = chart.series.splice(0,1)
            else
                compareCode = $(".compare-select").attr("data-code").split(",")
                chart.series = chart.series.splice(0,1)
                chart.xAxis.tickInterval = null
                for i in [0...compareCode.length]
                    data =
                        name: compareCode[i]
                        data:list[compareCode[i]]
                    chart.series.push data

        #处理displayType = 8 的数据-基金详情页
        dealType8: (res)->
            chart.charts.singleCascadeOption.xAxis.categories = res.times
            resTmp = []
            if res
                for i in [0...res.times.length]
                    resTmp[i] = 0
                res.fundData[0].values[0].data = resTmp
                series = res.fundData[0].values
            chart.charts.singleCascadeOption.series = series 

                        
        # 渲染图表
        renderChart: (res,type)->
            chartOption = chart.charts.fundIncomeOption
            if window.location.pathname == '/fund/detail'
                chartOption.chart.height = 360
            else
                chartOption.chart.height = 234
            chartOption.xAxis.categories = res.times
            downChartsX = res.times
            chartOption.chart.width = $(".m-charts").width()-10 #图标宽度等于其父元素
            chartOption.xAxis.tickInterval = Math.round(res.times.length/5)
            chartOption.exporting.buttons.contextButton.enabled = false # 去掉下载按钮
            chartOption.series = []
            series =
                data: if +type is 1 then (+item.d7py for item in res.fundData[0].values) else res.fundData[0].values
                name :res.fundName #fundData[0].name
            chartOption.series.push series
            @setSeries chartOption,res.compareData
            tag = if +type is 1 then "%" else ""
            @formatData chartOption,tag
            $(".m-charts").highcharts chartOption

        

        # 渲染对比列表
        renderCompareList:(data)->
            compare = $(".compare-select")
            compare.pullBox
                data: data
                codeList: compare.data("code").split(",")
                liTpl:"""<li class="compareLi clearfix" data-code="rCode">
                            <p>rName<span rChecked></span></p>
                    </li>"""
                headTpl:"对比标的<i class='icon-down'></i><ul class='pullBox rPosition' style='display:none;z-index:1'>"
                footTpl:"</ul>"
                callback:(list)->
                    compare.attr "data-code",list[0]
                    month = $(".time-select").find("li.active").val()
                    type = $(".risk-select").data('code')
                    request.trend month,+list[1],list[0],FUND_CODE
                    if window.location.pathname == '/fund/detail'
                        setTimeout ->
                            request.getChartData FUND_CODE,list[0],month,+list[2]
                        ,50

        # 渲染类型列表
        renderRiskList:->
            risk = $(".risk-select")
            risk.pullBox
                callback:(list)->
                    month = $(".time-select").find("li.active").val()
                    if list[3] is 0
                        request.trend month,list[1],list[0],FUND_CODE
                    if window.location.pathname == '/fund/detail'&& list[3] is 1 
                        setTimeout ->
                            request.getChartData FUND_CODE,list[0],month,+list[2]
                        ,50

        #数据下载相关函数
        differentiate:(id)->
            if id == "fundDetail"
                FILE = 2
                CODE = window.location.href.split("=")[1] 
                $("body").append(tpl.fundDetail).css('overflow-y','hidden')
            $(".father-input input:first-child").change ->
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
            if id == "fundDetail"
                data = 
                    file : FILE
                    tabs : TABS
                data1 = 
                    fundCode : CODE
                TIMES = 
                    data: [
                        {'parentId':'0','startDate':'','endDate':'',quarter:''},# 基础信息
                        {'parentId':'1','startDate':downChartsX[0],'endDate':downChartsX[downChartsX.length-1],'quarter':''},#净值数据
                        {'parentId':'2','startDate':downChartsX[0],'endDate':downChartsX[downChartsX.length-1],'quarter':''},#收益指标
                        {'parentId':'3','startDate':'','endDate':'','quarter':quarters},#风险指标
                        {'parentId':'4','startDate':'','endDate':'','quarter':quarters},#择时能力
                        {'parentId':'5','startDate':'','endDate':'','quarter':quarters},#资产配置
                        {'parentId':'6','startDate':'','endDate':'','quarter':quarters},#流动性
                        {'parentId':'7','startDate':'','endDate':'','quarter':quarters},#机构青睐 
                    ]
                window.open "http://matrix.sofund.com/download/excelnew?"+$.param(data)+"&"+$.param(data1)+"&times="+JSON.stringify(TIMES)
                $(".downloadBox").remove()
                $(".mask").remove()


    #事件监听#
    listener =
        init:->
            @changeTime()
            @close()
            @cancle()
            @download()

        #资产配置详情hover框监听
        assetHover:->
            chartName = $('.charts-below-name').text()
            tmpArr = []

            if chartName is '资产配置贡献'
                $('.charts-below').on 'mousemove',(e)->
                    tmpArr =[]
                    $('.charts-below').find('div.highcharts-tooltip').find('td').find('b').each (i,n)->
                        tmpArr.push +$.trim($(n).text().replace('%',''))

                    tmpArr = tmpArr.splice(1,6)
                    sum = (+eval(tmpArr.join('+'))).toFixed(4)
                    if $('.charts-below').find('div.highcharts-tooltip').find('tr td:eq(1) b')
                        $('.charts-below').find('div.highcharts-tooltip').find('tr td:eq(1) b').text sum+' %'

        #时间选择器监听
        changeTime:->
            $(".time-select").on "click","li",->
                self = $(this)
                if !self.hasClass('active')
                    self.addClass('active')
                    self.siblings().removeClass('active')

                type = $(".risk-select").attr('data-code')
                displayType = $(".risk-select").attr('data-id')
                compareCode = $(".compare-select").attr "data-code"
                month = $(".time-select").find("li.active").val()

                request.trend month,type,compareCode

                if window.location.pathname == '/fund/detail'
                    request.getChartData FUND_CODE,compareCode,month,displayType
        
        #数据下载弹窗的相关方法
        close :->
            $("body").on "click",".dBoxClose",->
                action.closeDialog()

        cancle :->
            $("body").on "click",".dCancle",->
                action.cancle()

        download :->
            $("body").off("click",".dDownload").on "click",".dDownload",->
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

                action.downloadData($("body").attr("id"))

    init = (fundCode)->
        FUND_CODE = fundCode
        listener.init()
        request.trend(12,1,"CGB1Y",fundCode)
        $(".down-data").off("click").on "click",->
            action.differentiate($("body").attr("id"))

    init: init
    request:request
