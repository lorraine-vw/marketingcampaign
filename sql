
-- renaming the columns so it's easier to reference in the code
alter table marketingcampaign rename column "ID" to id;
alter table marketingcampaign rename column "Year_Birth" to yearbirth;
alter table marketingcampaign rename column "Education" to education;
alter table marketingcampaign rename column "Marital_Status" to maritalstatus;
alter table marketingcampaign rename column "Income" to income;
alter table marketingcampaign rename column "Kidhome" to kidhome;
alter table marketingcampaign rename column "Teenhome" to teenhome;
alter table marketingcampaign rename column "Dt_Customer" to dtcustomer;
alter table marketingcampaign rename column "Recency" to recency;
alter table marketingcampaign rename column "MntWines" to mntwines;
alter table marketingcampaign rename column "MntFruits" to mntfruits;
alter table marketingcampaign rename column "MntMeatProducts" to mntmeatproducts;
alter table marketingcampaign rename column "MntFishProducts" to mntfishproducts;
alter table marketingcampaign rename column "MntSweetProducts" to mntsweetproducts;
alter table marketingcampaign rename column "MntGoldProds" to mntgoldprods;
alter table marketingcampaign rename column "NumDealsPurchases" to numdealspurchases;
alter table marketingcampaign rename column "NumWebPurchases" to numwebpurchases;
alter table marketingcampaign rename column "NumCatalogPurchases" to numcatalogpurchases;
alter table marketingcampaign rename column "NumStorePurchases" to numstorepurchases;
alter table marketingcampaign rename column "NumWebVisitsMonth" to numwebvisitsmonth;
alter table marketingcampaign rename column "AcceptedCmp3" to acceptedcmp3;
alter table marketingcampaign rename column "AcceptedCmp4" to acceptedcmp4;
alter table marketingcampaign rename column "AcceptedCmp5" to acceptedcmp5;
alter table marketingcampaign rename column "AcceptedCmp1" to acceptedcmp1;
alter table marketingcampaign rename column "AcceptedCmp2" to acceptedcmp2;
alter table marketingcampaign rename column "Complain" to complain;
alter table marketingcampaign rename column "Z_CostContact" to zcostcontact;
alter table marketingcampaign rename column "Z_Revenue" to zrevenue;
alter table marketingcampaign rename column "Response" to response;

-- what each column means, taken from the kaggle page
/*
AcceptedCmp1 - 1 if customer accepted the offer in the 1st campaign, 0 otherwise
AcceptedCmp2 - 1 if customer accepted the offer in the 2nd campaign, 0 otherwise
AcceptedCmp3 - 1 if customer accepted the offer in the 3rd campaign, 0 otherwise
AcceptedCmp4 - 1 if customer accepted the offer in the 4th campaign, 0 otherwise
AcceptedCmp5 - 1 if customer accepted the offer in the 5th campaign, 0 otherwise
Response (target) - 1 if customer accepted the offer in the last campaign, 0 otherwise
Complain - 1 if customer complained in the last 2 years
DtCustomer - date of customer’s enrollment with the company
Education - customer’s level of education
Marital - customer’s marital status
Kidhome - number of small children in customer’s household
Teenhome - number of teenagers in customer’s household
Income - customer’s yearly household income
MntFishProducts - amount spent on fish products in the last 2 years
MntMeatProducts - amount spent on meat products in the last 2 years
MntFruits - amount spent on fruits products in the last 2 years
MntSweetProducts - amount spent on sweet products in the last 2 years
MntWines - amount spent on wine products in the last 2 years
MntGoldProds - amount spent on gold products in the last 2 years
NumDealsPurchases - number of purchases made with discount
NumCatalogPurchases - number of purchases made using catalogue
NumStorePurchases - number of purchases made directly in stores
NumWebPurchases - number of purchases made through company’s web site
NumWebVisitsMonth - number of visits to company’s web site in the last month
Recency - number of days since the last purchase
*/


CLEANING

-- a check for how many nulls are in each column
select count(*) - count(id) as id,
       count(*) - count(yearbirth) as yearbirth,
       count(*) - count(education) as education,
       count(*) - count(maritalstatus) as maritalstatus,
       count(*) - count(income) as income,
       count(*) - count(kidhome) as kidhome,
       count(*) - count(teenhome) as teenhome,
       count(*) - count(dtcustomer) as dtcustomer,
       count(*) - count(recency) as recency,
       count(*) - count(mntwines) as mntwines,
       count(*) - count(mntfruits) as mntfruits,
       count(*) - count(mntmeatproducts) as mntmeatproducts,
       count(*) - count(mntfishproducts) as mntfishproducts,
       count(*) - count(mntsweetproducts) as mntsweetproducts,
       count(*) - count(mntgoldprods) as mntgoldprods,
       count(*) - count(numdealspurchases) as numdealspurchases,
       count(*) - count(numwebpurchases) as numwebpurchases,
       count(*) - count(numcatalogpurchases) as numcatalogpurchases,
       count(*) - count(numstorepurchases) as numstorepurchases,
       count(*) - count(numwebvisitsmonth) as numwebvisitsmonth,
       count(*) - count(acceptedcmp1) as acceptedcmp1,
       count(*) - count(acceptedcmp2) as acceptedcmp2,
       count(*) - count(acceptedcmp3) as acceptedcmp3,
       count(*) - count(acceptedcmp4) as acceptedcmp4,
       count(*) - count(acceptedcmp5) as acceptedcmp5,
       count(*) - count(complain) as complain,
       count(*) - count(zcostcontact) as zcostcontact,
       count(*) - count(zrevenue) as zrevenue,
       count(*) - count(response) as response
from marketingcampaign;


-- row count, duplicate ids, missing income, value ranges
select count(*) as total_rows,
       count(distinct id) as distinct_ids,
       min(yearbirth) as oldest_birth_year,
       max(yearbirth) as newest_birth_year,
       min(income) as min_income,
       max(income) as max_income
from marketingcampaign;

-- the 10 highest incomes
select id, income
from marketingcampaign
where income is not null
order by income desc
limit 10;

-- 10 oldest birth years
select id, yearbirth
from marketingcampaign
order by yearbirth
limit 10;

-- response should be only 0 and 1
select response, count(*)
from marketingcampaign
group by response;
 
-- enrollment date range (used to pick the year for the age calculation below)
select min(dtcustomer) as firstenrolled,
       max(dtcustomer) as lastenrolled
from marketingcampaign;

-- cleaning decisions
-- missing income: 24 customers (1.1%). assumed not reported, since nobody has an income of 0, excluded from the income analysis only.
-- income outlier: one customer at 666,666 (next highest is 162,397), excluded from the income analysis only.
-- impossible birth years: 3 customers born in 1893, 1899 and 1900. they would be over a hundred years old. excluded from the age analysis only.
-- age is approximated using 2014 as a base number. confirmed with lastenrolled above.


ANALYSIS

-- response rate for last campaign
select count(*) as customers, sum(response) as accepted, round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign;
-- we will use 14.9% as a base to compare. the analysis would want the most recent campaign because its the best guide to current response. other campaigns will be used for contexts and consistency checks.

-- response rate by campaign
select round(100.0 * sum(acceptedcmp1) / count(*), 1) as cmp1_pct,
       round(100.0 * sum(acceptedcmp2) / count(*), 1) as cmp2_pct,
       round(100.0 * sum(acceptedcmp3) / count(*), 1) as cmp3_pct,
       round(100.0 * sum(acceptedcmp4) / count(*), 1) as cmp4_pct,
       round(100.0 * sum(acceptedcmp5) / count(*), 1) as cmp5_pct,
       round(100.0 * sum(response) / count(*), 1) as last_campaign_pct
from marketingcampaign;
-- campaigns 3, 4 and 5 were close to each other, at 7.3%, 7.5% and 7.3%. campaign 1 was a little lower at 6.4%. campaign 2 was clearly the weakest at 1.3%. the last campaign at 14.9% was about double the best of the earlier ones.

-- response rate by kids at home
select kidhome, count(*) as customers, round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
group by kidhome
order by kidhome;
-- no kids: 17.2% (1,293 customers), above the 14.9% baseline. one kid: 12.2% (899), below the baseline. two kids: 4.2% (48), the lowest, but only about 2 people, so it’s too small to read.

-- response rate by education
select education, count(*) as customers, round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
group by education
order by response_pct desc;
-- phd v graduation have a real gap and both have large groups. basic is too small to read. master adn 2n cycle might be the same thing, 2n cycle is a european master level study.

-- response rate by teens at home
select teenhome,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
group by teenhome
order by teenhome;
 
-- response rate by marital status
select maritalstatus,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
group by maritalstatus
order by response_pct desc;

-- response rate by marital status (cleaned)
select case
         when maritalstatus in ('Single', 'Alone') then 'single'
         when maritalstatus in ('Married', 'Together') then 'partnered'
         when maritalstatus = 'Divorced' then 'divorced'
         when maritalstatus = 'Widow' then 'widow'
       end as marital_group,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where maritalstatus not in ('Absurd', 'YOLO')
group by 1
order by response_pct desc;

-- marital v income
select case 
	when maritalstatus in ('Married', 'Together') then 'partnered' 
	else 'not partnered' 
	end as marital_group,
       case 
	       when income < 70000 then 'under 70k' 
	       else '70k and over' 
	       end as income_group,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where income is not null
  and income < 200000
  and maritalstatus not in ('Absurd', 'YOLO')
group by income_group, marital_group
having count(*) >= 30
order by income_group, marital_group;
--income is no longer the only driver but on top of that it means something when they are unpartered they are more likely to respond. unpartnered customers earning 70k+ respond at nearly three times the average rate
-- absurd and yolo ommitted, seems unserious
-- alone merged with single
-- customers with a partner responded at about half the rate of those without. both partnered groups are big, so the gap is solid. It also fits what we saw with kids: households with fewer people responded more. partnered customers may be more likely to have kids at home, so these could be overlapping effects
 
-- response rate by income band
select case
         when income < 30000 then 'under 30k'
         when income < 50000 then '30k to 50k'
         when income < 70000 then '50k to 70k'
         else '70k and over'
       end as income_band,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where income is not null
  and income < 200000
group by income_band
order by min(income);
 
-- response rate by age group
select case
         when 2014 - yearbirth < 35 then 'under 35'
         when 2014 - yearbirth < 45 then '35 to 44'
         when 2014 - yearbirth < 55 then '45 to 54'
         when 2014 - yearbirth < 65 then '55 to 64'
         else '65 and over'
       end as age_group,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where yearbirth not in (1893, 1899, 1900)
group by age_group
order by min(2014 - yearbirth);
-- the dataset doesn’t state a collection date, so i used the latest enrollment date in the data as the reference year
-- its sort of like a u shape. the oldest and youngest repond the most
 
-- average spend by product category: responders vs non-responders
select response,
       count(*) as customers,
       round(avg(mntwines)) as wines,
       round(avg(mntfruits)) as fruits,
       round(avg(mntmeatproducts)) as meat,
       round(avg(mntfishproducts)) as fish,
       round(avg(mntsweetproducts)) as sweets,
       round(avg(mntgoldprods)) as gold,
       round(avg(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods)) as total
from marketingcampaign
group by response
order by response;
-- mostly wine and meats which are associated with being more expensive and needing higher income to afford
 
-- purchase channels: responders vs non-responders
select response,
       round(avg(numwebpurchases), 1) as web,
       round(avg(numcatalogpurchases), 1) as catalog,
       round(avg(numstorepurchases), 1) as store,
       round(avg(numwebvisitsmonth), 1) as web_visits_per_month
from marketingcampaign
group by response
order by response;
-- web visits are exactly the same whether respondant or not, no significance


-- higher education goes with a higher response rate.
-- fewer kids at home goes with a higher response rate.
-- probably overlaps with income lets test:

-- income v kids
select case 
	when income < 70000 then 'under 70k' 
	else '70k and over' 
	end as income_group,
       kidhome,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where income is not null
  and income < 200000
group by income_group, kidhome
having count(*) >= 30
order by response_pct desc;

-- income v education
select education,
       case 
	       when income < 70000 then 'under 70k' 
	       else '70k and over' 
       end as income_group,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where income is not null
  and income < 200000
group by education, income_group
having count(*) >= 30
order by education, income_group;
-- nothing. but mostly the 70k and over are leading in responses

-- teens v income
select teenhome,
       case 
	       when income < 70000 then 'under 70k' 
	       else '70k and over' 
	       end as income_group,
       count(*) as customers,
       round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where income is not null
  and income < 200000
group by income_group, teenhome
having count(*) >= 30
order by income_group, teenhome;


/* prioritize customers who earn 70k or more, are not partnered, and have no teens at home. customers with all three traits responded at 49.7% (145 customers), more than three times the 14.9% average.
next tier: customers with two of the three traits responded at 20.8%, above average.
de-emphasize customers with none of the traits, who responded at 6.5%. customers under 70k responded at 10-12%.
messaging: lean on wine and meat, where responders spend the most, and consider the catalog channel. these are suggestive, since we didn’t test whether spend and catalog use simply reflect higher income.
*/


-- favorible traits

select
    (case when income >= 70000 then 1 else 0 end
   + case when maritalstatus in ('Single', 'Alone', 'Divorced', 'Widow') then 1 else 0 end
   + case when teenhome = 0 then 1 else 0 end) as favorable_traits,
    count(*) as customers,
    round(100.0 * sum(response) / count(*), 1) as response_pct
from marketingcampaign
where income is not null
  and income < 200000
  and maritalstatus not in ('Absurd', 'YOLO')
group by 1
order by 1;
