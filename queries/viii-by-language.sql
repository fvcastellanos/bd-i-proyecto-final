  select language, sum(T1_2015) T1_2015, sum(T2_2015) T2_2015, sum(T3_2015) T3_2015, sum(T4_2015) T4_2015, sum(total_2015) total_2015,
    sum(T1_2016) T1_2016, sum(T2_2016) T2_2016, sum(T3_2016) T3_2016, sum(T4_2016) T4_2016, sum(total_2016) total_2016,
    ((sum(total_2016) - sum(total_2015)) / sum(total_2015)) * 100 percentage
  from
  (
    select sum(films) films, name language,
      case when year = 2015 and month between 1 and 3 then sum(films) end T1_2015,
      case when year = 2015 and  month between 4 and 6 then sum(films) end T2_2015,
      case when year = 2015 and  month between 7 and 9 then sum(films) end T3_2015,
      case when year = 2015 and  month between 10 and 12 then sum(films) end T4_2015,
      case when year = 2015 then sum(films) end total_2015,
      case when year = 2016 and month between 1 and 3 then sum(films) end T1_2016,
      case when year = 2016 and  month between 4 and 6 then sum(films) end T2_2016,
      case when year = 2016 and  month between 7 and 9 then sum(films) end T3_2016,
      case when year = 2016 and  month between 10 and 12 then sum(films) end T4_2016,
      case when year = 2016 then sum(films) end total_2016
    from
    (
      select count(f.film_id) films, l.language_id, l.name,
        year(r.rental_date) year, month(r.rental_date) month
      from rental r
        inner join inventory i on r.inventory_id = i.inventory_id
        inner join film f on f.film_id = i.film_id
        inner join language l on l.language_id = f.language_id
      group by l.language_id, l.name, year(r.rental_date), month(r.rental_date)
    ) asdf
    group by language_id, year

  ) grouped_data
  ;
