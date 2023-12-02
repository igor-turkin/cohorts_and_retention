SELECT
  data,  -- дата
  cohort,  -- название когорты
  COUNT(DISTINCT user_id) as day_cohort,  -- количество клиентов когорты по дням
  MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY cohort) as cohort_size,  -- размер когорты
  ROUND(COUNT(DISTINCT user_id) :: DECIMAL / MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY cohort) * 100, 2) as retention, --ретеншн
  data - cohort as days_order, -- номер дня от образования когорты
  DATE_TRUNC('month', cohort) as cohort_month, -- день когорты
  DATE_TRUNC('month', data) as data_month -- месяц когорты
FROM
  (SELECT
      DISTINCT user_id,
      time :: date as data,
      min(time :: date) OVER (PARTITION BY user_id ORDER BY time) as cohort
    FROM user_actions) as a
GROUP BY data, cohort
ORDER by cohort
