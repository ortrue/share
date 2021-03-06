<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="UTF-8"%>
<%@ page import="cn.com.dayang.suyou.constants.Constants"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>首页</title>

<script src="${ctx}/static/tab-plugin/mainTab.js" type="text/javascript"></script>

</head>
<body>

	<div class="frame-main">
		<div class="mail-header">
			<div class="toolbaritem">
				<button type="button" class="btn btn-default" onclick="confirmDel();">
					<i class="icon-trash mr5"></i>删除
				</button>
			</div>
			
			<div align="right">
				<div class="ctheader">
					<div class="input-append">
						<input class="span2" type="text" id="inboxKeywords" name="inboxKeywords">
						<button class="btn  btn-default btn-sm" type="button" onclick="doSearch()">搜索</button>
					</div>
				</div>
			</div>
			
		</div>
		<div class="mailtable">
			<table class="table">
				<thead>
					<tr>
						<th width="22"><input type="checkbox" id="chkall"/></th>
						<th width="26"><span class="iconfj"></span></th>
						<th>发件人</th>
						<th>主题</th>
						<th>日期</th>
						<th>附件信息</th>
					</tr>
				</thead>
				<tbody>
				 <c:forEach items="${inboxMailList.content}" var="inboxMail">
				    <c:if test="${inboxMail.status == 3}"> 
			            <tr style="cursor: pointer; font-weight: bold;">
				    </c:if>
				 	<c:if test="${inboxMail.status != 3}"> 
			            <tr style="cursor: pointer;">
				    </c:if>
						<td width="22"><input type="checkbox" value="${inboxMail.id}" name="chklist"/></td>
						<td width="26"><span class="iconfj"></span></td>
						<td>${inboxMail.senderName}</td>
						<td onclick="parent.openNewTab('M'+${inboxMail.id},'${inboxMail.title}','${ctx}/mail/detail/${inboxMail.id}/1');" ><div class="txtflow">${inboxMail.title}</div></td>
						<td>${inboxMail.sendTime}</td>
						<td>${inboxMail.attaInfo}</td>
					</tr>
				 </c:forEach>
				</tbody>
			</table>

		    <div class="pagination">
				<tags:pagination page="${inboxMailList}" paginationSize="10"/>
		    </div>

		</div>
	</div>

<div id="mustSelectModal" class="modal hide fade" style="width: 500px;left: 55%;">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>提示框</h3>
  </div>
  <div class="modal-body stepScroll">
	请选择一条记录!
  </div>
  <div class="modal-footer">
    <button class="btn btn-lv" type="submit" id="mustSelectOk">确定</button>
  </div>
</div>

<div id="confirmDeleteModal" class="modal hide fade" style="width: 500px;left: 55%;">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>提示框</h3>
  </div>
  <div class="modal-body stepScroll">
	系统将彻底删除您选择的邮件，确认要删除吗?
  </div>
  <div class="modal-footer">
    <button class="btn btn-lv" type="submit" id="confirmDeleteOk">确定</button>&nbsp;&nbsp;
    <button class="btn btn-lv" type="submit" id="confirmDeleteCanal">取消</button>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
	//绑定选择记录框确定按钮事件
    $("#mustSelectOk").bind("click",function(){
    	$("#mustSelectModal").modal('hide');
    });
    
	//绑定删除记录框确定按钮事件
    $("#confirmDeleteOk").bind("click",function(){
    	doDel();
    });
    
	//绑定删除记录框取消按钮事件
    $("#confirmDeleteCanal").bind("click",function(){
    	$("#confirmDeleteModal").modal('hide');
    });
	
	//绑定列表checkbox全选事件
    $("#chkall").bind("click",function(){
    	if($("#chkall").prop("checked") == true){
    		$("input[name='chklist']").prop("checked","true");
    	} else {
    		$("input[name='chklist']").removeProp("checked");
    	}
    });
});

function confirmDel()
{
   var itemsArray =  new Array();
   $("input[name='chklist']").each(function(){
	      if($(this).prop("checked")){
	    	  itemsArray.push($(this).val());
	      }
   });
   if(itemsArray.length > 0)
   {
	   $("#confirmDeleteModal").modal('show');
   }
   else
   {
	   $("#mustSelectModal").modal('show');
   }
}

function doDel()
{
   var itemsArray =  new Array();
   $("input[name='chklist']").each(function(){
      if($(this).prop("checked")){
    	  itemsArray.push($(this).val());
      }
   });
   
   var items=itemsArray.join(",");
   $.ajax({
       url:"${ctx}/mail/delete",
       data:{items:items},
       type:'post',
       dataType:'json',
       success:function(result){
    	   if(result.success == "true"){
    		   parent.buildMenuTotal();
    		   window.location.reload();
    	   }
      }
    });
}

function doSearch()
{
	var keywords=$("#inboxKeywords").val();
	keywords=encodeURIComponent(keywords,"UTF-8");
	parent.openNewTab('11','收件柜','${ctx}/mail/inbox?keyword='+encodeURIComponent(keywords,"UTF-8"));
}

</script>

</body>
</html>