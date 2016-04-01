#@2016.03.03
define "fundDetail",(require,exports)->

    c = require 'charts'
    trend = require 'trend'

    #柱状图
    bar =
        voliChart       : $ ".chart-volatility"
        retraceChart    : $ ".chart-retracement"
        timeChart       : $ ".chart-timeProfit"
        assetChart      : $ ".chart-assetContribution"
        scaleChart      : $ ".chart-scale"
        holdChart       : $ ".chart-instHold"

    #饼状图
    pie =
        assetInfoChart  : $ ".charts-asset"

    #接口
    ajaxUrl =
        chartUrl  :  '/fund/detail/chart'
        newsUrl   :  '/fund/detail/notices'
        assetUrl    :  '/fund/detail/asset'
        delFund   :  '/fund/userfund/del'
        addFund   :  '/fund/userfund/add'

    pBoxTpl =

        riskLi :"""<li class="riskLi clearfix" data-code="1">
                                    <p>收益率<i></i></p>
                                </li>
                                <li class="riskLi clearfix" data-code="2">
                                    <p>夏普指数<i></i></p>
                                </li>"""

        otherLi:"""<li class="otherLi clearfix" data-code="5">
                                    <p>波动率<i></i></p>
                                </li>
                                <li class="otherLi clearfix" data-code="6">
                                    <p>最大回撤<i></i></p>
                                </li>
                                <li class="otherLi clearfix" data-code="7">
                                    <p>择时损益<i></i></p>
                                </li>
                                <li class="otherLi clearfix" data-code="8">
                                    <p>资产配置贡献<i></i></p>
                                </li>
                                <li class="otherLi clearfix" data-code="9">
                                    <p>基金规模<i></i></p>
                                </li>
                                <li class="otherLi clearfix" data-code="10">
                                    <p>机构持仓<i></i></p>
                                </li>"""

    funList =
        #初始化
        init:->
            @getNews(1)
            @handleManager()
            @selfChose()
            @fontColor()
            @avgColor()


        #处理基金经理链接
        handleManager:()->
            html = ""
            linkUrl = "http://matrix.sofund.com/fundManager/detail?managerName="
            manArr = $.trim(fundManager).split(" ")
            for i in [0...manArr.length]
                if manArr[i] == ""
                    manArr.splice(i,1)
            for i in [0...manArr.length]
                html +=  """<a href="#{linkUrl}#{manArr[i]}" class="blue" target="_blank">#{manArr[i]}</a> """
            $('.manager').find('.data').append html

        #初始化舆情观察站
        getNews: (month)->
            $.ajax
                url:ajaxUrl.newsUrl
                type:'get'
                dataType:'json'
                data:
                    fundCode:fundCode
                    months:month
                success:(res)->
                    html = ""
                    if +res.code is 0 && res.notices.length isnt 0
                        data = res.notices
                        for i in [0...data.length]
                            newsDate = data[i].time.substr(8,2)
                            monthYear = data[i].time.substr(0,7)
                            html += """
                                <div class="new-box">
                                    <div class="new-time">
                                        <div class="nt-date">#{newsDate}</div>
                                        <div class="nt-y-m">#{monthYear}</div>
                                    </div>
                                    <div class="new-wrap">
                                        <a href="#{data[i].url}" class="new-title" target="_blank">#{data[i].title}</a>
                                        <a href="#{data[i].url}" class="new-source" target="_blank">#{data[i].sourceName}</a>
                                    </div>
                                </div>"""
                        
                        $('.news').append html
                    else 
                        $('.news').html """<div class="nodata"></div>"""   

        #自选按钮
        selfChose :()->
            selfBtn = $('.watch')
            if isFavorited is "true"
                selfBtn.text '取消自选'
                selfBtn.addClass 'active'
            else
                selfBtn.text '添加自选'
                selfBtn.removeClass 'active'

            selfBtn.off('click').on 'click',()->
                self = $(this)
                if self.text() is '添加自选'
                    $.ajax
                        url:ajaxUrl.addFund
                        type:'get'
                        dataType:'json'
                        data:
                            code:fundCode
                            fundName:fundName
                        success:(r)->
                            if +r.code is 0
                                self.text('取消自选')
                                selfBtn.addClass 'active'
                            else
                                $.toast r.msg
                else if self.text() is '取消自选'
                    $.ajax
                        url:ajaxUrl.delFund
                        type:'get'
                        dataType:'json'
                        data:
                            code:fundCode
                        success:(r)->
                            if r.code is 0
                                self.text('添加自选')
                                self.removeClass('active')
                            else
                                $.toast r.msg

        #修改数据颜色
        fontColor:()->
            $.each $('.font-color'),(i,n)->
                if $(n).text().substr(0,1) != '-'
                    $(n).addClass 'red'
                else if $(n).text().substr(0,2) != '--'
                    $(n).addClass 'green'

        #修改平均值数值展示
        avgColor:->
            $.each $('.average'),(i,n)->
                if $(n).find('span').text().substr(0,1) != '-'
                    $(n).find('span').addClass 'red'
                    $(n).find('i').addClass 'red-up'
                else if $(n).text().substr(0,2) != '--'
                    $(n).find('span').addClass 'green'
                    $(n).find('i').addClass 'green-down'
                    tmp = $(n).find('span').text().replace(/-/,'')
                    $(n).find('span').text(tmp)

    chartList = 

        #更改y轴和提示框 单位
        formatData: (chart,tag)->
            chart.tooltip.pointFormat = """<tr><td style="color:{series.color};padding:0">{series.name}: </td>
                <td style="padding:0"><b>{point.y:.4f}#{tag}</b></td></tr>"""
            chart.yAxis.labels.formatter = ->
                this.value + tag

        #资产配置详情
        assetPie:()->
            $.ajax
                url:ajaxUrl.assetUrl
                type:'get'
                dataType:'json'
                data:
                    fundCode:fundCode
                    quarter:3
                success:(r)->
                    if +r.code is 0
                        dataPie = []
                        htmlPie = ''
                        borderColor = ["#7ab5fb","#4d93e8","#3377c8","#2662aa","#1f508b","#0a3971","#512f8d","#6b46b0","#8762c9","#c34da1","#f43f62","#d44243","#f07330","#f19830","#ddcf3a","#37d3e0","#1fb5c3","#0c94a2","#107780","#076068"]
                        htmlBlock = ""
                        count = 0
                        $.each r,(i,n)->
                            if /\u5360\u6bd4/.test(i) and n isnt '0.00%'
                                formatN = +(n.replace(/%/,''))
                                dataPie.push(["#{i}",formatN]);

                                htmlBlock += """<li style="border-color:#{borderColor[count]}">
                                                <span class="float-l" style="color:#{borderColor[count]}">#{i}</span>
                                                <span class="float-r" style="color:#{borderColor[count]}">#{n}</span>
                                            </li>"""

                                count++

                            if /\u7387/.test(i) and n isnt '0.00%'
                                htmlPie += """<div class="sub-item">
                                <div class="item-title">#{i}</div>
                                <div class="item-value">#{n}</div>
                                </div>"""



                        pie.assetInfoChart.html htmlPie
                        c.charts.pieOption.series[0].data = dataPie
                        c.charts.pieOption.chart.marginLeft = -130
                        c.charts.pieOption.series[0].size = '80%'
                        c.charts.pieOption.series[0].innerSize = '40%'
                        c.charts.pieOption.exporting = ""
                        pie.assetInfoChart.highcharts(c.charts.pieOption)
                        pie.assetInfoChart.parent().append  """<ul class="block-data">
                                                                    #{htmlBlock}
                                                                </ul>"""
    
    #事件监听
    changeListener = 
        #初始化监听
        init:->
            @holdBtn($(".fund-name").text())
            @tabListener()

        #指标下拉框tab切换
        tabListener:()->
            tabs = $('.risk-select').find('.l-tabs').find('div')
            tabs.on 'click',(e)->
                e.stopPropagation()
                self = $(this)
                dataCode = +$('.risk-select').attr('data-code')
                dataId = +$('.risk-select').attr('data-id')
                console.log dataCode+","+dataId
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



        #申购请求接口
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

        #资产申购
        applyBuyMethod : (name)-> #资产申购
            $("""
                <div class="theCont">
                    <div class="lines">
                        <label for=''>资产名称</label>
                        <input type='text' value ="#{name}" class="applyBuy" placeholder='资产代码／资产名称'/>
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
                    fundCode = $(".applyBuy",dialog).val()
                    amount = $(".amount",dialog).val()
                    orderDate = $(".pickers",dialog).val()
                    changeListener.createOrder('purchase',fundCode,amount,orderDate)# 创建申购订单
                    window.open('http://matrix.sofund.com/invest')   #跳转

        #持仓盈亏按钮
        holdBtn:(name)->
            $('.invest').on 'click',()->
                changeListener.applyBuyMethod(name)
                $(".pickers").datepicker
                    inline: true
                    dateFormat: "yy-mm-dd"
                    showMonthAfterYear: true
                    monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
                    dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']


    init =->
        trend.init fundCode

        funList.init()
        changeListener.init()

        chartList.assetPie()

        


    init:init