#@2016.03.03
define "trendDialog",(require,exports)->

  mustache = require "mustache"
  chart    = require "charts"
  CHECKARR = [] # 已选基金
  TIME = 401 # 时间
  RTYPE = '1'
  COLOR_ARR = ["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
  ORIGIN_X =   # 缓存初始基金走势图的X轴
  tpl = 
    timeOption:"""
      {{#data}}
        <li value="{{index}}">{{name}}</li>
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

  listener =
    #时间列表渲染
    timeList : (list)->
      data = 
        data : list
      html = mustache.render(tpl.timeOption,data)
      $(".incomeTrend .time-select").empty().append(html)
      $(".incomeTrend .time-select li").filter('[value=401]').addClass('active')
    #对比标的列表渲染
    compareList : (list)->
      data = 
        data : list
      html = mustache.render(tpl.compareLi,data)
      $(".incomeTrend .pullBox").empty().append(html)

    incomeTrend : (fundCode,chartOption)-> # 收益走势弹框
      trendDialog = $("""<div class="incomeTrend">
              <div class="invest-close"></div>
              <div class='r-select'>
              <ul class="time-select">
              </ul>
              <div class="compare-select" data-code="CGB1Y">对比标的
                <i class="icon-down"></i>
                <ul class="pullBox">
                </ul>
              </div>
              <div data='3' class="percentSeries series">百分比坐标
                <i class='per'></i>
              </div>
              <div data='2' class="logSeries series">对数坐标
                <i class='log'></i>
              </div>
              <div data='1' class="lineSeries series active">线性坐标
                <i class='line'></i>
              </div>               
              </div>
              <div class="m-chart">

              </div>
          </div>""")
      $("body").append(trendDialog).append("<div class='mask'></div>").css('overflow-y', 'hidden')
      $(".invest-close").on 'click', (e) -> # 点击蒙层，弹框消失
        e.stopPropagation()
        listener.close()
        RTYPE = '1'
      trendDialog.find(".time-select option[value="+TIME+"]").attr("selected",true)
      trendDialog.find(".compare-select .pullBox li").each ->
        selfCode = +($ this).data("code")
        self = ($ this)
        CHECKARR.map (one)->
          if(one is selfCode)
            self.find("p").find("span").addClass("checked")

      listener.renderCharts(fundCode,chartOption)
      $(".incomeTrend .time-select").on "click","li",()->
        This=$(this)
        This.addClass('active')
        This.siblings().removeClass('active')
        val = +$(this).val()
        TIME = val
        if(CHECKARR.length isnt 0) # 存在对比项要加载
          listener.getCompare(CHECKARR,fundCode) #添加对比曲线
        else
          listener.renderCharts(fundCode,chartOption)

      $(".series").on "click",()->#坐标选取
        This=$(this)
        This.addClass('active')
        This.siblings().removeClass('active')
        RTYPE = This.attr('data')
        listener.renderCharts(fundCode,chartOption)

    renderCharts:(codes,chartOption)-> # 渲染图表
      $.ajax
        url:"/invest/list"
        type:"get"
        dataType:"json"
        data:
          fundCode:codes
          timeRange:TIME
          resultType:RTYPE
        success:(rs)->
          sType=$('.series.active').attr('data')
          switch sType
            when '1' then chartOption.yAxis.type = 'linear'
            when '2' then chartOption.yAxis.type = 'logarithmic'
            when '3' then chartOption.yAxis.type = 'linear'
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
          chartOption.exporting.buttons.contextButton.enabled = false # 去掉下载按钮
          chartOption.chart.height = 485
          chartOption.chart.backgroundColor = '#202427'
          chartOption.xAxis.tickInterval = Math.round(rs.data[0].xAxis.length/6)
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
          $(".incomeTrend .m-chart").highcharts(chartOption) # 绘制资产总览曲线
          if(CHECKARR.length isnt 0) # 存在对比项要加载
            listener.getCompare(CHECKARR,codes) #添加对比曲线
          else
            listener.addCompare(chartOption,codes)

    getData:->
      $.ajax
        url:"/invest/overview"
        type:"get"
        dataType:"json"
        data:
          uid:host
        success:(rs)->
          if(rs.code is 0)
            listener.timeList(rs.timeRangeList)
            listener.compareList(rs.comparingList)

    getCompare:(comp,fundCode)-> # 走势图对比
      $.ajax
        url:"/invest/comparing"
        type:"get"
        dataType:"json"
        data:
          comparing:comp.join(",")
          timeRange:TIME
          fundCode:fundCode
          resultType:RTYPE
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
          opt.xAxis.tickInterval = Math.round(rs.data[1].xAxis.length/6)
          # x_first = rs.data[0].xAxis.indexOf(ORIGIN_X[0])  #初始基金的x轴第一项在对比基金中的位置
          # x_last = rs.data[0].xAxis.indexOf(ORIGIN_X[ORIGIN_X.length-1]) #初始基金的x轴第一项在对比基金中的位置
          opt.exporting.buttons.contextButton.enabled = false # 去掉下载按钮
          opt.chart.backgroundColor = '#202427'
          opt.series = []
          # opt.series.push(oneSeri)# 加入总览数据
          for i in [0...rs.data.length]
            yAxisParse = []
            for one in rs.data[i].yAxis
              yAxisParse.push(+one)
            series =
              data:yAxisParse
              name:rs.data[i].name
              color:COLOR_ARR[i]
            opt.series.push(series)
          $(".incomeTrend .m-chart").highcharts(opt)

    addCompare:(chartOption,codes)-> # 添加对比
      #pullBox
      $("body").off("click").on "click",".incomeTrend .compare-select",(e)->
        e.stopPropagation()
        pullBox = $(this).find(".pullBox")
        if pullBox.css("display") is "none"
          pullBox.show()
        else
          pullBox.hide()

      .on "click",".incomeTrend .compare-select li",()->  # 选择对比标的
        self = $(this)
        code = self.data "code"
        checkbox = self.find("span")
        if checkbox.hasClass("checked") #取消选中
          checkbox.removeClass("checked")
          index = CHECKARR.indexOf(+code)
          CHECKARR.splice index,1
          if(CHECKARR.length is 0) # 没有对比项，渲染总览曲线
            listener.renderCharts(codes,chartOption)
          else
            listener.getCompare(CHECKARR,codes) #添加对比曲线
        else #选中
          checkbox.addClass("checked")
          CHECKARR.push(+code)
          listener.getCompare(CHECKARR,codes) #添加对比曲线

    close : () -> # 关闭浮层
      $(".incomeTrend").remove()
      $(".mask").remove()
      CHECKARR = []
      TIME = 401
      $('body').css 'overflow-y', 'auto'



  init = (code,chartOption)->
    listener.incomeTrend(code,chartOption)
    listener.getData()

  init:init
