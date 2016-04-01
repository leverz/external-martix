<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
	<title>MATRIX - 基金筛选结果</title>
	<%@ include file="../inc/meta.inc" %>
	<link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/filterDetail.css?ver=$revxxx$">
    <script type="text/javascript">
        resultData = ${result};
    </script>
</head>
<body>
	<%@ include file="../inc/header.inc" %>
	<div id="fund-content">
		<table class="data-table">
			<thead>
				<tr class="topLine">
					<th width="15%">基金</th>
                    <th width="5%"></th>
                    <th width="28%" colspan="4">收益指标</th>
                    <th width="12%" colspan="2">风险指标</th>
                    <th width="8%">流动性</th>
                    <th width="8%">机构青睐</th>
                    <th width="17%" colspan="2">基金评级</th>
                    <th width="7%"></th>
				</tr>
				<tr class="botLine headItem">
					<th>基金名称</th>
                    <th>基金类型</th>
                    <th class="sortCol" data-sort="2">一个月
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="3">三个月
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="4">近一年
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="6">夏普指数
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="8">波动率
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="9">最大回撤
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="12">基金规模
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="13">机构持仓比例
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="14">晨星评级
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="sortCol" data-sort="15">银河评级
                        <div class="updown">
                            <div class="up"></div>
                            <div class="down"></div>
                        </div>
                    </th>
                    <th class="hasRight"></th>
			    </tr>
			</thead>
			<tbody>

			</tbody>
		</table>
	</div>
    <script type="text/javascript">
    $(function(){
        require(["searchFund"],function(searchFund){
            searchFund.init();
        });
    });
    </script>
</body>
</html>
