#@2016.03.03
define "fundCompare",(require,exports)->
    charts    = require "charts"
    mustache  = require "mustache"
    compareDialog =require "compareDialog"
    curve     = charts.charts.fundIncomeOption #曲线图#
    histogram = charts.charts.callbackOption   #柱状图#
    canscade  = charts.charts.singleCascadeOption   #层叠图#
    DATA      = {}#cache 图表数据#
    latesTime = '2015Q4'
    FUNDNAME = {} #存放基金名字和code的对象


    #数据下载的两个全局变量
    FILE = 0 #全局文件类型变量
    TABS = ""#list选中的checkbox所代表的参数
    CODE = 0
    quarters = "2013Q1,2013Q2,2013Q3,2013Q4,2014Q1,2014Q2,2014Q3,2014Q4,2015Q1,2015Q2,2015Q3,2015Q4,"
    downChartsX = [] #下载图表时间
    downChartsX1 = [] #下载图表时间
    downChartsX2 = [] #下载图表时间
    downChartsX3 = [] #下载图表时间
    downChartsX4 = [] #下载图表时间
    downChartsX5 = [] #下载图表时间

    #修改highcharts下载文案#
    Highcharts.setOptions
      lang:
        printChart:"打印图表"
        downloadJPEG: "下载JPEG 图片"
        downloadPDF: "下载PDF文档"
        downloadPNG: "下载PNG 图片"
        downloadSVG: "下载SVG 矢量图"
        exportButtonTitle: "导出图片"

    #模板#
    tpl =
        #对比详情页详情页内容
        compareDetails :  """
                        
                    <div class="downloadBox">
                        <div class="dTitle clearfix">
                            <div class="dTitleText">数据下载</div>
                            <i class="dIcon dBoxClose"></i>
                        </div>
                        <div class="listContent">
                            <ul>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundInfo"> <label for="fundInfo">基本信息</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundAll"> <label for="fundAll">总览</label>
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
        #下拉列表#
        select:"""
           {{#selectKeyList}}<option value="{{key}}">{{value}}</option>{{/selectKeyList}}
        """
        #下拉列表#
        configSelect:"""
           {{#selectQuarterList}}<option value="{{.}}">{{.}}</option>{{/selectQuarterList}}
        """

    #操作函数#
    action =
        #重置图表配置#
        resetChart:->
            charts.charts.fundIncomeOption     = charts.reset.fundIncomeOption #曲线图#
            charts.charts.callbackOption       = charts.reset.callbackOption   #柱状图#
            curve     = charts.charts.fundIncomeOption #曲线图#
            histogram = charts.charts.callbackOption   #柱状图#
        #线条数量、柱状图数量配置#
        setSeries: (option,num)->
            colorArr = ["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
            data =
                name:""
                color:colorArr[num]
                data:[]
            option.series.push data
        # 更改y轴 和提示框 单位
        formatData: (chart,tag)->
            chart.tooltip.pointFormat = """<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>
                <td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} #{tag}</b></td></tr>"""
            chart.yAxis.labels.formatter = ->
            	this.value + tag
        #处理配置贡献层叠
        dealType8:(res)->
            canscade.xAxis.categories = res.xAxis
            colorArr = ["#993e3d","#b85722","#b18a01","#719ec7","#3e72bb","#7447a2"]
            canscade.plotOptions.column.pointPadding = 0
            canscade.plotOptions.column.groupPadding = 0.1
            canscade.series = series
        #隐藏小模块后自适应#
        # adjustBox:(boxObj)->
        #     minChart = boxObj.find(".minChart")
        #     if minChart.length%2 is 0 then return
        #     type = minChart.data "type"
        #     basicInfo = $("#basicInfo thead")
        #     res = DATA[minChart.attr("id")]
        #     data = res.fundData
        #     chartBox = minChart.last()
        #     nav = chartBox.find(".chartNav")
        #     chart = chartBox.find(".chart")
        #     nav.css("width","1160px")
        #     chart.css("width","1170px")

        #     option = if +type > 4 then histogram else curve
        #     option.xAxis.categories = res.times
        #     option.xAxis.tickInterval = Math.round(res.times.length/5)
        #     option.yAxis.tickInterval = Math.round(res.times.length/5)
        #     option.series = []
        #     for i in [0...data.length]
        #         action.setSeries option,i
        #         switch +type
        #             when 1
        #                 if res.b2CompareBaseList[0].fundType is "货币型"
        #                     option.series[i].data = (+item.d7py for item in data[i].values)
        #                 else
        #                     option.series[i].data = (+item.in for item in data[i].values)
        #             when 2,3,4
        #                 chart.highcharts option,""
        #                 option.series[i].data = data[i].values
        #             when 5,6
        #                 option.series[i].data = data[i].values
        #         option.series[i].name = basicInfo.find("th").eq(i+1).text()
        #     chart.highcharts option
        #     action.formatData option,"%"

        #配置图表#
        configChart: (option,res,type,month)->
            times = null
            data =null
            income = $("#income")
            risk = $("#risk")
            basicInfo = $("#basicInfo thead")
            option.legend.y = 0
            option.exporting.buttons.contextButton.enabled = false
            i = 0
            switch type
                when 1
                    times = res.incomeChar.times
                    data = res.incomeChar.fundData
                    downChartsX = times
                    #取最大值最小值的数组
                    dataArrey =[]
                    incomeArrey1 = []
                    sharpArrey1 = []
                    incomeArrey2 = []
                    sharpArrey2 = []
                    incomeArrey3 = []
                    sharpArrey3 = []
                    incomeArrey4 = []
                    sharpArrey4 = []
                    income.find("thead tr th:not(.stand)").remove()
                    income.find("tbody tr td:not(.stand)").remove()
                    for i in [0...res.income.length]
                        incomeArrey1.push(res.income[i].yieldMoth1)
                        sharpArrey1.push(res.income[i].sharpeRatio)
                        incomeArrey2.push(res.income[i].yieldMoth3)
                        sharpArrey2.push(res.income[i].sharpeRatio)
                        incomeArrey3.push(res.income[i].yieldMoth6)
                        sharpArrey3.push(res.income[i].sharpeRatio)
                        incomeArrey4.push(res.income[i].yieldMoth12)
                        sharpArrey4.push(res.income[i].sharpeRatio)
                        keys = res.income[i].fundCode
                        for key,value of  FUNDNAME
                            if res.income[i].fundCode == key
                                datas = value  
                        action.renderTable income,type,res.income[i],datas
                    dataArrey.push(incomeArrey1,sharpArrey1,incomeArrey2,sharpArrey2,incomeArrey3,sharpArrey3,incomeArrey4,sharpArrey4)
                    action.dataCompare(dataArrey,income.find("tbody tr"),type)
                    action.changeThWidth()
                    downChartsX1 = times # 存储下载图表的时间
                when 3
                    times = res.sharpeRatioChar.times
                    data = res.sharpeRatioChar.fundData
                when 5
                    times = res.volitalityChar.times
                    data = res.volitalityChar.fundData
                    downChartsX1 = times
                    dataArrey = []
                    risk1 = []
                    back1 = []
                    risk2 = []
                    back2 = []
                    risk3 = []
                    back3 = []
                    risk4 = []
                    back4 = []
                    risk.find("thead tr th:not(.stand)").remove()
                    risk.find("tbody tr td:not(.stand)").remove()
                    for key,value of res.volitality 
                        datas = value
                        risk1.push(datas[0].volitality)
                        back1.push(datas[0].drawback)
                        risk2.push(datas[1].volitality)
                        back2.push(datas[1].drawback)
                        risk3.push(datas[2].volitality)
                        back3.push(datas[2].drawback)
                        risk4.push(datas[3].volitality)
                        back4.push(datas[3].drawback)
                        for keys,values of  FUNDNAME
                            if key == keys
                                datas[4] = values          
                        action.renderTable risk,type,datas
                    dataArrey.push(risk1,back1,risk2,back2,risk3,back3,risk4,back4)
                    action.dataCompare(dataArrey,risk.find("tbody tr"),type)
                    downChartsX5 = times
                when 7
                    times = res.timingProfitChar.times
                    data = res.timingProfitChar.fundData
                    downChartsX2 = times
                    dataArrey = []
                    time1 = []
                    time2 = []
                    time3 = []
                    time4 = []
                    $("#ability").find("thead tr th:not(.stand)").remove()
                    $("#ability").find("tbody tr td:not(.stand)").remove()
                    for key,value of res.timingProfit
                        datas = value 
                        time1.push(datas[0].timingProfit)
                        time2.push(datas[1].timingProfit)
                        time3.push(datas[2].timingProfit)
                        time4.push(datas[3].timingProfit)
                        for keys,values of  FUNDNAME
                            if key == keys
                                datas[4] = values                 
                        action.renderTable $("#ability"),type,datas
                    dataArrey.push(time1,time2,time3,time4)
                    action.dataCompare(dataArrey,$("#ability").find("tbody tr"),type)
                when 8
                    times = res.allocationContributeRatioChar.times
                    data = res.allocationContributeRatioChar.fundData
                    downChartsX3 = times
                    dataArrey = []
                    all1 = []
                    all2 = []
                    all3 = []
                    all4 = []
                    $("#contribute").find("thead tr th:not(.stand)").remove()
                    $("#contribute").find("tbody tr td:not(.stand)").remove()
                    for key,value of res.allocationContributeRatio
                        datas = value 
                        all1.push(datas[0].allocationContriRatio)
                        all2.push(datas[1].allocationContriRatio)
                        all3.push(datas[2].allocationContriRatio)
                        all4.push(datas[3].allocationContriRatio)
                        for keys,values of  FUNDNAME
                            if key == keys
                                datas[4] = values                 
                        action.renderTable $("#contribute"),type,datas
                    dataArrey.push(all1,all2,all3,all4)
                    action.dataCompare(dataArrey,$("#contribute").find("tbody tr"),type)
                when 9
                    times = res.fundScaleChar.times
                    data = res.fundScaleChar.fundData
                    downChartsX4= times
                    dataArrey = []
                    scale1 = []
                    scale2 = []
                    scale3 = []
                    scale4 = []
                    $("#fundSize").find("thead tr th:not(.stand)").remove()
                    $("#fundSize").find("tbody tr td:not(.stand)").remove()
                    for key,value of res.fundScale
                        datas = value
                        scale1.push(datas[0].fundScale)
                        scale2.push(datas[1].fundScale)
                        scale3.push(datas[2].fundScale)
                        scale4.push(datas[3].fundScale)
                        for keys,values of  FUNDNAME
                            if key == keys
                                datas[4] = values              
                        action.renderTable $("#fundSize"),type,datas
                    dataArrey.push(scale1,scale2,scale3,scale4)
                    action.dataCompare(dataArrey,$("#fundSize").find("tbody tr"),type)
                when 10
                    times = res.instPosRatioChar.times
                    data = res.instPosRatioChar.fundData
                    downChartsX5 = times
                    dataArrey = []
                    inst1 = []
                    inst2 = []
                    inst3 = []
                    inst4 = []
                    $("#holdScale").find("thead tr th:not(.stand)").remove()
                    $("#holdScale").find("tbody tr td:not(.stand)").remove()
                    for key,value of res.instPosRatio
                        datas = value 
                        inst1.push(datas[0].instPosRatio)
                        inst2.push(datas[1].instPosRatio)
                        inst3.push(datas[2].instPosRatio)
                        inst4.push(datas[3].instPosRatio)
                        for keys,values of  FUNDNAME
                            if key == keys
                                datas[4] = values                  
                        action.renderTable $("#holdScale"),type,datas
                    dataArrey.push(inst1,inst2,inst3,inst4)
                    action.dataCompare(dataArrey,$("#holdScale").find("tbody tr"),type)
            option.xAxis.categories = times
            option.xAxis.tickInterval = Math.round(times.length/3)
            option.series = []
            if type ==8
                dataType8 = data[0].values
                option.series = dataType8
                option.plotOptions.column.pointPadding = 0
                option.plotOptions.column.groupPadding = 0.4
                option.xAxis.tickInterval = Math.round(times.length/8)
                $("#contribution").find(".chart").highcharts option
                action.renderSelect res,$("#contribution"),month,type
                return
            for i in [0...data.length]
                action.setSeries option,i
                option.series[i].name = basicInfo.find("th").eq(i+1).text()
                switch type
                    when 1
                        # option.yAxis.tickInterval = Math.round(times.length)
                        option.legend.x = -40
                        option.series[i].data = (+item.d7py for item in data[i].values)
                        $("#incomeTrend").find(".chart").highcharts option
                        action.renderSelect res,$("#incomeTrend"),month,type
                    when 3
                        option.legend.x = -40
                        action.formatData option,""
                        option.series[i].data = data[i].values
                        # option.yAxis.tickInterval = Math.round(times.length/60)
                        $("#leinuo").find(".chart").highcharts option
                        action.renderSelect res,$("#leinuo"),month,type
                    when 5
                        option.xAxis.tickInterval = Math.round(times.length/8)
                        option.series[i].data = data[i].values
                        option.plotOptions.column.pointPadding = 0
                        option.plotOptions.column.groupPadding = 0.4
                        $("#wave").find(".chart").highcharts option
                        action.renderSelect res,$("#wave"),month,type
                    when 7
                        option.xAxis.tickInterval = Math.round(times.length/8)
                        option.series[i].data = data[i].values
                        $("#timeAbility").find(".chart").highcharts option
                        action.renderSelect res,$("#timeAbility"),month,type
                    when 9
                        option.xAxis.tickInterval = Math.round(times.length/8)
                        action.formatData option,"亿"
                        option.series[i].data = data[i].values
                        $("#scope").find(".chart").highcharts option
                        action.renderSelect res,$("#scope"),month,type
                    when 10
                        option.xAxis.tickInterval = Math.round(times.length/8)
                        action.formatData option,"%"
                        option.series[i].data = data[i].values
                        $("#scale").find(".chart").highcharts option
                        action.renderSelect res,$("#scale"),month,type


        #渲染下拉列表#
        renderSelect: (res,parent,month,type)->
            html = ''
            switch type
                when 1
                    html = mustache.render tpl.select,res.incomeChar
                when 3
                    html = mustache.render tpl.select,res.sharpeRatioChar
                when 5
                    html = mustache.render tpl.select,res.volitalityChar
                when 7
                    html = mustache.render tpl.select,res.timingProfitChar
                when 8
                    html = mustache.render tpl.configSelect,res.allocationContributeRatioChar
                when 9
                    html = mustache.render tpl.select,res.fundScaleChar
                when 10
                    html = mustache.render tpl.select,res.instPosRatioChar
            if parent.find("select option").length is 0
                parent.find("select").html html
                parent.find("select option[value="+month+"]").prop "selected",true
        #渲染基本信息 table#
        renderBasicInfo: (data)->
            headTr = $("#basicInfo").find("thead tr")
            bodyTr = $("#basicInfo").find("tbody tr")
            dataArry = []
            incomeArrey = []
            sevenArrey = []
            # limitArrey = []
            # maxArrey = [] # 存放数据的数组
            for item in data
                #将基金经理名字拆分重构
                temp = ""
                managerName = item.fundInfo.manager.split(" ")
                newManagerName = []
                for i in [0...managerName.length]
                    if managerName[i]!= ""
                        newManagerName.push managerName[i]
                        temp += """<a href="http://matrix.sofund.com/fundManager/detail?managerName=#{newManagerName[newManagerName.length-1]}" target="_blank">#{newManagerName[newManagerName.length-1]}</a>&nbsp;&nbsp;"""
                headTr.append """<th>#{item.fundInfo.name}</th>"""
                bodyTr.eq(0).append """<td>#{item.fundValue.unit}</td>"""
                bodyTr.eq(1).append """<td>#{item.fundValue.all}%</td>"""
                bodyTr.eq(2).append """<td>#{item.fundFee.limitDay}</td>"""
                bodyTr.eq(3).append """<td>#{item.dailyMaxRedeem}万份</td>"""
                bodyTr.eq(4).append """<td>#{temp}</td>"""
                incomeArrey.push(item.fundValue.unit)
                sevenArrey.push(item.fundValue.all)
                FUNDNAME[item.fundInfo.code] = item.fundInfo.name
                # limitArrey.push(item.fundFee.limitDay.replace("元","").replace("--",""))
                # maxArrey.push(item.dailyMaxRedeem)

            dataArry.push(incomeArrey,sevenArrey)
            @dataCompare(dataArry,bodyTr,0)

        #渲染图表数据#
        renderTable:(dom,type,data,datas)->
            headTr = dom.find("thead tr")
            bodyTr = dom.find("tbody tr")
            switch type
                when 1
                    headTr.append """<th>#{datas}</th>"""
                    bodyTr.eq(0).append """<td>#{data.yieldMoth1}%</td>"""
                    bodyTr.eq(1).append """<td>#{data.sharpeRatio}</td>"""
                    bodyTr.eq(2).append """<td>#{data.yieldMoth3}%</td>"""
                    bodyTr.eq(3).append """<td>#{data.sharpeRatio}</td>"""
                    bodyTr.eq(4).append """<td>#{data.yieldMoth6}%</td>"""
                    bodyTr.eq(5).append """<td>#{data.sharpeRatio}</td>"""
                    bodyTr.eq(6).append """<td>#{data.yieldMoth12}%</td>"""
                    bodyTr.eq(7).append """<td>#{data.sharpeRatio}</td>"""
                when 5
                    headTr.append """<th>#{data[4]}</th>"""
                    for i in [0...data.length]
                        bodyTr.eq(i*2).append("""<td>#{data[i].volitality}%</td>""")
                        bodyTr.eq(i*2+1).append """<td>#{data[i].drawback}</td>"""
                when 7
                    headTr.append """<th>#{data[4]}</th>"""
                    for i in [0...data.length]
                        bodyTr.eq(i).append("""<td>#{data[i].timingProfit}%</td>""")
                when 8
                    headTr.append """<th>#{data[4]}</th>"""
                    for i in [0...data.length]
                        bodyTr.eq(i).append("""<td>#{data[i].allocationContriRatio}%</td>""")
                when 9
                    headTr.append """<th>#{data[4]}</th>"""
                    for i in [0...data.length]
                        bodyTr.eq(i).append("""<td>#{data[i].fundScale}亿</td>""")
                when 10
                    headTr.append """<th>#{data[4]}</th>"""
                    for i in [0...data.length]
                        bodyTr.eq(i).append("""<td>#{data[i].instPosRatio}%</td>""")

        #找到对应模块#
        renderModel: (type,res,month)->
            @resetChart()
            switch type
                when 1
                    action.configChart curve,res,type,month
                when 3
                    action.configChart curve,res,type,month
                when 5
                    action.configChart histogram,res,type,month
                when 7
                    action.configChart histogram,res,type,month
                when 8
                    action.configChart canscade,res,type,month
                when 9
                    action.configChart histogram,res,type,month
                when 10
                    action.configChart histogram,res,type,month

        #取最大最小值方法
        dataCompare:(dataArrey,dom,type)->
            #dataArry--要排列的数组的集合
            #dom--要取最大值和最小值的dom结构
            if dataArrey.length is 0
                return
            else
                for i in [0...dataArrey.length]
                    maxIndex = dataArrey[i].indexOf(+Math.max.apply(null,dataArrey[i]).toFixed(4))
                    minIndex = dataArrey[i].indexOf(+Math.min.apply(null,dataArrey[i]).toFixed(4))
                    if maxIndex != minIndex
                        if  type == 1 
                            if i%2!=0
                                dom.eq(i).find("td").eq(maxIndex+1).css("color","red")
                                dom.eq(i).find("td").eq(minIndex+1).css("color","green")
                            else
                                dom.eq(i).find("td").eq(maxIndex+2).css("color","red")
                                dom.eq(i).find("td").eq(minIndex+2).css("color","green")
                        if  type == 0 || type ==9 || type ==10 ||type ==8 || type ==7
                            dom.eq(i).find("td").eq(maxIndex+1).css("color","red")
                            dom.eq(i).find("td").eq(minIndex+1).css("color","green")
                        if  type == 5
                            if i%2!=0
                                dom.eq(i).find("td").eq(maxIndex+1).css("color","green")
                                dom.eq(i).find("td").eq(minIndex+1).css("color","red")
                            else
                                dom.eq(i).find("td").eq(maxIndex+2).css("color","green")
                                dom.eq(i).find("td").eq(minIndex+2).css("color","red")
                    
        #调整部分表格第一个th的宽度
        changeThWidth:()->
            ths = $("#basicInfo thead th")
            i = 1
            for i in [0...ths.length]
                widths = $("#basicInfo thead th").eq(i).width()
                $("#income thead th").eq(i).css("width",widths)


        #数据下载相关函数
        differentiate:(id)->
            FILE = 1
            CODE = window.location.href.split("=")[1] 
            $("body").append(tpl.compareDetails).css('overflow-y','hidden')
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
        downloadData :()->
            data = 
                file : FILE
                tabs : TABS
            data1 = 
                fundCode : CODE
            TIMES = 
                data: [
                    {'parentId':'0','startDate':'','endDate':'',quarter:''},# 基础信息
                    {'parentId':'1','startDate':downChartsX[0],'endDate':downChartsX[downChartsX.length-1],'quarter':''},#收益指标
                    {'parentId':'2','startDate':'','endDate':'','quarter':downChartsX1.join(",")},#风险指标
                    {'parentId':'3','startDate':'','endDate':'','quarter':downChartsX2.join(",")},#择时能力
                    {'parentId':'4','startDate':'','endDate':'','quarter':downChartsX2.join(",")},#资产配置
                    {'parentId':'5','startDate':'','endDate':'','quarter':downChartsX4.join(",")},#流动性
                    {'parentId':'6','startDate':'','endDate':'','quarter':downChartsX5.join(",")},#机构青睐 
                ]
            window.open "http://matrix.sofund.com/download/excelnew?"+$.param(data)+"&"+$.param(data1)+"&times="+JSON.stringify(TIMES)
            $(".downloadBox").remove()
            $(".mask").remove()

    #请求接口#
    request =
        #初始化#
        init: ->
            @getFundInfo()
            @getChart(12,1)
            @getChart(12,3)
            @getChart(12,5)
            @getChart(12,9)
            @getChart(12,10)
            @getChart(12,8)
            @getChart(12,7)
            action.changeThWidth()
        # 获取图表数据
        #【type】: 收益率数据1,夏普指数3,风险指标5,择时能力7,资产配置贡献率8,基金规模9,机构持仓10
        getChart: (month,type)->
            $.ajax
                url:"/fund/compare/charts"
                type:'get'
                dataType:'json'
                async:false
                data:
                    fundCodes: $.getUrlParam("code")
                    month: month
                    displayTypes: type
                    quarters: latesTime
                success:(res)->
                    if +res.code is 0
                        # latesTime = if +type is 5 then res.times[0] else latesTime
                        action.renderModel type,res,month
                    else
                        #$.toast res.msg
        #获取基金基本信息#
        getFundInfo: ->
            $.ajax
                url:"/fund/compare/baseInfo?code=" + $.getUrlParam("code")
                type:'get'
                async: false
                dataType:'json'
                success:(res)->
                    action.renderBasicInfo res.fundBaseInfoList
                    # if +res.code is 0
                    #     action.renderBasicInfo res
                    # else
                    #     $.toast res.msg

    #事件监听#
    listener =
        init: ->
            @showDialog()
            @changeTime()
            @close()
            @cancle()
            @download()
        #弹窗显示图像大图
        showDialog: ->
            $('.minChart').on 'click',()->
                fundCode = $.getUrlParam("code")# 获取fundCode
                type = $(this).attr('data-type')
                compareDialog.init(fundCode,curve,type) # 调用 收益走势弹框   
        #选取时间段 绘图#
        changeTime: ->
            $("body").on "change",".selectTime",->
                self = $ this
                type = self.data "type"
                month = self.val()
                if month.indexOf("Q") isnt -1
                    latesTime = month
                    month = 6
                request.getChart month,type
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

                action.downloadData()


    # 初始化函数
    init = ->
        $('body').placeholder() # 修复 ie placeholder 不显示bug
        listener.init()
        request.init()
        $(".down-data").off("click").on "click",->
            action.differentiate()
    init: init
