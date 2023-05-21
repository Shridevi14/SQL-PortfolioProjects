/*

Cleaning Data in Sql Queries

*/


Select * From NashvilleHousing



--Standarize Date Format

Select SaleDate
From NashvilleHousing

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted=Convert(Date, SaleDate)

Select SaleDateConverted
From NashvilleHousing



--Populate Property Address Data

Select *
From NashvilleHousing
Order By ParcelID

Select  a.ParcelId, a.PropertyAddress,b.ParcelId,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
      on a.ParcelId=b.ParcelId
	  And a.UniqueId <> b.UniqueId
Where a.propertyAddress is Null 

update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From NAshvilleHousing a
JOIN NAshvilleHousing b
     on a.ParcelId=b.ParcelId
	 And a.UniqueId <> b.UniqueId
Where a.propertyAddress is null



--Breaking Out Address into Individual Columns(Address, City, State)

Select PropertyAddress
From NAshvilleHousing

Select
Substring(propertyAddress, 1, CharIndex(',', PropertyAddress) -1) as Address,
Substring(propertyAddress, CharIndex(',', PropertyAddress) +1, Len(propertyAddress)) as Address
From NashvilleHousing

Alter table NashvilleHousing
Add PropertysplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertysplitAddress=Substring(propertyAddress, 1, CharIndex(',', PropertyAddress) -1) 

Alter table NashvilleHousing
Add PropertysplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertysplitCity=Substring(propertyAddress, CharIndex(',', PropertyAddress) +1, Len(propertyAddress))

Select *
From NashvilleHousing



Select OwnerAddress
From NashvilleHousing

Select 
Parsename(Replace(ownerAddress, ',', '.'), 3),
Parsename(Replace(ownerAddress, ',', '.'), 2),
Parsename(Replace(ownerAddress, ',', '.'), 1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select * From NashvilleHousing



--Change Y and N to Yes and No in "Sold as Vaccant" Field

Select Distinct(Soldasvacant), Count(Soldasvacant)
From NashvilleHousing
Group By SoldasVacant
Order By 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



---- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvilleHousing



-- Delete Unused Columns

Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


