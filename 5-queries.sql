-- Какое оборудование работает в поликлинике более 3-х лет?
SELECT
  e.id as equipment_id,
  e.name as equipment_name,
  floor(months_between(SysDate, p.PURCHASE_DATE) / 12) as years_used
FROM equipment e
  INNER JOIN purchase p
    ON e.ID = p.EQUIPMENT_ID
WHERE p.PURCHASE_DATE < TRUNC(SYSDATE) - interval '3' year;

-- У какого врача оборудование работает без единого ремонта?
SELECT
  c.id as cabinet,
  c.doctor as doctor_name
FROM cabinet c
WHERE c.id NOT IN (
  SELECT r.cabinet_id
  FROM repair r
);

-- Показать оснащение по кабинетам (названия по алфавиту).
SELECT
  p.cabinet_id as cabinet,
  p.equipment_id,
  e.name as equipment_name
FROM purchase p
  INNER JOIN equipment e
    ON p.equipment_id = e.id
UNION (
  SELECT
    c.id,
    NULL,
    'Оборудование отсутствует'
  FROM cabinet c
    WHERE c.id NOT IN (
      SELECT p.cabinet_id
        FROM purchase p
    )
)
ORDER BY cabinet, equipment_name;

-- Предоставить общую сумму, потраченную на ремонты с даты X по дату Y.
SELECT
  SUM(r.price) as total_repair_price
FROM repair r
WHERE r.repair_date BETWEEN
  TO_DATE('01/01/2012', 'dd/mm/yyyy') AND
  TO_DATE('01/01/2015', 'dd/mm/yyyy');
  
-- Показать разность сумм приобретения и ремонтов по
-- каждому из видов оборудования. (вид оборудования = имя оборудования).
SELECT
  pur.name,
  se - coalesce(sr, 0) as diff
FROM (
  SELECT
    e.name,
    sum(e.price) se
  FROM equipment e
  GROUP BY e.name
) pur
LEFT JOIN (
  SELECT
    e.name,
    sum(r.price) sr
  FROM repair r
    INNER JOIN equipment e
      ON r.equipment_id = e.id
  GROUP BY e.name
) rep
ON pur.name = rep.name;

-- 1. Использование агрегации и HAVING.
-- Показать врачей, у которых 2 и более оборудований в кабинете.
SELECT
  c.id as cabinet,
  count(*) as eq_in_cabinet
FROM cabinet c
  INNER JOIN purchase p
    ON p.cabinet_id = c.id
GROUP BY c.id
  HAVING count(*) >= 2;
  
-- 2. Преобразование типов.
-- Показать стоимость оборудования в гривнах.

SELECT
  e.name,
  TO_CHAR(e.price) || ' грн.' as price
FROM equipment e;

-- 3. Поиск по фрагменту текстового поля.
-- Найти все микроскопы.
SELECT DISTINCT
  e.name
FROM equipment e
WHERE regexp_like(e.name, 'микроскоп', 'i');

-- 4. Замена значений.
-- Показать состояние оборудования.
SELECT
  e.id as equipment_id,
  e.name as equipment_name,
  (CASE WHEN r.equipment_id IS NOT NULL
    THEN 'Ломалось'
    ELSE 'Не ломалось'
    END) as was_broken
FROM equipment e
  LEFT JOIN (
    SELECT
      r.equipment_id
    FROM repair r
    GROUP BY r.equipment_id
  ) r
    ON e.id = r.equipment_id;