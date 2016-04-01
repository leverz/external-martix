#@2016.03.03
define "fundHold",(require,exports)->

  mustache = require "mustache"
  chart    = require "charts"
  trendDialog = require "trendDialog"
  checkArr = [] # 对比基金列表
  COLOR_ARR = ["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
  # ORIGIN_X =   # 缓存初始基金走势图的X轴
  TPL =

    liHtml:"""
      {{#data}}
        <li>
          <div class="title">总资产价值（元）：</div>
          <div class="amount">{{totalProperty}}</div>
        </li>
        <li>
          <div class="title">本金（元）：</div>
          <div class="amount">{{principle}}</div>
        </li>
        <li>
          <div class="title">累计未结转收益（元）：</div>
          <div class="amount">{{uncommittedIncome}}</div>
        </li>
        <li>
          <div class="title">昨日收益（元）：</div>
          <div class="amount" style="color:#fc5858;">{{yesterdayIncrease}}</div>
        </li>
        <li>
          <div class="title">浮动收益（元）：</div>
          <div class="amount" style="color:#fc5858;">{{totalIncrease}}</div>
        </li>
        <li>
          <div class="title">收益率：</div>
          <div class="amount" style="color:#fc5858;">{{incomeRate}}%</div>
        </li>
      {{/data}}
      """

    fundLi : """
       {{#data}}
        <li>
            <div class="liTit">
              <a href="http://matrix.sofund.com/fund/detail?code={{fundCode}}" target="_blank">{{fundName}} &nbsp;({{fundCode}})</a>
            </div>
            <ul class="cont clearfix">
              <li>
                <div class="title">总资产价值（元）：</div>
                <div class="amount">{{totalProperty}}</div>
              </li>
              <li>
                <div class="title">昨日收益（元）：</div>
                <div class="amount" style="color:#fc5858;">{{yesterdayIncrease}}</div>
              </li>
              <li>
                <div class="title">持有份额（份）：</div>
                <div class="amount">{{holdingVolume}}</div>
              </li>
              <li>
                <div class="title">浮动收益（元）：</div>
                <div class="amount" style="color:#fc5858;">{{totalIncrease}}</div>
              </li>
              <li>
                <div class="title">累计未结转收益（元）：</div>
                <div class="amount">{{uncommittedIncome}}</div>
              </li>
              <li>
                <div class="title">收益率：</div>
                <div class="amount" style="color:#fc5858;">{{incomeRate}}%</div>
              </li>
            </ul>
            <div class="handleArea clearfix">
              <a href="javascript:;" class="apply">申购</a>
              <a href="javascript:;" class="call" data-volume="{{holdingVolume}}">赎回</a>
              <a href="javascript:;" class="income" data-code="{{fundCode}}" data-name="{{fundName}}">收益走势</a>
            </div>
          </li>
        {{/data}}
    """
    timeOption:"""
      {{#data}}
        <option value="{{index}}">{{name}}</option>
      {{/data}}
    """
    compareLi:"""
      {{#data}}
      <li class="compareLi clearfix" data-code="{{code}}">
        <p>{{name}}
          <span class=""></span>
        </p>
      </li>
    {{/data}}
    """
    baseLi:"""
      {{#data}}
        <li><span class="fund-color"></span>{{fundName}}</li>
      {{/data}}
      """

  elem =
    income:$(".boxCharts .leftBox .cont") # 收益状况
    costDet:$(".mainCont .listBox") # 收益明细
    timeRange:$(".chartArea .time-select") # 收益走势 timeRange
    compares:$(".chartArea .compare-select") # 对比标的
    time:$(".chartArea .time-select") # 时间标的

  listener =
    init:->
      @renderCharts(401) # 走势图渲染(默认加载最近一年)
      @getData() # 页面数据加载
      @handleEvent()

    createOrder :(urls,fundCode,amount,orderDate)->
      $.ajax
        url:'/invest/'+urls+'/createOrder'
        type:'post'
        dataType:'json'
        data:
          fundCode:fundCode
          amount:amount
          orderDate:orderDate
        success:(rs)->
          if +rs.code isnt 0
            $.toast rs.msg
          else
            window.location.reload()   #刷新页面

    redeemMethod : (code,name,vol)-> #资产赎回
      $("""
              <div class="theCont">
                  <div class="lines">
                  <label for=''>基金名称</label>
                  <select name='' class="redeem">
                      <option value='#{code}'>#{name}</option>
                  </select>
              </div>
              <div class="lines">
                  <label for=''>可用份额</label>
                  <span class="useCount">#{vol}</span>份
              </div>
              <div class="lines">
                  <label for=''>卖出份额</label>
                  <input type='text' class="amount"/>
                  <a href='javascript:;' class="drawAll">全部赎回</a>
              </div>
              <div class="lines">
                  <label for=''>赎回日期</label>
                  <input type='text' class="pickers"/>
                  <span class="lastEnd"><span class="times">15</span>点之前</span>
              </div>
              </div>
        """).dialogBox
          title:'资产赎回'
          height : 360
          subCallback:(dialog,option)->
            fundCode = $(".redeem option:selected",dialog).val()
            amount = $(".amount",dialog).val()
            orderDate = $(".pickers",dialog).val()
            listener.createOrder('redeem',fundCode,amount,orderDate)# 创建赎回订单

    applyBuyMethod : (name,code)-> #资产申购
      $("""
          <div class="theCont">
            <div class="lines">
              <label for=''>资产名称</label>
              <input type='text' value ="#{name}" data-value="#{code}" class="applyBuy" placeholder='资产代码／资产名称'/>
              <ul class="suggestList"></ul>
            </div>
            <div class="lines">
              <label for=''>申购金额</label>
              <input type='text' class="amount"/>
            </div>
            <div class="lines">
              <label for=''>申购日期</label>
              <input type='text' class="pickers"/>
              <span class="lastEnd"><span class="times">15</span>点之前</span>
            </div>
          </div>
        """).dialogBox
          title:'资产申购'
          height :330
          subCallback:(dialog,option)->
            #判断是手动输入基金代码还是自动补全
            fundCode = ""
            if $(".applyBuy",dialog).hasClass("ui-autocomplete-input")
              applyBuyVal = $(".applyBuy",dialog).val()
            else
              applyBuyVal = $(".applyBuy",dialog).data("value")
            pattern = /\//
            if pattern.test(applyBuyVal)
              fundCode = applyBuyVal.split("/")[1]
            else
              fundCode = applyBuyVal
            amount = $(".amount",dialog).val()
            orderDate = $(".pickers",dialog).val()
            listener.createOrder('purchase',fundCode,amount,orderDate)# 创建申购订单

    drawBackSuggest : -># 资产赎回
      $.ajax
        url:'/invest/redeem/list'
        type:'get'
        dataType:'json'
        success:(rs)->
          if rs.propertyList.length is 0
            $.toast("无可赎回的资产")
          else
          html = ''
          useCounts = []
          for one in rs.propertyList
            useCounts.push(one.holdingVolume)
            html += """<option value='#{one.fundCode}'>#{one.fundName}</option>"""
          $(".redeem").empty().append(html)
          $(".useCount").text(rs.propertyList[0].holdingVolume) # 资产赎回可用份额
          $("#fundHold").on "change" ,"select", ->
            funNameId = $(".redeem option:selected").index()
            $(".useCount").text(useCounts[funNameId])
         
          $(".pickers").datepicker
            inline: true
            dateFormat: "yy-mm-dd"
            showMonthAfterYear: true
            maxDate : "+0y +0m +0d"
            monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
            dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']

    autoCompleteHtml: -> #申购自动填充
      $.ajax 
        url : "/filter/fundlist "
        type : "get"
        dataType:"json"
        data :
          type : "fund"
          para : "货币型"
          filter: ""
        success:(res)->
          autoCompleteArr = []
          for one in res.fundlist
            nameCat = """#{one.fundname}/#{one.fundcode}"""
            autoCompleteArr.push(nameCat)
          $(".applyBuy").autocomplete({source:autoCompleteArr})
          $(".ui-autocomplete").css({
              "z-index":"99999",
              "background-color":"#374148",
              "color":"#778087",
              "height":"200px",
              "font-size":"14px",
              "font-family":"Microsoft YaHei"
              "overflow-y":"scroll",
              "border":"1px solid #5d6c78"
          })

    incomeState:(lists)-> # 收益状况渲染
      data =
        data:lists
      HTML = mustache.render(TPL.liHtml,data)
      elem.income.empty().append(HTML)

    costDetail:(lists)-> # 资产明细渲染
      data =
        data:lists
      HTML = mustache.render(TPL.fundLi,data)
      elem.costDet.empty().append(HTML)

    timeRender:(lists)-> # timeRange 渲染
      data =
        data:lists
      HTML = mustache.render(TPL.timeOption,data)
      elem.timeRange.empty().append(HTML)

    compareRender:(lists)->  #对比标的 渲染
      data =
        data:lists
      HTML = mustache.render(TPL.compareLi,data)
      elem.compares.find(".pullBox").empty().append(HTML)

    getData:->
      $.ajax
        url:"/invest/overview"
        type:"get"
        dataType:"json"
        data:
          uid:host
        success:(rs)->
          if(rs.code is 0)
            listener.incomeState(rs.overview)
            listener.costDetail(rs.fundList)
            listener.timeRender(rs.timeRangeList)
            listener.compareRender(rs.comparingList)
            totalCost = +rs.overview.totalProperty # 总资产价值
            listener.renderBing(totalCost,rs.fundList) # 渲染环形图

            # toFixedTwo()

    renderBing:(total,list)-> # 环形图
      chartOption = chart.charts.circleChart
      colors = chartOption.plotOptions.pie.colors #取出饼图的颜色数组
      chartOption.series[0].data = []
      for one in list
        data =
          data:list
        HTML = mustache.render(TPL.baseLi,data)
        $(".bingWrap .listName").empty().append(HTML)
        per =
          name: one.fundName,
          y: +one.totalProperty/total*100, # 资产占比
          sliced: false,
          selected: false
        chartOption.series[0].data.push(per)
      for i in [0...colors.length]
        $(".listName li span").eq(i).css("background-color",colors[i])
        
      $(".bingWrap .charts").highcharts(chartOption)
      $('.highcharts-series').find('path').on 'mouseover',(e)->
        pathIndex = $(e.target).index()
        colorTmp = $(this).attr('fill')

        setTimeout ()->
          $('.borderLeft').css 'background-color',colorTmp
          $('.totalProperty').text (+list[pathIndex].totalProperty).toFixed(2) + "元"
          $('.holdingVolume').text (+list[pathIndex].holdingVolume).toFixed(2) + "份"
        ,50

      $('div.bingWrap').find('.highcharts-container').find('path').eq(0).mouseover()

      
    getCompare:(comp,time)-> # 走势图对比      
      $.ajax
        url:"/invest/comparing"
        type:"get"
        dataType:"json"
        data:
            comparing:comp.join(","),
            timeRange:time,
            needAll:1  
        success:(rs)->
          opt = chart.charts.fundIncomeOption
          if rs.data.length is 1
              opt.chart.type = 'area'
               
              opt.plotOptions = area:
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
              opt.chart.type = 'spline'
                
              opt.plotOptions = spline:
                  lineWidth: 1
                  states:
                      hover:
                          lineWidth: 1.5
                  marker:
                      enabled: false
          opt.xAxis.categories = rs.data[1].xAxis
          opt.xAxis.tickInterval = Math.round(rs.data[1].xAxis.length/4)
          # x_first = rs.data[0].xAxis.indexOf(ORIGIN_X[0])  #初始基金的x轴第一项在对比基金中的位置
          # x_last = rs.data[0].xAxis.indexOf(ORIGIN_X[ORIGIN_X.length-1]) #初始基金的x轴第一项在对比基金中的位置
          opt.exporting.buttons.contextButton.enabled = false # 去掉下载按钮
          opt.chart.backgroundColor = '#202427'
          opt.series = []
          for i in [0...rs.data.length]
            yAxisParse = []
            for one in rs.data[i].yAxis # 转换为数值
              yAxisParse.push(+one)
            series =
              data:yAxisParse
              name:rs.data[i].name
              color: COLOR_ARR[i]
            opt.series.push(series)
          $(".chartArea .m-chart").highcharts(opt)

    renderCharts:(time)-> # 资产总览－走势图
      $.ajax
        url:"/invest/list"
        type:"get"
        dataType:"json"
        data:
          fundCode:''
          timeRange:time
        success:(rs)->
          chartOption = chart.charts.fundIncomeOption
          chartOption.exporting.buttons.contextButton.enabled = false # 去掉下载按钮
          chartOption.chart.height = 275
          if rs.data.length is 1
              chartOption.chart.type = 'area'
               
              chartOption.plotOptions = area:
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
              chartOption.chart.type = 'spline'
               
              chartOption.plotOptions = spline:
                  lineWidth: 1
                  states:
                      hover:
                          lineWidth: 1.5
                  marker:
                      enabled: false
          
          chartOption.xAxis.tickInterval = Math.round(rs.data[0].xAxis.length/4)
          chartOption.xAxis.categories = rs.data[0].xAxis
          chartOption.series = []
          # oneSeri = '' # 存储资产总览数据
          for i in [0...rs.data.length]
            yAxisParse = []
            for one in rs.data[i].yAxis # 转换为数值
              yAxisParse.push(+one)
            series =
              data:yAxisParse
              name:rs.data[i].name
              color:COLOR_ARR[i]
            # oneSeri = series
            chartOption.series.push(series)
          $(".chartArea .m-chart").highcharts(chartOption) # 绘制资产总览曲线

          if(checkArr.length isnt 0) # 存在对比项要加载
            listener.getCompare(checkArr,time) #添加对比曲线
          else
            listener.addCompare(chartOption)

    addCompare:(chartOption)-> # 添加对比
      #pullBox
      elem.compares.off("click").on "click",(e)->
        e.stopPropagation()
        pullBox = elem.compares.find(".pullBox")
        if pullBox.css("display") is "none"
          pullBox.show()
        else
          pullBox.hide()

      .on "click","li",()->  # 选择对比标的
        time = +$("option:selected",elem.time).val()
        self = $(this)
        code = self.data "code"
        checkbox = self.find("span")
        if checkbox.hasClass("checked") #取消选中
          checkbox.removeClass("checked")
          index = checkArr.indexOf(+code)
          checkArr.splice index,1
          if(checkArr.length is 0) # 没有对比项，渲染总览曲线
            listener.renderCharts(+$("option:selected",elem.time).val())
          else
            listener.getCompare(checkArr,time) #添加对比曲线
        else #选中
          checkbox.addClass("checked")
          checkArr.push(+code)
          listener.getCompare(checkArr,time) #添加对比曲线

    handleEvent:->
      #关闭pullBox
      $("body,html").on "click",(e)->
        target = $(e.target)
        if (target.attr("class") isnt "pullBox") and (target.attr("class") isnt "compare-select")
          $(".pullBox").hide()

      .on "click",".addCost",(e)-> # 资产增加
        e.stopPropagation()
        listener.applyBuyMethod('')
        listener.autoCompleteHtml()
        $(".pickers").datepicker
          inline: true
          dateFormat: "yy-mm-dd"
          showMonthAfterYear: true
          maxDate : "+0y +0m +0d"
          monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
          dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']

      .on "click",".callCost",(e)-> # 资产赎回
        e.stopPropagation()
        listener.redeemMethod('',"基金代码／基金名称")
        $(".drawAll").on "click",()->    #全部赎回
          $(".amount").val($(".useCount").text())
        listener.drawBackSuggest()

      elem.time.off("click").on "change",(e)->
        e.stopPropagation()
        val = $(this).val()
        if(checkArr.length isnt 0) # 存在对比项要加载
          listener.getCompare(checkArr,val) #添加对比曲线
        else
          listener.renderCharts(val)

      elem.costDet.off("click").on "click",".income",(e)-> # 收益走势
        e.stopPropagation()
        fundCode = $(this).data("code") # 获取fundCode
        chartOpt = chart.reset.fundIncomeOption
        trendDialog.init(fundCode,chartOpt) # 调用 收益走势弹框

      .on "click",".apply",-> # 申购资产
        self = $(this)
        name = self.parent().find(".income").data("name")
        code = self.parent().find(".income").data("code")
        listener.applyBuyMethod(name,code)
        $(".pickers").datepicker
          inline: true
          dateFormat: "yy-mm-dd"
          showMonthAfterYear: true
          maxDate : "+0y +0m +0d"
          monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
          dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']

      .on "click",".call",-> # 赎回资产
        self = $(this)
        code = self.parent().find(".income").data("code")
        name = self.parent().find(".income").data("name")
        holdingVolume = self.data("volume")
        listener.redeemMethod(code,name,holdingVolume)
        $(".drawAll").on "click",()->    #全部赎回
          $(".amount").val($(".useCount").text())
        $(".pickers").datepicker
          inline: true
          dateFormat: "yy-mm-dd"
          showMonthAfterYear: true
          maxDate : "+0y +0m +0d"
          monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
          dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']

      

  init = ->

    $.menuActive(4)
    $.selfChoose()
    listener.init()


  init:init
  listener:listener
