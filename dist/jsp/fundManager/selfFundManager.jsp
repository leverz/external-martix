<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>MATRIX - 自选基金经理</title>
    <link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/selfFundManager.css?ver=$revxxx$">
    <%@ include file="../inc/meta.inc" %>
</head>
<body id="managerSelf">
<%@ include file="../inc/header.inc" %>
<div class="managerPage clearfix">
    <%@ include file="../inc/left-menu.inc" %>
    <div id="manager">
        <div class="tableWrap">
            <div class="table">
                <table class="origin-table">
                    <thead>
                    <tr class="topLine">
                        <th width="11%">基金经理</th>
                        <th width="10%"></th>
                        <th width="34%" colspan="4">收益指标</th>
                        <th width="16%" colspan="2">风险指标</th>
                        <th width="10%">流动性</th>
                        <th width="10%">机构青睐</th>
                        <th width="9%"></th>
                    </tr>
                    <tr class="botLine headItem">
                        <th>基金经理名称</th>
                        <th><select class="fundType">
                        	<option value="货币型" select="true">货币型</option>
                        	<option value="债券型" select="true">债券型</option>
                        	<option value="混合型" select="true">混合型</option>
                        	<option value="股票型" select="true">股票型</option>
                        </select></th>
                        <th class="sortCol active" data-sort="2">一个月
                            <div class="updown">
                                <div class="up"></div>
                                <div class="down active"></div>
                            </div>
                        </th>
                        <th class="sortCol" data-sort="3">三个月
                            <div class="updown">
                                <div class="up"></div>
                                <div class="down"></div>
                            </div>
                        </th>
                        <th class="sortCol" data-sort="4">一年
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
                        <th class="hasRight"></th>
                    </tr>
                    </thead>
                    <tbody class="managerList">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        require(["selfFundManager"],function(selfFundManager){
            selfFundManager.init();
        })
    })
</script>
</body>
</html>
