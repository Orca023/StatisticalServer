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
# import struct  # 用於讀、寫、操作二進制本地硬盤文檔;
# import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
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
# import base64  # 加載加、解密模組;
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)
# import math  # 導入 Python 原生包「math」，用於數學計算;

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
# import numpy  # as np
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


# 匯入自定義路由模組脚本文檔「./Interface.py」;
# os.getcwd() # 獲取當前工作目錄路徑;
# os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# os.path.join(os.path.abspath("."), 'Interface.py')  # 拼接路徑字符串;
# pathlib.Path(os.path.join(os.path.abspath("."), Interface.py)  # 返回路徑對象;
# sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
import Interface as Interface  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Interface.py」;
# 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
Interface_File_Monitor = Interface.File_Monitor
Interface_http_Server = Interface.http_Server
Interface_http_Client = Interface.http_Client
check_json_format = Interface.check_json_format
win_file_is_Used = Interface.win_file_is_Used
clear_Directory = Interface.clear_Directory
formatByte = Interface.formatByte

import Router as Router  # 導入當前運行代碼所在目錄的，自定義路由（Router）脚本文檔「./Router.py」;
do_data = Router.do_data  # 使用「Router.py」模組中的成員「do_data(data_Str)」函數, 用於處理從硬盤文檔讀取到的 JSON 對象數據，然後返回處理之後的結果 JSON 對象，即路由（Router）功能;
do_Request = Router.do_Request  # 使用「Router.py」模組中的成員「do_Request(request_Dict)」函數, 用於處理用戶端（Client）發送請求的路由（Router）功能;
do_Response = Router.do_Response  # 使用「Router.py」模組中的成員「do_Response(response_Dict)」函數, 用於處理從服務端（Server）返回的響應值數據（Response）的執行函數，即路由（Router）功能;

# import Interpolation_Fitting as Interpolation_Fitting  # 加載自定義算法模組，自定義的用於曲綫擬合的模組，導入當前運行代碼所在目錄的，自定義脚本文檔「./Interpolation_Fitting.py」;
# LC5Pfit = Interpolation_Fitting.LC5Pfit
# Polynomial3Fit = Interpolation_Fitting.Polynomial3Fit
# MathInterpolation = Interpolation_Fitting.MathInterpolation



# 示例函數，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
def read_and_write_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep):

    # print("當前進程ID: ", multiprocessing.current_process().pid)
    # print("當前進程名稱: ", multiprocessing.current_process().name)
    # print("當前綫程ID: ", threading.currentThread().ident)
    # print("當前綫程名稱: ", threading.currentThread().getName())  # threading.currentThread() 表示返回當前綫程變量;
    if monitor_dir == "" or monitor_file == "" or monitor_file.find(monitor_dir, 0, int(len(monitor_file)-1)) == -1 or output_dir == "" or output_file == "" or output_file.find(output_dir, 0, int(len(output_file)-1)) == -1:
        return (monitor_dir, monitor_file, output_dir, output_file)

    # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
    # os.listdir(monitor_dir)  # 刷新目錄内容列表
    # print(os.listdir(monitor_dir))
    # 使用Python原生模組os判斷目錄或文檔是否存在以及是否為文檔;
    if not(os.path.exists(monitor_file) and os.path.isfile(monitor_file)):
        return monitor_file

    # 用於讀取或刪除文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
    if time_sleep != None and time_sleep != "" and isinstance(time_sleep, str):
        time_sleep = float(time_sleep)  # 延遲時長單位秒;

    # 使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
    if os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir():
        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        if not (os.access(monitor_dir, os.R_OK) and os.access(monitor_dir, os.W_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(monitor_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(monitor_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(monitor_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(monitor_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(monitor_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                print(f'Error: {monitor_dir} : {error.strerror}')
                print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法修改為可讀可寫權限.")
                return monitor_dir
    else:
        try:
            # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
            # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
            os.makedirs(monitor_dir, mode=0o777, exist_ok=True)
        except FileExistsError as error:
            # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
            print(f'Error: {monitor_dir} : {error.strerror}')
            print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
            return monitor_dir

    if not (os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir()):
        print(f'Error: {monitor_dir} : {error.strerror}')
        print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
        return monitor_dir

    data_Str = ""
    # print(monitor_file, "is a file 是一個文檔.")
    # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
    if not (os.access(monitor_file, os.R_OK) and os.access(monitor_file, os.W_OK)):
        try:
            # 修改文檔權限 mode:777 任何人可讀寫;
            os.chmod(monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
            # os.chmod(monitor_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
            # os.chmod(monitor_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
            # os.chmod(monitor_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
            # os.chmod(monitor_file, stat.S_IWOTH)  # 可被其它用戶寫入;
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
            print(f'Error: {monitor_file} : {error.strerror}')
            print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.")
            return monitor_file

    fd = open(monitor_file, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
    # fd = open(monitor_file, mode="rb+")
    try:
        data_Str = fd.read()
        # data_Str = fd.read().decode("utf-8")
        # data_Bytes = data_Str.encode("utf-8")
        # fd.write(data_Bytes)
    except FileNotFoundError:
        print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 不存在.")
    # except PersmissionError:
    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 沒有打開權限.")
    except Exception as error:
        if("[WinError 32]" in str(error)):
            print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法讀取數據.")
            print(f'Error: {monitor_file} : {error.strerror}')
            print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試讀取文檔 " + monitor_file)
            time.sleep(time_sleep)  # 用於讀取文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
            try:
                data_Str = fd.read()
                # data_Str = fd.read().decode("utf-8")
                # data_Bytes = data_Str.encode("utf-8")
                # fd.write(data_Bytes)
            except OSError as error:
                print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法讀取數據.")
                print(f'Error: {monitor_file} : {error.strerror}')
        else:
            print(f'Error: {monitor_file} : {error.strerror}')
    finally:
        fd.close()
    # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

    # # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔;
    # try:
    #     os.remove(monitor_file)  # os.unlink(monitor_file) 刪除文檔 monitor_file;
    #     # os.listdir(monitor_dir)  # 刷新目錄内容列表
    #     # print(os.listdir(monitor_dir))
    # except Exception as error:
    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #     print(f'Error: {monitor_file} : {error.strerror}')
    #     if("[WinError 32]" in str(error)):
    #         print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + monitor_file)
    #         time.sleep(time_sleep)  # 用於刪除文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
    #         try:
    #             # os.unlink(monitor_file) 刪除文檔 monitor_file;
    #             os.remove(monitor_file)
    #             # os.listdir(monitor_dir)  # 刷新目錄内容列表
    #             # print(os.listdir(monitor_dir))
    #         except OSError as error:
    #             print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #             print(f'Error: {monitor_file} : {error.strerror}')
    #     # else:
    #     #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #     #     print(f'Error: {monitor_file} : {error.strerror}')

    # # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
    # if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #     return monitor_file

    # 將從用於傳入的媒介文檔 monitor_file 讀取到的數據，傳入自定義函數 do_Function 處理，處理後的結果寫入傳出媒介文檔 output_file;
    if do_Function != None and hasattr(do_Function, '__call__'):
        # hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
        response_data_String = do_Function(data_Str)
    else:
        response_data_String = data_Str

    # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
    # response_data_JSON = {
    #     "Server_say": "",
    #     "require_Authorization": "",
    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    # }
    # # print(data_Str)
    # # print(typeof(data_Str))
    # if data_Str != "":
    #     # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    #     if self.check_json_format(data_Str):
    #         # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
    #         require_data_JSON = json.loads(data_Str)  # , encoding='utf-8'
    #     else:
    #         now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    #         require_data_JSON = {
    #             "Client_say": data_Str,
    #             "time": str(now_date)
    #         }
    #     # print(require_data_JSON)
    #     # print(typeof(require_data_JSON))

    #     if do_Function != None and hasattr(do_Function, '__call__'):
    #         # hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
    #         response_data_JSON["Server_say"] = do_Function(require_data_JSON)["Server_say"]
    #     else:
    #         response_data_JSON["Server_say"] = data_Str

    # else:
    #     response_data_JSON["Server_say"] = ""

    # response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;
    # # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
    # # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
    response_data_bytes = response_data_String.encode("utf-8")
    response_data_String_len = len(bytes(response_data_String, "utf-8"))

    # 使用Python原生模組os判斷指定的用於輸出傳值的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
    if os.path.exists(output_dir) and pathlib.Path(output_dir).is_dir():
        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        if not (os.access(output_dir, os.R_OK) and os.access(output_dir, os.W_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(output_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(output_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(output_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(output_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(output_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                print(f'Error: {output_dir} : {error.strerror}')
                print("用於輸出傳值的媒介文件夾 [ " + output_dir + " ] 無法修改為可讀可寫權限.")
                return output_dir
    else:
        try:
            # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
            # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
            os.makedirs(output_dir, mode=0o777, exist_ok=True)
        except FileExistsError as error:
            # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
            print(f'Error: {output_dir} : {error.strerror}')
            print("用於傳值的媒介文件夾 [ " + output_dir + " ] 無法創建.")
            return output_dir

    if not (os.path.exists(output_dir) and pathlib.Path(output_dir).is_dir()):
        print(f'Error: {output_dir} : {error.strerror}')
        print("用於輸出傳值的媒介文件夾 [ " + output_dir + " ] 無法創建.")
        return output_dir

    # 判斷用於輸出傳值的媒介文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
    if os.path.exists(output_file) and os.path.isfile(output_file):
        # print(output_file, "is a file 是一個文檔.")
        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        if not (os.access(output_file, os.R_OK) and os.access(output_file, os.W_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(output_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(output_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(output_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(output_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(output_file, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                print(f'Error: {output_file} : {error.strerror}')
                print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法修改為可讀可寫權限.")
                return output_file

        # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔;
        try:
            os.remove(output_file)  # 刪除文檔
        except OSError as error:
            print(f'Error: {output_file} : {error.strerror}')
            print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法刪除，以重新創建更新數據.")
            return output_file

        # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
        if os.path.exists(output_file) and os.path.isfile(output_file):
            print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法刪除，以重新創建更新數據.")
            return output_file

    # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔;
    fd = open(output_file, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
    # fd = open(output_file, mode="wb+")
    try:
        fd.write(response_data_String)
        # response_data_bytes = response_data_String.encode("utf-8")
        # response_data_String_len = len(bytes(response_data_String, "utf-8"))
        # fd.write(response_data_bytes)
    except FileNotFoundError:
        print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 創建失敗.")
        return output_file
    # except PersmissionError:
    #     print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 沒有打開權限.")
    #     return output_file
    finally:
        fd.close()
    # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

    # # 運算處理完之後，給調用語言的回復，os.access(to_script, os.X_OK) 判斷脚本文檔是否具有被執行權限;
    # if type(to_executable) == str and to_executable != "" and os.path.exists(to_executable) and os.path.isfile(to_executable) and os.access(to_executable, os.X_OK):
    #     if type(to_script) == str and to_script != "" and os.path.exists(to_script) and os.path.isfile(to_script):
    #         # node  環境;
    #         # test.js  待執行的JS的檔;
    #         # %s %s  傳遞給JS檔的參數;
    #         # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
    #         shell_to = os.popen('%s %s %s %s %s %s' % (to_executable, to_script, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;
    #         # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
    #         # let arg1 = process.argv[2];  // 解析出JS參數;
    #         # let arg2 = process.argv[3];
    #     else:
    #         shell_to = os.popen('%s %s %s %s %s' % (to_executable, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;

    #     # print(shell_to.readlines());
    #     result = shell_to.read()  # 取出執行結果
    #     # print(result)

    return (response_data_String, output_file, monitor_file)



# 配置預設值;
interface_Function = Interface_http_Server  # Interface_File_Monitor  # Interface_http_Server  # Interface_http_Client;
interface_Function_name_str = "http_Server"  # "file_Monitor"  # "http_Server"  # "http_Client"  # "Interface_File_Monitor"  # "Interface_http_Server"  # "Interface_http_Client"

# 配置當 interface_Function = Interface_File_Monitor 時的預設值;
# os.path.realpath(__file__)  # 獲取當前Python脚本文檔名稱;
# os.linesep  # 返回當前平臺換行符號;
# "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸入傳值的媒介目錄;
monitor_dir = os.path.join(os.path.abspath(".."), "/Intermediary/")
# monitor_dir = pathlib.Path(os.path.abspath("..") + "/temp/")  # pathlib.Path("../temp/")
monitor_file = os.path.join(monitor_dir, "intermediary_write_Node.txt")  # "../temp/intermediary_write_Node.txt" 用於接收傳值的媒介文檔;
# os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
# os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
temp_cache_IO_data_dir = os.path.join(os.path.abspath(".."), "/Intermediary/")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
number_Worker_process = int(4)  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
output_dir = os.path.join(os.path.abspath(".."), "/Intermediary/")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
output_file = os.path.join(str(output_dir), "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
to_executable = os.path.join(os.path.abspath(".."), "/NodeJS/", "node.exe")  # "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
to_script = os.path.join(os.path.abspath(".."), "/js/", "test.js")  # "../js/test.js" 用於執行功能的被調用的脚步文檔;
return_obj = {
    "output_dir": output_dir,  # os.path.join(os.path.abspath(".."), "/temp/"), "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
    "output_file": output_file,  # os.path.join(str(return_obj["output_dir"]), "intermediary_write_Python.txt"),  "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
    "to_executable": to_executable,  # os.path.join(os.path.abspath(".."), "/NodeJS/", "nodejs/node.exe"),  "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
    "to_script": to_script  # os.path.join(os.path.abspath(".."), "/js/", "test.js"),  "../js/test.js" 用於執行功能的被調用的脚步文檔;
}
return_obj["output_file"] = os.path.join(return_obj["output_dir"], "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
is_monitor = False  # 判斷是只需要執行一次還是啓動監聽服務器，可取值為：True、False;
is_Monitor_Concurrent = "Multi-Threading"  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值為：0、"0"、"Multi-Threading"、"Multi-Processes";
time_sleep = float(0.02)  # 用於監聽程序的輪詢延遲參數，單位（秒）;
# 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
# read_file_do_Function = read_and_write_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
read_file_do_Function_data = read_and_write_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
# 預設的可能被推入子進程執行功能的函數，可以在類實例化的時候輸入參數修改;
def temp_default_doFunction(arguments):
    return arguments
do_Function_data = do_data  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數， do_data 用於接收執行功能的函數;
# do_Function = temp_default_doFunction  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數， do_data 用於接收執行功能的函數;
do_Function_obj_data = {
    "do_Function": do_Function_data,  # 用於接收執行功能的函數;
    "read_file_do_Function": read_file_do_Function_data  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
}
do_Function_name_str_data = "do_data"
read_file_do_Function_name_str_data = "read_and_write_file_do_Function"

# 配置當 interface_Function = Interface_http_Server 時的預設值;
webPath = str(os.path.abspath("."))  # "C:/StatisticalServer/StatisticalServerPython/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
host = "::0"  # "localhost"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為：'localhost' 或 '127.0.0.1'則只能本機客戶端訪問
port = int(10001)  # 監聽埠號 1 ~ 65535;
# monitoring = (host, port)
Key = "username:password"
Session = {
    "request_Key->username:password": Key
}
Session_name_str = ""
Is_multi_thread = False
do_Function_Request = do_Request  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_GET_root_directory 用於接收執行功能的函數;
# do_Function = temp_default_doFunction  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_POST_root_directory 用於接收執行功能的函數
do_Function_obj_Request = {
    "do_Function": do_Function_Request
}
number_Worker_process = int(0)
do_Function_name_str_Request = "do_Request"

# 配置當 interface_Function = Interface_http_Client 時的預設值;
# 這裏是需要向Python服務器發送的參數數據JSON對象;
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
post_Data_String = '{"Client_say":"Python-3.11.2 http.client.HTTPConnection()."}'
# 讀取傳入的服務器主機 IP 參數;
Host = "::1"  # "127.0.0.1"、"localhost";
# 讀取傳入的服務器監聽端口號碼參數;
Port = int(10001)  # 監聽埠號 1 ~ 65535;
# 請求路徑;
URL = "/"  # 根目錄 "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
# 請求方法
Method = "POST"  # "GET"
# 鏈接請求等待時長，單位（秒）;
time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;
request_Auth = "username:password"
# request_Auth = bytes(request_Auth, encoding="utf-8")
# request_Authorization_Base64 = "Basic " + base64.b64encode(request_Auth, altchars=None)  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# request_Auth = str(base64.b64decode(request_Authorization_Base64.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)
request_Cookie = "Session_ID=request_Key->username:password"
# Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
# Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
# Cookie_value = bytes(Cookie_value, encoding="utf-8")
# request_Cookie_Base64 = Cookie_key + "=" + base64.b64encode(Cookie_value, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# request_Cookie = Cookie_key + "=" + str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
# # request_Cookie = bytes(request_Cookie, encoding="utf-8")
# # request_Cookie_Base64 = "Session_ID=" + base64.b64encode(request_Cookie, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# # request_Cookie = str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
# print(str(now_date) + " " + "http://" + Host + ":" + str(Port) + URL + " " + Method + " @" + str(request_Auth) + " " + str(request_Cookie))
# print("Client say: " + Python_say)
do_Function_Response = do_Response  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_Response 用於接收執行功能的函數;
do_Function_name_str_Response = "do_Response"


# os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
# os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
configFile = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "config.txt")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/config.txt" # "/home/StatisticalServer/StatisticalServerPython/config.txt"
# configFile = pathlib.Path(os.path.abspath("..") + "config.txt")  # pathlib.Path("../config.txt")
# print(configFile)
# 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的配置文檔（config.txt）參數的保存路徑全名："C:/StatisticalServer/StatisticalServerPython/config.txt" # "/home/StatisticalServer/StatisticalServerPython/config.txt" ;
# print(type(sys.argv))
# print(sys.argv)
if len(sys.argv) > 1:
    for i in range(len(sys.argv)):
        # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
        if i > 0:
            # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
            if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:
                if sys.argv[i].split("=", -1)[0] == "configFile":
                    configFile = sys.argv[i].split("=", -1)[1]  # 指定的配置文檔（config.txt）保存路徑全名："C:/StatisticalServer/StatisticalServerPython/config.txt" "/home/StatisticalServer/StatisticalServerPython/config.txt" ;
                    # print("Config file:", configFile)
                    break
                    # continue
                # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                elif sys.argv[i].split("=", -1)[0] == "time_sleep":
                    time_sleep = float(sys.argv[i].split("=", -1)[1])  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                    # print("Operation document time sleep:", time_sleep)
                    continue
                else:
                    # print(sys.argv[i], "unrecognized.")
                    # sys.exit(1)  # 中止當前進程，退出當前程序;
                    continue


# 讀取配置文檔（config.txt）裏的參數;
# "/home/StatisticalServer/StatisticalServerPython/config.txt"
# "C:/StatisticalServer/StatisticalServerPython/config.txt"
if configFile != "":
    # 使用Python原生模組os判斷目錄或文檔是否存在以及是否為文檔;
    if os.path.exists(configFile) and os.path.isfile(configFile):
        # print(configFile, "is a file 是一個文檔.")

        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        # if not (os.access(configFile, os.R_OK) and os.access(configFile, os.W_OK)):
        if not (os.access(configFile, os.R_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(configFile, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(configFile, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(configFile, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(configFile, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(configFile, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                print(f'Error: {configFile} : {error.strerror}')
                print("配置文檔 [ " + configFile + " ] 無法修改為可讀可寫權限.")
                # return configFile

        # if os.access(configFile, os.R_OK) and os.access(configFile, os.W_OK):
        if os.access(configFile, os.R_OK):

            fd = open(configFile, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(configFile, mode="rb+")
            try:
                print("Config file = " + str(configFile))
                # data_Str = fd.read()
                # data_Str = fd.read().decode("utf-8")
                # data_Bytes = data_Str.encode("utf-8")
                # fd.write(data_Bytes)
                lines = fd.readlines()
                line_I = int(0)
                for line in lines:
                    # print(line)

                    line_I = line_I + 1
                    line_Key = ""
                    line_Value = ""

                    # 使用函數 isinstance(line, str) 判斷傳入的參數是否為 str 字符串類型 type(line);
                    if isinstance(line, str) and line != "":

                        if line.find("\r\n", 0, int(len(line) + 1)) != -1:
                            line = line.replace('\r\n', '')  # 刪除行尾的換行符（\r\n）;
                        elif line.find("\r", 0, int(len(line))) != -1:
                            line = line.replace('\r', '')  # 刪除行尾的換行符（\r）;
                        elif line.find("\n", 0, int(len(line))) != -1:
                            line = line.replace('\n', '')  # 刪除行尾的換行符（\n）;
                        else:
                            line = line.strip(' ')  # 刪除行首尾的空格字符（' '）;

                        # 判斷字符串是否含有等號字符（=）連接符（Key=Value），若含有等號字符（=），則以等號字符（=）分割字符串;
                        if line.find("=", 0, int(len(line)-1)) != -1:
                            # line_split = line.split("=", -1)  # 分割字符串中含有的所有等號字符（=）;
                            line_split = line.split("=", 1)  # 祇分割字符串中含有的第一個等號字符（=）;
                            if len(line_split) == 1:
                                if str(line_split[0]) != "":
                                    line_Key = str(line_split[0]).strip(' ')  # 刪除字符串首尾的空格字符（' '）;
                            if len(line_split) > 1:
                                if str(line_split[0]) != "":
                                    line_Key = str(line_split[0]).strip(' ')  # 刪除字符串首尾的空格字符（' '）;
                                if str(line_split[1]) != "":
                                    line_Value = str(line_split[1]).strip(' ')  # 刪除字符串首尾的空格字符（' '）;
                        else:
                            line_Value = line

                        # 判斷啓動函數名稱：interface_Function = Interface_File_Monitor , Interface_http_Server , Interface_http_Client;
                        if line_Key == "interface_Function":
                            # interface_Function = line_Value  # 用於接收執行功能的函數 "do_data";
                            interface_Function_name_str = line_Value
                            # type(Interface_File_Monitor).__name__ == 'classobj' 判斷是否為類，isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                            if isinstance(line_Value, str) and line_Value != "" and line_Value == "file_Monitor":
                                # if type(Interface_File_Monitor).__name__ == 'classobj':
                                #     interface_Function = Interface_File_Monitor
                                #     interface_Function_name_str = "Interface_File_Monitor"
                                interface_Function = Interface_File_Monitor
                                interface_Function_name_str = "Interface_File_Monitor"
                            if isinstance(line_Value, str) and line_Value != "" and line_Value == "http_Server":
                                # if type(Interface_http_Server).__name__ == 'classobj':
                                #     interface_Function = Interface_http_Server
                                #     interface_Function_name_str = "Interface_http_Server"
                                interface_Function = Interface_http_Server
                                interface_Function_name_str = "Interface_http_Server"
                            if isinstance(line_Value, str) and line_Value != "" and line_Value == "http_Client":
                                # if type(Interface_http_Client).__name__ == 'classobj':
                                #     interface_Function = Interface_http_Client
                                #     interface_Function_name_str = "Interface_http_Client"
                                interface_Function = Interface_http_Client
                                interface_Function_name_str = "Interface_http_Client"
                            # print("interface Function:", interface_Function_name_str)
                            # print("interface Function:", line_Value)
                            continue
                        # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                        # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 read_file_do_Function = "read_and_write_file_do_Function";
                        elif line_Key == "read_file_do_Function":
                            # read_file_do_Function = line_Value  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
                            read_file_do_Function_name_str = line_Value  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
                            # isinstance(read_file_do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                            if isinstance(read_file_do_Function_name_str, str) and read_file_do_Function_name_str != "":
                                if read_file_do_Function_name_str == "read_and_write_file_do_Function" and inspect.isfunction(read_and_write_file_do_Function):
                                    read_file_do_Function_name_str_data = "read_and_write_file_do_Function"
                                    read_file_do_Function_data = read_and_write_file_do_Function
                                    # read_file_do_Function = read_and_write_file_do_Function
                                # else:
                            # print("read and write file do Function:", read_file_do_Function)
                            continue
                        # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                        # 用於接收執行功能的函數 do_Function = "do_data";
                        elif line_Key == "do_Function":
                            # do_Function = line_Value  # 用於接收執行功能的函數 "do_data";
                            do_Function_name_str = line_Value  # 用於接收執行功能的函數 "do_data";
                            # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                            if isinstance(do_Function_name_str, str) and do_Function_name_str != "":
                                if do_Function_name_str == "do_data" and inspect.isfunction(do_data):
                                    do_Function_name_str_data = "do_data"
                                    do_Function_data = do_data
                                    # do_Function = do_data
                                elif do_Function_name_str == "do_Request" and inspect.isfunction(do_Request):
                                    do_Function_name_str_Request = "do_Request"
                                    do_Function_Request = do_Request
                                    # do_Function = do_Request
                                elif do_Function_name_str == "do_Response" and inspect.isfunction(do_Response):
                                    do_Function_name_str_Response = "do_Response"
                                    do_Function_Response = do_Response
                                    # do_Function = do_Response
                                # else:
                            # print("do Function:", do_Function)
                            continue
                        # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
                        elif line_Key == "is_monitor":
                            # is_monitor = bool(line_Value)  # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
                            is_monitor_name_str = line_Value  # 用於接收執行功能的函數 "do_data";
                            if isinstance(is_monitor_name_str, str) and is_monitor_name_str != "" and (is_monitor_name_str == "True" or is_monitor_name_str == "true" or is_monitor_name_str == "TRUE" or is_monitor_name_str == "1"):
                                is_monitor = True
                            if isinstance(is_monitor_name_str, str) and (is_monitor_name_str == "" or is_monitor_name_str == "False" or is_monitor_name_str == "false" or is_monitor_name_str == "FALSE" or is_monitor_name_str == "0"):
                                is_monitor = False
                            # print("is monitor:", is_monitor)
                            continue
                        # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
                        elif line_Key == "is_Monitor_Concurrent":
                            is_Monitor_Concurrent = str(line_Value)  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
                            # print("Is Monitor Concurrent:", is_Monitor_Concurrent)
                            continue
                        # 用於接收傳值的媒介文檔 monitor_file = "../temp/intermediary_write_Node.txt";
                        elif line_Key == "monitor_file":
                            monitor_file = str(line_Value)  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                            # print("monitor file:", monitor_file)
                            continue
                        # 用於輸入傳值的媒介目錄 monitor_dir = "../temp/";
                        elif line_Key == "monitor_dir":
                            monitor_dir = str(line_Value)  # 用於輸入傳值的媒介目錄 "../temp/";
                            # print("monitor dir:", monitor_dir)
                            continue
                        # 用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
                        elif line_Key == "temp_cache_IO_data_dir":
                            temp_cache_IO_data_dir = str(line_Value)  # 用於輸入傳值的媒介目錄 "../temp/";
                            # print("temp cache IO data file dir:", temp_cache_IO_data_dir)
                            continue
                        # 用於輸出傳值的媒介目錄 monitor_dir = "../temp/";
                        elif line_Key == "output_dir":
                            output_dir = str(line_Value)  # 用於輸出傳值的媒介目錄 "../temp/";
                            # print("output dir:", output_dir)
                            continue
                        # 用於輸出傳值的媒介文檔 output_file = "../temp/intermediary_write_Python.txt";
                        elif line_Key == "output_file":
                            output_file = str(line_Value)  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
                            # print("output file:", output_file)
                            continue
                        # 用於對返回數據執行功能的解釋器可執行文件 to_executable = "C:\\NodeJS\\nodejs\\node.exe";
                        elif line_Key == "to_executable":
                            to_executable = str(line_Value)  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                            # print("to executable:", to_executable)
                            continue
                        # 用於對返回數據執行功能的被調用的脚本文檔 to_script = "../js/test.js";
                        elif line_Key == "to_script":
                            to_script = str(line_Value)  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                            # print("to script:", to_script)
                            continue
                        # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                        elif line_Key == "number_Worker_process":
                            number_Worker_process = int(line_Value)  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                            # print("number Worker processes:", number_Worker_process)
                            continue
                        # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                        elif line_Key == "time_sleep":
                            time_sleep = float(line_Value)  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                            # print("Operation document time sleep:", time_sleep)
                            continue

                        # 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
                        # http 服務器運行的根目錄 webPath = "C:/StatisticalServer/StatisticalServerPython/src/";
                        if line_Key == "webPath":
                            webPath = str(line_Value)  # http 服務器運行的根目錄 webPath = "C:/StatisticalServer/StatisticalServerPython/src/";
                            # print("webPath:", webPath)
                            continue
                        # http 服務器監聽的IP地址 host = "0.0.0.0";
                        elif line_Key == "host":
                            host = str(line_Value)  # http 服務器（Server）監聽的IP地址 host = "0.0.0.0";
                            # print("host:", host)
                            Host = str(line_Value)  # http 用戶端（Client）發送請求的目標主機IP地址 Host = "0.0.0.0";
                            # print("Host:", Host)
                            continue
                        # http 服務器監聽的埠號 port = int(8000);
                        elif line_Key == "port":
                            port = int(line_Value)  # http 服務器（Server）監聽的埠號 port = int(8000);
                            # print("port:", port)
                            Port = int(line_Value)  # http 用戶端（Client）發送請求的目標主機埠號 Port = int(8000);
                            # print("Port:", Port)
                            continue
                        # http 用戶端（Client）請求的方法 Method = "POST" or "GET";
                        elif line_Key == "requestMethod":
                            Method = str(line_Value)  # http 用戶端（Client）請求的方法 Method = "POST" or "GET";
                            # print("Method:", Method)
                            continue
                        # http 用戶端（Client）請求的網址 URL = "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
                        elif line_Key == "URL":
                            URL = str(line_Value)  # http 用戶端（Client）請求的網址 URL = "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
                            # print("request URL:", URL)
                            continue
                        # 傳入客戶端訪問服務器時發送請求（request）的頭（Head）參數 request_Auth = "username:password";
                        elif line_Key == "Authorization":
                            request_Auth = str(line_Value)  # 傳入客戶端訪問服務器時發送請求（request）的頭（Head）參數 request_Auth = "username:password";
                            # print("request Authorization:", request_Auth)
                            continue
                        # http 用戶端（Client）請求的 Cookie 值 request_Cookie = "Session_ID=request_Key->username:password" ;
                        elif line_Key == "Cookie":
                            request_Cookie = str(line_Value)  # http 用戶端（Client）請求的 Cookie 值 request_Cookie = "Session_ID=request_Key->username:password" ;
                            # print("request Cookie:", request_Cookie)
                            continue
                        # http 用戶端（Client）請求（Post）發送的數據（Body）值 post_Data_String = json.dumps(post_Data_JSON);
                        elif line_Key == "postData":
                            post_Data_String = str(line_Value)  # http 用戶端（Client）請求（Post）發送的數據（Body）值 post_Data_String = json.dumps(post_Data_JSON);
                            # print("request post data string:", "\n", post_Data_String)
                            continue
                        # http 用戶端（Client）請求的連接等待超時中止參數，單位（秒） time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;
                        elif line_Key == "time_out":
                            time_out = float(line_Value)  # http 用戶端（Client）請求的連接等待超時中止參數，單位（秒） time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;
                            # print("http client time out:", time_out)
                            continue
                        # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                        elif line_Key == "Is_multi_thread":
                            Is_multi_thread = bool(line_Value)  # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                            # print("multi thread:", Is_multi_thread)
                            continue
                        # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 Key = "username:password";
                        elif line_Key == "Key":
                            Key = str(line_Value)  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                            # print("Key:", Key)
                            continue
                        # 用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                        elif line_Key == "Session":
                            Session_name_str = line_Value

                            # # 使用自定義函數check_json_format(raw_msg)判斷傳入參數lines[1]是否為JSON格式的字符串
                            # if check_json_format(str(line_Value)):
                            #     Session = json.loads(line_Value, encoding='utf-8')  # 將讀取到的傳入參數字符串轉換爲JSON對象，用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                            # else:
                            #     print("控制臺傳入的 Session 參數 JSON 字符串無法轉換為 JSON 對象: " + line)

                            # isinstance(JSON, dict) 判斷是否為 JSON 對象類型數據;
                            if isinstance(Session_name_str, str) and Session_name_str != "" and Session_name_str == "Session" and isinstance(Session, dict):
                                Session = Session
                            # print("Session:", Session)
                            continue
                        # 用於接收執行功能的函數 do_GET_Function = "do_GET_root_directory";
                        elif line_Key == "do_GET_Function":
                            # do_GET_Function = line_Value  # 用於接收執行功能的函數 "do_GET_root_directory";
                            do_GET_Function_name_str = line_Value  # 用於接收執行功能的函數 "do_GET_root_directory";
                            # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                            if isinstance(do_GET_Function_name_str, str) and do_GET_Function_name_str != "" and do_GET_Function_name_str == "do_GET_root_directory" and inspect.isfunction(do_GET_root_directory):
                                do_GET_Function = do_GET_root_directory
                            # print("do GET Function:", do_GET_Function)
                            continue
                        # 用於接收執行功能的函數 do_POST_Function = "do_POST_root_directory";
                        elif line_Key == "do_POST_Function":
                            # do_POST_Function = line_Value  # 用於接收執行功能的函數 "do_POST_root_directory";
                            do_POST_Function_name_str = line_Value  # 用於接收執行功能的函數 "do_POST_root_directory";
                            # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                            if isinstance(do_POST_Function_name_str, str) and do_POST_Function_name_str != "" and do_POST_Function_name_str == "do_POST_root_directory" and inspect.isfunction(do_POST_root_directory):
                                do_POST_Function = do_POST_root_directory
                            # print("do POST Function:", do_POST_Function)
                            continue

                        else:
                            # print(line, "unrecognized.")
                            continue

            except FileNotFoundError:
                print("配置文檔 [ " + configFile + " ] 不存在.")
            # except PersmissionError:
            #     print("配置文檔 [ " + configFile + " ] 沒有打開權限.")
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("配置文檔 [ " + configFile + " ] 無法讀取數據.")
                    print(f'Error: {configFile} : {error.strerror}')
                    # print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試讀取文檔 " + configFile)
                    # time.sleep(time_sleep)  # 用於讀取文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
                    # try:
                    #     data_Str = fd.read()
                    #     # data_Str = fd.read().decode("utf-8")
                    #     # data_Bytes = data_Str.encode("utf-8")
                    #     # fd.write(data_Bytes)
                    # except OSError as error:
                    #     print("配置文檔 [ " + configFile + " ] 無法讀取數據.")
                    #     print(f'Error: {configFile} : {error.strerror}')
                else:
                    print(f'Error: {configFile} : {error.strerror}')
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

    else:
        print("Config file: [ ", str(configFile), " ] unrecognized.")
        # sys.exit(1)  # 中止當前進程，退出當前程序;


# 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# print(type(sys.argv))
# print(sys.argv)
if len(sys.argv) > 1:
    for i in range(len(sys.argv)):
        # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
        if i > 0:
            # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
            if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:

                if sys.argv[i].split("=", -1)[0] == "interface_Function":
                    # interface_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    # interface_Function_name_str = sys.argv[i].split("=", -1)[1]
                    # type(Interface_File_Monitor).__name__ == 'classobj' 判斷是否為類，isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(sys.argv[i].split("=", -1)[1], str) and sys.argv[i].split("=", -1)[1] != "" and sys.argv[i].split("=", -1)[1] == "file_Monitor":
                        # if type(Interface_File_Monitor).__name__ == 'classobj':
                        #     interface_Function = Interface_File_Monitor
                        #     interface_Function_name_str = "Interface_File_Monitor"
                        interface_Function = Interface_File_Monitor
                        interface_Function_name_str = "Interface_File_Monitor"
                    if isinstance(sys.argv[i].split("=", -1)[1], str) and sys.argv[i].split("=", -1)[1] != "" and sys.argv[i].split("=", -1)[1] == "http_Server":
                        # if type(Interface_http_Server).__name__ == 'classobj':
                        #     interface_Function = Interface_http_Server
                        #     interface_Function_name_str = "Interface_http_Server"
                        interface_Function = Interface_http_Server
                        interface_Function_name_str = "Interface_http_Server"
                    if isinstance(sys.argv[i].split("=", -1)[1], str) and sys.argv[i].split("=", -1)[1] != "" and sys.argv[i].split("=", -1)[1] == "http_Client":
                        # if type(Interface_http_Client).__name__ == 'classobj':
                        #     interface_Function = Interface_http_Client
                        #     interface_Function_name_str = "Interface_http_Client"
                        interface_Function = Interface_http_Client
                        interface_Function_name_str = "Interface_http_Client"
                    # print("interface Function:", interface_Function_name_str)
                    # print("interface Function:", sys.argv[i].split("=", -1)[1])
                    continue
                # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 read_file_do_Function = "read_and_write_file_do_Function";
                elif sys.argv[i].split("=", -1)[0] == "read_file_do_Function":
                    # read_file_do_Function = sys.argv[i].split("=", -1)[1]  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
                    read_file_do_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
                    # isinstance(read_file_do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(read_file_do_Function_name_str, str) and read_file_do_Function_name_str != "":
                        if read_file_do_Function_name_str == "read_and_write_file_do_Function" and inspect.isfunction(read_and_write_file_do_Function):
                            read_file_do_Function_name_str_data = "read_and_write_file_do_Function"
                            read_file_do_Function_data = read_and_write_file_do_Function
                            # read_file_do_Function = read_and_write_file_do_Function
                        # else:
                    # print("read and write file do Function:", read_file_do_Function)
                    continue
                # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                # 用於接收執行功能的函數 do_Function = "do_data";
                elif sys.argv[i].split("=", -1)[0] == "do_Function":
                    # do_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    do_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_Function_name_str, str) and do_Function_name_str != "":
                        if do_Function_name_str == "do_data" and inspect.isfunction(do_data):
                            do_Function_name_str_data = "do_data"
                            do_Function_data = do_data
                            # do_Function = do_data
                        elif do_Function_name_str == "do_Request" and inspect.isfunction(do_Request):
                            do_Function_name_str_Request = "do_Request"
                            do_Function_Request = do_Request
                            # do_Function = do_Request
                        elif do_Function_name_str == "do_Response" and inspect.isfunction(do_Response):
                            do_Function_name_str_Response = "do_Response"
                            do_Function_Response = do_Response
                            # do_Function = do_Response
                        # else:
                    # print("do Function:", do_Function)
                    continue
                # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
                elif sys.argv[i].split("=", -1)[0] == "is_monitor":
                    # is_monitor = bool(sys.argv[i].split("=", -1)[1])  # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
                    is_monitor_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    if isinstance(is_monitor_name_str, str) and is_monitor_name_str != "" and (is_monitor_name_str == "True" or is_monitor_name_str == "true" or is_monitor_name_str == "TRUE" or is_monitor_name_str == "1"):
                        is_monitor = True
                    if isinstance(is_monitor_name_str, str) and (is_monitor_name_str == "" or is_monitor_name_str == "False" or is_monitor_name_str == "false" or is_monitor_name_str == "FALSE" or is_monitor_name_str == "0"):
                        is_monitor = False
                    # print("is monitor:", is_monitor)
                    continue
                # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
                elif sys.argv[i].split("=", -1)[0] == "is_Monitor_Concurrent":
                    is_Monitor_Concurrent = str(sys.argv[i].split("=", -1)[1])  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
                    # print("Is Monitor Concurrent:", is_Monitor_Concurrent)
                    continue
                # 用於接收傳值的媒介文檔 monitor_file = "../temp/intermediary_write_Node.txt";
                elif sys.argv[i].split("=", -1)[0] == "monitor_file":
                    monitor_file = str(sys.argv[i].split("=", -1)[1])  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                    # print("monitor file:", monitor_file)
                    continue
                # 用於輸入傳值的媒介目錄 monitor_dir = "../temp/";
                elif sys.argv[i].split("=", -1)[0] == "monitor_dir":
                    monitor_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸入傳值的媒介目錄 "../temp/";
                    # print("monitor dir:", monitor_dir)
                    continue
                # 用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
                elif sys.argv[i].split("=", -1)[0] == "temp_cache_IO_data_dir":
                    temp_cache_IO_data_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸入傳值的媒介目錄 "../temp/";
                    # print("temp cache IO data file dir:", temp_cache_IO_data_dir)
                    continue
                # 用於輸出傳值的媒介目錄 monitor_dir = "../temp/";
                elif sys.argv[i].split("=", -1)[0] == "output_dir":
                    output_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸出傳值的媒介目錄 "../temp/";
                    # print("output dir:", output_dir)
                    continue
                # 用於輸出傳值的媒介文檔 output_file = "../temp/intermediary_write_Python.txt";
                elif sys.argv[i].split("=", -1)[0] == "output_file":
                    output_file = str(sys.argv[i].split("=", -1)[1])  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
                    # print("output file:", output_file)
                    continue
                # 用於對返回數據執行功能的解釋器可執行文件 to_executable = "C:\\NodeJS\\nodejs\\node.exe";
                elif sys.argv[i].split("=", -1)[0] == "to_executable":
                    to_executable = str(sys.argv[i].split("=", -1)[1])  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                    # print("to executable:", to_executable)
                    continue
                # 用於對返回數據執行功能的被調用的脚本文檔 to_script = "../js/test.js";
                elif sys.argv[i].split("=", -1)[0] == "to_script":
                    to_script = str(sys.argv[i].split("=", -1)[1])  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                    # print("to script:", to_script)
                    continue
                # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                elif sys.argv[i].split("=", -1)[0] == "number_Worker_process":
                    number_Worker_process = int(sys.argv[i].split("=", -1)[1])  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                    # print("number Worker processes:", number_Worker_process)
                    continue
                # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                elif sys.argv[i].split("=", -1)[0] == "time_sleep":
                    time_sleep = float(sys.argv[i].split("=", -1)[1])  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                    # print("Operation document time sleep:", time_sleep)
                    continue

                # 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
                # http 服務器運行的根目錄 webPath = "C:/StatisticalServer/StatisticalServerPython/src/";
                if sys.argv[i].split("=", -1)[0] == "webPath":
                    webPath = str(sys.argv[i].split("=", -1)[1])  # http 服務器運行的根目錄 webPath = "C:/StatisticalServer/StatisticalServerPython/src/";
                    # print("webPath:", webPath)
                    continue
                # http 服務器監聽的IP地址 host = "0.0.0.0";
                elif sys.argv[i].split("=", -1)[0] == "host":
                    host = str(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的IP地址 host = "0.0.0.0";
                    # print("host:", host)
                    Host = str(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的IP地址 Host = "127.0.0.1";
                    # print("Host:", Host)
                    continue
                # http 服務器監聽的埠號 port = int(8000);
                elif sys.argv[i].split("=", -1)[0] == "port":
                    port = int(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的埠號 port = int(8000);
                    # print("port:", port)
                    Port = int(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的埠號 Port = int(8000);
                    # print("Port:", Port)
                    continue
                # http 用戶端（Client）請求的方法 Method = "POST" or "GET";
                elif sys.argv[i].split("=", -1)[0] == "requestMethod":
                    Method = str(sys.argv[i].split("=", -1)[1])  # http 用戶端（Client）請求的方法 Method = "POST" or "GET";
                    # print("Method:", Method)
                    continue
                # http 用戶端（Client）請求的網址 URL = "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
                elif sys.argv[i].split("=", -1)[0] == "URL":
                    URL = str(sys.argv[i].split("=", -1)[1])  # http 用戶端（Client）請求的網址 URL = "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
                    # print("request URL:", URL)
                    continue
                # 傳入客戶端訪問服務器時發送請求（request）的頭（Head）參數 request_Auth = "username:password";
                elif sys.argv[i].split("=", -1)[0] == "Authorization":
                    # Key = str(sys.argv[i].split("=", -1)[1])  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                    # # print("Key:", Key)
                    request_Auth = str(sys.argv[i].split("=", -1)[1])  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                    # print("request Authorization:", request_Auth)
                    continue
                # http 用戶端（Client）請求的 Cookie 值 request_Cookie = "Session_ID=request_Key->username:password" ;
                elif sys.argv[i].split("=", -1)[0] == "Cookie":
                    request_Cookie = str(sys.argv[i].split("=", -1)[1])  # http 用戶端（Client）請求的 Cookie 值 request_Cookie = "Session_ID=request_Key->username:password"
                    # print("request Cookie:", request_Cookie)
                    continue
                # http 用戶端（Client）請求（Post）發送的數據（Body）值 post_Data_String = json.dumps(post_Data_JSON);
                elif sys.argv[i].split("=", -1)[0] == "postData":
                    post_Data_String = str(sys.argv[i].split("=", -1)[1])  # http 用戶端（Client）請求（Post）發送的數據（Body）值 post_Data_String = json.dumps(post_Data_JSON);
                    # print("request post data string:", "\n", post_Data_String)
                    continue
                # http 用戶端（Client）請求的連接等待超時中止參數，單位（秒） time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;
                elif sys.argv[i].split("=", -1)[0] == "time_out":
                    time_out = float(sys.argv[i].split("=", -1)[1])  # http 用戶端（Client）請求的連接等待超時中止參數，單位（秒） time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;
                    # print("http client time out:", time_out)
                    continue
                # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                elif sys.argv[i].split("=", -1)[0] == "Is_multi_thread":
                    Is_multi_thread = bool(sys.argv[i].split("=", -1)[1])  # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                    # print("multi thread:", Is_multi_thread)
                    continue
                # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 Key = "username:password";
                elif sys.argv[i].split("=", -1)[0] == "Key":
                    Key = str(sys.argv[i].split("=", -1)[1])  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                    # print("Key:", Key)
                    # request_Auth = str(sys.argv[i].split("=", -1)[1])  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                    # # print("request Authorization:", request_Auth)
                    continue
                # 用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                elif sys.argv[i].split("=", -1)[0] == "Session":
                    Session_name_str = sys.argv[i].split("=", -1)[1]

                    # # 使用自定義函數check_json_format(raw_msg)判斷傳入參數sys.argv[1]是否為JSON格式的字符串
                    # if check_json_format(str(sys.argv[i].split("=", -1)[1])):
                    #     Session = json.loads(sys.argv[i].split("=", -1)[1], encoding='utf-8')  # 將讀取到的傳入參數字符串轉換爲JSON對象，用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                    # else:
                    #     print("控制臺傳入的 Session 參數 JSON 字符串無法轉換為 JSON 對象: " + sys.argv[i])

                    # isinstance(JSON, dict) 判斷是否為 JSON 對象類型數據;
                    if isinstance(Session_name_str, str) and Session_name_str != "" and Session_name_str == "Session" and isinstance(Session, dict):
                        Session = Session
                    # print("Session:", Session)
                    continue
                # 用於接收執行功能的函數 do_GET_Function = "do_GET_root_directory";
                elif sys.argv[i].split("=", -1)[0] == "do_GET_Function":
                    # do_GET_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_GET_root_directory";
                    do_GET_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_GET_root_directory";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_GET_Function_name_str, str) and do_GET_Function_name_str != "" and do_GET_Function_name_str == "do_GET_root_directory" and inspect.isfunction(do_GET_root_directory):
                        do_GET_Function = do_GET_root_directory
                    # print("do GET Function:", do_GET_Function)
                    continue
                # 用於接收執行功能的函數 do_POST_Function = "do_POST_root_directory";
                elif sys.argv[i].split("=", -1)[0] == "do_POST_Function":
                    # do_POST_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_POST_root_directory";
                    do_POST_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_POST_root_directory";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_POST_Function_name_str, str) and do_POST_Function_name_str != "" and do_POST_Function_name_str == "do_POST_root_directory" and inspect.isfunction(do_POST_root_directory):
                        do_POST_Function = do_POST_root_directory
                    # print("do POST Function:", do_POST_Function)
                    continue

                else:
                    # print(sys.argv[i], "unrecognized.")
                    continue


# 根據從配置文檔（config.txt）中讀入的參數值，修改使用 import 方法加載的外部自定義路由（Router）模組「Router.py」内的變量的值，刷新賦值;
Router.webPath = webPath
Router.Key = Key
Router.Session = Session


# 啓動運行服務器;
if interface_Function_name_str == "file_Monitor" or interface_Function_name_str == "Interface_File_Monitor":
    monitor_Function = interface_Function(
        is_monitor=is_monitor,
        is_Monitor_Concurrent=is_Monitor_Concurrent,
        monitor_file=monitor_file,
        monitor_dir=monitor_dir,
        read_file_do_Function=read_file_do_Function_data,
        do_Function=do_Function_data,
        # do_Function_obj=do_Function_obj_data,
        output_dir=output_dir,
        output_file=output_file,
        to_executable=to_executable,
        to_script=to_script,
        # return_obj=return_obj,
        number_Worker_process=number_Worker_process,
        temp_cache_IO_data_dir=temp_cache_IO_data_dir,
        time_sleep=time_sleep
    )
elif interface_Function_name_str == "http_Server" or interface_Function_name_str == "Interface_http_Server":
    monitor_Function = interface_Function(
        host=host,
        port=port,
        Is_multi_thread=Is_multi_thread,
        Key=Key,
        Session=Session,
        # do_Function_obj=do_Function_obj_Request,
        do_Function=do_Function_Request,
        number_Worker_process=number_Worker_process
    )
elif interface_Function_name_str == "http_Client" or interface_Function_name_str == "Interface_http_Client":
    monitor_Function = interface_Function(
        Host,
        Port,
        URL,
        Method,
        request_Auth,
        request_Cookie,
        post_Data_String,
        time_out
    )
# else:
# monitor_Function = interface_Function()
if interface_Function_name_str == "file_Monitor" or interface_Function_name_str == "Interface_File_Monitor" or interface_Function_name_str == "http_Server" or interface_Function_name_str == "Interface_http_Server":
    result_tuple = monitor_Function.run()
elif interface_Function_name_str == "http_Client" or interface_Function_name_str == "Interface_http_Client":
    result_tuple = do_Function_Response(monitor_Function)
    # print(result_tuple)
# else:
# print(type(result_tuple))  # tuple;
# print(result_tuple[0])

return_file_creat_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")

result_text = ""
if interface_Function_name_str == "file_Monitor" or interface_Function_name_str == "Interface_File_Monitor":

    if is_monitor == True:
        result_text = "code:0"

    if is_monitor == False:
        if isinstance(result_tuple, tuple) and len(result_tuple) == 3 and isinstance(result_tuple[1], str) and isinstance(result_tuple[2], str) and isinstance(do_Function_name_str_data, str) and do_Function_name_str_data != "":
            return_info_JSON = {
                "Python_say": {
                    "output_file": str(result_tuple[1]),
                    "monitor_file": str(result_tuple[2]),
                    "do_Function": str(do_Function_name_str_data)
                },
                "time": str(return_file_creat_time)
            }  # '{"Python_say":{"output_file":"' + str(result_tuple[2]) + '","monitor_file":"' + str(result_tuple[3]) + '","do_Function":""},"time":"' + str(return_file_creat_time) + '"}'
            result_text = "\n".join(['code:0', json.dumps(return_info_JSON)])  # json.loads(JSON_str);
        elif isinstance(result_tuple, tuple) and len(result_tuple) == 3 and isinstance(result_tuple[1], str) and isinstance(result_tuple[2], str):
            return_info_JSON = {
                "Python_say": {
                    "output_file": str(result_tuple[1]),
                    "monitor_file": str(result_tuple[2]),
                    "do_Function": ""
                },
                "time": str(return_file_creat_time)
            }  # '{"Python_say":{"output_file":"' + str(result_tuple[2]) + '","monitor_file":"' + str(result_tuple[3]) + '","do_Function":""},"time":"' + str(return_file_creat_time) + '"}'
            result_text = "\n".join(['code:0', json.dumps(return_info_JSON)])  # json.loads(JSON_str);
        else:
            result_text = "code:-1"

elif interface_Function_name_str == "http_Server" or interface_Function_name_str == "Interface_http_Server":
    result_text = "code:0"
elif interface_Function_name_str == "http_Client" or interface_Function_name_str == "Interface_http_Client":
    result_text = "code:0"
# else:

# 將運算結果保存的目標文檔的信息，寫入控制臺標準輸出（顯示器），便於使主調程序獲取完成信號;
sys.stdout.write(result_text)  # 將運算結果寫到操作系統控制臺;
# print(result_text)  # 將運算結果寫到操作系統控制臺;
