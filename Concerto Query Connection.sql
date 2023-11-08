
-- The connection that retrieves the desired results

Select Pro.ProjectID, Pro.ProjectName 'Project Name', 
CONCAT([Buffer Consumption], '%') as 'Buffer Consumption', 
Pro.PROJECTED_COMPLETION 'Projected Date', ISNULL(DD.MaxDueDate, PT.DueDate) as ActualDueDate,
PROJECTED_START_DATE 'Planned Start'
From Project Pro 
LEFT JOIN (Select ProjectID, MAX(FINISHDATE) as 'DueDate', MIN(FINISHDATE) as 'MinDueDate'
			From PROJ_TASK
			Group By PROJECTID) PT
ON Pro.PROJECTID = PT.PROJECTID
LEFT JOIN (Select ProjectID, Max(Due_Date) as 'MaxDueDate', MIN(BM_TIMESTAMP) as 'Timestamp'
			From TBL_PROJECT_DELAY_HISTORY
			Group By PROJECTID) DD
ON Pro.PROJECTID = DD.PROJECTID
LEFT JOIN (Select ProjectID, MAX(PERCENTPENWREALIGNED) as 'Buffer Consumption'
			From S2M_BUFFER
			Group By PROJECTID) S2MTAB
ON Pro.PROJECTID = S2MTAB.PROJECTID
LEFT JOIN (Select ProjectID, MAX(DateVAL) as 'TheActualDate' 
			From PROJECT_UPDATE_HISTORY
			Where DATEVAL IS NOT NULL
			GROUP BY PROJECTID) PUH
ON Pro.PROJECTID = PUH.PROJECTID
Where CATEGORY = 'Drawings'