#@2016.03.03
define "contact",(require,exports)->
    #模板#
    tpl =
        #邮箱类名 s-mail
        #联系客服
        contactKefu:"""
            <div class="contactBox">
                <div class="cTitle clearfix">
                    <div class="cTitleText">您的专属客服</div>
                    <i class="cIcon cBoxClose"></i>
                </div>
                <div class="serverArea">
					<div class="serverBox border-b">
						<div class="tag-s s-name">李想</div>
						<div class="tag-s s-title">商务总监</div>
						<div class="tag-s s-contact phoneNum">联系电话：18581807680</div>
						<div class="tag-s s-contact mailAddr">邮箱地址：xiang.li@renren-inc.com</div>
					</div>
					<div class="serverBox">
						<div class="tag-s s-name">高璇</div>
						<div class="tag-s s-title">客户经理</div>
						<div class="tag-s s-contact phoneNum">联系电话：18516998477</div>
						<div class="tag-s s-contact mailAddr">邮箱地址：xuan.gao@renren-inc.com</div>
					</div>
                </div>
            </div>
            <div class="mask"></div>
            """ 

    #事件监听#
    listener =
        body: $("body")
        init:->
            @closeDialog()

        #关闭弹窗#
        closeDialog:->
            @body.on "click",".cBoxClose",->
               $(".contactBox").remove()
               $(".mask").remove()
               $('body').css('overflow-y','auto')

    # 初始化函数
    init = ->
        $("body").append(tpl.contactKefu).css('overflow-y','hidden')
        $(".selectType").parents("li").append tpl.seven
        listener.init()

    init: init
