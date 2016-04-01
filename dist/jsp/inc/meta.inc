<%@ page pageEncoding="UTF-8" %>
<meta charset="utf-8">
<meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
<link rel="shortcut icon" type="image/x-icon" href="http://s.xnimg.cn/external/matrix/images/matrix.ico">
<link type="text/css" rel="stylesheet" href="http://s.xnimg.cn/external/matrix/css/base.css?ver=$revxxx$">
<script type="text/javascript" src="http://s.xnimg.cn/external/matrix/js/libs.js?ver=$revxxx$"></script>
<script type="text/javascript" src="http://s.xnimg.cn/external/matrix/js/base.js?ver=$revxxx$"></script>
<script type="text/javascript">
    define.config({map:{
        "mustache": "http://s.xnimg.cn/external/matrix/js/libs/mustache.js?ver=$revxxx$",
        "newManager": "http://s.xnimg.cn/external/matrix/js/newManager.js?ver=$revxxx$",
        "managerDetail": "http://s.xnimg.cn/external/matrix/js/managerDetail.js?ver=$revxxx$",
        "selfFundManager": "http://s.xnimg.cn/external/matrix/js/selfFundManager.js?ver=$revxxx$",
        "selfFund": "http://s.xnimg.cn/external/matrix/js/selfFund.js?ver=$revxxx$",
        "searchFund": "http://s.xnimg.cn/external/matrix/js/searchFund.js?ver=$revxxx$",
        "fundDetail": "http://s.xnimg.cn/external/matrix/js/fund/fundDetail.js?ver=$revxxx$",
        "fundHold": "http://s.xnimg.cn/external/matrix/js/fundHold.js?ver=$revxxx$",
        "fundCompare": "http://s.xnimg.cn/external/matrix/js/fundCompare.js?ver=$revxxx$",
        "index": "http://s.xnimg.cn/external/matrix/js/index.js?ver=$revxxx$",
        "login": "http://s.xnimg.cn/external/matrix/js/login.js?ver=$revxxx$"
    }});
    //公共初始化
    $(function(){
        require(["common"],function(common){
            common.init();
        })
    });
    var host = '${host.id}';
</script>
