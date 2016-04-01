<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>MATRIX - 基金对比</title>
	<%@ include file="../inc/meta.inc" %>
    <link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/fundCompare.css?ver=$revxxx$">
</head>
<body>
	<%@ include file="../inc/header.inc" %>
    <%@ include file="../inc/left-menu.inc" %>
    <div id="compare-main">
        <!--基本信息对比-->
        <div class="table-tab tabNext">
            <div class="tabs">基本信息</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="basicInfo">
            <thead>
				<tr><th class="fundName"></th></tr>
            </thead>
            <tbody>
					<tr><td>万份收益</td></tr>
	                <tr><td>七日年化</td></tr>
	                <tr><td>日累计申购限额</td></tr>
	                <tr><td>单日最大赎回</td></tr>
	                <tr><td>基金经理</td></tr>
            </tbody>
        </table>
        <!--基本信息对比 结束-->

        <!--收益数据对比 开始-->
        <div class="table-tab tabNext">
            <div class="tabs">收益数据</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="income">
            <thead>
                <tr><th class="fundName stand" colspan="2"></th></tr>
            </thead>
            <tbody>
				<tr>
                    <td rowspan="2"  class="stand">
                        近一个月
                    </td>
                        
                    <td class="stand"> 
                        收益率
                    </td> 
                               
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> --> 
                    <td class="stand">
                        夏普指数
                    </td>          
                </tr>
                <tr>
                    <td rowspan="2" class="stand">
                        近三个月
                    </td>
                    <td class="stand">
                        收益率
                    </td>            
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> -->  
                    <td class="stand">
                        夏普指数
                    </td>             
                </tr>
                <tr>
                   <td rowspan="2" class="stand">
                        近六个月
                    </td>
                    <td class="stand">
                        收益率
                    </td>            
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> -->  
                    <td class="stand">
                        夏普指数
                    </td>              
                </tr>
                <tr>
                    <td rowspan="2" class="stand">
                        近一年
                    </td>
                    <td class="stand">
                        收益率
                    </td>             
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> -->  
                    <td class="stand">
                        夏普指数
                    </td>            
                </tr>
            </tbody>
        </table>
        <div class="chartsBox clearfix">
            <div class="minChart" id="incomeTrend" data-type="1">
                <div class="chartNav">
                    <span>收益走势</span>
                    <select class="selectTime" id="chooseTimeSel" data-type="1">
                    </select>
                </div>
                <div class="chart"></div>
            </div>
            <div class="minChart" id="leinuo" data-type="3">
                <div class="chartNav">
                    <span>夏普指数</span>
                    <select class="selectTime" id="chooseTimeSel" data-type="3">
                    </select>
                </div>
                <div class="chart"></div>
            </div>
        </div>
        <!--收益水平对比 结束-->

        <!--风险指标对比 开始-->
        <div class="table-tab tabNext">
            <div class="tabs">风险指标</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="risk">
            <thead>
                <tr><th class="fundName stand" colspan="2"></th></tr>
            </thead>
            <tbody>
                <tr>
                    <td rowspan="2" class="stand">
                        2015Q4
                    </td>
                       
                    <td class="stand"> 
                        波动率
                    </td> 
                               
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> --> 
                    <td class="stand">
                        最大回撤
                    </td>          
                </tr>
                <tr>
                    <td rowspan="2" class="stand">
                        2015Q3
                    </td>
                    <td class="stand">
                        波动率
                    </td>            
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> -->  
                    <td class="stand">
                        最大回撤
                    </td>             
                </tr>
                <tr>
                   <td rowspan="2" class="stand">
                        2015Q2
                    </td>
                    <td class="stand">
                        波动率
                    </td>            
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> -->  
                    <td class="stand">
                        最大回撤
                    </td>              
                </tr>
                <tr>
                    <td rowspan="2" class="stand">
                        2015Q1
                    </td>
                    <td class="stand">
                        波动率
                    </td>             
                </tr>
                <tr>
                    <!-- <td class="stand">
                    </td> -->  
                    <td class="stand">
                        最大回撤
                    </td>            
                </tr>
            </tbody>
        </table>
        <div class="chartsBox clearfix" id="wave">
            <div class="bigChart clearfix"  data-type="5">
                <div class="chartNav">
                    <span>波动率</span>
                    <select class="selectTime" id="chooseTimeSel" data-type="5">
                    </select>
                </div>
                <div class="chart"></div>
            </div>
        </div>
        <!--风险指标对比 结束-->

        <!--基金规模对比 开始-->
        <div class="table-tab tabNext">
            <div class="tabs">基金规模</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="fundSize">
            <thead>
                <tr><th class="stand"></th></tr>
            </thead>
            <tbody>
                <tr>
                    <td class="stand">
                        2015Q4
                    </td>
                               
                </tr>
                <tr>
                    <td class="stand">
                        2015Q3
                    </td>         
                </tr>
                <tr>
                   <td class="stand">
                        2015Q2
                    </td>         
                </tr>
                <tr>
                    <td class="stand">
                        2015Q1
                    </td>      
                </tr>
            </tbody>
        </table>
        <div class="bigChart clearfix" id="scope">
            <div class="chartNav">
                <span>基金规模</span>
                <select class="selectTime" id="chooseTimeSel" data-type="9">
                </select>
            </div>
            <div class="chart"></div>
        </div>
        <!--对比 结束-->

        <!--机构持仓占比 开始-->
       <div class="table-tab tabNext">
            <div class="tabs">机构持仓占比</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="holdScale">
            <thead>
                <tr><th class="stand"></th></tr>
            </thead>
            <tbody>
                <tr>
                    <td class="stand">
                        2015Q4
                    </td>
                               
                </tr>
                <tr>
                    <td class="stand">
                        2015Q3
                    </td>         
                </tr>
                <tr>
                   <td class="stand">
                        2015Q2
                    </td>         
                </tr>
                <tr>
                    <td class="stand">
                        2015Q1
                    </td>      
                </tr>
            </tbody>
        </table>
        <div class="bigChart clearfix" id="scale">
            <div class="chartNav">
                <span>机构持仓占比</span>
                <select class="selectTime" id="chooseTimeSel" data-type="10">
                </select>
                <%-- <select name="" class="fixMark">
                    <option value="">修改对比标的</option>
                    <option value="">修改对比标阿斯顿发的</option>
                </select> --%>
            </div>
            <div class="chart"></div>
        </div>
        <!--机构持仓占比 结束-->

        <!--资产配置贡献 开始-->
        <div class="table-tab tabNext">
            <div class="tabs">资产配置贡献</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="contribute">
            <thead>
                <tr><th class="stand"></th></tr>
            </thead>
            <tbody>
                <tr>
                    <td class="stand">
                        2015Q4
                    </td>
                               
                </tr>
                <tr>
                    <td class="stand">
                        2015Q3
                    </td>         
                </tr>
                <tr>
                   <td class="stand">
                        2015Q2
                    </td>         
                </tr>
                <tr>
                    <td class="stand">
                        2015Q1
                    </td>      
                </tr>
            </tbody>
        </table>
        <div class="bigChart clearfix" id="contribution">
            <div class="chartNav">
                <span>资产配置贡献</span>
                <select class="selectTime" id="chooseTimeSel" data-type="8">
                </select>
            </div>
            <div class="chart"></div>
        </div>
        <!--资产配置贡献 结束-->

        <!--择时能力 开始-->
       <div class="table-tab tabNext">
            <div class="tabs">择时能力</div>
            <span class="table-tigs">红色表示某只基金在该指标下表现最优，绿色则表示某只基金在该指标下表现最差。</span>
        </div>
        <table class="compCell" id="ability">
            <thead>
                <tr><th class="stand"></th></tr>
            </thead>
            <tbody>
                <tr>
                    <td class="stand">
                        2015Q4
                    </td>
                               
                </tr>
                <tr>
                    <td class="stand">
                        2015Q3
                    </td>         
                </tr>
                <tr>
                   <td class="stand">
                        2015Q2
                    </td>         
                </tr>
                <tr>
                    <td class="stand">
                        2015Q1
                    </td>      
                </tr>
            </tbody>
        </table>
        <div class="bigChart clearfix" id="timeAbility">
            <div class="chartNav">
                <span>择时能力</span>
                <select class="selectTime" id="chooseTimeSel" data-type="7">
                </select>
            </div>
            <div class="chart"></div>
        </div>
        <!--择时能力 结束-->
    </div>

</body>
<script>
    var fundBaseInfoList = '${fundBaseInfoList}';
    $(function(){
        require(["fundCompare"],function(fundCompare){
            fundCompare.init();
        })
    });
</script>
</html>
