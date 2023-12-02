SELECT
  data,  -- ����
  cohort,  -- �������� �������
  COUNT(DISTINCT user_id) as day_cohort,  -- ���������� �������� ������� �� ����
  MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY cohort) as cohort_size,  -- ������ �������
  ROUND(COUNT(DISTINCT user_id) :: DECIMAL / MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY cohort) * 100, 2) as retention, --�������
  data - cohort as days_order, -- ����� ��� �� ����������� �������
  DATE_TRUNC('month', cohort) as cohort_month, -- ���� �������
  DATE_TRUNC('month', data) as data_month -- ����� �������
FROM
  (SELECT
      DISTINCT user_id,
      time :: date as data,
      min(time :: date) OVER (PARTITION BY user_id ORDER BY time) as cohort
    FROM user_actions) as a
GROUP BY data, cohort
ORDER by cohort
