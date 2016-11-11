  select rating, year, ifnull(sum(enero), 0) enero, ifnull(sum(febrero), 0) febrero, ifnull(sum(marzo), 0) marzo,
    ifnull(sum(abril), 0) abril, ifnull(sum(mayo), 0) mayo, ifnull(sum(junio), 0) junio,
    ifnull(sum(julio), 0) julio, ifnull(sum(agosto), 0) agosto, ifnull(sum(septiembre), 0) septiembre,
    ifnull(sum(octubre), 0) octubre, ifnull(sum(noviembre), 0) noviembre, ifnull(sum(diciembre), 0) diciembre,
    sum(total) total
  from
  (
    select rating, year, sum(films) total,
      case when month = 1 then sum(films) end enero,
      case when month = 2 then sum(films) end febrero,
      case when month = 3 then sum(films) end marzo,
      case when month = 4 then sum(films) end abril,
      case when month = 5 then sum(films) end mayo,
      case when month = 6 then sum(films) end junio,
      case when month = 7 then sum(films) end julio,
      case when month = 8 then sum(films) end agosto,
      case when month = 9 then sum(films) end septiembre,
      case when month = 10 then sum(films) end octubre,
      case when month = 11 then sum(films) end noviembre,
      case when month = 12 then sum(films) end diciembre
    from
    (
      select count(f.film_id) films, f.rating, year(r.rental_date) year, month(r.rental_date) month
      from rental r
        inner join inventory i on r.inventory_id = i.inventory_id
        inner join film f on f.film_id = i.film_id
        inner join store s on s.store_id = i.store_id
        inner join address a on a.address_id = s.address_id
        inner join city ct on ct.city_id = a.city_id
        inner join customer c on r.customer_id = c.customer_id
      group by f.rating, year(r.rental_date), month(r.rental_date)
    ) clasification_by_month
    group by rating, month, year

  ) grouped_data
  group by rating, year
  order by year, rating
  ;
