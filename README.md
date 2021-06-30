# NaverSearchPlaceEx

장소검색을 구현

네이버 GeoCoding Api를 사용 해봤으나 주소로 입력 받아 상세정보를 갖고오는 Api 였다.
원하는 기능이 아님.
(Geocoding : 주소의 텍스트를 입력받아 좌표를 포함한 상세정보들을 제공합니다.)

장소검색이라는 키워드로 Api를 찾아봐서 Search Place Api를 사용 해보게 되었다.
(Search Place : 네이버 지역 서비스에 등록된 각 지역별 업체 및 상호 검색 결과를 출력해주는 REST API입니다)
원하는 기능이고, 잘 구현 되었으나 최대 5건 밖에 지원을 안한다고한다.
그 이유는 트래픽 문제라고 한다.. 
[참고클릭](https://developers.naver.com/notice/article/10000000000030669276)

기존에 네이버 클라우드센터에서도 Search Place Api 를 서비스 했다고 하는데 
클라우드센터는 건수 제한이 없었다고한다. (Poi Api이기 때문에?? 미들웨어??)
그래서 현재 Search Place Api는 네이버 개발자 센터에만 존재한다.
