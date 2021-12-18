-- Создаем таблицы
create table pilots(
	pilot_id integer not NULL primary key AUTOINCREMENT,
  	name varchar(100), 
  	age integer, 
  	rank integer, 
  	education_level varchar(256)
);


create table planes(
	plane_id Integer not NULL primary key autoincrement, 
  	capacity Integer, 
    cargo_flg integer
);


create table flights(
	flight_id Integer not NULL,
  	flight_dt date not NULL, 

  	plane_id INTEGER not NULL,
  	first_pilot_id Integer not NULL,
  	second_pilot_id Integer not NULL,
  	destination varchar(10), 
  	quantiny integer,
  	FOreign key (plane_id) references planes (plane_id),
  	Foreign Key (first_pilot_id) references pilots (pilot_id), 
  	foreign key (second_pilot_id) references pilots (pilot_id), 

    CONSTRAINT id primary key (flight_id, flight_dt)
);


-- Добавляем значения
insert into pilots 
values
(null, "Alex", 32, 2, "B"),
(null, "Borat", 26, 3, "C"),
(null, "Ivan", 48, 1, "A"),
(null, "Rajesh", 35, 2, "A"),
(null, "Abu", 30, 2, "B"),
(null, "Svetlana", 38, 1, "A"),
(null, "Giovanni", 28, 3, "A"),
(null, "Gabriel", 31, 2, "B"),
(null, "Jacob", 50, 1, "A"),
(null, "Igor", 51, 1, "A"),
(null, "Irena", 30, 2, "B"),
(null, "Prokhor", 60, 1, "B"),
(null, "Vasily", 47, 1, "C"),
(null, "Amari", 25, 3, "C"),
(null, "Simon", 30, 2, "B"),
(null, "Olga", 46, 2, "A");


INSERT INTO planes
values
(null, 100, 1),
(null, 500, 0), 
(null, 20, 1),
(null, 50, 0),
(null, 200, 1),
(null, 30, 0),
(null, 200, 0),
(null, 400, 0),
(null, 50, 1),
(null, 60, 1),
(null, 70, 1),
(null, 300, 0);


insert into flights
values 
(1, "2021-08-22", 12, 1, 12, "SVO", 200),
(2, "2021-09-22", 9, 2, 4, "SVO", 45),
(3, "2021-08-22", 8, 3, 8, "LED", 300),
(4, "2021-08-24", 11, 6, 1, "KUF", 60),
(5, "2021-01-24", 1, 11, 5, "CEK", 99),
(6, "2021-08-24", 2, 7, 9, "SVO", 386),
(7, "2016-08-24", 2, 10, 2, "SVO", 386),
(8, "2021-08-24", 6, 11, 16, "LED", 24),
(9, "2021-08-22", 12, 16, 1, "SVO", 200),
(10, "2021-09-22", 9, 15, 12, "SVO", 45),
(11, "2021-08-22", 8, 12, 2, "LED", 300),
(12, "2021-08-24", 11, 13, 5, "KUF", 60),
(13, "2021-01-24", 1, 7, 14, "CEK", 99),
(14, "2021-08-24", 2, 14, 13, "SVO", 386),
(15, "2016-08-24", 2, 16, 13, "SVO", 386),
(16, "2021-08-24", 6, 2, 10, "LED", 24),
(17, "2021-08-01", 11, 1, 10, "SVO", 60),
(18, "2021-08-31", 11, 1, 10, "SVO", 60);


-- Создаем helper для дополнения случайными записями таблицы flights
create table helper(
	flight_id Integer,
  	flight_dt date, 
  	plane_id INTEGER,
  	first_pilot_id Integer,
  	second_pilot_id Integer,
  	destination varchar(10), 
  	quantiny integer
);


insert into helper 
select * from flights;
insert into helper
select * from helper;
insert into helper
select * from helper;
insert into helper
select * from helper;
insert into helper
select * from helper;
insert into helper
select * from helper;


-- Дополняем случайными записями таблицу flights
insert into flights 
select 
	*, 
    abs(random()) % (select capacity from planes where plane_id = rnd_plane_id) as quantity
from (
select 
	row_number() over (order by flight_id) + (select count(flight_id) from flights) as flight_id,
	"2020-07-22",
    abs(random()) % (select count(plane_id) from planes) + 1 as rnd_plane_id,
    abs(random()) % (select count(pilot_id) from pilots) + 1 as first_pilot_id,
    abs(random()) % (select count(plane_id) from planes) + 1 as second_pilot_id,
   	"LED"
from helper where first_pilot_id != second_pilot_id );


-- Задание 1
Select distinct pilot_id, name from flights join pilots on pilots.pilot_id = flights.second_pilot_id 
	where flight_dt between '2021-08-01' and'2021-08-31' 
	and destination = "SVO";


-- Задание 2
-- Строим вспомогательную таблицу 
create table cargo_flights_number(
  pilot_id INTEGER NOT NULL primary key,
  number INTEGER not NULL
);

-- Учитываем полеты совершенные как в качестве первого, так в и в качестве второго пилота 
insert into cargo_flights_number
select pilot_id, sum(flights_number) 
from (
	select 
		first_pilot_id as pilot_id, 
        sum(cargo_flg) as flights_number
	From flights join planes on flights.plane_id = planes.plane_id
	group by first_pilot_id
	union ALL
	select 
		second_pilot_id as pilot_id, 
        sum(cargo_flg) as flights_number
	from flights join planes on flights.plane_id = planes.plane_id
	group by second_pilot_id
) group by pilot_id;


select pilots.pilot_id, name from cargo_flights_number join pilots on cargo_flights_number.pilot_id = pilots.pilot_id
where age > 45 and number > 30;


-- Задание 3
select first_pilot_id, name
from flights join pilots on first_pilot_id = pilot_id
join planes on planes.plane_id = flights.plane_id
where cargo_flg = 0
group by first_pilot_id
order by sum(quantiny) desc limit 10;






