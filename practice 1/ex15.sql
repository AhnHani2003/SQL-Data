--Find the advertising channel where Uber spent more than 100k USD in 2019.
select advertising_channel
from uber_advertising
where money_spent > 100000 and year = 2019
