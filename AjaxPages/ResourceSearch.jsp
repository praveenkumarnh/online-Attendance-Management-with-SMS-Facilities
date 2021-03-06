 

<%@page import="java.sql.*"  %>
<%@ include file="../common/DBConfig.jsp" %>
<%@ include file="../common/FlashPaperConfig.jsp" %>

 <%!
            public boolean isContains(String arr[],String key){
                if(key.equals(""))
                    return false;
                for(int i=0;i<arr.length-1;i++)
                    if(arr[i].equalsIgnoreCase(key))
                       return true;

                return false;
            }
        %>

<%

    if((session.getAttribute("DB_Name")==null)){
        %>
        <script>
            
            window.location="./";
        </script>
        <%
        return;
    }
     Connection con=DriverManager.getConnection(CONNECTION_URL,USER_NAME,PASSWORD);
     Statement st=con.createStatement();
     String sql="";
     ResultSet rs=null;
     if(request.getParameter("action").equals("showresource")){
         if(request.getParameter("subject").equals("undefined")){
             con.close();
             return;
         }

         String temp[]=request.getParameter("subject").toString().split("-") ;
         sql="select category,title,date_format(`date`,'%b %e,%Y') `date`,`desc`,group_concat(filename) filename,group_concat(folder) folder from resource where subject_id='"+temp[0]+"' and section ='"+temp[1]+"' and folder='"+request.getParameter("year")+"' group by category,title order by category";
         //out.print(sql);
         rs= st.executeQuery(sql);
             %>
             <br>
            
                 <table id="hor-minimalist-b">
                     <thead>
                        <tr>
                            <th>Category</th>
                            <th>Topic</th>                                                       
                            <th>Date</th>
                            
                            <th>Download</th>
                        </tr>
                    </thead>
                 <%
             String subject_id=temp[0];
             String section=temp[1];

             while(rs.next()){
                 String[] folder=rs.getString("folder").split(",");
                 String[] file=rs.getString("filename").split(",");
                 %>
                 <tr>
                     <td><%=rs.getString("category")%></td>
                     <td><%=rs.getString("desc")%></td>                                       
                     <td><%=rs.getString("date")%></td>
                     <td title="<%=rs.getString("title")%>">
                         <ul style="list-style-type:none">
                             <%for(int i=0;i<folder.length;i++){%>
                             <li title="<%=file[i]%>" onclick="window.open('./common/fileDownload.jsp?filename=<%=folder[i]%>/<%=subject_id+"["+section+"]/"+file[i]+"&type=RESOURCE"%>')"  style="background:url('./images/download.png') no-repeat;padding-left:20px;cursor:hand;"><%=rs.getString("title")%></li>
                             <%
                             int mid= file[i].lastIndexOf(".");
                              String ext=file[i].substring(mid+1,file[i].length());
                              
                               if(FLASH_PAPER && isContains(FLASH_PAPER_SUPPORTS,ext)){%>
                             <li onclick="window.open('./common/fileViewer.jsp?filename=<%=folder[i]%>/<%=subject_id+"["+section+"]/"+file[i]+"&type=RESOURCE"%>')" style="background:url('./images/view.png')  no-repeat ;padding-left:20px;cursor:hand"><%=rs.getString("title")%></li>
                             <%}
                              }
                              %>
                         </ul>
                     </td>
                 </tr>
                 <%
             }
             %>
             </table>
             
             
             <%
         con.close();
         return;
     }
 %>
    <div id="top_div">
		<h1>Resources</h1>
		<div align="justify" style="border-bottom:1px dotted #D3D4D5; padding-bottom:10px;">
                    
                    Archives:<select id="year" onchange="ResourceSearch()">
                    <option value="select">Please Select</option>
                        <%
                         sql="select distinct folder from resource";
                         rs=st.executeQuery(sql);
                        while(rs.next()){
                        %>
                        <option value="<%=rs.getString(1)%>" <%=(request.getParameter("year").equals(rs.getString(1)))?"selected":""%>><%=rs.getString(1)%></option>
                        <%}
                         out.print("</select>");
                         if(!request.getParameter("subject").equals("undefined")){
                         //String temp[]=request.getParameterValues("subject").toString().split("-");
                         //subject_id='"+temp[0]+"' and section='"+temp[1]+"' and folder='"+request.getParameter("year")+"'"
                         sql="select distinct r.subject_id,r.section,s.subject_name from resource r,subject s where r.subject_id=s.subject_id and r.folder='"+request.getParameter("year")+"' order by r.subject_id,r.section";
                        // out.print(sql);
                         rs=st.executeQuery(sql);
                         %>
                    
                         Subject<select id="subject" onchange="OnchangeResource()">
                             <option value="please Select">Please Select</option>
                        <%while(rs.next()){%>
                        <option value="<%=rs.getString("subject_id")+"-"+rs.getString("section")%>"> <%=rs.getString("subject_id").toUpperCase()+"-"+rs.getString("subject_name").toUpperCase()+" ["+(char)(rs.getInt("section")-1+'A')+"]"%></option>
                        <%}%>
                    </select>
                    <%}
                         else{
                                %>
                                Subject:
                                <select id="subject" disabled>
                                    <option>Please Select ...</option>
                                </select>
                                <%
                             }
                         %>
                          <div id="resource">

                            </div>
		</div>

  </div>
	
	<div style="clear:both"></div>
        <%
        con.close();
        %>