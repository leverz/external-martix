<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>MATRIX - 基金经理</title>
    <link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/newManager.css?ver=$revxxx$">
    <%@ include file="../inc/meta.inc" %>
</head>
<body id="manager-body">
<%@ include file="../inc/header.inc" %>
<div class="managerPage clearfix">
    <%@ include file="../inc/left-menu.inc" %>
    <div id="manager">
        <div class="typeBy">
            <div class="types clearfix">
                <label for="">擅长类型：</label>
                <ul id="type" class="clearfix">
                    <li class="active">全部</li>
                    <li>货币型</li>
                    <li>纯债型</li>
                    <li>二级债型</li>
                    <li>海外债型</li>
                </ul>
            </div>
            <div class="types clearfix">
                <label for="" style="display: block;">基金公司：</label>
                <ul id="findCompany"></ul>
                <ul id="company" data='0' class="clearfix hideAll" style="float:none;">
                </ul>

            </div>
            <div class="types clearfix">
                <label for="">经理学历：</label>
                <ul id="record" class="clearfix">
                    <li class="active">全部</li>
                    <li>本科</li>
                    <li>硕士</li>
                    <li>博士</li>
                    <li>博士后</li>
                </ul>
            </div>
            <div class="types clearfix">
                <label for="">是否海归：</label>
                <ul id="backOr" class="clearfix">
                    <li class="active">全部</li>
                    <li>是</li>
                    <li>否</li>
                </ul>
            </div>
            <div class="types clearfix">
                <label for="">从业时间：</label>
                <ul id="career" class="clearfix">
                    <li class="active">全部</li>
                    <li>1年以上</li>
                    <li>2年以上</li>
                    <li>3年以上</li>
                    <li>5年以上</li>
                    <li>10年以上</li>
                </ul>
            </div>
            <div class="types clearfix">
                <label for="">管理规模：</label>
                <ul id="govern" class="clearfix">
                    <li class="active">全部</li>
                    <li>100-200亿</li>
                    <li>200-500亿</li>
                    <li>500-1000亿</li>
                    <li>1000亿以上</li>
                </ul>
            </div>
        </div>
        <div class="tableWrap">
            <div class="table">
                <table class="origin-table">
                    <thead>
                    <tr class="topLine">
                        <th width="12.21%">基金</th>
                        <th width="35.62%" colspan="4">收益指标</th>
                        <th width="16.96%" colspan="2">风险指标</th>
                        <th width="11.03%">流动性</th>
                        <th width="11.03%">机构青睐</th>
                        <th width="13.15%"></th>
                    </tr>
                    <tr class="botLine headItem">
                        <th>基金经理名称</th>
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
        require(["newManager"],function(newManager){
            newManager.init();
        })
    })
</script>
</body>
</html>
