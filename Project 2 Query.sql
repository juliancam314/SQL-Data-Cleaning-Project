/*

Cleaning Data in SQL Queries

*/


Select *
From [Project 2].dbo.HousingData


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Project 2].dbo.HousingData
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Project 2].dbo.HousingData a
JOIN [Project 2].dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Project 2].dbo.HousingData a
JOIN [Project 2].dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Project 2].dbo.HousingData
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Project 2].dbo.HousingData


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE HousingData
Add PropertySplitCity Nvarchar(255);

Update HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [Project 2].dbo.HousingData

Select OwnerAddress
From [Project 2].dbo.HousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Project 2].dbo.HousingData



ALTER TABLE HousingData
Add OwnerSplitAddress Nvarchar(255);

Update HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE HousingData
Add OwnerSplitCity Nvarchar(255);

Update HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE HousingData
Add OwnerSplitState Nvarchar(255);

Update HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From [Project 2].dbo.HousingData

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Project 2].dbo.HousingData
Group by SoldAsVacant
order by 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 1 THEN 'Yes'
	 WHEN SoldAsVacant = 0 THEN 'No'
	 ELSE SoldAsVacant
END
FROM [Project 2].dbo.HousingData

ALTER TABLE HousingData
ALTER COLUMN SoldAsVacant VARCHAR(255)

Update HousingData
SET SoldAsVacant = CASE When SoldAsVacant = 1 THEN 'Yes'
	   When SoldAsVacant = 0 THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) row_num
From [Project 2].dbo.HousingData
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

ALTER TABLE HousingData
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

ALTER TABLE HousingData
DROP COLUMN SaleDate

SELECT *
FROM [Project 2].dbo.HousingData