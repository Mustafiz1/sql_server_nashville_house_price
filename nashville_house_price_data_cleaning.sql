select *
from Portfolio.dbo.nashville_housing 

-- Cleaning data with query

-- standarize date format 

select SaleDate, 
		convert(Date, SaleDate)
from Portfolio.dbo.nashville_housing

update Portfolio.dbo.nashville_housing 
set SaleDate = convert(Date, SaleDate)

alter table Portfolio.dbo.nashville_housing 
add SaleDateConverted Date;

update Portfolio.dbo.nashville_housing 
set SaleDateConverted = convert(Date, SaleDate)

select *
from Portfolio.dbo.nashville_housing

-- property address data	

select ParcelID, propertyaddress
from Portfolio.dbo.nashville_housing
-- where propertyaddress is null
order by ParcelID;

select a.ParcelID, 
		a.propertyaddress, 
		c.ParcelID, 
		c.propertyaddress,
		isnull(a.propertyaddress, c.propertyaddress)
from Portfolio.dbo.nashville_housing a
join Portfolio.dbo.nashville_housing c
		on a.ParcelID = c.ParcelID
		and a.UniqueID <> c.UniqueID
where a.propertyaddress is null;


update a
set propertyaddress = isnull(a.propertyaddress, c.propertyaddress)
from Portfolio.dbo.nashville_housing a
join Portfolio.dbo.nashville_housing c
		on a.ParcelID = c.ParcelID
		and a.UniqueID <> c.UniqueID
where a.propertyaddress is null;

select * 
from Portfolio.dbo.nashville_housing
where propertyaddress is null

-- diving address into individual columns (Address, City, State)

select propertyaddress
from Portfolio.dbo.nashville_housing
-- where PropertyAddress is null


select 
	SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress) -1) as address,
	SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1, len(propertyaddress)) as address
from Portfolio.dbo.nashville_housing



alter table Portfolio.dbo.nashville_housing 
add Propertysplitaddress Nvarchar(255);


update Portfolio.dbo.nashville_housing 
set Propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress) -1)

alter table Portfolio.dbo.nashville_housing 
add propertysplitcity Nvarchar(255);

update Portfolio.dbo.nashville_housing 
set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1, len(propertyaddress))

select *
from Portfolio.dbo.nashville_housing


select owneraddress
from Portfolio.dbo.nashville_housing;

-- REPLACE ( string_expression , string_pattern , string_replacement ) 
-- PARSENAME ('object_name' , object_piece )

select 
PARSENAME(replace(owneraddress, ',', '.'), 3),
PARSENAME(replace(owneraddress, ',', '.'), 2),
PARSENAME(replace(owneraddress, ',', '.'), 1) 
from Portfolio.dbo.nashville_housing



alter table Portfolio.dbo.nashville_housing 
add owner_split_street Nvarchar(255);


update Portfolio.dbo.nashville_housing 
set owner_split_street = PARSENAME(replace(owneraddress, ',', '.'), 3)

alter table Portfolio.dbo.nashville_housing 
add owner_split_city Nvarchar(255);

update Portfolio.dbo.nashville_housing 
set owner_split_city =  PARSENAME(replace(owneraddress, ',', '.'), 2)

alter table Portfolio.dbo.nashville_housing 
add owner_split_state Nvarchar(255);

update Portfolio.dbo.nashville_housing 
set owner_split_state =  PARSENAME(replace(owneraddress, ',', '.'), 1)


select *
from Portfolio.dbo.nashville_housing


-- Change Y/N to Yes/No in SoldVsVacant field

select distinct (SoldAsVacant), count(SoldAsVacant)
from Portfolio.dbo.nashville_housing
group by SoldAsVacant
order by 2


select SoldAsVacant,
		case when SoldAsVacant = 'Y' then 'Yes'
			 when SoldAsVacant = 'N' then 'No'
			 else SoldAsVacant
		end 
from Portfolio.dbo.nashville_housing



update Portfolio.dbo.nashville_housing 
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
					end 


select distinct (SoldAsVacant), count(SoldAsVacant)
from Portfolio.dbo.nashville_housing
group by SoldAsVacant
order by 2


-- Remove duplicates

with cte1 as (
	select *,
			ROW_NUMBER() over(partition By parcelid,
										 propertyaddress,
										 saleprice,
										 legalreference
										 order By uniqueid) rn
	from Portfolio.dbo.nashville_housing
	--order by ParcelID
	)

select * 
from cte1
where rn > 1
-- order by propertyaddress;

-- delete them
select *
from Portfolio.dbo.nashville_housing
 

with cte1 as (
	select *,
			ROW_NUMBER() over(partition By parcelid,
										 propertyaddress,
										 saleprice,
										 legalreference
										 order By uniqueid) rn
	from Portfolio.dbo.nashville_housing
	--order by ParcelID
	)

delete 
from cte1
where rn > 1
-- order by propertyaddress;


-- check!!

with cte1 as (
	select *,
			ROW_NUMBER() over(partition By parcelid,
										 propertyaddress,
										 saleprice,
										 legalreference
										 order By uniqueid) rn
	from Portfolio.dbo.nashville_housing
	--order by ParcelID
	)

select * 
from cte1
where rn > 1
order by propertyaddress;




-- Delete unused columns 

select * 
from Portfolio.dbo.nashville_housing


alter table  Portfolio.dbo.nashville_housing
drop column owneraddress, taxdistrict, propertyaddress


alter table  Portfolio.dbo.nashville_housing
drop column saledate

select * 
from Portfolio.dbo.nashville_housing

