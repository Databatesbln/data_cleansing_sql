USE MyDatabase
--View Data
SELECT * FROM NashvilleHousing

--Standardize Date Format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM NashvilleHousing

--ADD And Populate New Date Column 
Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
---------------------------------------------------------------------------

--Populate Property Address Data Where NULL with Property Address of same ParcelID

SELECT * FROM NashvilleHousing
--Where PropertyAddress is null
order by ParcelID ASC;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
Join NashvilleHousing b
on a. ParcelID = b. ParcelID
AND a.[UniqueID ] <> b. [UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
Join NashvilleHousing b
on a. ParcelID = b. ParcelID
AND a.[UniqueID ] <> b. [UniqueID ]
WHERE a.PropertyAddress is NULL

---------------------------------------------------
--Breaking PropertyAddress into Individual Columns (Street, City) using SUBSTRING & CHARINDEX
SELECT PropertyAddress
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM NashvilleHousing

USE MyDatabase
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

USE MyDatabase
SELECT * FROM NashvilleHousing

--SPLIT OwnerAddress into Street, City, State using PARSENAME
SELECT OwnerAddress FROM NashvilleHousing

SELECT PARSENAME(REPLACE (OwnerAddress,',', '.'),3) 
,PARSENAME(REPLACE (OwnerAddress,',', '.'),2) 
,PARSENAME(REPLACE (OwnerAddress,',', '.'),1) 
FROM NashvilleHousing

--ADD & Populate NEW COLUMNS 'OwnerStreet', 'OwnerCity', 'OwnerState'

ALTER TABLE NashvilleHousing
ADD OwnerStreet Nvarchar(255);

Update NashvilleHousing
SET OwnerStreet = PARSENAME(REPLACE (OwnerAddress,',', '.'),3) FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE (OwnerAddress,',', '.'),2) FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE (OwnerAddress,',', '.'),1) FROM NashvilleHousing
--------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" Column

--View Distinct Values and their counts

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant) AS 'Occurences' FROM NashvilleHousing GROUP BY SoldAsVacant ORDER BY 'Occurences' DESC

--Use case statement to change values to most frequent version
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant END
From NashvilleHousing

--Update SoldAsVacant Column with new values
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant END
----------------------------------------------------------

--Remove Duplicates with ROW_NUMBER, CTE, Partition By on ParcelID, Prop.Address, SalesPrice, SaleDate, LegalRef

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num

FROM NashvilleHousing) 
DELETE 
FROM RowNumCTE
WHERE row_num >1
----------------------------------------------------------------------
--DELETE UNUSED COLUMNS

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate
-------------------------------------------------------------------------
--Create New Column called AvgSalePriceTaxDistrict using a Subquery
USE MyDatabase
ALTER TABLE NashvilleHousing
ADD AvgSalePriceTaxDistrict NVARCHAR(255);

UPDATE NashvilleHousing
SET  AvgSalePriceTaxDistrict = CONVERT(NVARCHAR(255), 
     (SELECT AVG(NH2.SalePrice)
      FROM NashvilleHousing NH2
      WHERE NH2.TaxDistrict = NH.TaxDistrict))
FROM NashvilleHousing NH;

