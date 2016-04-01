#@2016.03.03
define "filter",(require,exports)->
    #模板#
    tpl =
        pure:"""
            <div class="baseLine twoInput currency">
                <span>基金净值</span>
                <label for="">超过</label>
                <input name="minUnit" type="text"/>
                <label for="">少于</label>
                <input name="maxUnit" type="text"/>
            </div>
        """
        #货币#
        seven:"""
            <div class="baseLine twoInput currency">
                <span>万份收益</span>
                <label for="">超过</label>
                <input name="minUnit" type="text"/>
                <label for="">少于</label>
                <input name="maxUnit" type="text"/>
            </div>
        """
        dialog:"""
            <div class="selBox">
                 <div class="selBoxTitle clearfix">
                    <div class="shai fundShai active" data-sep="fund">基金筛选</div>
                    <i class="selIcon boxClose"></i>
                </div>
                <ul class="fundCont selContent">
                    <form action="http://matrix.sofund.com/filter/popup/searchFund" target="_blank">
                    <li>
                        <h3>基本信息</h3>
                        <div class="baseLine">
                            <label for="fundCode">基金代码</label>
                            <input id="fundCode" name="fundCode" type="text" placeholder="请输入基金代码"/>
                            <span></span>
                        </div>
                        <div class="baseLine">
                            <label for="fundName">基金名称</label>
                            <input id="fundName" name="fundName" type="text" placeholder="请输入基金名称"/>
                            <span></span>
                        </div>
                        <div class="baseLine">
                            <label for="company">基金公司</label>
                            <input id="company" name="company" type="text" placeholder="请输入基金公司名称"/>
                            <span></span>
                        </div>
                        <div class="baseLine">
                            <label for="">基金类型</label>
                            <select class="selectType" name="fundType">
                                <option value="货币型" selected="true">货币型</option>
                                <option value="纯债">纯债</option>
                            </select>
                        </div>
                        <div class="baseLine twoInput">
                            <span>万份收益</span>
                            <label for="">超过</label>
                            <input name="thousandsOfIncomeLt" type="text"/>
                            <label for="">少于</label>
                            <input name="thousandsOfIncomeQt" type="text"/>
                        </div>
                    </li>
                    <li>
                        <h3>基金经理</h3>
                        <div class="baseLine">
                            <label for="managerName">基金经理</label>
                            <input id="managerName" name="managerName" type="text" placeholder="请输入基金经理名称"/>
                            <span></span>
                        </div>
                        <div class="baseLine twoInput">
                            <span>从业时间</span>
                            <label for="">超过</label>
                            <input name="workStartLt" type="text" placeholder="年"/>
                            <label for="">少于</label>
                            <input name="workStartQt" type="text" placeholder="年"/>
                        </div>
                        <div class="baseLine twoInput">
                            <span>经理学历</span>
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
                                <option value="博士后">博士后</option>
                            </select>
                        </div>
                        <div class="baseLine twoInput">
                            <span>管理规模</span>
                            <select class="s-short quater quaterList" name="managerFundScaleQuarter">
                                <option value="0">2015Q4</option>
                                <option value="1">2015Q3</option>
                                <option value="2">2015Q2</option>
                                <option value="3">2015Q1</option>
                            </select>
                            <label for="">超过</label>
                            <input name="managerFundScaleLt" type="text" placeholder="亿元">
                        </div>
                    </li>
                    <li>
                        <h3>收益相关</h3>
                        <div class="baseLine twoInput">
                            <span>阶段涨幅</span>
                            <select class="s-short rate profit-select" name="rangeQuarter">
                                <option value="1" selected="true">日涨幅</option>
                                <option value="3">月涨幅</option>
                                <option value="6">季涨幅</option>
                                <option value="12">年涨幅</option>
                            </select>
                            <label for="">超过</label>
                            <input name="minDailyIncrease" type="text">
                        </div>
                        <div class="baseLine twoInput">
                            <span>夏普指数</span>
                            <select class="s-short quater" name="sharpeRatioQuarter">
                                <option value="1" selected="true">近一月</option>
                                <option value="3">近三月</option>
                                <option value="6">近半年</option>
                                <option value="12">近一年</option>
                            </select>
                            <label for="">超过</label>
                            <input name="sharpeRatioLt" type="text">
                        </div>
                    </li>
                    <li>
                        <h3>风险相关</h3>
                        <div class="baseLine twoInput">
                            <span>波动率 &nbsp;&nbsp;</span>
                            <select class="s-short quater" name="volitalityQuarter">
                                <option value="0">2015Q4</option>
                                <option value="1">2015Q3</option>
                                <option value="2">2015Q2</option>
                                <option value="3">2015Q1</option>
                            </select>
                            <label for="">少于</label>
                            <input name="volitalityQt" type="text">
                        </div>
                        <div class="baseLine twoInput">
                            <span>最大回撤</span>
                            <select class="s-short quater" name="drawbackQuarter">
                                <option value="0">2015Q4</option>
                                <option value="1">2015Q3</option>
                                <option value="2">2015Q2</option>
                                <option value="3">2015Q1</option>
                            </select>
                            <label for="">少于</label>
                            <input name="drawbackQt" type="text">
                        </div>
                    </li>
                    <li>
                        <h3>其他指标</h3>
                        <div class="baseLine twoInput">
                            <span>基金规模</span>
                            <select class="s-short quater" name="fundScaleQuarter">
                                <option value="0">2015Q4</option>
                                <option value="1">2015Q3</option>
                                <option value="2">2015Q2</option>
                                <option value="3">2015Q1</option>
                            </select>
                            <label for="">超过</label>
                            <input name="fundScaleLt" type="text" placeholder="亿元">
                        </div>
                        <div class="baseLine twoInput">
                            <span>择时损益</span>
                            <select class="s-short quater" name="timingProfitQuarter">
                                <option value="0">2015Q4</option>
                                <option value="1">2015Q3</option>
                                <option value="2">2015Q2</option>
                                <option value="3">2015Q1</option>
                            </select>
                            <label for="">超过</label>
                            <input name="timingProfitLt" type="text">
                        </div>
                        <div class="baseLine twoInput">
                            <span>资产贡献</span>
                            <select class="s-short quater" name="allocationContriRatioQuarter">
                                <option value="0">2015Q4</option>
                                <option value="1">2015Q3</option>
                                <option value="2">2015Q2</option>
                                <option value="3">2015Q1</option>
                            </select>
                            <label for="">超过</label>
                            <input name="pallocationContriRatioLt" type="text">
                        </div>
                    </li>
                    <input type="hidden" name="sortedBy" value="999">
                    <input type="hidden" name="sortedDirection" value="0">
                    <input type="hidden" name="pageSize" value="999">
                    </form>
                </ul>
                <div class="handleBtn clearfix">
                    <a href="javascript:;" class="sub">确定</a>
                    <a href="javascript:;" class="canc">取消</a>
                </div>
            </div>
            <div class="mask"></div>
            """

    #事件监听#
    listener =
        body: $("body")
        init:->
            @closeDialog()
            # @specialSelect()
            @subFilter()
        #关闭弹窗#
        closeDialog:->
            @body.on "click",".canc,.boxClose",->
               $(".selBox").remove()
               $(".mask").remove()
               $('body').css('overflow-y','auto')
        #货币型基金#
        # specialSelect:->
        #     $(".selectType").on "change",->
        #         self = $ this
        #         type = self.val()
        #         self.parent().siblings(".currency").remove()
        #         # if +type is "货币型"
        #         #     self.parents("li").append tpl.seven
        #         # else
        #         #     self.parents("li").append tpl.pure
        # #提交筛选#
        subFilter:->
            @body.on "click",".sub",->
                type = $(".shai.active").attr 'data-sep'
                switch type
                    when 'fund'
                        $(".fundCont").find("form").submit()
                    when 'manager'
                        $(".managerCont").find("form").submit()
                $(".selBox,.mask").remove()
                $('body').css('overflow-y','auto')
                

    # 初始化函数
    init = ->
        $("body").append(tpl.dialog).css('overflow-y','hidden')
        # $(".selectType").parents("li").append tpl.seven
        listener.init()

    init: init
