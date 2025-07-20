# !/usr/bin/python3
# coding=utf-8


#################################################################################

# Title: Python3 statistical algorithm server v20161211
# Explain: Python3 file server, Python3 http server, Python3 http client
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在丙申
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
# Interpreter: python-3.11.2-amd64.exe
# Interpreter: Python-3.11.2-tar.xz, Python-3.11.2-amd64.deb
# Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
# Interpreter: Python-3.10.6-tar.xz, python3-3.10.6-aarch64.deb

# 使用説明：
# 控制臺命令列運行指令：
# C:\StatisticalServer> C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/StatisticalAlgorithmServer.py configFile=C:/StatisticalServer/StatisticalServerPython/config.txt webPath=C:/StatisticalServer/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=C:/StatisticalServer/Intermediary/ monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=C:/StatisticalServer/Intermediary/ output_file=C:/StatisticalServer/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=C:/StatisticalServer/temp/
# root@localhost:~# /usr/bin/python3 /home/StatisticalServer/StatisticalServerPython/StatisticalAlgorithmServer.py configFile=/home/StatisticalServer/StatisticalServerPython/config.txt webPath=/home/StatisticalServer/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/

#################################################################################


# import platform  # 加載Python原生的與平臺屬性有關的模組;
import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
# import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型;
# import importlib  # 導入 Python 内置熱重載模組，用於熱重載熱更新外部 .py 脚本文檔裏的變量值;
import ast  # 導入 Python 内置模組，用於安全評估字面量或容器，使用 ast.literal_eval() 函數將字符串 "False" 轉換爲布爾型 False 數據;
# import subprocess  # 加載Python原生的創建子進程模組;
import string  # 加載Python原生的字符串處理模組;
import datetime, time  # 加載Python原生的日期數據處理模組;
import json  # import the module of json. 加載Python原生的Json處理模組;
# import re  # 加載Python原生的正則表達式對象
# from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
import struct  # 用於讀、寫、操作二進制本地硬盤文檔;
import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
# import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
# import threading  # 加載Python原生的支持多綫程（執行緒）模組;
# from socketserver import ThreadingMixIn  #, ForkingMixIn
# import inspect, ctypes  # 用於强制終止綫程;
# import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
# import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
# from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
# # https: // docs.python.org/3/library/http.server.html
# from http import cookiejar  # 用於處理請求Cookie;
# import socket  # 加載Python原生的套接字模組socket、配置服務器支持 IPv6 格式地址;
# import ssl  # 用於處理請求證書驗證;
import base64  # 加載加、解密模組;
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)
import math  # 導入 Python 原生包「math」，用於數學計算;

# # 棄用控制臺打印警告信息;
# def fxn():
#     warnings.warn("deprecated", DeprecationWarning)  # 棄用控制臺打印警告信息;
# with warnings.catch_warnings():
#     warnings.simplefilter("ignore")
#     fxn()
# with warnings.catch_warnings(record=True) as w:
#     # Cause all warnings to always be triggered.
#     warnings.simplefilter("always")
#     # Trigger a warning.
#     fxn()
#     # Verify some things
#     assert len(w) == 1
#     assert issubclass(w[-1].category, DeprecationWarning)
#     assert "deprecated" in str(w[-1].message)


# 導入第三方擴展包，需要事先已經在操作系統控制臺命令行安裝配置成功;
# 先升級 pip 擴展包管理工具：root@localhost:~# python -m pip install --upgrade pip
# 再安裝第三方擴展包：root@localhost:~# pip install flask -i https://pypi.mirrors.ustc.edu.cn/simple
# 在專案中導入Flask模組，Flask類的一個對象是我們的WSGI應用程式;
# from flask import flask, request, jsonify, abort, make_response

# 導入第三方擴展包，需要事先已經在操作系統控制臺命令行安裝配置成功;
# 先升級 pip 擴展包管理工具：root@localhost:~# python -m pip install --upgrade pip
# 再安裝第三方擴展包：root@localhost:~# pip install sympy -i https://pypi.mirrors.ustc.edu.cn/simple
import numpy  # as np
# import pandas  # as pd
# from pandas import Series as pandas_Series  # 從第三方擴展包「pandas」中導入一維向量「Series」模組，用於構建擴展包「pandas」的一維向量「Series」類型變量;
# from pandas import DataFrame as pandas_DataFrame  # 從第三方擴展包「pandas」中導入二維矩陣「DataFrame」模組，用於構建擴展包「pandas」的二維矩陣「DataFrame」類型變量;
# import matplotlib  # as mpl
# import matplotlib.pyplot as matplotlib_pyplot
# import matplotlib.font_manager as matplotlib_font_manager  # 導入第三方擴展包「matplotlib」中的字體管理器，用於設置生成圖片中文字的字體;
# import seaborn  # as sns
# https://docs.sympy.org/latest/tutorial/preliminaries.html#installation
# import sympy  # 導入第三方擴展包「sympy」，用於符號計算;
# https://www.scipy.org/docs.html
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合插值函數;
# # https://www.statsmodels.org/stable/index.html
# import statsmodels.api as statsmodels_api  # 導入第三方擴展包「statsmodels」中的「api()」函數，用於模型方程式擬合自定義函數;
# import statsmodels.formula.api as statsmodels_formula_api  # 導入第三方擴展包「statsmodels」中的公式模組「formula」中的「api()」函數，用於模型方程式擬合;


# 匯入自定義路由模組脚本文檔「./Interpolation_Fitting.py」;
# 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
import Quantitative_Indicators as Quantitative_Indicators  # 加載自定義算法模組，導入本地自定義的日棒缐（K Line）趨勢指標計算模組;
Intuitive_Momentum = Quantitative_Indicators.Intuitive_Momentum
Intuitive_Momentum_KLine = Quantitative_Indicators.Intuitive_Momentum_KLine
import Quantitative_MarketTiming as Quantitative_MarketTiming  # 加載自定義算法模組，導入本地自定義的日棒缐（K Line）趨勢交易擇時計算模組;
MarketTiming_fit_model = Quantitative_MarketTiming.MarketTiming_fit_model
MarketTiming = Quantitative_MarketTiming.MarketTiming
import Quantitative_PickStock as Quantitative_PickStock  # 加載自定義算法模組，導入本地自定義的日棒缐（K Line）趨勢交易選股計算模組;
PickStock_fit_model = Quantitative_PickStock.PickStock_fit_model
PickStock = Quantitative_PickStock.PickStock
import Quantitative_SizePosition as Quantitative_SizePosition  # 加載自定義算法模組，導入本地自定義的日棒缐（K Line）趨勢交易倉位計算模組;
SizePosition_fit_model = Quantitative_SizePosition.SizePosition_fit_model
SizePosition = Quantitative_SizePosition.SizePosition
import Quantitative_BackTesting as Quantitative_BackTesting  # 加載自定義算法模組，導入本地自定義的日棒缐（K Line）趨勢交易步進（Stepper movement）回測計算模組;
BackTesting_Stepper = Quantitative_BackTesting.BackTesting_Stepper

# 匯入自定義路由模組脚本文檔「./Interpolation_Fitting.py」;
# os.getcwd() # 獲取當前工作目錄路徑;
# os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# os.path.join(os.path.abspath("."), 'Interpolation_Fitting.py')  # 拼接路徑字符串;
# pathlib.Path(os.path.join(os.path.abspath("."), Interpolation_Fitting.py)  # 返回路徑對象;
# sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
import Interpolation_Fitting as Interpolation_Fitting  # 加載自定義算法模組，自定義的用於曲綫擬合的模組，導入當前運行代碼所在目錄的，自定義脚本文檔「./Interpolation_Fitting.py」;
LC5Pfit = Interpolation_Fitting.LC5Pfit
Polynomial3Fit = Interpolation_Fitting.Polynomial3Fit
MathInterpolation = Interpolation_Fitting.MathInterpolation



# 示例函數，處理從硬盤文檔讀取到的字符串數據，然後返回處理之後的結果字符串數據的;
def do_data(require_data_String):

    # print(require_data_String)
    # print(typeof(require_data_String))

    # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    if check_json_format(require_data_String):
        # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
        require_data_JSON = json.loads(require_data_String)  # , encoding='utf-8'
    else:
        now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
        require_data_JSON = {
            "Client_say": require_data_String,
            "time": str(now_date)
        }
    # print(require_data_JSON)
    # print(typeof(require_data_JSON))

    Client_say = ""
    # 使用函數 isinstance(require_data_JSON, dict) 判斷傳入的參數 require_data_JSON 是否為 dict 字典（JSON）格式對象;
    if isinstance(require_data_JSON, dict):
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if (require_data_JSON.__contains__("Client_say")):
            Client_say = require_data_JSON["Client_say"]
        else:
            Client_say = ""
            # print('客戶端發送的請求 JSON 對象中無法找到目標鍵(key)信息 ["Client_say"].')
            # print(require_data_JSON)
    else:
        Client_say = require_data_JSON

    Server_say = Client_say  # "require no problem."
    # if Client_say == "How are you" or Client_say == "How are you." or Client_say == "How are you!" or Client_say == "How are you !":
    #     Server_say = "Fine, thank you, and you ?"
    # else:
    #     Server_say = "我現在只會説：「 Fine, thank you, and you ? 」，您就不能按規矩說一個：「 How are you ! 」"
    # Server_say = Server_say.decoding("utf-8")

    now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    # print(now_date)
    response_data_JSON = {
        "Server_say": Server_say,
        "require_Authorization": "",
        "time": str(now_date)
    }
    # check_json_format(request_data_JSON);
    # String = json.dumps(JSON); JSON = json.loads(String);

    response_data_String = Server_say
    if isinstance(response_data_JSON, dict):
        response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;

    # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
    # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
    response_data_bytes = response_data_String.encode("utf-8")
    response_data_String_len = len(bytes(response_data_String, "utf-8"))

    return response_data_String



webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
Key = "username:password"
Session = {
    "request_Key->username:password": Key
}

# 示例函數，處理從客戶端 GET 或 POST 請求的信息，然後返回處理之後的結果JSON對象字符串數據;
def do_Request(request_Dict):
    # request_Dict = {
    #     "Client_IP": Client_IP,
    #     "request_Url": request_Url,
    #     # "request_Path": request_Path,
    #     "require_Authorization": self.request_Key,
    #     "require_Cookie": self.Cookie_value,
    #     # "Server_Authorization": Key,
    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
    #     "request_body_string": request_form_value
    # }

    # print(type(request_Dict))
    # print(request_Dict)

    request_POST_String = ""  # request_Dict["request_body_string"];  # 客戶端發送 post 請求時的請求體數據;
    request_Url = ""  # request_Dict["request_Url"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
    request_Path = ""  # request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
    request_Url_Query_String = ""  # request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
    request_Url_Query_Dict = {}  # 客戶端請求 url 中的查詢字符串值解析字典 {"a": 1, "b": 2};
    request_Authorization = ""  # request_Dict["require_Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
    request_Cookie = ""  # request_Dict["require_Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
    request_Key = ""
    request_Nikename = ""  # request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
    request_Password = ""  # request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
    # request_time = ""  # request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
    # request_Date = ""  # request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
    request_IP = ""  # request_Dict["Client_IP"];  # 客戶端發送請求的 IP 地址字符串;
    # request_Method = ""  # request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
    request_Host = ""  # request_Dict["Host"];  # 客戶端發送請求的服務器主機域名或 IP 地址值字符串 "127.0.0.1"、"localhost";
    # request_Protocol = ""  # request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "http:"、"https:";
    request_User_Agent = ""  # request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
    request_From = ""  # request_Dict["From"];  # 客戶端發送請求的來源值字符串;

    # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
    if request_Dict.__contains__("Host"):
        # print(request_Dict["Host"])
        request_Host = request_Dict["Host"]
    if request_Dict.__contains__("request_Url"):
        # print(request_Dict["request_Url"])
        request_Url = request_Dict["request_Url"]
        # request_Url = request_Url.decode('utf-8')
    # if request_Dict.__contains__("request_Path"):
    #     # print(request_Dict["request_Path"])
    #     request_Path = request_Dict["request_Path"]
    #     # request_Path = request_Path.decode('utf-8')
    # if request_Dict.__contains__("request_Url_Query_String"):
    #     # print(request_Dict["request_Url_Query_String"])
    #     request_Url_Query_String = request_Dict["request_Url_Query_String"]
    #     # request_Url_Query_String = request_Url_Query_String.decode('utf-8')
    if request_Dict.__contains__("Client_IP"):
        # print(request_Dict["Client_IP"])
        request_IP = request_Dict["Client_IP"]
    if request_Dict.__contains__("require_Authorization"):
        # print(request_Dict["require_Authorization"])
        request_Authorization = request_Dict["require_Authorization"]
    if request_Dict.__contains__("require_Cookie"):
        # print(request_Dict["require_Cookie"])
         request_Cookie = request_Dict["require_Cookie"]
    if request_Dict.__contains__("request_body_string"):
        # print(request_Dict["request_body_string"])
        request_POST_String = request_Dict["request_body_string"]
        # request_POST_String = request_POST_String.decode('utf-8')
    # if request_Dict.__contains__("time"):
    #     print(request_Dict["time"])
    #     request_time = request_Dict["time"]

    # # print(request_Authorization)
    # # 使用請求頭信息「self.headers["Authorization"]」簡單驗證訪問用戶名和密碼，"Basic username:password";
    # if request_Authorization != None and request_Authorization != "":
    #     # print("request Headers Authorization: ", request_Authorization)
    #     # print("request Headers Authorization: ", request_Authorization.split(" ", -1)[0], base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False))
    #     # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
    #     # print(type(base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False)))

    #     # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
    #     if request_Authorization.find("Basic", 0, int(len(request_Authorization)-1)) != -1 and request_Authorization.split(" ", -1)[0] == "Basic" and len(request_Authorization.split("Basic ", -1)) > 1 and request_Authorization.split("Basic ", -1)[1] != "":
    #         request_Key = str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
    #         request_Authorization = "Basic " + str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "Basic username:password";
    #         request_Nikename = request_Key.split(":", -1)[0]
    #         request_Password = request_Key.split(":", -1)[1]
    #     # print(type(request_Key))
    #     # print(request_Key)

    # # print(request_Cookie)
    # # 使用請求頭信息「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼，"Session_ID=request_Key->username:password";
    # if request_Cookie != None and request_Cookie != "":
    #     Cookie_value = request_Cookie
    #     # print("request Headers Cookie: ", self.headers["Cookie"])
    #     # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
    #     # request_Key = eval("'" + str(Cookie_value.split("=", -1)[1]) + "'", {'request_Key' : ''})  # exec('request_Key="username:password"', {'request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

    #     # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
    #     if Cookie_value.find("=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.find("Session_ID=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.split("=", -1)[0] == "Session_ID":
    #         Session_ID = str(base64.b64decode(Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
    #     else:
    #         Session_ID = str(base64.b64decode(Cookie_value, altchars=None, validate=False), encoding="utf-8")

    #     # print(type(Session_ID))
    #     # print(Session_ID)

    #     request_Key = Session_ID.split("request_Key->", -1)[1]
    #     request_Cookie = "Session_ID=" + Session_ID  # "Session_ID=request_Key->username:password";
    #     request_Nikename = request_Key.split(":", -1)[0]
    #     request_Password = request_Key.split(":", -1)[1]

    #     # # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
    #     # if Session_ID != None and Session_ID != "" and type(Session_ID) == str and Session.__contains__(Session_ID) == True and Session[Session_ID] != None:
    #     #     request_Key = str(Session[Session_ID])
    #     #     # print(type(request_Key))
    #     #     # print(request_Key)
    #     # else:
    #     #     # request_Key = ":"
    #     #     request_Key = ""

    #     # print(type(request_Key))
    #     # print(request_Key)
    #     # print(Key)


    if request_Url != "":
        if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
            request_Path = str(request_Url.split("?", -1)[0])
        elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
            request_Path = str(request_Url.split("#", -1)[0])
        else:
            request_Path = str(request_Url)

        if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
            request_Url_Query_String = str(request_Url.split("?", -1)[1])
            if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])

    # print(request_Url_Query_String)
    if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
        if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
            # for i in range(0, len(request_Url_Query_String.split("&", -1))):
            for query_item in request_Url_Query_String.split("&", -1):
                if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                    temp_split_Array = query_item.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                    request_Url_Query_Dict[query_item] = ""
        else:
            if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                temp_split_Array = request_Url_Query_String.split("=", -1)
                temp_split_value = ""
                if len(temp_split_Array) > 1:
                    for i in range(1, len(temp_split_Array)):
                        if int(i) == int(1):
                            temp_split_value = temp_split_value + str(temp_split_Array[i])
                        if int(i) > int(1):
                            temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
            else:
                # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                request_Url_Query_Dict[request_Url_Query_String] = ""
    # print(request_Url_Query_Dict)

    # urllib.parse.urlparse(self.path)
    # urllib.parse.urlparse(self.path).path
    # parse_qs(urllib.parse.urlparse(self.path).query)
    fileName = "";  # "/PythonServer.py" 自定義的待替換的文件路徑全名;
    algorithmUser = "";  # 使用算法的驗證賬號;
    algorithmPass = "";  # 使用算法的驗證密碼;
    algorithmName = "";  # "Fitting"、"Simulation" 具體算法的名稱;
    global Key  # 變量 Key 為全局變量;
    # 使用函數 isinstance(request_Url_Query_Dict, dict) 判斷傳入的參數 request_Url_Query_Dict 是否為 dict 字典（JSON）格式對象;
    if isinstance(request_Url_Query_Dict, dict):
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if (request_Url_Query_Dict.__contains__("fileName")):
            fileName = str(request_Url_Query_Dict["fileName"])
        if (request_Url_Query_Dict.__contains__("algorithmUser")):
            algorithmUser = str(request_Url_Query_Dict["algorithmUser"])
        if (request_Url_Query_Dict.__contains__("algorithmPass")):
            algorithmPass = str(request_Url_Query_Dict["algorithmPass"])
        if (request_Url_Query_Dict.__contains__("algorithmName")):
            algorithmName = str(request_Url_Query_Dict["algorithmName"])
        if (request_Url_Query_Dict.__contains__("Key")):
            Key = str(request_Url_Query_Dict["Key"])


    # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
    request_data_Dict = {}  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
    # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
    # if check_json_format(request_POST_String):
    #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
    #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
    # # print(request_data_Dict)

    response_data_Dict = {}  # 函數返回值，聲明一個空字典;
    response_data_String = ""

    return_file_creat_time = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))
    # print(return_file_creat_time)

    response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)};
    # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)};
    # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)};
    # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)};
    response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)};
    response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)};
    # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)};
    # response_data_Dict["request_Password"] = str(request_Password)  # {"request_Password": str(request_Password)};
    response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)};
    # response_data_Dict["Server_Authorization"] = str(key)  # "username:password"，{"Server_Authorization": str(key)};
    response_data_Dict["Server_say"] = str("")  # {"Server_say": str(request_POST_String)};
    response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)};
    # print(response_data_Dict)

    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
    # # 使用加號（+）拼接字符串;
    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
    # # print(response_data_String)

    # webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
    web_path = "";  # str(os.path.join(os.path.abspath("."), str(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
    file_data = "";  # 用於保存從硬盤讀取文檔中的數據;
    dir_list_Arror = [];  # 用於保存從硬盤讀取文件夾中包含的子文檔和子文件夾名稱清單的字符串數組;

    if request_Path == "/":
        # 客戶端或瀏覽器請求 url = http://username:password@[::1]:10001/?Key=username:password&algorithmUser=username&algorithmPass=password
        # 客戶端或瀏覽器請求 url = http://username:password@127.0.0.1:10001/?Key=username:password&algorithmUser=username&algorithmPass=password
        # 客戶端或瀏覽器請求 url = http://username:password@localhost:10001/?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), "index.html"))  # 拼接本地當前目錄下的請求文檔名;
        file_data = ""

        Select_Statistical_Algorithms_HTML_path = str(os.path.join(str(webPath), "SelectStatisticalAlgorithms.html"))  # 拼接本地當前目錄下的請求文檔名;
        Select_Statistical_Algorithms_HTML = ""  # '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Select_Statistical_Algorithms_HTML_path) and os.path.isfile(Select_Statistical_Algorithms_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Select_Statistical_Algorithms_HTML_path, os.R_OK) and os.access(Select_Statistical_Algorithms_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Select_Statistical_Algorithms_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Select_Statistical_Algorithms_HTML_path, mode="rb+")
            try:
                Select_Statistical_Algorithms_HTML = fd.read()
                # Select_Statistical_Algorithms_HTML = fd.read().decode("utf-8")
                # data_Bytes = Select_Statistical_Algorithms_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Input_HTML_path = str(os.path.join(str(webPath), "InputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Input_HTML = ""  # '<table id="InputTable" style="border-collapse:collapse; display: block;"><thead id="InputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</th></tr></thead><tfoot id="InputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</td></tr></tfoot><tbody id="InputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.00001</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">98</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">102</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">90</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">150</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">148</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">152</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.5</td></tr><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">4</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td></tr></tbody></table>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Input_HTML_path) and os.path.isfile(Input_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Input_HTML_path, os.R_OK) and os.access(Input_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Input_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Input_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Input_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Input_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Input_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Input_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Input_HTML_path, mode="rb+")
            try:
                Input_HTML = fd.read()
                # Input_HTML = fd.read().decode("utf-8")
                # data_Bytes = Input_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Output_HTML_path = str(os.path.join(str(webPath), "OutputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Output_HTML = ""  # '<table id="OutputTable" style="border-collapse:collapse; display: block;"><thead id="OutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</th></tr></thead><tfoot id="OutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</td></tr></tfoot><tbody id="OutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">100.007982422761</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00781790123184812</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.9908250045862</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.025139840936</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.008980483748</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.0089499294379</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">101.00901103813</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00898048374801874</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500050586546119</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.499936310423273</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500160692642957</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">149.99494193308</td></tr><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">42148.4577551448</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">2104.76673086505</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">37529.2688077105</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">46767.6467025791</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">199.99155580718</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198.991136273453</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200.991951293373</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-0.00844419281929731</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00008444458554</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.999794808816128</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00036584601127</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">199.99155580718</td></tr></tbody></table><canvas id="OutputCanvas" width="300" height="150" style="display: block;"></canvas>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Output_HTML_path) and os.path.isfile(Output_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Output_HTML_path, os.R_OK) and os.access(Output_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Output_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Output_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Output_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Output_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Output_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Output_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Output_HTML_path, mode="rb+")
            try:
                Output_HTML = fd.read()
                # Output_HTML = fd.read().decode("utf-8")
                # data_Bytes = Output_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = file_data
            response_data_String = str(response_data_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Input_HTML -->", Input_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Output_HTML -->", Output_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/index.html":
        # 客戶端或瀏覽器請求 url = http://username:password@[::1]:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password
        # 客戶端或瀏覽器請求 url = http://username:password@127.0.0.1:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password
        # 客戶端或瀏覽器請求 url = http://username:password@localhost:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        file_data = ""

        Select_Statistical_Algorithms_HTML_path = str(os.path.join(str(webPath), "SelectStatisticalAlgorithms.html"))  # 拼接本地當前目錄下的請求文檔名;
        Select_Statistical_Algorithms_HTML = ""  # '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Select_Statistical_Algorithms_HTML_path) and os.path.isfile(Select_Statistical_Algorithms_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Select_Statistical_Algorithms_HTML_path, os.R_OK) and os.access(Select_Statistical_Algorithms_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Select_Statistical_Algorithms_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Select_Statistical_Algorithms_HTML_path, mode="rb+")
            try:
                Select_Statistical_Algorithms_HTML = fd.read()
                # Select_Statistical_Algorithms_HTML = fd.read().decode("utf-8")
                # data_Bytes = Select_Statistical_Algorithms_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Input_HTML_path = str(os.path.join(str(webPath), "InputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Input_HTML = ""  # '<table id="InputTable" style="border-collapse:collapse; display: block;"><thead id="InputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</th></tr></thead><tfoot id="InputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</td></tr></tfoot><tbody id="InputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.00001</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">98</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">102</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">90</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">150</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">148</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">152</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.5</td></tr><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">4</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td></tr></tbody></table>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Input_HTML_path) and os.path.isfile(Input_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Input_HTML_path, os.R_OK) and os.access(Input_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Input_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Input_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Input_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Input_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Input_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Input_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Input_HTML_path, mode="rb+")
            try:
                Input_HTML = fd.read()
                # Input_HTML = fd.read().decode("utf-8")
                # data_Bytes = Input_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Output_HTML_path = str(os.path.join(str(webPath), "OutputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Output_HTML = ""  # '<table id="OutputTable" style="border-collapse:collapse; display: block;"><thead id="OutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</th></tr></thead><tfoot id="OutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</td></tr></tfoot><tbody id="OutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">100.007982422761</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00781790123184812</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.9908250045862</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.025139840936</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.008980483748</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.0089499294379</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">101.00901103813</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00898048374801874</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500050586546119</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.499936310423273</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500160692642957</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">149.99494193308</td></tr><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">42148.4577551448</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">2104.76673086505</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">37529.2688077105</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">46767.6467025791</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">199.99155580718</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198.991136273453</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200.991951293373</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-0.00844419281929731</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00008444458554</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.999794808816128</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00036584601127</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">199.99155580718</td></tr></tbody></table><canvas id="OutputCanvas" width="300" height="150" style="display: block;"></canvas>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Output_HTML_path) and os.path.isfile(Output_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Output_HTML_path, os.R_OK) and os.access(Output_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Output_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Output_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Output_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Output_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Output_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Output_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Output_HTML_path, mode="rb+")
            try:
                Output_HTML = fd.read()
                # Output_HTML = fd.read().decode("utf-8")
                # data_Bytes = Output_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = file_data
            response_data_String = str(response_data_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Input_HTML -->", Input_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Output_HTML -->", Output_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/administrator.html":
        # 客戶端或瀏覽器請求 url = http://username:password@[::1]:10001/administrator.html?Key=username:password&algorithmUser=username&algorithmPass=password
        # 客戶端或瀏覽器請求 url = http://username:password@127.0.0.1:10001/administrator.html?Key=username:password&algorithmUser=username&algorithmPass=password
        # 客戶端或瀏覽器請求 url = http://username:password@localhost:10001/administrator.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        file_data = ""

        directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

        # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組，使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if os.path.exists(webPath) and pathlib.Path(webPath).is_dir():
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(webPath, os.R_OK) and os.access(webPath, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(webPath, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(webPath, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(webPath, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(webPath, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(webPath, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(webPath)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = f'Error: {str(webPath)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(webPath)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(webPath))
            # if len(os.listdir(webPath)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(webPath), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:
                # print(directoryHTML)
        else:
            print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 不存在或無法識別.")

            response_data_Dict["Server_say"] = "服務器的運行路徑: " + str(webPath) + " 無法識別."
            response_data_Dict["error"] = "Folder = { " + str(webPath) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/uploadFile":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py

        if fileName == "":
            print("Upload file name empty { " + str(fileName) + " }.")
            response_data_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " + str(fileName) + " } 爲空."
            response_data_Dict["error"] = "File name = { " + str(fileName) + " } empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        # print(fileName)
        web_path = ""
        if fileName[0] == '/' or fileName[0] == '\\':
            web_path = str(os.path.join(str(webPath), str(fileName[1:len(fileName)])))  # 拼接待替換寫入的目標文檔名（絕對路徑），如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
        else:
            web_path = str(os.path.join(str(webPath), str(fileName)))  # 拼接待替換寫入的目標文檔名（絕對路徑）;
        # print(web_path)

        file_data = str(request_POST_String)  # 向目標文檔中寫入的内容字符串;
        # file_data_bytes = file_data.encode("utf-8")
        # file_data_len = len(bytes(file_data, "utf-8"))
        # file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象 file_data_integer_Array = json.loads(file_data, encoding='utf-8');
        # file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
        # file_data = file_data.encode('utf-8')
        # file_data_bytes_Array = []  # 字符串轉換後的二進制字節流數組;
        # for i in range(0, int(len(file_data_integer_Array))):
        #     # itemBytes = bytes(int(file_data_integer_Array[i]), "utf-8")
        #     # itemBytes = str(file_data_integer_Array[i]).encode('utf-8')  # 字符串轉二進制字節流;
        #     itemBytes = struct.pack('B', int(file_data_integer_Array[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
        #     # itemBytes.decode("utf-8")  # 二進制字節流轉字符串;
        #     # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
        #     # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
        #     file_data_bytes_Array.append(itemBytes)

        # 同步寫入或創建硬盤目標文檔：首先判斷指定的待寫入文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("目標寫入文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(fileName) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            # 刪除指定的待寫入文檔;
            try:
                os.remove(web_path)  # 刪除文檔
            except OSError as error:
                print(f'Error: {str(web_path)} : {error.strerror}')
                print("目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據.")
                response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 已存在且無法刪除，以重新創建更新數據."
                response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String

            # # 判斷指定的待寫入文檔，是否已經從硬盤刪除;
            # if os.path.exists(web_path) and os.path.isfile(web_path):
            #     print("目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據.")
            #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據."
            #     response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String

        else:

            # 截取目標寫入目錄;
            writeDirectory = ""
            # print(fileName)
            if isinstance(fileName, str) and fileName.find("/", 0, int(len(fileName)-1)) != -1:
                tempArray = []
                tempArray = fileName.split("/", -1)
                if len(tempArray) <= 2:
                    writeDirectory = "/"
                else:
                    for i in range(0, int(len(tempArray) - int(1))):
                        if i == 0:
                            writeDirectory = str(tempArray[i])
                        else:
                            writeDirectory = writeDirectory + "/" + str(tempArray[i])
            elif isinstance(fileName, str) and fileName.find("\\", 0, int(len(fileName)-1)) != -1:
                tempArray = []
                tempArray = fileName.split("\\", -1)
                if len(tempArray) <= 2:
                    writeDirectory = "\\"
                else:
                    for i in range(0, int(len(tempArray) - int(1))):
                        if i == 0:
                            writeDirectory = str(tempArray[i])
                        else:
                            writeDirectory = writeDirectory + "\\" + str(tempArray[i])
            else:
                writeDirectory = "/"
            # print(writeDirectory)
            AbsolutewriteDirectory = ""
            if writeDirectory[0] == '/' or writeDirectory[0] == '\\':
                AbsolutewriteDirectory = str(os.path.join(str(webPath), str(writeDirectory[1:len(writeDirectory)])))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名，如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
            else:
                AbsolutewriteDirectory = str(os.path.join(str(webPath), str(writeDirectory)))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名;
            # print(AbsolutewriteDirectory)

            # 判斷目標寫入目錄（文件夾）是否存在，如果不存在則創建;
            # 使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            if os.path.exists(AbsolutewriteDirectory) and pathlib.Path(AbsolutewriteDirectory).is_dir():
                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(AbsolutewriteDirectory, os.R_OK) and os.access(AbsolutewriteDirectory, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(AbsolutewriteDirectory, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(AbsolutewriteDirectory, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(AbsolutewriteDirectory)} : {error.strerror}')
                        print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法修改為可讀可寫權限.")
                        response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = f'Error: {str(writeDirectory)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
            else:
                try:
                    # print(AbsolutewriteDirectory)
                    os.makedirs(AbsolutewriteDirectory, mode=0o777, exist_ok=True)
                    # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                    # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
                except FileExistsError as error:
                    # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
                    print(f'Error: {str(AbsolutewriteDirectory)} : {error.strerror}')
                    print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法創建.")
                    response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法創建."
                    response_data_Dict["error"] = f'Error: {str(writeDirectory)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            # # 判斷指定的寫入目錄（文件夾）是否創建成功;
            # if not (os.path.exists(AbsolutewriteDirectory) and pathlib.Path(AbsolutewriteDirectory).is_dir()):
            #     print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法創建.")
            #     response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法創建."
            #     response_data_Dict["error"] = f'Directory: ( {str(writeDirectory)} ) cannot be created.'
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String


        # # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔，以字符串形式寫入純文本文檔;
        # fd = open(web_path, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
        # # fd = open(web_path, mode="wb+")
        # try:
        #     numBytes = fd.write(file_data)  # 寫入字符串，返回值為寫入的字符數目;
        #     # file_data_bytes = file_data.encode("utf-8")
        #     # file_data_len = len(bytes(file_data, "utf-8"))
        #     # fd.write(file_data_bytes)
        #     response_data_Dict["Server_say"] = "向文檔: " + str(fileName) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
        #     # response_data_Dict["Server_say"] = "向文檔: " + str(web_path) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
        #     response_data_Dict["error"] = ""
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     # return response_data_String
        # except FileNotFoundError:
        #     print("目標替換文檔 [ " + str(web_path) + " ] 創建失敗.")
        #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 創建失敗."
        #     response_data_Dict["error"] = "File [ " + str(fileName) + " ] creation failed."
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     return response_data_String
        # except PersmissionError:
        #     print("目標替換文檔 [ " + str(web_path) + " ] 沒有打開權限.")
        #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 沒有打開權限."
        #     response_data_Dict["error"] = "File [ " + str(fileName) + " ]  unable to write."
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     return response_data_String
        # finally:
        #     fd.close()
        # # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


        # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔，以字節流形式寫入二進制文檔;
        fd = open(web_path, mode="wb+", buffering=-1)
        # fd = open(web_path, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
        try:
            file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象 file_data_integer_Array = json.loads(file_data, encoding='utf-8');
            # file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
            # file_data = file_data.encode('utf-8')
            numBytes = int(0)  # 寫入的縂字節數;
            # file_data_bytes_Array = []  # 字符串轉換後的二進制字節流數組;
            for i in range(0, int(len(file_data_integer_Array))):
                # itemBytes = bytes(int(file_data_integer_Array[i]), "utf-8")
                # itemBytes = str(file_data_integer_Array[i]).encode('utf-8')  # 字符串轉二進制字節流;
                itemBytes = struct.pack('B', int(file_data_integer_Array[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
                # itemBytes.decode("utf-8")  # 二進制字節流轉字符串;
                # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
                # file_data_bytes_Array.append(itemBytes)
                numWriteBytes = fd.write(itemBytes)  # 寫入一個二進制字節;
                numBytes = int(numBytes) + int(numWriteBytes)  # 纍計寫入文檔的字節數目;

            response_data_Dict["Server_say"] = "向文檔: " + str(fileName) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
            # response_data_Dict["Server_say"] = "向文檔: " + str(web_path) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
            response_data_Dict["error"] = ""
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            # return response_data_String
        except FileNotFoundError:
            print("目標替換文檔 [ " + str(web_path) + " ] 創建失敗.")
            response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 創建失敗."
            response_data_Dict["error"] = "File [ " + str(fileName) + " ] creation failed."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String
        except PersmissionError:
            print("目標替換文檔 [ " + str(web_path) + " ] 沒有打開權限.")
            response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 沒有打開權限."
            response_data_Dict["error"] = "File [ " + str(fileName) + " ]  unable to write."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String
        finally:
            fd.close()
        # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        return response_data_String

    elif request_Path == "/deleteFile":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py

        if fileName == "":
            print("Upload file name empty { " + str(fileName) + " }.")
            response_data_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " + str(fileName) + " } 爲空."
            response_data_Dict["error"] = "File name = { " + str(fileName) + " } empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        if fileName != "":

            # print(fileName)
            web_path = ""
            if fileName[0] == '/' or fileName[0] == '\\':
                web_path = str(os.path.join(str(webPath), str(fileName[1:len(fileName)])))  # 拼接待替換寫入的目標文檔名（絕對路徑），如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
            else:
                web_path = str(os.path.join(str(webPath), str(fileName)))  # 拼接待替換寫入的目標文檔名（絕對路徑）;
            # print(web_path)

            file_data = str(request_POST_String)  # 客戶端 POST 請求的内容字符串;

            if os.path.exists(web_path) and os.path.isfile(web_path):

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path)} : {error.strerror}')
                        print("目標待刪除文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                        response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = "File = { " + str(fileName) + " } cannot modify to read and write permission."

                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                # 刪除指定的文檔;
                try:
                    os.remove(web_path)  # 刪除文檔
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的待刪除文檔 [ " + str(web_path) + " ] 無法刪除.")
                    response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法刪除."
                    response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

                # # 判斷指定的待刪除文檔，是否已經從硬盤刪除;
                # if os.path.exists(web_path) and os.path.isfile(web_path):
                #     print("指定的待刪除文檔 [ " + str(web_path) + " ] 無法被刪除.")
                #     response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法被刪除."
                #     response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                #     # 使用加號（+）拼接字符串;
                #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                #     # print(response_data_String)
                #     return response_data_String

            elif os.path.exists(web_path) and pathlib.Path(web_path).is_dir():

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path)} : {error.strerror}')
                        print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法修改為可讀可寫權限.")
                        response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                # 刪除指定的目錄（文件夾）;
                try:
                    shutil.rmtree(web_path, ignore_errors=True)  # 遞歸刪除文件夾及文件夾裏的所有内容（子文檔和子文件夾），參數 ignore_errors=True 表示忽略錯誤;
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法刪除.")
                    response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法刪除."
                    response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

                # # 檢查指定的待刪除目錄（文件夾）是否已經從硬盤移除;
                # if os.path.exists(web_path) and pathlib.Path(web_path).is_dir():
                #     print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法被刪除.")
                #     response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法被刪除."
                #     response_data_Dict["error"] = f'Directory: ( {str(fileName)} ) cannot be deleted.'
                #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                #     # 使用加號（+）拼接字符串;
                #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                #     # print(response_data_String)
                #     return response_data_String

            else:

                print("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + str(web_path) + " 不存在或者無法識別.")
                response_data_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " + str(fileName) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(fileName) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String


        # # web_path_index_Html = str(os.path.join(str(webPath), "index.html"))  # 拼接服務器返回的響應值文檔名（絕對路徑）;
        # # file_data = Base.string(request_POST_String);
        # # 截取目標寫入目錄;
        # currentDirectory = ""
        # # print(fileName)
        # if isinstance(fileName, str) and fileName.find("/", 0, int(len(fileName)-1)) != -1:
        #     tempArray = []
        #     tempArray = fileName.split("/", -1)
        #     if len(tempArray) <= 2:
        #         currentDirectory = "/"
        #     else:
        #         for i in range(0, int(len(tempArray) - int(1))):
        #             if i == 0:
        #                 currentDirectory = str(tempArray[i])
        #             else:
        #                 currentDirectory = currentDirectory + "/" + str(tempArray[i])
        # elif isinstance(fileName, str) and fileName.find("\\", 0, int(len(fileName)-1)) != -1:
        #     tempArray = []
        #     tempArray = fileName.split("\\", -1)
        #     if len(tempArray) <= 2:
        #         currentDirectory = "\\"
        #     else:
        #         for i in range(0, int(len(tempArray) - int(1))):
        #             if i == 0:
        #                 currentDirectory = str(tempArray[i])
        #             else:
        #                 currentDirectory = currentDirectory + "\\" + str(tempArray[i])
        # else:
        #     currentDirectory = "/"
        # # print(currentDirectory)
        # if currentDirectory[0] == '/' or currentDirectory[0] == '\\':
        #     web_path = str(os.path.join(str(webPath), str(currentDirectory[1:len(currentDirectory)])))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名，如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
        # else:
        #     web_path = str(os.path.join(str(webPath), str(currentDirectory)))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名;
        # # print(web_path)

        return response_data_String

    elif request_Path == "/KLineCleaning":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001//KLineCleaning?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=KLineCleaning&configFile=C:/StatisticalServer/StatisticalServerPython/config.txt&input_K_Line=C:/StatisticalServer/Data/K-Day-source/&is_save_pickle=True&output_pickle_K_Line=C:/StatisticalServer/Data/steppingData.pickle&is_save_csv=True&output_csv_K_Line=C:/StatisticalServer/Data/K-Day/&is_save_xlsx=False&output_xlsx_K_Line=C:/StatisticalServer/Data/K-Day/
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001//KLineCleaning?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=KLineCleaning&configFile=C:/StatisticalServer/StatisticalServerPython/config.txt&input_K_Line=C:/StatisticalServer/Data/K-Day-source/&is_save_pickle=True&output_pickle_K_Line=C:/StatisticalServer/Data/steppingData.pickle&is_save_csv=True&output_csv_K_Line=C:/StatisticalServer/Data/K-Day/&is_save_xlsx=False&output_xlsx_K_Line=C:/StatisticalServer/Data/K-Day/

        # 將客戶端請求 url 中的查詢字符串值解析為 Python 字典類型;
        # print(request_Url_Query_String)
        if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
            if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
                # for i in range(0, len(request_Url_Query_String.split("&", -1))):
                for query_item in request_Url_Query_String.split("&", -1):
                    if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                        # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                        temp_split_Array = query_item.split("=", -1)
                        temp_split_value = ""
                        if len(temp_split_Array) > 1:
                            for i in range(1, len(temp_split_Array)):
                                if int(i) == int(1):
                                    temp_split_value = temp_split_value + str(temp_split_Array[i])
                                if int(i) > int(1):
                                    temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                        # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                        request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                    else:
                        # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                        request_Url_Query_Dict[query_item] = ""
            else:
                if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                    temp_split_Array = request_Url_Query_String.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                    request_Url_Query_Dict[request_Url_Query_String] = ""
        # print(request_Url_Query_Dict)

        # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
        # print(request_POST_String)
        if isinstance(request_POST_String, str) and request_POST_String != "":
            # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
            # # print(check_json_format(request_POST_String))
            # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
            # if check_json_format(request_POST_String):
            #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
        # print(request_data_Dict)

        # 預設參數初值;
        input_K_Line_Daily_file = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day-source")).replace('\\', '/')  # "C:/StatisticalServer/Data/K-Day-source/";
        # input_K_Line_Daily_file = "C:/StatisticalServer/Data/K-Day-source/"
        # input_K_Line_Daily_file = "C:/StatisticalServer/Data/K-Day-source/SZ#002611.csv"
        # input_K_Line_Daily_file = "C:/StatisticalServer/Data/K-Day-source/SZ#002611.xlsx"
        # print(input_K_Line_Daily_file)
        is_save_pickle = "False"  # True or False;
        output_pickle_K_Line_Daily_file = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "steppingData.pickle")).replace('\\', '/')  # "C:/StatisticalServer/Data/steppingData.pickle";
        # print(output_pickle_K_Line_Daily_file)
        is_save_csv = "False"  # True or False;
        output_csv_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day")).replace('\\', '/')  # "C:/StatisticalServer/Data/K-Day/";
        # print(output_csv_K_Line_Daily_file_dir)
        is_save_xlsx = "False"  # True or False;
        output_xlsx_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day")).replace('\\', '/')  # "C:/StatisticalServer/Data/K-Day/";
        # print(output_xlsx_K_Line_Daily_file_dir)
        Cleaned_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "steppingData.pickle")).replace('\\', '/')  # "C:/StatisticalServer/Data/steppingData.pickle";
        # print(Cleaned_K_Line_Daily_file_dir)
        # 從配置文檔（./config.txt）讀取傳入參數值;
        Quantitative_Trading_configFile = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "config.txt")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/config.txt" # "/home/StatisticalServer/StatisticalServerPython/config.txt";
        # Quantitative_Trading_configFile = pathlib.Path(os.path.abspath("..") + "config.txt")  # pathlib.Path("../config.txt")  # "C:/StatisticalServer/StatisticalServerPython/config.txt" # "/home/StatisticalServer/StatisticalServerPython/config.txt";
        # print(Quantitative_Trading_configFile)

        # argumentArray = []
        # if request_data_Dict.__contains__("argumentKLineClear"):
        #     if len(request_data_Dict["argumentKLineClear"]) > 0:
        #         for i in range(0, len(request_data_Dict["argumentKLineClear"]), 1):
        #             argumentArray.append(str(request_data_Dict["argumentKLineClear"][i]))

        if request_data_Dict.__contains__("configFile"):
            if len(request_data_Dict["configFile"]) > 0:
                Quantitative_Trading_configFile = str(request_data_Dict["configFile"][0])
        # print("Post configFile = ", Quantitative_Trading_configFile)
        if request_Url_Query_Dict.__contains__("configFile"):
            Quantitative_Trading_configFile = str(request_Url_Query_Dict["configFile"])
        # print("URL query configFile = ", Quantitative_Trading_configFile)

        if request_data_Dict.__contains__("input_K_Line"):
            if len(request_data_Dict["input_K_Line"]) > 0:
                input_K_Line_Daily_file = str(request_data_Dict["input_K_Line"][0])
        # print("Post input_K_Line = ", input_K_Line_Daily_file)
        if request_Url_Query_Dict.__contains__("input_K_Line"):
            input_K_Line_Daily_file = str(request_Url_Query_Dict["input_K_Line"])
        # print("URL query input_K_Line = ", input_K_Line_Daily_file)

        if request_data_Dict.__contains__("is_save_pickle"):
            if len(request_data_Dict["is_save_pickle"]) > 0:
                # is_save_pickle = str(request_data_Dict["is_save_pickle"][0])
                # is_save_pickle = ast.literal_eval(str(request_data_Dict["is_save_pickle"][0]))
                if request_data_Dict["is_save_pickle"][0] == "true" or request_data_Dict["is_save_pickle"][0] == "True" or request_data_Dict["is_save_pickle"][0] == "TRUE" or request_data_Dict["is_save_pickle"][0] == "1":
                    # is_save_pickle = True
                    is_save_pickle = "True"
                if request_data_Dict["is_save_pickle"][0] == "false" or request_data_Dict["is_save_pickle"][0] == "False" or request_data_Dict["is_save_pickle"][0] == "FALSE" or request_data_Dict["is_save_pickle"][0] == "0":
                    # is_save_pickle = False
                    is_save_pickle = "False"
        # print("Post is_save_pickle = ", is_save_pickle)
        if request_Url_Query_Dict.__contains__("is_save_pickle"):
            # is_save_pickle = str(request_Url_Query_Dict["is_save_pickle"])
            # is_save_pickle = ast.literal_eval(str(request_Url_Query_Dict["is_save_pickle"]))  # 使用 ast.literal_eval() 函數執行字符串代碼語句;
            if request_Url_Query_Dict["is_save_pickle"] == "true" or request_Url_Query_Dict["is_save_pickle"] == "True" or request_Url_Query_Dict["is_save_pickle"] == "TRUE" or request_Url_Query_Dict["is_save_pickle"] == "1":
                # is_save_pickle = True
                is_save_pickle = "True"
            if request_Url_Query_Dict["is_save_pickle"] == "false" or request_Url_Query_Dict["is_save_pickle"] == "False" or request_Url_Query_Dict["is_save_pickle"] == "FALSE" or request_Url_Query_Dict["is_save_pickle"] == "0":
                # is_save_pickle = False
                is_save_pickle = "False"
        # print("URL query is_save_pickle = ", is_save_pickle)

        if request_data_Dict.__contains__("output_pickle_K_Line"):
            if len(request_data_Dict["output_pickle_K_Line"]) > 0:
                output_pickle_K_Line_Daily_file = str(request_data_Dict["output_pickle_K_Line"][0])
        # print("Post output_pickle_K_Line = ", output_pickle_K_Line_Daily_file)
        if request_Url_Query_Dict.__contains__("output_pickle_K_Line"):
            output_pickle_K_Line_Daily_file = str(request_Url_Query_Dict["output_pickle_K_Line"])
        # print("URL query output_pickle_K_Line = ", output_pickle_K_Line_Daily_file)

        if request_data_Dict.__contains__("is_save_csv"):
            if len(request_data_Dict["is_save_csv"]) > 0:
                # is_save_csv = str(request_data_Dict["is_save_csv"][0])
                # is_save_csv = ast.literal_eval(str(request_data_Dict["is_save_csv"][0]))
                if request_data_Dict["is_save_csv"][0] == "true" or request_data_Dict["is_save_csv"][0] == "True" or request_data_Dict["is_save_csv"][0] == "TRUE" or request_data_Dict["is_save_csv"][0] == "1":
                    # is_save_csv = True
                    is_save_csv = "True"
                if request_data_Dict["is_save_csv"][0] == "false" or request_data_Dict["is_save_csv"][0] == "False" or request_data_Dict["is_save_csv"][0] == "FALSE" or request_data_Dict["is_save_csv"][0] == "0":
                    # is_save_csv = False
                    is_save_csv = "False"
        # print("Post is_save_csv = ", is_save_csv)
        if request_Url_Query_Dict.__contains__("is_save_csv"):
            # is_save_csv = str(request_Url_Query_Dict["is_save_csv"])
            # is_save_csv = ast.literal_eval(str(request_Url_Query_Dict["is_save_csv"]))
            if request_Url_Query_Dict["is_save_csv"] == "true" or request_Url_Query_Dict["is_save_csv"] == "True" or request_Url_Query_Dict["is_save_csv"] == "TRUE" or request_Url_Query_Dict["is_save_csv"] == "1":
                # is_save_csv = True
                is_save_csv = "True"
            if request_Url_Query_Dict["is_save_csv"] == "false" or request_Url_Query_Dict["is_save_csv"] == "False" or request_Url_Query_Dict["is_save_csv"] == "FALSE" or request_Url_Query_Dict["is_save_csv"] == "0":
                # is_save_csv = False
                is_save_csv = "False"
        # print("URL query is_save_csv = ", is_save_csv)

        if request_data_Dict.__contains__("output_csv_K_Line"):
            if len(request_data_Dict["output_csv_K_Line"]) > 0:
                output_csv_K_Line_Daily_file_dir = str(request_data_Dict["output_csv_K_Line"][0])
        # print("Post output_csv_K_Line = ", output_csv_K_Line_Daily_file_dir)
        if request_Url_Query_Dict.__contains__("output_csv_K_Line"):
            output_csv_K_Line_Daily_file_dir = str(request_Url_Query_Dict["output_csv_K_Line"])
        # print("URL query output_csv_K_Line = ", output_csv_K_Line_Daily_file_dir)

        if request_data_Dict.__contains__("is_save_xlsx"):
            if len(request_data_Dict["is_save_xlsx"]) > 0:
                # is_save_xlsx = str(request_data_Dict["is_save_xlsx"][0])
                # is_save_xlsx = ast.literal_eval(str(request_data_Dict["is_save_xlsx"][0]))
                if request_data_Dict["is_save_xlsx"][0] == "true" or request_data_Dict["is_save_xlsx"][0] == "True" or request_data_Dict["is_save_xlsx"][0] == "TRUE" or request_data_Dict["is_save_xlsx"][0] == "1":
                    # is_save_xlsx = True
                    is_save_xlsx = "True"
                if request_data_Dict["is_save_xlsx"][0] == "false" or request_data_Dict["is_save_xlsx"][0] == "False" or request_data_Dict["is_save_xlsx"][0] == "FALSE" or request_data_Dict["is_save_xlsx"][0] == "0":
                    # is_save_xlsx = False
                    is_save_xlsx = "False"
        # print("Post is_save_xlsx = ", is_save_xlsx)
        if request_Url_Query_Dict.__contains__("is_save_xlsx"):
            # is_save_xlsx = str(request_Url_Query_Dict["is_save_xlsx"])
            # is_save_xlsx = ast.literal_eval(str(request_Url_Query_Dict["is_save_xlsx"]))
            if request_Url_Query_Dict["is_save_xlsx"] == "true" or request_Url_Query_Dict["is_save_xlsx"] == "True" or request_Url_Query_Dict["is_save_xlsx"] == "TRUE" or request_Url_Query_Dict["is_save_xlsx"] == "1":
                # is_save_xlsx = True
                is_save_xlsx = "True"
            if request_Url_Query_Dict["is_save_xlsx"] == "false" or request_Url_Query_Dict["is_save_xlsx"] == "False" or request_Url_Query_Dict["is_save_xlsx"] == "FALSE" or request_Url_Query_Dict["is_save_xlsx"] == "0":
                # is_save_xlsx = False
                is_save_xlsx = "False"
        # print("URL query is_save_xlsx = ", is_save_xlsx)

        if request_data_Dict.__contains__("output_xlsx_K_Line"):
            if len(request_data_Dict["output_xlsx_K_Line"]) > 0:
                output_xlsx_K_Line_Daily_file_dir = str(request_data_Dict["output_xlsx_K_Line"][0])
        # print("Post output_xlsx_K_Line = ", output_xlsx_K_Line_Daily_file_dir)
        if request_Url_Query_Dict.__contains__("output_xlsx_K_Line"):
            output_xlsx_K_Line_Daily_file_dir = str(request_Url_Query_Dict["output_xlsx_K_Line"])
        # print("URL query output_xlsx_K_Line = ", output_xlsx_K_Line_Daily_file_dir)

        if request_data_Dict.__contains__("Cleaned_K_Line"):
            if len(request_data_Dict["Cleaned_K_Line"]) > 0:
                Cleaned_K_Line_Daily_file_dir = str(request_data_Dict["Cleaned_K_Line"][0])
        # print("Post Cleaned_K_Line = ", Cleaned_K_Line_Daily_file_dir)
        if request_Url_Query_Dict.__contains__("Cleaned_K_Line"):
            Cleaned_K_Line_Daily_file_dir = str(request_Url_Query_Dict["Cleaned_K_Line"])
        # print("URL query Cleaned_K_Line = ", Cleaned_K_Line_Daily_file_dir)


        # # 向外部 .py 脚本文檔裏的變量賦新值;
        # import Quantitative_Data_Cleaning as Quantitative_Data_Cleaning  # 加載自定義算法模組，導入本地自定義的日棒缐（K Line）數據清洗功能模組;
        # Quantitative_Data_Cleaning.input_K_Line_Daily_file = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day-source")).replace('\\', '/')  # "C:/StatisticalServer/Data/K-Day-source/"
        # Quantitative_Data_Cleaning.input_K_Line_Daily_file = input_K_Line_Daily_file
        # # Quantitative_Data_Cleaning.input_K_Line_Daily_file = "C:/StatisticalServer/Data/K-Day-source/"
        # # Quantitative_Data_Cleaning.input_K_Line_Daily_file = "C:/StatisticalServer/Data/K-Day-source/SZ#002611.csv"
        # # Quantitative_Data_Cleaning.input_K_Line_Daily_file = "C:/StatisticalServer/Data/K-Day-source/SZ#002611.xlsx"
        # # print(input_K_Line_Daily_file)
        # Quantitative_Data_Cleaning.is_save_pickle = False  # True or False
        # Quantitative_Data_Cleaning.is_save_pickle = ast.literal_eval(str(is_save_pickle))  # 使用 ast.literal_eval() 函數執行字符串代碼語句;
        # Quantitative_Data_Cleaning.output_pickle_K_Line_Daily_file = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "steppingData.pickle")).replace('\\', '/')  # "C:/StatisticalServer/Data/steppingData.pickle"
        # Quantitative_Data_Cleaning.output_pickle_K_Line_Daily_file = output_pickle_K_Line_Daily_file
        # # print(output_pickle_K_Line_Daily_file)
        # Quantitative_Data_Cleaning.is_save_csv = False  # True or False
        # Quantitative_Data_Cleaning.is_save_csv = ast.literal_eval(str(is_save_csv))
        # Quantitative_Data_Cleaning.output_csv_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day")).replace('\\', '/')  # "C:/StatisticalServer/Data/K-Day/"
        # Quantitative_Data_Cleaning.output_csv_K_Line_Daily_file_dir = output_csv_K_Line_Daily_file_dir
        # # print(output_csv_K_Line_Daily_file_dir)
        # Quantitative_Data_Cleaning.is_save_xlsx = False  # True or False
        # Quantitative_Data_Cleaning.is_save_xlsx = ast.literal_eval(str(is_save_xlsx))
        # Quantitative_Data_Cleaning.output_xlsx_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day")).replace('\\', '/')  # "C:/StatisticalServer/Data/K-Day/"
        # Quantitative_Data_Cleaning.output_xlsx_K_Line_Daily_file_dir = output_xlsx_K_Line_Daily_file_dir
        # # print(output_xlsx_K_Line_Daily_file_dir)
        # Quantitative_Data_Cleaning.configFile = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "config.txt")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/config.txt" # "/home/StatisticalServer/StatisticalServerPython/config.txt"
        # Quantitative_Data_Cleaning.configFile = Quantitative_Trading_configFile
        # # Quantitative_Data_Cleaning.configFile = pathlib.Path(os.path.abspath("..") + "config.txt")  # pathlib.Path("../config.txt")
        # # print(Quantitative_Data_Cleaning.configFile)
        # # import importlib  # 導入 Python 内置熱重載模組，用於熱重載熱更新外部 .py 脚本文檔裏的變量值;
        # importlib.reload(Quantitative_Data_Cleaning)  # 熱重載熱更新外部 .py 脚本文檔裏的變量值，重新加載本地自定義的日棒缐（K Line）數據清洗功能模組;
        # stepping_data = Quantitative_Data_Cleaning.stepping_data
        # # print(stepping_data)


        # 自定義的日棒缐（K Line）數據清洗功能模組使用示例;
        # 控制臺命令列運行指令：
        # C:\StatisticalServer> C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py configFile=C:/StatisticalServer/StatisticalServerPython/config.txt input_K_Line=C:/StatisticalServer/Data/K-Day-source/ is_save_pickle=True output_pickle_K_Line=C:/StatisticalServer/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=C:/StatisticalServer/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=C:/StatisticalServer/Data/K-Day/
        # root@localhost:~# /usr/bin/python3 /home/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py configFile=/home/StatisticalServer/StatisticalServerPython/config.txt input_K_Line=/home/StatisticalServer/Data/K-Day-source/ is_save_pickle=True output_pickle_K_Line=C:/StatisticalServer/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=/home/StatisticalServer/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=/home/StatisticalServer/Data/K-Day/

        # str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "Quantitative_Data_Cleaning.py")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/Quantitative_Data_Cleaning.py" # "/home/StatisticalServer/StatisticalServerPython/Quantitative_Data_Cleaning.py";
        Python_exe_path = str(sys.executable).replace('\\', '/')  # "C:/StatisticalServer/Python/Python311/python.exe" # "C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"
        # print(Python_exe_path)  # "C:/StatisticalServer/Python/Python311/python.exe" # "C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"
        Python_program_path = str(sys.prefix).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/"
        # print(Python_program_path)  # "C:/StatisticalServer/StatisticalServerPython/"
        Python_script_path = str(os.path.join(os.path.dirname(os.path.realpath(__file__)), "Quantitative_Data_Cleaning.py")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py" # "/home/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py";
        # print(Python_script_path)  # "C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py" # "/home/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py";

        # Python 使用 shell 語句調用 Linux Ubuntu shell 或 Windows cmd 執行檔;
        # shell_script = f'{Python_exe_path} {Python_script_path} configFile={Quantitative_Trading_configFile} input_K_Line={input_K_Line_Daily_file} is_save_pickle={is_save_pickle} output_pickle_K_Line={output_pickle_K_Line_Daily_file} is_save_csv={is_save_csv} output_csv_K_Line={output_csv_K_Line_Daily_file_dir} is_save_xlsx={is_save_xlsx} output_xlsx_K_Line={output_xlsx_K_Line_Daily_file_dir}'
        # shell_script = '{} {} configFile={} input_K_Line={} is_save_pickle={} output_pickle_K_Line={} is_save_csv={} output_csv_K_Line={} is_save_xlsx={} output_xlsx_K_Line={}'.format(Python_exe_path, Python_script_path, Quantitative_Trading_configFile, input_K_Line_Daily_file, is_save_pickle, output_pickle_K_Line_Daily_file, is_save_csv, output_csv_K_Line_Daily_file_dir, is_save_xlsx, output_xlsx_K_Line_Daily_file_dir)
        shell_script = '%s %s configFile=%s input_K_Line=%s is_save_pickle=%s output_pickle_K_Line=%s is_save_csv=%s output_csv_K_Line=%s is_save_xlsx=%s output_xlsx_K_Line=%s' % (Python_exe_path, Python_script_path, Quantitative_Trading_configFile, input_K_Line_Daily_file, is_save_pickle, output_pickle_K_Line_Daily_file, is_save_csv, output_csv_K_Line_Daily_file_dir, is_save_xlsx, output_xlsx_K_Line_Daily_file_dir)
        # shell_script = 'C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py configFile=C:/StatisticalServer/StatisticalServerPython/config.txt input_K_Line=C:/StatisticalServer/Data/K-Day-source/ is_save_pickle=False output_pickle_K_Line=C:/StatisticalServer/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=C:/StatisticalServer/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=C:/StatisticalServer/Data/K-Day/'
        # shell_script = '/usr/bin/python3 /home/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py configFile=/home/StatisticalServer/StatisticalServerPython/config.txt input_K_Line=/home/StatisticalServer/Data/K-Day-source/ is_save_pickle=False output_pickle_K_Line=/home/StatisticalServer/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=/home/StatisticalServer/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=/home/StatisticalServer/Data/K-Day/'
        # print(shell_script)
        Proc = os.popen(shell_script)  # 執行shell命令，拿到輸出結果;
        # Proc = os.popen('%s %s configFile=%s input_K_Line=%s is_save_pickle=%s output_pickle_K_Line=%s is_save_csv=%s output_csv_K_Line=%s is_save_xlsx=%s output_xlsx_K_Line=%s' % (Python_exe_path, Python_script_path, Quantitative_Trading_configFile, input_K_Line_Daily_file, is_save_pickle, output_pickle_K_Line_Daily_file, is_save_csv, output_csv_K_Line_Daily_file_dir, is_save_xlsx, output_xlsx_K_Line_Daily_file_dir))  # 執行shell命令，拿到輸出結果;
        # Proc = os.popen('C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py configFile=C:/StatisticalServer/StatisticalServerPython/config.txt input_K_Line=C:/StatisticalServer/Data/K-Day-source/ is_save_pickle=False output_pickle_K_Line=C:/StatisticalServer/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=C:/StatisticalServer/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=C:/StatisticalServer/Data/K-Day/')  執行shell命令，拿到輸出結果;
        # print(Proc.readlines())
        stdout_Command = Proc.read()  # 取出執行結果;
        # print(stdout_Command, end = '')
        # sys.stdout.write(stdout_Command)

        stdout_Command_head = ""
        stdout_Command_body = ""
        if len(stdout_Command) > 0:
            if stdout_Command.find("\r\n\r\n", 0, int(len(stdout_Command)-1)) != -1:
                stdout_Command_head = str(stdout_Command.split("\r\n\r\n", -1)[0])
                stdout_Command_body = str(stdout_Command.split("\r\n\r\n", -1)[1])
            else:
                stdout_Command_head = stdout_Command
                stdout_Command_body = stdout_Command
        # print(stdout_Command_head, end = '')
        # print(stdout_Command_body, end = '')

        backArray = []  # 聲明一個聯合類型的空1維數組;
        if len(stdout_Command_head) > 0:
            if stdout_Command_head.find("\n", 0, int(len(stdout_Command_head)-1)) != -1:
                for x in stdout_Command_head.split("\n", -1):
                    # print(x + '\n', end='')
                    backArray.append(x)
            else:
                backArray.append(stdout_Command_head)
        # print(backArray)

        response_data_Dict = {}
        response_data_Dict["configFile"] = str(Quantitative_Trading_configFile)
        response_data_Dict["input_K_Line"] = str(input_K_Line_Daily_file)
        response_data_Dict["is_save_pickle"] = str(is_save_pickle)
        response_data_Dict["output_pickle_K_Line"] = str(output_pickle_K_Line_Daily_file)
        response_data_Dict["is_save_csv"] = str(is_save_csv)
        response_data_Dict["output_csv_K_Line"] = str(output_csv_K_Line_Daily_file_dir)
        response_data_Dict["is_save_xlsx"] = str(is_save_xlsx)
        response_data_Dict["output_xlsx_K_Line"] = str(output_xlsx_K_Line_Daily_file_dir)

        response_data_Dict["return_KLineCleaning"] = {"KLineCleaned": {}}
        stepping_data = {}
        # stepping_data = Quantitative_Data_Cleaning.stepping_data
        if len(stdout_Command_body) > 0:
            stepping_data = json.loads(stdout_Command_body)  # 使用 Python 原生 JSON 模組中的 json.loads() 函數將 JSON 字符串轉換爲 Python 字典（Dict）對象;
        if isinstance(stepping_data, dict) and len(stepping_data) > 0:
            for key, value in stepping_data.items():
                # print("Key: %s, Value:\n%s" % (key, value))
                response_data_Dict["return_KLineCleaning"]["KLineCleaned"][key] = value

        # 向字典中添加元素;
        response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)}
        # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)}
        # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)}
        # response_data_Dict["request_POST"] = request_data_Dict  # {"request_POST": request_data_Dict}
        # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)}
        response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)}
        response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)}
        # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)}
        # response_data_Dict["request_Password"] = str(request_Cookie)  # {"request_Password": str(request_Password)}
        response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)}
        # response_data_Dict["Server_Authorization"] = str(key)  # {"Server_Authorization": str(key)}
        response_data_Dict["Server_say"] = str(stdout_Command)  # {"Server_say": str(request_POST_String)}
        response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)}
        # print(response_data_Dict)

        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        # 使用加號（+）拼接字符串;
        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        # print(response_data_String)

        # response_data_Dict = {
        #     "configFile" : "C:/StatisticalServer/StatisticalServerPython/config.txt",
        #     "input_K_Line" : "C:/StatisticalServer/Data/K-Day-source/",
        #     "is_save_pickle" : "False",
        #     "output_pickle_K_Line" : "C:/StatisticalServer/Data/steppingData.pickle",
        #     "is_save_csv" : "True",
        #     "output_csv_K_Line" : "C:/StatisticalServer/Data/K-Day/",
        #     "is_save_xlsx" : "False",
        #     "output_xlsx_K_Line" : "C:/StatisticalServer/Data/K-Day/",
        #     "stepping_data" : {
        #         "002611" : {
        #             "capitalization" : int(12170000000),
        #             "date_transaction" : [datetime.date("2019-1-2"), datetime.date("2019-1-3"), datetime.date("2019-1-4"), datetime.date("2019-1-7"), datetime.date("2019-1-8"), datetime.date("2019-1-9"), datetime.date("2019-1-10"), datetime.date("2019-1-11"), datetime.date("2019-1-14"), datetime.date("2019-1-15"), datetime.date("2019-1-16"), ...],
        #             "turnover_volume" : [int(7385675), int(33846475), int(27957054), int(25700917), int(56678844), int(39931296), int(21818792), int(15243953), int(46110961), int(29099424), int(58411670), ...],
        #             "turnover_rate" : [float(), float(), float(), ...],
        #             "turnover_amount" : [float(27770014), float(135627968), float(109496376), float(103257416), float(242614176), float(170208784), float(90564944), float(62862520), float(197721472), float(125331136), float(260167456), ...],
        #             "opening_price" : [float(3.75), float(3.76), float(3.84), float(3.99), float(4.04), float(4.24), float(4.12), float(4.13), float(4.14), float(4.27), float(4.32), ...],
        #             "close_price" : [float(3.76), float(3.94), float(3.98), float(4.05), float(4.27), float(4.18), float(4.14), float(4.13), float(4.31), float(4.34), float(4.48), ...],
        #             "low_price" : [float(3.73), float(3.72), float(3.8), float(3.92), float(3.98), float(4.16), float(4.11), float(4.09), float(4.12), float(4.24), float(4.29), ...],
        #             "high_price" : [float(3.8), float(4.14), float(4.0), float(4.07), float(4.46), float(4.36), float(4.21), float(4.17), float(4.45), float(4.36), float(4.67), ...],
        #             "focus" : [float(3.76), float(3.89), float(3.905), float(4.0075), float(4.1875), float(4.235), float(4.145), float(4.13), float(4.255), float(4.3025), float(4.44), ...],
        #             "amplitude" : [float(0.029439203), float(0.192180471), float(0.099833194), float(0.06751543), float(0.220510771), float(0.09), float(0.045092498), float(0.032659863), float(0.155456318), float(0.056789083), float(0.174547033), ...],
        #             "amplitude_rate" : [float(0.007829575), float(0.04940372), float(0.025565479), float(0.016847269), float(0.052659289), float(0.021251476), float(0.010878769), float(0.007907957), float(0.036534975), float(0.01319909), float(0.039312395), ...],
        #             "opening_price_Standardization" : [float(-0.33968311), float(-0.676447505), float(-0.651086049), float(-0.259200007), float(-0.668901567), float(0.055555556), float(-0.554415953), float(0.0), float(-0.739757649), float(-0.572293089), float(-0.687493784), ...],
        #             "closing_price_Standardization" : [float(0.0), float(0.260172117), float(0.751253134), float(0.629485731), float(0.374131385), float(-0.611111111), float(-0.110883191), float(0.0), float(0.353797136), float(0.66033818), float(0.229164595), ...],
        #             "low_price_Standardization" : [float(-1.019049331), float(-0.884585199), float(-1.051754387), float(-1.296000034), float(-0.940997119), float(-0.833333333), float(-0.776182335), float(-1.224744871), float(-0.868411153), float(-1.100563633), float(-0.859367229), ...],
        #             "high_price_Standardization" : [float(1.358732441), float(1.300860587), float(0.951587303), float(0.92571431), float(1.235767301), float(1.388888889), float(1.441481478), float(1.224744871), float(1.254371666), float(1.012518542), float(1.317696418), ...],
        #             "turnover_volume_growth_rate" : [float(0.0), float(3.58271925), float(-0.174003969), float(-0.080700098), float(1.205323802), float(-0.295481467), float(-0.453591689), float(-0.30133836), float(2.024869009), float(-0.3689261), float(1.007313616), ...],
        #             "opening_price_growth_rate" : [float(0.0), float(0.002666667), float(0.021276596), float(0.0390625), float(0.012531328), float(0.04950495), float(-0.028301887), float(0.002427184), float(0.002421308), float(0.031400966), float(0.011709602), ...],
        #             "closing_price_growth_rate" : [float(0.0), float(0.04787234), float(0.010152284), float(0.01758794), float(0.054320988), float(-0.021077283), float(-0.009569378), float(-0.002415459), float(0.043583535), float(0.006960557), float(0.032258065), ...],
        #             "high_price_proportion" : [float(0.989473684), float(0.951690821), float(0.995), float(0.995085995), float(0.957399103), float(0.972477064), float(0.983372922), float(0.990407674), float(0.968539326), float(0.995412844), float(0.959314775), ...],
        #             "low_price_proportion" : [float(0.994666667), float(0.989361702), float(0.989583333), float(0.98245614), float(0.985148515), float(0.995215311), float(0.997572816), float(0.99031477), float(0.995169082), float(0.992974239), float(0.993055556), ...],
        #             "closing_minus_opening_price_growth_rate" : [float(0.002666667), float(0.04787234), float(0.036458333), float(0.015037594), float(0.056930693), float(-0.014150943), float(0.004854369), float(0.0), float(0.041062802), float(0.016393443), float(0.037037037), ...],
        #             "book_value_per_share" : [float(), float(), float(), ...],
        #             "price_earnings" : [float(), float(), float(), ...],
        #             "sum_2_turnover_volume_growth_rate" : [numpy.NaN, float(1.791359625), float(0.808677828), float(-0.167702083), float(0.582486877), float(0.153590217), float(-0.601332423), float(-0.528134205), float(0.937099914), float(0.321754202), float(0.411425283), ...],
        #             "sum_2_opening_price_growth_rate" : [numpy.NaN, float(0.001333333), float(0.022609929), float(0.049700798), float(0.032062578), float(0.055770615), float(-0.001774706), float(-0.005861879), float(0.0036349), float(0.03261162), float(0.027410085), ...],
        #             "sum_2_closing_price_growth_rate" : [numpy.NaN, float(0.02393617), float(0.034088454), float(0.022664082), float(0.063114958), float(0.003041605), float(-0.02010802), float(-0.007200148), float(0.021187903), float(0.028752324), float(0.035738343), ...],
        #             "sum_2_closing_minus_opening_price_growth_rate" : [numpy.NaN, float(0.049205674), float(0.060394504), float(0.033266761), float(0.06444949), float(0.007157202), float(-0.001110551), float(0.001213592), float(0.020531401), float(0.036924844), float(0.045233758), ...],
        #             "sum_2_high_price_proportion" : [numpy.NaN, float(1.446427663), float(1.470845411), float(1.492585995), float(1.454942101), float(1.451176616), float(1.469611454), float(1.482094135), float(1.463743163), float(1.479682507), float(1.457021197), ...],
        #             "sum_2_low_price_proportion" : [numpy.NaN, float(1.486695035), float(1.484264184), float(1.477247807), float(1.476376585), float(1.487789568), float(1.495180471), float(1.489101178), float(1.490326467), float(1.49055878), float(1.489542675), ...],
        #             "sum_2_KLine_Intuitive_Momentum" : [numpy.NaN, float(1.794033435), float(0.816153433), float(-0.162394081), float(0.595663278), float(0.154499026), float(-0.601279023), float(-0.52816919), float(0.938211686), float(0.326751665), float(0.417624603), ...],
        #             "sum_3_turnover_volume_growth_rate" : [numpy.NaN, numpy.NaN, float(0.73815851), float(0.266944754), float(0.327240342), float(0.052928734), float(-0.299794689), float(-0.702226642), float(0.440230023), float(0.137056078), float(1.039529723), ...],
        #             "sum_3_opening_price_growth_rate" : [numpy.NaN, numpy.NaN, float(0.015369582), float(0.054135786), float(0.045665194), float(0.070880003), float(0.015352978), float(0.006329915), float(-0.0004517), float(0.033824233), float(0.033450682), ...],
        #             "sum_3_closing_price_growth_rate" : [numpy.NaN, numpy.NaN, float(0.028044785), float(0.040313576), float(0.069430376), float(0.021025331), float(-0.009711602), float(-0.015820805), float(0.011327779), float(0.023742447), float(0.051426281), ...],
        #             "sum_3_closing_minus_opening_price_growth_rate" : [numpy.NaN, numpy.NaN, float(0.069262116), float(0.055300596), float(0.079108534), float(0.023927237), float(0.012742857), float(-0.000493578), float(0.02845395), float(0.029179096), float(0.061653599), ...],
        #             "sum_3_high_price_proportion" : [numpy.NaN, numpy.NaN, float(1.959285109), float(1.975649602), float(1.952456433), float(1.942438465), float(1.950823999), float(1.970148643), float(1.956602082), float(1.971241619), float(1.94576978), ...],
        #             "sum_3_low_price_proportion" : [numpy.NaN, numpy.NaN, float(1.980713357), float(1.971965597), float(1.969980386), float(1.979466368), float(1.989432528), float(1.987101751), float(1.987903201), float(1.986525217), float(1.986761409), ...],
        #             "sum_3_KLine_Intuitive_Momentum" : [numpy.NaN, numpy.NaN, float(0.74982791), float(0.287293521), float(0.362261072), float(0.061384027), float(-0.299515692), float(-0.702208303), float(0.441433708), float(0.143633821), float(1.059759237), ...],
        #             "sum_5_turnover_volume_growth_rate" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(0.987779617), float(0.424219288), float(-0.461007301), float(-0.589686585), float(0.527522535), float(-0.308230627), float(0.585057271), ...],
        #             "sum_5_opening_price_growth_rate" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(0.046091162), float(0.092011485), float(0.047942084), float(0.031435847), float(0.017940814), float(0.033492099), float(0.030271151), ...],
        #             "sum_5_closing_price_growth_rate" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(0.074905317), float(0.049900492), float(0.014422453), float(-0.003532006), float(0.012116149), float(0.011035464), float(0.037233955), ...],
        #             "sum_5_closing_minus_opening_price_growth_rate" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(0.110518038), float(0.060149741), float(0.03959144), float(0.016099861), float(0.032084862), float(0.030145221), float(0.060608277), ...],
        #             "sum_5_high_price_proportion" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(2.929038965), float(2.923786108), float(2.932828433), float(2.94256909), float(2.931359864), float(2.952333491), float(2.9296063), ...],
        #             "sum_5_low_price_proportion" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(2.959541441), float(2.966513481), float(2.975733296), float(2.976052843), float(2.981080415), float(2.981370555), float(2.980176867), ...],
        #             "sum_5_KLine_Intuitive_Momentum" : [numpy.NaN, numpy.NaN, numpy.NaN, numpy.NaN, float(1.103698843), float(0.498255593), float(-0.439458671), float(-0.585752412), float(0.535949828), float(-0.296415761), float(0.620777963), ...],
        #             "sum_7_turnover_volume_growth_rate" : [float(), float(), float(), ...],
        #             "sum_7_opening_price_growth_rate" : [float(), float(), float(), ...],
        #             "sum_7_closing_price_growth_rate" : [float(), float(), float(), ...],
        #             "sum_7_high_price_proportion" : [float(), float(), float(), ...],
        #             "sum_7_low_price_proportion" : [float(), float(), float(), ...],
        #             "sum_7_closing_minus_opening_price_growth_rate" : [float(), float(), float(), ...],
        #             "sum_7_KLine_Intuitive_Momentum" : [float(), float(), float(), ...],
        #             "sum_10_turnover_volume_growth_rate" : [float(), float(), float(), ...],
        #             "sum_10_opening_price_growth_rate" : [float(), float(), float(), ...],
        #             "sum_10_closing_price_growth_rate" : [float(), float(), float(), ...],
        #             "sum_10_high_price_proportion" : [float(), float(), float(), ...],
        #             "sum_10_low_price_proportion" : [float(), float(), float(), ...],
        #             "sum_10_closing_minus_opening_price_growth_rate" : [float(), float(), float(), ...],
        #             "sum_10_KLine_Intuitive_Momentum" : [float(), float(), float(), ...],
        #             "average_5_closing_price" : [float(0.0), float(0.0), float(0.0), float(0.0), float(4.0), float(4.084), float(4.124), float(4.154), float(4.206), float(4.22), float(4.28), ...],
        #             "average_10_closing_price" : [float(0.0), float(0.0), float(0.0), float(0.0), float(0.0), float(0.0), float(0.0), float(0.0), float(0.0), float(4.11), float(4.182), ...],
        #             "average_20_closing_price" : [float(), float(), float(), ...],
        #             "average_30_closing_price" : [float(), float(), float(), ...],
        #             "Pdata_0" : [float(), float(), float(), float()],
        #             "Pupper" : [+math.inf, +math.inf, +math.inf, +math.inf],
        #             "Plower" : [-math.inf, -math.inf, -math.inf, -math.inf],
        #             "weight" : [float(), float(), float(), ...]
        #         },
        #         ...
        #     },
        #     "request_Url": '/KLineCleaning?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=KLineCleaning',
        #     "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
        #     "request_Cookie": 'session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
        #     "time": '2024-02-03 17:59:58.239794',
        #     "Server_say": '',
        #     "error": ''
        # }
        # response_data_String = json.dumps(response_data_Dict)

        return response_data_String

    # elif request_Path == "/MarketTiming":
    #     # 客戶端或瀏覽器請求 url = http://[::1]:10001/MarketTiming?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=MarketTiming&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle
    #     # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/MarketTiming?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=MarketTiming&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle

    elif request_Path == "/PickStock":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001/PickStock?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=PickStock&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&PickStock_Pdata_0=[3,5]&PickStock_Plower=["-Infinity","-Infinity"]&PickStock_Pupper=["+Infinity","+Infinity"]&PickStock_weight=[]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/PickStock?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=PickStock&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&PickStock_Pdata_0=[3,5]&PickStock_Plower=["-Infinity","-Infinity"]&PickStock_Pupper=["+Infinity","+Infinity"]&PickStock_weight=[]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle

        # 將客戶端請求 url 中的查詢字符串值解析為 Python 字典類型;
        # print(request_Url_Query_String)
        if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
            if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
                # for i in range(0, len(request_Url_Query_String.split("&", -1))):
                for query_item in request_Url_Query_String.split("&", -1):
                    if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                        # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                        temp_split_Array = query_item.split("=", -1)
                        temp_split_value = ""
                        if len(temp_split_Array) > 1:
                            for i in range(1, len(temp_split_Array)):
                                if int(i) == int(1):
                                    temp_split_value = temp_split_value + str(temp_split_Array[i])
                                if int(i) > int(1):
                                    temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                        # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                        request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                    else:
                        # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                        request_Url_Query_Dict[query_item] = ""
            else:
                if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                    temp_split_Array = request_Url_Query_String.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                    request_Url_Query_Dict[request_Url_Query_String] = ""
        # print(request_Url_Query_Dict)

        # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
        # print(request_POST_String)
        if isinstance(request_POST_String, str) and request_POST_String != "":
            # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
            # # print(check_json_format(request_POST_String))
            # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
            # if check_json_format(request_POST_String):
            #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
        # print(request_data_Dict)

        # 預設參數初值;
        Cleaned_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "steppingData.pickle")).replace('\\', '/')  # "C:/StatisticalServer/Data/steppingData.pickle";
        # print(Cleaned_K_Line_Daily_file_dir)

        investment_method = "Long_Position_and_Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling"
        ticker_symbol_Array = ["all"]  # ["002611", "600119"] # ["all"]
        is_Optimize = False  # True or False
        PickStock_Pdata_0 = [int(3), int(5)]
        PickStock_Plower = [-math.inf, -math.inf]
        PickStock_Pupper = [+math.inf, +math.inf]
        PickStock_weight = []
        MarketTiming_Pdata_0 = [int(3), float(+0.1), float(-0.1), float(0.0)]
        MarketTiming_Plower = [-math.inf, -math.inf, -math.inf, -math.inf]
        MarketTiming_Pupper = [+math.inf, +math.inf, +math.inf, +math.inf]
        MarketTiming_weight = []
        training_data = {}
        # with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
        #     training_data = pickle.load(f)
        #     f.close()
        # print(training_data)
        testing_data = {}
        # with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
        #     testing_data = pickle.load(f)
        #     f.close()
        # print(testing_data)
        stepping_data = {}
        # with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
        #     stepping_data = pickle.load(f)
        #     f.close()
        # print(stepping_data)

        # argumentArray = []
        # if request_data_Dict.__contains__("argumentKLineClear"):
        #     if len(request_data_Dict["argumentKLineClear"]) > 0:
        #         for i in range(0, len(request_data_Dict["argumentKLineClear"]), 1):
        #             argumentArray.append(str(request_data_Dict["argumentKLineClear"][i]))

        if request_data_Dict.__contains__("Cleaned_K_Line"):
            if len(request_data_Dict["Cleaned_K_Line"]) > 0:
                Cleaned_K_Line_Daily_file_dir = str(request_data_Dict["Cleaned_K_Line"][0])
        # print("Post Cleaned_K_Line = ", Cleaned_K_Line_Daily_file_dir)
        if request_Url_Query_Dict.__contains__("Cleaned_K_Line"):
            Cleaned_K_Line_Daily_file_dir = str(request_Url_Query_Dict["Cleaned_K_Line"])
        # print("URL query Cleaned_K_Line = ", Cleaned_K_Line_Daily_file_dir)

        if request_data_Dict.__contains__("trading_direction"):
            if len(request_data_Dict["trading_direction"]) > 0:
                investment_method = str(request_data_Dict["trading_direction"][0])
        # print("Post trading_direction = ", investment_method)
        if request_Url_Query_Dict.__contains__("trading_direction"):
            investment_method = str(request_Url_Query_Dict["trading_direction"])
        # print("URL query trading_direction = ", investment_method)

        if request_data_Dict.__contains__("ticker_symbol"):
            if isinstance(request_data_Dict["ticker_symbol"], list):
                ticker_symbol_Array = request_data_Dict["ticker_symbol"]
        # print("Post ticker_symbol :\n", ticker_symbol_Array)
        if request_Url_Query_Dict.__contains__("ticker_symbol"):
            ticker_symbol_Array_Source = ast.literal_eval(str(request_Url_Query_Dict["ticker_symbol"]))  # 使用 ast.literal_eval() 函數執行字符串代碼語句;
            if isinstance(ticker_symbol_Array_Source, list):
                ticker_symbol_Array = ticker_symbol_Array_Source
        # print("URL query ticker_symbol :\n", ticker_symbol_Array)

        if request_data_Dict.__contains__("is_Optimize"):
            if len(request_data_Dict["is_Optimize"]) > 0:
                # is_Optimize = str(request_data_Dict["is_Optimize"][0])
                # is_Optimize = ast.literal_eval(str(request_data_Dict["is_Optimize"][0]))
                if request_data_Dict["is_Optimize"][0] == "true" or request_data_Dict["is_Optimize"][0] == "True" or request_data_Dict["is_Optimize"][0] == "TRUE" or request_data_Dict["is_Optimize"][0] == "1":
                    is_Optimize = True
                    # is_Optimize = "True"
                if request_data_Dict["is_Optimize"][0] == "false" or request_data_Dict["is_Optimize"][0] == "False" or request_data_Dict["is_Optimize"][0] == "FALSE" or request_data_Dict["is_Optimize"][0] == "0":
                    is_Optimize = False
                    # is_Optimize = "False"
        # print("Post is_Optimize = ", is_Optimize)
        if request_Url_Query_Dict.__contains__("is_Optimize"):
            # is_Optimize = str(request_Url_Query_Dict["is_Optimize"])
            # is_Optimize = ast.literal_eval(str(request_Url_Query_Dict["is_Optimize"]))
            if request_Url_Query_Dict["is_Optimize"] == "true" or request_Url_Query_Dict["is_Optimize"] == "True" or request_Url_Query_Dict["is_Optimize"] == "TRUE" or request_Url_Query_Dict["is_Optimize"] == "1":
                is_Optimize = True
                # is_Optimize = "True"
            if request_Url_Query_Dict["is_Optimize"] == "false" or request_Url_Query_Dict["is_Optimize"] == "False" or request_Url_Query_Dict["is_Optimize"] == "FALSE" or request_Url_Query_Dict["is_Optimize"] == "0":
                is_Optimize = False
                # is_Optimize = "False"
        # print("URL query is_Optimize = ", is_Optimize)

        if request_data_Dict.__contains__("PickStock_Pdata_0"):
            # PickStock_Pdata_0 = request_data_Dict["PickStock_Pdata_0"]
            if isinstance(request_data_Dict["PickStock_Pdata_0"], list) and len(request_data_Dict["PickStock_Pdata_0"]) > 0:
                PickStock_Pdata_0 = []
                for i in range(0, len(request_data_Dict["PickStock_Pdata_0"]), 1):
                    if isinstance(request_data_Dict["PickStock_Pdata_0"][i], str) and (request_data_Dict["PickStock_Pdata_0"][i] == "+math.inf" or request_data_Dict["PickStock_Pdata_0"][i] == "+inf" or request_data_Dict["PickStock_Pdata_0"][i] == "+Inf" or request_data_Dict["PickStock_Pdata_0"][i] == "+Infinity" or request_data_Dict["PickStock_Pdata_0"][i] == "+infinity" or request_data_Dict["PickStock_Pdata_0"][i] == "math.inf" or request_data_Dict["PickStock_Pdata_0"][i] == "inf" or request_data_Dict["PickStock_Pdata_0"][i] == "Inf" or request_data_Dict["PickStock_Pdata_0"][i] == "Infinity" or request_data_Dict["PickStock_Pdata_0"][i] == "infinity"):
                        PickStock_Pdata_0.append(+math.inf)
                    elif isinstance(request_data_Dict["PickStock_Pdata_0"][i], str) and (request_data_Dict["PickStock_Pdata_0"][i] == "-math.inf" or request_data_Dict["PickStock_Pdata_0"][i] == "-inf" or request_data_Dict["PickStock_Pdata_0"][i] == "-Inf" or request_data_Dict["PickStock_Pdata_0"][i] == "-Infinity" or request_data_Dict["PickStock_Pdata_0"][i] == "-infinity"):
                        PickStock_Pdata_0.append(-math.inf)
                    else:
                        PickStock_Pdata_0.append(float(request_data_Dict["PickStock_Pdata_0"][i]))
        # print("Post PickStock Pdata_0 :\n", PickStock_Pdata_0)
        if request_Url_Query_Dict.__contains__("PickStock_Pdata_0"):
            PickStock_Pdata_0_Source = ast.literal_eval(request_Url_Query_Dict["PickStock_Pdata_0"])
            # PickStock_Pdata_0 = PickStock_Pdata_0_Source
            if isinstance(PickStock_Pdata_0_Source, list) and len(PickStock_Pdata_0_Source) > 0:
                PickStock_Pdata_0 = []
                for i in range(0, len(PickStock_Pdata_0_Source), 1):
                    if isinstance(PickStock_Pdata_0_Source[i], str) and (PickStock_Pdata_0_Source[i] == "+math.inf" or PickStock_Pdata_0_Source[i] == "+inf" or PickStock_Pdata_0_Source[i] == "+Inf" or PickStock_Pdata_0_Source[i] == "+Infinity" or PickStock_Pdata_0_Source[i] == "+infinity" or PickStock_Pdata_0_Source[i] == "math.inf" or PickStock_Pdata_0_Source[i] == "inf" or PickStock_Pdata_0_Source[i] == "Inf" or PickStock_Pdata_0_Source[i] == "Infinity" or PickStock_Pdata_0_Source[i] == "infinity"):
                        PickStock_Pdata_0.append(+math.inf)
                    elif isinstance(PickStock_Pdata_0_Source[i], str) and (PickStock_Pdata_0_Source[i] == "-math.inf" or PickStock_Pdata_0_Source[i] == "-inf" or PickStock_Pdata_0_Source[i] == "-Inf" or PickStock_Pdata_0_Source[i] == "-Infinity" or PickStock_Pdata_0_Source[i] == "-infinity"):
                        PickStock_Pdata_0.append(-math.inf)
                    else:
                        PickStock_Pdata_0.append(float(PickStock_Pdata_0_Source[i]))
        # print("URL query PickStock Pdata_0 :\n", PickStock_Pdata_0)

        if request_data_Dict.__contains__("PickStock_Plower"):
            # PickStock_Plower = request_data_Dict["PickStock_Plower"]
            if isinstance(request_data_Dict["PickStock_Plower"], list) and len(request_data_Dict["PickStock_Plower"]) > 0:
                PickStock_Plower = []
                for i in range(0, len(request_data_Dict["PickStock_Plower"]), 1):
                    if isinstance(request_data_Dict["PickStock_Plower"][i], str) and (request_data_Dict["PickStock_Plower"][i] == "+math.inf" or request_data_Dict["PickStock_Plower"][i] == "+inf" or request_data_Dict["PickStock_Plower"][i] == "+Inf" or request_data_Dict["PickStock_Plower"][i] == "+Infinity" or request_data_Dict["PickStock_Plower"][i] == "+infinity" or request_data_Dict["PickStock_Plower"][i] == "math.inf" or request_data_Dict["PickStock_Plower"][i] == "inf" or request_data_Dict["PickStock_Plower"][i] == "Inf" or request_data_Dict["PickStock_Plower"][i] == "Infinity" or request_data_Dict["PickStock_Plower"][i] == "infinity"):
                        PickStock_Plower.append(+math.inf)
                    elif isinstance(request_data_Dict["PickStock_Plower"][i], str) and (request_data_Dict["PickStock_Plower"][i] == "-math.inf" or request_data_Dict["PickStock_Plower"][i] == "-inf" or request_data_Dict["PickStock_Plower"][i] == "-Inf" or request_data_Dict["PickStock_Plower"][i] == "-Infinity" or request_data_Dict["PickStock_Plower"][i] == "-infinity"):
                        PickStock_Plower.append(-math.inf)
                    else:
                        PickStock_Plower.append(float(request_data_Dict["PickStock_Plower"][i]))
        # print("Post PickStock Plower :\n", PickStock_Plower)
        if request_Url_Query_Dict.__contains__("PickStock_Plower"):
            PickStock_Plower_Source = ast.literal_eval(request_Url_Query_Dict["PickStock_Plower"])
            # PickStock_Plower = PickStock_Plower_Source
            if isinstance(PickStock_Plower_Source, list) and len(PickStock_Plower_Source) > 0:
                PickStock_Plower = []
                for i in range(0, len(PickStock_Plower_Source), 1):
                    if isinstance(PickStock_Plower_Source[i], str) and (PickStock_Plower_Source[i] == "+math.inf" or PickStock_Plower_Source[i] == "+inf" or PickStock_Plower_Source[i] == "+Inf" or PickStock_Plower_Source[i] == "+Infinity" or PickStock_Plower_Source[i] == "+infinity" or PickStock_Plower_Source[i] == "math.inf" or PickStock_Plower_Source[i] == "inf" or PickStock_Plower_Source[i] == "Inf" or PickStock_Plower_Source[i] == "Infinity" or PickStock_Plower_Source[i] == "infinity"):
                        PickStock_Plower.append(+math.inf)
                    elif isinstance(PickStock_Plower_Source[i], str) and (PickStock_Plower_Source[i] == "-math.inf" or PickStock_Plower_Source[i] == "-inf" or PickStock_Plower_Source[i] == "-Inf" or PickStock_Plower_Source[i] == "-Infinity" or PickStock_Plower_Source[i] == "-infinity"):
                        PickStock_Plower.append(-math.inf)
                    else:
                        PickStock_Plower.append(float(PickStock_Plower_Source[i]))
        # print("URL query PickStock Plower :\n", PickStock_Plower)

        if request_data_Dict.__contains__("PickStock_Pupper"):
            # PickStock_Pupper = request_data_Dict["PickStock_Pupper"]
            if isinstance(request_data_Dict["PickStock_Pupper"], list) and len(request_data_Dict["PickStock_Pupper"]) > 0:
                PickStock_Pupper = []
                for i in range(0, len(request_data_Dict["PickStock_Pupper"]), 1):
                    if isinstance(request_data_Dict["PickStock_Pupper"][i], str) and (request_data_Dict["PickStock_Pupper"][i] == "+math.inf" or request_data_Dict["PickStock_Pupper"][i] == "+inf" or request_data_Dict["PickStock_Pupper"][i] == "+Inf" or request_data_Dict["PickStock_Pupper"][i] == "+Infinity" or request_data_Dict["PickStock_Pupper"][i] == "+infinity" or request_data_Dict["PickStock_Pupper"][i] == "math.inf" or request_data_Dict["PickStock_Pupper"][i] == "inf" or request_data_Dict["PickStock_Pupper"][i] == "Inf" or request_data_Dict["PickStock_Pupper"][i] == "Infinity" or request_data_Dict["PickStock_Pupper"][i] == "infinity"):
                        PickStock_Pupper.append(+math.inf)
                    elif isinstance(request_data_Dict["PickStock_Pupper"][i], str) and (request_data_Dict["PickStock_Pupper"][i] == "-math.inf" or request_data_Dict["PickStock_Pupper"][i] == "-inf" or request_data_Dict["PickStock_Pupper"][i] == "-Inf" or request_data_Dict["PickStock_Pupper"][i] == "-Infinity" or request_data_Dict["PickStock_Pupper"][i] == "-infinity"):
                        PickStock_Pupper.append(-math.inf)
                    else:
                        PickStock_Pupper.append(float(request_data_Dict["PickStock_Pupper"][i]))
        # print("Post PickStock Pupper :\n", PickStock_Pupper)
        if request_Url_Query_Dict.__contains__("PickStock_Pupper"):
            PickStock_Pupper_Source = ast.literal_eval(request_Url_Query_Dict["PickStock_Pupper"])
            # PickStock_Pupper = PickStock_Pupper_Source
            if isinstance(PickStock_Pupper_Source, list) and len(PickStock_Pupper_Source) > 0:
                PickStock_Pupper = []
                for i in range(0, len(PickStock_Pupper_Source), 1):
                    if isinstance(PickStock_Pupper_Source[i], str) and (PickStock_Pupper_Source[i] == "+math.inf" or PickStock_Pupper_Source[i] == "+inf" or PickStock_Pupper_Source[i] == "+Inf" or PickStock_Pupper_Source[i] == "+Infinity" or PickStock_Pupper_Source[i] == "+infinity" or PickStock_Pupper_Source[i] == "math.inf" or PickStock_Pupper_Source[i] == "inf" or PickStock_Pupper_Source[i] == "Inf" or PickStock_Pupper_Source[i] == "Infinity" or PickStock_Pupper_Source[i] == "infinity"):
                        PickStock_Pupper.append(+math.inf)
                    elif isinstance(PickStock_Pupper_Source[i], str) and (PickStock_Pupper_Source[i] == "-math.inf" or PickStock_Pupper_Source[i] == "-inf" or PickStock_Pupper_Source[i] == "-Inf" or PickStock_Pupper_Source[i] == "-Infinity" or PickStock_Pupper_Source[i] == "-infinity"):
                        PickStock_Pupper.append(-math.inf)
                    else:
                        PickStock_Pupper.append(float(PickStock_Pupper_Source[i]))
        # print("URL query PickStock Pupper :\n", PickStock_Pupper)

        if request_data_Dict.__contains__("PickStock_weight"):
            # PickStock_weight = request_data_Dict["PickStock_weight"]
            if isinstance(request_data_Dict["PickStock_weight"], list) and len(request_data_Dict["PickStock_weight"]) > 0:
                PickStock_weight = []
                for i in range(0, len(request_data_Dict["PickStock_weight"]), 1):
                    if isinstance(request_data_Dict["PickStock_weight"][i], str) and (request_data_Dict["PickStock_weight"][i] == "+math.inf" or request_data_Dict["PickStock_weight"][i] == "+inf" or request_data_Dict["PickStock_weight"][i] == "+Inf" or request_data_Dict["PickStock_weight"][i] == "+Infinity" or request_data_Dict["PickStock_weight"][i] == "+infinity" or request_data_Dict["PickStock_weight"][i] == "math.inf" or request_data_Dict["PickStock_weight"][i] == "inf" or request_data_Dict["PickStock_weight"][i] == "Inf" or request_data_Dict["PickStock_weight"][i] == "Infinity" or request_data_Dict["PickStock_weight"][i] == "infinity"):
                        PickStock_weight.append(+math.inf)
                    elif isinstance(request_data_Dict["PickStock_weight"][i], str) and (request_data_Dict["PickStock_weight"][i] == "-math.inf" or request_data_Dict["PickStock_weight"][i] == "-inf" or request_data_Dict["PickStock_weight"][i] == "-Inf" or request_data_Dict["PickStock_weight"][i] == "-Infinity" or request_data_Dict["PickStock_weight"][i] == "-infinity"):
                        PickStock_weight.append(-math.inf)
                    else:
                        PickStock_weight.append(float(request_data_Dict["PickStock_weight"][i]))
        # print("Post PickStock weight :\n", PickStock_weight)
        if request_Url_Query_Dict.__contains__("PickStock_weight"):
            PickStock_weight_Source = ast.literal_eval(request_Url_Query_Dict["PickStock_weight"])
            # PickStock_weight = PickStock_weight_Source
            if isinstance(PickStock_weight_Source, list) and len(PickStock_weight_Source) > 0:
                PickStock_weight = []
                for i in range(0, len(PickStock_weight_Source), 1):
                    if isinstance(PickStock_weight_Source[i], str) and (PickStock_weight_Source[i] == "+math.inf" or PickStock_weight_Source[i] == "+inf" or PickStock_weight_Source[i] == "+Inf" or PickStock_weight_Source[i] == "+Infinity" or PickStock_weight_Source[i] == "+infinity" or PickStock_weight_Source[i] == "math.inf" or PickStock_weight_Source[i] == "inf" or PickStock_weight_Source[i] == "Inf" or PickStock_weight_Source[i] == "Infinity" or PickStock_weight_Source[i] == "infinity"):
                        PickStock_weight.append(+math.inf)
                    elif isinstance(PickStock_weight_Source[i], str) and (PickStock_weight_Source[i] == "-math.inf" or PickStock_weight_Source[i] == "-inf" or PickStock_weight_Source[i] == "-Inf" or PickStock_weight_Source[i] == "-Infinity" or PickStock_weight_Source[i] == "-infinity"):
                        PickStock_weight.append(-math.inf)
                    else:
                        PickStock_weight.append(float(PickStock_weight_Source[i]))
        # print("URL query PickStock weight :\n", PickStock_weight)

        if request_data_Dict.__contains__("MarketTiming_Pdata_0"):
            # MarketTiming_Pdata_0 = request_data_Dict["MarketTiming_Pdata_0"]
            if isinstance(request_data_Dict["MarketTiming_Pdata_0"], list) and len(request_data_Dict["MarketTiming_Pdata_0"]) > 0:
                MarketTiming_Pdata_0 = []
                for i in range(0, len(request_data_Dict["MarketTiming_Pdata_0"]), 1):
                    if isinstance(request_data_Dict["MarketTiming_Pdata_0"][i], str) and (request_data_Dict["MarketTiming_Pdata_0"][i] == "+math.inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "+inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "+Inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "+Infinity" or request_data_Dict["MarketTiming_Pdata_0"][i] == "+infinity" or request_data_Dict["MarketTiming_Pdata_0"][i] == "math.inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "Inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "Infinity" or request_data_Dict["MarketTiming_Pdata_0"][i] == "infinity"):
                        MarketTiming_Pdata_0.append(+math.inf)
                    elif isinstance(request_data_Dict["MarketTiming_Pdata_0"][i], str) and (request_data_Dict["MarketTiming_Pdata_0"][i] == "-math.inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "-inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "-Inf" or request_data_Dict["MarketTiming_Pdata_0"][i] == "-Infinity" or request_data_Dict["MarketTiming_Pdata_0"][i] == "-infinity"):
                        MarketTiming_Pdata_0.append(-math.inf)
                    else:
                        MarketTiming_Pdata_0.append(float(request_data_Dict["MarketTiming_Pdata_0"][i]))
        # print("Post MarketTiming Pdata_0 :\n", MarketTiming_Pdata_0)
        if request_Url_Query_Dict.__contains__("MarketTiming_Pdata_0"):
            MarketTiming_Pdata_0_Source = ast.literal_eval(request_Url_Query_Dict["MarketTiming_Pdata_0"])
            # MarketTiming_Pdata_0 = MarketTiming_Pdata_0_Source
            if isinstance(MarketTiming_Pdata_0_Source, list) and len(MarketTiming_Pdata_0_Source) > 0:
                MarketTiming_Pdata_0 = []
                for i in range(0, len(MarketTiming_Pdata_0_Source), 1):
                    if isinstance(MarketTiming_Pdata_0_Source[i], str) and (MarketTiming_Pdata_0_Source[i] == "+math.inf" or MarketTiming_Pdata_0_Source[i] == "+inf" or MarketTiming_Pdata_0_Source[i] == "+Inf" or MarketTiming_Pdata_0_Source[i] == "+Infinity" or MarketTiming_Pdata_0_Source[i] == "+infinity" or MarketTiming_Pdata_0_Source[i] == "math.inf" or MarketTiming_Pdata_0_Source[i] == "inf" or MarketTiming_Pdata_0_Source[i] == "Inf" or MarketTiming_Pdata_0_Source[i] == "Infinity" or MarketTiming_Pdata_0_Source[i] == "infinity"):
                        MarketTiming_Pdata_0.append(+math.inf)
                    elif isinstance(MarketTiming_Pdata_0_Source[i], str) and (MarketTiming_Pdata_0_Source[i] == "-math.inf" or MarketTiming_Pdata_0_Source[i] == "-inf" or MarketTiming_Pdata_0_Source[i] == "-Inf" or MarketTiming_Pdata_0_Source[i] == "-Infinity" or MarketTiming_Pdata_0_Source[i] == "-infinity"):
                        MarketTiming_Pdata_0.append(-math.inf)
                    else:
                        MarketTiming_Pdata_0.append(float(MarketTiming_Pdata_0_Source[i]))
        # print("URL query MarketTiming Pdata_0 :\n", MarketTiming_Pdata_0)

        if request_data_Dict.__contains__("MarketTiming_Plower"):
            # MarketTiming_Plower = request_data_Dict["MarketTiming_Plower"]
            if isinstance(request_data_Dict["MarketTiming_Plower"], list) and len(request_data_Dict["MarketTiming_Plower"]) > 0:
                MarketTiming_Plower = []
                for i in range(0, len(request_data_Dict["MarketTiming_Plower"]), 1):
                    if isinstance(request_data_Dict["MarketTiming_Plower"][i], str) and (request_data_Dict["MarketTiming_Plower"][i] == "+math.inf" or request_data_Dict["MarketTiming_Plower"][i] == "+inf" or request_data_Dict["MarketTiming_Plower"][i] == "+Inf" or request_data_Dict["MarketTiming_Plower"][i] == "+Infinity" or request_data_Dict["MarketTiming_Plower"][i] == "+infinity" or request_data_Dict["MarketTiming_Plower"][i] == "math.inf" or request_data_Dict["MarketTiming_Plower"][i] == "inf" or request_data_Dict["MarketTiming_Plower"][i] == "Inf" or request_data_Dict["MarketTiming_Plower"][i] == "Infinity" or request_data_Dict["MarketTiming_Plower"][i] == "infinity"):
                        MarketTiming_Plower.append(+math.inf)
                    elif isinstance(request_data_Dict["MarketTiming_Plower"][i], str) and (request_data_Dict["MarketTiming_Plower"][i] == "-math.inf" or request_data_Dict["MarketTiming_Plower"][i] == "-inf" or request_data_Dict["MarketTiming_Plower"][i] == "-Inf" or request_data_Dict["MarketTiming_Plower"][i] == "-Infinity" or request_data_Dict["MarketTiming_Plower"][i] == "-infinity"):
                        MarketTiming_Plower.append(-math.inf)
                    else:
                        MarketTiming_Plower.append(float(request_data_Dict["MarketTiming_Plower"][i]))
        # print("Post MarketTiming Plower :\n", MarketTiming_Plower)
        if request_Url_Query_Dict.__contains__("MarketTiming_Plower"):
            MarketTiming_Plower_Source = ast.literal_eval(request_Url_Query_Dict["MarketTiming_Plower"])
            # MarketTiming_Plower = MarketTiming_Plower_Source
            if isinstance(MarketTiming_Plower_Source, list) and len(MarketTiming_Plower_Source) > 0:
                MarketTiming_Plower = []
                for i in range(0, len(MarketTiming_Plower_Source), 1):
                    if isinstance(MarketTiming_Plower_Source[i], str) and (MarketTiming_Plower_Source[i] == "+math.inf" or MarketTiming_Plower_Source[i] == "+inf" or MarketTiming_Plower_Source[i] == "+Inf" or MarketTiming_Plower_Source[i] == "+Infinity" or MarketTiming_Plower_Source[i] == "+infinity" or MarketTiming_Plower_Source[i] == "math.inf" or MarketTiming_Plower_Source[i] == "inf" or MarketTiming_Plower_Source[i] == "Inf" or MarketTiming_Plower_Source[i] == "Infinity" or MarketTiming_Plower_Source[i] == "infinity"):
                        MarketTiming_Plower.append(+math.inf)
                    elif isinstance(MarketTiming_Plower_Source[i], str) and (MarketTiming_Plower_Source[i] == "-math.inf" or MarketTiming_Plower_Source[i] == "-inf" or MarketTiming_Plower_Source[i] == "-Inf" or MarketTiming_Plower_Source[i] == "-Infinity" or MarketTiming_Plower_Source[i] == "-infinity"):
                        MarketTiming_Plower.append(-math.inf)
                    else:
                        MarketTiming_Plower.append(float(MarketTiming_Plower_Source[i]))
        # print("URL query MarketTiming Plower :\n", MarketTiming_Plower)

        if request_data_Dict.__contains__("MarketTiming_Pupper"):
            # MarketTiming_Pupper = request_data_Dict["MarketTiming_Pupper"]
            if isinstance(request_data_Dict["MarketTiming_Pupper"], list) and len(request_data_Dict["MarketTiming_Pupper"]) > 0:
                MarketTiming_Pupper = []
                for i in range(0, len(request_data_Dict["MarketTiming_Pupper"]), 1):
                    if isinstance(request_data_Dict["MarketTiming_Pupper"][i], str) and (request_data_Dict["MarketTiming_Pupper"][i] == "+math.inf" or request_data_Dict["MarketTiming_Pupper"][i] == "+inf" or request_data_Dict["MarketTiming_Pupper"][i] == "+Inf" or request_data_Dict["MarketTiming_Pupper"][i] == "+Infinity" or request_data_Dict["MarketTiming_Pupper"][i] == "+infinity" or request_data_Dict["MarketTiming_Pupper"][i] == "math.inf" or request_data_Dict["MarketTiming_Pupper"][i] == "inf" or request_data_Dict["MarketTiming_Pupper"][i] == "Inf" or request_data_Dict["MarketTiming_Pupper"][i] == "Infinity" or request_data_Dict["MarketTiming_Pupper"][i] == "infinity"):
                        MarketTiming_Pupper.append(+math.inf)
                    elif isinstance(request_data_Dict["MarketTiming_Pupper"][i], str) and (request_data_Dict["MarketTiming_Pupper"][i] == "-math.inf" or request_data_Dict["MarketTiming_Pupper"][i] == "-inf" or request_data_Dict["MarketTiming_Pupper"][i] == "-Inf" or request_data_Dict["MarketTiming_Pupper"][i] == "-Infinity" or request_data_Dict["MarketTiming_Pupper"][i] == "-infinity"):
                        MarketTiming_Pupper.append(-math.inf)
                    else:
                        MarketTiming_Pupper.append(float(request_data_Dict["MarketTiming_Pupper"][i]))
        # print("Post MarketTiming Pupper :\n", MarketTiming_Pupper)
        if request_Url_Query_Dict.__contains__("MarketTiming_Pupper"):
            MarketTiming_Pupper_Source = ast.literal_eval(request_Url_Query_Dict["MarketTiming_Pupper"])
            # MarketTiming_Pupper = MarketTiming_Pupper_Source
            if isinstance(MarketTiming_Pupper_Source, list) and len(MarketTiming_Pupper_Source) > 0:
                MarketTiming_Pupper = []
                for i in range(0, len(MarketTiming_Pupper_Source), 1):
                    if isinstance(MarketTiming_Pupper_Source[i], str) and (MarketTiming_Pupper_Source[i] == "+math.inf" or MarketTiming_Pupper_Source[i] == "+inf" or MarketTiming_Pupper_Source[i] == "+Inf" or MarketTiming_Pupper_Source[i] == "+Infinity" or MarketTiming_Pupper_Source[i] == "+infinity" or MarketTiming_Pupper_Source[i] == "math.inf" or MarketTiming_Pupper_Source[i] == "inf" or MarketTiming_Pupper_Source[i] == "Inf" or MarketTiming_Pupper_Source[i] == "Infinity" or MarketTiming_Pupper_Source[i] == "infinity"):
                        MarketTiming_Pupper.append(+math.inf)
                    elif isinstance(MarketTiming_Pupper_Source[i], str) and (MarketTiming_Pupper_Source[i] == "-math.inf" or MarketTiming_Pupper_Source[i] == "-inf" or MarketTiming_Pupper_Source[i] == "-Inf" or MarketTiming_Pupper_Source[i] == "-Infinity" or MarketTiming_Pupper_Source[i] == "-infinity"):
                        MarketTiming_Pupper.append(-math.inf)
                    else:
                        MarketTiming_Pupper.append(float(MarketTiming_Pupper_Source[i]))
        # print("URL query MarketTiming Pupper :\n", MarketTiming_Pupper)

        if request_data_Dict.__contains__("MarketTiming_weight"):
            # MarketTiming_weight = request_data_Dict["MarketTiming_weight"]
            if isinstance(request_data_Dict["MarketTiming_weight"], list) and len(request_data_Dict["MarketTiming_weight"]) > 0:
                MarketTiming_weight = []
                for i in range(0, len(request_data_Dict["MarketTiming_weight"]), 1):
                    if isinstance(request_data_Dict["MarketTiming_weight"][i], str) and (request_data_Dict["MarketTiming_weight"][i] == "+math.inf" or request_data_Dict["MarketTiming_weight"][i] == "+inf" or request_data_Dict["MarketTiming_weight"][i] == "+Inf" or request_data_Dict["MarketTiming_weight"][i] == "+Infinity" or request_data_Dict["MarketTiming_weight"][i] == "+infinity" or request_data_Dict["MarketTiming_weight"][i] == "math.inf" or request_data_Dict["MarketTiming_weight"][i] == "inf" or request_data_Dict["MarketTiming_weight"][i] == "Inf" or request_data_Dict["MarketTiming_weight"][i] == "Infinity" or request_data_Dict["MarketTiming_weight"][i] == "infinity"):
                        MarketTiming_weight.append(+math.inf)
                    elif isinstance(request_data_Dict["MarketTiming_weight"][i], str) and (request_data_Dict["MarketTiming_weight"][i] == "-math.inf" or request_data_Dict["MarketTiming_weight"][i] == "-inf" or request_data_Dict["MarketTiming_weight"][i] == "-Inf" or request_data_Dict["MarketTiming_weight"][i] == "-Infinity" or request_data_Dict["MarketTiming_weight"][i] == "-infinity"):
                        MarketTiming_weight.append(-math.inf)
                    else:
                        MarketTiming_weight.append(float(request_data_Dict["MarketTiming_weight"][i]))
        # print("Post MarketTiming weight :\n", MarketTiming_weight)
        if request_Url_Query_Dict.__contains__("MarketTiming_weight"):
            MarketTiming_weight_Source = ast.literal_eval(request_Url_Query_Dict["MarketTiming_weight"])
            # MarketTiming_weight = MarketTiming_weight_Source
            if isinstance(MarketTiming_weight_Source, list) and len(MarketTiming_weight_Source) > 0:
                MarketTiming_weight = []
                for i in range(0, len(MarketTiming_weight_Source), 1):
                    if isinstance(MarketTiming_weight_Source[i], str) and (MarketTiming_weight_Source[i] == "+math.inf" or MarketTiming_weight_Source[i] == "+inf" or MarketTiming_weight_Source[i] == "+Inf" or MarketTiming_weight_Source[i] == "+Infinity" or MarketTiming_weight_Source[i] == "+infinity" or MarketTiming_weight_Source[i] == "math.inf" or MarketTiming_weight_Source[i] == "inf" or MarketTiming_weight_Source[i] == "Inf" or MarketTiming_weight_Source[i] == "Infinity" or MarketTiming_weight_Source[i] == "infinity"):
                        MarketTiming_weight.append(+math.inf)
                    elif isinstance(MarketTiming_weight_Source[i], str) and (MarketTiming_weight_Source[i] == "-math.inf" or MarketTiming_weight_Source[i] == "-inf" or MarketTiming_weight_Source[i] == "-Inf" or MarketTiming_weight_Source[i] == "-Infinity" or MarketTiming_weight_Source[i] == "-infinity"):
                        MarketTiming_weight.append(-math.inf)
                    else:
                        MarketTiming_weight.append(float(MarketTiming_weight_Source[i]))
        # print("URL query MarketTiming weight :\n", MarketTiming_weight)

        if request_data_Dict.__contains__("training_data_file"):
            if isinstance(request_data_Dict["training_data_file"], list) and len(request_data_Dict["training_data_file"]) > 0 and isinstance(request_data_Dict["training_data_file"][0], str) and len(request_data_Dict["training_data_file"][0]) > 0:
                training_data_Source = {}
                if os.path.exists(str(request_data_Dict["training_data_file"][0])) and os.path.isfile(str(request_data_Dict["training_data_file"][0])):
                    with open(str(request_data_Dict["training_data_file"][0]), "rb") as f:
                        training_data_Source = pickle.load(f)
                        f.close()
                else:
                    print("training data file: [ ", str(request_data_Dict["training_data_file"][0]), " ] unrecognized.")
                # if os.path.exists(Cleaned_K_Line_Daily_file_dir) and os.path.isfile(Cleaned_K_Line_Daily_file_dir):
                #     with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
                #         training_data_Source = pickle.load(f)
                #         f.close()
                # else:
                #     print("training data file: [ ", str(Cleaned_K_Line_Daily_file_dir), " ] unrecognized.")
                # print(training_data_Source)
                if isinstance(training_data_Source, dict) and len(training_data_Source) > 0:
                    if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                        if not ("training_data" in locals() and isinstance(training_data, dict)):
                            training_data = {}
                        if "all" in ticker_symbol_Array:
                            # training_data = training_data_Source
                            for key, value in training_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                training_data[key] = value
                        if not ("all" in ticker_symbol_Array):
                            for key, value in training_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                if key in ticker_symbol_Array:
                                    training_data[key] = value
        if request_data_Dict.__contains__("training_data"):
            if isinstance(request_data_Dict["training_data"], dict) and len(request_data_Dict["training_data"]) > 0:
                if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                    if not ("training_data" in locals() and isinstance(training_data, dict)):
                        training_data = {}
                    if "all" in ticker_symbol_Array:
                        # training_data = request_data_Dict["training_data"]
                        for key, value in request_data_Dict["training_data"].items():
                            # print("Key: %s, Value:\n%s" % (key, value))
                            training_data[key] = value
                    if not ("all" in ticker_symbol_Array):
                        for key, value in request_data_Dict["training_data"].items():
                            # print("Key: %s, Value:\n%s" % (key, value))
                            if key in ticker_symbol_Array:
                                training_data[key] = value
        # print("Post training data :\n", training_data)
        if request_Url_Query_Dict.__contains__("training_data_file"):
            if isinstance(request_Url_Query_Dict["training_data_file"], str) and len(request_Url_Query_Dict["training_data_file"]) > 0:
                training_data_Source = {}
                if os.path.exists(str(request_Url_Query_Dict["training_data_file"])) and os.path.isfile(str(request_Url_Query_Dict["training_data_file"])):
                    # training_data_Source = ast.literal_eval(request_Url_Query_Dict["training_data_file"])
                    with open(str(request_Url_Query_Dict["training_data_file"]), "rb") as f:
                        training_data_Source = pickle.load(f)
                        f.close()
                else:
                    print("training data file: [ ", str(request_Url_Query_Dict["training_data_file"]), " ] unrecognized.")
                # if os.path.exists(Cleaned_K_Line_Daily_file_dir) and os.path.isfile(Cleaned_K_Line_Daily_file_dir):
                #     with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
                #         training_data_Source = pickle.load(f)
                #         f.close()
                # else:
                #     print("training data file: [ ", str(Cleaned_K_Line_Daily_file_dir), " ] unrecognized.")
                # print(training_data_Source)
                if isinstance(training_data_Source, dict) and len(training_data_Source) > 0:
                    if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                        if not ("training_data" in locals() and isinstance(training_data, dict)):
                            training_data = {}
                        if "all" in ticker_symbol_Array:
                            # training_data = training_data_Source
                            for key, value in training_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                training_data[key] = value
                        if not ("all" in ticker_symbol_Array):
                            for key, value in training_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                if key in ticker_symbol_Array:
                                    training_data[key] = value
        # print("URL query training data :\n", training_data)
        if isinstance(training_data, dict) and len(training_data) > 0:
            for key, value in training_data.items():
                if isinstance(value, dict) and len(value) > 0:
                    if value.__contains__("date_transaction"):
                        if isinstance(value["date_transaction"], list) and len(value["date_transaction"]) > 0:
                            for i in range(0, len(value["date_transaction"]), 1):
                                # print("Index: %d, Value: %s" % (i, value["date_transaction"][i]))
                                if isinstance(value["date_transaction"][i], str) and value["date_transaction"][i] != "":
                                    training_data[key]["date_transaction"][i] = datetime.datetime.strptime(str(str(str(training_data[key]["date_transaction"][i]).replace("/", "-")).strip()), "%Y-%m-%d").date()
        # print("training data :\n", training_data)

        if request_data_Dict.__contains__("testing_data_file"):
            if isinstance(request_data_Dict["testing_data_file"], list) and len(request_data_Dict["testing_data_file"]) > 0 and isinstance(request_data_Dict["testing_data_file"][0], str) and len(request_data_Dict["testing_data_file"][0]) > 0:
                testing_data_Source = {}
                if os.path.exists(str(request_data_Dict["testing_data_file"][0])) and os.path.isfile(str(request_data_Dict["testing_data_file"][0])):
                    with open(str(request_data_Dict["testing_data_file"][0]), "rb") as f:
                        testing_data_Source = pickle.load(f)
                        f.close()
                else:
                    print("testing data file: [ ", str(request_data_Dict["testing_data_file"][0]), " ] unrecognized.")
                # if os.path.exists(Cleaned_K_Line_Daily_file_dir) and os.path.isfile(Cleaned_K_Line_Daily_file_dir):
                #     with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
                #         testing_data_Source = pickle.load(f)
                #         f.close()
                # else:
                #     print("testing data file: [ ", str(Cleaned_K_Line_Daily_file_dir), " ] unrecognized.")
                # print(testing_data_Source)
                if isinstance(testing_data_Source, dict) and len(testing_data_Source) > 0:
                    if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                        if not ("testing_data" in locals() and isinstance(testing_data, dict)):
                            testing_data = {}
                        if "all" in ticker_symbol_Array:
                            # testing_data = testing_data_Source
                            for key, value in testing_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                testing_data[key] = value
                        if not ("all" in ticker_symbol_Array):
                            for key, value in testing_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                if key in ticker_symbol_Array:
                                    testing_data[key] = value
        if request_data_Dict.__contains__("testing_data"):
            if isinstance(request_data_Dict["testing_data"], dict) and len(request_data_Dict["testing_data"]) > 0:
                if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                    if not ("testing_data" in locals() and isinstance(testing_data, dict)):
                        testing_data = {}
                    if "all" in ticker_symbol_Array:
                        # testing_data = request_data_Dict["testing_data"]
                        for key, value in request_data_Dict["testing_data"].items():
                            # print("Key: %s, Value:\n%s" % (key, value))
                            testing_data[key] = value
                    if not ("all" in ticker_symbol_Array):
                        for key, value in request_data_Dict["testing_data"].items():
                            # print("Key: %s, Value:\n%s" % (key, value))
                            if key in ticker_symbol_Array:
                                testing_data[key] = value
        # print("Post testing data :\n", testing_data)
        if request_Url_Query_Dict.__contains__("testing_data_file"):
            if isinstance(request_Url_Query_Dict["testing_data_file"], str) and len(request_Url_Query_Dict["testing_data_file"]) > 0:
                testing_data_Source = {}
                if os.path.exists(str(request_Url_Query_Dict["testing_data_file"])) and os.path.isfile(str(request_Url_Query_Dict["testing_data_file"])):
                    # testing_data_Source = ast.literal_eval(request_Url_Query_Dict["testing_data_file"])
                    with open(str(request_Url_Query_Dict["testing_data_file"]), "rb") as f:
                        testing_data_Source = pickle.load(f)
                        f.close()
                else:
                    print("testing data file: [ ", str(request_Url_Query_Dict["testing_data_file"]), " ] unrecognized.")
                # if os.path.exists(Cleaned_K_Line_Daily_file_dir) and os.path.isfile(Cleaned_K_Line_Daily_file_dir):
                #     with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
                #         testing_data_Source = pickle.load(f)
                #         f.close()
                # else:
                #     print("testing data file: [ ", str(Cleaned_K_Line_Daily_file_dir), " ] unrecognized.")
                # print(testing_data_Source)
                if isinstance(testing_data_Source, dict) and len(testing_data_Source) > 0:
                    if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                        if not ("testing_data" in locals() and isinstance(testing_data, dict)):
                            testing_data = {}
                        if "all" in ticker_symbol_Array:
                            # testing_data = testing_data_Source
                            for key, value in testing_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                testing_data[key] = value
                        if not ("all" in ticker_symbol_Array):
                            for key, value in testing_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                if key in ticker_symbol_Array:
                                    testing_data[key] = value
        # print("URL query testing data :\n", testing_data)
        if isinstance(testing_data, dict) and len(testing_data) > 0:
            for key, value in testing_data.items():
                if isinstance(value, dict) and len(value) > 0:
                    if value.__contains__("date_transaction"):
                        if isinstance(value["date_transaction"], list) and len(value["date_transaction"]) > 0:
                            for i in range(0, len(value["date_transaction"]), 1):
                                # print("Index: %d, Value: %s" % (i, value["date_transaction"][i]))
                                if isinstance(value["date_transaction"][i], str) and value["date_transaction"][i] != "":
                                    testing_data[key]["date_transaction"][i] = datetime.datetime.strptime(str(str(str(testing_data[key]["date_transaction"][i]).replace("/", "-")).strip()), "%Y-%m-%d").date()
        # print("testing data :\n", testing_data)

        if request_data_Dict.__contains__("stepping_data_file"):
            if isinstance(request_data_Dict["stepping_data_file"], list) and len(request_data_Dict["stepping_data_file"]) > 0 and isinstance(request_data_Dict["stepping_data_file"][0], str) and len(request_data_Dict["stepping_data_file"][0]) > 0:
                stepping_data_Source = {}
                if os.path.exists(str(request_data_Dict["stepping_data_file"][0])) and os.path.isfile(str(request_data_Dict["stepping_data_file"][0])):
                    with open(str(request_data_Dict["stepping_data_file"][0]), "rb") as f:
                        stepping_data_Source = pickle.load(f)
                        f.close()
                else:
                    print("stepping data file: [ ", str(request_data_Dict["stepping_data_file"][0]), " ] unrecognized.")
                # if os.path.exists(Cleaned_K_Line_Daily_file_dir) and os.path.isfile(Cleaned_K_Line_Daily_file_dir):
                #     with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
                #         stepping_data_Source = pickle.load(f)
                #         f.close()
                # else:
                #     print("stepping data file: [ ", str(Cleaned_K_Line_Daily_file_dir), " ] unrecognized.")
                # print(stepping_data_Source)
                if isinstance(stepping_data_Source, dict) and len(stepping_data_Source) > 0:
                    if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                        if not ("stepping_data" in locals() and isinstance(stepping_data, dict)):
                            stepping_data = {}
                        if "all" in ticker_symbol_Array:
                            # stepping_data = stepping_data_Source
                            for key, value in stepping_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                stepping_data[key] = value
                        if not ("all" in ticker_symbol_Array):
                            for key, value in stepping_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                if key in ticker_symbol_Array:
                                    stepping_data[key] = value
        if request_data_Dict.__contains__("stepping_data"):
            if isinstance(request_data_Dict["stepping_data"], dict) and len(request_data_Dict["stepping_data"]) > 0:
                if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                    if not ("stepping_data" in locals() and isinstance(stepping_data, dict)):
                        stepping_data = {}
                    if "all" in ticker_symbol_Array:
                        # stepping_data = request_data_Dict["stepping_data"]
                        for key, value in request_data_Dict["stepping_data"].items():
                            # print("Key: %s, Value:\n%s" % (key, value))
                            stepping_data[key] = value
                    if not ("all" in ticker_symbol_Array):
                        for key, value in request_data_Dict["stepping_data"].items():
                            # print("Key: %s, Value:\n%s" % (key, value))
                            if key in ticker_symbol_Array:
                                stepping_data[key] = value
        # print("Post stepping data :\n", stepping_data)
        if request_Url_Query_Dict.__contains__("stepping_data_file"):
            if isinstance(request_Url_Query_Dict["stepping_data_file"], str) and len(request_Url_Query_Dict["stepping_data_file"]) > 0:
                stepping_data_Source = {}
                if os.path.exists(str(request_Url_Query_Dict["stepping_data_file"])) and os.path.isfile(str(request_Url_Query_Dict["stepping_data_file"])):
                    # stepping_data_Source = ast.literal_eval(request_Url_Query_Dict["stepping_data_file"])
                    with open(str(request_Url_Query_Dict["stepping_data_file"]), "rb") as f:
                        stepping_data_Source = pickle.load(f)
                        f.close()
                else:
                    print("stepping data file: [ ", str(request_Url_Query_Dict["stepping_data_file"]), " ] unrecognized.")
                # if os.path.exists(Cleaned_K_Line_Daily_file_dir) and os.path.isfile(Cleaned_K_Line_Daily_file_dir):
                #     with open(Cleaned_K_Line_Daily_file_dir, "rb") as f:
                #         stepping_data_Source = pickle.load(f)
                #         f.close()
                # else:
                #     print("stepping data file: [ ", str(Cleaned_K_Line_Daily_file_dir), " ] unrecognized.")
                # print(stepping_data_Source)
                if isinstance(stepping_data_Source, dict) and len(stepping_data_Source) > 0:
                    if isinstance(ticker_symbol_Array, list) and len(ticker_symbol_Array) > 0:
                        if not ("stepping_data" in locals() and isinstance(stepping_data, dict)):
                            stepping_data = {}
                        if "all" in ticker_symbol_Array:
                            # stepping_data = stepping_data_Source
                            for key, value in stepping_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                stepping_data[key] = value
                        if not ("all" in ticker_symbol_Array):
                            for key, value in stepping_data_Source.items():
                                # print("Key: %s, Value:\n%s" % (key, value))
                                if key in ticker_symbol_Array:
                                    stepping_data[key] = value
        # print("URL query stepping data :\n", stepping_data)
        if isinstance(stepping_data, dict) and len(stepping_data) > 0:
            for key, value in stepping_data.items():
                if isinstance(value, dict) and len(value) > 0:
                    if value.__contains__("date_transaction"):
                        if isinstance(value["date_transaction"], list) and len(value["date_transaction"]) > 0:
                            for i in range(0, len(value["date_transaction"]), 1):
                                # print("Index: %d, Value: %s" % (i, value["date_transaction"][i]))
                                if isinstance(value["date_transaction"][i], str) and value["date_transaction"][i] != "":
                                    stepping_data[key]["date_transaction"][i] = datetime.datetime.strptime(str(str(str(stepping_data[key]["date_transaction"][i]).replace("/", "-")).strip()), "%Y-%m-%d").date()
        # print("stepping data :\n", stepping_data)

        # 若 testing_data 數據集爲空，則將其賦值爲等同 training_data 數據集;
        if ("training_data" in locals()) and ((not ("testing_data" in locals())) or (isinstance(testing_data, dict) and len(testing_data) == 0)):
            testing_data = training_data

        response_data_Dict = {}
        # response_data_Dict["Cleaned_K_Line"] = str(Cleaned_K_Line_Daily_file_dir);
        response_data_Dict["trading_direction"] = str(investment_method)
        response_data_Dict["is_Optimize"] = str("True" if is_Optimize else "False")
        response_data_Dict["ticker_symbol"] = ticker_symbol_Array
        response_data_Dict["PickStock_Pdata_0"] = PickStock_Pdata_0
        # response_data_Dict["PickStock_Plower"] = PickStock_Plower
        # response_data_Dict["PickStock_Pupper"] = PickStock_Pupper
        # response_data_Dict["PickStock_weight"] = PickStock_weight
        response_data_Dict["MarketTiming_Pdata_0"] = MarketTiming_Pdata_0
        # response_data_Dict["MarketTiming_Plower"] = MarketTiming_Plower
        # response_data_Dict["MarketTiming_Pupper"] = MarketTiming_Pupper
        # response_data_Dict["MarketTiming_weight"] = MarketTiming_weight

        # response_data_Dict["stepping_data"] = {}
        # stepping_data = Quantitative_Data_Cleaning.stepping_data
        # if isinstance(stepping_data, dict) and len(stepping_data) > 0:
        #     for key, value in stepping_data.items():
        #         # print("Key: %s, Value:\n%s" % (key, value))
        #         response_data_Dict["stepping_data"][key] = value

        response_data_Dict["return_PickStock"] = {}
        if is_Optimize == False:

            return_PickStock_fit_model = PickStock_fit_model(
                training_data,  # {}
                PickStock_Pdata_0[0],  # int(3),  # P1,  # 觀察收益率歷史向前推的交易日長度;
                PickStock_Pdata_0[1],  # int(10),  # P2  # 依據市值高低分組選股的分類數目;
                {key: {"Long_Position": MarketTiming_Pdata_0, "Short_Selling": MarketTiming_Pdata_0} for key, value in training_data.items()},  # 按照擇時規則優化之後的參數字典;  # {}
                MarketTiming,
                MarketTiming_fit_model,
                Intuitive_Momentum_KLine,
                investment_method  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
            )

            if investment_method == "Long_Position_and_Short_Selling":
                response_data_Dict["return_PickStock"]["Coefficient"] = {"Long_Position": PickStock_Pdata_0, "Short_Selling": PickStock_Pdata_0}
            elif investment_method == "Long_Position":
                response_data_Dict["return_PickStock"]["Coefficient"] = {str(investment_method): PickStock_Pdata_0}
            elif investment_method == "Short_Selling":
                response_data_Dict["return_PickStock"]["Coefficient"] = {str(investment_method): PickStock_Pdata_0}
            # else:
            response_data_Dict["return_PickStock"]["PickStock_sort_ticker"] = return_PickStock_fit_model["PickStock_sort"]["ticker_symbol"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
            response_data_Dict["return_PickStock"]["PickStock_sort_score"] = return_PickStock_fit_model["PickStock_sort"]["score"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
            response_data_Dict["return_PickStock"]["y_profit"] = return_PickStock_fit_model["y_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
            response_data_Dict["return_PickStock"]["y_Long_Position_profit"] = return_PickStock_fit_model["y_Long_Position_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
            response_data_Dict["return_PickStock"]["y_Short_Selling_profit"] = return_PickStock_fit_model["y_Short_Selling_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
            response_data_Dict["return_PickStock"]["y_loss"] = return_PickStock_fit_model["y_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
            response_data_Dict["return_PickStock"]["y_Long_Position_loss"] = return_PickStock_fit_model["y_Long_Position_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
            response_data_Dict["return_PickStock"]["y_Short_Selling_loss"] = return_PickStock_fit_model["y_Short_Selling_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
            response_data_Dict["return_PickStock"]["maximum_drawdown"] = return_PickStock_fit_model["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            response_data_Dict["return_PickStock"]["maximum_drawdown_Long_Position"] = return_PickStock_fit_model["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            response_data_Dict["return_PickStock"]["maximum_drawdown_Short_Selling"] = return_PickStock_fit_model["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            response_data_Dict["return_PickStock"]["profit_total"] = return_PickStock_fit_model["profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
            response_data_Dict["return_PickStock"]["Long_Position_profit_total"] = return_PickStock_fit_model["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
            response_data_Dict["return_PickStock"]["Short_Selling_profit_total"] = return_PickStock_fit_model["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
            response_data_Dict["return_PickStock"]["profit_Positive"] = return_PickStock_fit_model["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            response_data_Dict["return_PickStock"]["profit_Negative"] = return_PickStock_fit_model["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            response_data_Dict["return_PickStock"]["Long_Position_profit_Positive"] = return_PickStock_fit_model["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            response_data_Dict["return_PickStock"]["Long_Position_profit_Negative"] = return_PickStock_fit_model["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive"] = return_PickStock_fit_model["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative"] = return_PickStock_fit_model["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            response_data_Dict["return_PickStock"]["profit_Positive_probability"] = return_PickStock_fit_model["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            response_data_Dict["return_PickStock"]["profit_Negative_probability"] = return_PickStock_fit_model["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            response_data_Dict["return_PickStock"]["Long_Position_profit_Positive_probability"] = return_PickStock_fit_model["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            response_data_Dict["return_PickStock"]["Long_Position_profit_Negative_probability"] = return_PickStock_fit_model["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive_probability"] = return_PickStock_fit_model["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative_probability"] = return_PickStock_fit_model["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            response_data_Dict["return_PickStock"]["average_price_amplitude_date_transaction"] = return_PickStock_fit_model["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            response_data_Dict["return_PickStock"]["Long_Position_average_price_amplitude_date_transaction"] = return_PickStock_fit_model["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            response_data_Dict["return_PickStock"]["Short_Selling_average_price_amplitude_date_transaction"] = return_PickStock_fit_model["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            response_data_Dict["return_PickStock"]["average_volume_turnover_date_transaction"] = return_PickStock_fit_model["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            response_data_Dict["return_PickStock"]["Long_Position_average_volume_turnover_date_transaction"] = return_PickStock_fit_model["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            response_data_Dict["return_PickStock"]["Short_Selling_average_volume_turnover_date_transaction"] = return_PickStock_fit_model["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            response_data_Dict["return_PickStock"]["average_date_transaction_between"] = return_PickStock_fit_model["average_date_transaction_between"]  # 兩次交易間隔日長，均值;
            response_data_Dict["return_PickStock"]["Long_Position_average_date_transaction_between"] = return_PickStock_fit_model["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            response_data_Dict["return_PickStock"]["Short_Selling_average_date_transaction_between"] = return_PickStock_fit_model["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            response_data_Dict["return_PickStock"]["number_PickStock_transaction"] = return_PickStock_fit_model["number_PickStock_transaction"]  # 交易過股票的總隻數;

        elif is_Optimize == True:

            # 優化求解擇時參數;
            MarketTiming_Parameter = {}  # 依照擇時規則優化之後得到的擇時規則的輸入參數存儲字典;
            weight_MarketTiming_Dict = {}  # 依照擇時規則交易倉位參數的存儲字典;
            Plower_weight_MarketTiming_Dict = {}
            Pupper_weight_MarketTiming_Dict = {}
            if isinstance(training_data, dict) and int(len(training_data)) > int(0):
                for key, value in training_data.items():
                    # print("Key: {key}, Value: {value}")
                    if isinstance(value, dict) and ("date_transaction" in value and isinstance(value["date_transaction"], list)) and ("turnover_volume" in value and isinstance(value["turnover_volume"], list)) and ("opening_price" in value and isinstance(value["opening_price"], list)) and ("close_price" in value and isinstance(value["close_price"], list)) and ("low_price" in value and isinstance(value["low_price"], list)) and ("high_price" in value and isinstance(value["high_price"], list)) and ("focus" in value and isinstance(value["focus"], list)) and ("amplitude" in value and isinstance(value["amplitude"], list)) and ("amplitude_rate" in value and isinstance(value["amplitude_rate"], list)) and ("opening_price_Standardization" in value and isinstance(value["opening_price_Standardization"], list)) and ("closing_price_Standardization" in value and isinstance(value["closing_price_Standardization"], list)) and ("low_price_Standardization" in value and isinstance(value["low_price_Standardization"], list)) and ("high_price_Standardization" in value and isinstance(value["high_price_Standardization"], list)) and ("turnover_volume_growth_rate" in value and isinstance(value["turnover_volume_growth_rate"], list)) and ("opening_price_growth_rate" in value and isinstance(value["opening_price_growth_rate"], list)) and ("closing_price_growth_rate" in value and isinstance(value["closing_price_growth_rate"], list)) and ("closing_minus_opening_price_growth_rate" in value and isinstance(value["closing_minus_opening_price_growth_rate"], list)) and ("high_price_proportion" in value and isinstance(value["high_price_proportion"], list)) and ("low_price_proportion" in value and isinstance(value["low_price_proportion"], list)):

                        x0 = value["date_transaction"]  # 交易日期;
                        x1 = value["turnover_volume"]  # 成交量;
                        # x2 = value["turnover_amount"]  # 成交總金額;
                        x3 = value["opening_price"]  # 開盤成交價;
                        x4 = value["close_price"]  # 收盤成交價;
                        x5 = value["low_price"]  # 最低成交價;
                        x6 = value["high_price"]  # 最高成交價;
                        x7 = value["focus"]  # 當日成交價重心;
                        x8 = value["amplitude"]  # 當日成交價絕對振幅;
                        x9 = value["amplitude_rate"]  # 當日成交價相對振幅（%）;
                        x10 = value["opening_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                        x11 = value["closing_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                        x12 = value["low_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                        x13 = value["high_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                        x14 = value["turnover_volume_growth_rate"]  # 成交量的成長率;
                        x15 = value["opening_price_growth_rate"]  # 開盤價的成長率;
                        x16 = value["closing_price_growth_rate"]  # 收盤價的成長率;
                        x17 = value["closing_minus_opening_price_growth_rate"]  # 收盤價減開盤價的成長率;
                        x18 = value["high_price_proportion"]  # 收盤價和開盤價裏的最大值占最高價的比例;
                        x19 = value["low_price_proportion"]  # 最低價占收盤價和開盤價裏的最小值的比例;
                        # x20 = value["turnover_rate"]  # 成交量換手率;
                        # x21 = value["price_earnings"]  # 每股收益（公司經營利潤率 ÷ 股本）;
                        # x22 = value["book_value_per_share"]  # 每股净值（公司净資產 ÷ 股本）;
                        # x23 = value["capitalization"]  # 總市值;
                        # x24 = value["moving_average_5"]  # 收盤價 5 日滑動平均缐;
                        # x25 = value["moving_average_10"]  # 收盤價 10 日滑動平均缐;
                        # x26 = value["moving_average_20"]  # 收盤價 20 日滑動平均缐;
                        # x27 = value["moving_average_30"]  # 收盤價 30 日滑動平均缐;
                        Pdata_0 = value["Pdata_0"]
                        Plower = value["Plower"]
                        Pupper = value["Pupper"]
                        weight = value["weight"]

                        # investment_method = "Long_Position"
                        return_MarketTiming = MarketTiming(
                            training_data = {
                                str(key) : {
                                    "date_transaction": x0,
                                    "turnover_volume": x1,
                                    "opening_price": x3,
                                    "close_price": x4,
                                    "low_price": x5,
                                    "high_price": x6,
                                    "focus": x7,
                                    "amplitude": x8,
                                    "amplitude_rate": x9,
                                    "opening_price_Standardization": x10,
                                    "closing_price_Standardization": x11,
                                    "low_price_Standardization": x12,
                                    "high_price_Standardization": x13,
                                    "turnover_volume_growth_rate": x14,
                                    "opening_price_growth_rate": x15,
                                    "closing_price_growth_rate": x16,
                                    "closing_minus_opening_price_growth_rate": x17,
                                    "high_price_proportion": x18,
                                    "low_price_proportion": x19,
                                    "Pdata_0": Pdata_0,
                                    "Plower": Plower,
                                    "Pupper": Pupper,
                                    "weight": weight
                                }
                            },
                            testing_data = {
                                str(key) : {
                                    "date_transaction": x0,
                                    "turnover_volume": x1,
                                    "opening_price": x3,
                                    "close_price": x4,
                                    "low_price": x5,
                                    "high_price": x6,
                                    "focus": x7,
                                    "amplitude": x8,
                                    "amplitude_rate": x9,
                                    "opening_price_Standardization": x10,
                                    "closing_price_Standardization": x11,
                                    "low_price_Standardization": x12,
                                    "high_price_Standardization": x13,
                                    "turnover_volume_growth_rate": x14,
                                    "opening_price_growth_rate": x15,
                                    "closing_price_growth_rate": x16,
                                    "closing_minus_opening_price_growth_rate": x17,
                                    "high_price_proportion": x18,
                                    "low_price_proportion": x19,
                                    "Pdata_0": Pdata_0,
                                    "Plower": Plower,
                                    "Pupper": Pupper,
                                    "weight": weight
                                }
                            },
                            Pdata_0 = MarketTiming_Pdata_0,  # [int(3), float(+0.1), float(-0.1), float(0.0)],  # [Pdata_0[1], Pdata_0[2], Pdata_0[3], Pdata_0[4]],  # Pdata_0, # value["Pdata_0"],
                            weight = MarketTiming_weight,  # [],  # weight,  # value["weight"],
                            Plower = MarketTiming_Plower,  # [-math.inf, -math.inf, -math.inf, -math.inf],  # [Plower[1], Plower[2], Plower[3], Plower[4]],  # Plower, # value["Plower"],
                            Pupper = MarketTiming_Pupper,  # [+math.inf, +math.inf, +math.inf, +math.inf],  # [Pupper[1], Pupper[2], Pupper[3], Pupper[4]],  # Pupper, # value["Pupper"],
                            MarketTiming_fit_model = MarketTiming_fit_model,
                            Quantitative_Indicators_Function = Intuitive_Momentum_KLine,
                            investment_method = "Long_Position"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                        )
                        if isinstance(MarketTiming_Parameter, dict) and str(key) in MarketTiming_Parameter:
                            if isinstance(MarketTiming_Parameter[str(key)], dict):
                                MarketTiming_Parameter[str(key)]["Long_Position"] = return_MarketTiming[key]["Coefficient"]
                        elif isinstance(MarketTiming_Parameter, dict) and (not (str(key) in MarketTiming_Parameter)):
                            MarketTiming_Parameter[str(key)] = {}
                            MarketTiming_Parameter[str(key)]["Long_Position"] = return_MarketTiming[key]["Coefficient"]
                        # else:
                        if isinstance(weight_MarketTiming_Dict, dict) and str(key) in weight_MarketTiming_Dict:
                            if isinstance(weight_MarketTiming_Dict[str(key)], dict):
                                weight_MarketTiming_Dict[str(key)]["Long_Position"] = return_MarketTiming[key]["weight_MarketTiming"]["Long_Position"]  # 依照擇時規則交易倉位參數的存儲字典;
                        elif isinstance(weight_MarketTiming_Dict, dict) and (not (str(key) in weight_MarketTiming_Dict)):
                            weight_MarketTiming_Dict[str(key)] = {}
                            weight_MarketTiming_Dict[str(key)]["Long_Position"] = return_MarketTiming[key]["weight_MarketTiming"]["Long_Position"]  # 依照擇時規則交易倉位參數的存儲字典;
                        # else:
                        if isinstance(Plower_weight_MarketTiming_Dict, dict) and str(key) in Plower_weight_MarketTiming_Dict:
                            if isinstance(Plower_weight_MarketTiming_Dict[str(key)], dict):
                                Plower_weight_MarketTiming_Dict[str(key)]["Long_Position"] = float(0.0)
                        elif isinstance(Plower_weight_MarketTiming_Dict, dict) and (not (str(key) in Plower_weight_MarketTiming_Dict)):
                            Plower_weight_MarketTiming_Dict[str(key)] = {}
                            Plower_weight_MarketTiming_Dict[str(key)]["Long_Position"] = float(0.0)
                        # else:
                        if isinstance(Pupper_weight_MarketTiming_Dict, dict) and str(key) in Pupper_weight_MarketTiming_Dict:
                            if isinstance(Pupper_weight_MarketTiming_Dict[str(key)], dict):
                                Pupper_weight_MarketTiming_Dict[str(key)]["Long_Position"] = float(1.0)
                        elif isinstance(Pupper_weight_MarketTiming_Dict, dict) and (not (str(key) in Pupper_weight_MarketTiming_Dict)):
                            Pupper_weight_MarketTiming_Dict[str(key)] = {}
                            Pupper_weight_MarketTiming_Dict[str(key)]["Long_Position"] = float(1.0)
                        # else:
                        return_MarketTiming = None  # 釋放内存;

                        # investment_method = "Short_Selling"
                        return_MarketTiming = MarketTiming(
                            training_data = {
                                str(key) : {
                                    "date_transaction": x0,
                                    "turnover_volume": x1,
                                    "opening_price": x3,
                                    "close_price": x4,
                                    "low_price": x5,
                                    "high_price": x6,
                                    "focus": x7,
                                    "amplitude": x8,
                                    "amplitude_rate": x9,
                                    "opening_price_Standardization": x10,
                                    "closing_price_Standardization": x11,
                                    "low_price_Standardization": x12,
                                    "high_price_Standardization": x13,
                                    "turnover_volume_growth_rate": x14,
                                    "opening_price_growth_rate": x15,
                                    "closing_price_growth_rate": x16,
                                    "closing_minus_opening_price_growth_rate": x17,
                                    "high_price_proportion": x18,
                                    "low_price_proportion": x19,
                                    "Pdata_0": Pdata_0,
                                    "Plower": Plower,
                                    "Pupper": Pupper,
                                    "weight": weight
                                }
                            },
                            testing_data = {
                                str(key) : {
                                    "date_transaction": x0,
                                    "turnover_volume": x1,
                                    "opening_price": x3,
                                    "close_price": x4,
                                    "low_price": x5,
                                    "high_price": x6,
                                    "focus": x7,
                                    "amplitude": x8,
                                    "amplitude_rate": x9,
                                    "opening_price_Standardization": x10,
                                    "closing_price_Standardization": x11,
                                    "low_price_Standardization": x12,
                                    "high_price_Standardization": x13,
                                    "turnover_volume_growth_rate": x14,
                                    "opening_price_growth_rate": x15,
                                    "closing_price_growth_rate": x16,
                                    "closing_minus_opening_price_growth_rate": x17,
                                    "high_price_proportion": x18,
                                    "low_price_proportion": x19,
                                    "Pdata_0": Pdata_0,
                                    "Plower": Plower,
                                    "Pupper": Pupper,
                                    "weight": weight
                                }
                            },
                            Pdata_0 = MarketTiming_Pdata_0,  # [int(3), float(+0.1), float(-0.1), float(0.0)],  # [Pdata_0[1], Pdata_0[2], Pdata_0[3], Pdata_0[4]],  # Pdata_0, # value["Pdata_0"],
                            weight = MarketTiming_weight,  # [],  # weight,  # value["weight"],
                            Plower = MarketTiming_Plower,  # [-math.inf, -math.inf, -math.inf, -math.inf],  # [Plower[1], Plower[2], Plower[3], Plower[4]],  # Plower, # value["Plower"],
                            Pupper = MarketTiming_Pupper,  # [+math.inf, +math.inf, +math.inf, +math.inf],  # [Pupper[1], Pupper[2], Pupper[3], Pupper[4]],  # Pupper, # value["Pupper"],
                            MarketTiming_fit_model = MarketTiming_fit_model,
                            Quantitative_Indicators_Function = Intuitive_Momentum_KLine,
                            investment_method = "Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                        )
                        if isinstance(MarketTiming_Parameter, dict) and str(key) in MarketTiming_Parameter:
                            if isinstance(MarketTiming_Parameter[str(key)], dict):
                                MarketTiming_Parameter[str(key)]["Short_Selling"] = return_MarketTiming[key]["Coefficient"]
                        elif isinstance(MarketTiming_Parameter, dict) and (not (str(key) in MarketTiming_Parameter)):
                            MarketTiming_Parameter[str(key)] = {}
                            MarketTiming_Parameter[str(key)]["Short_Selling"] = return_MarketTiming[key]["Coefficient"]
                        # else:
                        if isinstance(weight_MarketTiming_Dict, dict) and str(key) in weight_MarketTiming_Dict:
                            if isinstance(weight_MarketTiming_Dict[str(key)], dict):
                                weight_MarketTiming_Dict[str(key)]["Short_Selling"] = return_MarketTiming[key]["weight_MarketTiming"]["Short_Selling"]  # 依照擇時規則交易倉位參數的存儲字典;
                        elif isinstance(weight_MarketTiming_Dict, dict) and (not (str(key) in weight_MarketTiming_Dict)):
                            weight_MarketTiming_Dict[str(key)] = {}
                            weight_MarketTiming_Dict[str(key)]["Short_Selling"] = return_MarketTiming[key]["weight_MarketTiming"]["Short_Selling"]  # 依照擇時規則交易倉位參數的存儲字典;
                        # else:
                        if isinstance(Plower_weight_MarketTiming_Dict, dict) and str(key) in Plower_weight_MarketTiming_Dict:
                            if isinstance(Plower_weight_MarketTiming_Dict[str(key)], dict):
                                Plower_weight_MarketTiming_Dict[str(key)]["Short_Selling"] = float(0.0)
                        elif isinstance(Plower_weight_MarketTiming_Dict, dict) and (not (str(key) in Plower_weight_MarketTiming_Dict)):
                            Plower_weight_MarketTiming_Dict[str(key)] = {}
                            Plower_weight_MarketTiming_Dict[str(key)]["Short_Selling"] = float(0.0)
                        # else:
                        if isinstance(Pupper_weight_MarketTiming_Dict, dict) and str(key) in Pupper_weight_MarketTiming_Dict:
                            if isinstance(Pupper_weight_MarketTiming_Dict[str(key)], dict):
                                Pupper_weight_MarketTiming_Dict[str(key)]["Short_Selling"] = float(1.0)
                        elif isinstance(Pupper_weight_MarketTiming_Dict, dict) and (not (str(key) in Pupper_weight_MarketTiming_Dict)):
                            Pupper_weight_MarketTiming_Dict[str(key)] = {}
                            Pupper_weight_MarketTiming_Dict[str(key)]["Short_Selling"] = float(1.0)
                        # else:
                        return_MarketTiming = None  # 釋放内存;
            # print(MarketTiming_Parameter)
            # print(weight_MarketTiming_Dict)
            # print(Plower_weight_MarketTiming_Dict)
            # print(Pupper_weight_MarketTiming_Dict)

            # MarketTiming_Parameter = {}  # 依照擇時規則優化之後得到的擇時規則的輸入參數存儲字典;
            # weight_MarketTiming_Dict = {}  # 依照擇時規則交易倉位參數的存儲字典;
            # Plower_weight_MarketTiming_Dict = {}
            # Pupper_weight_MarketTiming_Dict = {}
            # if isinstance(training_data, dict) and int(len(training_data)) > int(0):
            #     for key, value in training_data.items():
            #         if isinstance(MarketTiming_Parameter, dict) and (not (str(key) in MarketTiming_Parameter)):
            #             MarketTiming_Parameter[str(key)] = {}
            #         if isinstance(weight_MarketTiming_Dict, dict) and (not (str(key) in weight_MarketTiming_Dict)):
            #             weight_MarketTiming_Dict[str(key)] = {}
            #         if isinstance(Plower_weight_MarketTiming_Dict, dict) and (not (str(key) in Plower_weight_MarketTiming_Dict)):
            #             Plower_weight_MarketTiming_Dict[str(key)] = {}
            #         if isinstance(Pupper_weight_MarketTiming_Dict, dict) and (not (str(key) in Pupper_weight_MarketTiming_Dict)):
            #             Pupper_weight_MarketTiming_Dict[str(key)] = {}
            #         MarketTiming_Parameter[str(key)]["Long_Position"] = MarketTiming_Pdata_0
            #         MarketTiming_Parameter[str(key)]["Short_Selling"] = MarketTiming_Pdata_0
            #         weight_MarketTiming_Dict[str(key)]["Long_Position"] = MarketTiming_weight
            #         weight_MarketTiming_Dict[str(key)]["Short_Selling"] = MarketTiming_weight
            #         Plower_weight_MarketTiming_Dict[str(key)]["Long_Position"] = MarketTiming_Plower
            #         Plower_weight_MarketTiming_Dict[str(key)]["Short_Selling"] = MarketTiming_Plower
            #         Pupper_weight_MarketTiming_Dict[str(key)]["Long_Position"] = MarketTiming_Pupper
            #         Pupper_weight_MarketTiming_Dict[str(key)]["Short_Selling"] = MarketTiming_Pupper

            if investment_method == "Long_Position":

                return_PickStock = PickStock(
                    training_data = training_data,  # {}
                    testing_data = testing_data,  # {}
                    Pdata_0 = PickStock_Pdata_0,  # [int(3), int(5)],
                    # weight = PickStock_weight,  # [],
                    Plower = PickStock_Plower,  # [-math.inf, -math.inf],
                    Pupper = PickStock_Pupper,  # [+math.inf, +math.inf],
                    MarketTiming_Parameter = MarketTiming_Parameter,  # 按照擇時規則優化之後的參數字典;  # {}
                    PickStock_fit_model = PickStock_fit_model,
                    MarketTiming = MarketTiming,
                    MarketTiming_fit_model = MarketTiming_fit_model,
                    Quantitative_Indicators_Function = Intuitive_Momentum_KLine,
                    investment_method = "Long_Position"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                )

                if ("Coefficient" in response_data_Dict["return_PickStock"]) and isinstance(response_data_Dict["return_PickStock"]["Coefficient"], dict):
                    response_data_Dict["return_PickStock"]["Coefficient"]["Long_Position"] = return_PickStock["Coefficient"]
                elif not ("Coefficient" in response_data_Dict["return_PickStock"]):
                    response_data_Dict["return_PickStock"]["Coefficient"] = {}
                    response_data_Dict["return_PickStock"]["Coefficient"]["Long_Position"] = return_PickStock["Coefficient"]
                # else:

            elif investment_method == "Short_Selling":

                return_PickStock = PickStock(
                    training_data = training_data,  # {}
                    testing_data = testing_data,  # {}
                    Pdata_0 = PickStock_Pdata_0,  # [int(3), int(5)],
                    # weight = PickStock_weight,  # [],
                    Plower = PickStock_Plower,  # [-math.inf, -math.inf],
                    Pupper = PickStock_Pupper,  # [+math.inf, +math.inf],
                    MarketTiming_Parameter = MarketTiming_Parameter,  # 按照擇時規則優化之後的參數字典;  # {}
                    PickStock_fit_model = PickStock_fit_model,
                    MarketTiming = MarketTiming,
                    MarketTiming_fit_model = MarketTiming_fit_model,
                    Quantitative_Indicators_Function = Intuitive_Momentum_KLine,
                    investment_method = "Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                )

                if ("Coefficient" in response_data_Dict["return_PickStock"]) and isinstance(response_data_Dict["return_PickStock"]["Coefficient"], dict):
                    response_data_Dict["return_PickStock"]["Coefficient"]["Short_Selling"] = return_PickStock["Coefficient"]
                elif not ("Coefficient" in response_data_Dict["return_PickStock"]):
                    response_data_Dict["return_PickStock"]["Coefficient"] = {}
                    response_data_Dict["return_PickStock"]["Coefficient"]["Short_Selling"] = return_PickStock["Coefficient"]
                # else:

            elif investment_method == "Long_Position_and_Short_Selling":

                return_PickStock = PickStock(
                    training_data = training_data,  # {}
                    testing_data = testing_data,  # {}
                    Pdata_0 = PickStock_Pdata_0,  # [int(3), int(5)],
                    # weight = PickStock_weight,  # [],
                    Plower = PickStock_Plower,  # [-math.inf, -math.inf],
                    Pupper = PickStock_Pupper,  # [+math.inf, +math.inf],
                    MarketTiming_Parameter = MarketTiming_Parameter,  # 按照擇時規則優化之後的參數字典;  # {}
                    PickStock_fit_model = PickStock_fit_model,
                    MarketTiming = MarketTiming,
                    MarketTiming_fit_model = MarketTiming_fit_model,
                    Quantitative_Indicators_Function = Intuitive_Momentum_KLine,
                    investment_method = investment_method  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                )

                if ("Coefficient" in response_data_Dict["return_PickStock"]) and isinstance(response_data_Dict["return_PickStock"]["Coefficient"], dict):
                    response_data_Dict["return_PickStock"]["Coefficient"]["Long_Position"] = return_PickStock["Coefficient"]
                    response_data_Dict["return_PickStock"]["Coefficient"]["Short_Selling"] = return_PickStock["Coefficient"]
                elif not ("Coefficient" in response_data_Dict["return_PickStock"]):
                    response_data_Dict["return_PickStock"]["Coefficient"] = {}
                    response_data_Dict["return_PickStock"]["Coefficient"]["Long_Position"] = return_PickStock["Coefficient"]
                    response_data_Dict["return_PickStock"]["Coefficient"]["Short_Selling"] = return_PickStock["Coefficient"]
                # else:
                response_data_Dict["return_PickStock"]["PickStock_sort_ticker"] = return_PickStock["PickStock_sort"]["ticker_symbol"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
                response_data_Dict["return_PickStock"]["PickStock_sort_score"] = return_PickStock["PickStock_sort"]["score"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
                response_data_Dict["return_PickStock"]["y_profit"] = return_PickStock["testData"]["y_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_Long_Position_profit"] = return_PickStock["testData"]["y_Long_Position_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_Short_Selling_profit"] = return_PickStock["testData"]["y_Short_Selling_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_loss"] = return_PickStock["testData"]["y_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["y_Long_Position_loss"] = return_PickStock["testData"]["y_Long_Position_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["y_Short_Selling_loss"] = return_PickStock["testData"]["y_Short_Selling_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["maximum_drawdown"] = return_PickStock["testData"]["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["maximum_drawdown_Long_Position"] = return_PickStock["testData"]["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["maximum_drawdown_Short_Selling"] = return_PickStock["testData"]["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["profit_total"] = return_PickStock["testData"]["profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_total"] = return_PickStock["testData"]["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_total"] = return_PickStock["testData"]["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["profit_Positive"] = return_PickStock["testData"]["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["profit_Negative"] = return_PickStock["testData"]["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Positive"] = return_PickStock["testData"]["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Negative"] = return_PickStock["testData"]["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive"] = return_PickStock["testData"]["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative"] = return_PickStock["testData"]["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["profit_Positive_probability"] = return_PickStock["testData"]["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["profit_Negative_probability"] = return_PickStock["testData"]["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Positive_probability"] = return_PickStock["testData"]["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Negative_probability"] = return_PickStock["testData"]["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive_probability"] = return_PickStock["testData"]["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative_probability"] = return_PickStock["testData"]["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["average_price_amplitude_date_transaction"] = return_PickStock["testData"]["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_price_amplitude_date_transaction"] = return_PickStock["testData"]["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_price_amplitude_date_transaction"] = return_PickStock["testData"]["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["average_volume_turnover_date_transaction"] = return_PickStock["testData"]["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_volume_turnover_date_transaction"] = return_PickStock["testData"]["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_volume_turnover_date_transaction"] = return_PickStock["testData"]["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["average_date_transaction_between"] = return_PickStock["testData"]["average_date_transaction_between"]  # 兩次交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_date_transaction_between"] = return_PickStock["testData"]["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_date_transaction_between"] = return_PickStock["testData"]["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["number_PickStock_transaction"] = return_PickStock["testData"]["number_PickStock_transaction"]  # 交易過股票的總隻數;

            # else:

            if investment_method == "Long_Position":

                return_PickStock_fit_model = PickStock_fit_model(
                    training_data,  # {}
                    response_data_Dict["return_PickStock"]["Coefficient"]["Long_Position"][0],  # int(3),  # P1,  # 觀察收益率歷史向前推的交易日長度;
                    response_data_Dict["return_PickStock"]["Coefficient"]["Long_Position"][1],  # int(10),  # P2  # 依據市值高低分組選股的分類數目;
                    {key: {"Long_Position": MarketTiming_Pdata_0, "Short_Selling": MarketTiming_Pdata_0} for key, value in training_data.items()},  # 按照擇時規則優化之後的參數字典;  # {}
                    MarketTiming,
                    MarketTiming_fit_model,
                    Intuitive_Momentum_KLine,
                    investment_method  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                )

                response_data_Dict["return_PickStock"]["PickStock_sort_ticker"] = return_PickStock_fit_model["PickStock_sort"]["ticker_symbol"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
                response_data_Dict["return_PickStock"]["PickStock_sort_score"] = return_PickStock_fit_model["PickStock_sort"]["score"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
                response_data_Dict["return_PickStock"]["y_profit"] = return_PickStock_fit_model["y_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_Long_Position_profit"] = return_PickStock_fit_model["y_Long_Position_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_Short_Selling_profit"] = return_PickStock_fit_model["y_Short_Selling_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_loss"] = return_PickStock_fit_model["y_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["y_Long_Position_loss"] = return_PickStock_fit_model["y_Long_Position_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["y_Short_Selling_loss"] = return_PickStock_fit_model["y_Short_Selling_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["maximum_drawdown"] = return_PickStock_fit_model["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["maximum_drawdown_Long_Position"] = return_PickStock_fit_model["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["maximum_drawdown_Short_Selling"] = return_PickStock_fit_model["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["profit_total"] = return_PickStock_fit_model["profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_total"] = return_PickStock_fit_model["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_total"] = return_PickStock_fit_model["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["profit_Positive"] = return_PickStock_fit_model["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["profit_Negative"] = return_PickStock_fit_model["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Positive"] = return_PickStock_fit_model["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Negative"] = return_PickStock_fit_model["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive"] = return_PickStock_fit_model["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative"] = return_PickStock_fit_model["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["profit_Positive_probability"] = return_PickStock_fit_model["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["profit_Negative_probability"] = return_PickStock_fit_model["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Positive_probability"] = return_PickStock_fit_model["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Negative_probability"] = return_PickStock_fit_model["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive_probability"] = return_PickStock_fit_model["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative_probability"] = return_PickStock_fit_model["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["average_price_amplitude_date_transaction"] = return_PickStock_fit_model["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_price_amplitude_date_transaction"] = return_PickStock_fit_model["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_price_amplitude_date_transaction"] = return_PickStock_fit_model["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["average_volume_turnover_date_transaction"] = return_PickStock_fit_model["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_volume_turnover_date_transaction"] = return_PickStock_fit_model["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_volume_turnover_date_transaction"] = return_PickStock_fit_model["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["average_date_transaction_between"] = return_PickStock_fit_model["average_date_transaction_between"]  # 兩次交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_date_transaction_between"] = return_PickStock_fit_model["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_date_transaction_between"] = return_PickStock_fit_model["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["number_PickStock_transaction"] = return_PickStock_fit_model["number_PickStock_transaction"]  # 交易過股票的總隻數;

            elif investment_method == "Short_Selling":

                return_PickStock_fit_model = PickStock_fit_model(
                    training_data,  # {}
                    response_data_Dict["return_PickStock"]["Coefficient"]["Short_Selling"][0],  # int(3),  # P1,  # 觀察收益率歷史向前推的交易日長度;
                    response_data_Dict["return_PickStock"]["Coefficient"]["Short_Selling"][1],  # int(10),  # P2  # 依據市值高低分組選股的分類數目;
                    {key: {"Long_Position": MarketTiming_Pdata_0, "Short_Selling": MarketTiming_Pdata_0} for key, value in training_data.items()},  # 按照擇時規則優化之後的參數字典;  # {}
                    MarketTiming,
                    MarketTiming_fit_model,
                    Intuitive_Momentum_KLine,
                    investment_method  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                )

                response_data_Dict["return_PickStock"]["PickStock_sort_ticker"] = return_PickStock_fit_model["PickStock_sort"]["ticker_symbol"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
                response_data_Dict["return_PickStock"]["PickStock_sort_score"] = return_PickStock_fit_model["PickStock_sort"]["score"]  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
                response_data_Dict["return_PickStock"]["y_profit"] = return_PickStock_fit_model["y_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_Long_Position_profit"] = return_PickStock_fit_model["y_Long_Position_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_Short_Selling_profit"] = return_PickStock_fit_model["y_Short_Selling_profit"]  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                response_data_Dict["return_PickStock"]["y_loss"] = return_PickStock_fit_model["y_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["y_Long_Position_loss"] = return_PickStock_fit_model["y_Long_Position_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["y_Short_Selling_loss"] = return_PickStock_fit_model["y_Short_Selling_loss"]  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                response_data_Dict["return_PickStock"]["maximum_drawdown"] = return_PickStock_fit_model["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["maximum_drawdown_Long_Position"] = return_PickStock_fit_model["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["maximum_drawdown_Short_Selling"] = return_PickStock_fit_model["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                response_data_Dict["return_PickStock"]["profit_total"] = return_PickStock_fit_model["profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_total"] = return_PickStock_fit_model["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_total"] = return_PickStock_fit_model["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 權重，纍加總計;
                response_data_Dict["return_PickStock"]["profit_Positive"] = return_PickStock_fit_model["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["profit_Negative"] = return_PickStock_fit_model["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Positive"] = return_PickStock_fit_model["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Negative"] = return_PickStock_fit_model["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive"] = return_PickStock_fit_model["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative"] = return_PickStock_fit_model["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                response_data_Dict["return_PickStock"]["profit_Positive_probability"] = return_PickStock_fit_model["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["profit_Negative_probability"] = return_PickStock_fit_model["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Positive_probability"] = return_PickStock_fit_model["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["Long_Position_profit_Negative_probability"] = return_PickStock_fit_model["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Positive_probability"] = return_PickStock_fit_model["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                response_data_Dict["return_PickStock"]["Short_Selling_profit_Negative_probability"] = return_PickStock_fit_model["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                response_data_Dict["return_PickStock"]["average_price_amplitude_date_transaction"] = return_PickStock_fit_model["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_price_amplitude_date_transaction"] = return_PickStock_fit_model["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_price_amplitude_date_transaction"] = return_PickStock_fit_model["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                response_data_Dict["return_PickStock"]["average_volume_turnover_date_transaction"] = return_PickStock_fit_model["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_volume_turnover_date_transaction"] = return_PickStock_fit_model["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_volume_turnover_date_transaction"] = return_PickStock_fit_model["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                response_data_Dict["return_PickStock"]["average_date_transaction_between"] = return_PickStock_fit_model["average_date_transaction_between"]  # 兩次交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["Long_Position_average_date_transaction_between"] = return_PickStock_fit_model["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["Short_Selling_average_date_transaction_between"] = return_PickStock_fit_model["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                response_data_Dict["return_PickStock"]["number_PickStock_transaction"] = return_PickStock_fit_model["number_PickStock_transaction"]  # 交易過股票的總隻數;

            # else:

        # else:

        # 向字典中添加元素;
        response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)}
        # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)}
        # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)}
        # response_data_Dict["request_POST"] = request_data_Dict  # {"request_POST": request_data_Dict}
        # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)}
        response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)}
        response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)}
        # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)}
        # response_data_Dict["request_Password"] = str(request_Cookie)  # {"request_Password": str(request_Password)}
        response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)}
        # response_data_Dict["Server_Authorization"] = str(key)  # {"Server_Authorization": str(key)}
        response_data_Dict["Server_say"] = str("")  # response_data_Dict["return_PickStock"]  # {"Server_say": str(request_POST_String)}
        response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)}
        # print(response_data_Dict)

        # 將 Python 數據類型 numpy.NaN 轉換爲 "NaN" 字符串類型;
        if isinstance(response_data_Dict, dict) and response_data_Dict.__contains__("return_PickStock") and isinstance(response_data_Dict["return_PickStock"], dict):
            if response_data_Dict["return_PickStock"].__contains__("PickStock_sort_ticker") and isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"], list):
                for i in range(0, len(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"]), 1):
                    if not (isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i], dict) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i], list) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i], str)) and ((response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i] is None) or numpy.isnan(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i])):
                        response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i] = "NaN"
                    if isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i], list):
                        for j in range(0, len(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i]), 1):
                            if not (isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i][j], dict) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i][j], list) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i][j], str)) and ((response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i] is None) or numpy.isnan(response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i][j])):
                                response_data_Dict["return_PickStock"]["PickStock_sort_ticker"][i][j] = "NaN"
            if response_data_Dict["return_PickStock"].__contains__("PickStock_sort_score") and isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"], list):
                for i in range(0, len(response_data_Dict["return_PickStock"]["PickStock_sort_score"]), 1):
                    if not (isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i], dict) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i], list) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i], str)) and ((response_data_Dict["return_PickStock"]["PickStock_sort_score"][i] is None) or numpy.isnan(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i])):
                        response_data_Dict["return_PickStock"]["PickStock_sort_score"][i] = "NaN"
                    if isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i], list):
                        for j in range(0, len(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i]), 1):
                            if not (isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i][j], dict) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i][j], list) or isinstance(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i][j], str)) and ((response_data_Dict["return_PickStock"]["PickStock_sort_score"][i] is None) or numpy.isnan(response_data_Dict["return_PickStock"]["PickStock_sort_score"][i][j])):
                                response_data_Dict["return_PickStock"]["PickStock_sort_score"][i][j] = "NaN"

        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        # 使用加號（+）拼接字符串;
        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        # print(response_data_String)

        # response_data_Dict = {
        #     "Cleaned_K_Line" : "C:/StatisticalServer/Data/steppingData.pickle",
        #     "trading_direction" : "Long_Position_and_Short_Selling",  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
        #     "is_Optimize" : "True",  # "True", "False";
        #     "ticker_symbol" : ["all"],  # ["002611", "600119"]; # ["all"];
        #     "PickStock_Pdata_0" : [int(3), int(5)],
        #     "PickStock_Plower" : [-math.inf, -math.inf],
        #     "PickStock_Pupper" : [+math.inf, +math.inf],
        #     "PickStock_weight" : [],
        #     "MarketTiming_Pdata_0" : [int(3), float(+0.1), float(-0.1), float(0.0)],
        #     "MarketTiming_Plower" : [-math.inf, -math.inf, -math.inf, -math.inf],
        #     "MarketTiming_Pupper" : [+math.inf, +math.inf, +math.inf, +math.inf],
        #     "MarketTiming_weight" : [],
        #     "return_PickStock" : {
        #         "Coefficient" : [int(3), int(5)],
        #         "PickStock_sort_ticker" : [str(), str(), str(), ...],  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
        #         "PickStock_sort_score" : [float(), float(), float(), ...],  # 依照選股規則排序篩選出的股票代碼字符串存儲數組;
        #         "y_profit" : float(),  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
        #         "y_Long_Position_profit" : float(),  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
        #         "y_Short_Selling_profit" : float(),  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
        #         "y_loss" : float(),  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
        #         "y_Long_Position_loss" : float(),  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
        #         "y_Short_Selling_loss" : float(),  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
        #         "maximum_drawdown" : float(),  # 兩次對衝交易之間的最大回撤值，取極值統計;
        #         "maximum_drawdown_Long_Position" : float(),  # 兩次對衝交易之間的最大回撤值，取極值統計;
        #         "maximum_drawdown_Short_Selling" : float(),  # 兩次對衝交易之間的最大回撤值，取極值統計;
        #         "profit_total" : float(),  # 每兩次對衝交易利潤 × 權重，纍加總計;
        #         "Long_Position_profit_total" : float(),  # 每兩次對衝交易利潤 × 權重，纍加總計;
        #         "Short_Selling_profit_total" : float(),  # 每兩次對衝交易利潤 × 權重，纍加總計;
        #         "profit_Positive" : float(),  # 每兩次對衝交易收益纍加總計;
        #         "profit_Negative" : float(),  # 每兩次對衝交易損失纍加總計;
        #         "Long_Position_profit_Positive" : float(),  # 每兩次對衝交易收益纍加總計;
        #         "Long_Position_profit_Negative" : float(),  # 每兩次對衝交易損失纍加總計;
        #         "Short_Selling_profit_Positive" : float(),  # 每兩次對衝交易收益纍加總計;
        #         "Short_Selling_profit_Negative" : float(),  # 每兩次對衝交易損失纍加總計;
        #         "profit_Positive_probability" : float(),  # 每兩次對衝交易正利潤概率;
        #         "profit_Negative_probability" : float(),  # 每兩次對衝交易負利潤概率;
        #         "Long_Position_profit_Positive_probability" : float(),  # 每兩次對衝交易正利潤概率;
        #         "Long_Position_profit_Negative_probability" : float(),  # 每兩次對衝交易負利潤概率;
        #         "Short_Selling_profit_Positive_probability" : float(),  # 每兩次對衝交易正利潤概率;
        #         "Short_Selling_profit_Negative_probability" : float(),  # 每兩次對衝交易負利潤概率;
        #         "average_price_amplitude_date_transaction" : float(),  # 兩兩次對衝交易日成交價振幅平方和，均值;
        #         "Long_Position_average_price_amplitude_date_transaction" : float(),  # 兩兩次對衝交易日成交價振幅平方和，均值;
        #         "Short_Selling_average_price_amplitude_date_transaction" : float(),  # 兩兩次對衝交易日成交價振幅平方和，均值;
        #         "average_volume_turnover_date_transaction" : int(),  # 兩次對衝交易日成交量（換手率）均值;
        #         "Long_Position_average_volume_turnover_date_transaction" : int(),  # 兩次對衝交易日成交量（換手率）均值;
        #         "Short_Selling_average_volume_turnover_date_transaction" : int(),  # 兩次對衝交易日成交量（換手率）均值;
        #         "average_date_transaction_between" : int(),  # 兩次交易間隔日長，均值;
        #         "Long_Position_average_date_transaction_between" : int(),  # 兩次對衝交易間隔日長，均值;
        #         "Short_Selling_average_date_transaction_between" : int(),  # 兩次對衝交易間隔日長，均值;
        #         "number_PickStock_transaction" : int()
        #     },
        #     "request_Url" : '/PickStock?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=PickStock',
        #     "request_Authorization" : "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        #     "request_Cookie" : "session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk",
        #     "time" : "2024-02-03 17:59:58.239794",
        #     "Server_say" : "",
        #     "error" : ""
        # }
        # response_data_String = json.dumps(response_data_Dict)

        return response_data_String

    # elif request_Path == "/SizePosition":
    #     # 客戶端或瀏覽器請求 url = http://[::1]:10001/SizePosition?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=SizePosition&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&PickStock_Pdata_0=[3,5]&PickStock_Plower=["-Infinity","-Infinity"]&PickStock_Pupper=["+Infinity","+Infinity"]&PickStock_weight=[]&SizePosition_Pdata_0=[1.0,"average"]&SizePosition_Plower=[0.0,0.0]&SizePosition_Pupper=[1.0,1.0]&SizePosition_weight=[]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle
    #     # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/SizePosition?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=SizePosition&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&PickStock_Pdata_0=[3,5]&PickStock_Plower=["-Infinity","-Infinity"]&PickStock_Pupper=["+Infinity","+Infinity"]&PickStock_weight=[]&SizePosition_Pdata_0=[1.0,"average"]&SizePosition_Plower=[0.0,0.0]&SizePosition_Pupper=[1.0,1.0]&SizePosition_weight=[]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle

    # elif request_Path == "/BackTesting":
    #     # 客戶端或瀏覽器請求 url = http://[::1]:10001/BackTesting?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BackTesting&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&PickStock_Pdata_0=[3,5]&PickStock_Plower=["-Infinity","-Infinity"]&PickStock_Pupper=["+Infinity","+Infinity"]&PickStock_weight=[]&SizePosition_Pdata_0=[1.0,"average"]&SizePosition_Plower=[0.0,0.0]&SizePosition_Pupper=[1.0,1.0]&SizePosition_weight=[]&risk_threshold=0.0&training_sequence_length=60&training_ticker_symbol=["all"]&testing_sequence_length=1&testing_ticker_symbol=["all"]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle
    #     # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/BackTesting?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BackTesting&trading_direction=Long_Position_and_Short_Selling&ticker_symbol=["all"]&is_Optimize=False&MarketTiming_Pdata_0=[3,+0.1,-0.1,0.0]&MarketTiming_Plower=["-Infinity","-Infinity","-Infinity","-Infinity"]&MarketTiming_Pupper=["+Infinity","+Infinity","+Infinity","+Infinity"]&MarketTiming_weight=[]&PickStock_Pdata_0=[3,5]&PickStock_Plower=["-Infinity","-Infinity"]&PickStock_Pupper=["+Infinity","+Infinity"]&PickStock_weight=[]&SizePosition_Pdata_0=[1.0,"average"]&SizePosition_Plower=[0.0,0.0]&SizePosition_Pupper=[1.0,1.0]&SizePosition_weight=[]&risk_threshold=0.0&training_sequence_length=60&training_ticker_symbol=["all"]&testing_sequence_length=1&testing_ticker_symbol=["all"]&Cleaned_K_Line=C:/StatisticalServer/Data/steppingData.pickle&training_data_file=C:/StatisticalServer/Data/trainingData.pickle&testing_data_file=C:/StatisticalServer/Data/testingData.pickle&stepping_data_file=C:/StatisticalServer/Data/steppingData.pickle

    elif request_Path == "/Polynomial3Fit":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit

        # 將客戶端請求 url 中的查詢字符串值解析為 Python 字典類型;
        # print(request_Url_Query_String)
        if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
            if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
                # for i in range(0, len(request_Url_Query_String.split("&", -1))):
                for query_item in request_Url_Query_String.split("&", -1):
                    if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                        # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                        temp_split_Array = query_item.split("=", -1)
                        temp_split_value = ""
                        if len(temp_split_Array) > 1:
                            for i in range(1, len(temp_split_Array)):
                                if int(i) == int(1):
                                    temp_split_value = temp_split_value + str(temp_split_Array[i])
                                if int(i) > int(1):
                                    temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                        # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                        request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                    else:
                        # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                        request_Url_Query_Dict[query_item] = ""
            else:
                if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                    temp_split_Array = request_Url_Query_String.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                    request_Url_Query_Dict[request_Url_Query_String] = ""
        # print(request_Url_Query_Dict)

        # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
        # print(request_POST_String)
        if isinstance(request_POST_String, str) and request_POST_String != "":
            # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
            # # print(check_json_format(request_POST_String))
            # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
            # if check_json_format(request_POST_String):
            #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
        # print(request_data_Dict)
        # request_data_Dict = {
        #     'trainXdata': [
        #         0.00001,  # float(0.00001),
        #         1,  # float(1),
        #         2,  # float(2),
        #         3,  # float(3),
        #         4,  # float(4),
        #         5,  # float(5),
        #         6,  # float(6),
        #         7,  # float(7),
        #         8,  # float(8),
        #         9,  # float(9),
        #         10  # float(10)
        #     ],
        #     'trainYdata_1': [
        #         100,  # float(100),
        #         200,  # float(200),
        #         300,  # float(300),
        #         400,  # float(400),
        #         500,  # float(500),
        #         600,  # float(600),
        #         700,  # float(700),
        #         800,  # float(800),
        #         900,  # float(900),
        #         1000,  # float(1000),
        #         1100  # float(1100)
        #     ],
        #     'trainYdata_2': [
        #         98,  # float(98),
        #         198,  # float(198),
        #         298,  # float(298),
        #         398,  # float(398),
        #         498,  # float(498),
        #         598,  # float(598),
        #         698,  # float(698),
        #         798,  # float(798),
        #         898,  # float(898),
        #         998,  # float(998),
        #         1098  # float(1098)
        #     ],
        #     'trainYdata_3': [
        #         102,  # float(102),
        #         202,  # float(202),
        #         302,  # float(302),
        #         402,  # float(402),
        #         502,  # float(502),
        #         602,  # float(602),
        #         702,  # float(702),
        #         802,  # float(802),
        #         902,  # float(902),
        #         1002,  # float(1002),
        #         1102  # float(1102)
        #     ],
        #     'weight': [
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5  # float(0.5)
        #     ],
        #     'Pdata_0': [
        #         90,  # float(90),
        #         4,  # float(4),
        #         1,  # float(1),
        #         1210  # float(1210)
        #     ],
        #     'Plower': [
        #         '-inf',  # -math.inf,
        #         '-inf',  # -math.inf,
        #         '-inf',  # -math.inf,
        #         '-inf'  # -math.inf
        #     ],
        #     'Pupper': [
        #         '+inf',  # +math.inf,
        #         '+inf',  # +math.inf,
        #         '+inf',  # +math.inf,
        #         '+inf'  # +math.inf
        #     ],
        #     'testYdata_1': [
        #         150,  # float(150),
        #         200,  # float(200),
        #         250,  # float(250),
        #         350,  # float(350),
        #         450,  # float(450),
        #         550,  # float(550),
        #         650,  # float(650),
        #         750,  # float(750),
        #         850,  # float(850),
        #         950,  # float(950),
        #         1050  # float(1050)
        #     ],
        #     'testYdata_2': [
        #         148,  # float(148),
        #         198,  # float(198),
        #         248,  # float(248),
        #         348,  # float(348),
        #         448,  # float(448),
        #         548,  # float(548),
        #         648,  # float(648),
        #         748,  # float(748),
        #         848,  # float(848),
        #         948,  # float(948),
        #         1048  # float(1048)
        #     ],
        #     'testYdata_3': [
        #         152,  # float(152),
        #         202,  # float(202),
        #         252,  # float(252),
        #         352,  # float(352),
        #         452,  # float(452),
        #         552,  # float(552),
        #         652,  # float(652),
        #         752,  # float(752),
        #         852,  # float(852),
        #         952,  # float(952),
        #         1052  # float(1052)
        #     ],
        #     'testXdata': [
        #         0.5,  # float(0.5),
        #         1,  # float(1),
        #         1.5,  # float(1.5),
        #         2.5,  # float(2.5),
        #         3.5,  # float(3.5),
        #         4.5,  # float(4.5),
        #         5.5,  # float(5.5),
        #         6.5,  # float(6.5),
        #         7.5,  # float(7.5),
        #         8.5,  # float(8.5),
        #         9.5  # float(9.5)
        #     ],
        #     'trainYdata': [
        #         [100, 98, 102],  # [float(100), float(98), float(102)],
        #         [200, 198, 202],  # [float(200), float(198), float(202)],
        #         [300, 298, 302],  # [float(300), float(298), float(302)],
        #         [400, 398, 402],  # [float(400), float(398), float(402)],
        #         [500, 498, 502],  # [float(500), float(498), float(502)],
        #         [600, 598, 602],  # [float(600), float(598), float(602)],
        #         [700, 698, 702],  # [float(700), float(698), float(702)],
        #         [800, 798, 802],  # [float(800), float(798), float(802)],
        #         [900, 898, 902],  # [float(900), float(898), float(902)],
        #         [1000, 998, 1002],  # [float(1000), float(998), float(1002)],
        #         [1100, 1098, 1102]  # [float(1100), float(1098), float(1102)]
        #     ],
        #     'testYdata': [
        #         [150, 148, 152],  # [float(150), float(148), float(152)],
        #         [200, 198, 202],  # [float(200), float(198), float(202)],
        #         [250, 248, 252],  # [float(250), float(248), float(252)],
        #         [350, 348, 352],  # [float(350), float(348), float(352)],
        #         [450, 448, 452],  # [float(450), float(448), float(452)],
        #         [550, 548, 552],  # [float(550), float(548), float(552)],
        #         [650, 648, 652],  # [float(650), float(648), float(652)],
        #         [750, 748, 752],  # [float(750), float(748), float(752)],
        #         [850, 848, 852],  # [float(850), float(848), float(852)],
        #         [950, 948, 952],  # [float(950), float(948), float(952)],
        #         [1050, 1048, 1052]  # [float(1050), float(1048), float(1052)]
        #     ]
        # }

        training_data = {
            "Xdata": request_data_Dict["trainXdata"],
            "Ydata": request_data_Dict["trainYdata"]
        }
        training_data["Xdata"] = []
        if request_data_Dict.__contains__("trainXdata"):
            for i in range(len(request_data_Dict["trainXdata"])):
                training_data["Xdata"].append(float(request_data_Dict["trainXdata"][i]))
        training_data["Ydata"] = []
        if request_data_Dict.__contains__("trainYdata"):
            for i in range(len(request_data_Dict["trainYdata"])):
                # training_data["Ydata"].append(float(request_data_Dict["trainYdata"][i]))
                temp = []
                for j in range(len(request_data_Dict["trainYdata"][i])):
                    temp.append(float(request_data_Dict["trainYdata"][i][j]))
                training_data["Ydata"].append(temp)
        # print(training_data)
        trainXdata = training_data["Xdata"]

        # 解析配置客戶端 post 請求發送的運行參數;
        # 求 Ydata 均值向量;
        trainYdataMean  = []
        for i in range(len(training_data["Ydata"])):
            # yMean = float(numpy.mean(request_data_Dict["trainYdata"][i]))
            yMean = float(numpy.mean(training_data["Ydata"][i]))
            trainYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # print(trainYdataMean)

        # 求 Ydata 標準差向量;
        trainYdataSTD = []
        for i in range(len(training_data["Ydata"])):
            if len(training_data["Ydata"][i]) > 1:
                # ySTD = float(numpy.std(request_data_Dict["trainYdata"][i], ddof=1))
                ySTD = float(numpy.std(training_data["Ydata"][i], ddof=1))
                trainYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            elif len(training_data["Ydata"][i]) == 1:
                # ySTD = float(numpy.std(request_data_Dict["trainYdata"][i]))
                ySTD = float(numpy.std(training_data["Ydata"][i]))
                trainYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            # else:
        # print(trainYdataSTD)

        testing_data = {}
        # testing_data = {
        #     "Xdata": request_data_Dict["testXdata"],
        #     "Ydata": request_data_Dict["testYdata"]
        # }
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if request_data_Dict.__contains__("testYdata"):
            # testing_data["Ydata"] = request_data_Dict["testYdata"]
            testing_data["Ydata"] = []
            for i in range(len(request_data_Dict["testYdata"])):
                # testing_data["Ydata"].append(float(request_data_Dict["testYdata"][i]))
                temp = []
                for j in range(len(request_data_Dict["testYdata"][i])):
                    temp.append(float(request_data_Dict["testYdata"][i][j]))
                testing_data["Ydata"].append(temp)
        if request_data_Dict.__contains__("testXdata"):
            # testing_data["Xdata"] = request_data_Dict["testXdata"]
            testing_data["Xdata"] = []
            for i in range(len(request_data_Dict["testXdata"])):
                testing_data["Xdata"].append(float(request_data_Dict["testXdata"][i]))
        # print(testing_data)

        # 求擬合（Fit）迭代運算參數的起始值;
        Pdata_0_P1 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                Pdata_0_P1_I = float(trainYdataMean[i] / trainXdata[i]**3)
            else:
                Pdata_0_P1_I = float(trainYdataMean[i] - trainXdata[i]**3)
            Pdata_0_P1.append(Pdata_0_P1_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P1 = float(numpy.mean(Pdata_0_P1))
        # print(Pdata_0_P1)
        Pdata_0_P2 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                Pdata_0_P2_I = float(trainYdataMean[i] / trainXdata[i]**2)
            else:
                Pdata_0_P2_I = float(trainYdataMean[i] - trainXdata[i]**2)
            Pdata_0_P2.append(Pdata_0_P2_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P2 = float(numpy.mean(Pdata_0_P2))
        # print(Pdata_0_P2)
        Pdata_0_P3 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                Pdata_0_P3_I = float(trainYdataMean[i] / trainXdata[i]**1)
            else:
                Pdata_0_P3_I = float(trainYdataMean[i] - trainXdata[i]**1)
            Pdata_0_P3.append(Pdata_0_P3_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P3 = float(numpy.mean(Pdata_0_P3))
        # print(Pdata_0_P3)
        Pdata_0_P4 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                # 符號 / 表示常規除法，符號 % 表示除法取餘，符號 // 表示除法取整，符號 * 表示乘法，符號 ** 表示冪運算，符號 + 表示加法，符號 - 表示減法;
                Pdata_0_P4_I_1 = float(float(trainYdataMean[i] % float(Pdata_0_P3 * trainXdata[i]**1)) * float(Pdata_0_P3 * trainXdata[i]**1))
                Pdata_0_P4_I_2 = float(float(trainYdataMean[i] % float(Pdata_0_P2 * trainXdata[i]**2)) * float(Pdata_0_P2 * trainXdata[i]**2))
                Pdata_0_P4_I_3 = float(float(trainYdataMean[i] % float(Pdata_0_P1 * trainXdata[i]**3)) * float(Pdata_0_P1 * trainXdata[i]**3))
                Pdata_0_P4_I = float(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3)
            else:
                Pdata_0_P4_I = float(trainYdataMean[i] - trainXdata[i])
            Pdata_0_P4.append(Pdata_0_P4_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P4 = float(numpy.mean(Pdata_0_P4))
        # print(Pdata_0_P4)
        # 參數初始值數組;
        # Pdata_0 = []
        # Pdata_0.append(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Pdata_0.append(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])))
        # Pdata_0.append(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])))
        # Pdata_0.append(float(numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) for i in range(len(trainYdataMean))])))
        # # Pdata_0.append(float(0.0))
        # Pdata_0 = [
        #     float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])),
        #     float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])),
        #     float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])),
        #     float(numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) for i in range(len(trainYdataMean))]))
        #     # float(0.0)
        # ]
        Pdata_0 = [
            Pdata_0_P1,
            Pdata_0_P2,
            Pdata_0_P3,
            Pdata_0_P4
            # float(0.0)
        ]
        if request_data_Dict.__contains__("Pdata_0"):
            if len(request_data_Dict["Pdata_0"]) > 0:
                # Pdata_0 = request_data_Dict["Pdata_0"]
                Pdata_0 = []
                for i in range(len(request_data_Dict["Pdata_0"])):
                    Pdata_0.append(float(request_data_Dict["Pdata_0"][i]))
        # print(Pdata_0)

        # Plower = []
        # Plower.append(-math.inf)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Plower.append(-math.inf)
        # Plower.append(-math.inf)
        # Plower.append(-math.inf)
        # # Plower.append(-math.inf)
        Plower = [
            -math.inf,
            -math.inf,
            -math.inf,
            -math.inf
            # -math.inf
        ]
        if request_data_Dict.__contains__("Plower"):
            if len(request_data_Dict["Plower"]) > 0:
                # Plower = request_data_Dict["Plower"]
                Plower = []
                for i in range(len(request_data_Dict["Plower"])):
                    # if request_data_Dict["Plower"][i] == "math.inf" or request_data_Dict["Plower"][i] == "-math.inf" or request_data_Dict["Plower"][i] == "+math.inf":
                    #     Plower.append(eval(request_data_Dict["Plower"][i]))
                    # else:
                    #     Plower.append(float(request_data_Dict["Plower"][i]))
                    if isinstance(request_data_Dict["Plower"][i], str) and (request_data_Dict["Plower"][i] == "+math.inf" or request_data_Dict["Plower"][i] == "+inf" or request_data_Dict["Plower"][i] == "+Inf" or request_data_Dict["Plower"][i] == "+Infinity" or request_data_Dict["Plower"][i] == "+infinity" or request_data_Dict["Plower"][i] == "math.inf" or request_data_Dict["Plower"][i] == "inf" or request_data_Dict["Plower"][i] == "Inf" or request_data_Dict["Plower"][i] == "Infinity" or request_data_Dict["Plower"][i] == "infinity"):
                        Plower.append(+math.inf)
                    elif isinstance(request_data_Dict["Plower"][i], str) and (request_data_Dict["Plower"][i] == "-math.inf" or request_data_Dict["Plower"][i] == "-inf" or request_data_Dict["Plower"][i] == "-Inf" or request_data_Dict["Plower"][i] == "-Infinity" or request_data_Dict["Plower"][i] == "-infinity"):
                        Plower.append(-math.inf)
                    else:
                        Plower.append(float(request_data_Dict["Plower"][i]))
        # print(Plower)

        # Pupper = []
        # Pupper.append(math.inf)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Pupper.append(math.inf)
        # Pupper.append(math.inf)
        # Pupper.append(math.inf)
        # # Pupper.append(math.inf)
        Pupper = [
            math.inf,
            math.inf,
            math.inf,
            math.inf
            # math.inf
        ]
        if request_data_Dict.__contains__("Pupper"):
            if len(request_data_Dict["Pupper"]) > 0:
                # Pupper = request_data_Dict["Pupper"]
                Pupper = []
                for i in range(len(request_data_Dict["Pupper"])):
                    # if request_data_Dict["Pupper"][i] == "math.inf" or request_data_Dict["Pupper"][i] == "-math.inf" or request_data_Dict["Pupper"][i] == "+math.inf":
                    #     Pupper.append(eval(request_data_Dict["Pupper"][i]))
                    # else:
                    #     Pupper.append(float(request_data_Dict["Pupper"][i]))
                    if isinstance(request_data_Dict["Pupper"][i], str) and (request_data_Dict["Pupper"][i] == "+math.inf" or request_data_Dict["Pupper"][i] == "+inf" or request_data_Dict["Pupper"][i] == "+Inf" or request_data_Dict["Pupper"][i] == "+Infinity" or request_data_Dict["Pupper"][i] == "+infinity" or request_data_Dict["Pupper"][i] == "math.inf" or request_data_Dict["Pupper"][i] == "inf" or request_data_Dict["Pupper"][i] == "Inf" or request_data_Dict["Pupper"][i] == "Infinity" or request_data_Dict["Pupper"][i] == "infinity"):
                        Pupper.append(+math.inf)
                    elif isinstance(request_data_Dict["Pupper"][i], str) and (request_data_Dict["Pupper"][i] == "-math.inf" or request_data_Dict["Pupper"][i] == "-inf" or request_data_Dict["Pupper"][i] == "-Inf" or request_data_Dict["Pupper"][i] == "-Infinity" or request_data_Dict["Pupper"][i] == "-infinity"):
                        Pupper.append(-math.inf)
                    else:
                        Pupper.append(float(request_data_Dict["Pupper"][i]))
        # print(Pupper)

        weight = []
        # # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # # for i in range(len(trainYdataMean)):
        # #     wei = float(math.exp(-(abs(trainYdataMean[i] - trainYdataMean[target]) / (max(trainYdataMean) - min(trainYdataMean)))))
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # 使用高斯核賦權法;
        # target = 1  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i in range(len(trainYdataMean)):
        #     wei = float(math.exp(math.pow(trainYdataMean[i] / trainYdataMean[target] - 1, 2) / ((-2) * math.pow(af, 2))))
        #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # # 使用方差倒數值賦權法;
        # # for i in range(len(trainYdataSTD)):
        # #     wei = float(1 / trainYdataSTD[i])  # numpy.std(request_data_Dict["trainYdata"][i], ddof=1), numpy.var(request_data_Dict["trainYdata"][i], ddof = 1);
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        if request_data_Dict.__contains__("weight"):
            if len(request_data_Dict["weight"]) > 0:
                # weight = request_data_Dict["weight"]
                weight = []
                for i in range(len(request_data_Dict["weight"])):
                    weight.append(float(request_data_Dict["weight"][i]))
        # print(weight)


        # # 函數使用示例;
        # # 變量實測值;
        # Xdata = [
        #     float(0.0001),
        #     float(1.0),
        #     float(2.0),
        #     float(3.0),
        #     float(4.0),
        #     float(5.0),
        #     float(6.0),
        #     float(7.0),
        #     float(8.0),
        #     float(9.0),
        #     float(10.0)
        # ]  # 自變量 x 的實測數據;
        # # Xdata = numpy.array(Xdata)
        # Ydata = [
        #     [float(1000.0), float(2000.0), float(3000.0)],
        #     [float(2000.0), float(3000.0), float(4000.0)],
        #     [float(3000.0), float(4000.0), float(5000.0)],
        #     [float(4000.0), float(5000.0), float(6000.0)],
        #     [float(5000.0), float(6000.0), float(7000.0)],
        #     [float(6000.0), float(7000.0), float(8000.0)],
        #     [float(7000.0), float(8000.0), float(9000.0)],
        #     [float(8000.0), float(9000.0), float(10000.0)],
        #     [float(9000.0), float(10000.0), float(11000.0)],
        #     [float(10000.0), float(11000.0), float(12000.0)],
        #     [float(11000.0), float(12000.0), float(13000.0)]
        # ]  # 應變量 y 的實測數據;
        # # Ydata = numpy.array(Ydata)
        # training_data = {
        #     "Xdata": Xdata,
        #     "Ydata": Ydata
        # }
        # # testing_data = training_data
        # testing_data = {
        #     "Xdata": Xdata[1:len(Xdata)-1:1],  # 數組切片刪除首、尾兩個元素;
        #     "Ydata": Ydata[1:len(Ydata)-1:1]  # 數組切片刪除首、尾兩個元素;
        # }

        # # 計算應變量 y 的實測值 Ydata 的均值;
        # YdataMean = []
        # for i in range(len(Ydata)):
        #     yMean = numpy.mean(Ydata[i])
        #     YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # # 計算應變量 y 的實測值 Ydata 的均值;
        # YdataSTD = []
        # for i in range(len(Ydata)):
        #     if len(Ydata[i]) > 1:
        #         ySTD = numpy.std(Ydata[i], ddof=1)
        #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     elif len(Ydata[i]) == 1:
        #         ySTD = numpy.std(Ydata[i])
        #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # # 參數初始值;
        # Pdata_0 = [
        #     min(YdataMean) * 0.9,
        #     numpy.mean(Xdata),
        #     (1 - min(YdataMean) / max(YdataMean)) / (1 - min(Xdata) / max(Xdata)),
        #     max(YdataMean) * 1.1
        #     # float(1)
        # ]

        # # 參數上下限值;
        # Plower = [
        #     -math.inf,
        #     -math.inf,
        #     -math.inf,
        #     -math.inf
        #     # -math.inf
        # ]
        # Pupper = [
        #     math.inf,
        #     math.inf,
        #     math.inf,
        #     math.inf
        #     # math.inf
        # ]

        # # 變量實測值擬合權重;
        # weight = []
        # # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # # for i in range(len(YdataMean)):
        # #     wei = math.exp(-(abs(YdataMean[i] - YdataMean[target]) / (max(YdataMean) - min(YdataMean))))
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # 使用高斯核賦權法;
        # target = 1  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i in range(len(YdataMean)):
        #     wei = math.exp(math.pow(YdataMean[i] / YdataMean[target] - 1, 2) / ((-2) * math.pow(af, 2)))
        #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # # 使用方差倒數值賦權法;
        # # for i in range(len(YdataSTD)):
        # #     wei = 1 / YdataSTD[i]  # numpy.std(Ydata[i], ddof=1), numpy.var(Ydata[i], ddof = 1);
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # result = Polynomial3Fit(
        #     training_data,
        #     Pdata_0 = Pdata_0,
        #     weight = weight,
        #     Plower = Plower,
        #     Pupper = Pupper,
        #     testing_data = testing_data
        # )
        # print(result["Coefficient"])
        # print(result["testData"])
        # # result["fit-image"].savefig('./LC4P-fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()
        # # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./LC4P-fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;


        # 調用自定義函數 Polynomial3Fit() 擬合 Polynomial-3 曲綫;
        response_data_Dict = Polynomial3Fit(
            training_data,
            Pdata_0 = Pdata_0,
            weight = weight,
            Plower = Plower,
            Pupper = Pupper,
            testing_data = testing_data
        )
        # print(response_data_Dict)

        # 刪除 JSON 對象中包含的圖片元素;
        if response_data_Dict.__contains__("fit-image"):
            del response_data_Dict["fit-image"]

        # 向字典中添加元素;
        response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)}
        # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)}
        # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)}
        # response_data_Dict["request_POST"] = request_data_Dict  # {"request_POST": request_data_Dict}
        # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)}
        response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)}
        response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)}
        # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)}
        # response_data_Dict["request_Password"] = str(request_Cookie)  # {"request_Password": str(request_Password)}
        response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)}
        # response_data_Dict["Server_Authorization"] = str(key)  # {"Server_Authorization": str(key)}
        response_data_Dict["Server_say"] = str("")  # {"Server_say": str(request_POST_String)}
        response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)}
        # print(response_data_Dict)

        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        # 使用加號（+）拼接字符串;
        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        # print(response_data_String)

        # response_data_Dict = {
        #     "Coefficient": [
        #         100.007982422761,
        #         42148.4577551448,
        #         1.0001564001486,
        #         4221377.92224082
        #     ],
        #     "Coefficient-StandardDeviation": [
        #         0.00781790123184812,
        #         2104.76673086505,
        #         0.0000237490808220821,
        #         210359.023599377
        #     ],
        #     "Coefficient-Confidence-Lower-95%": [
        #         99.9908250045862,
        #         37529.2688077105,
        #         1.0001042796499,
        #         3759717.22485611
        #     ],
        #     "Coefficient-Confidence-Upper-95%": [
        #         100.025139840936,
        #         46767.6467025791,
        #         1.00020852064729,
        #         4683038.61962554
        #     ],
        #     "Yfit": [
        #         100.008980483748,
        #         199.99155580718,
        #         299.992070696316,
        #         399.99603100866,
        #         500.000567344017,
        #         600.00431688223,
        #         700.006476967595,
        #         800.006517272442,
        #         900.004060927778,
        #         999.998826196417,
        #         1099.99059444852
        #     ],
        #     "Yfit-Uncertainty-Lower": [
        #         99.0089499294379,
        #         198.991136273453,
        #         298.990136898385,
        #         398.991624763274,
        #         498.99282487668,
        #         598.992447662226,
        #         698.989753032473,
        #         798.984266632803,
        #         898.975662941844,
        #         998.963708008532,
        #         1098.94822805642
        #     ],
        #     "Yfit-Uncertainty-Upper": [
        #         101.00901103813,
        #         200.991951293373,
        #         300.993902825086,
        #         401.000210884195,
        #         501.007916682505,
        #         601.015588680788,
        #         701.022365894672,
        #         801.027666045591,
        #         901.031064750697,
        #         1001.0322361364,
        #         1101.0309201882
        #     ],
        #     "Residual": [
        #         0.00898048374801874,
        #         -0.00844419281929731,
        #         -0.00792930368334055,
        #         -0.00396899133920669,
        #         0.000567344017326831,
        #         0.00431688223034143,
        #         0.00647696759551763,
        #         0.00651727244257926,
        #         0.00406092777848243,
        #         -0.00117380358278751,
        #         -0.00940555147826671
        #     ],
        #     "testData": {
        #         "Ydata": [
        #             [150, 148, 152],
        #             [200, 198, 202],
        #             [250, 248, 252],
        #             [350, 348, 352],
        #             [450, 448, 452],
        #             [550, 548, 552],
        #             [650, 648, 652],
        #             [750, 748, 752],
        #             [850, 848, 852],
        #             [950, 948, 952],
        #             [1050, 1048, 1052]
        #         ],
        #         "test-Xvals": [
        #             0.500050586546119,
        #             1.00008444458554,
        #             1.50008923026377,
        #             2.50006143908055,
        #             3.50001668919562,
        #             4.49997400999207,
        #             5.49994366811569,
        #             6.49993211621922,
        #             7.49994379302719,
        #             8.49998194168741,
        #             9.50004903674755
        #         ],
        #         "test-Xvals-Uncertainty-Lower": [
        #             0.499936310423273,
        #             0.999794808816128,
        #             1.49963107921017,
        #             2.49927920023971,
        #             3.49892261926065,
        #             4.49857747071072,
        #             5.4982524599721,
        #             6.4979530588239,
        #             7.49768303155859,
        #             8.49744512880161,
        #             9.49724144950174
        #         ],
        #         "test-Xvals-Uncertainty-Upper": [
        #             0.500160692642957,
        #             1.00036584601127,
        #             1.50053513648402,
        #             2.5008235803856,
        #             3.50108303720897,
        #             4.50133543331854,
        #             5.50159259771137,
        #             6.50186196458511,
        #             7.50214864756277,
        #             8.50245638268284,
        #             9.50278802032924
        #         ],
        #         "Xdata": [
        #             0.5,
        #             1,
        #             1.5,
        #             2.5,
        #             3.5,
        #             4.5,
        #             5.5,
        #             6.5,
        #             7.5,
        #             8.5,
        #             9.5
        #         ],
        #         "test-Yfit": [
        #             149.99283432168886,
        #             199.98780598165467,
        #             249.98704946506768,
        #             349.9910371559672,
        #             449.9975369446911,
        #             550.0037557953037,
        #             650.0081868763082,
        #             750.0098833059892,
        #             850.0081939375959,
        #             950.002643218264,
        #             1049.9928684998304
        #         ],
        #         "test-Yfit-Uncertainty-Lower": [],
        #         "test-Yfit-Uncertainty-Upper": [],
        #         "test-Residual": [
        #             [0.000050586546119],
        #             [0.00008444458554],
        #             [0.00008923026377],
        #             [0.00006143908055],
        #             [0.00001668919562],
        #             [-0.00002599000793],
        #             [-0.0000563318843],
        #             [-0.00006788378077],
        #             [-0.0000562069728],
        #             [-0.00001805831259],
        #             [0.00004903674755]
        #         ]
        #     },
        #     "request_Url": '/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit',
        #     "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
        #     "request_Cookie": 'session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
        #     "time": '2024-02-03 17:59:58.239794',
        #     "Server_say": '',
        #     "error": ''
        # }
        # response_data_String = json.dumps(response_data_Dict)

        return response_data_String

    elif request_Path == "/LC5PFit":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit

        # 將客戶端請求 url 中的查詢字符串值解析為 Python 字典類型;
        # print(request_Url_Query_String)
        if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
            if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
                # for i in range(0, len(request_Url_Query_String.split("&", -1))):
                for query_item in request_Url_Query_String.split("&", -1):
                    if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                        # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                        temp_split_Array = query_item.split("=", -1)
                        temp_split_value = ""
                        if len(temp_split_Array) > 1:
                            for i in range(1, len(temp_split_Array)):
                                if int(i) == int(1):
                                    temp_split_value = temp_split_value + str(temp_split_Array[i])
                                if int(i) > int(1):
                                    temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                        # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                        request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                    else:
                        # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                        request_Url_Query_Dict[query_item] = ""
            else:
                if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                    temp_split_Array = request_Url_Query_String.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                    request_Url_Query_Dict[request_Url_Query_String] = ""
        # print(request_Url_Query_Dict)

        # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
        # print(request_POST_String)
        if isinstance(request_POST_String, str) and request_POST_String != "":
            # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
            # # print(check_json_format(request_POST_String))
            # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
            # if check_json_format(request_POST_String):
            #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
        # print(request_data_Dict)
        # request_data_Dict = {
        #     'trainXdata': [
        #         0.00001,  # float(0.00001),
        #         1,  # float(1),
        #         2,  # float(2),
        #         3,  # float(3),
        #         4,  # float(4),
        #         5,  # float(5),
        #         6,  # float(6),
        #         7,  # float(7),
        #         8,  # float(8),
        #         9,  # float(9),
        #         10  # float(10)
        #     ],
        #     'trainYdata_1': [
        #         100,  # float(100),
        #         200,  # float(200),
        #         300,  # float(300),
        #         400,  # float(400),
        #         500,  # float(500),
        #         600,  # float(600),
        #         700,  # float(700),
        #         800,  # float(800),
        #         900,  # float(900),
        #         1000,  # float(1000),
        #         1100  # float(1100)
        #     ],
        #     'trainYdata_2': [
        #         98,  # float(98),
        #         198,  # float(198),
        #         298,  # float(298),
        #         398,  # float(398),
        #         498,  # float(498),
        #         598,  # float(598),
        #         698,  # float(698),
        #         798,  # float(798),
        #         898,  # float(898),
        #         998,  # float(998),
        #         1098  # float(1098)
        #     ],
        #     'trainYdata_3': [
        #         102,  # float(102),
        #         202,  # float(202),
        #         302,  # float(302),
        #         402,  # float(402),
        #         502,  # float(502),
        #         602,  # float(602),
        #         702,  # float(702),
        #         802,  # float(802),
        #         902,  # float(902),
        #         1002,  # float(1002),
        #         1102  # float(1102)
        #     ],
        #     'weight': [
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5  # float(0.5)
        #     ],
        #     'Pdata_0': [
        #         90,  # float(90),
        #         4,  # float(4),
        #         1,  # float(1),
        #         1210  # float(1210)
        #     ],
        #     'Plower': [
        #         '-inf',  # -math.inf,
        #         '-inf',  # -math.inf,
        #         '-inf',  # -math.inf,
        #         '-inf'  # -math.inf
        #     ],
        #     'Pupper': [
        #         '+inf',  # +math.inf,
        #         '+inf',  # +math.inf,
        #         '+inf',  # +math.inf,
        #         '+inf'  # +math.inf
        #     ],
        #     'testYdata_1': [
        #         150,  # float(150),
        #         200,  # float(200),
        #         250,  # float(250),
        #         350,  # float(350),
        #         450,  # float(450),
        #         550,  # float(550),
        #         650,  # float(650),
        #         750,  # float(750),
        #         850,  # float(850),
        #         950,  # float(950),
        #         1050  # float(1050)
        #     ],
        #     'testYdata_2': [
        #         148,  # float(148),
        #         198,  # float(198),
        #         248,  # float(248),
        #         348,  # float(348),
        #         448,  # float(448),
        #         548,  # float(548),
        #         648,  # float(648),
        #         748,  # float(748),
        #         848,  # float(848),
        #         948,  # float(948),
        #         1048  # float(1048)
        #     ],
        #     'testYdata_3': [
        #         152,  # float(152),
        #         202,  # float(202),
        #         252,  # float(252),
        #         352,  # float(352),
        #         452,  # float(452),
        #         552,  # float(552),
        #         652,  # float(652),
        #         752,  # float(752),
        #         852,  # float(852),
        #         952,  # float(952),
        #         1052  # float(1052)
        #     ],
        #     'testXdata': [
        #         0.5,  # float(0.5),
        #         1,  # float(1),
        #         1.5,  # float(1.5),
        #         2.5,  # float(2.5),
        #         3.5,  # float(3.5),
        #         4.5,  # float(4.5),
        #         5.5,  # float(5.5),
        #         6.5,  # float(6.5),
        #         7.5,  # float(7.5),
        #         8.5,  # float(8.5),
        #         9.5  # float(9.5)
        #     ],
        #     'trainYdata': [
        #         [100, 98, 102],  # [float(100), float(98), float(102)],
        #         [200, 198, 202],  # [float(200), float(198), float(202)],
        #         [300, 298, 302],  # [float(300), float(298), float(302)],
        #         [400, 398, 402],  # [float(400), float(398), float(402)],
        #         [500, 498, 502],  # [float(500), float(498), float(502)],
        #         [600, 598, 602],  # [float(600), float(598), float(602)],
        #         [700, 698, 702],  # [float(700), float(698), float(702)],
        #         [800, 798, 802],  # [float(800), float(798), float(802)],
        #         [900, 898, 902],  # [float(900), float(898), float(902)],
        #         [1000, 998, 1002],  # [float(1000), float(998), float(1002)],
        #         [1100, 1098, 1102]  # [float(1100), float(1098), float(1102)]
        #     ],
        #     'testYdata': [
        #         [150, 148, 152],  # [float(150), float(148), float(152)],
        #         [200, 198, 202],  # [float(200), float(198), float(202)],
        #         [250, 248, 252],  # [float(250), float(248), float(252)],
        #         [350, 348, 352],  # [float(350), float(348), float(352)],
        #         [450, 448, 452],  # [float(450), float(448), float(452)],
        #         [550, 548, 552],  # [float(550), float(548), float(552)],
        #         [650, 648, 652],  # [float(650), float(648), float(652)],
        #         [750, 748, 752],  # [float(750), float(748), float(752)],
        #         [850, 848, 852],  # [float(850), float(848), float(852)],
        #         [950, 948, 952],  # [float(950), float(948), float(952)],
        #         [1050, 1048, 1052]  # [float(1050), float(1048), float(1052)]
        #     ]
        # }

        training_data = {
            "Xdata": request_data_Dict["trainXdata"],
            "Ydata": request_data_Dict["trainYdata"]
        }
        training_data["Xdata"] = []
        if request_data_Dict.__contains__("trainXdata"):
            for i in range(len(request_data_Dict["trainXdata"])):
                training_data["Xdata"].append(float(request_data_Dict["trainXdata"][i]))
        training_data["Ydata"] = []
        if request_data_Dict.__contains__("trainYdata"):
            for i in range(len(request_data_Dict["trainYdata"])):
                # training_data["Ydata"].append(float(request_data_Dict["trainYdata"][i]))
                temp = []
                for j in range(len(request_data_Dict["trainYdata"][i])):
                    temp.append(float(request_data_Dict["trainYdata"][i][j]))
                training_data["Ydata"].append(temp)
        # print(training_data)
        trainXdata = training_data["Xdata"]

        # 解析配置客戶端 post 請求發送的運行參數;
        # 求 Ydata 均值向量;
        trainYdataMean  = []
        for i in range(len(training_data["Ydata"])):
            # yMean = float(numpy.mean(request_data_Dict["trainYdata"][i]))
            yMean = float(numpy.mean(training_data["Ydata"][i]))
            trainYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # print(trainYdataMean)

        # 求 Ydata 標準差向量;
        trainYdataSTD = []
        for i in range(len(training_data["Ydata"])):
            if len(training_data["Ydata"][i]) > 1:
                # ySTD = float(numpy.std(request_data_Dict["trainYdata"][i], ddof=1))
                ySTD = float(numpy.std(training_data["Ydata"][i], ddof=1))
                trainYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            elif len(training_data["Ydata"][i]) == 1:
                # ySTD = float(numpy.std(request_data_Dict["trainYdata"][i]))
                ySTD = float(numpy.std(training_data["Ydata"][i]))
                trainYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            # else:
        # print(trainYdataSTD)

        testing_data = {}
        # testing_data = {
        #     "Xdata": request_data_Dict["testXdata"],
        #     "Ydata": request_data_Dict["testYdata"]
        # }
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if request_data_Dict.__contains__("testYdata"):
            # testing_data["Ydata"] = request_data_Dict["testYdata"]
            testing_data["Ydata"] = []
            for i in range(len(request_data_Dict["testYdata"])):
                # testing_data["Ydata"].append(float(request_data_Dict["testYdata"][i]))
                temp = []
                for j in range(len(request_data_Dict["testYdata"][i])):
                    temp.append(float(request_data_Dict["testYdata"][i][j]))
                testing_data["Ydata"].append(temp)
        if request_data_Dict.__contains__("testXdata"):
            # testing_data["Xdata"] = request_data_Dict["testXdata"]
            testing_data["Xdata"] = []
            for i in range(len(request_data_Dict["testXdata"])):
                testing_data["Xdata"].append(float(request_data_Dict["testXdata"][i]))
        # print(testing_data)

        # Pdata_0 = []
        # Pdata_0.append(min(trainYdataMean) * 0.9)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Pdata_0.append(float(numpy.mean(request_data_Dict["trainXdata"])))
        # Pdata_0.append(float((1 - min(trainYdataMean) / max(trainYdataMean)) / (1 - min(request_data_Dict["trainXdata"]) / max(request_data_Dict["trainXdata"]))))
        # Pdata_0.append(max(trainYdataMean) * 1.1)
        # # Pdata_0.append(float(1.0))
        Pdata_0 = [
            min(trainYdataMean) * 0.9,
            float(numpy.mean(request_data_Dict["trainXdata"])),
            float((1 - min(trainYdataMean) / max(trainYdataMean)) / (1 - min(request_data_Dict["trainXdata"]) / max(request_data_Dict["trainXdata"]))),
            max(trainYdataMean) * 1.1
            # float(1.0)
        ]
        if request_data_Dict.__contains__("Pdata_0"):
            if len(request_data_Dict["Pdata_0"]) > 0:
                # Pdata_0 = request_data_Dict["Pdata_0"]
                Pdata_0 = []
                for i in range(len(request_data_Dict["Pdata_0"])):
                    Pdata_0.append(float(request_data_Dict["Pdata_0"][i]))
        # print(Pdata_0)

        # Plower = []
        # Plower.append(-math.inf)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Plower.append(-math.inf)
        # Plower.append(-math.inf)
        # Plower.append(-math.inf)
        # # Plower.append(-math.inf)
        Plower = [
            -math.inf,
            -math.inf,
            -math.inf,
            -math.inf
            # -math.inf
        ]
        if request_data_Dict.__contains__("Plower"):
            if len(request_data_Dict["Plower"]) > 0:
                # Plower = request_data_Dict["Plower"]
                Plower = []
                for i in range(len(request_data_Dict["Plower"])):
                    # if request_data_Dict["Plower"][i] == "math.inf" or request_data_Dict["Plower"][i] == "-math.inf" or request_data_Dict["Plower"][i] == "+math.inf":
                    #     Plower.append(eval(request_data_Dict["Plower"][i]))
                    # else:
                    #     Plower.append(float(request_data_Dict["Plower"][i]))
                    if isinstance(request_data_Dict["Plower"][i], str) and (request_data_Dict["Plower"][i] == "+math.inf" or request_data_Dict["Plower"][i] == "+inf" or request_data_Dict["Plower"][i] == "+Inf" or request_data_Dict["Plower"][i] == "+Infinity" or request_data_Dict["Plower"][i] == "+infinity" or request_data_Dict["Plower"][i] == "math.inf" or request_data_Dict["Plower"][i] == "inf" or request_data_Dict["Plower"][i] == "Inf" or request_data_Dict["Plower"][i] == "Infinity" or request_data_Dict["Plower"][i] == "infinity"):
                        Plower.append(+math.inf)
                    elif isinstance(request_data_Dict["Plower"][i], str) and (request_data_Dict["Plower"][i] == "-math.inf" or request_data_Dict["Plower"][i] == "-inf" or request_data_Dict["Plower"][i] == "-Inf" or request_data_Dict["Plower"][i] == "-Infinity" or request_data_Dict["Plower"][i] == "-infinity"):
                        Plower.append(-math.inf)
                    else:
                        Plower.append(float(request_data_Dict["Plower"][i]))
        # print(Plower)

        # Pupper = []
        # Pupper.append(math.inf)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Pupper.append(math.inf)
        # Pupper.append(math.inf)
        # Pupper.append(math.inf)
        # # Pupper.append(math.inf)
        Pupper = [
            math.inf,
            math.inf,
            math.inf,
            math.inf
            # math.inf
        ]
        if request_data_Dict.__contains__("Pupper"):
            if len(request_data_Dict["Pupper"]) > 0:
                # Pupper = request_data_Dict["Pupper"]
                Pupper = []
                for i in range(len(request_data_Dict["Pupper"])):
                    # if request_data_Dict["Pupper"][i] == "math.inf" or request_data_Dict["Pupper"][i] == "-math.inf" or request_data_Dict["Pupper"][i] == "+math.inf":
                    #     Pupper.append(eval(request_data_Dict["Pupper"][i]))
                    # else:
                    #     Pupper.append(float(request_data_Dict["Pupper"][i]))
                    if isinstance(request_data_Dict["Pupper"][i], str) and (request_data_Dict["Pupper"][i] == "+math.inf" or request_data_Dict["Pupper"][i] == "+inf" or request_data_Dict["Pupper"][i] == "+Inf" or request_data_Dict["Pupper"][i] == "+Infinity" or request_data_Dict["Pupper"][i] == "+infinity" or request_data_Dict["Pupper"][i] == "math.inf" or request_data_Dict["Pupper"][i] == "inf" or request_data_Dict["Pupper"][i] == "Inf" or request_data_Dict["Pupper"][i] == "Infinity" or request_data_Dict["Pupper"][i] == "infinity"):
                        Pupper.append(+math.inf)
                    elif isinstance(request_data_Dict["Pupper"][i], str) and (request_data_Dict["Pupper"][i] == "-math.inf" or request_data_Dict["Pupper"][i] == "-inf" or request_data_Dict["Pupper"][i] == "-Inf" or request_data_Dict["Pupper"][i] == "-Infinity" or request_data_Dict["Pupper"][i] == "-infinity"):
                        Pupper.append(-math.inf)
                    else:
                        Pupper.append(float(request_data_Dict["Pupper"][i]))
        # print(Pupper)

        weight = []
        # # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # # for i in range(len(trainYdataMean)):
        # #     wei = float(math.exp(-(abs(trainYdataMean[i] - trainYdataMean[target]) / (max(trainYdataMean) - min(trainYdataMean)))))
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # 使用高斯核賦權法;
        # target = 1  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i in range(len(trainYdataMean)):
        #     wei = float(math.exp(math.pow(trainYdataMean[i] / trainYdataMean[target] - 1, 2) / ((-2) * math.pow(af, 2))))
        #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # # 使用方差倒數值賦權法;
        # # for i in range(len(trainYdataSTD)):
        # #     wei = float(1 / trainYdataSTD[i])  # numpy.std(request_data_Dict["trainYdata"][i], ddof=1), numpy.var(request_data_Dict["trainYdata"][i], ddof = 1);
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        if request_data_Dict.__contains__("weight"):
            if len(request_data_Dict["weight"]) > 0:
                # weight = request_data_Dict["weight"]
                weight = []
                for i in range(len(request_data_Dict["weight"])):
                    weight.append(float(request_data_Dict["weight"][i]))
        # print(weight)


        # # 函數使用示例;
        # # 變量實測值;
        # Xdata = [
        #     float(0.0001),
        #     float(1.0),
        #     float(2.0),
        #     float(3.0),
        #     float(4.0),
        #     float(5.0),
        #     float(6.0),
        #     float(7.0),
        #     float(8.0),
        #     float(9.0),
        #     float(10.0)
        # ]  # 自變量 x 的實測數據;
        # # Xdata = numpy.array(Xdata)
        # Ydata = [
        #     [float(1000.0), float(2000.0), float(3000.0)],
        #     [float(2000.0), float(3000.0), float(4000.0)],
        #     [float(3000.0), float(4000.0), float(5000.0)],
        #     [float(4000.0), float(5000.0), float(6000.0)],
        #     [float(5000.0), float(6000.0), float(7000.0)],
        #     [float(6000.0), float(7000.0), float(8000.0)],
        #     [float(7000.0), float(8000.0), float(9000.0)],
        #     [float(8000.0), float(9000.0), float(10000.0)],
        #     [float(9000.0), float(10000.0), float(11000.0)],
        #     [float(10000.0), float(11000.0), float(12000.0)],
        #     [float(11000.0), float(12000.0), float(13000.0)]
        # ]  # 應變量 y 的實測數據;
        # # Ydata = numpy.array(Ydata)
        # training_data = {
        #     "Xdata": Xdata,
        #     "Ydata": Ydata
        # }
        # # testing_data = training_data
        # testing_data = {
        #     "Xdata": Xdata[1:len(Xdata)-1:1],  # 數組切片刪除首、尾兩個元素;
        #     "Ydata": Ydata[1:len(Ydata)-1:1]  # 數組切片刪除首、尾兩個元素;
        # }

        # # 計算應變量 y 的實測值 Ydata 的均值;
        # YdataMean = []
        # for i in range(len(Ydata)):
        #     yMean = numpy.mean(Ydata[i])
        #     YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # # 計算應變量 y 的實測值 Ydata 的均值;
        # YdataSTD = []
        # for i in range(len(Ydata)):
        #     if len(Ydata[i]) > 1:
        #         ySTD = numpy.std(Ydata[i], ddof=1)
        #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     elif len(Ydata[i]) == 1:
        #         ySTD = numpy.std(Ydata[i])
        #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # # 參數初始值;
        # Pdata_0 = [
        #     min(YdataMean) * 0.9,
        #     numpy.mean(Xdata),
        #     (1 - min(YdataMean) / max(YdataMean)) / (1 - min(Xdata) / max(Xdata)),
        #     max(YdataMean) * 1.1
        #     # float(1)
        # ]

        # # 參數上下限值;
        # Plower = [
        #     -math.inf,
        #     -math.inf,
        #     -math.inf,
        #     -math.inf
        #     # -math.inf
        # ]
        # Pupper = [
        #     math.inf,
        #     math.inf,
        #     math.inf,
        #     math.inf
        #     # math.inf
        # ]

        # # 變量實測值擬合權重;
        # weight = []
        # # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # # for i in range(len(YdataMean)):
        # #     wei = math.exp(-(abs(YdataMean[i] - YdataMean[target]) / (max(YdataMean) - min(YdataMean))))
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # 使用高斯核賦權法;
        # target = 1  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i in range(len(YdataMean)):
        #     wei = math.exp(math.pow(YdataMean[i] / YdataMean[target] - 1, 2) / ((-2) * math.pow(af, 2)))
        #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # # 使用方差倒數值賦權法;
        # # for i in range(len(YdataSTD)):
        # #     wei = 1 / YdataSTD[i]  # numpy.std(Ydata[i], ddof=1), numpy.var(Ydata[i], ddof = 1);
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # result = LC5Pfit(
        #     training_data,
        #     Pdata_0 = Pdata_0,
        #     weight = weight,
        #     Plower = Plower,
        #     Pupper = Pupper,
        #     testing_data = testing_data
        # )
        # print(result["Coefficient"])
        # print(result["testData"])
        # # result["fit-image"].savefig('./LC4P-fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()
        # # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./LC4P-fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;


        # 調用自定義函數 LC5PFit() 擬合 5PLC 曲綫;
        response_data_Dict = LC5Pfit(
            training_data,
            Pdata_0 = Pdata_0,
            weight = weight,
            Plower = Plower,
            Pupper = Pupper,
            testing_data = testing_data
        )
        # print(response_data_Dict)

        # 刪除 JSON 對象中包含的圖片元素;
        if response_data_Dict.__contains__("fit-image"):
            del response_data_Dict["fit-image"]

        # 向字典中添加元素;
        response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)}
        # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)}
        # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)}
        # response_data_Dict["request_POST"] = request_data_Dict  # {"request_POST": request_data_Dict}
        # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)}
        response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)}
        response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)}
        # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)}
        # response_data_Dict["request_Password"] = str(request_Cookie)  # {"request_Password": str(request_Password)}
        response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)}
        # response_data_Dict["Server_Authorization"] = str(key)  # {"Server_Authorization": str(key)}
        response_data_Dict["Server_say"] = str("")  # {"Server_say": str(request_POST_String)}
        response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)}
        # print(response_data_Dict)

        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        # 使用加號（+）拼接字符串;
        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        # print(response_data_String)

        # response_data_Dict = {
        #     "Coefficient": [
        #         100.007982422761,
        #         42148.4577551448,
        #         1.0001564001486,
        #         4221377.92224082
        #     ],
        #     "Coefficient-StandardDeviation": [
        #         0.00781790123184812,
        #         2104.76673086505,
        #         0.0000237490808220821,
        #         210359.023599377
        #     ],
        #     "Coefficient-Confidence-Lower-95%": [
        #         99.9908250045862,
        #         37529.2688077105,
        #         1.0001042796499,
        #         3759717.22485611
        #     ],
        #     "Coefficient-Confidence-Upper-95%": [
        #         100.025139840936,
        #         46767.6467025791,
        #         1.00020852064729,
        #         4683038.61962554
        #     ],
        #     "Yfit": [
        #         100.008980483748,
        #         199.99155580718,
        #         299.992070696316,
        #         399.99603100866,
        #         500.000567344017,
        #         600.00431688223,
        #         700.006476967595,
        #         800.006517272442,
        #         900.004060927778,
        #         999.998826196417,
        #         1099.99059444852
        #     ],
        #     "Yfit-Uncertainty-Lower": [
        #         99.0089499294379,
        #         198.991136273453,
        #         298.990136898385,
        #         398.991624763274,
        #         498.99282487668,
        #         598.992447662226,
        #         698.989753032473,
        #         798.984266632803,
        #         898.975662941844,
        #         998.963708008532,
        #         1098.94822805642
        #     ],
        #     "Yfit-Uncertainty-Upper": [
        #         101.00901103813,
        #         200.991951293373,
        #         300.993902825086,
        #         401.000210884195,
        #         501.007916682505,
        #         601.015588680788,
        #         701.022365894672,
        #         801.027666045591,
        #         901.031064750697,
        #         1001.0322361364,
        #         1101.0309201882
        #     ],
        #     "Residual": [
        #         0.00898048374801874,
        #         -0.00844419281929731,
        #         -0.00792930368334055,
        #         -0.00396899133920669,
        #         0.000567344017326831,
        #         0.00431688223034143,
        #         0.00647696759551763,
        #         0.00651727244257926,
        #         0.00406092777848243,
        #         -0.00117380358278751,
        #         -0.00940555147826671
        #     ],
        #     "testData": {
        #         "Ydata": [
        #             [150, 148, 152],
        #             [200, 198, 202],
        #             [250, 248, 252],
        #             [350, 348, 352],
        #             [450, 448, 452],
        #             [550, 548, 552],
        #             [650, 648, 652],
        #             [750, 748, 752],
        #             [850, 848, 852],
        #             [950, 948, 952],
        #             [1050, 1048, 1052]
        #         ],
        #         "test-Xvals": [
        #             0.500050586546119,
        #             1.00008444458554,
        #             1.50008923026377,
        #             2.50006143908055,
        #             3.50001668919562,
        #             4.49997400999207,
        #             5.49994366811569,
        #             6.49993211621922,
        #             7.49994379302719,
        #             8.49998194168741,
        #             9.50004903674755
        #         ],
        #         "test-Xvals-Uncertainty-Lower": [
        #             0.499936310423273,
        #             0.999794808816128,
        #             1.49963107921017,
        #             2.49927920023971,
        #             3.49892261926065,
        #             4.49857747071072,
        #             5.4982524599721,
        #             6.4979530588239,
        #             7.49768303155859,
        #             8.49744512880161,
        #             9.49724144950174
        #         ],
        #         "test-Xvals-Uncertainty-Upper": [
        #             0.500160692642957,
        #             1.00036584601127,
        #             1.50053513648402,
        #             2.5008235803856,
        #             3.50108303720897,
        #             4.50133543331854,
        #             5.50159259771137,
        #             6.50186196458511,
        #             7.50214864756277,
        #             8.50245638268284,
        #             9.50278802032924
        #         ],
        #         "Xdata": [
        #             0.5,
        #             1,
        #             1.5,
        #             2.5,
        #             3.5,
        #             4.5,
        #             5.5,
        #             6.5,
        #             7.5,
        #             8.5,
        #             9.5
        #         ],
        #         "test-Yfit": [
        #             149.99283432168886,
        #             199.98780598165467,
        #             249.98704946506768,
        #             349.9910371559672,
        #             449.9975369446911,
        #             550.0037557953037,
        #             650.0081868763082,
        #             750.0098833059892,
        #             850.0081939375959,
        #             950.002643218264,
        #             1049.9928684998304
        #         ],
        #         "test-Yfit-Uncertainty-Lower": [],
        #         "test-Yfit-Uncertainty-Upper": [],
        #         "test-Residual": [
        #             [0.000050586546119],
        #             [0.00008444458554],
        #             [0.00008923026377],
        #             [0.00006143908055],
        #             [0.00001668919562],
        #             [-0.00002599000793],
        #             [-0.0000563318843],
        #             [-0.00006788378077],
        #             [-0.0000562069728],
        #             [-0.00001805831259],
        #             [0.00004903674755]
        #         ]
        #     },
        #     "request_Url": '/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit',
        #     "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
        #     "request_Cookie": 'Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
        #     "time": '2024-02-03 17:59:58.239794',
        #     "Server_say": '',
        #     "error": ''
        # }
        # response_data_String = json.dumps(response_data_Dict)

        return response_data_String

    elif request_Path == "/Interpolation":
        # 客戶端或瀏覽器請求 url = http://[::1]:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2

        # 將客戶端請求 url 中的查詢字符串值解析為 Python 字典類型;
        # print(request_Url_Query_String)
        if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
            if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
                # for i in range(0, len(request_Url_Query_String.split("&", -1))):
                for query_item in request_Url_Query_String.split("&", -1):
                    if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                        # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                        temp_split_Array = query_item.split("=", -1)
                        temp_split_value = ""
                        if len(temp_split_Array) > 1:
                            for i in range(1, len(temp_split_Array)):
                                if int(i) == int(1):
                                    temp_split_value = temp_split_value + str(temp_split_Array[i])
                                if int(i) > int(1):
                                    temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                        # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                        request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                    else:
                        # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                        request_Url_Query_Dict[query_item] = ""
            else:
                if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                    temp_split_Array = request_Url_Query_String.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                    request_Url_Query_Dict[request_Url_Query_String] = ""
        # print(request_Url_Query_Dict)

        # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
        # print(request_POST_String)
        if isinstance(request_POST_String, str) and request_POST_String != "":
            # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
            # # print(check_json_format(request_POST_String))
            # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
            # if check_json_format(request_POST_String):
            #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
            #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
        # print(request_data_Dict)
        # request_data_Dict = {
        #     'trainXdata': [
        #         0.00001,  # float(0.00001),
        #         1,  # float(1),
        #         2,  # float(2),
        #         3,  # float(3),
        #         4,  # float(4),
        #         5,  # float(5),
        #         6,  # float(6),
        #         7,  # float(7),
        #         8,  # float(8),
        #         9,  # float(9),
        #         10  # float(10)
        #     ],
        #     'trainYdata_1': [
        #         100,  # float(100),
        #         200,  # float(200),
        #         300,  # float(300),
        #         400,  # float(400),
        #         500,  # float(500),
        #         600,  # float(600),
        #         700,  # float(700),
        #         800,  # float(800),
        #         900,  # float(900),
        #         1000,  # float(1000),
        #         1100  # float(1100)
        #     ],
        #     'trainYdata_2': [
        #         98,  # float(98),
        #         198,  # float(198),
        #         298,  # float(298),
        #         398,  # float(398),
        #         498,  # float(498),
        #         598,  # float(598),
        #         698,  # float(698),
        #         798,  # float(798),
        #         898,  # float(898),
        #         998,  # float(998),
        #         1098  # float(1098)
        #     ],
        #     'trainYdata_3': [
        #         102,  # float(102),
        #         202,  # float(202),
        #         302,  # float(302),
        #         402,  # float(402),
        #         502,  # float(502),
        #         602,  # float(602),
        #         702,  # float(702),
        #         802,  # float(802),
        #         902,  # float(902),
        #         1002,  # float(1002),
        #         1102  # float(1102)
        #     ],
        #     'weight': [
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5,  # float(0.5),
        #         0.5  # float(0.5)
        #     ],
        #     'Pdata_0': [
        #         90,  # float(90),
        #         4,  # float(4),
        #         1,  # float(1),
        #         1210  # float(1210)
        #     ],
        #     'Plower': [
        #         '-inf',  # -math.inf,
        #         '-inf',  # -math.inf,
        #         '-inf',  # -math.inf,
        #         '-inf'  # -math.inf
        #     ],
        #     'Pupper': [
        #         '+inf',  # +math.inf,
        #         '+inf',  # +math.inf,
        #         '+inf',  # +math.inf,
        #         '+inf'  # +math.inf
        #     ],
        #     'testYdata_1': [
        #         150,  # float(150),
        #         200,  # float(200),
        #         250,  # float(250),
        #         350,  # float(350),
        #         450,  # float(450),
        #         550,  # float(550),
        #         650,  # float(650),
        #         750,  # float(750),
        #         850,  # float(850),
        #         950,  # float(950),
        #         1050  # float(1050)
        #     ],
        #     'testYdata_2': [
        #         148,  # float(148),
        #         198,  # float(198),
        #         248,  # float(248),
        #         348,  # float(348),
        #         448,  # float(448),
        #         548,  # float(548),
        #         648,  # float(648),
        #         748,  # float(748),
        #         848,  # float(848),
        #         948,  # float(948),
        #         1048  # float(1048)
        #     ],
        #     'testYdata_3': [
        #         152,  # float(152),
        #         202,  # float(202),
        #         252,  # float(252),
        #         352,  # float(352),
        #         452,  # float(452),
        #         552,  # float(552),
        #         652,  # float(652),
        #         752,  # float(752),
        #         852,  # float(852),
        #         952,  # float(952),
        #         1052  # float(1052)
        #     ],
        #     'testXdata': [
        #         0.5,  # float(0.5),
        #         1,  # float(1),
        #         1.5,  # float(1.5),
        #         2.5,  # float(2.5),
        #         3.5,  # float(3.5),
        #         4.5,  # float(4.5),
        #         5.5,  # float(5.5),
        #         6.5,  # float(6.5),
        #         7.5,  # float(7.5),
        #         8.5,  # float(8.5),
        #         9.5  # float(9.5)
        #     ],
        #     'trainYdata': [
        #         [100, 98, 102],  # [float(100), float(98), float(102)],
        #         [200, 198, 202],  # [float(200), float(198), float(202)],
        #         [300, 298, 302],  # [float(300), float(298), float(302)],
        #         [400, 398, 402],  # [float(400), float(398), float(402)],
        #         [500, 498, 502],  # [float(500), float(498), float(502)],
        #         [600, 598, 602],  # [float(600), float(598), float(602)],
        #         [700, 698, 702],  # [float(700), float(698), float(702)],
        #         [800, 798, 802],  # [float(800), float(798), float(802)],
        #         [900, 898, 902],  # [float(900), float(898), float(902)],
        #         [1000, 998, 1002],  # [float(1000), float(998), float(1002)],
        #         [1100, 1098, 1102]  # [float(1100), float(1098), float(1102)]
        #     ],
        #     'testYdata': [
        #         [150, 148, 152],  # [float(150), float(148), float(152)],
        #         [200, 198, 202],  # [float(200), float(198), float(202)],
        #         [250, 248, 252],  # [float(250), float(248), float(252)],
        #         [350, 348, 352],  # [float(350), float(348), float(352)],
        #         [450, 448, 452],  # [float(450), float(448), float(452)],
        #         [550, 548, 552],  # [float(550), float(548), float(552)],
        #         [650, 648, 652],  # [float(650), float(648), float(652)],
        #         [750, 748, 752],  # [float(750), float(748), float(752)],
        #         [850, 848, 852],  # [float(850), float(848), float(852)],
        #         [950, 948, 952],  # [float(950), float(948), float(952)],
        #         [1050, 1048, 1052]  # [float(1050), float(1048), float(1052)]
        #     ]
        # }

        training_data = {
            "Xdata": request_data_Dict["trainXdata"],
            "Ydata": request_data_Dict["trainYdata"]
        }
        training_data["Xdata"] = []
        if request_data_Dict.__contains__("trainXdata"):
            for i in range(len(request_data_Dict["trainXdata"])):
                training_data["Xdata"].append(float(request_data_Dict["trainXdata"][i]))
        training_data["Ydata"] = []
        if request_data_Dict.__contains__("trainYdata"):
            for i in range(len(request_data_Dict["trainYdata"])):
                # training_data["Ydata"].append(float(request_data_Dict["trainYdata"][i]))
                temp = []
                for j in range(len(request_data_Dict["trainYdata"][i])):
                    temp.append(float(request_data_Dict["trainYdata"][i][j]))
                training_data["Ydata"].append(temp)
        # print(training_data)
        trainXdata = training_data["Xdata"]

        # 解析配置客戶端 post 請求發送的運行參數;
        # 求 Ydata 均值向量;
        trainYdataMean  = []
        for i in range(len(training_data["Ydata"])):
            # yMean = float(numpy.mean(request_data_Dict["trainYdata"][i]))
            yMean = float(numpy.mean(training_data["Ydata"][i]))
            trainYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # print(trainYdataMean)

        # 求 Ydata 標準差向量;
        trainYdataSTD = []
        for i in range(len(training_data["Ydata"])):
            if len(training_data["Ydata"][i]) > 1:
                # ySTD = float(numpy.std(request_data_Dict["trainYdata"][i], ddof=1))
                ySTD = float(numpy.std(training_data["Ydata"][i], ddof=1))
                trainYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            elif len(training_data["Ydata"][i]) == 1:
                # ySTD = float(numpy.std(request_data_Dict["trainYdata"][i]))
                ySTD = float(numpy.std(training_data["Ydata"][i]))
                trainYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            # else:
        # print(trainYdataSTD)

        testing_data = {}
        # testing_data = {
        #     "Xdata": request_data_Dict["testXdata"],
        #     "Ydata": request_data_Dict["testYdata"]
        # }
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if request_data_Dict.__contains__("testYdata"):
            # testing_data["Ydata"] = request_data_Dict["testYdata"]
            testing_data["Ydata"] = []
            for i in range(len(request_data_Dict["testYdata"])):
                # testing_data["Ydata"].append(float(request_data_Dict["testYdata"][i]))
                temp = []
                for j in range(len(request_data_Dict["testYdata"][i])):
                    temp.append(float(request_data_Dict["testYdata"][i][j]))
                testing_data["Ydata"].append(temp)
        if request_data_Dict.__contains__("testXdata"):
            # testing_data["Xdata"] = request_data_Dict["testXdata"]
            testing_data["Xdata"] = []
            for i in range(len(request_data_Dict["testXdata"])):
                testing_data["Xdata"].append(float(request_data_Dict["testXdata"][i]))
        # print(testing_data)

        # 求擬合（Fit）迭代運算參數的起始值;
        Pdata_0_P1 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                Pdata_0_P1_I = float(trainYdataMean[i] / trainXdata[i]**3)
            else:
                Pdata_0_P1_I = float(trainYdataMean[i] - trainXdata[i]**3)
            Pdata_0_P1.append(Pdata_0_P1_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P1 = float(numpy.mean(Pdata_0_P1))
        # print(Pdata_0_P1)
        Pdata_0_P2 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                Pdata_0_P2_I = float(trainYdataMean[i] / trainXdata[i]**2)
            else:
                Pdata_0_P2_I = float(trainYdataMean[i] - trainXdata[i]**2)
            Pdata_0_P2.append(Pdata_0_P2_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P2 = float(numpy.mean(Pdata_0_P2))
        # print(Pdata_0_P2)
        Pdata_0_P3 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                Pdata_0_P3_I = float(trainYdataMean[i] / trainXdata[i]**1)
            else:
                Pdata_0_P3_I = float(trainYdataMean[i] - trainXdata[i]**1)
            Pdata_0_P3.append(Pdata_0_P3_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P3 = float(numpy.mean(Pdata_0_P3))
        # print(Pdata_0_P3)
        Pdata_0_P4 = []
        for i in range(len(trainYdataMean)):
            if float(trainXdata[i]) != float(0.0):
                # 符號 / 表示常規除法，符號 % 表示除法取餘，符號 // 表示除法取整，符號 * 表示乘法，符號 ** 表示冪運算，符號 + 表示加法，符號 - 表示減法;
                Pdata_0_P4_I_1 = float(float(trainYdataMean[i] % float(Pdata_0_P3 * trainXdata[i]**1)) * float(Pdata_0_P3 * trainXdata[i]**1))
                Pdata_0_P4_I_2 = float(float(trainYdataMean[i] % float(Pdata_0_P2 * trainXdata[i]**2)) * float(Pdata_0_P2 * trainXdata[i]**2))
                Pdata_0_P4_I_3 = float(float(trainYdataMean[i] % float(Pdata_0_P1 * trainXdata[i]**3)) * float(Pdata_0_P1 * trainXdata[i]**3))
                Pdata_0_P4_I = float(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3)
            else:
                Pdata_0_P4_I = float(trainYdataMean[i] - trainXdata[i])
            Pdata_0_P4.append(Pdata_0_P4_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        Pdata_0_P4 = float(numpy.mean(Pdata_0_P4))
        # print(Pdata_0_P4)
        # 參數初始值數組;
        # Pdata_0 = []
        # Pdata_0.append(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Pdata_0.append(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])))
        # Pdata_0.append(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])))
        # Pdata_0.append(float(numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) for i in range(len(trainYdataMean))])))
        # # Pdata_0.append(float(0.0))
        # Pdata_0 = [
        #     float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])),
        #     float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])),
        #     float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])),
        #     float(numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**1) for i in range(len(trainYdataMean))])) * trainXdata[i]**1)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**2) for i in range(len(trainYdataMean))])) * trainXdata[i]**2)) for i in range(len(trainYdataMean))]) + numpy.mean([float(float(trainYdataMean[i] % float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) * float(float(numpy.mean([(trainYdataMean[i]/trainXdata[i]**3) for i in range(len(trainYdataMean))])) * trainXdata[i]**3)) for i in range(len(trainYdataMean))]))
        #     # float(0.0)
        # ]
        Pdata_0 = [
            Pdata_0_P1,
            Pdata_0_P2,
            Pdata_0_P3,
            Pdata_0_P4
            # float(0.0)
        ]
        if request_data_Dict.__contains__("Pdata_0"):
            if len(request_data_Dict["Pdata_0"]) > 0:
                # Pdata_0 = request_data_Dict["Pdata_0"]
                Pdata_0 = []
                for i in range(len(request_data_Dict["Pdata_0"])):
                    Pdata_0.append(float(request_data_Dict["Pdata_0"][i]))
        # print(Pdata_0)

        # Plower = []
        # Plower.append(-math.inf)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Plower.append(-math.inf)
        # Plower.append(-math.inf)
        # Plower.append(-math.inf)
        # # Plower.append(-math.inf)
        Plower = [
            -math.inf,
            -math.inf,
            -math.inf,
            -math.inf
            # -math.inf
        ]
        if request_data_Dict.__contains__("Plower"):
            if len(request_data_Dict["Plower"]) > 0:
                # Plower = request_data_Dict["Plower"]
                Plower = []
                for i in range(len(request_data_Dict["Plower"])):
                    # if request_data_Dict["Plower"][i] == "math.inf" or request_data_Dict["Plower"][i] == "-math.inf" or request_data_Dict["Plower"][i] == "+math.inf":
                    #     Plower.append(eval(request_data_Dict["Plower"][i]))
                    # else:
                    #     Plower.append(float(request_data_Dict["Plower"][i]))
                    if isinstance(request_data_Dict["Plower"][i], str) and (request_data_Dict["Plower"][i] == "+math.inf" or request_data_Dict["Plower"][i] == "+inf" or request_data_Dict["Plower"][i] == "+Inf" or request_data_Dict["Plower"][i] == "+Infinity" or request_data_Dict["Plower"][i] == "+infinity" or request_data_Dict["Plower"][i] == "math.inf" or request_data_Dict["Plower"][i] == "inf" or request_data_Dict["Plower"][i] == "Inf" or request_data_Dict["Plower"][i] == "Infinity" or request_data_Dict["Plower"][i] == "infinity"):
                        Plower.append(+math.inf)
                    elif isinstance(request_data_Dict["Plower"][i], str) and (request_data_Dict["Plower"][i] == "-math.inf" or request_data_Dict["Plower"][i] == "-inf" or request_data_Dict["Plower"][i] == "-Inf" or request_data_Dict["Plower"][i] == "-Infinity" or request_data_Dict["Plower"][i] == "-infinity"):
                        Plower.append(-math.inf)
                    else:
                        Plower.append(float(request_data_Dict["Plower"][i]))
        # print(Plower)

        # Pupper = []
        # Pupper.append(math.inf)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # Pupper.append(math.inf)
        # Pupper.append(math.inf)
        # Pupper.append(math.inf)
        # # Pupper.append(math.inf)
        Pupper = [
            math.inf,
            math.inf,
            math.inf,
            math.inf
            # math.inf
        ]
        if request_data_Dict.__contains__("Pupper"):
            if len(request_data_Dict["Pupper"]) > 0:
                # Pupper = request_data_Dict["Pupper"]
                Pupper = []
                for i in range(len(request_data_Dict["Pupper"])):
                    # if request_data_Dict["Pupper"][i] == "math.inf" or request_data_Dict["Pupper"][i] == "-math.inf" or request_data_Dict["Pupper"][i] == "+math.inf":
                    #     Pupper.append(eval(request_data_Dict["Pupper"][i]))
                    # else:
                    #     Pupper.append(float(request_data_Dict["Pupper"][i]))
                    if isinstance(request_data_Dict["Pupper"][i], str) and (request_data_Dict["Pupper"][i] == "+math.inf" or request_data_Dict["Pupper"][i] == "+inf" or request_data_Dict["Pupper"][i] == "+Inf" or request_data_Dict["Pupper"][i] == "+Infinity" or request_data_Dict["Pupper"][i] == "+infinity" or request_data_Dict["Pupper"][i] == "math.inf" or request_data_Dict["Pupper"][i] == "inf" or request_data_Dict["Pupper"][i] == "Inf" or request_data_Dict["Pupper"][i] == "Infinity" or request_data_Dict["Pupper"][i] == "infinity"):
                        Pupper.append(+math.inf)
                    elif isinstance(request_data_Dict["Pupper"][i], str) and (request_data_Dict["Pupper"][i] == "-math.inf" or request_data_Dict["Pupper"][i] == "-inf" or request_data_Dict["Pupper"][i] == "-Inf" or request_data_Dict["Pupper"][i] == "-Infinity" or request_data_Dict["Pupper"][i] == "-infinity"):
                        Pupper.append(-math.inf)
                    else:
                        Pupper.append(float(request_data_Dict["Pupper"][i]))
        # print(Pupper)

        weight = []
        # # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # # for i in range(len(trainYdataMean)):
        # #     wei = float(math.exp(-(abs(trainYdataMean[i] - trainYdataMean[target]) / (max(trainYdataMean) - min(trainYdataMean)))))
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # 使用高斯核賦權法;
        # target = 1  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i in range(len(trainYdataMean)):
        #     wei = float(math.exp(math.pow(trainYdataMean[i] / trainYdataMean[target] - 1, 2) / ((-2) * math.pow(af, 2))))
        #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # # 使用方差倒數值賦權法;
        # # for i in range(len(trainYdataSTD)):
        # #     wei = float(1 / trainYdataSTD[i])  # numpy.std(request_data_Dict["trainYdata"][i], ddof=1), numpy.var(request_data_Dict["trainYdata"][i], ddof = 1);
        # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        if request_data_Dict.__contains__("weight"):
            if len(request_data_Dict["weight"]) > 0:
                # weight = request_data_Dict["weight"]
                weight = []
                for i in range(len(request_data_Dict["weight"])):
                    weight.append(float(request_data_Dict["weight"][i]))
        # print(weight)

        # 插值（Interpolation）參數預設值;
        Interpolation_Method = str("BSpline(Cubic)")  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
        λ = int(0)  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
        k = int(2)  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
        if isinstance(request_Url_Query_Dict, dict):
            # if len(request_Url_Query_Dict) > 0
            if request_Url_Query_Dict.__contains__("algorithmName"):
                # if isinstance(request_Url_Query_Dict["algorithmName"], str) and len(request_Url_Query_Dict["algorithmName"]) > 0:
                Interpolation_Method = str(request_Url_Query_Dict["algorithmName"])  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
            if request_Url_Query_Dict.__contains__("algorithmLambda"):
                # if isinstance(request_Url_Query_Dict["algorithmLambda"], int):
                λ = int(round(float(request_Url_Query_Dict["algorithmLambda"]), int(0)))  # int(0)  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
            if request_Url_Query_Dict.__contains__("algorithmKei"):
                # if isinstance(request_Url_Query_Dict["algorithmKei"], int):
                k = int(round(float(request_Url_Query_Dict["algorithmKei"]), int(0)))  # int(2)  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
        # print(Interpolation_Method)
        # print(λ)
        # print(k)
        # print(type(Interpolation_Method))
        # print(type(λ))
        # print(type(k))


        # # 函數使用示例;
        # # 變量實測值;
        # Xdata = [
        #     float(0.0001),
        #     float(1.0),
        #     float(2.0),
        #     float(3.0),
        #     float(4.0),
        #     float(5.0),
        #     float(6.0),
        #     float(7.0),
        #     float(8.0),
        #     float(9.0),
        #     float(10.0)
        # ]  # 自變量 x 的實測數據;
        # # Xdata = numpy.array(Xdata)
        # Ydata = [
        #     [float(1000.0), float(2000.0), float(3000.0)],
        #     [float(2000.0), float(3000.0), float(4000.0)],
        #     [float(3000.0), float(4000.0), float(5000.0)],
        #     [float(4000.0), float(5000.0), float(6000.0)],
        #     [float(5000.0), float(6000.0), float(7000.0)],
        #     [float(6000.0), float(7000.0), float(8000.0)],
        #     [float(7000.0), float(8000.0), float(9000.0)],
        #     [float(8000.0), float(9000.0), float(10000.0)],
        #     [float(9000.0), float(10000.0), float(11000.0)],
        #     [float(10000.0), float(11000.0), float(12000.0)],
        #     [float(11000.0), float(12000.0), float(13000.0)]
        # ]  # 應變量 y 的實測數據;
        # # Ydata = numpy.array(Ydata)

        # # 計算應變量 y 的實測值 Ydata 的均值;
        # YdataMean = []
        # for i in range(len(Ydata)):
        #     yMean = numpy.mean(Ydata[i])
        #     YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # # 計算應變量 y 的實測值 Ydata 的均值;
        # YdataSTD = []
        # for i in range(len(Ydata)):
        #     if len(Ydata[i]) > 1:
        #         ySTD = numpy.std(Ydata[i], ddof=1)
        #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     elif len(Ydata[i]) == 1:
        #         ySTD = numpy.std(Ydata[i])
        #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # training_data = {
        #     "Xdata": Xdata,
        #     "Ydata": Ydata
        # }
        # # training_data = {
        # #     "Xdata": Xdata,
        # #     "Ydata": YdataMean
        # # }

        # # testing_data = training_data
        # # testing_data = {
        # #     # "Xdata": Xdata[1:len(Xdata)-1:1],  # 數組切片刪除首、尾兩個元素;
        # #     "Ydata": Ydata[1:len(Ydata)-1:1]  # 數組切片刪除首、尾兩個元素;
        # # }
        # # testing_data = {
        # #     "Xdata": Xdata,
        # #     "Ydata": Ydata
        # # }
        # testing_data = {
        #     # "Xdata": Xdata,
        #     "Ydata": YdataMean
        # }

        # Interpolation_Method = str("BSpline(Cubic)")  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
        # # λ = int(0)  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
        # k = int(2)  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;

        # result = MathInterpolation(
        #     training_data,
        #     Interpolation_Method = Interpolation_Method,
        #     k = k,
        #     testing_data = testing_data
        # )
        # print(result["testData"])
        # # result["fit-image"].savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()
        # # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;


        # 調用自定義函數 MathInterpolation() 插值（Interpolation）曲綫;
        response_data_Dict = MathInterpolation(
            training_data,
            Interpolation_Method = Interpolation_Method,
            # λ = λ,
            k = k,
            testing_data = testing_data
        )
        # print(response_data_Dict)

        # 刪除 JSON 對象中包含的圖片元素;
        if response_data_Dict.__contains__("fit-image"):
            del response_data_Dict["fit-image"]

        # 向字典中添加元素;
        response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)}
        # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)}
        # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)}
        # response_data_Dict["request_POST"] = request_data_Dict  # {"request_POST": request_data_Dict}
        # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)}
        response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)}
        response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)}
        # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)}
        # response_data_Dict["request_Password"] = str(request_Cookie)  # {"request_Password": str(request_Password)}
        response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)}
        # response_data_Dict["Server_Authorization"] = str(key)  # {"Server_Authorization": str(key)}
        response_data_Dict["Server_say"] = str("")  # {"Server_say": str(request_POST_String)}
        response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)}
        # print(response_data_Dict)

        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        # 使用加號（+）拼接字符串;
        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        # print(response_data_String)

        # response_data_Dict = {
        #     "Coefficient": [
        #         100.007982422761,
        #         42148.4577551448,
        #         1.0001564001486,
        #         4221377.92224082
        #     ],
        #     "Coefficient-StandardDeviation": [
        #         0.00781790123184812,
        #         2104.76673086505,
        #         0.0000237490808220821,
        #         210359.023599377
        #     ],
        #     "Coefficient-Confidence-Lower-95%": [
        #         99.9908250045862,
        #         37529.2688077105,
        #         1.0001042796499,
        #         3759717.22485611
        #     ],
        #     "Coefficient-Confidence-Upper-95%": [
        #         100.025139840936,
        #         46767.6467025791,
        #         1.00020852064729,
        #         4683038.61962554
        #     ],
        #     "Yfit": [
        #         100.008980483748,
        #         199.99155580718,
        #         299.992070696316,
        #         399.99603100866,
        #         500.000567344017,
        #         600.00431688223,
        #         700.006476967595,
        #         800.006517272442,
        #         900.004060927778,
        #         999.998826196417,
        #         1099.99059444852
        #     ],
        #     "Yfit-Uncertainty-Lower": [
        #         99.0089499294379,
        #         198.991136273453,
        #         298.990136898385,
        #         398.991624763274,
        #         498.99282487668,
        #         598.992447662226,
        #         698.989753032473,
        #         798.984266632803,
        #         898.975662941844,
        #         998.963708008532,
        #         1098.94822805642
        #     ],
        #     "Yfit-Uncertainty-Upper": [
        #         101.00901103813,
        #         200.991951293373,
        #         300.993902825086,
        #         401.000210884195,
        #         501.007916682505,
        #         601.015588680788,
        #         701.022365894672,
        #         801.027666045591,
        #         901.031064750697,
        #         1001.0322361364,
        #         1101.0309201882
        #     ],
        #     "Residual": [
        #         0.00898048374801874,
        #         -0.00844419281929731,
        #         -0.00792930368334055,
        #         -0.00396899133920669,
        #         0.000567344017326831,
        #         0.00431688223034143,
        #         0.00647696759551763,
        #         0.00651727244257926,
        #         0.00406092777848243,
        #         -0.00117380358278751,
        #         -0.00940555147826671
        #     ],
        #     "testData": {
        #         "Ydata": [
        #             [150, 148, 152],
        #             [200, 198, 202],
        #             [250, 248, 252],
        #             [350, 348, 352],
        #             [450, 448, 452],
        #             [550, 548, 552],
        #             [650, 648, 652],
        #             [750, 748, 752],
        #             [850, 848, 852],
        #             [950, 948, 952],
        #             [1050, 1048, 1052]
        #         ],
        #         "test-Xvals": [
        #             0.500050586546119,
        #             1.00008444458554,
        #             1.50008923026377,
        #             2.50006143908055,
        #             3.50001668919562,
        #             4.49997400999207,
        #             5.49994366811569,
        #             6.49993211621922,
        #             7.49994379302719,
        #             8.49998194168741,
        #             9.50004903674755
        #         ],
        #         "test-Xvals-Uncertainty-Lower": [
        #             0.499936310423273,
        #             0.999794808816128,
        #             1.49963107921017,
        #             2.49927920023971,
        #             3.49892261926065,
        #             4.49857747071072,
        #             5.4982524599721,
        #             6.4979530588239,
        #             7.49768303155859,
        #             8.49744512880161,
        #             9.49724144950174
        #         ],
        #         "test-Xvals-Uncertainty-Upper": [
        #             0.500160692642957,
        #             1.00036584601127,
        #             1.50053513648402,
        #             2.5008235803856,
        #             3.50108303720897,
        #             4.50133543331854,
        #             5.50159259771137,
        #             6.50186196458511,
        #             7.50214864756277,
        #             8.50245638268284,
        #             9.50278802032924
        #         ],
        #         "Xdata": [
        #             0.5,
        #             1,
        #             1.5,
        #             2.5,
        #             3.5,
        #             4.5,
        #             5.5,
        #             6.5,
        #             7.5,
        #             8.5,
        #             9.5
        #         ],
        #         "test-Yfit": [
        #             149.99283432168886,
        #             199.98780598165467,
        #             249.98704946506768,
        #             349.9910371559672,
        #             449.9975369446911,
        #             550.0037557953037,
        #             650.0081868763082,
        #             750.0098833059892,
        #             850.0081939375959,
        #             950.002643218264,
        #             1049.9928684998304
        #         ],
        #         "test-Yfit-Uncertainty-Lower": [],
        #         "test-Yfit-Uncertainty-Upper": [],
        #         "test-Residual": [
        #             [0.000050586546119],
        #             [0.00008444458554],
        #             [0.00008923026377],
        #             [0.00006143908055],
        #             [0.00001668919562],
        #             [-0.00002599000793],
        #             [-0.0000563318843],
        #             [-0.00006788378077],
        #             [-0.0000562069728],
        #             [-0.00001805831259],
        #             [0.00004903674755]
        #         ]
        #     },
        #     "request_Url": '/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2',
        #     "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
        #     "request_Cookie": 'session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
        #     "time": '2024-02-03 17:59:58.239794',
        #     "Server_say": '',
        #     "error": ''
        # }
        # response_data_String = json.dumps(response_data_Dict)

        return response_data_String

    else:

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        web_path_index_Html = str(os.path.join(str(webPath), "administrator.html"))
        file_data = ""

        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 同步讀取硬盤文檔，返回字符串;
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(request_Path) + " } cannot modify to read and write permission."
                    # response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String


            # # 用讀取字符串的形式讀取純文本文檔;
            # fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # # fd = open(web_path, mode="rb+")
            # try:
            #     file_data = fd.read()
            #     # file_data = fd.read().decode("utf-8")
            #     # data_Bytes = file_data.encode("utf-8")
            #     # fd.write(data_Bytes)
            # except FileNotFoundError:
            #     print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
            #     # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            #     response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
            #     # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
            #     response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String
            # except PersmissionError:
            #     print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
            #     # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
            #     response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 沒有打開權限."
            #     # response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
            #     response_data_Dict["error"] = "File = { " + str(request_Path) + " } unable to read."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String
            # except Exception as error:
            #     if("[WinError 32]" in str(error)):
            #         print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
            #         print(f'Error: {str(web_path)} : {error.strerror}')
            #         # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法讀取數據."
            #         # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'
            #         # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #         # 使用加號（+）拼接字符串;
            #         # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #         # print(response_data_String)
            #         return response_data_String
            #     else:
            #         print(f'Error: {str(web_path)} : {error.strerror}')
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
            #         response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #         # 使用加號（+）拼接字符串;
            #         # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #         # print(response_data_String)
            #         return response_data_String
            # finally:
            #     fd.close()
            # # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


            # 用讀取字節流數組的形式讀取二進制文檔;
            fd = open(web_path, mode="rb+", buffering=-1)
            # fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            try:
                file_data_bytes_String = fd.read()
                # file_data_bytes_String.decode("utf-8")  # 二進制字節流轉字符串;
                file_data_integer_Tuple = struct.unpack('B' * len(file_data_bytes_String), file_data_bytes_String)
                # bytes(int(file_data_integer_Tuple[i]), "utf-8")
                # struct.pack('B', int(file_data_integer_Tuple[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
                # str(file_data_integer_Tuple[i]).encode("utf-8")  # 字符串轉二進制字節流;
                file_data_integer_Array = []
                for i in range(0, int(len(file_data_integer_Tuple))):
                    file_data_integer_Array.append(int(file_data_integer_Tuple[i]))
                file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
                # file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象;
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                response_data_Dict["error"] = "File = { " + str(request_Path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


            response_data_String = str(file_data)
            # # 替換 .html 文檔中指定的位置字符串;
            # if file_data != "":
            #     # response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            # else:
            #     # response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            #     response_data_Dict["Server_say"] = "文檔: " + str(request_Path) + " 爲空."
            #     # response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            #     response_data_Dict["error"] = "File ( " + str(request_Path) + " ) empty."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String

            return response_data_String

        elif os.path.exists(web_path) and pathlib.Path(web_path).is_dir():

            directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

            # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(request_Path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(web_path)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(web_path))
            # if len(os.listdir(web_path)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(web_path), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:

            # 同步讀取硬盤 .html 文檔，返回字符串;
            if os.path.exists(web_path_index_Html) and os.path.isfile(web_path_index_Html):

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path_index_Html, os.R_OK) and os.access(web_path_index_Html, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path_index_Html, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path_index_Html, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path_index_Html, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path_index_Html, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path_index_Html, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        print("請求的文檔 [ " + str(web_path_index_Html) + " ] 無法修改為可讀可寫權限.")

                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } cannot modify to read and write permission."

                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                fd = open(web_path_index_Html, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
                # fd = open(web_path_index_Html, mode="rb+")
                try:
                    file_data = fd.read()
                    # file_data = fd.read().decode("utf-8")
                    # data_Bytes = file_data.encode("utf-8")
                    # fd.write(data_Bytes)
                except FileNotFoundError:
                    print("請求的文檔 [ " + str(web_path_index_Html) + " ] 不存在.")
                    response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別."
                    response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unrecognized."
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                except PersmissionError:
                    print("請求的文檔 [ " + str(web_path_index_Html) + " ] 沒有打開權限.")
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 沒有打開權限."
                    response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unable to read."
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                except Exception as error:
                    if("[WinError 32]" in str(error)):
                        print("請求的文檔 [ " + str(web_path_index_Html) + " ] 無法讀取數據.")
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 無法讀取數據."
                        response_data_Dict["error"] = f'Error: {str(web_path_index_Html)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
                    else:
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 讀取數據發生錯誤."
                        response_data_Dict["error"] = f'Error: {str(web_path_index_Html)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
                finally:
                    fd.close()
                # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

            else:

                print("請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別.")

                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unrecognized."

                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String


            # 替換 .html 文檔中指定的位置字符串;
            if file_data != "":
                response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            else:
                response_data_Dict["Server_say"] = "文檔: " + str(web_path_index_Html) + " 爲空."
                response_data_Dict["error"] = "File ( " + str(web_path_index_Html) + " ) empty."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String

            return response_data_String

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
            response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        # return response_data_String


# # 使用示例，自定義類 http_Server Web 服務器使用説明;
# if __name__ == '__main__':
#     # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
#     try:
#         webPath = str(os.path.abspath("."))  # "C:/StatisticalServer/StatisticalServerPython/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
#         host = "::0"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
#         port = int(10001)  # 監聽埠號 1 ~ 65535;
#         # monitoring = (host, port)
#         Key = "username:password"
#         Session = {
#             "request_Key->username:password": Key
#         }
#         Is_multi_thread = True
#         do_Function = do_Request
#         do_Function_obj = {
#             "do_Function": do_Function
#         }
#         number_Worker_process = int(2)

#         Interface_http_Server = Interface_http_Server(
#             host = host,
#             port = port,
#             Is_multi_thread = Is_multi_thread,
#             Key = Key,
#             Session = Session,
#             # do_Function_obj = do_Function_obj,
#             do_Function = do_Function,
#             number_Worker_process = number_Worker_process
#         )
#         # Interface_http_Server = Interface_http_Server()
#         Interface_http_Server.run()

#     except Exception as error:
#         print(error)



# 示例函數，處理從服務器端返回的響應信息;
def do_Response(response_Dict):
    # response_Dict = {
    #     response_status,
    #     response_headers,
    #     response_POST_String
    # }
    # response_Dict = [
    #     response_status,
    #     response_headers,
    #     response_POST_String
    # ]

    # print(type(response_Dict))
    # print(response_Dict)

    # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
    # if len(response_Dict) > 0:
    #     # isinstance(response_Dict, dict)
    #     if response_Dict.__contains__("status"):
    #     if response_Dict.__contains__("headers"):
    #     if response_Dict.__contains__("body"):

    # 使用 Python 原生模組「json」中的函數，將 JSON 字符串轉換爲 Python 的字典對象（dict），需要事先加載：import json ;
    response_Dict_String = json.dumps(response_Dict)

    response_data_Dict = {}  # 函數返回值，聲明一個空字典;
    response_data_String = ""

    return_file_creat_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")  # str(datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 datetime 包 import datetime;
    # print(str(datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")))

    response_data_Dict["Python_say"] = str(response_Dict_String)  # {"Python_say" : str(response_Dict_String)}
    response_data_Dict["time"] = str(return_file_creat_time);  # {"Python_say" : str(response_Dict_String), "time" : str(return_file_creat_time)}
    # print(response_data_Dict)

    # 使用 Python 原生模組「json」中的函數，將 Python 的字典對象（dict）轉換爲 JSON 字符串，需要事先加載：import json ;
    # response_data_String = json.loads(response_data_Dict)
    response_data_String = "{\"Python_say\":\"" * str(response_Dict_String) * "\",\"time\":\"" * str(return_file_creat_time) * "\"}"  # 使用星號*拼接字符串;
    # print(response_data_String)

    return response_data_String


# # 使用示例，自定義函數 http_Client Web 客戶端使用説明;
# # 這裏是需要向Python服務器發送的參數數據JSON對象;
# now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
# # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
# argument = "How_are_you_!"
# if argument.find("_", 0, int(len(argument)-1)):
#     Python_say = argument.replace("_", " ")  # 將傳入參數字符串中的"_"字符替換為空" "字符
# post_Data_JSON = {
#     "Client_say": Python_say,
#     "time": str(now_date)
# }
# # post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + time + '\\"}'  # change the javascriptobject to jsonstring;
# post_Data_String = json.dumps(post_Data_JSON)

# # 讀取傳入的服務器主機 IP 參數;
# Host = "::1"  # "127.0.0.1"、"localhost";
# # 讀取傳入的服務器監聽端口號碼參數;
# Port = int(10001)  # 監聽埠號 1 ~ 65535;
# # 請求路徑;
# URL = "/"  # 根目錄 "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
# # 請求方法
# Method = "POST"  # "GET"
# # 鏈接請求等待時長，單位（秒）;
# time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;

# request_Auth = "username:password"
# # request_Auth = bytes(request_Auth, encoding="utf-8")
# # request_Authorization_Base64 = "Basic " + base64.b64encode(request_Auth, altchars=None)  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# # request_Auth = str(base64.b64decode(request_Authorization_Base64.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
# # 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# # base64.b64encode(s, altchars=None)
# # 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# # base64.b64decode(s, altchars=None, validate=False)

# request_Cookie = "Session_ID=request_Key->username:password"
# # Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
# # Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
# # Cookie_value = bytes(Cookie_value, encoding="utf-8")
# # request_Cookie_Base64 = Cookie_key + "=" + base64.b64encode(Cookie_value, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# # request_Cookie = Cookie_key + "=" + str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
# # # request_Cookie = bytes(request_Cookie, encoding="utf-8")
# # # request_Cookie_Base64 = "Session_ID=" + base64.b64encode(request_Cookie, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# # # request_Cookie = str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"

# # print(str(now_date) + " " + "http://" + Host + ":" + str(Port) + URL + " " + Method + " @" + str(request_Auth) + " " + str(request_Cookie))
# # print("Client say: " + Python_say)

# try:
#     return_Response = Interface_http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_String, time_out)
#     # print(type(return_Response))
#     # print(return_Response)
#     Response_status = return_Response[0]
#     # print(Response_status)
#     Response_headers_JSON = return_Response[1]
#     # print(Response_headers_JSON)
#     Response_body_str = return_Response[2]
#     # print(Response_body_str)
#     result = do_Response(return_Response)
#     print(result)
# except Exception as error:
#     print(error)

# # # 讀出響應頭中 Set-Cookie 參數值 # "Session_ID=request_Key->username:password";
# # Response_headers_Set_Cookie = Response_headers_JSON["Set-Cookie"]
# # # print("response Headers Set-Cookie: " + str(Response_headers_Set_Cookie))
# # if Response_headers_Set_Cookie != None and Response_headers_Set_Cookie != "" and isinstance(Response_headers_Set_Cookie, str):

# #     cookieName = ""
# #     # if Response_headers_Set_Cookie.find(",", 0, int(len(Response_headers_Set_Cookie)-1)) != -1:
# #     #     Response_headers_Set_Cookie = Response_headers_Set_Cookie.split(",", -1)[0]

# #     if Response_headers_Set_Cookie.find(";", 0, int(len(Response_headers_Set_Cookie)-1)) != -1:
# #         # 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
# #         cookieName = Response_headers_Set_Cookie.split(";", -1)[0]
# #     else:
# #         cookieName = Response_headers_Set_Cookie

# #     if cookieName.find("=", 0, int(len(cookieName)-1)) != -1:
# #         request_Cookie_name = cookieName.split("=", -1)[0]
# #         request_Cookie_value = ""
# #         for index in range(len(cookieName.split("=", -1))-int(1)):
# #             if index == 0:
# #                 request_Cookie_value = request_Cookie_value + str(cookieName.split("=", -1)[int(index) + int(1)])
# #             else:
# #                 request_Cookie_value = request_Cookie_value + "=" + str(cookieName.split("=", -1)[int(index) + int(1)])
# #         # request_Cookie = cookieName.split("=", -1)[0] + "=" + str(base64.b64decode(cookieName.split("=", -1)[1], altchars=None, validate=False), encoding="utf-8")
# #         # request_Cookie = request_Cookie_name + "=" + str(base64.b64decode(request_Cookie_value, altchars=None, validate=False), encoding="utf-8")
# #         # Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
# #         # Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
# #         # Cookie_value = bytes(Cookie_value, encoding="utf-8")
# #         # request_Cookie_Base64 = Cookie_key + "=" + str(base64.b64encode(Cookie_value, altchars=None), encoding="utf-8")  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# #     # else:
# #     #     request_Cookie = str(base64.b64decode(cookieName, altchars=None, validate=False), encoding="utf-8")
# #     # print(request_Cookie)  # "Session_ID=request_Key->username:password"
# #     print(request_Cookie_value)  # "request_Key->username:password"

# # # 讀出響應頭中 www-authenticate 參數值 # 'www-authenticate': 'Basic realm="domain name -> username:password"';
# # Response_headers_www_authenticate = Response_headers_JSON["www-authenticate"]
# # # print("response Headers www-authenticate: " + str(Response_headers_www_authenticate))
# # if Response_headers_www_authenticate != None and Response_headers_www_authenticate != "" and isinstance(Response_headers_www_authenticate, str):

# #     wwwauthenticate_Value = ""
# #     if Response_headers_www_authenticate.find("Basic realm=", 0, int(len(Response_headers_www_authenticate)-1)) != -1:
# #         # 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
# #         wwwauthenticate_Value = Response_headers_www_authenticate.split("Basic realm=", -1)[1]  # 'www-authenticate': 'Basic realm="domain name -> username:password"';
# #         # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # # request_Auth = bytes(request_Auth, encoding="utf-8")
# #         # # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# #     else:
# #         wwwauthenticate_Value = Response_headers_www_authenticate
# #         # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # # request_Auth = bytes(request_Auth, encoding="utf-8")
# #         # # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;

# #     if wwwauthenticate_Value.find(" -> ", 0, int(len(wwwauthenticate_Value)-1)) != -1:
# #         request_Auth_name = wwwauthenticate_Value.split(" -> ", -1)[0]
# #         request_Auth_value = ""
# #         for index in range(len(wwwauthenticate_Value.split(" -> ", -1))-int(1)):
# #             request_Auth_value = request_Auth_value + str(wwwauthenticate_Value.split(" -> ", -1)[int(index) + int(1)])
# #         # wwwauthenticate_Value = wwwauthenticate_Value.split(" -> ", -1)[0] + " -> " + str(base64.b64decode(wwwauthenticate_Value.split(" -> ", -1)[1], altchars=None, validate=False), encoding="utf-8")
# #         # wwwauthenticate_Value = request_Auth_name + " -> " + str(base64.b64decode(request_Auth_value, altchars=None, validate=False), encoding="utf-8")
# #         # request_Auth = request_Auth_value  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # request_Auth = str(base64.b64decode(request_Auth_value, altchars=None, validate=False), encoding="utf-8")
# #         # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # request_Auth = bytes(request_Auth, encoding="utf-8")
# #         # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# #     # else:
# #     #     request_Auth = wwwauthenticate_Value
# #         # request_Auth = str(base64.b64decode(wwwauthenticate_Value, altchars=None, validate=False), encoding="utf-8")
# #     print(wwwauthenticate_Value)  # "domain name -> username:password";
# #     # print(request_Auth)  # "username:password";

# # Response_headers_location = Response_headers_JSON["location"]
# # print("response Headers location: " + str(Response_headers_location))
# # # /^https?:\/\//.test(response.headers["location"]);  // 使用正則表達式判斷網址 URL 格式是否正確;

# if str(Response_status) == str(200) and isinstance(Response_body_str, str) and check_json_format(Response_body_str):
#     Response_body_JSON = json.loads(Response_body_str)
#     # String = json.dumps(JSON); JSON = json.loads(String); check_json_format(JSON_String);
#     if "Server_say" in Response_body_JSON:
#         print(Response_body_JSON["Server_say"])
#     else:
#         print(Response_body_JSON)
# else:
#     print(Response_body_str)
