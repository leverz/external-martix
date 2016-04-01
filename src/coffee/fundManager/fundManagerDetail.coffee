#@2016.03.03
define "managerDetail",(require,exports)->

    mustache = require "mustache"
    chartData = require "charts"

    #数据下载的两个全局变量
    FILE = 0 #全局文件类型变量
    TABS = ""#list选中的checkbox所代表的参数
    managerNames = ""
    downChartsX = []
    quarters = "2013Q1,2013Q2,2013Q3,2013Q4,2014Q1,2014Q2,2014Q3,2014Q4,2015Q1,2015Q2,2015Q3,2015Q4,"

    Highcharts.setOptions
        lang:
            printChart:"打印图表"
            downloadJPEG: "下载JPEG 图片"
            downloadPDF: "下载PDF文档"
            downloadPNG: "下载PNG 图片"
            downloadSVG: "下载SVG 矢量图"
            exportButtonTitle: "导出图片"

    
    ele =
      managerName : decodeURI($.getUrlParam("managerName"))#基金经理名字
      chartD:chartData.charts.fundIncomeOption
      chartQ:chartData.charts.callbackOption
      comp:'1'
      risk:'0'
      cIndex:'0'
      tIndex:'401'
      scope:'4'
      pair:'0,4'
      fundCode:''
    #模板#
    pBoxTpl =
      riskLi :"""<li class="riskLi clearfix" data-code="0">
          <p>收益率<i></i></p>
      </li>
      <li class="riskLi clearfix" data-code="10002">
          <p>夏普指数<i></i></p>
      </li>"""

      otherLi:"""<li class="otherLi clearfix" data-code="4">
            <p>波动率<i></i></p>
        </li>
        <li class="otherLi clearfix" data-code="5">
            <p>最大回撤<i></i></p>
        </li>
        <li class="otherLi clearfix" data-code="8">
            <p>基金规模<i></i></p>
        </li>
        <li class="otherLi clearfix" data-code="9">
            <p>机构持仓<i></i></p>
        </li>
        <li class="otherLi clearfix" data-code="6">
            <p>择时损益<i></i></p>
        </li>
        <li class="otherLi clearfix" data-code="7">
            <p>资产配置贡献<i></i></p>
        </li>"""


    tpl =
        #基金列表#
        fundTR: """
                {{#data}}
                    <tr>
                        <td data-code="{{fundCode}}"><a class="fund-name" href="http://matrix.sofund.com/fund/detail?code={{fundCode}} "target="_blank">{{fundName}}</a></td>
                        <td>{{fundType}}</td>
                        <td>{{yieldMoth1}}%</td>
                        <td>{{yieldMoth3}}%</td>
                        <td>{{yield}}%</td>
                        <td>{{sharpeIndex}}</td>
                        <td>{{volitality}}%</td>
                        <td>{{drawback}}</td>
                        <td>{{fundScale}}亿</td>
                        <td>{{instPosRatio}}%</td>
                        <td class="btn-watch"><i class="watchit{{selfFlag}}"></i></td>
                    </tr>
                {{/data}}
        """
        chenStar:"""<i class="star s-{{morningstarScore}}"></i>"""
        yinStar:"""<i class="star s-{{galaxyScore}}"></i>"""
        #右边栏基本信息
        basicData:"""
                  {{#data}}
                           <div class="nameSpace">
                          <span class="name">{{managerName}}</span>
                          <span class="fundName">({{company}})</span>
                      </div>
                      <div class="handleSpace clearfix">
                          <a href="{{compFund}}" class="handleBtn" id='compFund' target="_blank">对比其管理基金</a>
                          <a href="#" class="handleBtn addFavourite">{{added}}</a>
                      </div>
                      <div class="base">
                          <h3>基础情况</h3>
                          <div class="baseLine clearfix">
                              <label for="">擅长类型：</label><span>{{majorFundType}}</span>
                          </div>
                          <div class="baseLine clearfix">
                              <label for="">管理总规模：</label><span>{{totalScale}}</span>
                          </div>
                          <div class="baseLine clearfix">
                              <label for="">管理时间：</label><span>{{period}}</span>
                          </div>
                      </div>
                      <div class="base managerIntro">
                          <h3>经理简历</h3>
                          <div class="baseLine clearfix">
                              <label style='line-height:24px;'>学历信息：</label><span style='max-width:190px;display:inline-block;line-height:24px;'>{{degreeNote}}</span>
                          </div>
                          <div class="career">
                              <div class="tit">从业经历：</div>
                              <div><p class='note' style="height:220px;overflow: hidden;">{{career}}</p></div>                                    
                          </div>
                      </div>
                  {{/data}}
          """
        compareSelect:"""
                      {{#data}}

                      {{/data}}
                      """
        #基金经理详情页内容
        managerDetail :  """
                        
                    <div class="downloadBox">
                        <div class="dTitle clearfix">
                            <div class="dTitleText">数据下载</div>
                            <i class="dIcon dBoxClose"></i>
                        </div>
                        <div class="listContent">
                            <ul>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundInfo"> <label for="fundInfo">经理基本信息</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundAll"> <label for="fundAll">总览</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundData"> <label for="fundData">管理的基金</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                            <input type="checkbox" id="fundLei"> <label for="fundLei">收益指标</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundDan"> <label for="fundDan">风险指标</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundFlow"> <label for="fundFlow">流动性</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundGood"> <label for="fundGood">机构青睐</label>
                                            </span>
                                            <span class="child-input">
                                                <input type="checkbox" id="fundStar"> <label for="fundStar">基金评级</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundIncome"> <label for="fundIncome">盈利能力</label>
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
                                        <input type="checkbox" id="fundRisk"> <label for="fundRisk">风控水平</label>
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
                                        <input type="checkbox" id="fundLiu"> <label for="fundLiu">管理规模</label>
                                        <div class="child-wrap">
                                            <span class="child-input">
                                                <input type="checkbox" id="fundSize"> <label for="fundSize">基金规模</label>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="father-input">
                                        <input type="checkbox" id="fundJigou"> <label for="fundJigou">机构持仓</label>
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
      
        #获取基金#
        getFund: (isSort,isFilter)->
            url = "/fundManager/fundList" 
            $.ajax
                url:url
                type:'post'
                dataType:'json'
                async:false
                data:
                  managerName:ele.managerName
                success:(res)->
                    if(+res.code is 0)
                      for i in [0...res.data.length]
                        if res.data[i].fundType is '货币型'
                          data =
                              data:res.data[i].list
                              drawback:->
                                  if @maxDrawback is 0 then '--' else @maxDrawback
                              selfFlag:->
                                  if @addFlag then ' watching' else ''
                              chenStar:->
                                  if @morningstarScore is 0 then '--' else tpl.chenStar
                              yinStar:->
                                  if @galaxyScore is 0 then '--' else tpl.yinStar
                          compare=res.data[i].list.length  #对比其管理基金判断
                          arry=[]
                          if compare > 1
                            for j in [0...compare]
                              arry[j]=res.data[i].list[j].fundCode
                            ele.fundCode=arry.join(',')                         
                      html = mustache.render(tpl.fundTR,data)                   
                      $("#fundList").empty().append(html)
                    else
                        $.toast "暂无数据"
        #获取基本信息#
        getBasic:()->
          $.ajax
            url:'/fundManager/basic'
            type:'get'
            dataType:'json'
            data:
              managerName:ele.managerName
              type:'货币型'
            success:(rs)->
              if +rs.code is 0
                if $(".compare-select").find("li").length is 0
                  action.renderCompareList rs.comparingList
                  action.renderRiskList()
                # 基金
                note=''
                data =
                  data:rs 
                  managerName:-> 
                    return ele.managerName
                  career:->
                    note=this.careerNote.replace(/;/gm,'<br>')
                    return note
                  added:->
                    if @isAdded is 'true' then '取消自选' else '加入自选'
                  compFund:-> #对比其管理基金判断
                    if ele.fundCode.length>7
                      return 'http://matrix.sofund.com/fund/compare?code='+ele.fundCode
                    else
                      return 'javascript:void(0)'
                temp = mustache.render(tpl.basicData,data)
                $(".intro").empty().append(temp)
                $('.note').html(note)
        #获取对比标的#     
        getChartD : (cindex,tindex)->
          $.ajax
            url:'/fundManager/daily'
            type:'get'
            dataType:'json'
            data:
              managerName:ele.managerName
              type:'货币型'
              comparing:cindex
              timeRange:tindex
            success:(r)->
              xArr = []
              xArr = r.data[0].xAxis
              serieS = []
              for i in [0...r.data.length]
                  xAxisParse = []
                  yAxisParse = []
                  for one in r.data[i].xAxis # 转换为数值
                    xAxisParse.push(one)
                  for one in r.data[i].yAxis # 转换为数值
                    yAxisParse.push(+one)
                  series =
                    data:yAxisParse                                            
                    name:r.data[i].name                    
                  serieS.push(series)
              if serieS.length is 1 #判断线条数量改变样式
                ele.chartD.chart.type = 'area'
                 
                ele.chartD.plotOptions = area:
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
                  ele.chartD.chart.type = 'spline'
                   
                  ele.chartD.plotOptions = spline:
                      lineWidth: 1
                      states:
                          hover:
                              lineWidth: 1.5
                      marker:
                          enabled: false
              ele.chartD.series = serieS
              ele.chartD.series[0].name = ele.managerName
              ele.chartD.xAxis.categories=xAxisParse
              downChartsX = xAxisParse
              ele.chartD.xAxis.tickInterval = Math.round(xArr.length/5)
              $('.chartD').highcharts(ele.chartD)
        getChartQ : (pair,tindex)->
          $.ajax
            url:'/fundManager/quarter'
            type:'get'
            dataType:'json'
            data:
              managerName:ele.managerName
              type:'货币型'
              pair:pair
              timeRange:tindex
            success:(r)->
              xArr = []
              xArr = r.data[0].xAxis             
              serieS = []
              for i in [0...r.data.length]
                yAxisParse = []
                if r.data[i].yAxis.length > 0
                  for one in r.data[i].yAxis # 转换为数值                   
                      yAxisParse.push(+one)
                  series =
                    data:yAxisParse
                    name:r.data[i].name 
                  serieS.push(series)
              if r.data[0].xAxis.length is 0
                action.showNoData()
              else
                if serieS.length < 2
                  ele.chartQ.plotOptions.column.pointPadding = 0
                  ele.chartQ.plotOptions.column.groupPadding = 0.4
                displayType = r.data[0].scope
                tag = if displayType is 8 then "亿" else "%"
                action.formatData ele.chartQ, tag
                ele.chartQ.series = serieS
                ele.chartQ.series[0].name = ele.managerName
                ele.chartQ.xAxis.categories=xArr
                ele.chartQ.xAxis.tickInterval = null
                $('.chartQ').highcharts(ele.chartQ)
                action.formatData ele.chartQ,"%"
        #添加自选经理#
        addSelf: (data,selfBtn)->
            $.ajax
                url:"/fundManager/addFavourite"
                type:'get'
                dataType:'json'
                data: 
                  managerName:ele.managerName
                success:(res)->
                    if +res.code is 0
                      if $('.addFavourite').text() is '取消自选'
                        $('.addFavourite').text('加入自选')
                        $.toast res.msg
                      else
                        $('.addFavourite').text('取消自选')
                        $.toast res.msg
        #添加自选基金#
        addSelfFund: (data,selfBtn)->
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

    action =
        # 渲染risk列表
        renderRiskList : ()->
            risk = $(".risk-select")
            risk.pullBox
                callback:(list)->
                  if list[3] is 0
                    ele.risk=list[1]
                    request.getChartD(ele.cIndex,ele.tIndex)
                  if list[3] is 1
                    ele.scope=list[2]
                    ele.cIndex=list[0]
                    action.scopeReplace()
                    request.getChartQ(ele.pair,ele.tIndex)
        # 渲染对比列表
        renderCompareList:(data)->
            compare = $(".compare-select")
            compare.pullBox
                data: data
                codeList: compare.data("code").split(",")
                liTpl:"""<li class="compareLi clearfix" data-code="rCode">
                            <p>rName</span>
                            <span rChecked></span>
                    </li>"""
                headTpl:"对比标的<i class='icon-down'></i><ul class='pullBox rPosition' style='display:none;z-index:1'>"
                footTpl:"</ul>"
                callback:(list)->
                    compare.attr "index",list
                    month = $(".time-select").val()
                    type = $(".risk-select").val()
                    ele.cIndex = $(".compare-select").attr('data-code')
                    arr=$(".compare-select").attr('data-code').split(',')
                    action.scopeReplace()                                   
                    request.getChartD(ele.cIndex,ele.tIndex)
                    request.getChartQ(ele.pair,ele.tIndex)
                    if ele.risk is '10002'
                      ele.pair=ele.pair.replace(/10002/gm,'0')
                      request.getChartD(ele.cIndex,ele.tIndex)
                      request.getChartQ(ele.pair,ele.tIndex)
                      if ele.tIndex is '101'
                        action.showNoData()
        showNoData:->
            html='''<div class="nodata"></div>'''
            $('.chartQ').html(html)
        formatData: (chart,tag)->
            # chart.tooltip.pointFormat = """<tr><td style="color:{series.color};padding:0">{series.name}: </td>
            #     <td style="padding:0"><b>{point.y:.2f}#{tag}</b></td></tr>"""
            chart.yAxis.labels.formatter = ->
              this.value + tag

        scopeReplace:->
            ele.cIndex =ele.risk+ele.cIndex 
            ele.pair =ele.cIndex.replace(/,/gm,','+ele.scope+',')
            ele.pair = ele.pair+','+ele.scope

        #基金排序#
        fundSort:(sortTag,self)->
            switch sortTag
                when "","sort-up"
                    self.removeClass("sort-up").addClass "sort-down"
                    DIRECTION = 1
                when "sort-down"
                    self.removeClass("sort-down").addClass "sort-up"
                    DIRECTION = 0
            SORT_BY = self.data "sort"
            PAGE_INDEX = 1
            request.getFund(1,0)

        #数据下载相关函数
        differentiate:()->
            FILE = 3
            managerNames = $(".name").text() 
            $("body").append(tpl.managerDetail).css('overflow-y','hidden')
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
                fundManager : managerNames
            TIMES = 
                data: [
                    {'parentId':'0','startDate':'','endDate':'',quarter:''},# 基本信息
                    {'parentId':'1','startDate':'','endDate':'',quarter:''},# 管理的基金
                    {'parentId':'2','startDate':downChartsX[0],'endDate':downChartsX[downChartsX.length-1],'quarter':''},#盈利能力
                    {'parentId':'3','startDate':'','endDate':'','quarter':quarters},#风控水平
                    {'parentId':'4','startDate':'','endDate':'','quarter':quarters},#择时能力
                    {'parentId':'5','startDate':'','endDate':'','quarter':quarters},#资产贡献
                    {'parentId':'6','startDate':'','endDate':'','quarter':quarters},#管理规模
                    {'parentId':'7','startDate':'','endDate':'','quarter':quarters}#机构青睐
                ]
            window.open "http://matrix.sofund.com/download/excelnew?"+$.param(data)+"&"+$.param(data1)+"&times="+JSON.stringify(TIMES)
            $(".downloadBox").remove()
            $(".mask").remove()


    #事件监听#
    listener =
        init:->
            @changeComparing()
            @changeDate()
            # @card()
            @addFavourite()
            @selfOption()
            @close()
            @cancle()
            @download()
            @tabListener()

        #指标下拉框tab切换
        tabListener:()->
          tabs = $('.risk-select').find('.l-tabs').find('div')
          tabs.on 'click',(e)->
            e.stopPropagation()
            self = $(this)
            dataCode = +$('.risk-select').attr('data-code')
            dataId = +$('.risk-select').attr('data-id')
            if !self.hasClass('active')
              self.siblings().removeClass('active')
              self.addClass('active')
              if self.hasClass('profit-tab')
                self.parents('.pullBox').find('.otherLi').remove()
                self.parents('.label-li').after pBoxTpl.riskLi
                $(".riskLi[data-code= #{dataCode}]").find('i').addClass('checked')
              else if self.hasClass('other-tab')
                self.parents('.pullBox').find('.riskLi').remove()
                self.parents('.label-li').after pBoxTpl.otherLi
                $(".otherLi[data-code=#{dataId}]").find('i').addClass('checked')

        #自选基金操作#
        selfOption:->
            $("tbody").on "click",".watchit",->
                self = $(this)
                parent = self.parents("tr")
                data =
                    code:parent.find("td:first").attr "data-code"
                    fundName:parent.find("td:first").children().text()
                if self.hasClass("watching")
                    request.cancelSelf data,self
                else
                    data.fundName = parent.find(".fund-name").text()
                    request.addSelfFund data,self
        #自选经理操作#
        addFavourite:->
            $('.intro').on 'click','.addFavourite',()->
              request.addSelf()   
        #改变基金类型筛选基金#
        # card:->
        #     $('.c-tab-bar').find('.tabs').on 'click',()->             
        #         self = $(this)
        #         compareCode = +self.attr('data-code')
        #         ele.pair=ele.pair.replace(new RegExp(ele.scope,'g'),compareCode)
        #         ele.scope=compareCode
        #         if ele.risk is '10002'
        #             ele.pair=ele.pair.replace(/10002/gm,'0')                 
        #         if self.hasClass('active')                  
        #           request.getChartQ(ele.pair,ele.tIndex)
        #         else if !self.hasClass('active')
        #           self.parent().find('.tabs').removeClass('active')
        #           self.addClass('active')
        #           request.getChartQ(ele.pair,ele.tIndex)
        changeComparing:->
            $(".compare-select").off().on "click",->
                ele.cIndex=$(this).attr('data-code')
                request.getChartD(ele.cIndex,ele.tIndex)

        changeDate:->
            $(".time-select li").on "click",->
                ele.tIndex=$(this).val()
                request.getChartD(ele.cIndex,ele.tIndex)
                request.getChartQ(ele.pair,ele.tIndex)
                This=$(this)
                This.addClass('active')
                This.siblings().removeClass('active')

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

            
       
    init = ->
        listener.init()
        request.getFund()
        request.getBasic()
        request.getChartD(ele.cIndex,ele.tIndex)
        request.getChartQ(ele.pair,ele.tIndex)
        #第一次手动触发筛选获取基金列表#
        $(".submit-filter").trigger "click"
        $(".down-data").off("click").on "click",->
          action.differentiate()

    init:init


 