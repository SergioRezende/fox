       

 select * from \tmp\tmprel rt;
 where; 
     str(rt.empresa,3)+str(rt.duplicata,9)  ;
        not in (select tmp.chvdup from tmpdup);
  order by ;
	   empresa,;
       duplicata,;
       dt_emi,;
       nota;
  into table \tmp\duprel
