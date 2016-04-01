#@2016.03.03
define "selfFund",(require,exports)->

  mustache = require "mustache"

  LOCK_SCROll = false # 锁住加载

  elem = # dom节点
    tableBox: $(".table")
    sortBar:$(".botLine")
    typeBy:$(".typeBy")
    listTr: """
            {{#data}}
                <tr class="{{bgColorRender}}">
                    <td class="hasRight name" data-code="{{fundCode}}"><a class="fund-name" onclick="e.preventDefault()" href="http://matrix.sofund.com/fund/detail?code={{fundCode}}" target="_blank">{{fundName}}</a></td>
                    <td class="hasRight">{{fundType}}</td>
                    <td>{{yieldMoth1}}%</td>
                    <td>{{yieldMoth3}}%</td>
                    <td>{{yield}}%</td>
                    <td class="hasRight">{{sharpeIndex}}</td>
                    <td>{{volitality}}%</td>
                    <td class="hasRight">{{drawback}}</td>
                    <td class="hasRight">{{fundScale}}亿</td>
                    <td class="hasRight">{{limitDay}}</td>
                    <td class="hasRight">{{instPosRatio}}%</td>
                    <td class="hasRight">
                        <div class="handle">
                            <i class="choose {{logoRender}}"></i>
                            <a href="javascript:;" class="{{btnClassRender}}">{{chooseRender}}</a>
                        </div>
                    </td>
                </tr>
            {{/data}}
          """
    chenStar:"""<i class="star s-{{morningstarScore}}"></i>"""
    yinStar:"""<i class="star s-{{galaxyScore}}"></i>"""

  opt = # 列表加载参数
    pageId:1
    sortBy:2
    sortId:1

  doHandle =
#添加自选#
    addSelf: (data)->
        $.ajax
            url:"/fund/userfund/add"
            type:'get'
            dataType:'json'
            data: data
            success:(res)->
                if +res.code is 0
                    
                else
                    $.toast res.msg
    #取消自选#
    cancelSelf: (data)->
        $.ajax
            url:"/fund/userfund/del"
            type:'get'
            dataType:'json'
            data: data
            success:(res)->
                if +res.code is 0
                    
                else
                    $.toast res.msg


    changeList: (opt)-># 更新列表
      $.ajax
        url:"/fund/user/fundlist"
        type:"get"
        dataType:"json"
        data:
          sortedBy:opt.sortBy
          sortedDirection:opt.sortId
          page:opt.pageId
          pageSize:30
        success:(rs)->
          if(rs.code is 0)
            for i in [0...rs.list.length]
              rs.list[i].index = i
            list =
              data:rs.list
              chooseRender: ->
                if(this.addFlag is true) then '取消自选' else '加入自选'
              logoRender: ->
                if(this.addFlag is true) then 'cancelLogo' else 'addLogo'
              btnClassRender: ->
                if(this.addFlag is true) then 'cancel' else 'add'
              bgColorRender:->
                if(this.index%2 is 0) then 'eventBg' else 'oddBg'
              chenStar:->
                  if @morningstarScore is 0 then '--' else tpl.chenStar
              yinStar:->
                  if @galaxyScore is 0 then '--' else tpl.yinStar
              drawback:->
                if @maxDrawback is '0.00' then '--'
            html = mustache.render(elem.listTr, list)
            # $('#fundList tr').each (i,n)->
            #   $(n).find('td').eq(thIndex).css('color','#ced6e1')
            if(LOCK_SCROll)
              if(opt.pageId > rs.pageCount)
                return
                LOCK_SCROll = false
              else
                $(".fundList").append(html)
                LOCK_SCROll = false
            else
              $(".fundList").empty().append(html)

  listener =
    init:->
      @doSort()# 做排序
      @loadFund()
      @addFavorate() #加入自选


    doSort:-> # 做排序
      elem.tableBox.on "click",".sortCol",->
        self = $(this)
        elem.tableBox.scrollTop 0
        opt.pageId = 1
        if self.parents(".headFix")
            #将吸顶head的排序标记传给原表头#
            self = $("thead").eq(0).find("tr").eq(1).find("th").eq(self.index())
        self.addClass("active").siblings(".sortCol").removeClass("active") #该列字体高亮
        self.siblings(".sortCol").find(".updown").find("div").removeClass("active") # 其他列排序符号置灰
        # 降序
        if(!$(".down",self).hasClass("active") and !$(".up",self).hasClass("active") or $(".up",self).hasClass("active"))
          $(".up",self).removeClass("active")
          $(".down",self).addClass("active")
          opt.sortBy = self.data("sort")
          opt.sortId = 1
          doHandle.changeList(opt)
        else #升序
          $(".down",self).removeClass("active")
          $(".up",self).addClass("active")
          opt.sortBy = self.data("sort")
          opt.sortId = 0
          doHandle.changeList(opt)

    loadFund:-> #滚动加载基金#
      $("div.table").on "scroll",->
        dataTable = $("div.table")
        scrollTop = dataTable.scrollTop()
        docHeight = dataTable.find("table").eq(0).height()
        lock = true
        $(".headFix").remove()
        #根据scoll高度是否吸顶表头#
        if (scrollTop > 42) and ($(".headFix").length is 0) and lock
            head = dataTable.find("thead").prop("outerHTML")
            table = """<table class="headFix">#{head}<tbody></tbody></table>"""
            dataTable.append(table).find("thead").eq(1).removeClass(".headItem")
            $.each $(".headItem th"),(i)->
                $(".headFix").find("thead tr").eq(1).find("th").eq(i).width $(this).width()
            lock = false
        else if scrollTop < 42
                $(".headFix").remove()
                lock = true

        if LOCK_SCROll then return # 若正在加载请稍等
        if docHeight-scrollTop-700 > 30
          opt.pageId++
          LOCK_SCROll = true
          doHandle.changeList(opt)

    addFavorate:-> #自选操作
      $(".table table").on "click",".handle",->
        self = $(this)
        parent = self.parents("tr");
        data =
              code:parent.find("td:first").attr "data-code"
              fundName:parent.find("td:first").children().text()
        if(self.find("a").text() is '加入自选')
          doHandle.addSelf(data)
          self.find("i").removeClass("addLogo").addClass("cancelLogo")
          self.find("a").removeClass("add").addClass("cancel").end().find("a").html('取消自选')
        else if(self.find("a").text() is '取消自选')
          doHandle.cancelSelf(data)
          self.find("i").removeClass("cancelLogo").addClass("addLogo")
          self.find("a").removeClass("cancel").addClass("add").end().find("a").html('加入自选')




  init = ->
    $.menuActive(3)
    $.selfChoose()
    listener.init()
    doHandle.changeList(opt) # 分类

  init:init
