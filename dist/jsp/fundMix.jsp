<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>MATRIX - 首页</title>
	<%@ include file="inc/meta.inc" %>
	<meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
	<link type="text/css" rel="stylesheet"  href="http://s.xnimg.cn/external/matrix/css/index.css?ver=$revxxx$">
</head>
<body id="m-index">
	<%@ include file="inc/header.inc" %>
	<%@ include file="inc/left-menu.inc" %>
	<div class="main">
		<div class="left-filter">
			<form>
			<div class="f-box">
				<div class="f-title">基本信息</div>
				<div class="label-input">
					<label>基金代码</label>
					<input name="fundCode" type="text" maxlength="10" placeholder="请输入基金代码" class="i-fund-code">
				</div>
				<div class="label-input">
					<label>基金名称</label>
					<input name="fundName" type="text" placeholder="请输入基金名称" class="i-fund-name">
				</div>
				<div class="label-input">
					<label>基金公司</label>
					<input name="company" type="text" placeholder="请输入基金公司名称" class="i-fund-corp-code">
				</div>
				<div class="label-input select">
					<label>基金类型</label>
					<select name="fundType" class="fund-type">
						<option value="货币型" selected="true">货币型</option>
						<option value="纯债">纯债</option>
						<!-- <option value="二级债">二级债</option>
						<option value="海外债">海外债</option> -->
					</select>
				</div>
				<div class="label-input double-input">
					<label>万份收益</label>
					<div class="d-i">
						<span>超过</span>
						<input name="thousandsOfIncomeLt" type="text" class="input-short">
						<span>少于</span>
						<input name="thousandsOfIncomeQt" type="text" class="input-short">
					</div>
				</div>
			</div>
			<div class="f-box">
				<div class="f-title">基金经理</div>
				<div class="label-input">
					<label>基金经理</label>
					<input name="managerName" type="text" placeholder="请输入基金经理姓名" class="i-fund-manager">
				</div>
				<div class="label-input double-input">
					<label>从业时间</label>
					<div class="d-i">
						<span>超过</span>
						<input name="workStartLt" type="text" class="input-short" placeholder="年">
						<span>少于</span>
						<input name="workStartQt" type="text" class="input-short" placeholder="年">
					</div>
				</div>
				<div class="label-input select">
					<label>经理学历</label>
					<div class="l-s">
						<select class="s-short oversea" name="degreeCountries">
							<option value="">请选择</option>
							<option value="2">非海归</option>
							<option value="1">海归</option>
						</select>
						<select class="s-short education" name="degreeSchooling">
							<option value="">请选择</option>
							<option value="本科">本科</option>
							<option value="硕士">硕士</option>
							<option value="博士">博士</option>
						</select>
					</div>
				</div>
				<div class="label-input select">
					<label>管理规模</label>
					<div class="l-s">
						<select class="s-short quater quaterList" name="managerFundScaleQuarter">
							<c:forEach var="item" items="${selectQuarterList}" varStatus="status">
								<c:if test="${!status.last}"><option value="${item}">${item}</option></c:if>
								<c:if test="${status.last}"><option value="${item}" selected="true">${item}</option></c:if>
							</c:forEach>
						</select>
						<span>超过</span>
						<input name="managerFundScaleLt" type="text" class="input-short" placeholder="亿元">
					</div>
				</div>
			</div>
			<div class="f-box">
				<div class="f-title">收益相关</div>
				<div class="label-input select">
					<label>阶段涨幅</label>
					<div class="l-s">
						<select class="s-short rate profit-select" name="rangeQuarter">
							<option value="1" selected="true">日涨幅</option>
							<option value="3">月涨幅</option>
							<option value="6">季涨幅</option>
							<option value="12">年涨幅</option>
						</select>
						<span>超过</span>
						<input name="minDailyIncrease" type="text" class="input-short">
					</div>
				</div>
				<div class="label-input select">
					<label>夏普指数</label>
					<div class="l-s">
						<select class="s-short quater" name="sharpeRatioQuarter">
							<option value="1" selected="true">近一月</option>
							<option value="3">近三月</option>
							<option value="6">近半年</option>
							<option value="12">近一年</option>
                        </select>
						<span>超过</span>
						<input name="sharpeRatioLt" type="text" class="input-short">
					</div>
				</div>
			</div>
			<div class="f-box">
				<div class="f-title">风险相关</div>
				<div class="label-input select">
					<label>波动率</label>
					<div class="l-s">
						<select class="s-short quater" name="volitalityQuarter">
							<c:forEach var="item" items="${selectQuarterList}" varStatus="status">
								<c:if test="${!status.last}"><option value="${item}">${item}</option></c:if>
								<c:if test="${status.last}"><option value="${item}" selected="true">${item}</option></c:if>
							</c:forEach>
						</select>
						<span>少于</span>
						<input name="volitalityQt" type="text" class="input-short">
					</div>
				</div>
				<div class="label-input select">
					<label>最大回撤</label>
					<div class="l-s">
						<select class="s-short quater" name="drawbackQuarter">
							<c:forEach var="item" items="${selectQuarterList}" varStatus="status">
								<c:if test="${!status.last}"><option value="${item}">${item}</option></c:if>
								<c:if test="${status.last}"><option value="${item}" selected="true">${item}</option></c:if>
							</c:forEach>
                        </select>
						<span>少于</span>
						<input name="drawbackQt" type="text" class="input-short">
					</div>
				</div>
			</div>
			<div class="f-box">
				<div class="f-title">其他指标</div>
				<div class="label-input select">
					<label>基金规模</label>
					<div class="l-s">
						<select class="s-short quater" name="fundScaleQuarter">
							<c:forEach var="item" items="${selectQuarterList}" varStatus="status">
								<c:if test="${!status.last}"><option value="${item}">${item}</option></c:if>
								<c:if test="${status.last}"><option value="${item}" selected="true">${item}</option></c:if>
							</c:forEach>
                        </select>
						<span>超过</span>
						<input name="fundScaleLt" type="text" class="input-short" placeholder="亿元">
					</div>
				</div>
				<div class="label-input select">
					<label>择时损益</label>
					<div class="l-s">
						<select class="s-short quater" name="timingProfitQuarter">
							<c:forEach var="item" items="${selectQuarterList}" varStatus="status">
								<c:if test="${!status.last}"><option value="${item}">${item}</option></c:if>
								<c:if test="${status.last}"><option value="${item}" selected="true">${item}</option></c:if>
							</c:forEach>
                        </select>
						<span>超过</span>
						<input name="timingProfitLt" type="text" class="input-short">
					</div>
				</div>
				<div class="label-input select">
					<label>资产贡献</label>
					<div class="l-s">
						<select class="s-short quater" name="allocationContriRatioQuarter">
							<c:forEach var="item" items="${selectQuarterList}" varStatus="status">
								<c:if test="${!status.last}"><option value="${item}">${item}</option></c:if>
								<c:if test="${status.last}"><option value="${item}" selected="true">${item}</option></c:if>
							</c:forEach>
                        </select>
						<span>超过</span>
						<input name="pallocationContriRatioLt" type="text" class="input-short">
					</div>
				</div>
			</div>
			<div class="submit-filter red-button">确定</div>
			</form>
		</div>
		<div class="right">
			<div class="data-table">
				<table class="origin-table">
					<thead>
						<tr>
							<th colspan="2">基金</th>
							<th colspan="4">收益指标</th>
							<th colspan="2">风险指标</th>
							<th colspan="2">流动性</th>
							<th>机构青睐</th>
							<th></th>
						</tr>
						<tr class="headItem">
							<th>基金名称</th>
							<th class="cursor" data-sort="18">基金代码<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="2">一个月<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="3">三个月<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="4">近一年<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="6">夏普指数<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="8">波动率<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="9">最大回撤<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="12">基金规模<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="17">当日申购限额<i class="sort-icon"></i></th>
							<th class="cursor" data-sort="13">机构持仓比例<i class="sort-icon"></i></th>
							<th class="no-ti" data-sort=""></th>
						</tr>
					</thead>
					<tbody id="fundList">
					</tbody>
				</table>
			</div>
			<div class="chart-box">
				<div class="chart-tab">
					<div class="tabs">七日年化走势</div>
					<i class="tabs-icon down"></i>
				</div>
				<div class="chart-wrap">
					<div class="r-select">
						<ul class="time-select"></ul>
						<div class="compare-select" data-code="CGB1Y"></div>
						<div class="risk-select" data-code="1">
							指标
							<i class="icon-down"></i>
							<ul class="pullBox" style="display:none;z-index:1">
								<li class="riskLi clearfix" data-code="1">
                            		<p>收益率<i class="checked"></i></p>
                    			</li>
                    			<li class="riskLi clearfix" data-code="2">
                            		<p>夏普指数<i></i></p>
                    			</li>
							</ul>
						</div>
					</div>
					<div class="m-charts"></div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(function(){
	require(["index"],function(index){
		index.init();
	});
});
</script>
</html>
