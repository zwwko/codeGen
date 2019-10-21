<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/context/myTag.jsp" %>
<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title></title>
<script src="${ctx_module}/dist/js/jquery-1.8.3.min.js"></script>
<link rel="stylesheet" href="${ctx_module}/plugins/layui/css/layui.css" />
<link rel="stylesheet" href="${ctx_module}/dist/css/commen.css" />
<link rel="stylesheet" href="${ctx_module}/plugins/layui-formSelects/dist/formSelects-v4.css" />
<style type="text/css">
.layui-btn-sm {
    height: 25px;
    line-height: 25px;
    padding: 0 30px;
    font-size: 14px;
}
.layui-word {
    color: #1492ff;
}
.menuContent {
    left: 0px;
    top: 33px;
    width: 220px;
    height: 300px;
}
</style>
</head>
<body>
<div class="layui-fluid">
  <div class="layui-row layui-col-space15">
    <div class="layui-col-md12">
      <div class="layui-card">
        <div class="layui-card-body nominheight">
          <form class="layui-form content-form" method="post" lay-filter="pojo">
			<input type="hidden" name="id" value="${object.id}">
			  <@for(var i=0,len=columnInfForm.~size;i<len;i++){
			  if(0==i){@>
			  <div class="layui-form-item">
				  <@}if(i>0&&0==i%2){@>
			  </div><div class="layui-form-item">
			  <@}@>
			  <div class="layui-col-xs6">
				  <label class="layui-form-label">@{columnInfForm[i].remarks}</label>
				  <div class="layui-input-block">
					  <@if(columnInfForm[i].typeName=='TINYINT'){@>
					  <select id="@{columnInfForm[i].columnName}" name="@{columnInfForm[i].columnName}"></select>
					  <@}else if(columnInfForm[i].typeName=='BIGINT'){@>
					  <input type="hidden" name="@{columnInfForm[i].columnName}" id="@{columnInfForm[i].columnName}" >
					  <input type="text" class="layui-input" id="@{columnInfForm[i].columnName}Date">
					  <@}else if(columnInfForm[i].columnSize>1000){@>
					  <textarea class="layui-textarea" name="@{columnInfForm[i].columnName}"></textarea>
					  <@}else{@>
					  <input type="text" class="layui-input" name="@{columnInfForm[i].columnName}" >
					  <@}@>
				  </div>
			  </div>
			  <@if(i==len-1){@>
		  	  </div>
			  <@}}@>
	        <button id="formDemo" class="layui-hide" lay-submit lay-filter="formDemo"></button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript" src="${ctx_module}/plugins/layui/layui.all.js"></script>
<script type="text/javascript" src="${ctx_module}/plugins/layui-formSelects/dist/formSelects-v4.min.js"></script>
<script src="${ctx_module}/dist/js/jquery.ajaxCall.js"></script>
<!-- ckeditor -->
<script type="text/javascript" src="${ctx_module}/plugins/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="${ctx_module}/plugins/ckeditor/config.js"></script>
<!-- pupload --> 
<script src="${ctx_module}/plugins/plupload/js/plupload.full.min.js" type="text/javascript"></script> 
<script src="${ctx_module}/plugins/plupload/js/i18n/zh_CN.js" type="text/javascript"></script>
<script src="${ctx_module}/dist/js/PuploadHelper.js" type="text/javascript"></script>
<!-- fancybox -->
<link rel="stylesheet" href="${ctx_module}/plugins/fancyBox/source/jquery.fancybox.css" type="text/css" media="screen" />
<script type="text/javascript" src="${ctx_module}/plugins/fancyBox/source/jquery.fancybox.pack.js"></script>
<script type="text/javascript" src="${ctx_module}/dist/js/form-helper.js"></script>
<script>
var dataMap = {};
dataMap.editor = null;
//附件参数
dataMap.fileAccessoryIds = [];
dataMap.loadingIndex = 0;
dataMap.pojo = '${objectJson}';


$(function(){
	layui.use(['laydate', 'form'], function(){
		var form = layui.form;
		var laydate = layui.laydate;
        dataMap.form = layui.form;
        initFormSelect();
        form.val('pojo', JSON.parse(dataMap.pojo));

		form.on('submit(formDemo)', function(data){
		    var url="${ctx}/@{moduleName}/@{entityName}/saveOrUpdate";
		 	// 赋值ID
		    data.field.fileAccessoryIds = dataMap.fileAccessoryIds.join(",");
		    // data.field.content = content;
		  	//转义方法
		    dataMap.htmlEscape(data.field);
		  	//console.log(data.field)
		  	var loadingIndex = top.uiLayer.showloading({content: '保存中...'});
			AjaxCall.nPost(url, data.field, function(data){
				// 清空附件ID
				dataMap.fileAccessoryIds = [];
				var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
				dataMap.win.dataReload();
				parent.layer.close(index); //再执行关闭
                parent.layer.alert('操作成功');
                top.uiLayer.closeloading(loadingIndex);
			});
			
		    //阻止表单跳转。
		    return false;
		});

    	<@for(obj in columnInfForm){if(obj.typeName=="BIGINT"){@>
            laydate.render({
                elem: '#@{obj.columnName}Date',
                // type: 'datetime',
                value: ''=='${object.@{obj.columnName}}'?'':new Date(${object.@{obj.columnName}}),
                done: function(value, date){
                    if(""==value){
                        $('#@{obj.columnName}').val("")
                    }else {
                        $('#@{obj.columnName}').val(new Date(value).getTime())
                    }
                }
            });
        <@}}@>
	});

});

dataMap.htmlEscape = function(obj) {
	$.each($(":input[htmlEscape]"), function(i ,item){
		var value = $(item).val();
		var name = item.name;
		value = value.replace(/[<>"'&]/g, function(match, pos, originalText){
			switch(match){
		    	case "<":
		    		return "&lt;";
		    	case ">":
		    		return "&gt;";
		    	case "&":
		    		return "&amp;";
		    	case "\"":
		    		return "&quot;";
		    	case "\'":
		    		return "&apos;";
			}
		});
		obj[name] = encodeURIComponent(value);
	})
};


function initFormSelect(){
    var url="${ctx}/urp/dictionarycontent/findmuti";
    var codes = [];
<@for(obj in columnInfForm){if(obj.typeName=="TINYINT"){@>
        codes.push("@{obj.columnName}");//@{obj.remarks}
    <@}}@>
    var param = {"codes":codes.join(",")};
    AjaxCall.nPost(url, param, function(data){
    <@for(obj in columnInfForm){if(obj.typeName=="TINYINT"){@>
            FormHelper.selectRender({id:"@{obj.columnName}", obj:data.@{obj.columnName}});//@{obj.remarks}
        <@}}@>
        dataMap.form.render('select');
    }, null, 'json', false);
}

function save(win){
	dataMap.win = win;
	$("#formDemo").trigger("click");	
}

</script>
</body>
</html>

