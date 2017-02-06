insert into shipment (sugar_shipped, bagasse_shipped, agent_id)
  select
    r.rest_sugar,
    r.rest_bagasse,
    a.id
  from total_rest r
    inner join (
      select id, name from agent where name = 'Волошин Денис'
    ) a
    on r.name = a.name;
    
update shipment
  set bagasse_shipped = 0.8 * bagasse_shipped
  where shipment.agent_id = (
    select id from agent where name = 'Волошин Денис'
  );
  
update supply
  set bagasse_estimated = 0.8 * bagasse_estimated
  where supply.agent_id = (
    select id from agent where name = 'Волошин Денис'
  );
  
delete from shipment
  where
    ( extract (year from bill_date) = 2016) and
    ( extract (month from bill_date) = 11) and
    ( extract (day from bill_date) = 4) and
    agent_id = (
      select id from agent where name = 'Волошин Денис'
    );
    
-- RECOVER FROM PREVIOUS DELETE:    
--insert into shipment (sugar_shipped, bagasse_shipped, agent_id)
--values (20.3, 64.344, 6)

select
  a.name,
  s.supplies
from (
  select
    agent_id,
    count(*) as supplies
  from supply
  group by agent_id
    having count(*) >= 2
) s
inner join agent a
  on a.id = s.agent_id;

create table rest as(
  select name, rest_sugar, rest_bagasse
    from global_rest
);
