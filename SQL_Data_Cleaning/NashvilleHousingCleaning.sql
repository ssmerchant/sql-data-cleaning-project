--Select Data

Select * From [Nashville Housing Data].[dbo].[Nashville_housing_data]

-- Standardize Date

Alter Table [Nashville_housing_data]
Add SaleDate Date;

Update [Nashville_housing_data]
SET SaleDate = CONVERT(Date, [Sale Date])

Select [SaleDate]
From [Nashville Housing Data].[dbo].[Nashville_housing_data]

----------------------------------------------------------------------------------------

-- Property Address Cleaning
-- Populating null values with data found from other values with the same Parcel ID

Select *
From [Nashville Housing Data].[dbo].[Nashville_housing_data]
order by [Parcel ID]

Select a.[Parcel ID], a.[Property Address], b.[Parcel ID], b.[Property Address], ISNULL(a.[Property Address], b.[Property Address])
From [Nashville Housing Data].[dbo].[Nashville_housing_data] a
JOIN [Nashville Housing Data].[dbo].[Nashville_housing_data] b
	on a.[Parcel ID] = b.[Parcel ID]
	AND a.[F1] <> b.[F1]
where a.[Property Address] is null

Update a
Set [Property Address] = ISNULL(a.[Property Address], b.[Property Address])
From [Nashville Housing Data].[dbo].[Nashville_housing_data] a
JOIN [Nashville Housing Data].[dbo].[Nashville_housing_data] b
	on a.[Parcel ID] = b.[Parcel ID]
	AND a.[F1] <> b.[F1]
where a.[Property Address] is null

--Removing any remaining null values with no address recorded

Delete from [Nashville Housing Data].[dbo].[Nashville_housing_data]
where [Property Address] is null;

----------------------------------------------------------------------------------------

--Removing Duplicate Data

with RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	Partition by [Parcel ID],
				 [Property Address],
				 [Sale Price],
				 [Sale Date],
				 [Legal Reference]
				 Order by
					F1
					) row_num

From [Nashville Housing Data].[dbo].[Nashville_housing_data]
)
Delete
From RowNumCTE
Where row_num > 1

--Selecting data to check for duplicates

with RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	Partition by [Parcel ID],
				 [Property Address],
				 [Sale Price],
				 [Sale Date],
				 [Legal Reference]
				 Order by
					F1
					) row_num

From [Nashville Housing Data].[dbo].[Nashville_housing_data]
)
Select *
From RowNumCTE
Where row_num > 1
Order by [Property Address]

----------------------------------------------------------------------------------------

--Deleting unused columns

Select *
From [Nashville Housing Data].[dbo].[Nashville_housing_data]

Alter table [Nashville Housing Data].[dbo].[Nashville_housing_data]
drop column [Unnamed: 0], [Sale Date], [Tax District]