# Data Cleansing in SQL 

The goal of this project was to clean and transform the Nashville housing market data to make it more consumable for analysis. The original dataset, provided as an Excel file, can be found in this repository("Nashville Housing Data for Data Cleaning.xlsx). For the purposes of this project, the data was migrated into an SQL table to facilitate manipulation using SQL queries and functions. The script implementing the following details is "NashvilleHousingExcercise.sql".

# Standardize Date Format
The first step in the data transformation process was standardizing the date format. This involved converting the SaleDate column in the NashvilleHousing table to a standard date format. The original date format was inconsistent, requiring the use of the CONVERT function to standardize all entries to a DATE type.

# Manage Null Values in PropertyAddress
Additionally, to manage null entries in the PropertyAddress field, a self-join was utilized. This technique identified rows with the same ParcelID but different UniqueIDs, allowing the substitution of null addresses with corresponding non-null entries from the same parcel.

# Breaking PropertyAddress into Indivdual Columns
The project also entailed breaking down the PropertyAddress into individual components such as street and city. This was achieved by employing the SUBSTRING and CHARINDEX functions to extract parts of the address string.

# Breaking OwnerAddress into Individual Columns
Another transformation applied to the dataset was parsing the OwnerAddress into separate columns for street, city, and state using the PARSENAME function. This function, typically used for SQL object naming, was creatively repurposed to handle comma-separated address data.

# Standardize Values of "Sold as Vacant" Column
The "Sold as Vacant" column values were standardized from 'Y' and 'N' to 'Yes' and 'No' using a CASE statement. This change not only made the data more readable but also ensured consistency across the dataset.

# Handle Duplicate Records
To address duplicate records, a Common Table Expression (CTE) with the ROW_NUMBER function was used. This approach assigned a unique row number to each record partitioned by ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference. Records with a row number greater than one were then deleted, effectively removing duplicates.

# Remove Unused Columns, add Avg. Sales Price per Tax District
Unused columns such as PropertyAddress, OwnerAddress, and SaleDate were dropped to streamline the table structure. Furthermore, a new column called AvgSalePriceTaxDistrict was added. This column was populated using a subquery that calculated the average sale price within each tax district.






