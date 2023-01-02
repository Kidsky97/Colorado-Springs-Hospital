--DataSet Verification

use [HCI320 Project]

select * from er_charges
order by Account ASC

select * from billing_status
order by Account ASC

--Join the Two Tables
Select distinct e.Account, b.CodingStatus, Charges, DateOfService as DOS, VisitStatus
from er_charges e
Join billing_status b
on e.Account = b.Account
order by DOS

-- Narrow the results down to the requested timeline (2018-06-01 to 2019-05-31) and see how many records aren't complete. (Coding Complete doesn't mean done). 

Select distinct e.Account, b.CodingStatus, Charges, DateOfService as DOS, VisitStatus
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'
order by DOS ASC

--Sum it all up from June 2018 to May 2019 By Category
ALTER TABLE er_charges
Alter column Charges float

Select distinct CodingStatus, sum(Charges) Charge
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'
Group by CodingStatus

--Total Unbilled Expenses from June 2018 to May 2019

Select sum(Charges) Charges
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'

--Unbilled Expenses for Quarter 3 (June 01 2018 to Aug 31 2018)
Select sum(Charges) Unbilled_Expenses_Jun18_to_Aug18
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2018-08-31' and CodingStatus <> 'Completed'

--Sept 01 2018- Nov 31 2018
Select sum(Charges) Unbilled_Expenses_Sept18_to_Nov18
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-09-01' and '2018-11-30' and CodingStatus <> 'Completed'

--Dec 01 2018 - Feb 28 2019
Select sum(Charges) Unbilled_Expenses_Dec18_to_Feb_19
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-12-01' and '2019-02-28' and CodingStatus <> 'Completed'

--March 01 2019 - May 31 2019
Select sum(Charges) Unbilled_Expenses_Mar19_to_May19
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2019-03-01' and '2019-05-31' and CodingStatus <> 'Completed'

--Total Unbilled Expenses from June 01 2018 to May 31 2019
Select sum(Charges) Unbilled_Expenses_Jun18_to_May19
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'

--2018 Quarter 3 divided by the entire year.
Select(sum(Charges/1300150.64))*100 as Third_Quarter_Percentage
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2018-08-31' and CodingStatus <> 'Completed'

--Creating Temp Table

Drop Table if exists Unbilled_Expenses_June18_to_May19
Create table Unbilled_Expenses_June18_to_May19
(Account Nvarchar(255), 
CodingStatus Nvarchar(255), 
Charges float, 
DateOfService DateTime, 
VisitStatus Nvarchar(255))

Insert into Unbilled_Expenses_June18_to_May19

Select distinct e.Account, b.CodingStatus, Charges, DateOfService as DOS, VisitStatus
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'
order by DateOfService ASC

Select * from Unbilled_Expenses_June18_to_May19

--Create Views
Create View Unbilled_by_Category as
Select distinct CodingStatus, sum(Charges) Charge
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'
Group by CodingStatus

--View for Unbilled Expenses for the Year
Create view Annual_Unbilled_Expenses_Amount as
Select sum(Charges) Charges
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2019-05-31' and CodingStatus <> 'Completed' and Charges <> '0.00'

--View for Unbilled Expenses for Quarter 3 (June 01 2018 to Aug 31 2018)
Create View Unbilled_Jun18_to_Aug18 as
Select sum(Charges) Unbilled_Expenses_Jun18_to_Aug18
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2018-08-31' and CodingStatus <> 'Completed'

--View Sept 01 2018- Nov 31 2018
create view Unbilled_Sept18_to_Nov18 as
Select sum(Charges) Unbilled_Expenses_Sept18_to_Nov18
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-09-01' and '2018-11-30' and CodingStatus <> 'Completed'

--Dec 01 2018 - Feb 28 2019
Create View Unbilled_Dec18_to_Feb19 as
Select sum(Charges) Unbilled_Expenses_Dec18_to_Feb_19
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-12-01' and '2019-02-28' and CodingStatus <> 'Completed'

--March 01 2019 - May 31 2019
Create View Unbilled_Mar19_to_May19 as
Select sum(Charges) Unbilled_Expenses_Mar19_to_May19
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2019-03-01' and '2019-05-31' and CodingStatus <> 'Completed'


--2018 Quarter 3 divided by the entire year.
Create View QTR3_Percentage_Vs_Year as
Select(sum(Charges/1300150.64))*100 as Third_Quarter_Percentage
from er_charges e
Join billing_status b
on e.Account = b.Account
where DateOfService between '2018-06-01' and '2018-08-31' and CodingStatus <> 'Completed'


