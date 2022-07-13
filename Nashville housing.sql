SELECT * 
FROM Nashville_housing.nashvillehousing;

-- Populate property address/Fixing Nulls
SELECT *
FROM Nashville_housing.nashvillehousing
WHERE PropertyAddress = ''


SELECT PropertyAddress
FROM Nashville_housing.nashvillehousing 
--
UPDATE Nashville_housing.nashvillehousing  
SET PropertyAddress = NULLIF(PropertyAddress, '')


--------------------------------------------------------------------------------------------------------------------------
-- Creating a self join to get a new column with address to add to the null unique ID's

SELECT 
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelId,
    b.PropertyAddress,
    IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM
    Nashville_housing.nashvillehousing  a
        JOIN
    Nashville_housing.nashvillehousing b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID
WHERE
    a.PropertyAddress IS NULL

-- Updating the table with those new address'
UPDATE Nashville_housing.nashvillehousing a
JOIN Nashville_housing.nashvillehousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress,b.PropertyAddress)
WHERE a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------
-- Breaking out addresses into individual columns (Address, City, State)
SELECT PropertyAddress
FROM Nashville_housing.nashvillehousing

SELECT SUBSTRING_INDEX(PropertyAddress,',',1) AS Address,
SUBSTRING_INDEX(PropertyAddress,',',-1) AS Address
FROM Nashville_housing.nashvillehousing

ALTER TABLE Nashville_housing.nashvillehousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Nashville_housing.nashvillehousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress,',',1)

ALTER TABLE Nashville_housing.nashvillehousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE Nashville_housing.nashvillehousing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress,',',-1) 


-- Splitting Owner Address
SELECT *
FROM Nashville_housing.nashvillehousing

SELECT SUBSTRING_INDEX(OwnerAddress,',',1) AS Address,
SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress,',',2)),',',-1) AS ADDRESS2,
SUBSTRING_INDEX(OwnerAddress,',',-1) AS Address
FROM Nashville_housing.nashvillehousing

ALTER TABLE Nashville_housing.nashvillehousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE Nashville_housing.nashvillehousing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress,',',1) 

ALTER TABLE Nashville_housing.nashvillehousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Nashville_housing.nashvillehousing
SET OwnerSplitCity = SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress,',',2)),',',-1)

ALTER TABLE Nashville_housing.nashvillehousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE Nashville_housing.nashvillehousing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress,',',-1)


--------------------------------------------------------------------------------------------------------------------------

-- Changing Y and N to Yes and No in Sold as Vacant column

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM Nashville_housing.nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No' 
    ELSE SoldAsVacant 
END 
FROM Nashville_housing.nashvillehousing;

UPDATE Nashville_housing.nashvillehousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No' 
    ELSE SoldAsVacant 
END ;

--------------------------------------------------------------------------------------------------------------------------
-- Searching for Duplicates on UniqueID
SELECT UniqueID,COUNT(UniqueID)
FROM Nashville_housing.nashvillehousing
group by UniqueID
Having count(*)>1;


--------------------------------------------------------------------------------------------------------------------------
-- Deleting unused Columns
SELECT *
FROM Nashville_housing.nashvillehousing

ALTER Table Nashville_housing.nashvillehousing
DROP COLUMN PropertyAddress

ALTER Table Nashville_housing.nashvillehousing
DROP COLUMN OwnerAddress

ALTER Table Nashville_housing.nashvillehousing
DROP COLUMN TaxDistrict


