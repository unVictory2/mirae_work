import FinanceDataReader as fdr
from flask import Flask, request, jsonify
# 파이썬에서 가장 유명한 웹 프레임워크 flask, jango. 웹 서비스 애플리케이션 만들게 해줌
from flask_cors import CORS
# pip install finance-datareader
# pip install flask
# pip install flask_cors
# pip install beautifulsoup4
# pip install plotly > Installing collected packages: tenacity, packaging, ploty에서 멈출 경우 좀 기다리다 ctrl c

# 실행 후 크롬에서 http://127.0.0.1:8070/stock?page=1&ppv=20 에 접속.

app = Flask(__name__)
CORS(app)

# api 더 만들어서 사용 가능, 형태도 바꿔서 원하는 데이터 받아서.
# @app.route('/stock', methods=['GET'])
# def get_stock():
# 	stock_code= request.args.get('code')
# 	if stock_code is None:
# 		return jsonify({'error' : 'code is required'}), 400
# 	try:
# 		stock = fdr.DataReader 등

#FinDataReader한테 stock list 그냥 받아오면 양이 너무 많음. 그래서 페이지로 나누고 한 페이지에서 20개 정도만.
# base url = http://127.0.0.1/stock?page=1&ppv=20
@app.route('/stock', methods=['GET'])
def get_all_stock():
	#주소의 page=1에서의1 이 req_page에 들어옴
	req_page = request.args.get('page')
	if isinstance(req_page, str):
		req_page = int(req_page)

	# 안 주면 기본값은 1
	if req_page is None:
		req_page = 1

	# 잘못 준 경우. json 형태로 dictionary 데이터를 문자열로 바꿔서 반환. 400은 bad request. 200이 정상처리.
	if req_page < 1:
		return jsonify({'error' : 'page should be greater than 0'}), 400

	view_count = request.args.get('ppv')
	if isinstance(view_count, str):
		view_count = int(view_count)

	if view_count is None:
		view_count = 20

	if view_count < 1 :
		return jsonify({'error' : 'ppv should be greater than 0'}), 400
	
	start_idx = (req_page - 1) * view_count # 1페이지일 땐 0. 2페이지부터는 페이지-1 * 한 장에 몇 개 볼건지
	end_idx = start_idx + view_count # 예를 들어 한 페이지에 20개면, 인덱스는 20~40임.

	try:
		stock = fdr.StockListing('KRX') # 한국 거래서 상장종목 전체. stock은 데이터 프레임 = 정보가 전부 담겨있는 엑셀표.
		count = stock.shape[0] # shape = 데이터가 몇행 몇열짜리인지 줌. count는 전체 종목의 개수가 몇 개인지
		all_stock = []
		for i in range(start_idx, end_idx):
			stock_data = stock.iloc[i].to_dict() #iloc은 행번호. 가져온 주식 데이터를 python의 dictionary 형태로 stock_data에 넣는다. 종목명: 삼성전자, 가격: 70000 등이 하나의 딕셔너리가 되고
			all_stock.append(stock_data) ## 그게 all_stock 리스트에 20개까지 추가된다.

		output = {} # 최종적으로 보내는 것. 이 딕셔너리에 total count, total page, data 3개의 값이 있다. 
		#data는 리스트 형식이고, 이 리스트의 각 항목은 map으로 이루어져 있다.
		output['total_count'] = count
		pages = count // view_count # 전체 페이지 정보. 20개씩 페이지 가져왔을 때 몇 페이지까지 생성되는지. 프론트에서 처리 수월.
		output['total_page'] = pages if count % view_count == 0 else pages + 1 # 파이썬의 삼항 연산자. 조건은 if~else까지. 참이면 pages, 거짓이면 pages + 1
		output['data'] = all_stock

		return jsonify(output), 200

	except Exception as e:
		return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port = 8070) # 외부에서 내 pc로 http request 할 수 있게 허용
