<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>MATRIX - 自选基金</title>
    <link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/selfFund.css?ver=$revxxx$">
    <%@ include file="../inc/meta.inc" %>
</head>
<body id="fundSelf">
<%@ include file="../inc/header.inc" %>
<div class="managerPage clearfix">
    <%@ include file="../inc/left-menu.inc" %>
    <div id="selfFund">
        <div class="tableWrap">
            <div class="table">
                <table class="origin-table">
                    <thead>
                    <tr class="topLine">
                        <th width="11%">基金</th>
                        <th width="5%"></th>
                        <th width="28%" colspan="4">收益指标</th>
                        <th width="14%" colspan="2">风险指标</th>
                        <th width="14%"  colspan="2">流动性</th>
                        <th width="8%">机构青睐</th>
                        <th width="8%"></th>
                    </tr>
                    <tr class="botLine headItem">
                        <th>基金名称</th>
                        <th>基金类型</th>
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
                        <th class="sortCol" data-sort="17">当日申购限额
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
                    <tbody class="fundList">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        require(["selfFund"],function(selfFund){
            selfFund.init();
        })
    })
</script>
</body>
</html>
