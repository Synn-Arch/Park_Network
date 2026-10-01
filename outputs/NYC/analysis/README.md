# 분석 표 (STEP 16)

회귀에 바로 쓰는 표다. 통제변수의 뜻은 `../controls/README.md`(가로 구조)와 `../controls/README_context.md`(주변 여건)를, 군집 속성은 `../clusters/README.md`를 본다.

POI 지표: 아직 없음. `Data/Advan/`에 파일을 넣고 STEP 16을 다시 실행하면 채워진다.

## 파일
| 파일 | 단위 | 내용 |
|---|---|---|
| `park_table.csv` | 규칙 × 공원 (2,057곳) | 공원 속성, 정의별 군집, D와 N의 일치 유형, 통제변수 |
| `cluster_table_<def>.csv` | 규칙 × 군집 | 군집 속성(STEP 13), 통제변수 |
| `control_vif.csv` | | 통제변수 후보의 VIF (공원 단위, `nearest`) |


## `rule`
| 값 | 상업 영역 | POI 배정 |
|---|---|---|
| `nearest` (주 분석) | 공원 가장자리에서 길을 따라 100 m 안의 가로 | 네트워크 거리가 가장 짧은 공원 하나 |
| `overlap` (민감도) | 같음 | 닿는 모든 공원. 한 군집 안에서는 한 번만 셈 |
| `buffer` (비교) | 직선 100 m 버퍼 − 공원 부지 | 직선 거리로 가장 가까운 공원 |

## 공원 표의 열
| 열 | 뜻 |
|---|---|
| `park_id`, `name`, `parent_id`, `typecategory`, `borough` | 공원 속성. 긴 선형 공원은 구간으로 나뉘어 있고 `parent_id`가 원래 공원이다 |
| `<def>_cluster`, `<def>_in_group`, `<def>_cluster_size`, `<def>_status` | 정의(D·N1·N2·N3)별 군집 id, 묶음에 속하는지, 군집의 공원 수, 상태 |
| `D_vs_N1`, `D_vs_N2`, `D_vs_N3` | D와 N의 일치 유형: `both`, `D only`, `N? only`, `neither` |
| `zone_street_len_m`, `zone_area_m2` | 그 규칙에서 공원에 배정된 가로 길이와 영역 면적. 밀도의 분모 |
| `no_street_reach` | 길을 따라 100 m 안에 가로가 없는 공원 |
| `ax_*`, `nain_*`, `nach_*`, `top10_*`, `street_basis` | 가로 구조 통제변수 (STEP 14) |
| `area_ha` … `parkland_800m_ha` | 주변 여건 통제변수 (STEP 15) |
| `poi_n`, `poi_per_100m`, `poi_per_ha` | 업소 수, 가로 100 m당, ha당 (POI 파일이 있을 때) |
| `poi_categories`, `poi_diversity` | NAICS 4자리 업종 수, Shannon 엔트로피 |
| `visits`, `visits_per_poi`, `visits_per_100m` | 방문량 합계, 업소당, 가로 100 m당 |

## 쓸 때 주의
- `nearest` 규칙에서는 가로가 전부 더 가까운 다른 공원에 배정돼 영역이 비는 공원이 있다(`zone_street_len_m` = 0). 공원 단위 모형에서는 이 공원들을 빼거나 `overlap` 규칙과 비교한다.
- 군집 표의 `street_len_m`은 STEP 13 값(`nearest`)이고, `zone_street_len_m`이 그 행의 규칙에 맞는 길이다.
- 군집 표의 `attach_nach_1600_mean`은 구성 공원이 붙은 가로의 NACH 평균(STEP 13)이고, `nach_1600_mean`은 상업 영역 가로의 평균(STEP 14)이다.
- 상업 업소의 범위는 노트북 위쪽 `COMMERCIAL_NAICS2`, `EXCLUDE_NAICS3`에서 정한다(지금은 소매·예술오락·숙박음식·기타 서비스).
