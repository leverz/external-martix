#@2016.03.03
define "charts",(require,exports)->

  charts =
    # 环形图
    circleChart:
      chart:
        backgroundColor:'#202427'
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow: false
        marginBottom:180
      title:
        text: ''
      credits:
        enabled: false
      legend:
        enabled:false
      tooltip:
        backgroundColor:'#202427'
        borderWidth:0
        shadow:false
        useHTML:true
        hideDelay:4320000
        style:
          color:'#9eacbf'
          padding:'8px'
          fontSize:'14px'
        headerFormat: '<div class="borderLeft" style="display:inline-block;height:100px;width:4px;float:left;margin-left:22px"></div>'+
                    '<div style="display:inline-block;padding-left:10px;width:240px">'+
                    '<div style="font-size:14px;color:#fff;width:100%;font-weight:bold;padding-bottom:20px;">{point.key}</div>'+
                    '<table style="width:100%;">'
        pointFormat:  '<tr><td style="padding:0;width:30%;">资产价值 ：</td><td class="totalProperty" style="padding:0;font-weight:bold;"></td></tr>'+
                      '<tr><td style="padding:0;width:30%;">{series.name} ：</td>' +
                      '<td style="padding:0;"><b>{point.y:.2f} %</b></td></tr>'+
                      '<tr><td style="padding:0;width:30%;">持有份额 ： </td><td class="holdingVolume" style="padding:0;font-weight:bold;"></td></tr>'
        footerFormat: '</table></div>'
        followPointer:false
        positioner:()->
            return { x: 0, y: 260 }
      plotOptions:
        pie:
          allowPointSelect: true
          cursor: 'pointer'
          colors:["#7ab5fb","#4d93e8","#3377c8","#2662aa","#1f508b","#0a3971","#512f8d","#6b46b0","#8762c9","#c34da1","#f43f62","#d44243","#f07330","#f19830","#ddcf3a","#37d3e0","#1fb5c3","#0c94a2","#107780","#076068"],
          # colors:["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
          dataLabels:
            enabled: false
          borderWidth:0
          showInLegend: true
          innerSize:68
      series: [{
        type: 'pie',
        name: '资产占比',
        colors:["#7ab5fb","#4d93e8","#3377c8","#2662aa","#1f508b","#0a3971","#512f8d","#6b46b0","#8762c9","#c34da1","#f43f62","#d44243","#f07330","#f19830","#ddcf3a","#37d3e0","#1fb5c3","#0c94a2","#107780","#076068"],
        data: [
          {
            name: 'Firefox',
            y: 45.0,
            sliced: true,
            selected: true
          },
          {
            name: 'IE',
            y: 26.8,
            sliced: false,
            selected: false
          },
          {
            name: 'Chrome',
            y: 12.8,
            sliced: false,
            selected: false
          },
          {
            name: 'Safari',
            y: 8.5,
            sliced: false,
            selected: false
          },
          {
            name: 'Opera',
            y: 6.2,
            sliced: false,
            selected: false
          },
          {
            name: 'Others',
            y: 0.7,
            sliced: false,
            selected: false
          }
        ]
      }]
      exporting:
        buttons:
          contextButton:
            enabled:false

    #（雷达图）
    riskOption:
      chart:
        polar: true,
        type: 'area'
        width:310
        height:220
        marginLeft:40
        marginTop:30
        spacingTop:0
        backgroundColor:'#4d4d51'
      title:
        text: null
      pane:
        size: '80%'
      xAxis:
        categories: ['收益水平', '从业时间', '管理规模', '择时能力','风控管理']
        tickmarkPlacement: 'on'
        lineWidth: 0
        labels:
          style:
            color: '#aaa'
            fontSize: '12px'

        tickColor: '#FF0000'
        gridLineWidth: 1
        gridLineColor:'#747377'

      yAxis:
        gridLineInterpolation: 'polygon'
        gridLineWidth: 1
        gridLineColor:'#747377'
        lineWidth: 0
        min: 0
        labels:
          enabled: false
        tickInterval:2
        max:10
        plotBands: [
          color: '#4d4d51',
          from: 0,
          to: 10
        ]
      tooltip:
        enabled: true
        shared: false
        valueSuffix:"a"
        pointFormat: '<span style="color:{series.color}">{series.name}: <b>{point.y:,.2f}</b><br/>'

      credits:
        enabled: false

      legend:
        enabled: false

      plotOptions:
        line:
          lineWidth: 1
        area:
          color: '#9f4e4f'
          lineWidth: 0
          marker:
            enabled: false
        arearange:
          fillColor:'#4d4d51'

      series: [{
        name: "评分",
        data: [1, 2, 3, 5, 3],
        pointPlacement: 'on'
      }]
      exporting:
        buttons:
          contextButton:
            x:-15
            y:20
            theme:
              'stroke-width': 0
              fill:'#4d4d51'
              stroke:'#3f3f42'
              states:
                hover:
                  fill:'#3f3f42'
                  stroke:'#fff'
                select:
                  fill:'#3f3f42'
                  stroke:"#fff"


    #（双柱状图）
    callbackOption:
      chart:
        type: 'column'
        spacingRight:0
        spacingBottom:5
        spacingLeft:0
        spacingTop:0
        backgroundColor:'#202427'
        
      colors:["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
      credits:
        enabled : false
      title:
        text: ''

      subtitle:
        text: ''

      xAxis:
        categories: []
        labels:
          style:
            color: '#9eacbf'
            fontSize: "12px"
            fontWeight: "bold"
            fontFamily: "Tahoma"
        lineColor:'#5c6c79'
        lineWidth:1
        tickLength:0

      yAxis:
        gridLineColor:'#374148'
        title:null
        lineWidth: 1
        lineColor: '#5c6c79'
        opposite: true
        offset:30
        labels:
          format: '{value}%'
          offset:10
          style:
            color: '#9eacbf'
            fontSize: "12px"
            fontWeight: "bold"
            fontFamily: "Tahoma"
          align: 'right'
          x: -5
          y: 0 
        
      # legend:
      #   align: 'right'
      #   # labelFormatter:->
      #   #   cTmp = this.color
      #   #   this.legendItem.styles.fill = this.legendItem.styles.color = cTmp
      #   #   console.log this
      #   #   return this.name
      #   itemStyle:
      #     color:'#888'
      #     # width:3
      #   verticalAlign: 'top'
      #   x: -50
      #   y: 0
      legend:
        align: 'right'
        itemStyle:
          color:'#888'
          # width:3
        verticalAlign: 'top'
        x: -50
        y: 5
      tooltip:
        # backgroundColor:'#363f46'
        # headerFormat: '<span style="font-size:12px">{point.key}</span><table>'
        # pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
        #     '<td style="padding:0"><b>{point.y:.2f} %</b></td></tr>'
        # footerFormat: '</table>'
        headerFormat: '<span style="font-size:12px;color:#9facbc;font-weight:bold;padding-bottom:5px;">{point.key}</span><table style="display:table;margin-top:5px;">'
        pointFormat: '<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>' +
            '<td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} %</b></td></tr>'
        footerFormat: '</table>'
        backgroundColor:'rgba(53,62,67,0.85)'
        borderColor: '#5e6c79'
        borderRadius:4
        shared: true
        useHTML: true
        crosshairs:[
          {
            dashStyle:'ShortDash'
          },
          {
            dashStyle:'ShortDash'
          }
        ]

      plotOptions:
        column:
          borderWidth: 0
          pointPadding: 0
          groupPadding:0.4
      credits:
          enabled: false
      series: [
        {
          name: '新华行业轮换灵活配置A',
          # color:'fff',
          data: [49.9, 71.5, 106.4, 129.2, 144.0, 176.0, 135.6, 148.5, 216.4, 194.1, 95.6, 54.4]
        },
        {
          name: '国债收益率曲线',
          # color:'#b85722',
          data: [83.6, 78.8, 98.5, 93.4, 106.0, 84.5, 105.0, 104.3, 91.2, 83.5, 106.6, 92.3]
        }
      ]
      exporting:
        buttons:
          contextButton:
            theme:
              'stroke-width': 0
              fill:'#3f3f42'
              stroke:'#3f3f42'
              states:
                hover:
                  fill:'#3f3f42'
                  stroke:'#fff'
                select:
                  fill:'#3f3f42'
                  stroke:"#fff"

    #单柱状层叠图
    singleCascadeOption:
        chart:
          type: 'column'
          spacingRight:0
          spacingBottom:20
          spacingLeft:0
          spacingTop:0
          backgroundColor:'#202427'
          
        colors:["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
        title:
            text: null
        credits:
            enabled: false
        legend:
            align: 'right'
            itemStyle:
                color:'#fff'
            verticalAlign: 'top'
            x: -30
            y: 0
        xAxis:
          categories: []
          labels:
            style:
              color: '#9eacbf'
              fontSize: "12px"
              fontWeight: "bold"
              fontFamily: "Tahoma"
          lineColor:'#5c6c79'
          lineWidth:1
          tickLength:0

        yAxis:
          gridLineColor:'#374148'
          title:null
          lineWidth: 1
          lineColor: '#5c6c79'
          opposite: true
          labels:
            format: '{value}%'
            style:
              color: '#9eacbf'
              fontSize: "12px"
              fontWeight: "bold"
              fontFamily: "Tahoma"
            align: 'right'
            x: -10
            y: -10  
        plotOptions:
            column:
                stacking:'normal'
                borderWidth:0
                pointPadding: 0
                groupPadding:0.4
        tooltip:
            # headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
            # pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            #     '<td style="padding:0"><b>{point.y:.4f}%</b></td></tr>'
            # footerFormat: '</table>'
            headerFormat: '<span style="font-size:12px;color:#9facbc;font-weight:bold;padding-bottom:5px;">{point.key}</span><table style="display:table;margin-top:5px;">'
            pointFormat: '<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>' +
                '<td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} %</b></td></tr>'
            footerFormat: '</table>'
            backgroundColor:'rgba(53,62,67,0.85)'
            borderRadius:4
            borderColor: '#5e6c79'
            shared: true
            useHTML: true
            # formatter: ()->
            #     '<b>'+ $("#basicInfo th").eq(this.stack+1).text() + this.x + '</b><br/>' + this.series.name + ': ' + this.y + '%<br/>'
            crosshairs:[true,false]
            
        series: []
        exporting:
            buttons:
                contextButton:
                    theme:
                        'stroke-width': 0
                        fill:'#3f3f42'
                        stroke:'#3f3f42'
                        states:
                            hover:
                                fill:'#3f3f42'
                                stroke:'#fff'
                            select:
                                fill:'#3f3f42'
                                stroke:"#fff"

    #（单柱状图）
    fundSizeOption:
      chart:
        type: 'column'
        spacingRight:0
        spacingBottom:20
        spacingLeft:0
        spacingTop:0
        backgroundColor:'#202427'
        
      colors:["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
      title:
        text: ''

      xAxis:
        categories: []
        labels:
          style:
            color: '#9eacbf'
            fontSize: "12px"
            fontWeight: "bold"
            fontFamily: "Tahoma"
        lineColor:'#5c6c79'
        lineWidth:1
        tickLength:0

      yAxis:
        gridLineColor:'#374148'
        title:null
        lineWidth: 1
        lineColor: '#5c6c79'
        opposite: true
        labels:
          format: '{value}%'
          style:
            color: '#9eacbf'
            fontSize: "12px"
            fontWeight: "bold"
            fontFamily: "Tahoma"
          align: 'right'
          x: -10
          y: -10  

      legend:
        enabled: false

      tooltip:
        # headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
        # pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
        #     '<td style="padding:0"><b>{point.y:.1f} %</b></td></tr>'
        # footerFormat: '</table>'
        headerFormat: '<span style="font-size:12px;color:#9facbc;font-weight:bold;padding-bottom:5px;">{point.key}</span><table style="display:table;margin-top:5px;">'
        pointFormat: '<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>' +
            '<td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} 亿</b></td></tr>'
        footerFormat: '</table>'
        backgroundColor:'rgba(53,62,67,0.85)'
        borderRadius:4
        borderColor: '#5e6c79'
        shared: true
        useHTML: true
        crosshairs:[
          {
            dashStyle:'ShortDash'
          },
          {
            dashStyle:'ShortDash'
          }
        ]
      plotOptions:
        column:
          borderWidth: 0
          pointPadding: 0
          groupPadding:0.4
      series: [
        name: 'Population'
        # color: '#993e3d'
        data: [34.4, 21.8, 20.1, 20, 19.6, 19.5, 19.1, 18.4, 18,
               17.3, 16.8, 15, 14.7, 14.5, 13.3, 12.8, 12.4, 11.8,
               11.7, 11.2]
      ]
      credits:
          enabled: false
      exporting:
        buttons:
          contextButton:
            theme:
              'stroke-width': 0
              fill:'#3f3f42'
              stroke:'#3f3f42'
              states:
                hover:
                  fill:'#3f3f42'
                  stroke:'#fff'
                select:
                  fill:'#3f3f42'
                  stroke:"#fff"

    # (双曲线)
    fundIncomeOption:
      chart:
        type: 'spline'
        spacingRight:0
        spacingBottom:8
        spacingLeft:0
        spacingTop:10
        backgroundColor:'#202427'
        
      colors:["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
      title:
        text: null
      xAxis:
        categories: [4,5,6]
        tickInterval: 0
        lineColor:'#5c6c79'
        lineWidth:1
        tickColor:'#5c6c79'
        # tickPosition: 'inside'
        tickLength: 5
        offset: 30
        #highstock
        crosshair:
          dashStyle:'ShortDash'
          width:1
          label:
            enabled:true
            formatter:->
              return this.chart.hoverPoint.category
            backgroundColor:'#384148'
            style:
              color:'#9eacbf'
        labels:          
          align: 'center'
          x: 0
          y: -10
          rotation: 0
          style:
            color:'#9eacbf'
            fontSize: "12px"
            fontWeight: "bold"
            fontFamily: "Tahoma"
      yAxis:
        # type: 'logarithmic'
        gridLineColor:'#374148'
        opposite: true
        offset: 30
        # tickInterval: 3
        crosshair:
          dashStyle:'ShortDash'
          width:1
        title:
          text: null
        labels:
          format: '{value} %'
          style:
            color: '#9eacbf'
            fontSize: "12px"
            fontWeight: "bold"
            fontFamily: "Tahoma"
          align: 'right'
          x: -5
          y: 5  
        lineColor:'#5c6c79'
        lineWidth:1
        tickColor:'#5c6c79'
        tickPosition: 'inside'
      tooltip:
        headerFormat: '<span style="font-size:12px;color:#9facbc;font-weight:bold;padding-bottom:5px;">{point.key}</span><table style="display:table;margin-top:5px;">'
        pointFormat: '<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>' +
            '<td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} %</b></td></tr>'
        footerFormat: '</table>'
        shared: true
        useHTML: true
        backgroundColor:'rgba(53,62,67,0.85)'
        borderColor: '#5e6c79'
        borderRadius: 4
      legend:
        align: 'right'
        itemStyle:
          color:'#888'
          # width:3
        verticalAlign: 'top'
        x: -50
        y: 0
      plotOptions:
        # area:
        #   lineWidth: 1
        #   states:
        #     hover:
        #       lineWidth: 1.5
        #   marker:
        #     enabled: false
        #   fillColor:
        #     linearGradient:
        #       x1:0
        #       y1:0
        #       x2:0
        #       y2:1
        #     stops:[
        #       [0,Highcharts.getOptions().colors[0]],
        #       [1,Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
        #     ]
        spline:
          lineWidth: 1
          states:
            hover:
              lineWidth: 1.5
          marker:
            enabled: false
      credits:
        enabled: false
      series:[
        {
        #   type: 'area'
          name: "新华基金A"
          dataLabels:
            enabled: false
          data:[0, -0.38, -0.25, -0.04, 0, -0.34, -0.04, -0.3, -1.02, -0.3, -0.21, -0.38, -0.25, 0.21, 0.08, -0.85, -0.76, -0.59, -0.55, -0.13, -0.3, 0.25, -0.04]
        },
        {
        #   type:'area'
          name: "国债收益率曲线"
          data:[0, 1.24, 1.05, 1.06, 0.05, -1.24, -0.77, -0.92, -2.05, -0.49, -0.5, -1.06, -1.04, -0.31, -0.89, -6.23, -5.98, -5.32, -1.88, -1.16, -3.05, -2.79, -2.79]
        }
      ]
      exporting:
        buttons:
          contextButton:
            theme:
              'stroke-width': 0
              fill:'#202427'
              stroke:'#3f3f42'
              states:
                hover:
                  fill:'#3f3f42'
                  stroke:'#fff'
                select:
                  fill:'#3f3f42'
                  stroke:"#fff"

    # (单曲线)
    chartIndexOption:
      chart:
        type: 'spline'
        spacingTop:40
        backgroundColor:'#3f3f42'
        
      title:
        text: null
      xAxis:
        categories: []
        lineColor:'#48484c'
        lineWidth:1
        tickColor:'#48484c'
        tickPosition: 'inside'
      yAxis:
        gridLineColor:'#48484c'
        title:
          text: null
        labels:
          format: '{value}% '
        lineColor:'#48484c'
        lineWidth:1
        tickColor:'#48484c'
        tickPosition: 'inside'
      tooltip:
        headerFormat: '<span style="font-size:12px;color:#9facbc;font-weight:bold;padding-bottom:5px;">{point.key}</span><table style="display:table;margin-top:5px;">'
        pointFormat: '<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>' +
            '<td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} %</b></td></tr>'
        footerFormat: '</table>'
        backgroundColor:'rgba(53,62,67,0.85)'
        borderColor: '#5e6c79'
        borderRadius:4
        useHTML:true
        shared:true
        crosshairs:[
          {
            width: 1,
            color: '#999',
            dashStyle:'ShortDash'
          },
          {
            width: 1,
            color: '#999',
            dashStyle:'ShortDash'
          }
        ]
        valueSuffix: '%'
        crosshairs:
          width: 1
          color: '#D8D8D8'
      legend:
        align: 'right'
        itemStyle:
          color:'#fff'
        verticalAlign: 'top'
        x: -30
        y: 0
      plotOptions:
        # area:
        #   fillColor:
        #     linearGradient:[0,0,0,300]
        #     stops:[
        #       [0,Highcharts.getOptions().colors[0]],
        #       [1,Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
        #     ]
        spline:
          lineWidth: 2
          states:
            hover:
              lineWidth: 2.5
          marker:
            enabled: false
      credits:
        enabled: false
      series:[
        {
          name: "SHIBORON"
          # color: '#5cb8ee'
          dataLabels:
            enabled: false
          data:[]
        }
      ]

      exporting:
        buttons:
          contextButton:
            theme:
              'stroke-width': 0
              fill:'#3f3f42'
              stroke:'#3f3f42'
              states:
                hover:
                  fill:'#3f3f42'
                  stroke:'#fff'
                select:
                  fill:'#3f3f42'
                  stroke:"#fff"

    #饼图
    pieOption :
      chart:
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        backgroundColor: null,
        marginLeft:-250;
        style:
          zIndex : 100
      
      title:
        text: null
      tooltip:
        enabled: false,
        shared: false,
        valueDecimals: 2,
        valueSuffix: '%'
      plotOptions:
        pie:
          allowPointSelect: true,
          cursor: 'pointer',
          shadow: false,
          dataLabels:
            enabled: false
          showInLegend: true,
          colors:["#7ab5fb","#4d93e8","#3377c8","#2662aa","#1f508b","#0a3971","#512f8d","#6b46b0","#8762c9","#c34da1","#f43f62","#d44243","#f07330","#f19830","#ddcf3a","#37d3e0","#1fb5c3","#0c94a2","#107780","#076068"],
          # colors:["#7ab4fa","#ff40ff","#9a37ff","#4683eb","#00fdff","#f2c314","#e8922a","#ce3f19","#00999a","#9ec5ea","d9d9d9"]
      tooltip:
        headerFormat: '<span style="font-size:12px;color:#9facbc;font-weight:bold;padding-bottom:5px;">{point.key}</span><table style="display:table;margin-top:5px;">'
        pointFormat: '<tr><td style="color:#9facbc;padding:2px 0;font-size:12px;"><span style="display:inline-block;width:3px;height:13px;margin-right:5px;background:{series.color};vertical-align:middle;"></span>{series.name}  </td>' +
            '<td style="padding:2px 0 2px 20px;color:#9facbc"><b>{point.y:.4f} %</b></td></tr>'
        footerFormat: '</table>'
        backgroundColor:'rgba(53,62,67,0.85)'
        borderColor: '#5e6c79'
        borderRadius:4
        useHTML:true
        shared:true
      credits:
        enabled: false
      legend:
        enabled: false
        itemStyle:
          color:'#888'
      series: [{
            type: 'pie',
            name: '所占比例',
            size: '100%',
            innerSize: '20%',
            data: [['债券',44],['混合',20],['指数',10],['股票',15],['货币',10]]
        }]
      exporting:
        buttons:
          contextButton:
            theme:
              'stroke-width': 0
              fill:'#3f3f42'
              stroke:'#3f3f42'
              states:
                hover:
                  fill:'#3f3f42'
                  stroke:'#fff'
                select:
                  fill:'#3f3f42'
                  stroke:"#fff"

  #临时存储，便于重置#
  chartsTemp = charts

  charts: charts
  reset: chartsTemp
