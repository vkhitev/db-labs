insert all
  into agent (name) values ('Адаменко Владислав')
  into agent (name) values ('Бевз Дмитрий')
  into agent (name) values ('Бондар Максим')
  into agent (name) values ('Ботвинко Дарья')
  into agent (name) values ('Бузинный Александр')
  into agent (name) values ('Волошин Денис')
  into agent (name) values ('Дифучина Александра')
  into agent (name) values ('Жовтун Виктория')
  into agent (name) values ('Камышанов Владимир')
  into agent (name) values ('Косенко Владислав')
  into agent (name) values ('Клименко Вадим')
  into agent (name) values ('Кучмий Антонина')
  into agent (name) values ('Лесниченко Роман')
  into agent (name) values ('Любченко Глеб')
  into agent (name) values ('Михайленко Олег')
  into agent (name) values ('Обёртышев Анатолий')
  into agent (name) values ('Романченко Богдан')
  into agent (name) values ('Романчук Иван')
  into agent (name) values ('Савченко Влад')
  into agent (name) values ('Сердюк Евгений')
  into agent (name) values ('Труба Александр')
  into agent (name) values ('Хитёв Владислав')
select 1 from dual;

insert into supply (beet_supplied, sugar_estimated, bagasse_estimated, agent_id)
  values (70.204, 10.5, 55.1, (select agent.id from agent where agent.name = 'Романчук Иван'));
  
insert into supply (beet_supplied, sugar_estimated, bagasse_estimated, agent_id)
  values (114.5, 20.3, 80.43, (select agent.id from agent where agent.name = 'Волошин Денис'));
  
insert into supply (beet_supplied, sugar_estimated, bagasse_estimated, agent_id)
  values (90.04, 15.6, 60.13, (select agent.id from agent where agent.name = 'Романчук Иван'));
  
insert into shipment (sugar_shipped, bagasse_shipped, agent_id)
  values (19, 99, (select agent.id from agent where agent.name = 'Романчук Иван'));
  
--update agent
--  set rest_sugar = 20.3, rest_bagasse = 80.43
--  where name = 'Волошин Денис';
--  
--update agent
--  set rest_sugar = 7.1, rest_bagasse = 16.23
--  where name = 'Романчук Иван';