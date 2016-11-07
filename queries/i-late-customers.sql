SELECT store_id, city_id, city, ifnull(((customers_late/customers)*100), 0) late_percentage,
  ifnull(((customer_on_time/customers)*100), 0) on_time_percentaje
  FROM
(
  SELECT
    store_id,
    city_id,
    city,
    sum(total)         customers,
    sum(total_late)    customers_late,
    sum(total_on_time) customer_on_time
  FROM
    (
      SELECT
        count(customer_id)            total,
        store_id,
        city_id,
        city,
        CASE WHEN late = 1
          THEN count(customer_id) END total_late,
        CASE WHEN late = 0
          THEN count(customer_id) END total_on_time
      FROM
        (
          SELECT
            r.customer_id,
            s.store_id,
            ct.city_id,
            ct.city,
            CASE WHEN (current_timestamp() > timestampadd(DAY, f.rental_duration, r.rental_date)
                       AND r.return_date IS NULL)
              THEN 1
            ELSE 0
            END late
          FROM rental r
            INNER JOIN inventory i ON r.inventory_id = i.inventory_id
            INNER JOIN film f ON f.film_id = i.film_id
            INNER JOIN customer c ON r.customer_id = c.customer_id
            INNER JOIN address a ON a.address_id = c.address_id
            INNER JOIN city ct ON ct.city_id = a.city_id
            INNER JOIN store s ON s.store_id = c.store_id
          WHERE c.active
        ) customer_status
      GROUP BY store_id, city_id, city, late
    ) grouped_data
  GROUP BY store_id, city_id, city
) CUSTOMER_PERCENTAGE
;
