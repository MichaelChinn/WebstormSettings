select * from InPrinRR
update InPrinRR set
pld1=
'Principal does not display initiative and persistence by:
-- Rarely or never achieving expected goals;
--Rarely or never taking on additional, voluntary responsibilities that contribute to school success;
-- Rarely or never taking risks to support students in achieving results;
-- Never seeking out potential partnerships.'

,pld2=
'Principal displays initiative and persistence by: 
-- Achieving most, but not all expected goals;
-- Occasionally taking on additional, voluntary responsibilities that contribute to school success; 
-- Occasionally taking risks to support students in achieving results by attempting to remove the school''s most significant obstacles to student achievement;
-- Infrequently seeking out potential partnerships with groups and organizations with the intent of increasing student achievement.'

,pld3=
'Principal displays initiative and persistence by: 
-- Consistently achieving expected goals;
-- Taking on voluntary responsibilities that contribute to school success; 
-- Taking risks to support students in achieving results by identifying and frequently attempting to remove the school''s most significant obstacles to student achievement;
-- Seeking out potential partnerships with groups and organizations with the intent of increasing student achievement. '
,PLD4=
'At Level 4, a principal fulfills the criteria for Level 3 and additionally:
-- Exceeding typical expectations to accomplish ambitious goals;
-- Regularly identifying, communicating, and addressing the school''s most significant obstacles to student achievement; 
-- Engaging with key stakeholders at the district and state level, and within the local community to create solutions to the school''s most significant obstacles to student achievement.  '

where RRNo='2.1.4'

update InPrinRR set
pld1=
'Principal does not create an organizational culture of urgency by: 
-- Failing to align efforts of students and teachers to a shared understanding of academic and behavior expectations;
-- Failing to identify the efforts of students and teachers, thus unable to align these efforts.'
,pld2=
'Principal creates an organizational culture of urgency by:  
-- Aligning major efforts of students and teachers to the shared understanding or academic and behavioral expectations while failing to include other stakeholders;
-- Occasionally leading a pursuit of these expectations. '
,pld3=
'Principal creates an organizational culture of urgency by: 
-- Aligning the efforts of students, parents, teachers, and other stakeholders to a shared understanding of academic and behavioral expectations.
--Leading a relentless pursuit of these expectations.'
,pld4=
'At Level 4, a principal fulfills the criteria for Level 3 and additionally: 
-- Ensuring the culture of urgency is sustainable by celebrating progress while maintaining a focus on continued improvement.'
where rrno = '2.2.1'

select * from InPrinRR
where RRNo = '2.2.1'
