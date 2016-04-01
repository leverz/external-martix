#@2016.03.03
define "newManager",(require,exports)->

  mustache = require "mustache"

  #数据下载的两个全局变量
  FILE = 0 #全局文件类型变量
  TABS = ""#list选中的checkbox所代表的参数
  dataList = ""

  LOCK_SCROll = false # 锁住加载

  tpl = 
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
  elem = # dom节点
    tableBox: $(".table")
    sortBar:$(".botLine")
    typeBy:$(".typeBy")
    listTr: """
            {{#data}}
                <tr class="{{bgColorRender}}">
                <td class="hasRight name"><a target="_blank"href="http://matrix.sofund.com/fundManager/detail?managerName={{managerName}}">{{managerName}}</a></td>
                <td>{{yieldMoth1}}%</td>
                <td>{{yieldMoth3}}%</td>
                <td>{{yield}}%</td>
                <td class="hasRight">{{sharpeIndex}}</td>
                <td>{{volitality}}%</td>
                <td class="hasRight">{{drawback}}</td>
                <td class="hasRight">{{fundScale}}亿</td>
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

  opt = # 列表加载参数
    pageId:1
    sortBy:2
    sortId:1
    type:"全部"
    company:"全部"
    record:"全部"
    backOr:"全部"
    career:"全部"
    govern:"全部"
  doHandle =
    getCompany:-> # 获取基金公司
      $.ajax
        url:'/filter/workcompany'
        type:'get'
        success:(rs)->
          if(rs.code is 0)
            # $("#company li").not(".active,#company li:first-child").remove()
            company=$('#company')
            filter=$('#findCompany')
            keys=Object.keys(rs.split)
            filter.append("<li class='active' data='hot'>热门</li>")
            for one in keys
              if one isnt 'hot'                
                filter.append("<li data='#{one}'>#{one}</li>")
            for one in rs.split.hot
              company.append("<li >#{one}</li>")
            company.show()
    changeCompany:(e)->
      $.ajax
        url:'/filter/workcompany'
        type:'get'
        success:(rs)->
          if(rs.code is 0)
            $('#company').empty()
            for one in rs.split[e]
              $('#company').append("<li >#{one}</li>")
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
        url:"/filter/manager2"
        type:"post"
        dataType:"json"
        data:
          fundType:opt.type
          company:opt.company
          degree:opt.record
          oversea:opt.backOr
          workyear:opt.career
          fundScale:opt.govern
          sortedBy:opt.sortBy
          sortDirection:opt.sortId
          page:opt.pageId
          pageSize:24
        success:(rs)->
          if(rs.code is '0')
            for i in [0...rs.list.length]
              rs.list[i].index = i

            list =
              data :rs.list
              drawback:->
                if @maxDrawback is '0'  || '0.00' then '--' else @maxDrawback               
              chooseRender: ->
                if(this.addFlag is true) then '取消自选' else '加入自选'
              logoRender: ->
                if(this.addFlag is true) then 'cancelLogo' else 'addLogo'
              btnClassRender: ->
                if(this.addFlag is true) then 'cancel' else 'add'
              bgColorRender:->
                if(this.index%2 is 0) then 'eventBg' else 'oddBg'

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

    #数据下载相关函数
    differentiate:()->
        FILE = 8
        $("body").append(tpl.selfManagerFund).css('overflow-y','hidden')
    closeDialog :->
        $(".downloadBox").remove()
        $(".mask").remove()
        $('body').css('overflow-y','auto')
    cancle :->
        $(".downloadBox").remove()
        $(".mask").remove()
        $('body').css('overflow-y','auto')
    #接口函数参照文档
    downloadData :(id)->
        data = 
            file : FILE
            tabs : TABS
        window.open "http://matrix.sofund.com/download/excelnew?"+$.param(data)+"&"+$.param(dataList)
        $(".downloadBox").remove()
        $(".mask").remove()

  listener =
    init:->
      @doSort()# 做排序
      @descBy() # 分类
      @loadFund()
      @addFavorate() #加入自选
      @moreCompany()
      @close()
      @cancle()
      @download()
      @findCompany()

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

        dataList = 
          fundType:opt.type
          company:opt.company
          degree:opt.record
          oversea:opt.backOr
          workyear:opt.career
          fundScale:opt.govern
          sortedBy:opt.sortBy
          sortDirection:opt.sortId
          page:opt.pageId
          pageSize:24

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
    moreCompany:->
      $(".moreCompany").on "click",->
        doHandle.getCompany();
        data=$('#company').attr('data');
        if data is '0'
          $('#company').addClass('showAll');
          $(".moreCompany").text('收起');
          $('#company').attr('data','1');
          $(".moreCompany").css('background-image','url(http://s.xnimg.cn/external/matrix/images/up_Show.png)');
        if data is '1'
          $('#company').scrollTop(0)
          $('#company').removeClass('showAll');
          $(".moreCompany").text('更多');
          $('#company').attr('data','0');
          $(".moreCompany").css('background-image','url(http://s.xnimg.cn/external/matrix/images/down_Show.png)')

    #数据下载弹窗的相关方法
    close :->
        $("body").on "click",".dBoxClose",->
            doHandle.closeDialog()

    cancle :->
        $("body").on "click",".dCancle",->
            doHandle.cancle()

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



            
            doHandle.downloadData()
    findCompany : ->
        $('#findCompany').on 'click' , 'li',->
          This=$(this)
          data=This.attr('data')
          This.addClass('active')
          This.siblings().removeClass('active')
          doHandle.changeCompany(data)


  init = ->
    $.menuActive(2)
    $.selfChoose()
    listener.init()
    doHandle.changeList(opt) # 分类
    doHandle.getCompany()

    $(".down-data").off("click").on "click",-> 
        doHandle.differentiate()

  init:init
