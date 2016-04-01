#@2016.03.03
# 基于jquery的公用方法
# @js tool

do () ->
  $.fn.extend
    # 弹窗控件
    # @function dialogBox
    # @param {obj} _option 需要定义的参数对象
    # @return {el} 链式返回
    dialogBox : (_option) ->
      $containment = this
      option = $.extend
        width : 545 # 弹窗宽度
        height : 260 # 弹窗高度
        titleIcon : false # 默认没有icon
        titleShow : true # 标题栏是否显示
        contentShow:true # 内容区块是否显示
        title : '' # 弹窗title文案,
        cancelBtn : true # 默认没有取消按钮
        cBtnText : '取消'
        sBtnText : '确定'
        noBtn : false
        callback : $.noop
        cancelCallback : $.noop # 取消按钮的回调
        subCallback : $.noop # 提交按钮的回调
        maskColor : null
        close : () ->
          $dialogBox.remove()
          $mask.remove()
          $('body').css 'overflow-y', 'auto'
      , _option or {}
      $dialogBox = $ "<div class='dialogBox'>
          <div class='close icon'></div>
          <div class='dTitle #{if option.titleShow then '' else 'hidden'}'>
            #{option.title}
          </div>
          <div class='dContent #{if option.contentShow then '' else 'hide'}'></div>
          <div class='dFooter clearfix #{if option.noBtn then 'hide' else ''}' >
            <div class='uiButton subBtn orange'>
              #{option.sBtnText}
            </div>
            <div class='uiButton cancelBtn gray'>
              #{option.cBtnText}
            </div>
          </div>
        </div>"
      $mask = $ "<div class='mask' #{if (option.maskColor isnt null) then style='background:#{option.maskColor}' else ''}></div>"
      $dialogBox.find('.dContent').append $containment
      $dialogBox.css
        width : option.width
        height : option.height
      .find('.cancelBtn').on 'click', (e) -> # 点击取消
        e.stopPropagation()
        option.cancelCallback.call this, $dialogBox, option
        option.close()
      .end().find('.subBtn').on 'click', (e) -> # 点击确定
        e.stopPropagation()
        option.subCallback.call this, $dialogBox, option
        option.close()
      .end().find('.close').on 'mousedown', () -> # 点击关闭
        option.close()

      $mask.on 'click', (e) -> # 点击蒙层，弹框消失
        e.stopPropagation()
        option.close()

      $dialogBox.placeholder()

      ($ 'body').append($dialogBox).append($mask).css('overflow-y', 'hidden')

      option.callback.call this,$dialogBox
      $containment

    # 修复ie placeholder 不显示 bug
    placeholder : () ->
      $self = $ this
      if ('placeholder' of document.createElement('input')) then return
      setTimeout ()->
        $self.find(':input[placeholder]').each (index, element) ->
          $this = $ this
          if $this.parents(".placehold").length is 0
            $this.wrap $('<div class="placehold"></div>').css
              position: 'relative'
              zoom: '1'
              border: 'none'
              background: 'none'
              padding: 'none'
              margin: 'none'
              float: $this.css 'float'
              display: $this.css 'display'
            pos = $this.position()
            h = $this.outerHeight true
            holder = $('<span></span>').text($this.attr 'placeholder')
            .css
                position : 'absolute'
                left : 0
                top : 0
                height : $this.height()
                width : $this.width()
                lineHeight : $this.height()+'px'
                paddingLeft : $this.css 'padding-left'
                textIndent : $this.css 'text-indent'
                paddingTop : $this.css 'padding-top'
                marginLeft : $this.css 'margin-left'
                fontSize : $this.css 'fontSize'
                color : '#aaa'
            .appendTo $this.parent()
            # 避免已存在的值跟placeholder重影
            holder.hide() if ($ this).val()

            $this.on 'change', ->
              holder.hide() if ($ this).val()

            $this.focusin (e) ->
              holder.hide()
            .focusout (e)->
              holder.show() if !$this.val()

            holder.click ->
              holder.hide()
              $this.focus()
      ,0
      $self

    # 下拉列表
    # @function pullBox
    # @param {data} 需要定义的参数对象
    # @return {obj} 链式返回
    # pullBox: (_option)->
    #     html = ""
    #     obj  = $(this)
    #     option =
    #         data:[]
    #         callback:$.noop
    #         position:''
    #         codeList:[]
    #     $.extend(option,_option || {})

    #     codeList = option.codeList
    #     for i in [0...option.data.length]
    #         checked = if codeList.indexOf(option.data[i].code) isnt -1 then 'class="checked"' else ""
    #         html += """<li class="compareLi clearfix" data-code="#{option.data[i].code}">
    #                         <p>#{option.data[i].name}</span>
    #                         <span #{checked}></span>
    #                 </li>"""
    #     obj.html("对比标的<i class='icon-down'></i><ul class='pullBox #{option.position}' style='display:none;z-index:1'>" + html + "<ul>")
    #     #展示pullBox 复选框选中取消
    #     obj.off("click").on "click",(e)->
    #         e.stopPropagation()
    #         pullBox = obj.find(".pullBox")
    #         if pullBox.css("display") is "none"
    #             pullBox.show()
    #         else
    #             pullBox.hide()
    #     .on "click","li",()->
    #         self = $(this)
    #         code = self.data "code"
    #         checkbox = self.find("span")
    #         if checkbox.hasClass("checked")
    #             checkbox.removeClass("checked")
    #             index = codeList.indexOf(code)
    #             codeList.splice index,1
    #         else
    #             checkbox.addClass("checked")
    #             codeList.push code
    #         obj.attr "data-code",codeList.join(",")
    #         option.callback codeList.join(",")
    #     #关闭pullBox
    #     $("body,html").on "click",(e)->
    #         target = $(e.target)
    #         if (target.attr("class") isnt "pullBox") and (target.attr("class") isnt "compare-select")
    #             $(".pullBox").hide()
    #     obj

    # 下拉列表
    # @function pullBox
    # @param {data} 需要定义的参数对象
    # @return {obj} 链式返回
    pullBox: (_option)->
        html = ""
        obj  = $(this)
        option =
          data:[]
          callback:$.noop
          position:''
          codeList:[]
          liTpl:""
          headTpl:""
          footTpl:""
        $.extend(option,_option || {})

        if option.data.length > 0
          codeList = option.codeList

          for i in [0...option.data.length]
            checked = if codeList.indexOf(option.data[i].code) isnt -1 then 'class="checked"' else ""

            #替换模版
            option.liTplTmp = option.liTpl.replace("rCode",option.data[i].code).replace("rName",option.data[i].name).replace("rChecked",checked)
            option.headTplTmp = option.headTpl.replace("rPosition",option.position)

            html += option.liTplTmp

          obj.html(option.headTplTmp + html + option.footTpl)
        #展示pullBox 复选框选中取消
        obj.off("click").on "click",(e)->
          e.stopPropagation()
          pullBox = obj.find(".pullBox")
          if pullBox.css("display") is "none"
              pullBox.show()
          else
              pullBox.hide()
        .on "click","li",(e)->
          self = $(this)
          code = self.data "code"
          checkbox = self.find("span")
          checkI = self.find("i")
          if !self.hasClass("label-li") && (self.hasClass("riskLi")||self.hasClass("compareLi"))
            if self.parent().parent().hasClass "compare-select"
              if checkbox.hasClass("checked")
                checkbox.removeClass("checked")
                index = codeList.indexOf(code)
                codeList.splice index,1
              else
                checkbox.addClass("checked")
                codeList.push code
              obj.attr "data-code",codeList.join(",")
              checkIndex = $('.risk-select').attr('data-code')
              otherIndex = $('.risk-select').attr('data-id')
              option.callback [codeList.join(","),checkIndex,otherIndex]

            else if self.parent().parent().hasClass "risk-select"
              if !checkI.hasClass("checked")
                self.siblings('.riskLi').find('i').removeClass("checked")
                checkI.addClass("checked")
                chartTopName = $(this).find('p').text()
                $('.charts-top-name').text(chartTopName)

              checkIndex = self.attr('data-code')
              $('.risk-select').attr "data-code",checkIndex
              otherIndex = $('.risk-select').data('id')
              compareIndex = $('.compare-select').attr('data-code')
              option.callback [compareIndex,checkIndex,otherIndex,0]

          else if !self.hasClass("label-li") && self.hasClass("otherLi")
            if !checkI.hasClass("checked")
              self.siblings('.otherLi').find('i').removeClass("checked")
              checkI.addClass("checked")
              chartBelowName = $(this).find('p').text()
              $('.charts-below-name').text(chartBelowName)
            
            checkIndex = $('.risk-select').data('code')
            otherIndex = self.attr('data-code')
            $('.risk-select').attr "data-id",otherIndex
            compareIndex = $('.compare-select').attr('data-code')
            option.callback [compareIndex,checkIndex,otherIndex,1]
          else
            e.stopPropagation()
        #关闭pullBox
        $("body,html").on "click",(e)->
            target = $(e.target)
            if (target.attr("class") isnt "pullBox") and (target.attr("class") isnt "compare-select")
                $(".pullBox").hide()
        obj

    # 表头吸顶
    # @function headFix
    # @param {data} 需要定义的参数对象
    # headFix: ()->
    #     self = $(this)
    #     lock = true
    #     $(".headFix").remove()
    #     #根据scoll高度是否吸顶表头#
    #     self.off("scroll").on "scroll",->
    #         scrollTop = self.scrollTop()
    #         if (scrollTop > 42) and ($(".headFix").length is 0) and lock
    #             head = self.find("thead").prop("outerHTML")
    #             table = """<table class="headFix">#{head}<tbody></tbody></table>"""
    #             self.append(table).find("thead").eq(1).removeClass(".headItem").find("tr").eq(0).hide()
    #             $.each $(".headItem th"),(i)->
    #                 $(".headFix").find("thead tr").eq(1).find("th").eq(i).width $(this).width()
    #             lock = false
    #         else if scrollTop < 42
    #             $(".headFix").remove()
    #             lock = true

    # 分页
    # @function pagination
    # @param {_option} 需要定义的参数对象
    # @return {obj} 链式返回
    pagination : (_option) -> #添加分页页码
      $self = $(this).addClass('package-num')
      option = $.extend #设置默认的继承对象
        totalPage : 9, #总页数
        initPage : 1, #
        maxPage : 4,
        needSkip : false, #是否需要添加跳页
        pageCallback : $.noop #回调函数的类型为函数
        # pageCallback : ()->
      , _option or {}
      # _option 为手动配置的参数列表
      fillHtml = (page) -> #page - 要进入的页码
        $self.empty()
        # 上一页
        if option.totalPage >= 2
          $self.append '<a href="javascript:;" class="pre '+(if page > 1 then '' else 'disabled')+'"><span class="pre1"></span><span class="pre2"></span>上一页</a>'
          # 初始化的页面为4及以上，添加第一页
          $self.append '<a href="javascript:;" class="num">'+1+'</a>' if page isnt 1 and page >= option.maxPage and option.totalPage isnt option.maxPage
          # ...显示在页码1后面，当前页码>4,至少6页以上才会有
          $self.append '<span>...</span>' if page-2 > 2 and page <= option.totalPage and option.totalPage > option.maxPage+1
          start = page-2
          end = page+2 # 保持有四个相连续的页码

          end++ if (start > 1 and page < option.maxPage) or page == 1
          start-- if page > option.totalPage-option.maxPage and page >= option.totalPage
          #连续加载4个页码
          while start <= end
            if(start <= option.totalPage and start >= 1)
              $self.append '<a href="javascript:;" class="num '+(if start isnt page then '' else 'num-active')+'">'+start+'</a>'
            start++
          # 最低6页显示 ...
          $self.append('<span>...</span>') if page+2 < option.totalPage-1 and page >= 1 and option.totalPage > option.maxPage+1
          # 当不少于6页的时候，加载最后一页的页码
          $self.append('<a href="javascript:;" class="num">'+option.totalPage+'</a>') if page != option.totalPage and page < option.totalPage-2  and option.totalPage != option.maxPage
          #下一页
          $self.append '<a href="javascript:;" class="next '+(if page < option.totalPage then '' else 'disabled')+'"><span class="next1"></span><span class="next2"></span>下一页</a>'
          # 是否需要跳页按钮
          $self.append '<label for="">跳转到:</label><input type="text" value='+page+'><a href="javascript:;" class="skip">GO</a>' if option.needSkip
          # 页码大于等于100，缩小页码字体
          $(".package-num .num").css({"font-size":"12px"}) if option.totalPage >= 100
      $self.off "click"
      .on "click", "a.num:not(.num-active)", ()-> #点击已有的页码
        current = parseInt($(this).text()); #当前页码
        fillHtml current #更新按钮点击状态，当前点击的高亮显示
        option.pageCallback current #回调函数用来加载当前页面数据，去掉其他页面数据
      # 上一页
      .on "click","a.pre:not(.disabled)", ()->
        current = parseInt($(this).parents('.package-num').children("a.num-active").text())
        fillHtml current-1
        option.pageCallback current-1
      # 下一页
      .on "click", "a.next:not(.disabled)", ()->
        current = parseInt($(this).parents('.package-num').children("a.num-active").text())
        fillHtml current+1
        option.pageCallback current+1
      .on "click", 'a.skip', ()->
        current = parseInt($self.children("input").val())
        if(current isnt ~~current)
          $self.children("input").val(+$self.children('.num-active').text())
          return false
        current = 1 if current <= 0
        current = option.totalPage if current > option.totalPage
        fillHtml current
        option.pageCallback current
      fillHtml(option.initPage)
      $self


  $.extend
    # 设置cookie
    # @function setCookie
    # @param {key:cookie键名称，value:cookie值，days:过期时间}
    setCookie:(key, value, days)->
        expire = new Date()
        expire = expire.getTime() + days*24*60*60*1000
        document.cookie = key + "=" + escape(value) + ";expires=" + new Date(expire)

    # 获取cookie
    # @function getCookie
    # @param {key:cookie名称}
    getCookie: (key)->
        reg = new RegExp("(^| )"+name+"=([^;]*)(;|$)")
        arr = document.cookie.match()
        if arr isnt null then return unescape(arr[2])
        false

    # 删除cookie
    # @function delCookie
    # @param {key:cookie名称}
    delCookie:(key)->
        $.setCookie(key,"",-1)

    # 黑色浮层弹窗
    # @function toast
    # @param {_text} 弹出文案
    # @param {callback} 回调
    # @return {el} 链式返回
    toast : (_text,callback,time) ->
        $(".toast").remove();
        $("body").append "<div class='toast'><p>"+_text+"</p></div>"
        setTimeout( ->
            $(".toast").remove();
            callback() if callback;
        ,time || 2000)

    # json字符串转对象
    # @function stringToObj
    # @param {String} str 需要转义的json串
    # @return {obj} 返回转义后的对象
    stringToObj : (str) -> eval("(#{str})")

    # 对象转字符串
    # @function objToString
    # @param {obj} obj 需要转义的对象
    # @return {string} 返回转义后的json串
    objToString : (obj) ->
      JSON.stringify(obj).replace(/"/g,'"')

    # 获取url的参数
    # @function getUrlParam
    # @param {String} name 需要查找的字段名
    # @return {String} 返回获取的结果
    getUrlParam : (name) ->
      reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i")
      r = encodeURI(window.location.search).substr(1).match(reg)
      if r != null
        return unescape(r[2])
      null

    # 解析url参数
    # @function splitUrlParam
    splitUrlParam: ()->
      urlArr = location.href.split("/")
      paramArr = urlArr.pop().replace(".htm","").split("-")
      if paramArr.length > 1
        return paramArr
      null

    # 截取文本
    # @function cutContent
    cutContent: (str,len)->
      content = $.trim(str.replace(/nbsp;/g,""))
      if content.length > len then content.substring(0,len) + "..." else content

    # 判断当前电脑是否为mac
    # @function isMac
    isMac : () ->
      return (navigator.platform is "Mac68K") or (navigator.platform is "MacPPC") or (navigator.platform is "Macintosh") or (navigator.platform is "MacIntel")

    # 判断当前电脑是否为mac
    # @function 选中左侧菜单
    menuActive : (num) ->
      $('#left-menu a').removeClass('active').eq(num-1).addClass('active')
    selfChoose : () ->
      $('.choice').on 'click',()->
        $('.selfTrend').css('display','block')
        $('.selfManager').css('display','block')
