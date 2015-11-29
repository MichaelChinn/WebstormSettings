declare @foo int

SELECT b.Emp, p.Emp, p.OrgChartId 
  FROM #OrgChart AS P 
       LEFT OUTER JOIN 
       #OrgChart AS B 
       ON B.lft 
          = (SELECT MAX(lft) 
               FROM #OrgChart AS S 
              WHERE P.lft > S.lft 
                AND P.lft < S.rgt)
where b.orgChartId = 7 and p.emp='conant'

drop table #orgChart
create table #orgchart (emp varchar(20), lft int, rgt int, orgChartId int)

insert #orgchart (orgChartId, emp, lft, rgt) values (1 ,'mary', 0, 21    )
insert #orgchart (orgChartId, emp, lft, rgt) values (2 ,'bob',1,8        )
insert #orgchart (orgChartId, emp, lft, rgt) values (3 ,'john',2,3       )
insert #orgchart (orgChartId, emp, lft, rgt) values (4 ,'bill',4,4       )
insert #orgchart (orgChartId, emp, lft, rgt) values (5 ,'frank', 6, 7    )
insert #orgchart (orgChartId, emp, lft, rgt) values (6 ,'joe',9,18       )
insert #orgchart (orgChartId, emp, lft, rgt) values (7 ,'james', 10,17   )
insert #orgchart (orgChartId, emp, lft, rgt) values (8 ,'mike',11,12     )
insert #orgchart (orgChartId, emp, lft, rgt) values (9 ,'brian', 13, 14  )
insert #orgchart (orgChartId, emp, lft, rgt) values (10,'conant' , 15,16 )
insert #orgchart (orgChartId, emp, lft, rgt) values (11,'josh',19,20     )



