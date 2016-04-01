#@2016.03.03
define "selfFundManager",(require,exports)->

  mustache = require "mustache"

  LOCK_SCROll = false # 锁住加载

  elem = # dom节点
    tableBox: $(".table")
    sortBar:$(".botLine")
    typeBy:$(".typeBy")
    listTr: """
            {{#data}}
                <tr class="{{bgColorRender}}">
                <td class="hasRight name"><a target="_blank"href="http://matrix.sofund.com/fundManager/detail?managerName={{managerName}}">{{managerName}}</a></td>
                <td class="hasRight">{{fundType}}</td>
                <td>{{yieldMoth1}}</td>
                <td>{{yieldMoth3}}</td>
                <td>{{yield}}</td>
                <td class="hasRight">{{sharpeIndex}}</td>
                <td>{{volitality}}</td>
                <td class="hasRight">{{drawback}}</td>
                <td class="hasRight">{{fundScale}}</td>
                <td class="hasRight">{{instPosRatio}}</td>
                <td class="hasRight">
                    <div class="handle">
                        <i class="choose {{logoRender}}"></i>
                        <a href="javascript:;" class="{{btnClassRender}}">{{chooseRender}}</a>
                    </div>
                </td>
            </tr>
            {{/data}}
    """

  opt = # 列表加载参数
    pageId:1
    sortBy:2
    sortId:1
    type:"货币型"

  doHandle =
    

    addChoose:(fundName,self)-> # 基金经理加减自选
      $.ajax
        url:'/fundManager/addFavourite'
        type:'post'
        dataType:'json'
        data:
          managerName:fundName
        success:(rs) ->
          if(self.find("a").text() is '加入自选')
            self.find("i").removeClass("addLogo").addClass("cancelLogo")
            self.find("a").removeClass("add").addClass("cancel").end().find("a").html('取消自选')
#            self.find("a").html('取消自选')
          else
            self.find("i").removeClass("cancelLogo").addClass("addLogo")
            self.find("a").removeClass("cancel").addClass("add").end().find("a").html('加入自选')

    changeList: (opt)-># 更新列表
      $.ajax
        url:"/fund/user/managerlist"
        type:"post"
        dataType:"json"
        data:
          fundType:opt.type
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
              drawback:->
                if @maxDrawback is '0'  || '0.00' then '--' else @maxDrawback
            html = mustache.render(elem.listTr, list)
            if(LOCK_SCROll)
              if(opt.pageId > rs.pageCount)
                return
                LOCK_SCROll = false
              else
                $(".managerList").append(html)
                LOCK_SCROll = false
            else
              $(".managerList").empty().append(html)

  listener =
    init:->
      @doSort()# 做排序
      @descBy() # 分类
      @loadFund()
      @addFavorate() #加入自选
      @changeType()


    changeType:->
      $('#fundType').on 'change',->
        This=$(this)
        opt.type=This.val()
        doHandle.changeList(opt)

    descBy: -> # 根据类型区分
      elem.typeBy.on "click","li",(e)->
        self = $(this)
        id = $(e.target).parent().attr("id")
        switch id
          when 'type'   # 擅长类型
            self.addClass("active")
            self.siblings().removeClass("active")
            if(self.text() is '全部')
              opt.type = self.text()
            else
              if(/[\u4E00-\u9FA5]/.test(self.text())) #去掉‘型’字
                fundLen = self.text().length
                opt.type = self.text().substr(0,fundLen-1)
              else
                opt.type = self.text() # 英文的类型保持不变
            doHandle.changeList(opt)
          when 'company'# 基金公司
            self.addClass("active")
            self.siblings().removeClass("active")
            opt.company = self.text()
            doHandle.changeList(opt)
          when 'record' # 经理学历
            self.addClass("active")
            self.siblings().removeClass("active")
            opt.record = self.text()
            doHandle.changeList(opt)
          when 'backOr' # 是否海归
            self.addClass("active")
            self.siblings().removeClass("active")
            opt.backOr = self.text()
            doHandle.changeList(opt)
          when 'career' # 从业时间
            self.addClass("active")
            self.siblings().removeClass("active")
            opt.career = self.text()
            doHandle.changeList(opt)
          when 'govern' # 管理规模
            self.addClass("active")
            self.siblings().removeClass("active")
            opt.govern = self.text()
            doHandle.changeList(opt)

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

    addFavorate:-> #添加自选
      $(".table table").on "click",".handle",->
        self = $(this)
        name = self.parents("tr").find(".name").text()
        doHandle.addChoose(name,self)




  init = ->
    $.menuActive(3)
    $.selfChoose()
    listener.init()
    doHandle.changeList(opt) # 分类

  init:init
