  select store, city, year, sum(T1) T1, sum(T2) T2, sum(T3) T3,
    sum(T4) T4, sum(total) total
  from
  (
    select store_id store, city_id, city, year,
      case when month between 1 and 3 then sum(income) end T1,
      case when month between 4 and 6 then sum(income) end T2,
      case when month between 7 and 9 then sum(income) end T3,
      case when month between 10 and 12 then sum(income) end T4,
      sum(income) total
    from
    (
      select s.store_id, ct.city_id, ct.city, sum(p.amount) income,
        year(p.payment_date) year, month(p.payment_date) month
      from payment p
        inner join customer c on p.customer_id = c.customer_id
        inner join store s on c.store_id = s.store_id
        inner join address a on a.address_id = s.address_id
        inner join city ct on ct.city_id = a.city_id
      group by s.store_id, ct.city_id, ct.city, year(p.payment_date), month(p.payment_date)
    ) income_by_city
    group by store_id, city_id, city, year
  ) grouped_data
  group by store, city_id, year
  order by year desc
  ;
