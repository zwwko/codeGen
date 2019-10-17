<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/context/myTag.jsp" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title></title>
    <script type="text/javascript" src="${ctx_module}/dist/js/jquery-1.8.3.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${ctx_module}/plugins/jquery-easyui/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="${ctx_module}/plugins/jquery-easyui/themes/icon.css" />
    <script type="text/javascript" src="${ctx_module}/plugins/jquery-easyui/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${ctx_module}/dist/css/main-c.css" />
    <link rel="stylesheet" href="${ctx_module}/plugins/layui/css/layui.css" />
    <link rel="stylesheet" href="${ctx}/static/sifa/css/table.css" />
    <!-- jPages -->
    <script src="${ctx_module}/plugins/jPages/js/jPages.js"></script>
    <link rel="stylesheet" type="text/css" href="${ctx_module}/plugins/jPages/css/jPages.css" />
    <script src="${ctx_module}/dist/js/PageHelper.js"></script>
    <!-- ztree -->
    <%-- <link rel="stylesheet" href="${ctx_module}/plugins/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" /> --%>
    <%-- <script type="text/javascript" src="${ctx_module}/plugins/zTree/js/jquery.ztree.core.js"></script> --%>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/ztree/zTreeStyle/bootstrapztree.css">
    <script type="text/javascript"  src="${ctx}/static/ztree/jquery.ztree.all-3.5.min.js"></script>

    <!-- dayjs -->
    <script src="${ctx_module}/dist/js/dayjs.min.js"></script>
    <style>
        .panel-body {
            background: none;
        }
        .layui-fluid{
            padding: 0;
        }
        .ztree{
            margin-top: 5px;
        }
        .portlet-body .m-title {
            background-color: #4ea6eb;
        }
        .layui-form-checked span, .layui-form-checked:hover span {
            background-color: #4ea6eb;
        }
    </style>
</head>
<body class="easyui-layout">
<div data-options="region:'west',border:false" style="width:250px; overflow:hidden;padding: 15px; padding-right: 0;">
    <div class="porlet">
        <div class="portlet-body">
            <h3 class="m-title">组织机构信息</h3>
            <div id="sidebar" style="width:205px;display: block;overflow: auto;">
                <ul id="orgTree" class="ztree"></ul>
            </div>
        </div>
    </div>
</div>
<div data-options="region:'center',border:false" style="overflow: hidden; padding: 15px;">
    <div class="layui-fluid">
        <div class="layui-row layui-col-space15">
            <div class="layui-col-md12">
                <div class="layui-card">
                    <div class="layui-card-header"> <span>@{tableInf.remarks}</span>
                        <div class="tools_bar">
                            <button type="button" class="default-btn btn-radius bposright" onclick="add();">新增</button>
                        </div>
                    </div>
                    <div class="layui-card-body nominheight">
                        <form id="form-submit" class="layui-form layuiadmin-card-header-auto search-card" lay-filter="pojo">
                            <input type="hidden" name="orgIdxx" id="orgId" />
                            <div class="layui-form-item">
                                <@for(obj in columnInfQuery){if(obj.columnName!="id"){@>
                                <div class="layui-inline">@{obj.remarks}</div>
                                <div class="layui-inline">
                                    <@if(obj.typeName=="TINYINT"){@>
                                    <select id="@{obj.columnName}" name="@{obj.columnName}"></select>
                                    <@}else if(obj.typeName=="BIGINT"){@>
                                    <input type="hidden" name="@{obj.columnName}" id="@{obj.columnName}">
                                    <input type="text" class="layui-input" id="@{obj.columnName}Date">
                                    <@}else{@>
                                    <input type="text" class="layui-input" name="@{obj.columnName}" placeholder="@{obj.remarks}">
                                    <@}@>
                                </div>
                                <@}}@>
                                <div class="layui-inline">
                                    <button class="default-btn btn-radius" id="formSearch" lay-submit lay-filter="formSearch" >查 询</button>
                                    <button type="reset" class="default-btn btn-radius">重置</button>
                                </div>
                            </div>
                        </form>
                        <div class="table-body">
                            <div class="tablelist">
                                <table class="table table-ellipsis">
                                    <thead>
                                    <tr>
                                        <th width="28">序号</th>
                                        <@for(obj in columnInfList){@>
                                        <th>@{obj.remarks}</th>
                                        <@}@>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody id="itemContainer">
                                    </tbody>
                                </table>
                            </div>
                            <div class="jpagination">
                                <div class="page">
                                    <div class="holder"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${ctx_module}/dist/js/jquery.ajaxCall.js"></script>
<script type="text/javascript" src="${ctx_module}/plugins/layui/layui.all.js"></script>
<!-- artTemplate 兼容 ie -->
<script src="${ctx}/static/artTemplate/lib/es5-shim.min.js"></script>
<script src="${ctx}/static/artTemplate/lib/es5-sham.min.js"></script>
<script src="${ctx}/static/artTemplate/lib/json3.min.js"></script>
<script src="${ctx}/static/artTemplate/lib/template-web.js"></script>
<!-- tableHtml  -->
<script id="tableHtml" type="text/html">
    {{each list as value i}}
    <tr>
        <td>{{i+1}}</td>
        <@for(obj in columnInfList){
          if(obj.columnName!="id"){@>
        <td>{{value.@{obj.columnName}<@if(obj.typeName=="BIGINT"){@> | dateformat 'YYYY-MM-DD'<@}@><@if(obj.typeName=="TINYINT"){@> | dictformat '@{obj.columnName}'<@}@>}}</td>
        <@}}@>
        <td class="operate">
            <a href="javascript:void(0)"  title="编辑" class="btn-delete" onclick="edit('{{value.id}}')">编辑</a>
            <a href="javascript:void(0)" title="删除" class="btn-def" onclick="deleteById('{{value.id}}')">删除</a>
        </td>
    </tr>
    {{/each}}
</script>
<script type="text/javascript" src="${ctx_module}/dist/js/form-helper.js"></script>
<script>
    var dataMap = {};
    dataMap.pageNumber = 1; //当前页，默认1
    dataMap.pageSize = 10; //每页数量，默认10
    var dict = {}

    var zTreeObj;
    var setting = {
        check: {
            enable: false
        },
        data: { simpleData: { enable: true } },
        callback: {
            onClick: function onClick(e,treeId,treeNode){
                $("#orgId").val(treeNode.id);
                $('#allSearch').attr('checked',false);
                layui.form.render();
                $("#formSearch").trigger("click");
            },
            onExpand:function onExpand(event, treeId, treeNode){
                flushNode(treeNode.id);
            }

        }
    };
    var zNodes = ${treeNodes};
    $(function() {
        $(".search-card").toggle();
        //
        $('.layui-card-body').css("height", $(window).height() - 100);
        $('#sidebar').css("height", $(window).height() - 100);

        // 自适应
        $(window).resize(function() {
            $('.layui-card-body').css("height", $(window).height() - 100);
            $('#sidebar').css("height", $(window).height() - 100);
        });
        zTreeObj = $.fn.zTree.init($("#orgTree"), setting, zNodes);
        treeNode = zTreeObj.getNodeByParam("id", "root");
        if(treeNode){
            zTreeObj.selectNode(treeNode);
        }
        //
        layui.use('form', function(){
            dataMap.form = layui.form;

            // search
            dataMap.form.on('submit(formSearch)', function(data){
                var allSearch = $('#allSearch').attr('checked');
                if('checked' == allSearch){
                    data.field.allSearch = true;
                }else{
                    data.field.allSearch = false;
                }
                dataMap.url = "${ctx}/@{moduleName}/@{entityName}/list";
                PageHelper.datagrid({
                    url: dataMap.url,
                    params: data.field,
                    pageNumber: dataMap.pageNumber,
                    perPage: dataMap.pageSize
                });
                //阻止表单跳转。
                return false;
            });

            template.defaults.imports.dateformat = function(value, patten){
                if(patten == ""){
                    patten = "YYYY-MM-DD HH:mm:ss";
                }
                if(dayjs(value).isValid()){
                    return dayjs(value).format(patten);
                }else{
                    return "";
                }
            };
            template.defaults.imports.dictformat = function(value, type){
                if(null==type || null==value || "" ==value){
                    return value;
                }
                var dt =dict[type];
                if(null==dt){
                    initDict();
                    dt =dict[type];
                }
                for(var i=0;i<dt.length;i++){
                    if(value==dt[i].value){
                        return dt[i].text;
                    }
                }
                return value;
            };
        });

        //点击浙江省司法厅 var node = zTreeObj.getNodeByParam('code', "330");
        var node = zTreeObj.getNodes()[0];
        zTreeObj.selectNode(node);
        $(".curSelectedNode").trigger('click');

        initFormSelect();
    });


    function initDict() {
        var dictUrl="${ctx}/urp/dictionarycontent/findmuti";
        var codes = [];
        <@for(obj in columnInfList){if(obj.typeName=="TINYINT"){@>
            codes.push("@{obj.columnName}");//@{obj.remarks}
        <@}}@>
        var dictParam = {"codes":codes.join(",")};
        AjaxCall.nPost(dictUrl, dictParam, function(data){
        <@for(obj in columnInfList){if(obj.typeName=="TINYINT"){@>
                dict["@{obj.columnName}"]= data.@{obj.columnName};//@{obj.remarks}
        <@}}@>
        }, null, 'json', false);
    }

    function initFormSelect(){
        var url="${ctx}/urp/dictionarycontent/findmuti";
        var codes = [];
        <@for(obj in columnInfQuery){if(obj.typeName=="TINYINT"){@>
            codes.push("@{obj.columnName}");//@{obj.remarks}
        <@}}@>
        var param = {"codes":codes.join(",")};
        AjaxCall.nPost(url, param, function(data){
            <@for(obj in columnInfQuery){if(obj.typeName=="TINYINT"){@>
                FormHelper.selectRender({id:"@{obj.columnName}", obj:data.@{obj.columnName}});//@{obj.remarks}
            <@}}@>
            dataMap.form.render('select');
        }, null, 'json', false);
    }


    function dataReload() {
        PageHelper.reload();
    }

    function flushNode(pId){
        if(null == pId || '' == pId){
            return;
        }
        var url = "${ctx}/userfront/orgTree?pId=" + pId;
        AjaxCall.nGet(url, {}, function (data) {
            var treeObj = $.fn.zTree.getZTreeObj("orgTree");
            var node = treeObj.getNodeByParam("id",pId,null);
            var children = [];
            if(null != data){
                $(data).each(function(index,element){
                    element.isParent = false
                    if(element.id == pId){
                        return true;
                    }
                    children.push(element);
                });
            }
            node.children = children;
            treeObj.refresh();
        });
    }

    function add(){
        parent.uiLayer.Iframe({
            title: '新增',
            area: ['1100px', '90%'],
            btn: ['取 消','保 存'],
            content: "${ctx}/@{moduleName}/@{entityName}?redirect=/@{redirect}/add",
            yes: function(index, layero){
                parent.layer.close(index);
            },
            btn2: function(index, layero){
                var iframeName = layero.find('iframe')[0]['name'];
                var iframeWin = parent.window[iframeName];
                // iframeWin.$('#status').val('1');
                iframeWin.save(window);
                dataReload();
            }
        });
    }
    function deleteById(id){
        parent.layer.confirm('确定要删除吗？', function(index){
            var url="${ctx}/@{moduleName}/@{entityName}/delete?id="+id;
            AjaxCall.nGet(url, {}, function(data){
                if(data.success==true){
                    dataReload();
                    parent.layer.close(index); //再执行关闭
                    parent.layer.alert('删除成功');
                }else{
                    parent.layer.alert(data.msg);
                }
            });
        });
    }
    function edit(id){
        parent.uiLayer.Iframe({
            title: '编辑',
            area: ['1100px', '90%'],
            btn: ['取 消','保 存'],
            content: "${ctx}/@{moduleName}/@{entityName}?redirect=/@{redirect}/edit&id="+id,
            yes: function(index, layero){
                parent.layer.close(index);
            },
            btn2: function(index, layero){
                var iframeName = layero.find('iframe')[0]['name'];
                var iframeWin = parent.window[iframeName];
                // iframeWin.$('#status').val('1');
                iframeWin.save(window);
                dataReload();
            }
        });
    }
</script>
</body>
</html>


