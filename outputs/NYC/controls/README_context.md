# 주변 여건 통제변수 (STEP 15)

공원 네트워크와 무관한 입지 조건을 통제하는 변수다. 가로 구조 통제변수는 `README.md`(STEP 14)를 본다.

## 파일
| 파일 | 단위 | 내용 |
|---|---|---|
| `park_context_controls.csv` | 규칙 × 공원 (2,057곳) | 공원별 상업 영역과 주변 400 m의 값 |
| `cluster_context_controls.csv` | 규칙 × 정의 × 군집 | 군집별 값 |
| `context_sources.csv` | | 자료 출처, 기준, 받은 날짜 |
| `context_correlations.csv` / `.png` | | 통제변수 간 Spearman 상관 (가로 통제변수 포함) |

`rule`: `nearest` = 가장 가까운 공원(네트워크 거리)에 배정한 영역(주 분석), `overlap` = 닿는 모든 공원에 중복 배정(민감도), `buffer` = 직선 100 m 버퍼(비교).

## 변수 (상업 영역)
| 변수 | 뜻 |
|---|---|
| `area_ha` | 영역 폴리곤 면적 |
| `pop`, `pop_density` | ACS 2020–2024 인구(블록그룹 값을 2020 블록 인구 비율로 나눔), ha당 인구 |
| `pop2020`, `housing_units` | 2020 Census 블록 인구, 주택 수 |
| `jobs`, `jobs_retail`, `jobs_food`, `job_density` | LODES 2023 일자리: 전체, 소매, 숙박·음식, ha당 전체 |
| `median_income` | 트랙트 중위 가구소득을 영역 안 인구로 가중 평균 (달러) |
| `income_topcoded_share` | 소득이 상한(250,001달러 이상)인 트랙트에 사는 인구 비율 |
| `ba_share` | 25세 이상 중 학사 이상 비율 (트랙트 값의 인구 가중 평균) |
| `zone_c_share`, `zone_m_share`, `zone_r_share` | 영역 면적 중 상업·공업·주거 용도지역 비율 |
| `overlay_share` | 상업 오버레이(C1·C2) 비율 |
| `commercial_zoning_share` | 상업지역 + 상업 오버레이 비율 |
| `lots` | 영역에 배정된 PLUTO 필지 수 |
| `bldg_area_m2`, `com_area_m2`, `retail_area_m2`, `office_area_m2`, `res_area_m2`, `res_units` | 필지 연면적 합계(전체·상업·소매·사무·주거)와 주거 세대 수 |
| `com_floor_share` | 상업 연면적 ÷ 전체 연면적 |
| `floor_area_ratio` | 전체 연면적 ÷ 영역 면적 (토지이용 강도) |
| `lots_mixed_share`, `lots_commercial_share` | 주상복합(토지이용 4), 상업·사무(토지이용 5) 필지 비율 |

## 변수 (규칙과 무관)
| 변수 | 뜻 |
|---|---|
| `n400_*` | 위와 같은 변수를 구성 공원에서 직선 400 m 이내로 집계한 값 (배후 수요) |
| `subway_dist_m` | 가장 가까운 지하철 출입구까지 직선 거리 (군집은 구성 공원 중 최솟값) |
| `subway_stations_400m` | 직선 400 m 안의 역 수 (환승 단지는 하나로 셈) |
| `park_acres` | 공원(군집) 면적 |
| `parkland_400m_ha`, `parkland_800m_ha` | 직선 400 m·800 m 안의 공원 부지 면적. Flagship·대형 공원을 포함한 NYC Parks 전체 기준 |

## 계산 방법
- 블록 자료(인구·주택·일자리)와 용도지역은 영역 폴리곤과 겹치는 면적 비율로 배분한다.
- PLUTO 필지는 POI와 같은 규칙으로 배정한다: 필지 중심점을 가장 가까운 가로 표본점(50 m 이내)에 붙이고, 그 점이 속한 공원에 넣는다. 공원 부지 안의 필지는 뺀다.
- 겹치지 않는 영역(`nearest`, `buffer`)의 군집 값은 구성 공원 값의 합이다. `overlap`과 주변 400 m는 합집합 도형으로 다시 집계한다.

## 쓸 때 주의
- 일자리는 2023년 자료다. Advan 2024년과 1년 차이가 난다.
- 상업 영역은 가로를 따라가는 좁은 띠라서 영역 안 인구는 적다. 배후 수요는 `n400_pop`, `n400_jobs`가 더 맞다.
- 소득은 트랙트 값이다. 블록그룹보다 오차가 작지만 공간 해상도는 낮다.
- 서로 강하게 상관된 변수는 `context_correlations.csv`에서 확인하고 같이 넣지 않는다.
