select SaleDate
From nashville..NashvilleHousing

select saledateconverted, convert(date,saleDate) as SaleDate
from nashville..NashvilleHousing

alter table Nashville..NashvilleHousing
add SaleDateConverted date;

update nashville..NashvilleHousing
set SaleDateConverted= CONVERT(date,SaleDate)

alter table Nashville..NashvilleHousing
Drop Column SaleDateConverted;

alter table Nashville..NashvilleHousing
set SaleDateConverted = SaleDate

--Populate property address data


select *
from nashville..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL (a.PropertyAddress , b.PropertyAddress)
from nashville..NashvilleHousing a
join nashville..NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from nashville..NashvilleHousing a
join nashville..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual columns (address, city, state)

Select SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)as Address , SUBSTRING(PropertyAddress,
CHARINDEX(',' , PropertyAddress) + 1, LEN(PropertyAddress)) as address
from nashville.dbo.NashvilleHousing

alter table Nashville..NashvilleHousing
add PropertySplitAddress nvarchar(255);

update nashville..NashvilleHousing
set PropertySplitAddress =SUBSTRING( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table Nashville..NashvilleHousing
add PropertySplitCity nvarchar(255);

update nashville..NashvilleHousing
set PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) + 1, LEN(PropertyAddress))

Select *
From nashville..NashvilleHousing

Select owneraddress
From nashville..NashvilleHousing

select
PARSENAME(replace (owneraddress,',','.'),3),
PARSENAME(replace (owneraddress,',','.'),2),
PARSENAME(replace (owneraddress,',','.'),1)
from nashville..NashvilleHousing

alter table Nashville..NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update nashville..NashvilleHousing
set OwnerSplitAddress =PARSENAME(replace (owneraddress,',','.'),3)

alter table Nashville..NashvilleHousing
add OwnerSplitCity nvarchar(255);

update nashville..NashvilleHousing
set OwnerSplitCity = PARSENAME(replace (owneraddress,',','.'),2)

alter table Nashville..NashvilleHousing
add OwnerSplitState nvarchar(255);

update nashville..NashvilleHousing
set OwnerSplitState =  PARSENAME(replace (owneraddress,',','.'),1)


--change Y and N to Yes and No in "sold as Vacant" field

Select Distinct(SoldAsVacant ), Count(SoldAsVacant) as Count 
From nashville..NashvilleHousing
Group by SoldAsVacant
order by 2

Select distinct(SoldAsVacant),
Case When SoldAsVacant = 'Y' then 'YES'
	 When soldAsVacant = 'N' then 'NO'
	 Else soldAsVAcant
	 End
From nashville..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant= Case When SoldAsVacant = 'Y' then 'YES'
	 When soldAsVacant = 'N' then 'NO'
	 Else soldAsVAcant
	 End
from nashville..NashvilleHousing

--Remove Duplicates
 
with RowNumCTE as (
select *, 
 ROW_NUMBER() over(
 Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
 Order by UniqueID) row_num
From nashville..NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE 
Where row_num > 1
--Order by PropertyAddress

with RowNumCTE as (
select *, 
 ROW_NUMBER() over(
 Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
 Order by UniqueID) row_num
From nashville..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE 
Where row_num > 1
Order by PropertyAddress

-- Delete Unused Columns

SElect *
From nashville..NashvilleHousing

Alter Table Nashville..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate