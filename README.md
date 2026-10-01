# Park_Network

뉴욕시 중소형 공원들이 보행 네트워크 위에서 이루는 **configurational(각도 기반, Space Syntax 영감) 네트워크**를 찾는다. 그 결과로 공원 묶음(cluster)과 고립 공원을 식별한다.
- 분석 설계: [CLAUDE.md](CLAUDE.md)
- 연구 목적과 다음 단계(공원 네트워크 구성과 주변 상업 활동, 100 m 버퍼 회귀): `SunghoSynn_ResearchOutline.docx`
네트워크 분석은 **Cityseer 5.8**을 중심으로 한다.

## 노트북 (STEP 순서대로 실행)

| 노트북 | 내용 | 주요 출력 |
|---|---|---|
| [01_nyc_walk_network.ipynb](01_nyc_walk_network.ipynb) | (초기) OSMnx 보행/차도망 다운로드. **이후 단계에서는 사용하지 않음** | `Data/nyc_walk_network/` |
| [02_step1_osm_network.ipynb](02_step1_osm_network.ipynb) | OSM 보행망 재구축: Staten Island 포함, `sidewalk=separate` 도로 포함, 태그 보존. 두 변형 **C**(가로 중심선+보행전용, 주 분석)와 **S**(보도 포함, 민감도) | `Data/derived/network/segments_{C,S}.parquet` |
| [03_step2_cityseer_network.ipynb](03_step2_cityseer_network.ipynb) | 합성 각도 테스트, 보로+3.2 km 버퍼 dual `CityNetwork` 구축, 호출 비용 벤치마크 | `Data/derived/network/cityseer/` |
| [04_step3_park_attachment.ipynb](04_step3_park_attachment.ipynb) | 공원 필터, 입구 데이터 없는 공원-네트워크 attachment(경계 링 + 전면 조건 + FPS), unresolved, OSM 완전성, E0 co-frontage | `parks.parquet`, `attachments.parquet`, `pairs_E0.parquet` |
| [05_step4_angular_relations.ipynb](05_step4_angular_relations.ipynb) | `dijkstra_tree_simplest`/`shortest`로 공원 쌍의 각도 비용·최단거리, few-turn catchment | `pairs_{v}.parquet`, `catch_park_{v}.pkl` |
| [06_step5_backbone_corridors.ipynb](06_step5_backbone_corridors.ipynb) | 각도 choice/farness → NACH 유사 정규화, 각도 연속 stroke, corridor | `centrality_{v}`, `strokes_{v}`, `corridors_{v}`, `park_stroke_{v}` |
| [07_step6_park_graphs.ipynb](07_step6_park_graphs.ipynb) | 정의별(D/N1abs/N1rel/N2/N3)·파라미터별 공원 그래프와 구조 분류 | `graphs/edges_*.parquet`, `classification.parquet` |
| [08_step7_sensitivity_groups.ipynb](08_step7_sensitivity_groups.ipynb) | persistence, 동반소속 합의 → **강건한 공원 묶음**, 방법론·노드 집합 민감도 | `robust_groups_{def}.parquet`, `persistence.parquet` |
| [09_step8_evaluation.ipynb](09_step8_evaluation.ipynb) | 근접성 환원 여부 검증: proximity AUC, 밀도 맞춘 거리 null, 사례, 고립 요인 모델 | `evaluation_*.csv` |
| [10_step9_results_maps.ipynb](10_step9_results_maps.ipynb) | 정의별 공원 묶음·고립 공원 지도(folium/PNG), 정의 간 비교 (1차 결과) | `outputs/{AREA}/` |
| [11_step10_regrouping.ipynb](11_step10_regrouping.ipynb) | **최종 묶음**: 네 정의(D·N1·N2·N3)에 같은 절차 적용(보로 단위 퍼콜레이션 필터 → Louvain γ=2 → 합의 → 도보 10분 분할), 정의 간 비교(ARI·묶음 쌍 겹침) | `outputs/{AREA}/regroup/` (`park_groups_final.csv`, `map_final_groups.html`) |
| [12_step11_export_geojson.ipynb](12_step11_export_geojson.ipynb) | **정의별 GeoJSON**: 공원(묶음 id·고립 지수·상태), 묶음 볼록껍질, 공원 간 관계선. D·N1·N2·N3 + 보조 N1rel·N1knn, 데이터 사전 포함 | `outputs/{AREA}/geojson/` |
| [13_step12_slides.ipynb](13_step12_slides.ipynb) | **발표 자료(영어·한글)**: 쉬운 말 본문 + 기술 부록, 정의 요약 다이어그램, 결과 지도, 네이티브 차트 | `outputs/{AREA}/slides/` (`NYC_park_networks_EN/KO.pptx`, `figs/`) |
| [14_step13_cluster_table.ipynb](14_step13_cluster_table.ipynb) | **회귀 준비물**: 정의별 모든 공원 → 군집 id(단독 포함), 군집 속성표, **상업 영역**(공원 가장자리에서 길을 따라 100 m 안의 가로, 가장 가까운 공원 기준으로 나눔), 비교용 직선 버퍼 | `outputs/{AREA}/clusters/` |
| [15_step14_street_controls.ipynb](15_step14_street_controls.ipynb) | **회귀 통제변수(가로 구조)**: 가로 중심선에서 뽑은 axial line의 Connectivity·Integration(HH)·Choice, Cityseer NAIN·NACH 유사(400–3200 m), 군집·공원 100 m 영역 집계, POI 연결 함수, alcyon(depthmapX 엔진) 대조 | `outputs/{AREA}/controls/` |
| [16_step15_context_controls.ipynb](16_step15_context_controls.ipynb) | **회귀 통제변수(주변 여건)**: ACS 인구·소득·학력, LODES 일자리, PLUTO 토지이용, 용도지역, 지하철, 공원 공급을 상업 영역과 주변 400 m로 집계 | `outputs/{AREA}/controls/` |
| [17_step16_poi_tables.ipynb](17_step16_poi_tables.ipynb) | **POI 배정·지표와 분석 표**: POI 배정 규칙(합성 점으로 점검), 공원·군집 단위 분석 표, D와 N의 일치 유형, VIF. `Data/Advan/`에 POI 파일을 넣으면 결과변수까지 채운다 | `outputs/{AREA}/analysis/` |

### 실행 방법
- 커널: `py13env` (Python 3.13, `cityseer==5.8.0`)
- STEP 14는 `igraph`가 필요하다. alcyon 대조 절은 R과 R 패키지 `alcyon`이 있을 때만 실행되고, 없으면 건너뛴다.
- STEP 15는 Census API 키가 필요하다. 저장소 루트의 `CensusAPIkey.txt`(git에서 제외됨)에 키를 한 줄로 넣는다. 원자료는 `Data/external/`(git에서 제외됨)에 받는다.
- 각 노트북의 첫 셀(공통 설정)에서 `STUDY_AREA`를 고른다: `"Brooklyn"`(파일럿) 또는 `"NYC"`(전체). 환경변수 `PARK_STUDY_AREA`로도 지정할 수 있다.
- STEP 1–3의 결과는 지역과 무관하다(NYC 전체, `Data/derived/network/`). STEP 4 이후 결과는 `Data/derived/{AREA}/`와 `outputs/{AREA}/`에 저장된다.
- 명령줄 실행 예:
  ```bash
  PARK_STUDY_AREA=NYC jupyter nbconvert --to notebook --execute --inplace \
    --ExecutePreprocessor.kernel_name=py13env --ExecutePreprocessor.timeout=-1 05_step4_angular_relations.ipynb
  ```
  STEP 4·5는 보로 단위 체크포인트를 쓰므로, 중단 후 다시 실행하면 이어서 진행한다.

## 핵심 설계 결정
- **공원 필터**:
  - 제외: `typecategory` = Flagship Park, 비공원성 필지(Operations, Lot, Undeveloped, Buildings/Institutions, Cemetery, Managed Sites)
  - 면적 100 acres 이하 → **1,902개 공원**
  - 면적 상한 50/200은 민감도 분석용
- **네트워크 표현**: 보도 네트워크(S)에서는 길 건너 공원이 보도→횡단보도→보도로 약 180°가 되는 인공물이 생긴다. 그래서 Space Syntax segment map에 대응하는 **C(가로 중심선 + 보행전용 경로)**를 주 분석으로 쓴다.
- **R(거리)은 탐색 한계로만** 사용한다. 공원 간 연결의 실질적 정의는 각도 기반이다.
- **네 가지 공원 네트워크 정의** (연구 개요 RQ3: walking distance, street-axis continuity, directional change):
  - **D** walking distance: 보행 최단거리 ≤ d(200/400/800 m). 근접성 기준선이다.
  - **N1** directional change(angular few-turn): 쌍별 최소 각도 비용 ≤ θ. 거리 구간 내 상대 기준(N1rel)은 보조.
  - **N2** street-axis continuity: 같은 각도 연속 가로(stroke) 위, 가로를 따라간 간격 ≤ lim(400/800/1600 m).
    - 큰길(상위 NACH) 여부는 연결 조건이 아니라 **군집 속성**(STEP 13)으로 쓴다. 큰길만 보면 대부분 공원이 빠지고, 모든 가로를 보면 N1과 약 60% 겹친다.
  - **N3** excess few-turn field overlap: 각도 생활권 겹침이 메트릭 생활권 겹침보다 큰 경우. 희소한(약한) 정의다.
- **E0**(attachment 공유·폴리곤 접촉)는 자명한 연결이므로 N1–N3에서 제외하고 별도 레이어로 둔다. D는 근접성 자체이므로 포함한다.
- **통일된 묶음 절차**(STEP 10, 네 정의 공통):
  1. 보로 단위 퍼콜레이션이 없는 설정만 사용
  2. 설정별 Louvain(γ = 2)
  3. 동반소속 합의 ≥ 0.5
  4. 도보 10분 지름 분할
  - N1만 각도 가중치를 쓴다.
- **회귀 단위**(STEP 13): 정의마다 모든 공원이 정확히 한 군집에 속한다(단독 공원 포함).
- **상업 영역**(STEP 13): 공원 가장자리에서 **보행망을 따라 100 m** 안에 있는 가로다. 직선 버퍼가 아니다.
  - 출발선은 공원에 붙은 가로 중 공원 경계 20 m 안의 구간이다. C 망은 중심선이라 공원 앞길은 길 양쪽이 모두 거리 0이다.
  - POI는 가장 가까운 가로 지점(50 m 이내)에 붙이고, 그 지점이 100 m 안이면 포함한다. 공원 부지 안의 POI는 뺀다.
  - **POI 배정**: 네트워크 거리가 가장 짧은 공원의 군집에 한 번만 넣는다(`nearest`, 주 분석). 닿는 모든 공원에 넣는 방식(`overlap`)은 민감도로 둔다.
  - 직선 100 m 버퍼(`buffer`)는 비교용으로 남긴다.
  - 밀도의 분모는 배정된 가로 길이(가로 100 m당 업소 수)가 주, 영역 면적이 보조다.
- **POPS(민간 소유 공공공간)는 쓰지 않는다.** 공원 집합은 NYC Parks 자료만이다.
- **가로 구조 통제변수**(STEP 14): 상업 활동 회귀에서 "큰길 효과"를 통제하는 용도이고, 공원 네트워크 정의에는 쓰지 않는다.
  - **Axial**: 진짜 axial map은 NYC 규모에서 만들 수 없어, 가로 중심선(C 망)에서 직선 조각을 뽑아 axial line으로 쓴다(허용 횡편차 10 m, 민감도 5·15 m). 선은 보행망의 같은 교차점을 지나면 연결된다.
  - 지표는 고전 정의(Mean Depth → RA → RRA → Integration(HH))이고, 같은 연결 그래프에서 alcyon과 수치가 일치한다. 본 계산은 Python(igraph)이고 alcyon은 검증에만 쓴다.
  - **Segment angular**: Cityseer 각도 중심성으로 만든 NAIN·NACH 유사 값(400/800/1600/3200 m).
  - 선이 1,000개 미만인 고립 시스템은 axial Integration·Choice를 비운다.
- **선형 공원 구간 분할**(STEP 3):
  - 대상: Parkway·Strip·Mall이거나 매우 길쭉한(compactness ≥ 20) 공원 중 지름 1 km 이상
  - 이런 공원은 약 400 m 구간으로 나눠 노드로 쓴다. 200 acres 상위집합 기준 32개 공원 → 274개 구간이고, 100 acres 이하 주 분석 대상만 보면 25개 공원 → 180개 구간이다.
  - 같은 공원의 구간끼리는 연결하지 않는다.
  - 수 km 길이의 공원 하나가 먼 공원들을 한 묶음으로 잇는 문제를 막기 위해서다.
- **묶음 = 커뮤니티, 고립 = 연결요소**: 관대한 설정(θ ≥ 90°)에서는 격자 도시 특성상 공원 대부분이 하나의 연결요소로 퍼콜레이션된다. 그래서 묶음은 Louvain 커뮤니티로 찾는다. 최종 N1 묶음은 퍼콜레이션이 없는 설정과 각도 가중치 exp(−A/45°)로 만들고, 해상도 γ = 1/2/4로 동네 → 블록 스케일을 제시한다.
  - 퍼콜레이션 판정은 **보로 단위**로 한다: 모든 보로에서 최대 연결요소가 그 보로 공원의 50% 미만인 설정만 쓴다(NYC 24개 중 9개).
  - 물로 나뉜 보로 때문에 시 전체 비율은 퍼콜레이션을 가리므로 보로 단위로 본다.
- **도보 10분 지름 제약**(STEP 10): 모든 최종 묶음(D·N1·N2·N3, 보조 N1rel·N1knn 포함)은 **묶음 안 모든 공원 쌍이 서로 도보 10분(보행망 최단거리 800 m, 1.33 m/s) 이내**다.
  - 방법: 합의 묶음마다 보행거리 complete-linkage로 800 m에서 분할한다.
  - 묶을 수 있는지는 각도 관계가, 묶음이 얼마나 넓어질 수 있는지는 거리가 정한다. 거리는 안전 한계로만 쓴다.
  - 10분 안에 함께 묶일 공원이 없는 공원은 `beyond_walk_limit` 상태가 된다.
  - 분할 전 묶음은 `*_nolimit` 열에 보존한다. 5·10·15분 민감도는 `regroup/walk_limit_sensitivity.csv`에 있다.
- **근접성 검증**: 탐색 한계 R 안에서 거리로 엣지를 예측하는 AUC(`AUC_condR`)로 판정한다. 0.85를 넘으면 근접성 지배로 본다.
- 1차 결과(선형 공원 분할 전)는 `outputs/_v1_nosplit/`에 보관했다.
