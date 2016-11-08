  select store, sum(one_to_three) one_to_3, sum(four_to_six) four_to_6, sum(seven_to_nine) seven_to_9,
    sum(ten_to_12) ten_to_12, sum(more_than_13) more_than_13, sum(total) total
  from
  (
    select store,
        case when days_late between 1 and 3 then sum(films) end one_to_three,
        case when days_late between 4 and 6 then sum(films) end four_to_six,
        case when days_late between 7 and 9 then sum(films) end seven_to_nine,
        case when days_late between 10 and 12 then sum(films) end ten_to_12,
        case when days_late >= 13 then sum(films) end more_than_13,
        sum(films) total
    from
    (
      select count(f.film_id) films, s.store_id store,
        # Added - 255 to the days_late column since the data is more than six months ago
        datediff(current_timestamp(), timestampadd(day, f.rental_duration, r.rental_date)) - 255 days_late
      from rental r
        inner join inventory i on r.inventory_id = i.inventory_id
        inner join film f on f.film_id = i.film_id
        inner join customer c on r.customer_id = c.customer_id
        inner join address a on a.address_id = c.address_id
        inner join city ct on ct.city_id = a.city_id
        inner join store s on s.store_id = c.store_id
      where current_timestamp() > timestampadd(day, f.rental_duration, r.rental_date)
        and r.return_date is null
      group by s.store_id, days_late

    ) grouped_data
    group by store, days_late

  ) by_range
  group by store
  ;
