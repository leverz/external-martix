
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>MATRIX - 基金持仓</title>
	<link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/fundHold.css?ver=$revxxx$">
	<%@ include file="./inc/meta.inc" %>
</head>
<body id="fundHold">
	<%@ include file="./inc/header.inc" %>
	<div class="fundHold clearfix">
		<%@ include file="./inc/left-menu.inc" %>
		<div class="mainCont">
			<div class="table-tab clearfix">
				<div class="tabs">资产总览</div>
				<a href="javascript:;" class="callCost">赎回</a>
				<a href="javascript:;" class="addCost">申购</a>
			</div>
			<div class="boxCharts clearfix">
				<div class="rightBox">
					<div class="tit clearfix">
						<h3>资产配置</h3>
						<div class="line"></div>
					</div>
					<div class="bingWrap clearfix">
						<div class="charts"></div>
						<div class="charts-list">
							<ul class="listName">
							
							</ul>	
						</div>
					</div>
				</div>
				<div class="leftBox">
					<div class="tit clearfix">
						<h3>收益状况</h3>
						<div class="line"></div>
					</div>
					<ul class="cont clearfix">
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
					</ul>
					<div class="chartArea">
						<select class="time-select">
							<option value="1">近两年</option>
						</select>
						<div class="compare-select" data-code="CGB1Y">对比标的
							<i class="icon-down"></i>
							<ul class="pullBox"></ul>
						</div>
						<div class="m-chart">

						</div>
					</div>
				</div>

			</div>
			<div class="table-tab tabNext">
				<div class="tabs">资产明细</div>
			</div>
			<ul class="listBox clearfix">
				<li>
					<div class="liTit">博时天天增利货币a</div>
					<ul class="cont clearfix">
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
						<li>
							<div class="title">总资产价值（元）：</div>
							<div class="amount">0</div>
						</li>
					</ul>
					<div class="handleArea clearfix">
						<a href="javascript:;" class="apply">申购资产</a>
						<a href="javascript:;" class="call">赎回资产</a>
						<a href="javascript:;" class="income">收益走势</a>
					</div>
				</li>

			</ul>
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			require(["fundHold"],function(fundHold){
				fundHold.init();
			})
		})
    </script>
</body>
</html>
