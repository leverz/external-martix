#数据下载模块
#包含基金自选，基金经理自选，持仓盈亏页
#首页、基金经理首页及三个详情页在相对应的私有模块里面
define "downloadData",(require,exports)->
	FILE = 0 #全局文件类型变量
	TABS = ""#list选中的checkbox所代表的参数
	CODE = 0 #基金代码
	MANAGER = ""#基金经理名称
	TIMES = {}#时间全局变量
	dataArrey = [] #data数组
	#模板
	tpl = 
		#基金自选
		selfFund : """
					<div class="downloadBox">
						<div class="dTitle clearfix">
							<div class="dTitleText">数据下载</div>
							<i class="dIcon dBoxClose"></i>
						</div>
						<div class="listContent">
							<ul>
								<li>
									<div class="father-input">
										<input type="checkbox" id="fundIncome"> <label for="fundIncome">基金收益指标</label>
										<div class="child-wrap">
											<span class="child-input">
											<input type="checkbox" id="fundYe1"> <label for="fundYe1">近1月</label>
											</span>
											<span class="child-input">
												<input type="checkbox" id="fundYe3"> <label for="fundYe3">近3月</label>
											</span>
											<span class="child-input">
												<input type="checkbox" id="fundYe12"> <label for="fundYe12">近1年</label>
											</span>
											<span class="child-input">
												<input type="checkbox" id="fundSharp"> <label for="fundSharp">夏普指数</label>
											</span>
										</div>
									</div>
								</li>
								<li>
									<div class="father-input">
										<input type="checkbox" id="fundRisk"> <label for="fundRisk">风险指标</label>
										<div class="child-wrap">
											<span class="child-input">
												<input type="checkbox" id="fundBo"> <label for="fundBo">波动率</label>
											</span>
											<span class="child-input">
												<input type="checkbox" id="fundBack"> <label for="fundBack">最大回撤</label>
											</span>
										</div>
									</div>
								</li>
								<li>
									<div class="father-input">
										<input type="checkbox" id="fundLiu"> <label for="fundLiu">流动性</label>
										<div class="child-wrap">
											<span class="child-input">
												<input type="checkbox" id="fundSize"> <label for="fundSize">基金规模</label>
											</span>
											<span class="child-input">
                                                <input type="checkbox" id="fundLimi"> <label for="fundLimi">当日申购限额</label>
                                            </span>
										</div>
									</div>
								</li>
								<li>
									<div class="father-input">
										<input type="checkbox" id="fundJigou"> <label for="fundJigou">机构青睐</label>
										<div class="child-wrap">
											<span class="child-input">
												<input type="checkbox" id="fundBili"> <label for="fundBili">机构持仓比例</label>
											</span>
										</div>
									</div>
								</li>
							</ul> 
						</div>
						<div class="dFooter">
							<span class="dDownload dButton">确认下载</span>
							<span class="dCancle dButton">取消</span>
						</div>
					</div>
					<div class="mask"></div>

				   """		
		#基金经理自选
		selfManagerFund : """
						<div class="downloadBox">
							<div class="dTitle clearfix">
								<div class="dTitleText">数据下载</div>
								<i class="dIcon dBoxClose"></i>
							</div>
							<div class="listContent">
								<ul>
									<li>
										<div class="father-input">
											<input type="checkbox" id="fundIncome"> <label for="fundIncome">基金收益指标</label>
											<div class="child-wrap">
												<span class="child-input">
												<input type="checkbox" id="fundYe1"> <label for="fundYe1">近1月</label>
												</span>
												<span class="child-input">
													<input type="checkbox" id="fundYe3"> <label for="fundYe3">近3月</label>
												</span>
												<span class="child-input">
													<input type="checkbox" id="fundYe12"> <label for="fundYe12">近1年</label>
												</span>
												<span class="child-input">
													<input type="checkbox" id="fundSharp"> <label for="fundSharp">夏普指数</label>
												</span>
											</div>
										</div>
									</li>
									<li>
										<div class="father-input">
											<input type="checkbox" id="fundRisk"> <label for="fundRisk">风险指标</label>
											<div class="child-wrap">
												<span class="child-input">
													<input type="checkbox" id="fundBo"> <label for="fundBo">波动率</label>
												</span>
												<span class="child-input">
													<input type="checkbox" id="fundBack"> <label for="fundBack">最大回撤</label>
												</span>
											</div>
										</div>
									</li>
									<li>
										<div class="father-input">
											<input type="checkbox" id="fundLiu"> <label for="fundLiu">流动性</label>
											<div class="child-wrap">
												<span class="child-input">
													<input type="checkbox" id="fundSize"> <label for="fundSize">基金规模</label>
												</span>
											</div>
										</div>
									</li>
									<li>
										<div class="father-input">
											<input type="checkbox" id="fundJigou"> <label for="fundJigou">机构青睐</label>
											<div class="child-wrap">
												<span class="child-input">
													<input type="checkbox" id="fundBili"> <label for="fundBili">机构持仓比例</label>
												</span>
											</div>
										</div>
									</li>
								</ul> 
							</div>
							<div class="dFooter">
								<span class="dDownload dButton">确认下载</span>
								<span class="dCancle dButton">取消</span>
							</div>
						</div>
						<div class="mask"></div>				
						"""
		#持仓盈亏
		hold : """
				<div class="downloadBox">
					<div class="dTitle clearfix">
						<div class="dTitleText">数据下载</div>
						<i class="dIcon dBoxClose"></i>
					</div>
					<div class="listContent">
						<ul>
							<li>
								<div class="father-input">
									<input type="checkbox" id="fundInfo"> <label for="fundInfo">基金基本信息</label>
									<div class="child-wrap">
										<span class="child-input">
											<input type="checkbox" id="fundAll"> <label for="fundAll">总览</label>
										</span>
									</div>
								</div>
							</li>
							<li>
								<div class="father-input">
									<input type="checkbox" id="fundIncome"> <label for="fundIncome">资产明细</label>
									<div class="child-wrap">
										<span class="child-input">
										<input type="checkbox" id="fundYe1"> <label for="fundYe1">持有份额</label>
										</span>
										<span class="child-input">
											<input type="checkbox" id="fundYe3"> <label for="fundYe3">累计未结转</label>
										</span>
										<span class="child-input">
											<input type="checkbox" id="fundYe12"> <label for="fundYe12">昨日收益</label>
										</span>
										<span class="child-input">
											<input type="checkbox" id="fundSharp"> <label for="fundSharp">浮动收益</label>
										</span>
										<span class="child-input">
											<input type="checkbox" id="fundCome"> <label for="fundCome">收益率</label>
										</span>
									</div>
								</div>
							</li>
						</ul> 
					</div>
					<div class="dFooter">
						<span class="dDownload dButton">确认下载</span>
						<span class="dCancle dButton">取消</span>
					</div>
				</div>
				<div class="mask"></div>
			   """

	#操作函数
	action = 
		closeDialog :->
			$(".downloadBox").remove()
			$(".mask").remove()
		cancle :->
			$(".downloadBox").remove()
			$(".mask").remove()

		selected :(self) ->
			if self.prop("checked") is true
				self.siblings().find("input").prop("checked",true)
			else
				self.siblings().find("input").prop("checked",false)

		downloadData :(id)->
			data = 
				file : FILE
				tabs : TABS
			window.open "http://matrix.sofund.com/download/excelnew?"+$.param(data)
			$(".downloadBox").remove()
			$(".mask").remove()

		#根据页面的body id区别不同的页面
		differentiate:(id)->
			switch id
				when "managerSelf"
					FILE = 4
					$("body").append(tpl.selfManagerFund).css('overflow-y','hidden')
				when "fundSelf"
					FILE = 5
					$("body").append(tpl.selfFund).css('overflow-y','hidden')
				when "fundHold"
					FILE = 6
					$("body").append(tpl.hold).css('overflow-y','hidden')
					
			$(".father-input input:first-child").change ->
				_self = $(this)
				action.selected(_self)

	#时间监听
	listener = 

		init:->
			@close()

			@cancle()

			@download()

		close :->
			$("body").on "click",".dBoxClose",->

				action.closeDialog()
				$('body').css('overflow-y','auto')

		cancle :->
			$("body").on "click",".dCancle",->

				action.cancle()

		download :->
			$("body").off("click",".dDownload").on "click",".dDownload",->
				fatherInput = $(".father-input")
				#构建tabs参数
				for i in [0...fatherInput.length]
					strings = i+":"
					childInput = fatherInput.eq(i).find(".child-input input:checked")
					if childInput.length !=0
						for j in [0...childInput.length]
							indexs = fatherInput.eq(i).find(".child-input input").index childInput.eq(j)
							nums = indexs+1
							if j == childInput.length - 1
								strings += nums
							else
								strings += nums+","

						if i == fatherInput-1
							TABS += (strings)
						else
							TABS += (strings+";")

				action.downloadData($("body").attr("id"))

	init = ->
		action.differentiate($("body").attr("id"))
		listener.init()

	init:init



		


		




























