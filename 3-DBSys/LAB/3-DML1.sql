use OOVEO_Salon

select CustomerName, CustomerGender 
from MsCustomer

begin tran
insert into MsStaff
values('SF006','Jeklin','Female','085265433322',
'Kebon Jeruk Street no 140',3000000,'Stylist')
commit rollback

select * from MsStaff

begin tran
update MsStaff
set StaffID = 'SF888'
--from -> join
where StaffId = 'SF006'
commit rollback

select * from MsStaff

begin tran
delete MsStaff
where StaffId = 'SF006'
-- from -> join
commit rollback

print dateadd(second, 2400, getdate())

insert into MsCustomer
values('CU006','Kiki','Male','081280308225','Gunsa Street no 38')

select * from MsCustomer

delete MsCustomer
where CustomerId='CU006'

begin tran
update MsCustomer
set CustomerPhone = replace(CustomerPhone,'08','628')
commit rollback

select * from MsCustomer mc
join HeaderSalonServices hss
on mc.CustomerId = hss.CustomerId
join MsStaff ms
on hss.StaffId = ms.StaffId

begin tran
update MsCustomer
set CustomerAddress = 'Daan Mogot Baru No. 23'
from MsCustomer mc
join HeaderSalonServices hss on mc.CustomerId = hss.CustomerId
join MsStaff ms on hss.StaffId = ms.StaffId
where ms.StaffName = 'Indra Saswita' 
and datename(weekday, hss.TransactionDate) = 'Thursday'
commit rollback

select * from HeaderSalonServices

begin tran
delete HeaderSalonServices
--from MsCustomer mc
--join HeaderSalonServices hss
--on mc.CustomerId = hss.CustomerId
from HeaderSalonServices hss, MsCustomer mc --join kw
where hss.CustomerId = mc.CustomerId
and charindex(' ', mc.CustomerName) = 0
commit rollback

select * from MsCustomer mc,
HeaderSalonServices hss, MsStaff ms
where mc.CustomerId = hss.CustomerId
and hss.StaffId = ms.StaffId

select TreatmentName, Price
from MsTreatment mt join MsTreatmentType mtt
on mt.TreatmentTypeId = mtt.TreatmentTypeId
where mtt.TreatmentTypeName
in('message / spa', 'beauty care')