  select city, sum(G) G, sum(PG) PG, sum(PG_13) PG13,
    sum(NC_17) NC17, sum(R) R, sum(total) total
  from
  (
    # ENUM('G', 'PG', 'PG-13', 'R', 'NC-17')
    select city_id, city,
      case when rating = 'G' then sum(films) end G,
      case when rating = 'PG' then sum(films) end PG,
      case when rating = 'PG-13' then sum(films) end PG_13,
      case when rating = 'NC-17' then sum(films) end NC_17,
      case when rating = 'R' then sum(films) end R,
      sum(films) total
    from
    (
      select count(f.film_id) films, f.rating, ct.city_id, ct.city
      from rental r
        inner join inventory i on r.inventory_id = i.inventory_id
        inner join film f on f.film_id = i.film_id
        inner join customer c on r.customer_id = c.customer_id
        inner join address a on a.address_id = c.address_id
        inner join city ct on ct.city_id = a.city_id
        inner join store s on s.store_id = c.store_id
      group by f.rating, ct.city_id, ct.city
    ) films_by_city
    group by city_id, city, rating
  ) grouped_data
  group by city_id
  ;
