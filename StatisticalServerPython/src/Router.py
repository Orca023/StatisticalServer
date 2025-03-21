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
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/?Key=username:password&algorithmUser=username&algorithmPass=password

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
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

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
        # 客戶端或瀏覽器請求 url = http://localhost:10001/administrator.html?Key=username:password&algorithmUser=username&algorithmPass=password

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
        # 客戶端或瀏覽器請求 url = http://localhost:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

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
        # 客戶端或瀏覽器請求 url = http://localhost:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py

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

    elif request_Path == "/Polynomial3Fit":
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
