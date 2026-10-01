# 가로 구조 통제변수 (STEP 14)

회귀에서 "큰길 효과"를 통제하기 위한 가로 값이다. 공원 네트워크 정의(D·N1·N2·N3)에는 쓰지 않는다.

## 파일
| 파일 | 단위 | 내용 |
|---|---|---|
| `axial_lines.gpkg` | axial line 135,773개 | 선 도형과 axial 지표 (EPSG:32618) |
| `segment_controls.parquet` | 가로 세그먼트 409,172개 | 세그먼트별 axial·angular 값 (GeoParquet) |
| `cluster_street_controls.csv` | 정의 × 군집 | 군집 100 m 상업 영역 안 가로 값의 길이 가중 평균·최댓값 |
| `park_street_controls.csv` | 공원 | 공원별 100 m 영역 안 가로 값 |
| `control_correlations.csv` / `.png` | | 통제변수 간 Spearman 상관 |
| `axial_validation.csv` | | alcyon(depthmapX 엔진)과의 대조 결과 |
| `axial_tolerance_sensitivity.csv` | | 허용 횡편차 5·10·15 m 민감도 |
| `map_axial_integration.png`, `map_axial_pilot.png` | | Integration 지도 |
| `alcyon_pilot.R` | | 검증에 쓴 R 스크립트 |

## 변수
| 변수 | 뜻 |
|---|---|
| `ax_line` | 세그먼트가 속한 axial line id (가장 길게 겹치는 선) |
| `ax_share` | 세그먼트 길이 중 그 선에 속한 비율 |
| `ax_connectivity` | 그 선과 교차하는 선의 수 |
| `ax_int_n` | Integration(HH), 반경 n (연결된 시스템 전체) |
| `ax_int_r3`, `ax_int_r5`, `ax_int_r7` | Integration(HH), 위상 반경 3·5·7 단계 |
| `ax_choice`, `ax_choice_norm`, `ax_choice_log` | Choice(순서쌍 기준), 정규화 값, log10(choice + 1) |
| `ax_system`, `ax_node_count` | 연결된 시스템 번호와 그 시스템의 선 개수 |
| `nain_{r}` | NAIN 유사 = density^1.2 / farness, 반경 r m (Cityseer 각도) |
| `nach_{r}` | NACH 유사 = log(choice + 1) / log(farness + 3), 반경 r m (Cityseer 각도) |
| `*_mean`, `*_max` | 영역 안 가로 세그먼트의 길이 가중 평균, 최댓값 |
| `top10_nach_1600_share`, `top10_ax_int_n_share` | 영역 안 가로 길이 중 도시 상위 10% 가로의 비율 |
| `street_len_m`, `n_segments`, `basis` | 집계에 쓴 길이·세그먼트 수, 기준(`street` = 가로만, `all` = 가로가 없어 전체 사용) |

## Axial line 만드는 법
- 가로 중심선(C 망)에서 교차점마다 가장 곧게 이어지는 세그먼트를 잇고(편차 < 30°), Douglas–Peucker로 허용 횡편차 10 m 안의 직선 조각으로 나눈다.
- 두 선은 보행망의 같은 교차점을 지나면 연결된다.
- 지표는 Hillier & Hanson(1984) 정의다. 같은 연결 그래프에서 alcyon과 Connectivity·Mean Depth·Integration(HH)이 일치한다(`axial_validation.csv`).

## 쓸 때 주의
- axial과 angular 값은 서로 상관이 있다(`control_correlations.csv`). 한 모형에는 계열마다 한두 개만 넣는다.
- N2 군집의 "큰길 비율" 속성은 NACH에서 만든 것이므로 `nach_*`와 같이 넣지 않는다.
- 보행망이 끊긴 시스템(스태튼아일랜드 등)은 `ax_int_n`이 시스템별로 계산된다. 보로 고정효과와 함께 쓴다.
- POI 단위 값은 노트북의 `attach_points()`로 붙인다.
