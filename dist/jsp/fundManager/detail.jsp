<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>MATRIX - 基金经理详情</title>   
    <link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/managerDetail.css?ver=$revxxx$">
    <%@ include file="../inc/meta.inc" %>
</head>
<body id="managerDetail">
    <%@ include file="../inc/header.inc" %>
    <div class="topBox clearfix">
        <div class="intro">

        </div>
        <div class="chartsBox">

            <div class="chartTop">
                <div class="r-select">
                    <div class="risk-select" data-code="0" data-id="4">
                        指标
                        <i class="icon-down"></i>
                        <ul class="pullBox detail" style="display:none;z-index:1">
                            <li class="label-li">
                                <div class="l-tabs">
                                    <div class="profit-tab active">收益指标</div>
                                    <div class="other-tab">其他指标</div>
                                </div>
                            </li>
                            <li class="riskLi clearfix" data-code="0">
                                <p>收益率<i class="checked"></i></p>
                            </li>
                            <li class="riskLi clearfix" data-code="10002">
                                <p>夏普指数<i></i></p>
                            </li>
                        </ul>
                        <!-- <ul class="pullBox detail" style="display:none;z-index:1">
                            <li class="label-li">收益指标</li>
                            <li class="riskLi clearfix" data-code="0">
                                <p>收益率<i class="checked"></i></p>
                            </li>
                            <li class="riskLi clearfix" data-code="10002">
                                <p>Sharpe<i></i></p>
                            </li>
                            <li class="label-li has-bt">其他指标</li>
                            <li class="otherLi clearfix" data-code="4">
                                <p>波动率<i class="checked"></i></p>
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
                            </li>
                        </ul> -->
                    </div>
                    <div class="compare-select" data-code="">对比标的</div>
                    <ul class="time-select">
                        <li value='101'>1M</li>
                        <li value='103'>3M</li>
                        <li value='106'>6M</li>
                        <li value='401' class='active'>1Y</li>
                        <li value='402'>2Y</li>
                    </ul>                    
                </div>
                <div class="charts-top-name">收益率</div>
                <div class="chartD"></div>
            </div>
            <div class="charts-below-name">波动率</div>
            <div class="chartQ">
            </div>
        </div>

    </div>
    <div class="botBox">
        <div class="table-tab">
            <div class="tabs">管理的基金</div>
            <i class="tabs-icon up"></i>
        </div>
        <div class="table">
            <table>
                <thead>
                    <tr class="topTr">
                        <th>基金</th>
                        <th>基金类型</th>
                        <th colspan="4">收益指标</th>
                        <th colspan="2">风险指标</th>
                        <th>流动性</th>
                        <th>机构青睐</th>
                        <th></th>
                    </tr>
                    <tr class="botTr">
                        <th>基金名称</th>
                        <th>基金类型</th>
                        <th class="cursor" data-sort="2">一个月
                        </th>
                        <th class="cursor" data-sort="3">三个月
                        </th>
                        <th class="cursor" data-sort="4">近一年
                        </th>
                        <th class="cursor" data-sort="6">夏普指数
                        </th>
                        <th class="cursor" data-sort="8">波动率
                        </th>
                        <th class="cursor" data-sort="9">最大回撤
                        </th>
                        <th class="cursor" data-sort="12">基金规模
                        </th>
                        <th class="cursor" data-sort="13">机构持仓比例
                        </th>
                        <th class="no-ti" data-sort="">自选</th>
                    </tr>
                </thead>
                <tbody id="fundList">
                </tbody>
            </table>
        </div>
    </div>
    <%@ include file="../inc/footer.inc" %>
    <script type="text/javascript">
    $(function(){
        require(["managerDetail"],function(managerDetail){
            managerDetail.init();
        })
    })
    </script>
</body>
</html>