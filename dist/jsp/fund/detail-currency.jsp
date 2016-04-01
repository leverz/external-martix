<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../inc/meta.inc" %>
    <title>MATRIX 基金详情 - ${fundInfo.name}(${fundInfo.code})</title>
    <link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/fundDetail.css?ver=$revxxx$">
    <script type="text/javascript">
        var fundCode = "${fundInfo.code}";
        var isCurrency = "${isCurrency}";
        var isFavorited = "${isFavorited}";
        var pieChartQuarters = "${pieChartQuarters}";
        var fundName = '${fundInfo.name}';
        var fundManager = '${fundInfo.manager}';
        var renScore = [${fundScore.timingAbility},${fundScore.institutionFavor},${fundScore.flowAbility},${fundScore.timingAbility},${fundScore.riskLevel}];
    </script>
</head>
<body id="fundDetail">
	<%@ include file="../inc/header.inc" %>
	<div class="main">
		<div class="r-data">
			<div class="d-top">
				<div class="t-title">
					<span class="fund-name">${fundInfo.name}</span>
					<span class="fund-code">(${fundInfo.code})</span>
				</div>
				<div class="t-btn-bar clearfix">
					<div class="t-btn invest">持仓盈亏</div>
					<div class="t-btn alarm">添加提醒</div>
					<div class="t-btn watch last">添加自选</div>
				</div>
			</div>
			<div class="d-block d-basic">
				<div class="d-b-title">基础数据
					<span class="update-time">(${fundValue.createDate})</span>
				</div>
				<div class="d-b-wrap">
					<div class="d-box rate">
						<div class="label">万份收益(日涨幅)：</div>
						<div class="data">${fundValue.unit}
							(<span class="font-color red">${fundValue.range}</span>)
						</div>
					</div>
					<div class="d-box 7days">
						<div class="label">七日年化：</div>
						<div class="data">${fundValue.all}%</div>
					</div>
					<div class="d-box mount">
						<div class="label">最新份额：</div>
						<div class="data">${fundInfo.mountNew}</div>
					</div>
					<div class="d-box manager">
						<div class="label">基金经理：</div>
						<div class="data">
						</div>
					</div>
					<div class="d-box company">
						<div class="label">基金公司：</div>
						<div class="data">
							<span>${fundInfo.company}</span>
						</div>
					</div>
					<div class="d-box day-limit">
						<div class="label">日累计申购限额：</div>
						<div class="data">${fundFee.limitDay}</div>
					</div>
					<div class="d-box day-limit">
						<div class="label">单日最大赎回：</div>
						<div class="data">${dailyMaxRedeem}</div>
					</div>
				</div>
			</div>
			<div class="d-block d-gain">
				<div class="d-b-title">收益数据
					<span class="update-time">(${incomeDate})</span>
				</div>
				<div class="d-b-wrap">
					<div class="d-box m-1">
						<div class="label">近1个月：</div>
						<div class="data">
							<span class="font-color">${month1Income}</span>
							<span>(${month1IncomeRank})</span>
						</div>
					</div>
					<div class="d-box m-3">
						<div class="label">近3个月：</div>
						<div class="data">
							<span class="font-color">${month3Income}</span>
							<span>(${month3IncomeRank})</span>
						</div>
					</div>
					<div class="d-box y-1">
						<div class="label">近1年：</div>
						<div class="data">
							<span class="font-color">${year1Income}</span>
							<span>(${year1IncomeRank})</span>
						</div>
					</div>
					<div class="d-box y-2">
						<div class="label">近2年：</div>
						<div class="data">
							<span class="font-color">${year2Income}</span>
							<span>(${year2IncomeRank})</span>
						</div>
					</div>
				</div>
			</div>
			<div class="d-block d-other">
				<div class="d-b-title">其余指标
					<span class="update-time">(${indexDate})</span>
				</div>
				<div class="d-b-wrap">
					<div class="d-box sharp">
						<div class="label">夏普指数：</div>
						<div class="data">
							<span>${sharpe}</span>
							<span>(${sharpeRank})</span>
							<span class="span-text">平均</span>
							<div class="average">
								<i class="ic-aver"></i>
								<span class="">${sharpeTopAvg}</span>
							</div>
						</div>
					</div>
					<div class="d-box wave">
						<div class="label">波动率：</div>
						<div class="data">
							<span>${volitality}</span>
							<span>(${volitalityRank})</span>
							<span class="span-text">平均</span>
							<div class="average">
								<i class="ic-aver"></i>
								<span class="">${volitalityTopAvg}</span>
							</div>
						</div>
					</div>
					<div class="d-box timing">
						<div class="label">择时损益：</div>
						<div class="data">
							<span>${timingProfit}</span>
							<span>(${timingProfitRank})</span>
							<span class="span-text">平均</span>
							<div class="average">
								<i class="ic-aver"></i>
								<span class="">${timingProfitTopAvg}</span>
							</div>
						</div>
					</div>
					<div class="d-box asset">
						<div class="label">资产贡献率：</div>
						<div class="data">
							<span>${allocationContriRatio}</span>
							<span>(${allocationContriRatioRank})</span>
							<span class="span-text">平均</span>
							<div class="average">
								<i class="ic-aver"></i>
								<span class="">${allocationContriRatioTopAvg}</span>
							</div>
						</div>
					</div>
					<div class="d-box scale">
						<div class="label">基金规模：</div>
						<div class="data">
							<span>${fundScale}</span>
							<span>(${fundScaleRank})</span>
							<span class="span-text">平均</span>
							<div class="average">
								<i class="ic-aver"></i>
								<span class="">${fundScaleTopAvg}</span>
							</div>
						</div>
					</div>
					<div class="d-box hold">
						<div class="label">机构持仓：</div>
						<div class="data">
							<span>${instPosRatio}</span>
							<span>(${instPosRatioRank})</span>
							<span class="span-text">平均</span>
							<div class="average">
								<i class="ic-aver"></i>
								<span class="">${instPosRatioTopAvg}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="d-block d-asset-chart">
				<div class="d-b-title">资产配置详情
					<span class="update-time">(2015-Q4)</span>
				</div>
				<div class="charts-asset">
				</div>
			</div>
		</div>
		<div class="l-chart">
			<div class="chart-area">
				<div class="c-bar clearfix">
					<div class="r-select">
						<div class="risk-select" data-code="1" data-id="5">
							指标
							<i class="icon-down"></i>
							<ul class="pullBox detail" style="display:none;z-index:1">
								<li class="label-li">
									<div class="l-tabs">
										<div class="profit-tab active">收益指标</div>
										<div class="other-tab">其他指标</div>
									</div>
								</li>
								<li class="riskLi clearfix" data-code="1">
                            		<p>收益率<i class="checked"></i></p>
                    			</li>
                    			<li class="riskLi clearfix" data-code="2">
                            		<p>夏普指数<i></i></p>
                    			</li>

								<!-- <li class="otherLi clearfix" data-code="5">
                            		<p>波动率<i class="checked"></i></p>
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
                    			</li> -->
							</ul>
						</div>
						<div class="compare-select" data-code="CGB1Y"></div>
						<ul class="time-select"></ul>
					</div>
				</div>
				<div class="charts-name charts-top-name">收益率</div>
				<div class="charts-top m-charts chart-box">
					
				</div>
				<div class="charts-name charts-below-name">波动率</div>
				<div class="charts-below">
					<div class="nodata"></div>
				</div>
				<!-- <div class="c-tab-bar clearfix">
					<div class="tabs active" data-code="5">波动率</div>
					<div class="tabs" data-code="6">最大回撤</div>
					<div class="tabs" data-code="7">择时损益</div>
					<div class="tabs" data-code="8">资产配置贡献</div>
					<div class="tabs" data-code="9">基金规模</div>
					<div class="tabs" data-code="10">机构持仓</div>
				</div> -->
			</div>
			<div class="news-area">
				<div class="news-tab-bar">
					<div class="tabs active">基金公告</div>
				</div>
				<div class="news-range">
					<div class="news">
						<!-- <div class="new-box">
							<div class="new-time">
								<div class="nt-date">28</div>
								<div class="nt-y-m">2015-11</div>
							</div>
							<div class="new-wrap">
								<a href="#" class="new-title">易方达基金管理有限公司关于旗下部分开放式基金参加苏州银行申购及定期定额投资费率优惠活动的公告易方达基金管理有限公司关于旗下部分开放式基金参加苏州银行申购及定期定额投资费率优惠活动的公告</a>
								<a href="#" class="new-source">东方财富网</a>
							</div>
						</div> -->
					</div>
				</div>	
			</div>
		</div>
	</div>
	<script type="text/javascript">
    	$(function(){
        	require(["fundDetail"],function(_detail){
            	_detail.init();
        	})
    	})
    </script>
</body>
</html>