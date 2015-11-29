   select * from SEEvalSession es
     join SEEvaluation e on es.EvaluateeUserID=e.EvaluateeID
     where es.IsFocused=1
       and es.FocusedFrameworkNodeID is null
       and e.SchoolYear=2014
       and e.FocusedFrameworkNodeID is not NULL
           AND e.DistrictCode=es.DistrictCode
       AND e.EvaluationTypeID=es.EvaluationTYpeID
       
              UPDATE s
         SET s.FocusedFrameworkNodeID=e.FocusedFrameworkNodeID
            ,s.FocusedSGFrameworkNodeID=e.FocusedSGFrameworkNodeID
        FROM dbo.SEEvalSession s
      join SEEvaluation e on s.EvaluateeUserID=e.EvaluateeID
     where s.IsFocused=1
       and s.FocusedFrameworkNodeID is null
       and e.SchoolYear=2014
       AND e.DistrictCode=s.DistrictCode
       AND e.EvaluationTypeID=s.EvaluationTYpeID
       and e.FocusedFrameworkNodeID is not NULL