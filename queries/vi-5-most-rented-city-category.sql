  select sum(count) summary, film_id, title, city_id, city, category
  from
  (
    select count(f.film_id) count, f.film_id, f.title, ct.city_id, ct.city, cy.name category
    from rental r
      inner join inventory i on r.inventory_id = i.inventory_id
      inner join film f on f.film_id = i.film_id
      inner join store s on s.store_id = i.store_id
      inner join address a on a.address_id = s.address_id
      inner join city ct on ct.city_id = a.city_id
      inner join film_category fc on fc.film_id = f.film_id
      inner join category cy on cy.category_id = fc.category_id
    where year(r.last_update) = (select year(max(rr.last_update)) from rental rr)
      and month(r.last_update) = (select month(max(rr.last_update)) from rental rr)
    group by f.film_id, ct.city_id, ct.city, cy.category_id, cy.name
  ) by_category_city
  group by film_id, title, city, category
  order by summary desc, category desc
  limit 10
  ;