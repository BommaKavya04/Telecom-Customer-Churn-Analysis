use data_analyst_projects;
#load the table using data import wizard and create table 
create table cust_churn
(Customer_ID varchar(255),
Gender varchar(255),
Age int,
Married varchar(255),
Number_of_Dependents int,
City varchar(255),
Zip_Code varchar(255),
Latitude decimal(9,7),
Longitude decimal(9,7),	
Number_of_Referrals int,
Tenure_in_Months int,
Offer varchar(255),
Phone_Service varchar(255),
Avg_Monthly_Long_Distance_Charges float,	
Multiple_Lines varchar(255),
Internet_Service varchar(255),
Internet_Type varchar(255),
Avg_Monthly_GB_Download int,
Online_Security varchar(255),
Online_Backup varchar(255),
Device_Protection_Plan varchar(255),
Premium_Tech_Support varchar(255),
Streaming_TV varchar(255),
Streaming_Movies varchar(255),
Streaming_Music	varchar(255),
Unlimited_Data varchar(255),
Contract varchar(255),
Paperless_Billing varchar(255),
Payment_Method varchar(255),
Monthly_Charge decimal(5,2),
Total_Charges decimal(6,2),
Total_Refunds decimal(4,2),
Total_Extra_Data_Charges int,
Total_Long_Distance_Charges	decimal(6,2),
Total_Revenue decimal(7,2),
Customer_Status	varchar(255),
Churn_Category	varchar(255),
Churn_Reason varchar(255)
)
#to check the table
select * from cust_churn;

#load data into file 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer_churn.csv'
INTO TABLE cust_churn
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 2 ROWS;

#we are using this so it can take big values and negatives also
alter table cust_churn
modify Longitude decimal(10,7);

select * from cust_churn;

#to check data type
desc cust_churn;

#to check rows inserted
select count(*) from cust_churn;

#we can see blanks/nulls under multiple lines,internet type,online security,online backup,
#device protection plan,premium set up,streaming tv, streaming music,streaming movies, unlimited data,

#to check missing or null values for the columns and multiple lines has 9.6% and internet 
#has 21.6% null values from csv file 

select
sum(case when Multiple_Lines is null then 1 else 0 end ) as Multiple_Lines_Null_Count,
sum(case when TRIM(Multiple_Lines) = '' then  1 else 0 end ) as Multiple_Lines_Blank_Count,
sum(case when Internet_Type is null then 1 else 0 end ) as Internet_Type_Null_Count,
sum(case when TRIM(Internet_type) = '' then  1 else 0 end ) as Internet_Type_Blank_Count
from cust_churn;

#set the safe mode 0 to update table 
SET SQL_SAFE_UPDATES = 0;


#impute with unknown as mode is meaningfull if missing % is less than 5%
update cust_churn
set Multiple_Lines = 'Unknown'
where Multiple_Lines = '' or Multiple_Lines is null;

update cust_churn
set Internet_Type = 'Unknown'
where Internet_Type = '' or Internet_Type is null;

#we can see blanks/nulls under online security,online backup,device protection plan,premium set up,
#streaming tv, streaming music,streaming movies, unlimited data,

select
sum(case when Online_Security is null then 1 else 0 end ) as OS_Null_Count,
sum(case when TRIM(Online_Security) = '' then  1 else 0 end ) as OS_Blank_Count,
sum(case when Online_Backup is null then 1 else 0 end ) as OB_Null_Count,
sum(case when TRIM(Online_Backup) = '' then  1 else 0 end ) as OB_Blank_Count,
sum(case when Device_Protection_Plan is null then 1 else 0 end ) as DP_Null_Count,
sum(case when TRIM(Device_Protection_Plan) = '' then  1 else 0 end ) as DP_Blank_Count,
sum(case when Premium_Tech_Support is null then 1 else 0 end ) as PS_Null_Count,
sum(case when TRIM(Premium_Tech_Support) = '' then  1 else 0 end ) as PS_Blank_Count,
sum(case when Streaming_TV is null then 1 else 0 end ) as ST_Null_Count,
sum(case when TRIM(Streaming_TV) = '' then  1 else 0 end ) as ST_Blank_Count,
sum(case when Streaming_Music is null then 1 else 0 end ) as SM_Null_Count,
sum(case when TRIM(Streaming_Music) = '' then  1 else 0 end ) as SM_Blank_Count,
sum(case when Streaming_Movies is null then 1 else 0 end ) as SMovies_Null_Count,
sum(case when TRIM(Streaming_Movies) = '' then  1 else 0 end ) as SMovies_Blank_Count,
sum(case when Unlimited_Data is null then 1 else 0 end ) as UD_Null_Count,
sum(case when TRIM(Unlimited_Data) = '' then  1 else 0 end ) as UD_Blank_Count
from cust_churn;

# to update two columns in the table at once we use case when statement
update cust_churn
set 
Online_Security = case
when Online_Security = '' or Online_Security is null then 'Unknown'
else Online_Security
end,
Online_Backup = case
when Online_Backup ='' or Online_Backup is null then 'Unknown'
else Online_Backup
end;

#similarly set to others also as unknown
update cust_churn
set
Device_Protection_Plan = case
when Device_Protection_Plan = '' or Device_Protection_Plan is null then 'Unknown'
else Device_Protection_Plan
end,
Premium_Tech_Support = case
when Premium_Tech_Support = '' or Premium_Tech_Support is null then 'Unknown'
else Premium_Tech_Support
end,
Streaming_TV = case
when Streaming_TV = '' or Streaming_TV is null then 'Unknown'
else Streaming_TV
end,
Streaming_Movies = case
when Streaming_Movies = '' or Streaming_Movies is null then 'Unknown'
else Streaming_Movies
end,
Streaming_Music = case
when Streaming_Music ='' or Streaming_Music is null then 'Unknown'
else Streaming_Music
end,
Unlimited_Data = case
when Unlimited_Data = '' or Unlimited_Data is null then 'Unknown'
else Unlimited_Data
end;

#see the null and replace with unknown for churn catergory and churn reason
select 
sum(case when Churn_Category is null then 1 else 0 end) as Null_Count,
sum(case when Churn_Category ='' then 1 else 0 end) as Blank_Count
from cust_churn;

#replace with unknow
update cust_churn
set Churn_Category = 'Unknown'
where Churn_Category = '' or Churn_Category is null;


SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Churn_Reason IS NULL THEN 1 ELSE 0 END) AS Null_Count,
    SUM(CASE WHEN TRIM(Churn_Reason) = '' THEN 1 ELSE 0 END) AS Blank_Or_Whitespace_Count
FROM cust_churn;

UPDATE cust_churn
SET Churn_Reason = 'No Churn'
WHERE Churn_Reason IS NULL OR TRIM(Churn_Reason) = '';

#Now all nulls and missing values are treated

#now we can see the category type under Churn_Category column
select Churn_Category, count(*) 
from cust_churn
group by Churn_Category;

#to see top churn reason based on churned status 
SELECT Churn_Reason, COUNT(*) FROM cust_churn 
WHERE Customer_Status = 'Churned' 
GROUP BY Churn_Reason 
ORDER BY COUNT(*) DESC;

#to see the groups of churn status
select Customer_Status, count(*) 
from cust_churn
group by Customer_Status
order by count(*) desc;

#to see by age customer status by Stayed status
select Age, count(*)
from cust_churn
where Customer_Status = 'Stayed'
group by Age
order by age,count(*) desc;

#to see churned status by gender 
select Gender, count(*)
from cust_churn
where Customer_Status = 'Churned'
group by Gender
order by count(*) desc;

#now we are loading our cleaned data 
SELECT *
FROM cust_churn
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_churn_cleaned.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';









