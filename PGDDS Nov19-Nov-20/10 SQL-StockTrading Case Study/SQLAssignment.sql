CREATE SCHEMA `assignment` ;
#Import data from csv file into table bajaj using import wizard
alter table bajaj rename column `Close Price` to `close_price`;
create table bajaji1(Date date,`close_price` float(10,2) );
insert into bajaji1 select str_to_date(Date,'%d-%M-%Y') as Date,`close_price` from bajaj;
CREATE VIEW  bjv as select  Date, close_price,
row_number() over (order by Date)  "rno",
if(row_number() over (order by Date)>19,avg(close_price) over (order by Date rows 19 preceding),NULL) as MA20,
if(row_number() over (order by Date)>49,avg(close_price) over (order by Date rows 49 preceding),NULL) as MA50
from bajaji1
order by rno desc;
create table bajaj1 as select Date,close_price,MA20,MA50
from bjv where rno > 49;

#Import data from csv file into table eicher using import wizard

alter table eicher rename column `Close Price` to `close_price`;
create table eicheri1(Date date,`close_price` float);
insert into eicheri1 select str_to_date(Date,'%d-%M-%Y') as Date,`close_price` from eicher;
CREATE VIEW  ecv as select  Date, close_price,
row_number() over (order by Date)  "rno",
if(row_number() over (order by Date)>19,avg(close_price) over (order by Date rows 19 preceding),NULL) as MA20,
if(row_number() over (order by Date)>49,avg(close_price) over (order by Date rows 49 preceding),NULL) as MA50
from eicheri1
order by rno desc;
create table eicher1 as select Date,close_price,MA20,MA50
from ecv where rno > 49;


#Import data from csv file into table hero using import wizard

alter table hero rename column `Close Price` to `close_price`;
create table heroi1(Date date,`close_price` float);
insert into heroi1 select str_to_date(Date,'%d-%M-%Y') as Date,`close_price` from hero;
CREATE VIEW  hev as select  Date, close_price,
row_number() over (order by Date)  "rno",
if(row_number() over (order by Date)>19,avg(close_price) over (order by Date rows 19 preceding),NULL) as MA20,
if(row_number() over (order by Date)>49,avg(close_price) over (order by Date rows 49 preceding),NULL) as MA50
from heroi1
order by rno desc;
create table hero1 as select Date,close_price,MA20,MA50
from hev where rno > 49;

#Import data from csv file into table infosys using import wizard

alter table infosys rename column `Close Price` to `close_price`;
create table infosysi1(Date date,`close_price` float);
insert into infosysi1 select str_to_date(Date,'%d-%M-%Y') as Date,`close_price` from infosys;
CREATE VIEW  iev as select  Date, close_price,
row_number() over (order by Date)  "rno",
if(row_number() over (order by Date)>19,avg(close_price) over (order by Date rows 19 preceding),NULL) as MA20,
if(row_number() over (order by Date)>49,avg(close_price) over (order by Date rows 49 preceding),NULL) as MA50
from infosysi1
order by rno desc;
create table infosys1 as select Date,close_price,MA20,MA50
from iev where rno > 49;

#Import data from csv file into table tcs using import wizard

alter table tcs rename column `Close Price` to `close_price`;
create table tcsi1(Date date,`close_price` float);
insert into tcsi1 select str_to_date(Date,'%d-%M-%Y') as Date,`close_price` from tcs;
CREATE VIEW  tcv as select  Date, close_price,
row_number() over (order by Date)  "rno",
if(row_number() over (order by Date)>19,avg(close_price) over (order by Date rows 19 preceding),NULL) as MA20,
if(row_number() over (order by Date)>49,avg(close_price) over (order by Date rows 49 preceding),NULL) as MA50
from tcsi1
order by rno desc;
create table tcs1 as select Date,close_price,MA20,MA50
from tcv where rno > 49;

#Import data from csv file into table tvs using table import wizard

alter table tvs rename column `Close Price` to `close_price`;
create table tvsi1(Date date,`close_price` float);
insert into tvsi1 select str_to_date(Date,'%d-%M-%Y') as Date,`close_price` from tvs;
CREATE VIEW  tvv as select  Date, close_price,
row_number() over (order by Date)  "rno",
if(row_number() over (order by Date)>19,avg(close_price) over (order by Date rows 19 preceding),NULL) as MA20,
if(row_number() over (order by Date)>49,avg(close_price) over (order by Date rows 49 preceding),NULL) as MA50
from tvsi1
order by rno desc;
create table tvs1 as select Date,close_price,MA20,MA50
from tvv where rno > 49;

#-------------Master Table Creation

create table master_tbl as select Date,b.close_price as Bajaj,tc.close_price TCS,tv.close_price as TVS,
inf.close_price as Infosys, ec.close_price as Eicher,h.close_price as Hero
from bajaj b inner join tcs tc
using (Date) inner join tvs tv
using(Date) inner join infosys inf
using (Date) inner join eicher ec
using (Date) inner join hero h
using (Date);

#------------to generate buy and sell signal in tbl bajaj2

create table bajajl3 as select *, (MA20-MA50) AS flag, lead((MA20-MA50),1) over(order by Date desc) as flagp,
"Hold"
from bajaj1;

update bajajl3 set Hold = "Buy"
where flag>0 and flagp<0;

update bajajl3 set Hold = "Sell"
where flag<0 and flagp>0;

create table bajaj2 as
select Date,close_price, Hold as `Signal` from bajajl3;

#-----------to generate to generate buy and sell signal in tbl tcs2

create table tcsl3 as select *, (MA20-MA50) AS flag, lead((MA20-MA50),1) over(order by Date desc) as flagp,
"Hold"
from tcs1;

update tcsl3 set Hold = "Buy"
where flag>0 and flagp<0;

update tcsl3 set Hold = "Sell"
where flag<0 and flagp>0;

create table tcs2 as
select Date,close_price, Hold as `Signal` from tcsl3;
 #-----------to generate to generate buy and sell signal in tbl tvs2

create table tvsl3 as select *, (MA20-MA50) AS flag, lead((MA20-MA50),1) over(order by Date desc) as flagp,
"Hold"
from tvs1;

update tvsl3 set Hold = "Buy"
where flag>0 and flagp<0;

update tvsl3 set Hold = "Sell"
where flag<0 and flagp>0;

create table tvs2 as
select Date,close_price, Hold as `Signal` from tvsl3;

 #-----------to generate to generate buy and sell signal in tbl infosys2

create table infosysl3 as select *, (MA20-MA50) AS flag, lead((MA20-MA50),1) over(order by Date desc) as flagp,
"Hold"
from infosys1;

update infosysl3 set Hold = "Buy"
where flag>0 and flagp<0;

update infosysl3 set Hold = "Sell"
where flag<0 and flagp>0;

create table infosys2 as
select Date,close_price, Hold as `Signal` from infosysl3;

 #-----------to generate to generate buy and sell signal in tbl eicher2

create table eicherl3 as select *, (MA20-MA50) AS flag, lead((MA20-MA50),1) over(order by Date desc) as flagp,
"Hold"
from eicher1;

update eicherl3 set Hold = "Buy"
where flag>0 and flagp<0;

update eicherl3 set Hold = "Sell"
where flag<0 and flagp>0;

create table eicher2 as
select Date,close_price, Hold as `Signal` from eicherl3;

#-----------to generate to generate buy and sell signal in tbl hero2

create table herol3 as select *, (MA20-MA50) AS flag, lead((MA20-MA50),1) over(order by Date desc) as flagp,
"Hold"
from hero1;

update herol3 set Hold = "Buy"
where flag>0 and flagp<0;

update herol3 set Hold = "Sell"
where flag<0 and flagp>0;

create table hero2 as
select Date,close_price, Hold as `Signal` from herol3;

#---UDF--Create UDF, that takes the date in format ('yyyy-dd-mm') as input and returns the signal for day (Buy/Sell/Hold) for the Bajaj
#e.g. select decisupport('2018-06-21'); returns Buy
delimiter $$ 
create function decisupport(Date date)
returns varchar(25) deterministic
begin
 declare sign varchar(25) ;
 set sign = (select `Signal` from bajaj2 where bajaj2.Date = Date limit 1);
 return sign ;
end; $$ 
delimiter ;