# !/usr/bin/python3
# coding=utf-8


#################################################################################

# Title: Python3 server v20161211
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
# C:\Criss> C:/Criss/Python/Python311/python.exe C:/Criss/py/Interface.py configFile=C:/Criss/py/config.txt webPath=C:/Criss/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=C:/Criss/temp/
# root@localhost:~# /usr/bin/python3 /home/Criss/py/Interface.py configFile=/home/Criss/py/config.txt webPath=/home/Criss/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/Criss/temp/

#################################################################################


import platform  # 加載Python原生的與平臺屬性有關的模組;
import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型;
import subprocess  # 加載Python原生的創建子進程模組;
import string  # 加載Python原生的字符串處理模組;
import datetime, time  # 加載Python原生的日期數據處理模組;
import json  # import the module of json. 加載Python原生的Json處理模組;
import re  # 加載Python原生的正則表達式對象
from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
import struct  # 用於讀、寫、操作二進制本地硬盤文檔;
import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
import threading  # 加載Python原生的支持多綫程（執行緒）模組;
from socketserver import ThreadingMixIn  #, ForkingMixIn
import inspect, ctypes  # 用於强制終止綫程;
import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
# https: // docs.python.org/3/library/http.server.html
from http import cookiejar  # 用於處理請求Cookie;
import socket  # 加載Python原生的套接字模組socket、配置服務器支持 IPv6 格式地址;
import ssl  # 用於處理請求證書驗證;
import base64  # 加載加、解密模組;
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)


# # 匯入自定義路由模組脚本文檔「./Interface.py」;
# # os.getcwd() # 獲取當前工作目錄路徑;
# # os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# # os.path.join(os.path.abspath("."), 'Interface.py')  # 拼接路徑字符串;
# # pathlib.Path(os.path.join(os.path.abspath("."), Interface.py)  # 返回路徑對象;
# # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# import Interface as Interface  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Interface.py」;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append("path") 函數臨時添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」，使用 sys.path.append("path") 方法添加搜索目錄，只是臨時行爲，解釋器退出重啓即會失效;
# Interface_File_Monitor = Interface.File_Monitor
# Interface_http_Server = Interface.http_Server
# Interface_http_Client = Interface.http_Client


# 自定義封裝的函數check_ip(address)用於判斷是否爲 IP 地址的字符串，並判斷是：IPv6，還是：IPv4;
def check_ip(address):
    """
    用於判斷一個字符串是否符合 IP 地址格式
    :param self:
    :return:
    """
    if isinstance(address, str):  # 首先判斷傳入的參數是否為一個字符串，如果不是直接返回false值
        # IPv6 格式由八組十六進制數字構成，並且每組之間通過符號「:」分隔;
        IPv6_pattern = r'^([A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4}$'
        # IPv4 格式爲四段數字，每段範圍從「0」至「255」，並且通過符號「.」分隔;
        IPv4_pattern = r'^(([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.){3}([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])$'
        if re.match(IPv6_pattern, address):
            return "IPv6"
        elif re.match(IPv4_pattern, address):
            return "IPv4"
        else:
            return False
    else:
        return False

# 自定義封裝的函數check_json_format(raw_msg)用於判斷是否為JSON格式的字符串;
def check_json_format(raw_msg):
    """
    用於判斷一個字符串是否符合 JSON 格式
    :param self:
    :return:
    """
    if isinstance(raw_msg, str):  # 首先判斷傳入的參數是否為一個字符串，如果不是直接返回false值
        try:
            json.loads(raw_msg)  # , encoding='utf-8'
            return True
        except ValueError:
            return False
    else:
        return False

# 自定義函數，只能在 Windows 系統使用，判斷某個文檔是否被其它進程占用;
def win_file_is_Used(file_name):
    try:
        vHandle = win32file.CreateFile(file_name, win32file.GENERIC_READ, 0, None, win32file.OPEN_EXISTING, win32file.FILE_ATTRIBUTE_NORMAL, None)
        return int(vHandle) == win32file.INVALID_HANDLE_VALUE
    except:
        return True
    finally:
        try:
            win32file.CloseHandle(vHandle)
        except:
            pass

# 遞歸清空指定目錄（文件夾）下的所有内容（不包括這個文件夾），使用 Python 原生的標準 os 模組;
def clear_Directory(dir_path):
    # os.chdir(dir_path)  # 改變當前工作目錄到指定的路徑;
    list_dir = os.listdir(dir_path)
    if len(list_dir) > 0:
        for f in list_dir:
            if os.path.isfile(dir_path + "\\%s" % f):
                os.remove(dir_path + "\\%s" % f)
            else:
                list_dir_2 = os.listdir(dir_path + "\\%s" % f)
                if len(list_dir_2) > 0:
                    clear_Directory(dir_path + "\\%s" % f)

    list_dir = os.listdir(dir_path)
    if len(list_dir) > 0:
        for f in list_dir:
            if os.path.isfile(dir_path + "\\%s" % f):
                os.remove(dir_path + "\\%s" % f)
            else:
                list_dir_2 = os.listdir(dir_path + "\\%s" % f)
                if len(list_dir_2) == 0:
                    os.rmdir(dir_path + "\\%s" % f)

    return list_dir

# 格式化文檔大小輸出形式;
def formatByte(number):
    for(scale.label) in [(1024*1024*1024, "GB"), (1024*1024, "MB"), (1024, "KB")]:
        if number >= scale:
            return "%.2f %s" % (number*1.0/scale, lable)
        elif number == 1:
            return "1 字節"
        else:
            # 小於 1 字節;
            byte = "%.2f" % (number or 0)
    return str(byte[:-3] if byte.endswith(".00") else byte) + " 字節"



# # 示例函數，處理從硬盤文檔讀取到的字符串數據，然後返回處理之後的結果字符串數據的;
# def do_data(require_data_String):

#     # print(require_data_String)
#     # print(typeof(require_data_String))

#     # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
#     if check_json_format(require_data_String):
#         # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
#         require_data_JSON = json.loads(require_data_String)  # , encoding='utf-8'
#     else:
#         now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
#         require_data_JSON = {
#             "Client_say": require_data_String,
#             "time": str(now_date)
#         }
#     # print(require_data_JSON)
#     # print(typeof(require_data_JSON))

#     Client_say = ""
#     # 使用函數 isinstance(require_data_JSON, dict) 判斷傳入的參數 require_data_JSON 是否為 dict 字典（JSON）格式對象;
#     if isinstance(require_data_JSON, dict):
#         # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
#         if (require_data_JSON.__contains__("Client_say")):
#             Client_say = require_data_JSON["Client_say"]
#         else:
#             Client_say = ""
#             # print('客戶端發送的請求 JSON 對象中無法找到目標鍵(key)信息 ["Client_say"].')
#             # print(require_data_JSON)
#     else:
#         Client_say = require_data_JSON

#     Server_say = Client_say  # "require no problem."
#     # if Client_say == "How are you" or Client_say == "How are you." or Client_say == "How are you!" or Client_say == "How are you !":
#     #     Server_say = "Fine, thank you, and you ?"
#     # else:
#     #     Server_say = "我現在只會説：「 Fine, thank you, and you ? 」，您就不能按規矩說一個：「 How are you ! 」"

#     now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
#     # print(now_date)
#     response_data_JSON = {
#         "Server_say": Server_say,
#         "require_Authorization": "",
#         "time": str(now_date)
#     }
#     # check_json_format(request_data_JSON);
#     # String = json.dumps(JSON); JSON = json.loads(String);

#     response_data_String = Server_say
#     if isinstance(response_data_JSON, dict):
#         response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;

#     # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
#     # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
#     response_data_bytes = response_data_String.encode("utf-8")
#     response_data_String_len = len(bytes(response_data_String, "utf-8"))

#     return response_data_String


# # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
# def read_and_write_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep):

#     # print("當前進程ID: ", multiprocessing.current_process().pid)
#     # print("當前進程名稱: ", multiprocessing.current_process().name)
#     # print("當前綫程ID: ", threading.current_thread().ident)
#     # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
#     if monitor_dir == "" or monitor_file == "" or monitor_file.find(monitor_dir, 0, int(len(monitor_file)-1)) == -1 or output_dir == "" or output_file == "" or output_file.find(output_dir, 0, int(len(output_file)-1)) == -1:
#         return (monitor_dir, monitor_file, output_dir, output_file)

#     # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
#     # os.listdir(monitor_dir)  # 刷新目錄内容列表
#     # print(os.listdir(monitor_dir))
#     # 使用Python原生模組os判斷目錄或文檔是否存在以及是否為文檔;
#     if not(os.path.exists(monitor_file) and os.path.isfile(monitor_file)):
#         return monitor_file

#     # 用於讀取或刪除文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
#     if time_sleep != None and time_sleep != "" and isinstance(time_sleep, str):
#         time_sleep = float(time_sleep)  # 延遲時長單位秒;

#     # 使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
#     if os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir():
#         # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
#         if not (os.access(monitor_dir, os.R_OK) and os.access(monitor_dir, os.W_OK)):
#             try:
#                 # 修改文檔權限 mode:777 任何人可讀寫;
#                 os.chmod(monitor_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
#                 # os.chmod(monitor_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
#                 # os.chmod(monitor_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
#                 # os.chmod(monitor_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
#                 # os.chmod(monitor_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
#                 # stat.S_IXOTH:  其他用戶有執行權0o001
#                 # stat.S_IWOTH:  其他用戶有寫許可權0o002
#                 # stat.S_IROTH:  其他用戶有讀許可權0o004
#                 # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
#                 # stat.S_IXGRP:  組用戶有執行許可權0o010
#                 # stat.S_IWGRP:  組用戶有寫許可權0o020
#                 # stat.S_IRGRP:  組用戶有讀許可權0o040
#                 # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
#                 # stat.S_IXUSR:  擁有者具有執行許可權0o100
#                 # stat.S_IWUSR:  擁有者具有寫許可權0o200
#                 # stat.S_IRUSR:  擁有者具有讀許可權0o400
#                 # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
#                 # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
#                 # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
#                 # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
#                 # stat.S_IREAD:  windows下設為唯讀
#                 # stat.S_IWRITE: windows下取消唯讀
#             except OSError as error:
#                 print(f'Error: {monitor_dir} : {error.strerror}')
#                 print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法修改為可讀可寫權限.")
#                 return monitor_dir
#     else:
#         try:
#             # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
#             # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
#             os.makedirs(monitor_dir, mode=0o777, exist_ok=True)
#         except FileExistsError as error:
#             # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
#             print(f'Error: {monitor_dir} : {error.strerror}')
#             print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
#             return monitor_dir

#     if not (os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir()):
#         print(f'Error: {monitor_dir} : {error.strerror}')
#         print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
#         return monitor_dir

#     data_Str = ""
#     # print(monitor_file, "is a file 是一個文檔.")
#     # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
#     if not (os.access(monitor_file, os.R_OK) and os.access(monitor_file, os.W_OK)):
#         try:
#             # 修改文檔權限 mode:777 任何人可讀寫;
#             os.chmod(monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
#             # os.chmod(monitor_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
#             # os.chmod(monitor_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
#             # os.chmod(monitor_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
#             # os.chmod(monitor_file, stat.S_IWOTH)  # 可被其它用戶寫入;
#             # stat.S_IXOTH:  其他用戶有執行權0o001
#             # stat.S_IWOTH:  其他用戶有寫許可權0o002
#             # stat.S_IROTH:  其他用戶有讀許可權0o004
#             # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
#             # stat.S_IXGRP:  組用戶有執行許可權0o010
#             # stat.S_IWGRP:  組用戶有寫許可權0o020
#             # stat.S_IRGRP:  組用戶有讀許可權0o040
#             # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
#             # stat.S_IXUSR:  擁有者具有執行許可權0o100
#             # stat.S_IWUSR:  擁有者具有寫許可權0o200
#             # stat.S_IRUSR:  擁有者具有讀許可權0o400
#             # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
#             # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
#             # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
#             # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
#             # stat.S_IREAD:  windows下設為唯讀
#             # stat.S_IWRITE: windows下取消唯讀
#         except OSError as error:
#             print(f'Error: {monitor_file} : {error.strerror}')
#             print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.")
#             return monitor_file

#     fd = open(monitor_file, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
#     # fd = open(monitor_file, mode="rb+")
#     try:
#         data_Str = fd.read()
#         # data_Str = fd.read().decode("utf-8")
#         # data_Bytes = data_Str.encode("utf-8")
#         # fd.write(data_Bytes)
#     except FileNotFoundError:
#         print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 不存在.")
#     # except PersmissionError:
#     #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 沒有打開權限.")
#     except Exception as error:
#         if("[WinError 32]" in str(error)):
#             print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法讀取數據.")
#             print(f'Error: {monitor_file} : {error.strerror}')
#             print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試讀取文檔 " + monitor_file)
#             time.sleep(time_sleep)  # 用於讀取文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
#             try:
#                 data_Str = fd.read()
#                 # data_Str = fd.read().decode("utf-8")
#                 # data_Bytes = data_Str.encode("utf-8")
#                 # fd.write(data_Bytes)
#             except OSError as error:
#                 print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法讀取數據.")
#                 print(f'Error: {monitor_file} : {error.strerror}')
#         else:
#             print(f'Error: {monitor_file} : {error.strerror}')
#     finally:
#         fd.close()
#     # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

#     # # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔;
#     # try:
#     #     os.remove(monitor_file)  # os.unlink(monitor_file) 刪除文檔 monitor_file;
#     #     # os.listdir(monitor_dir)  # 刷新目錄内容列表
#     #     # print(os.listdir(monitor_dir))
#     # except Exception as error:
#     #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
#     #     print(f'Error: {monitor_file} : {error.strerror}')
#     #     if("[WinError 32]" in str(error)):
#     #         print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + monitor_file)
#     #         time.sleep(time_sleep)  # 用於刪除文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
#     #         try:
#     #             # os.unlink(monitor_file) 刪除文檔 monitor_file;
#     #             os.remove(monitor_file)
#     #             # os.listdir(monitor_dir)  # 刷新目錄内容列表
#     #             # print(os.listdir(monitor_dir))
#     #         except OSError as error:
#     #             print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
#     #             print(f'Error: {monitor_file} : {error.strerror}')
#     #     # else:
#     #     #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
#     #     #     print(f'Error: {monitor_file} : {error.strerror}')

#     # # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
#     # if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
#     #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
#     #     return monitor_file

#     # 將從用於傳入的媒介文檔 monitor_file 讀取到的數據，傳入自定義函數 do_Function 處理，處理後的結果寫入傳出媒介文檔 output_file;
#     if do_Function != None and hasattr(do_Function, '__call__'):
#         # hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
#         response_data_String = do_Function(data_Str)
#     else:
#         response_data_String = data_Str

#     # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
#     # response_data_JSON = {
#     #     "Server_say": "",
#     #     "require_Authorization": "",
#     #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
#     # }
#     # # print(data_Str)
#     # # print(typeof(data_Str))
#     # if data_Str != "":
#     #     # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
#     #     if self.check_json_format(data_Str):
#     #         # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
#     #         require_data_JSON = json.loads(data_Str)  # , encoding='utf-8'
#     #     else:
#     #         now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
#     #         require_data_JSON = {
#     #             "Client_say": data_Str,
#     #             "time": str(now_date)
#     #         }
#     #     # print(require_data_JSON)
#     #     # print(typeof(require_data_JSON))

#     #     if do_Function != None and hasattr(do_Function, '__call__'):
#     #         # hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
#     #         response_data_JSON["Server_say"] = do_Function(require_data_JSON)["Server_say"]
#     #     else:
#     #         response_data_JSON["Server_say"] = data_Str

#     # else:
#     #     response_data_JSON["Server_say"] = ""

#     # response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;
#     # # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
#     # # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
#     response_data_bytes = response_data_String.encode("utf-8")
#     response_data_String_len = len(bytes(response_data_String, "utf-8"))

#     # 使用Python原生模組os判斷指定的用於輸出傳值的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
#     if os.path.exists(output_dir) and pathlib.Path(output_dir).is_dir():
#         # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
#         if not (os.access(output_dir, os.R_OK) and os.access(output_dir, os.W_OK)):
#             try:
#                 # 修改文檔權限 mode:777 任何人可讀寫;
#                 os.chmod(output_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
#                 # os.chmod(output_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
#                 # os.chmod(output_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
#                 # os.chmod(output_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
#                 # os.chmod(output_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
#                 # stat.S_IXOTH:  其他用戶有執行權0o001
#                 # stat.S_IWOTH:  其他用戶有寫許可權0o002
#                 # stat.S_IROTH:  其他用戶有讀許可權0o004
#                 # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
#                 # stat.S_IXGRP:  組用戶有執行許可權0o010
#                 # stat.S_IWGRP:  組用戶有寫許可權0o020
#                 # stat.S_IRGRP:  組用戶有讀許可權0o040
#                 # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
#                 # stat.S_IXUSR:  擁有者具有執行許可權0o100
#                 # stat.S_IWUSR:  擁有者具有寫許可權0o200
#                 # stat.S_IRUSR:  擁有者具有讀許可權0o400
#                 # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
#                 # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
#                 # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
#                 # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
#                 # stat.S_IREAD:  windows下設為唯讀
#                 # stat.S_IWRITE: windows下取消唯讀
#             except OSError as error:
#                 print(f'Error: {output_dir} : {error.strerror}')
#                 print("用於輸出傳值的媒介文件夾 [ " + output_dir + " ] 無法修改為可讀可寫權限.")
#                 return output_dir
#     else:
#         try:
#             # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
#             # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
#             os.makedirs(output_dir, mode=0o777, exist_ok=True)
#         except FileExistsError as error:
#             # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
#             print(f'Error: {output_dir} : {error.strerror}')
#             print("用於傳值的媒介文件夾 [ " + output_dir + " ] 無法創建.")
#             return output_dir

#     if not (os.path.exists(output_dir) and pathlib.Path(output_dir).is_dir()):
#         print(f'Error: {output_dir} : {error.strerror}')
#         print("用於輸出傳值的媒介文件夾 [ " + output_dir + " ] 無法創建.")
#         return output_dir

#     # 判斷用於輸出傳值的媒介文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
#     if os.path.exists(output_file) and os.path.isfile(output_file):
#         # print(output_file, "is a file 是一個文檔.")
#         # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
#         if not (os.access(output_file, os.R_OK) and os.access(output_file, os.W_OK)):
#             try:
#                 # 修改文檔權限 mode:777 任何人可讀寫;
#                 os.chmod(output_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
#                 # os.chmod(output_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
#                 # os.chmod(output_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
#                 # os.chmod(output_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
#                 # os.chmod(output_file, stat.S_IWOTH)  # 可被其它用戶寫入;
#                 # stat.S_IXOTH:  其他用戶有執行權0o001
#                 # stat.S_IWOTH:  其他用戶有寫許可權0o002
#                 # stat.S_IROTH:  其他用戶有讀許可權0o004
#                 # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
#                 # stat.S_IXGRP:  組用戶有執行許可權0o010
#                 # stat.S_IWGRP:  組用戶有寫許可權0o020
#                 # stat.S_IRGRP:  組用戶有讀許可權0o040
#                 # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
#                 # stat.S_IXUSR:  擁有者具有執行許可權0o100
#                 # stat.S_IWUSR:  擁有者具有寫許可權0o200
#                 # stat.S_IRUSR:  擁有者具有讀許可權0o400
#                 # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
#                 # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
#                 # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
#                 # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
#                 # stat.S_IREAD:  windows下設為唯讀
#                 # stat.S_IWRITE: windows下取消唯讀
#             except OSError as error:
#                 print(f'Error: {output_file} : {error.strerror}')
#                 print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法修改為可讀可寫權限.")
#                 return output_file

#         # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔;
#         try:
#             os.remove(output_file)  # 刪除文檔
#         except OSError as error:
#             print(f'Error: {output_file} : {error.strerror}')
#             print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法刪除，以重新創建更新數據.")
#             return output_file

#         # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
#         if os.path.exists(output_file) and os.path.isfile(output_file):
#             print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法刪除，以重新創建更新數據.")
#             return output_file

#     # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔;
#     fd = open(output_file, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
#     # fd = open(output_file, mode="wb+")
#     try:
#         fd.write(response_data_String)
#         # response_data_bytes = response_data_String.encode("utf-8")
#         # response_data_String_len = len(bytes(response_data_String, "utf-8"))
#         # fd.write(response_data_bytes)
#     except FileNotFoundError:
#         print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 創建失敗.")
#         return output_file
#     # except PersmissionError:
#     #     print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 沒有打開權限.")
#     #     return output_file
#     finally:
#         fd.close()
#     # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

#     # # 運算處理完之後，給調用語言的回復，os.access(to_script, os.X_OK) 判斷脚本文檔是否具有被執行權限;
#     # if type(to_executable) == str and to_executable != "" and os.path.exists(to_executable) and os.path.isfile(to_executable) and os.access(to_executable, os.X_OK):
#     #     if type(to_script) == str and to_script != "" and os.path.exists(to_script) and os.path.isfile(to_script):
#     #         # node  環境;
#     #         # test.js  待執行的JS的檔;
#     #         # %s %s  傳遞給JS檔的參數;
#     #         # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
#     #         shell_to = os.popen('%s %s %s %s %s %s' % (to_executable, to_script, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;
#     #         # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
#     #         # let arg1 = process.argv[2];  // 解析出JS參數;
#     #         # let arg2 = process.argv[3];
#     #     else:
#     #         shell_to = os.popen('%s %s %s %s %s' % (to_executable, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;

#     #     # print(shell_to.readlines());
#     #     result = shell_to.read()  # 取出執行結果
#     #     # print(result)

#     return (response_data_String, output_file, monitor_file)


# # 使用 while True: 的方法設置死循環創建看守進程，監聽指定的硬盤目錄或文檔，響應創建事件，從而達到不同語言之間利用硬盤文檔傳輸數據交互的效果;
# # 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# is_monitor = ""  # boolean;  # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
# is_Monitor_Concurrent = ""  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：0、"0"、"Multi-Threading"、"Multi-Processes";
# monitor_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "Intermediary")  # os.path.join(os.path.abspath(".."), "Intermediary")  # monitor_dir = pathlib.Path("../temp/") 用於輸入傳值的媒介目錄 "../temp/";
# monitor_file = os.path.join(monitor_dir, "intermediary_write_C")  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
# do_Function = "do_data"  # 用於接收執行功能的函數 "do_data";
# read_file_do_Function = "read_and_write_file_do_Function"  # None 或自定義的示例函數 "read_and_write_file_do_Function"，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
# output_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "Intermediary")  # output_dir = pathlib.Path("../temp/") 用於輸出傳值的媒介目錄 "../temp/";
# output_file = os.path.join(str(output_dir), "intermediary_write_Python.txt")  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
# temp_cache_IO_data_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "temp")  # 用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
# to_executable = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "NodeJS", "node.exe")  # os.path.join(os.path.abspath(".."), "/NodeJS/", "node.exe")  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
# to_script = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "js", "test.js")  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
# number_Worker_process = int(0);  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
# time_sleep = float(0.02)  # float(0.02) 用於監聽程序的輪詢延遲參數，單位（秒）;


# # os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
# # os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
# configFile = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "config.txt")).replace('\\', '/')  # "C:/Criss/py/config.txt" # "/home/Criss/py/config.txt"
# # configFile = pathlib.Path(os.path.abspath("..") + "config.txt")  # pathlib.Path("../config.txt")
# # print(configFile)
# # 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的配置文檔（config.txt）參數的保存路徑全名："C:/Criss/py/config.txt" # "/home/Criss/py/config.txt" ;
# # print(type(sys.argv))
# # print(sys.argv)
# if len(sys.argv) > 1:
#     for i in range(len(sys.argv)):
#         # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
#         if i > 0:
#             # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
#             if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:
#                 if sys.argv[i].split("=", -1)[0] == "configFile":
#                     configFile = sys.argv[i].split("=", -1)[1]  # 指定的配置文檔（config.txt）保存路徑全名：# "C:/Criss/py/config.txt" # "/home/Criss/py/config.txt" ;
#                     # print("Config file:", configFile)
#                     break
#                     # continue
#                 # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
#                 elif sys.argv[i].split("=", -1)[0] == "time_sleep":
#                     time_sleep = float(sys.argv[i].split("=", -1)[1])  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
#                     # print("Operation document time sleep:", time_sleep)
#                     continue
#                 else:
#                     # print(sys.argv[i], "unrecognized.")
#                     # sys.exit(1)  # 中止當前進程，退出當前程序;
#                     continue


# # 讀取配置文檔（config.txt）裏的參數;
# # "/home/Criss/py/config.txt"
# # "C:/Criss/py/config.txt"
# if configFile != "":
#     # 使用Python原生模組os判斷目錄或文檔是否存在以及是否為文檔;
#     if os.path.exists(configFile) and os.path.isfile(configFile):
#         # print(configFile, "is a file 是一個文檔.")

#         # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
#         # if not (os.access(configFile, os.R_OK) and os.access(configFile, os.W_OK)):
#         if not (os.access(configFile, os.R_OK)):
#             try:
#                 # 修改文檔權限 mode:777 任何人可讀寫;
#                 os.chmod(configFile, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
#                 # os.chmod(configFile, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
#                 # os.chmod(configFile, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
#                 # os.chmod(configFile, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
#                 # os.chmod(configFile, stat.S_IWOTH)  # 可被其它用戶寫入;
#                 # stat.S_IXOTH:  其他用戶有執行權0o001
#                 # stat.S_IWOTH:  其他用戶有寫許可權0o002
#                 # stat.S_IROTH:  其他用戶有讀許可權0o004
#                 # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
#                 # stat.S_IXGRP:  組用戶有執行許可權0o010
#                 # stat.S_IWGRP:  組用戶有寫許可權0o020
#                 # stat.S_IRGRP:  組用戶有讀許可權0o040
#                 # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
#                 # stat.S_IXUSR:  擁有者具有執行許可權0o100
#                 # stat.S_IWUSR:  擁有者具有寫許可權0o200
#                 # stat.S_IRUSR:  擁有者具有讀許可權0o400
#                 # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
#                 # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
#                 # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
#                 # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
#                 # stat.S_IREAD:  windows下設為唯讀
#                 # stat.S_IWRITE: windows下取消唯讀
#             except OSError as error:
#                 print(f'Error: {configFile} : {error.strerror}')
#                 print("配置文檔 [ " + configFile + " ] 無法修改為可讀可寫權限.")
#                 # return configFile

#         # if os.access(configFile, os.R_OK) and os.access(configFile, os.W_OK):
#         if os.access(configFile, os.R_OK):

#             fd = open(configFile, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
#             # fd = open(configFile, mode="rb+")
#             try:
#                 print("Config file = " + str(configFile))
#                 # data_Str = fd.read()
#                 # data_Str = fd.read().decode("utf-8")
#                 # data_Bytes = data_Str.encode("utf-8")
#                 # fd.write(data_Bytes)
#                 lines = fd.readlines()
#                 line_I = int(0)
#                 for line in lines:
#                     # print(line)

#                     line_I = line_I + 1
#                     line_Key = ""
#                     line_Value = ""

#                     # 使用函數 isinstance(line, str) 判斷傳入的參數是否為 str 字符串類型 type(line);
#                     if isinstance(line, str) and line != "":

#                         if line.find("\r\n", 0, int(len(line) + 1)) != -1:
#                             line = line.replace('\r\n', '')  # 刪除行尾的換行符（\r\n）;
#                         elif line.find("\r", 0, int(len(line))) != -1:
#                             line = line.replace('\r', '')  # 刪除行尾的換行符（\r）;
#                         elif line.find("\n", 0, int(len(line))) != -1:
#                             line = line.replace('\n', '')  # 刪除行尾的換行符（\n）;
#                         else:
#                             line = line.strip(' ')  # 刪除行首尾的空格字符（' '）;

#                         # 判斷字符串是否含有等號字符（=）連接符（Key=Value），若含有等號字符（=），則以等號字符（=）分割字符串;
#                         if line.find("=", 0, int(len(line)-1)) != -1:
#                             # line_split = line.split("=", -1)  # 分割字符串中含有的所有等號字符（=）;
#                             line_split = line.split("=", 1)  # 祇分割字符串中含有的第一個等號字符（=）;
#                             if len(line_split) == 1:
#                                 if str(line_split[0]) != "":
#                                     line_Key = str(line_split[0]).strip(' ')  # 刪除字符串首尾的空格字符（' '）;
#                             if len(line_split) > 1:
#                                 if str(line_split[0]) != "":
#                                     line_Key = str(line_split[0]).strip(' ')  # 刪除字符串首尾的空格字符（' '）;
#                                 if str(line_split[1]) != "":
#                                     line_Value = str(line_split[1]).strip(' ')  # 刪除字符串首尾的空格字符（' '）;
#                         else:
#                             line_Value = line

#                         # 判斷啓動函數名稱：interface_Function = Interface_File_Monitor , Interface_http_Server , Interface_http_Client;
#                         if line_Key == "interface_Function":
#                             # interface_Function = line_Value  # 用於接收執行功能的函數 "do_data";
#                             interface_Function_name_str = line_Value
#                             # type(Interface_File_Monitor).__name__ == 'classobj' 判斷是否為類，isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
#                             if isinstance(line_Value, str) and line_Value != "" and line_Value == "file_Monitor":
#                                 # if type(Interface_File_Monitor).__name__ == 'classobj':
#                                 #     interface_Function = Interface_File_Monitor
#                                 #     interface_Function_name_str = "Interface_File_Monitor"
#                                 interface_Function = Interface_File_Monitor
#                                 interface_Function_name_str = "Interface_File_Monitor"
#                             if isinstance(line_Value, str) and line_Value != "" and line_Value == "http_Server":
#                                 # if type(Interface_http_Server).__name__ == 'classobj':
#                                 #     interface_Function = Interface_http_Server
#                                 #     interface_Function_name_str = "Interface_http_Server"
#                                 interface_Function = Interface_http_Server
#                                 interface_Function_name_str = "Interface_http_Server"
#                             if isinstance(line_Value, str) and line_Value != "" and line_Value == "http_Client":
#                                 # if type(Interface_http_Client).__name__ == 'classobj':
#                                 #     interface_Function = Interface_http_Client
#                                 #     interface_Function_name_str = "Interface_http_Client"
#                                 interface_Function = Interface_http_Client
#                                 interface_Function_name_str = "Interface_http_Client"
#                             # print("interface Function:", interface_Function_name_str)
#                             # print("interface Function:", line_Value)
#                             continue
#                         # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
#                         # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 read_file_do_Function = "read_and_write_file_do_Function";
#                         elif line_Key == "read_file_do_Function":
#                             # read_file_do_Function = line_Value  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
#                             read_file_do_Function_name_str = line_Value  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
#                             # isinstance(read_file_do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
#                             if isinstance(read_file_do_Function_name_str, str) and read_file_do_Function_name_str != "":
#                                 if read_file_do_Function_name_str == "read_and_write_file_do_Function" and inspect.isfunction(read_and_write_file_do_Function):
#                                     read_file_do_Function_name_str_data = "read_and_write_file_do_Function"
#                                     read_file_do_Function_data = read_and_write_file_do_Function
#                                     # read_file_do_Function = read_and_write_file_do_Function
#                                 # else:
#                             # print("read and write file do Function:", read_file_do_Function)
#                             continue
#                         # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
#                         # 用於接收執行功能的函數 do_Function = "do_data";
#                         elif line_Key == "do_Function":
#                             # do_Function = line_Value  # 用於接收執行功能的函數 "do_data";
#                             do_Function_name_str = line_Value  # 用於接收執行功能的函數 "do_data";
#                             # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
#                             if isinstance(do_Function_name_str, str) and do_Function_name_str != "":
#                                 if do_Function_name_str == "do_data" and inspect.isfunction(do_data):
#                                     do_Function_name_str_data = "do_data"
#                                     do_Function_data = do_data
#                                     # do_Function = do_data
#                                 elif do_Function_name_str == "do_Request" and inspect.isfunction(do_Request):
#                                     do_Function_name_str_Request = "do_Request"
#                                     do_Function_Request = do_Request
#                                     # do_Function = do_Request
#                                 # else:
#                             # print("do Function:", do_Function)
#                             continue
#                         # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
#                         elif line_Key == "is_monitor":
#                             # is_monitor = bool(line_Value)  # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
#                             is_monitor_name_str = line_Value  # 用於接收執行功能的函數 "do_data";
#                             if isinstance(is_monitor_name_str, str) and is_monitor_name_str != "" and (is_monitor_name_str == "True" or is_monitor_name_str == "true" or is_monitor_name_str == "TRUE" or is_monitor_name_str == "1"):
#                                 is_monitor = True
#                             if isinstance(is_monitor_name_str, str) and (is_monitor_name_str == "" or is_monitor_name_str == "False" or is_monitor_name_str == "false" or is_monitor_name_str == "FALSE" or is_monitor_name_str == "0"):
#                                 is_monitor = False
#                             # print("is monitor:", is_monitor)
#                             continue
#                         # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
#                         elif line_Key == "is_Monitor_Concurrent":
#                             is_Monitor_Concurrent = str(line_Value)  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
#                             # print("Is Monitor Concurrent:", is_Monitor_Concurrent)
#                             continue
#                         # 用於接收傳值的媒介文檔 monitor_file = "../temp/intermediary_write_Node.txt";
#                         elif line_Key == "monitor_file":
#                             monitor_file = str(line_Value)  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
#                             # print("monitor file:", monitor_file)
#                             continue
#                         # 用於輸入傳值的媒介目錄 monitor_dir = "../temp/";
#                         elif line_Key == "monitor_dir":
#                             monitor_dir = str(line_Value)  # 用於輸入傳值的媒介目錄 "../temp/";
#                             # print("monitor dir:", monitor_dir)
#                             continue
#                         # 用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
#                         elif line_Key == "temp_cache_IO_data_dir":
#                             temp_cache_IO_data_dir = str(line_Value)  # 用於輸入傳值的媒介目錄 "../temp/";
#                             # print("temp cache IO data file dir:", temp_cache_IO_data_dir)
#                             continue
#                         # 用於輸出傳值的媒介目錄 monitor_dir = "../temp/";
#                         elif line_Key == "output_dir":
#                             output_dir = str(line_Value)  # 用於輸出傳值的媒介目錄 "../temp/";
#                             # print("output dir:", output_dir)
#                             continue
#                         # 用於輸出傳值的媒介文檔 output_file = "../temp/intermediary_write_Python.txt";
#                         elif line_Key == "output_file":
#                             output_file = str(line_Value)  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
#                             # print("output file:", output_file)
#                             continue
#                         # 用於對返回數據執行功能的解釋器可執行文件 to_executable = "C:\\NodeJS\\nodejs\\node.exe";
#                         elif line_Key == "to_executable":
#                             to_executable = str(line_Value)  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
#                             # print("to executable:", to_executable)
#                             continue
#                         # 用於對返回數據執行功能的被調用的脚本文檔 to_script = "../js/test.js";
#                         elif line_Key == "to_script":
#                             to_script = str(line_Value)  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
#                             # print("to script:", to_script)
#                             continue
#                         # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
#                         elif line_Key == "number_Worker_process":
#                             number_Worker_process = int(line_Value)  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
#                             # print("number Worker processes:", number_Worker_process)
#                             continue
#                         # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
#                         elif line_Key == "time_sleep":
#                             time_sleep = float(line_Value)  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
#                             # print("Operation document time sleep:", time_sleep)
#                             continue

#                         # 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
#                         # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
#                         if line_Key == "webPath":
#                             webPath = str(line_Value)  # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
#                             # print("webPath:", webPath)
#                             continue
#                         # http 服務器監聽的IP地址 host = "0.0.0.0";
#                         elif line_Key == "host":
#                             host = str(line_Value)  # http 服務器監聽的IP地址 host = "0.0.0.0";
#                             # print("host:", host)
#                             continue
#                         # http 服務器監聽的埠號 port = int(8000);
#                         elif line_Key == "port":
#                             port = int(line_Value)  # http 服務器監聽的埠號 port = int(8000);
#                             # print("port:", port)
#                             continue
#                         # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
#                         elif line_Key == "Is_multi_thread":
#                             Is_multi_thread = bool(line_Value)  # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
#                             # print("multi thread:", Is_multi_thread)
#                             continue
#                         # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 Key = "username:password";
#                         elif line_Key == "Key":
#                             Key = str(line_Value)  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
#                             # print("Key:", Key)
#                             continue
#                         # 用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
#                         elif line_Key == "Session":
#                             Session_name_str = line_Value

#                             # # 使用自定義函數check_json_format(raw_msg)判斷傳入參數lines[1]是否為JSON格式的字符串
#                             # if check_json_format(str(line_Value)):
#                             #     Session = json.loads(line_Value, encoding='utf-8')  # 將讀取到的傳入參數字符串轉換爲JSON對象，用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
#                             # else:
#                             #     print("控制臺傳入的 Session 參數 JSON 字符串無法轉換為 JSON 對象: " + line)

#                             # isinstance(JSON, dict) 判斷是否為 JSON 對象類型數據;
#                             if isinstance(Session_name_str, str) and Session_name_str != "" and Session_name_str == "Session" and isinstance(Session, dict):
#                                 Session = Session
#                             # print("Session:", Session)
#                             continue
#                         # 用於接收執行功能的函數 do_GET_Function = "do_GET_root_directory";
#                         elif line_Key == "do_GET_Function":
#                             # do_GET_Function = line_Value  # 用於接收執行功能的函數 "do_GET_root_directory";
#                             do_GET_Function_name_str = line_Value  # 用於接收執行功能的函數 "do_GET_root_directory";
#                             # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
#                             if isinstance(do_GET_Function_name_str, str) and do_GET_Function_name_str != "" and do_GET_Function_name_str == "do_GET_root_directory" and inspect.isfunction(do_GET_root_directory):
#                                 do_GET_Function = do_GET_root_directory
#                             # print("do GET Function:", do_GET_Function)
#                             continue
#                         # 用於接收執行功能的函數 do_POST_Function = "do_POST_root_directory";
#                         elif line_Key == "do_POST_Function":
#                             # do_POST_Function = line_Value  # 用於接收執行功能的函數 "do_POST_root_directory";
#                             do_POST_Function_name_str = line_Value  # 用於接收執行功能的函數 "do_POST_root_directory";
#                             # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
#                             if isinstance(do_POST_Function_name_str, str) and do_POST_Function_name_str != "" and do_POST_Function_name_str == "do_POST_root_directory" and inspect.isfunction(do_POST_root_directory):
#                                 do_POST_Function = do_POST_root_directory
#                             # print("do POST Function:", do_POST_Function)
#                             continue

#                         else:
#                             # print(line, "unrecognized.")
#                             continue

#             except FileNotFoundError:
#                 print("配置文檔 [ " + configFile + " ] 不存在.")
#             # except PersmissionError:
#             #     print("配置文檔 [ " + configFile + " ] 沒有打開權限.")
#             except Exception as error:
#                 if("[WinError 32]" in str(error)):
#                     print("配置文檔 [ " + configFile + " ] 無法讀取數據.")
#                     print(f'Error: {configFile} : {error.strerror}')
#                     # print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試讀取文檔 " + configFile)
#                     # time.sleep(time_sleep)  # 用於讀取文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
#                     # try:
#                     #     data_Str = fd.read()
#                     #     # data_Str = fd.read().decode("utf-8")
#                     #     # data_Bytes = data_Str.encode("utf-8")
#                     #     # fd.write(data_Bytes)
#                     # except OSError as error:
#                     #     print("配置文檔 [ " + configFile + " ] 無法讀取數據.")
#                     #     print(f'Error: {configFile} : {error.strerror}')
#                 else:
#                     print(f'Error: {configFile} : {error.strerror}')
#             finally:
#                 fd.close()
#             # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

#     else:
#         print("Config file: [ ", str(configFile), " ] unrecognized.")
#         # sys.exit(1)  # 中止當前進程，退出當前程序;


# # 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# # print(type(sys.argv))
# # print(sys.argv)
# if len(sys.argv) > 1:
#     for i in range(len(sys.argv)):
#         # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
#         if i > 0:
#             # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
#             if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:
#                 # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
#                 if sys.argv[i].split("=", -1)[0] == "is_monitor":
#                     # is_monitor = bool(sys.argv[i].split("=", -1)[1])  # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
#                     if sys.argv[i].split("=", -1)[1] == "True":
#                         is_monitor = True  # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
#                     elif sys.argv[i].split("=", -1)[1] == "False":
#                         is_monitor = False  # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
#                     elif int(sys.argv[i].split("=", -1)[1]) >= int(1):
#                         is_monitor = True  # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
#                     elif int(sys.argv[i].split("=", -1)[1]) == int(0):
#                         is_monitor = False  # 判斷只需要執行一次還是啓動監聽服務器功能 is_monitor = True;
#                     # else:
#                     # print("Is monitor:", is_monitor)
#                     continue
#                 # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
#                 elif sys.argv[i].split("=", -1)[0] == "is_Monitor_Concurrent":
#                     is_Monitor_Concurrent = str(sys.argv[i].split("=", -1)[1])  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
#                     # print("Is Monitor Concurrent:", is_Monitor_Concurrent)
#                     continue
#                 # 用於接收傳值的媒介文檔 monitor_file = "../temp/intermediary_write_Node.txt";
#                 elif sys.argv[i].split("=", -1)[0] == "monitor_file":
#                     monitor_file = sys.argv[i].split("=", -1)[1]  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
#                     # print("monitor file:", monitor_file)
#                     continue
#                 # 用於輸入傳值的媒介目錄 monitor_dir = "../temp/";
#                 elif sys.argv[i].split("=", -1)[0] == "monitor_dir":
#                     monitor_dir = sys.argv[i].split("=", -1)[1]  # 用於輸入傳值的媒介目錄 "../temp/";
#                     # print("monitor dir:", monitor_dir)
#                     continue
#                 # 用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
#                 elif sys.argv[i].split("=", -1)[0] == "temp_cache_IO_data_dir":
#                     temp_cache_IO_data_dir = sys.argv[i].split("=", -1)[1]  # 用於輸入傳值的媒介目錄 "../temp/";
#                     # print("temp cache IO data file dir:", temp_cache_IO_data_dir)
#                     continue
#                 # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 read_file_do_Function = "read_and_write_file_do_Function";
#                 elif sys.argv[i].split("=", -1)[0] == "read_file_do_Function":
#                     read_file_do_Function = sys.argv[i].split("=", -1)[1]  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
#                     # print("read and write file do Function:", read_file_do_Function)
#                     continue
#                 # 用於接收執行功能的函數 do_Function = "do_data";
#                 elif sys.argv[i].split("=", -1)[0] == "do_Function":
#                     do_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
#                     # print("do Function:", do_Function)
#                     continue
#                 # 用於輸出傳值的媒介目錄 monitor_dir = "../temp/";
#                 elif sys.argv[i].split("=", -1)[0] == "output_dir":
#                     output_dir = sys.argv[i].split("=", -1)[1]  # 用於輸出傳值的媒介目錄 "../temp/";
#                     # print("output dir:", output_dir)
#                     continue
#                 # 用於輸出傳值的媒介文檔 output_file = "../temp/intermediary_write_Python.txt";
#                 elif sys.argv[i].split("=", -1)[0] == "output_file":
#                     output_file = sys.argv[i].split("=", -1)[1]  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
#                     # print("output file:", output_file)
#                     continue
#                 # 用於對返回數據執行功能的解釋器可執行文件 to_executable = "C:\\NodeJS\\nodejs\\node.exe";
#                 elif sys.argv[i].split("=", -1)[0] == "to_executable":
#                     to_executable = sys.argv[i].split("=", -1)[1]  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
#                     # print("to executable:", to_executable)
#                     continue
#                 # 用於對返回數據執行功能的被調用的脚本文檔 to_script = "../js/test.js";
#                 elif sys.argv[i].split("=", -1)[0] == "to_script":
#                     to_script = sys.argv[i].split("=", -1)[1]  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
#                     # print("to script:", to_script)
#                     continue
#                 # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
#                 elif sys.argv[i].split("=", -1)[0] == "number_Worker_process":
#                     number_Worker_process = int(sys.argv[i].split("=", -1)[1])  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
#                     # print("number Worker processes:", number_Worker_process)
#                     continue
#                 # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
#                 elif sys.argv[i].split("=", -1)[0] == "time_sleep":
#                     time_sleep = float(sys.argv[i].split("=", -1)[1])  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
#                     # print("Operation document time sleep:", time_sleep)
#                     continue
#                 # else:
#                 #     print(sys.argv[i], "unrecognized.")
#                 #     continue

# Python 自定義類時，類名第一個字母需要大寫，并且不能有參數;
class File_Monitor:
    # 可變參數
    # def Function(*args, **kwargs)  Function(a, b, c, a=1, b=2, c=3)
    # a --int
    # *args --tuple  args == (a, b, c)
    # **kwargs -- dict  kwargs == {'a': 1, 'b': 2, 'c': 3}

    # 在 Python 類 class 中的 def __init__(self) 函數，可以用於配置需要從類外部傳入的參數，預設會將實例化類時傳入的參數複製到這個函數中，並，在類啓動時先運行一下這個函數;
    def __init__(self, **kwargs):

        # 檢查函數需要用到的 Python 原生模組是否已經載入(import)，如果還沒載入，則執行載入操作;
        imported_package_list = dir(list)
        if not("os" in imported_package_list):
            import os  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("sys" in imported_package_list):
            import sys  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("signal" in imported_package_list):
            import signal  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("stat" in imported_package_list):
            import stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("platform" in imported_package_list):
            import platform  # 加載Python原生的與平臺屬性有關的模組;
        if not("subprocess" in imported_package_list):
            import subprocess  # 加載Python原生的創建子進程模組;
        if not("string" in imported_package_list):
            import string  # 加載Python原生的字符串處理模組;
        if not("datetime" in imported_package_list):
            import datetime  # 加載Python原生的日期數據處理模組;
        if not("time" in imported_package_list):
            import time  # 加載Python原生的日期數據處理模組;
        if not("json" in imported_package_list):
            import json  # import the module of json. 加載Python原生的Json處理模組;
        if not("re" in imported_package_list):
            import re  # 加載Python原生的正則表達式對象
        if not("tempfile" in imported_package_list):
            import tempfile  # from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
        if not("pathlib" in imported_package_list):
            import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
        if not("shutil" in imported_package_list):
            import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
        if not("multiprocessing" in imported_package_list):
            import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
        if not("threading" in imported_package_list):
            import threading  # 加載Python原生的支持多綫程（執行緒）模組;
        if not("inspect" in imported_package_list):
            import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型，以及用於强制終止綫程;
        if not("ctypes" in imported_package_list):
            import ctypes  # 用於强制終止綫程;
        # if not("socketserver" in imported_package_list):
        #     import socketserver  # from socketserver import ThreadingMixIn  #, ForkingMixIn
        # if not("urllib" in imported_package_list):
        #     import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
        # if not("http.client" in imported_package_list):
        #     import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
        # if not("http.server" in imported_package_list):
        #     import http.server  # from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
        #     # https: // docs.python.org/3/library/http.server.html
        # if not("cookiejar" in imported_package_list):
        #     from http import cookiejar  # 用於處理請求Cookie;
        # if not("ssl" in imported_package_list):
        #     import ssl  # 用於處理請求證書驗證;
        if not("base64" in imported_package_list):
            import base64  # 加載加、解密模組;

        # # 檢查函數需要用到的 Python 第三方模組是否已經安裝成功(pip install)，如果還沒安裝，則執行安裝操作;
        # if "os" in dir(list):
        #     installed_package_list = os.popen("pip list").read()
        # if isinstance(installed_package_list, list) and not("Flask" in installed_package_list):
        #     os_popen_read = os.popen("pip install Flask --trusted-host -i https://pypi.tuna.tsinghua.edu.cn/simple").read()
        #     print(os_popen_read)

        # 配置預設值;
        self.is_monitor = False  # 預設不啓動看守進程監聽功能，只運行一輪就退出函數;
        self.is_Monitor_Concurrent = "0"  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：0、"0"、"Multi-Threading"、"Multi-Processes";
        # 用於輸入傳值的媒介目錄;
        # os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
        # os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
        self.monitor_dir = os.path.join(os.path.abspath(".."), "temp")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸入傳值的媒介目錄;
        # self.monitor_dir = pathlib.Path(os.path.abspath("..") + "/temp/")  # pathlib.Path("../temp/")
        # 用於接收傳值的媒介文檔;
        self.monitor_file = ""  # os.path.join(self.monitor_dir, "intermediary_write_Node.txt")  # "../temp/intermediary_write_Node.txt" 用於接收傳值的媒介文檔;
        # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
        self.read_file_do_Function = self.read_and_write_file_do_Function  # None 或類中預設的示例函數 self.read_and_write_file_do_Function;
        # 用於接收執行功能的函數;
        self.do_Function = self.temp_default_doFunction  # None 或匿名函數 lambda arguments:arguments，其中 lambda 表示聲明匿名函數， do_data 用於接收執行功能的函數;
        # 用於輸出傳值的媒介目錄;
        self.output_dir = os.path.join(os.path.abspath(".."), "temp")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
        # self.output_dir = pathlib.Path(os.path.abspath("..") + "/temp/")  # pathlib.Path("../temp/")
        # 用於輸出傳值的媒介文檔;
        self.output_file = os.path.join(self.output_dir, "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
        # 用於對返回數據執行功能的解釋器可執行文件;
        self.to_executable = ""  # os.path.join(os.path.abspath(".."), "NodeJS", "nodejs/node.exe")  # "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
        # 用於對返回數據執行功能的被調用的脚本文檔;
        self.to_script = ""  # os.path.join(os.path.abspath(".."), "js", "test.js")  # "../js/test.js" 用於對返回數據執行功能的被調用的脚本文檔;
        # 用於暫存輸入輸出傳值的媒介目錄;
        self.temp_cache_IO_data_dir = os.path.join(os.path.abspath(".."), "temp")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於暫存輸入輸出傳值的媒介目錄;
        # self.temp_cache_IO_data_dir = pathlib.Path(os.path.abspath("..") + "/temp/")  # pathlib.Path("../temp/")
        # 用於判斷監聽創建子進程池數目的參數;
        self.number_Worker_process = int(0)  # 子進程數目默認 0 個;
        # 用於監聽程序的輪詢延遲參數，單位（秒）;
        self.time_sleep = float(0.02)  # 預設延遲等待時長為 20 毫秒;

        if "monitor_file" in kwargs:
            self.monitor_file = str(kwargs["monitor_file"])

        if "monitor_dir" in kwargs:
            self.monitor_dir = str(kwargs["monitor_dir"])

        if "output_dir" in kwargs:
            self.output_dir = str(kwargs["output_dir"])

        if "output_file" in kwargs:
            self.output_file = str(kwargs["output_file"])

        if "to_executable" in kwargs:
            self.to_executable = str(kwargs["to_executable"])

        if "to_script" in kwargs:
            self.to_script = str(kwargs["to_script"])

        if "is_monitor" in kwargs:
            self.is_monitor = bool(kwargs["is_monitor"])

        if "is_Monitor_Concurrent" in kwargs:
            self.is_Monitor_Concurrent = str(kwargs["is_Monitor_Concurrent"])  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：0、"0"、"Multi-Threading"、"Multi-Processes";

        if "temp_cache_IO_data_dir" in kwargs:
            self.temp_cache_IO_data_dir = str(kwargs["temp_cache_IO_data_dir"])

        if "read_file_do_Function" in kwargs and inspect.isfunction(kwargs["read_file_do_Function"]):
            self.read_file_do_Function = kwargs["read_file_do_Function"]

        if "do_Function" in kwargs and inspect.isfunction(kwargs["do_Function"]):
            self.do_Function = kwargs["do_Function"]

        # 用於監聽程序的輪詢延遲參數，單位（秒） and isinstance(time_sleep, str);
        if "time_sleep" in kwargs:
            self.time_sleep = float(kwargs["time_sleep"])  # 延遲時長;

        # 用於判斷監聽創建子進程池數目的參數  and isinstance(number_Worker_process, str);
        if "number_Worker_process" in kwargs:
            self.number_Worker_process = int(kwargs["number_Worker_process"])  # 子進程數目默認 0 個;

        # 具體處理數據的函數;
        # self.do_Function = None
        if "do_Function_obj" in kwargs and isinstance(kwargs["do_Function_obj"], dict) and any(kwargs["do_Function_obj"]):
            # isinstance(do_Function_obj, dict) type(do_Function_obj) == dict do_Function_obj != {} any(do_Function_obj)
            for key in kwargs["do_Function_obj"]:
                # isinstance(do_Function_obj[key], FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                if key == "do_Function" and inspect.isfunction(kwargs["do_Function_obj"][key]):
                    self.do_Function = kwargs["do_Function_obj"][key]

        # 傳入處理完數據後的，輸出參數;
        # self.output_dir = ""
        # self.output_file = ""
        # self.to_executable = ""
        # self.to_script = ""
        if "return_obj" in kwargs and isinstance (kwargs["return_obj"], dict) and any(kwargs["return_obj"]):
            # isinstance(return_obj, dict) type(return_obj) == dict return_obj != {} any(return_obj)
            for key in kwargs["return_obj"]:
                # isinstance(return_obj[key], FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數;
                if key == "output_dir" and type(kwargs["return_obj"][key]) == str:
                    self.output_dir = kwargs["return_obj"][key]
                if key == "output_file" and type(kwargs["return_obj"][key]) == str:
                    self.output_file = kwargs["return_obj"][key]
                if key == "to_executable" and type(kwargs["return_obj"][key]) == str:
                    self.to_executable = kwargs["return_obj"][key]
                if key == "to_script" and type(kwargs["return_obj"][key]) == str:
                    self.to_script = kwargs["return_obj"][key]

        self.total_worker_called_number = {}  # 預設的全局變量，記錄每個進程被調用運算具體處理數據的纍加總次數
        # self.pool = None  # pool 進程池，函數 monitor_file_do_Function 中自定義創建的全局變量;

    # 預設的可能被推入子進程執行功能的函數，可以在類實例化的時候輸入參數修改;
    def temp_default_doFunction(self, arguments):
        return arguments

    # 自定義封裝的函數check_json_format(raw_msg)用於判斷是否為JSON格式的字符串;
    def check_json_format(self, raw_msg):
        """
        用於判斷一個字符串是否符合 JSON 格式
        :param self:
        :return:
        """
        if isinstance(raw_msg, str):  # 首先判斷傳入的參數是否為一個字符串，如果不是直接返回false值
            try:
                json.loads(raw_msg)  # , encoding='utf-8'
                return True
            except ValueError:
                return False
        else:
            return False

    # 進程池中的執行函數;
    def pool_func(self, read_file_do_Function, monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep):

        result_Array = [None, None, None]

        if monitor_file != "" and output_file != "":
            result_Array[0] = read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep)

        # result_Array.append(multiprocessing.current_process().pid)  # 推入該次調用子進程的 pid 號碼;
        # result_Array.append(threading.current_thread().ident)  # 推入該次調用子進程中執行緒的 id 號碼;
        result_Array[1] = multiprocessing.current_process().pid  # 推入該次調用子進程的 pid 號碼;
        result_Array[2] = threading.current_thread().ident  # 推入該次調用子進程中執行緒的 id 號碼;

        return result_Array

    # 子進程中的初始化預設值（默認值）配置函數;
    def initializer(self):
        """Ignore SIGINT in child workers. 忽略子進程中的信號."""
        # 忽略子進程中的信號，不然鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，會報 Traceback (most recent call last) 和 KeyboardInterrupt 的錯誤;
        signal.signal(signal.SIGINT, signal.SIG_IGN)  # 忽略子進程中的信號，不然鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，會報 Traceback (most recent call last) 和 KeyboardInterrupt 的錯誤;

    # 自定義的，進程池啓動子進程時用於引用的回調函數 apply_async_func_return = pool.apply_async(func=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), callback=cb)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
    def pool_call_back(self, apply_async_func_return):

        # if isinstance(apply_async_func_return, list):
        #     prcess_pid = int(apply_async_func_return[1])
        #     thread_ident = int(apply_async_func_return[2])

        #     # 記錄每個被調用的子進程的纍加總次數;
        #     if str(apply_async_func_return[1]) in self.total_worker_called_number:
        #         self.total_worker_called_number[str(apply_async_func_return[1])] = int(self.total_worker_called_number[str(apply_async_func_return[1])]) + int(1)
        #     else:
        #         self.total_worker_called_number[str(apply_async_func_return[1])] = int(1)

        #     result_Data = {
        #         "monitor_file": apply_async_func_return[0][2],
        #         "output_file": apply_async_func_return[0][1]
        #     }
        #     output_queues_array.append(result_Data)
        #     # print(output_queues_array)

        #     # multiprocessing.current_process().pid, multiprocessing.current_process().name, threading.current_thread().ident, threading.current_thread().getName()
        #     print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) + " process-" + str(prcess_pid) + " thread-" + str(thread_ident) + " " + str(result_Data["monitor_file"]) + " " + self.output_file)

        #     # result = apply_async_func_return[0][0],

        #     # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔 apply_async_func_return[0][2] == monitor_file;
        #     try:
        #         os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return[0][2] == monitor_file;
        #         # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
        #         # print(os.listdir(input_queues_array[0][monitor_dir]))
        #     except Exception as error:
        #         print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
        #         if("[WinError 32]" in str(error)):
        #             print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + result_Data["monitor_file"])
        #             time.sleep(time_sleep)
        #             try:
        #                 os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return[0][2] == monitor_file;
        #                 # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
        #                 # print(os.listdir(input_queues_array[0][monitor_dir]))
        #             except OSError as error:
        #                 print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
        #         # else:
        #         #     print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')

        #     # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
        #     if os.path.exists(result_Data["monitor_file"]) and os.path.isfile(result_Data["monitor_file"]):
        #         print("用於接收傳值的媒介文檔 [ " + result_Data["monitor_file"] + " ] 無法刪除.")
        #         # return result_Data["monitor_file"]

        # else:
        #     print("函數 read_file_do_Function() 從硬盤媒介文檔 [ " + apply_async_func_return[0][2] + " ] 讀取傳入數據并進行處理的過程出現錯誤.")

        return apply_async_func_return

    # 自定義的，進程池子進程運行出現異常時的回調函數;
    def error_pool_call_back(self, error):
        print(error)
        return error

    # 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
    def read_and_write_file_do_Function(self, monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep):
        # print("當前進程ID: ", multiprocessing.current_process().pid)
        # print("當前進程名稱: ", multiprocessing.current_process().name)
        # print("當前綫程ID: ", threading.current_thread().ident)
        # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
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
    
    # 監聽操作指定文件夾下的用於傳入數據的媒介文檔改名為暫存臨時傳入媒介文檔的子進程中執行函數;
    # def monitor_file_func(self, read_file_do_Function, monitor_file, monitor_dir, do_Function, temp_cache_IO_data_dir, output_dir, output_file, to_executable, to_script, time_sleep):
    def monitor_file_func(self, monitor_file, temp_cache_IO_data_dir, output_file, to_executable, to_script, time_sleep, input_file_NUM):
        # print("process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " ( name: " + str(threading.current_thread().name) + " )")

        # # 使用 Python 原生的多執行緒（綫程）支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
        # # 第一個參數 target=do_Function 是子執行緒（綫程）函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        # t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        # t.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        # t.start()  # 啓動子綫程;
        # # threading.Condition()

        # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
        # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        # p = multiprocessing.Process(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        # p.start()  # 啓動子進程;
        # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
        # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
        # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
        # # p.pid
        # # p.name
        # # p.ident
        # # p.sentinel

        result_Array = [None, None, None]

        # # 監聽文件夾，監測指定目錄下是否有新增或刪除文檔或文件夾的動作;
        # input_file_NUM = int(0)  # 監聽到的第幾次傳入媒介文檔;

        # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
        # 創建看守進程，監聽指定的用於傳入數據的媒介文檔是否已經被創建;
        while True:

            # 使用Python原生模組os判斷目錄或文檔是否存在;
            if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(monitor_file, os.R_OK) and os.access(monitor_file, os.W_OK)):
                    try:
                        os.chmod(monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
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

                monitor_file_creat_host = os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                monitor_file_creat_time = datetime.datetime.fromtimestamp(os.stat(monitor_file).st_atime).strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;
                # monitor_file_creat_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.stat(monitor_file).st_atime))

                input_file_NUM = int(input_file_NUM) + int(1)  # 監聽到的第幾次傳入媒介文檔增加一個;
                # 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                index_NUM = "_" + str(input_file_NUM)  # 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                if len(input_queues_array) > 0:
                    index_NUM = "_" + str(int(os.path.split(input_queues_array[int(int(len(input_queues_array)) - int(1))])[0].split("_")[1]) + int(1))  # 字符串切片函數 str.split(" ", num=string.count(str));

                temp_monitor_file = os.path.join(temp_cache_IO_data_dir + os.path.split(monitor_file)[1].split(os.path.splitext(monitor_file)[1])[0] + str(index_NUM) + os.path.splitext(monitor_file)[1])  # 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                # print(temp_monitor_file)
                temp_output_file = os.path.join(temp_cache_IO_data_dir + os.path.split(output_file)[1].split(os.path.splitext(output_file)[1])[0] + str(index_NUM) + os.path.splitext(output_file)[1])  # 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                # print(temp_output_file)

                # 判斷用於暫存接收和輸出傳值的臨時媒介文檔是否有重名的;
                file_bool = False
                try:
                    # 同步判斷，使用 Python 原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    file_bool = (os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file)) or (os.path.exists(temp_output_file) and os.path.isfile(temp_output_file))
                    # print("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.")
                except OSError as error:
                    print(f'Error: {temp_monitor_file} or {temp_output_file} : {error.strerror}')
                    print("用於暫存接收傳值的媒介文檔 [ " + temp_monitor_file + " 或用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否重名.")
                    return [temp_monitor_file, temp_output_file]

                while file_bool:
                    # print("用於暫存接收傳值的媒介文檔: " + temp_monitor_file + " 已經存在.")
                    input_file_NUM = int(input_file_NUM) + int(1)  # 監聽到的第幾次傳入媒介文檔增加一個;
                    # 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                    index_NUM = "_" + str(input_file_NUM)  # 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                    # if len(input_queues_array) > 0:
                    #     index_NUM = "_" + str(int(os.path.split(input_queues_array[int(int(len(input_queues_array)) - int(1))])[0].split("_")[1]) + int(1))  # 字符串切片函數 str.split(" ", num=string.count(str));

                    temp_monitor_file = os.path.join(temp_cache_IO_data_dir + os.path.split(monitor_file)[1].split(os.path.splitext(monitor_file)[1])[0] + str(index_NUM) + os.path.splitext(monitor_file)[1])  # 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                    # print(temp_monitor_file)
                    temp_output_file = os.path.join(temp_cache_IO_data_dir + os.path.split(output_file)[1].split(os.path.splitext(output_file)[1])[0] + str(index_NUM) + os.path.splitext(output_file)[1])  # 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                    # print(temp_output_file)

                    # 判斷用於接收傳值的臨時媒介文檔是否有重名的;
                    file_bool = False
                    try:
                        # 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = (os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file)) or (os.path.exists(temp_output_file) and os.path.isfile(temp_output_file))
                        # print("文檔: " + temp_monitor_file + " 存在.")# print("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.")
                    except OSError as error:
                        print(f'Error: {temp_monitor_file} or {temp_output_file} : {error.strerror}')
                        print("用於暫存接收傳值的媒介文檔 [ " + temp_monitor_file + " 或用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否存在.")
                        return [temp_monitor_file, temp_output_file]

                # # 判斷用於暫存輸出傳值的臨時媒介文檔是否有重名的;
                # file_bool = False
                # try:
                #     # 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                #     file_bool = os.path.exists(temp_output_file) and os.path.isfile(temp_output_file)
                #     # print("文檔: " + temp_output_file + " 存在.")
                # except OSError as error:
                #     print(f'Error: {temp_output_file} : {error.strerror}')
                #     print("用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否存在.")
                #     return temp_output_file

                # while file_bool:
                #     # print("用於暫存輸出傳值的媒介文檔: " + temp_output_file + " 已經存在.")
                #     input_file_NUM = int(input_file_NUM) + int(1)  # 監聽到的第幾次傳入媒介文檔增加一個;
                #     # 同步移動文檔，將用於傳出數據的媒介文檔 output_file 從媒介文件夾 output_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                #     index_NUM = "_" + str(input_file_NUM)  # 傳出數據的臨時暫存文檔 temp_output_file 的序號尾;
                #     # if len(input_queues_array) > 0:
                #     #     index_NUM = "_" + str(int(os.path.split(input_queues_array[int(int(len(input_queues_array)) - int(1))])[0].split("_")[1]) + int(1))  # 字符串切片函數 str.split(" ", num=string.count(str));

                #     temp_monitor_file = os.path.join(temp_cache_IO_data_dir + os.path.split(monitor_file)[1].split(os.path.splitext(monitor_file)[1])[0] + str(index_NUM) + os.path.splitext(monitor_file)[1])  # 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                #     # print(temp_monitor_file)
                #     temp_output_file = os.path.join(temp_cache_IO_data_dir + os.path.split(output_file)[1].split(os.path.splitext(output_file)[1])[0] + str(index_NUM) + os.path.splitext(output_file)[1])  # 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                #     # print(temp_output_file)

                #     # 判斷用於輸出傳值的臨時媒介文檔是否有重名的;
                #     file_bool = False
                #     try:
                #         # 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                #         file_bool = os.path.exists(temp_output_file) and os.path.isfile(temp_output_file)
                #         # print("文檔: " + temp_output_file + " 存在.")
                #     except OSError as error:
                #         print(f'Error: {temp_output_file} : {error.strerror}')
                #         print("用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否存在.")
                #         return temp_output_file

                # 將指定用於傳入數據的媒介文檔，改名為臨時暫存傳入數據的媒介文檔;
                try:                    
                    os.rename(monitor_file, temp_monitor_file)  # 移動或重命名文檔;
                    # 函數 shutil.move(src, dst) 不好用;
                except Exception as error:
                    # print(f'Error: {monitor_file} : {error.strerror}')
                    # print("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file)
                    # "[Errno 13] Permission denied" in str(error)
                    if("[WinError 32]" in str(error)):
                        # print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試將文檔 " + monitor_file + " 移動更名為: " + temp_monitor_file)
                        time.sleep(time_sleep)
                        try:
                            os.rename(monitor_file, temp_monitor_file)  # 移動或重命名文檔;
                            # 函數 shutil.move(src, dst) 不好用;
                        except OSError as error:
                            print(f'Error: {monitor_file} : {error.strerror}')
                            print("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file)
                            # return monitor_file
                    else:
                        print(f'Error: {monitor_file} : {error.strerror}')
                        print("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file)
                        # return monitor_file


                # 使用Python原生模組os判斷指定的用於暫存輸入輸出數據的暫存媒介文檔，是否創建成功，如果已經被創建，則為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
                if os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file):
                    # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                    if not (os.access(temp_monitor_file, os.R_OK) and os.access(temp_monitor_file, os.W_OK)):
                        try:
                            os.chmod(temp_monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                            # os.chmod(temp_monitor_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                            # os.chmod(temp_monitor_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                            # os.chmod(temp_monitor_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                            # os.chmod(temp_monitor_file, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                            print(f'Error: {temp_monitor_file} : {error.strerror}')
                            print("用於暫存接收傳值的媒介文檔 [ " + temp_monitor_file + " ] 無法修改為可讀可寫權限.")
                            # return temp_monitor_file
                else:
                    # 如果指定創建的臨時文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                    print("用於暫存輸入傳值的媒介文檔 [ " + temp_monitor_file + " ] 無法創建.")
                    # return temp_monitor_file

                # 使用Python原生模組os判斷用於輸入數據的媒介文檔，是否已經被刪除，如果仍然存在則報錯退出;
                if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
                    # 如果指定創建的臨時文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                    print("用於輸入傳值的媒介文檔 [ " + monitor_file + " ] 無法被刪除.")
                    # return monitor_file

                # 將新讀入的數據，推入待命任務隊列數組
                if os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file) and os.access(temp_monitor_file, os.R_OK) and os.access(temp_monitor_file, os.W_OK):

                    worker_Data = {
                        # "read_file_do_Function": read_file_do_Function,
                        "monitor_file": temp_monitor_file,  # monitor_file;
                        "monitor_dir": temp_cache_IO_data_dir,  # monitor_dir;
                        # "do_Function": do_Function,  # do_Function_obj["do_Function"];
                        "output_dir": temp_cache_IO_data_dir,  # output_dir;
                        "output_file": temp_output_file,  # output_file，output_queues_array;
                        "to_executable": to_executable,
                        "to_script": to_script,
                        "monitor_file_creat_host": monitor_file_creat_host,
                        "monitor_file_creat_time": monitor_file_creat_time,
                    }

                    input_queues_array.append(worker_Data)  # 推入待處理隊列;

                    # # 使用 Python 原生的多執行緒（綫程）支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
                    # # 第一個參數 target=do_Function 是子執行緒（綫程）函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                    # t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
                    # t.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    # t.start()  # 啓動子綫程;
                    # # threading.Condition()

                    # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
                    # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                    # p = multiprocessing.Process(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
                    # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    # p.start()  # 啓動子進程;
                    # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
                    # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
                    # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
                    # # p.pid
                    # # p.name
                    # # p.ident
                    # # p.sentinel

            time.sleep(time_sleep)

        result_Array[0] = input_queues_array
        # result_Array.append(multiprocessing.current_process().pid)  # 推入該次調用子進程的 pid 號碼;
        # result_Array.append(threading.current_thread().ident)  # 推入該次調用子進程中執行緒的 id 號碼;
        result_Array[1] = multiprocessing.current_process().pid  # 推入該次調用子進程的 pid 號碼;
        result_Array[2] = threading.current_thread().ident  # 推入該次調用子進程中執行緒的 id 號碼;

        return result_Array

    # 監聽操作具體計算傳入數據的臨時媒介文檔中的數據並生成臨時的用於傳出數據的媒介文檔的子進程中執行函數;
    # def monitor_input_queues_func(self, read_file_do_Function, monitor_file, monitor_dir, do_Function, temp_cache_IO_data_dir, output_dir, output_file, to_executable, to_script, time_sleep):
    def monitor_input_queues_func(self, read_file_do_Function, do_Function, output_file, time_sleep, pool_func, pool_call_back, error_pool_call_back, number_Worker_process, process_Pool, total_worker_called_number):
        # print("process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " ( name: " + str(threading.current_thread().name) + " )")

        # # 使用 Python 原生的多執行緒（綫程）支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
        # # 第一個參數 target=do_Function 是子執行緒（綫程）函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        # t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        # t.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        # t.start()  # 啓動子綫程;
        # # threading.Condition()

        # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
        # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        # p = multiprocessing.Process(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        # p.start()  # 啓動子進程;
        # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
        # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
        # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
        # # p.pid
        # # p.name
        # # p.ident
        # # p.sentinel

        result_Array = [None, None, None]

        # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
        # 創建看守進程，監聽指定的用於傳入數據的媒介文檔是否已經被創建;
        while True:

            # 監聽待處理任務隊列數組 input_queues_array 和 空閑子綫程隊列 worker_free，當有待處理任務等待時，且有空閑子進程時，將待任務隊列中排在前面的第一個待處理任務，推入一個空閑子進程;
            if len(input_queues_array) > 0:

                # 判斷傳入的等待處理的參數 JSON 對象的合法性;
                if not(isinstance(input_queues_array[0], dict)) or input_queues_array[0]["monitor_file"] == None or not(os.path.exists(input_queues_array[0]["monitor_file"]) and os.path.isfile(input_queues_array[0]["monitor_file"])):
                    print("傳入的等待處理的參數 JSON 對象無法識別: " + input_queues_array[0])
                    temp = input_queues_array[0]
                    del input_queues_array[0]
                    return temp

                if number_Worker_process > 0 and process_Pool != None:

                    # 將監聽到待處理的文檔信息推入進程池
                    # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
                    # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                    # p = multiprocessing.Process(target=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), kwds={}, name=None, daemon=True)
                    # # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    # p.start()  # 啓動子進程;
                    # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
                    # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
                    # # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
                    # # p.pid
                    # # p.name
                    # # p.ident
                    # # p.sentinel
                    # worker_queues[str(p.pid)] = p
                    # worker_free[str(p.pid)] = True
                    # total_worker_called_number[str(p.pid)] = int(0)

                    monitor_file_creat_host = input_queues_array[0]["monitor_file_creat_host"]  # os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                    monitor_file_creat_time = input_queues_array[0]["monitor_file_creat_time"]  # os.stat(monitor_file).st_atime.strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;

                    # print(input_queues_array[0])
                    # 函數 process_Pool.apply_async(func=, args=(,), kwds={}, callback=, error_callback=) 中的執行函數 func 和 callback 只能接受最外層的函數，不能是嵌套的内層函數;
                    apply_async_func_return = process_Pool.apply_async(func=pool_func, args=(read_file_do_Function, input_queues_array[0]["monitor_file"], input_queues_array[0]["monitor_dir"], do_Function, input_queues_array[0]["output_dir"], input_queues_array[0]["output_file"], input_queues_array[0]["to_executable"], input_queues_array[0]["to_script"], time_sleep), kwds={}, callback=pool_call_back, error_callback=error_pool_call_back)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
                    # input_queues_array[0] == {
                    #     # "read_file_do_Function": read_file_do_Function,
                    #     "monitor_file": temp_monitor_file,  # monitor_file;
                    #     "monitor_dir": temp_cache_IO_data_dir,  # monitor_dir;
                    #     # "do_Function": do_Function,  # do_Function_obj["do_Function"];
                    #     "output_dir": temp_cache_IO_data_dir,  # output_dir;
                    #     "output_file": temp_output_file,  # output_file，output_queues_array;
                    #     "to_executable": to_executable,
                    #     "to_script": to_script,
                    #     "monitor_file_creat_host": monitor_file_creat_host,
                    #     "monitor_file_creat_time": monitor_file_creat_time
                    # }
                    # args == (
                    #     read_file_do_Function,
                    #     input_queues_array[0]["monitor_file"],
                    #     input_queues_array[0]["monitor_dir"],
                    #     do_Function,
                    #     input_queues_array[0]["output_dir"],
                    #     input_queues_array[0]["output_file"],
                    #     input_queues_array[0]["to_executable"],
                    #     input_queues_array[0]["to_script"],
                    #     time_sleep
                    # )
                    # print(apply_async_func_return.get(timeout=None))
                    # print(apply_async_func_return.ready())
                    # print(apply_async_func_return.successful())

                    del input_queues_array[0]

                    if isinstance(apply_async_func_return.get(timeout=None), list):

                        prcess_pid = int(apply_async_func_return.get(timeout=None)[1])
                        thread_ident = int(apply_async_func_return.get(timeout=None)[2])

                        # 記錄每個被調用的子進程的纍加總次數;
                        if str(prcess_pid) in total_worker_called_number:
                            total_worker_called_number[str(prcess_pid)] = int(total_worker_called_number[str(prcess_pid)]) + int(1)
                        else:
                            total_worker_called_number[str(prcess_pid)] = int(1)

                        result_Data = {
                            "monitor_file": apply_async_func_return.get(timeout=None)[0][2],
                            "output_file": apply_async_func_return.get(timeout=None)[0][1]
                        }
                        output_queues_array.append(result_Data)
                        # print(output_queues_array)

                        # multiprocessing.current_process().pid, multiprocessing.current_process().name, threading.current_thread().ident, threading.current_thread().getName()
                        print(str(monitor_file_creat_host) + " " + str(monitor_file_creat_time) + " process-" + str(prcess_pid) + " thread-" + str(thread_ident) + " " + result_Data["monitor_file"] + " " + output_file)
                        # print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) + " process-" + str(prcess_pid) + " thread-" + str(thread_ident) + " " + result_Data["monitor_file"] + " " + output_file)

                        # result = apply_async_func_return.get(timeout=None)[0][0],

                        # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔 apply_async_func_return.get(timeout=None)[0][2] == monitor_file;
                        try:
                            os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[0][2] == monitor_file;
                            # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                            # print(os.listdir(input_queues_array[0][monitor_dir]))
                        except Exception as error:
                            print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                            if("[WinError 32]" in str(error)):
                                print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + result_Data["monitor_file"])
                                time.sleep(time_sleep)
                                try:
                                    os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[0][2] == monitor_file;
                                    # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                                    # print(os.listdir(input_queues_array[0][monitor_dir]))
                                except OSError as error:
                                    print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                            # else:
                            #     print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')

                        # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                        if os.path.exists(result_Data["monitor_file"]) and os.path.isfile(result_Data["monitor_file"]):
                            print("用於接收傳值的媒介文檔 [ " + result_Data["monitor_file"] + " ] 無法刪除.")
                            # return result_Data["monitor_file"]

                    else:
                        print("函數 read_file_do_Function() 從硬盤媒介文檔 [ " + apply_async_func_return.get(timeout=None)[0][2] + " ] 讀取傳入數據并進行處理的過程出現錯誤.")
                        # return apply_async_func_return

                if number_Worker_process <= 0 or process_Pool == None:

                    monitor_file_creat_host = input_queues_array[0]["monitor_file_creat_host"]  # os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                    monitor_file_creat_time = input_queues_array[0]["monitor_file_creat_time"]  # os.stat(monitor_file).st_atime.strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;

                    # multiprocessing.current_process().pid, multiprocessing.current_process().name, threading.current_thread().ident, threading.current_thread().getName()
                    print(str(monitor_file_creat_host) + " " + str(monitor_file_creat_time) + " process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " " + input_queues_array[0]["monitor_file"] + " " + output_file)
                    # print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) + " process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " " + input_queues_array[0]["monitor_file"] + " " + output_file)

                    prcess_pid = multiprocessing.current_process().pid
                    thread_ident = threading.current_thread().ident

                    # 記錄每個被調用的子進程的纍加總次數;
                    if str(prcess_pid) in total_worker_called_number:
                        total_worker_called_number[str(prcess_pid)] = int(total_worker_called_number[str(prcess_pid)]) + int(1)
                    else:
                        total_worker_called_number[str(prcess_pid)] = int(1)

                    # print(input_queues_array[0])
                    result_arr = read_file_do_Function(input_queues_array[0]["monitor_file"], input_queues_array[0]["monitor_dir"], do_Function, input_queues_array[0]["output_dir"], input_queues_array[0]["output_file"], input_queues_array[0]["to_executable"], input_queues_array[0]["to_script"], time_sleep)
                    # print(result_arr)
                    # input_queues_array[0] == {
                    #     # "read_file_do_Function": read_file_do_Function,
                    #     "monitor_file": temp_monitor_file,  # monitor_file;
                    #     "monitor_dir": temp_cache_IO_data_dir,  # monitor_dir;
                    #     # "do_Function": do_Function,  # do_Function_obj["do_Function"];
                    #     "output_dir": temp_cache_IO_data_dir,  # output_dir;
                    #     "output_file": temp_output_file,  # output_file，output_queues_array;
                    #     "to_executable": to_executable,
                    #     "to_script": to_script
                    # }

                    del input_queues_array[0]

                    # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
                    # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                    # p = multiprocessing.Process(target=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), kwds={}, name=None, daemon=True)
                    # # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    # p.start()  # 啓動子進程;
                    # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
                    # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
                    # # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
                    # # p.pid
                    # # p.name
                    # # p.ident
                    # # p.sentinel
                    # worker_queues[str(p.pid)] = p
                    # worker_free[str(p.pid)] = True
                    # total_worker_called_number[str(p.pid)] = int(0)

                    if isinstance(result_arr, tuple):

                        result_Data = {
                            "monitor_file": result_arr[2],
                            "output_file": result_arr[1]
                        }
                        output_queues_array.append(result_Data)
                        # print(output_queues_array)

                        # result = result_arr[0]

                        # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔 apply_async_func_return.get(timeout=None)[2] == monitor_file;
                        try:
                            os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[2] == monitor_file;
                            # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                            # print(os.listdir(input_queues_array[0][monitor_dir]))
                        except Exception as error:
                            print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                            if("[WinError 32]" in str(error)):
                                print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + result_Data["monitor_file"])
                                time.sleep(time_sleep)
                                try:
                                    os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[2] == monitor_file;
                                    # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                                    # print(os.listdir(input_queues_array[0][monitor_dir]))
                                except OSError as error:
                                    print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                            else:
                                print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')

                        # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                        if os.path.exists(result_Data["monitor_file"]) and os.path.isfile(result_Data["monitor_file"]):
                            print("用於暫存接收傳值的臨時媒介文檔 [ " + result_Data["monitor_file"] + " ] 無法刪除.")
                            # return result_Data["monitor_file"]

                    else:
                        print("函數 read_file_do_Function() 從硬盤媒介文檔 [ " + result_arr[2] + " ] 讀取傳入數據并進行處理的過程出現錯誤.")
                        # return result_arr

            time.sleep(time_sleep)

        result_Array[0] = output_queues_array
        # result_Array.append(multiprocessing.current_process().pid)  # 推入該次調用子進程的 pid 號碼;
        # result_Array.append(threading.current_thread().ident)  # 推入該次調用子進程中執行緒的 id 號碼;
        result_Array[1] = multiprocessing.current_process().pid  # 推入該次調用子進程的 pid 號碼;
        result_Array[2] = threading.current_thread().ident  # 推入該次調用子進程中執行緒的 id 號碼;

        return result_Array

    # 監聽操作傳出數據的臨時媒介文檔改名移位為正式傳出數據的媒介文檔的子進程中執行函數;
    # def monitor_output_queues_func(self, read_file_do_Function, monitor_file, monitor_dir, do_Function, temp_cache_IO_data_dir, output_dir, output_file, to_executable, to_script, time_sleep):
    def monitor_output_queues_func(self, monitor_file, monitor_dir, output_dir, output_file, to_executable, to_script, time_sleep):
        # print("process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " ( name: " + str(threading.current_thread().name) + " )")

        # # 使用 Python 原生的多執行緒（綫程）支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
        # # 第一個參數 target=do_Function 是子執行緒（綫程）函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        # t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        # t.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        # t.start()  # 啓動子綫程;
        # # threading.Condition()

        # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
        # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        # p = multiprocessing.Process(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        # p.start()  # 啓動子進程;
        # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
        # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
        # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
        # # p.pid
        # # p.name
        # # p.ident
        # # p.sentinel

        result_Array = [None, None, None]

        # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
        # 創建看守進程，監聽指定的用於傳入數據的媒介文檔是否已經被創建;
        while True:

            # 監聽待傳出數據結果隊列數組 output_queues_array，當有用於傳出數據的媒介目錄 output_dir 中不在含有 output_file 時，將待傳出數據結果隊列數組 output_queues_array 中排在前面的第一個結果文檔，更名移人用於傳出數據的媒介目錄 output_dir 中;
            if len(output_queues_array) > 0:

                # 判斷傳入的等待寫入用於傳出數據的媒介文檔的參數 JSON 對象的合法性;
                if isinstance(output_queues_array[0], dict) and output_queues_array[0]["output_file"] != None and os.path.exists(output_queues_array[0]["output_file"]) and os.path.isfile(output_queues_array[0]["output_file"]):
                    # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                    if not (os.access(output_queues_array[0]["output_file"], os.R_OK) and os.access(output_queues_array[0]["output_file"], os.W_OK)):
                        try:
                            os.chmod(output_queues_array[0]["output_file"], stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                            # os.chmod(output_queues_array[0]["output_file"], stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                            # os.chmod(output_queues_array[0]["output_file"], stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                            # os.chmod(output_queues_array[0]["output_file"], stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                            # os.chmod(output_queues_array[0]["output_file"], stat.S_IWOTH)  # 可被其它用戶寫入;
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
                            print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                            print("用於暫存輸出傳值的臨時媒介文檔 [ " + output_queues_array[0]["output_file"] + " ] 無法修改為可讀可寫權限.")
                            temp = output_queues_array[0]
                            del output_queues_array[0]
                            # return temp["output_file"]
                else:
                    print("用於傳出數據的暫存媒介文檔隊列中的: " + output_queues_array[0]["output_file"] + " 不存在.")
                    temp = output_queues_array[0]
                    del output_queues_array[0]
                    # return temp

                # 判斷如果指定的用於輸出的正式媒介文檔不存在，則將用於傳出數據的臨時媒介文檔改名為指定的正式傳出媒介文檔;
                if not (os.path.exists(output_file) and os.path.isfile(output_file)):

                    # 將用於傳出數據的臨時媒介文檔改名為指定的正式傳出媒介文檔;
                    try:
                        os.rename(output_queues_array[0]["output_file"], output_file)  # 移動或重命名文檔;
                        # 函數 shutil.move(src, dst) 不好用;
                        del output_queues_array[0]
                    except Exception as error:
                        print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                        print("用於暫存傳出數據的臨時媒介文檔: " + output_queues_array[0]["output_file"] + " 無法移動更名為指定的正式傳出媒介文檔: " + output_file)
                        # "[Errno 13] Permission denied" in str(error)
                        if("[WinError 32]" in str(error)):
                            print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試將文檔 " + output_queues_array[0]["output_file"] + " 移動更名為: " + output_file)
                            time.sleep(time_sleep)
                            try:
                                os.rename(output_queues_array[0]["output_file"], output_file)  # 移動或重命名文檔;
                                # 函數 shutil.move(src, dst) 不好用;
                            except OSError as error:
                                print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                                print("用於暫存傳出數據的臨時媒介文檔: " + output_queues_array[0]["output_file"] + " 無法移動更名為指定的正式傳出媒介文檔: " + output_file)
                                # "[Errno 13] Permission denied" in str(error)
                                # temp = output_queues_array[0]
                                # del output_queues_array[0]
                                # return temp["output_file"]
                        else:
                            temp = output_queues_array[0]
                            # del output_queues_array[0]
                            # return temp["output_file"]

                    # 使用Python原生模組os判斷指定的用於輸出數據的媒介文檔，是否創建成功，如果已經被創建，則為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
                    if os.path.exists(output_file) and os.path.isfile(output_file):
                        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                        if not (os.access(output_file, os.R_OK) and os.access(output_file, os.W_OK)):
                            try:
                                os.chmod(output_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
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
                                print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.")
                                # del output_queues_array[0]
                                # return output_file

                        # 運算處理完之後，給調用語言的回復，os.access(to_script, os.X_OK) 判斷脚本文檔是否具有被執行權限;
                        if type(to_executable) == str and to_executable != "" and os.path.exists(to_executable) and os.path.isfile(to_executable) and os.access(to_executable, os.X_OK):
                            if type(to_script) == str and to_script != "" and os.path.exists(to_script) and os.path.isfile(to_script):
                                # node  環境;
                                # test.js  待執行的JS的檔;
                                # %s %s  傳遞給JS檔的參數;
                                # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
                                shell_to = os.popen('%s %s %s %s %s %s' % (to_executable, to_script, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;
                                # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
                                # let arg1 = process.argv[2];  // 解析出JS參數;
                                # let arg2 = process.argv[3];
                            else:
                                shell_to = os.popen('%s %s %s %s %s' % (to_executable, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;

                            # print(shell_to.readlines());
                            response = shell_to.read()  # 取出執行結果
                            # print(response)

                    # else:
                    #     # 如果指定創建的傳出數據的媒介文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                    #     print(f'Error: {output_file} : {error.strerror}')
                    #     print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 無法創建.")
                    #     temp = output_queues_array[0]
                    #     del output_queues_array[0]
                    #     return temp["output_file"]

                    # # 使用Python原生模組os判斷用於暫存數據的臨時輸出媒介文檔，是否已經被刪除，如果仍然存在則報錯退出;
                    # if os.path.exists(output_queues_array[0]["output_file"]) and os.path.isfile(output_queues_array[0]["output_file"]):
                    #     # 如果指定創建的臨時文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                    #     print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                    #     print("用於暫存傳出數據的臨時媒介文檔 [ " + output_queues_array[0]["output_file"] + " ] 無法被刪除.")
                    #     # temp = output_queues_array[0]
                    #     # del output_queues_array[0]
                    #     # return temp["output_file"]

            time.sleep(time_sleep)

        result_Array[0] = output_file
        # result_Array.append(multiprocessing.current_process().pid)  # 推入該次調用子進程的 pid 號碼;
        # result_Array.append(threading.current_thread().ident)  # 推入該次調用子進程中執行緒的 id 號碼;
        result_Array[1] = multiprocessing.current_process().pid  # 推入該次調用子進程的 pid 號碼;
        result_Array[2] = threading.current_thread().ident  # 推入該次調用子進程中執行緒的 id 號碼;

        return result_Array

    # 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
    def monitor_file_do_Function(self, read_file_do_Function, monitor_file, monitor_dir, do_Function, number_Worker_process, temp_cache_IO_data_dir, output_dir, output_file, to_executable, to_script, time_sleep, total_worker_called_number, pool_func, initializer, pool_call_back, error_pool_call_back, is_Monitor_Concurrent, monitor_file_func, monitor_input_queues_func, monitor_output_queues_func, Monitor_Concurrent_process_Pool):
        # print("當前進程ID: ", multiprocessing.current_process().pid)
        # print("當前進程名稱: ", multiprocessing.current_process().name)
        # print("當前綫程ID: ", threading.current_thread().ident)
        # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
        if monitor_dir == "" or monitor_file == "" or monitor_file.find(monitor_dir, 0, int(len(monitor_file)-1)) == -1 or output_dir == "" or output_file == "" or output_file.find(output_dir, 0, int(len(output_file)-1)) == -1:
            return (monitor_dir, monitor_file, output_dir, output_file)

        # 用於監聽程序的輪詢延遲參數，單位（秒）;
        if time_sleep != None and time_sleep != "" and isinstance(time_sleep, str):
            time_sleep = float(time_sleep)  # 延遲時長單位秒;

        # 用於判斷監聽創建子進程池數目的參數;
        if number_Worker_process != None and number_Worker_process != "" and isinstance(number_Worker_process, str):
            number_Worker_process = int(number_Worker_process)  # 子進程數目默認 0 個;

        # 使用Python原生模組os判斷指定的用於傳入數據的媒介目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir():
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(monitor_dir, os.R_OK) and os.access(monitor_dir, os.W_OK)):
                try:
                    os.chmod(monitor_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
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
                    print("用於傳值的媒介文件夾 [ " + monitor_dir + " ] 無法修改為可讀可寫權限.")
                    return monitor_dir
        else:
            try:
                # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                os.makedirs(monitor_dir, mode=0o777, exist_ok=True)  # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
            except FileExistsError as error:
                # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
                print("用於傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
                print(f'Error: {monitor_dir} : {error.strerror}')
                return monitor_dir

        if not (os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir()):
            print(f'Error: {monitor_dir} : {error.strerror}')
            print("用於傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
            return monitor_dir
            
        # 使用Python原生模組os判斷指定的用於輸出數據的媒介目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
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

        # 使用Python原生模組os判斷指定的用於暫存輸入輸出數據文檔的媒介目錄，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if os.path.exists(temp_cache_IO_data_dir) and pathlib.Path(temp_cache_IO_data_dir).is_dir():
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(temp_cache_IO_data_dir, os.R_OK) and os.access(temp_cache_IO_data_dir, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(temp_cache_IO_data_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(temp_cache_IO_data_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(temp_cache_IO_data_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(temp_cache_IO_data_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(temp_cache_IO_data_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                    print(f'Error: {temp_cache_IO_data_dir} : {error.strerror}')
                    print("用於暫存輸入輸出傳值文檔的媒介文件夾 [ " + temp_cache_IO_data_dir + " ] 無法修改為可讀可寫權限.")
                    return temp_cache_IO_data_dir
        else:
            try:
                # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
                os.makedirs(temp_cache_IO_data_dir, mode=0o777, exist_ok=True)
            except FileExistsError as error:
                # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
                print(f'Error: {temp_cache_IO_data_dir} : {error.strerror}')
                print("用於暫存輸入輸出傳值文檔的媒介文件夾 [ " + temp_cache_IO_data_dir + " ] 無法創建.")
                return temp_cache_IO_data_dir

        if not (os.path.exists(temp_cache_IO_data_dir) and pathlib.Path(temp_cache_IO_data_dir).is_dir()):
            print(f'Error: {temp_cache_IO_data_dir} : {error.strerror}')
            print("用於暫存輸入輸出傳值文檔的媒介文件夾 [ " + temp_cache_IO_data_dir + " ] 無法創建.")
            return temp_cache_IO_data_dir


        # 綫程（執行緒）池操作
        # import threading
        # import time 
        # class Concur(threading.Thread):
        #     def __init__(self):
        #         super(Concur, self).__init__()
        #         self.iterations = 0
        #         self.daemon = True  # Allow main to exit even if still running.
        #         self.paused = True  # Start out paused.
        #         self.state = threading.Condition()
 
        #     def run(self):
        #         while True:
        #             with self.state:  # 在該條件下操作
        #                 plt.figure(figsize=(4, 4))  # 一些操作
        #                 plt.ion()
        #                 plt.axis('off')  # 不需要坐標軸
        #                 plt.imshow(self._img_qr)
        #                 while self._pause:
        #                     plt.pause(0.05)
        #                 plt.ioff()  # 必須和plt.ion()配合使用，如果不加ioff會出問題
 
        #                 if self.paused:
        #                     self.state.wait()  # Block execution until notified.
 
        #     def resume(self):  # 用來恢復/啟動run
        #         with self.state:  # 在該條件下操作
        #             self.paused = False
        #             self.state.notify()  # Unblock self if waiting.
 
        #     def pause(self):  # 用來暫停run
        #         with self.state:  # 在該條件下操作
        #             self.paused = True  # Block self.
        
        global input_queues_array, output_queues_array  # total_worker_called_number

        input_queues_array = []  # 待處理傳入的暫存媒介文檔名隊列列表;
        output_queues_array = []  # 已經處理完畢待改名為指定的傳出媒介文檔的暫存媒介文檔名隊列列表;

        # 監聽文件夾，監測指定目錄下是否有新增或刪除文檔或文件夾的動作;
        input_file_NUM = int(0)  # 監聽到的第幾次傳入媒介文檔;

        # 創建執行具體的讀寫動作的函數的子進程池;
        process_Pool = None
        if number_Worker_process > 0:
            try:
                # start number_Worker_process worker processes, number_Worker_process = os.cpu_count();
                print("Master process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " create process pool with spawning " + str(number_Worker_process) + " Worker process ...")
                process_Pool = multiprocessing.Pool(processes=number_Worker_process, initializer=initializer, initargs=(), maxtasksperchild=None)
                # 創建進程池，使用 Pool 類執行提交給它的任務，注意要設置參數 initializer，配置爲等於自定義的初始化函數 initializer()，作用是消除鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，子進程被終止的報錯信息;
                # class multiprocessing.Pool([processes[, initializer[, initargs[, maxtasksperchild[, context]]]]])
                #     一個進程池物件，它控制可以提交作業的工作進程池。它支援帶有超時和回檔的非同步結果，以及一個並行的 map 實現;
                #     processes 是要使用的工作進程數目。如果 processes 為 None，則使用 os.cpu_count() 返回的值;
                #     如果 initializer 不為 None，則每個工作進程將會在啟動時調用 initializer(*initargs);
                #     maxtasksperchild 是一個工作進程在它退出或被一個新的工作進程代替之前能完成的任務數量，為了釋放未使用的資源。預設的 maxtasksperchild 是 None，意味著工作進程壽與池齊;
                #     context 可被用於指定啟動的工作進程的上下文。通常一個進程池是使用函數 multiprocessing.Pool() 或者一個上下文物件的 Pool() 方法創建的。在這兩種情況下， context 都是適當設置的;
                # 注意，進程池物件的方法只有創建它的進程能夠調用;
                # 備註 通常來說，Pool 中的 Worker 進程的生命週期和進程池的工作隊列一樣長。一些其他系統中（如 Apache, mod_wsgi 等）也可以發現另一種模式，他們會讓工作進程在完成一些任務後退出，清理、釋放資源，然後啟動一個新的進程代替舊的工作進程。 Pool 的 maxtasksperchild 參數給用戶提供了這種能力;
                # class multiprocessing.pool.AsyncResult
                #     Pool.apply_async() 和 Pool.map_async() 返回對象所屬的類;
                #     get([timeout])
                #         用於獲取執行結果。如果 timeout 不是 None 並且在 timeout 秒內仍然沒有執行完得到結果，則拋出 multiprocessing.TimeoutError 異常。如果遠端調用發生異常，這個異常會通過 get() 重新拋出。
                #     wait([timeout])
                #         阻塞，直到返回結果，或者 timeout 秒後超時。
                #     ready()
                #         用於判斷執行狀態，是否已經完成。
                #     successful()
                #         Return whether the call completed without raising an exception. Will raise AssertionError if the result is not ready.

                # # 推入函數在進程池中啓動一個子進程，process_Pool.apply(func=, args=(,), kwds={})，同步函數會阻塞主進程直到返回結果，其中的執行函數 func 只能接受最外層的函數，不能是嵌套的内層函數;
                # apply_func_return = process_Pool.apply(func=pool_func, args=(read_file_do_Function, "", "", do_Function, "", "", "", "", time_sleep), kwds={})  # 同步函數，會阻塞主進程等待直到返回結果;
                # # print(apply_func_return)
                # if isinstance(apply_func_return, list):
                #     prcess_pid = int(apply_func_return[1])
                #     thread_ident = int(apply_func_return[2])
                #     # 記錄每個被調用的子進程的纍加總次數;
                #     if str(apply_func_return[1]) in total_worker_called_number:
                #         print(total_worker_called_number)
                #         # total_worker_called_number[str(apply_func_return[1])] = int(total_worker_called_number[str(apply_func_return[1])]) + int(1)
                #     else:
                #         total_worker_called_number[str(apply_func_return[1])] = int(0)
                # process_Pool.close()
                # process_Pool.join()
                # process_Pool.terminate()
            except Exception as error:
                print(error)

        # # 創建監聽目標文檔並對其改名操作的子進程池;
        # Monitor_Concurrent_process_Pool = None
        # # is_Monitor_Concurrent = ""  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：0、"0"、"Multi-Threading"、"Multi-Processes";
        # if is_Monitor_Concurrent == "Multi-Threading":
        #     try:
        #         # start number_Worker_process worker processes, number_Worker_process = os.cpu_count();
        #         print("Master process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " create process pool with spawning 3 Worker process ...")
        #         Monitor_Concurrent_process_Pool = multiprocessing.Pool(processes=int(3), initializer=initializer, initargs=(), maxtasksperchild=None)
        #         # 創建進程池，使用 Pool 類執行提交給它的任務，注意要設置參數 initializer，配置爲等於自定義的初始化函數 initializer()，作用是消除鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，子進程被終止的報錯信息;
        #         # class multiprocessing.Pool([processes[, initializer[, initargs[, maxtasksperchild[, context]]]]])
        #         #     一個進程池物件，它控制可以提交作業的工作進程池。它支援帶有超時和回檔的非同步結果，以及一個並行的 map 實現;
        #         #     processes 是要使用的工作進程數目。如果 processes 為 None，則使用 os.cpu_count() 返回的值;
        #         #     如果 initializer 不為 None，則每個工作進程將會在啟動時調用 initializer(*initargs);
        #         #     maxtasksperchild 是一個工作進程在它退出或被一個新的工作進程代替之前能完成的任務數量，為了釋放未使用的資源。預設的 maxtasksperchild 是 None，意味著工作進程壽與池齊;
        #         #     context 可被用於指定啟動的工作進程的上下文。通常一個進程池是使用函數 multiprocessing.Pool() 或者一個上下文物件的 Pool() 方法創建的。在這兩種情況下， context 都是適當設置的;
        #         # 注意，進程池物件的方法只有創建它的進程能夠調用;
        #         # 備註 通常來說，Pool 中的 Worker 進程的生命週期和進程池的工作隊列一樣長。一些其他系統中（如 Apache, mod_wsgi 等）也可以發現另一種模式，他們會讓工作進程在完成一些任務後退出，清理、釋放資源，然後啟動一個新的進程代替舊的工作進程。 Pool 的 maxtasksperchild 參數給用戶提供了這種能力;
        #         # class multiprocessing.pool.AsyncResult
        #         #     Pool.apply_async() 和 Pool.map_async() 返回對象所屬的類;
        #         #     get([timeout])
        #         #         用於獲取執行結果。如果 timeout 不是 None 並且在 timeout 秒內仍然沒有執行完得到結果，則拋出 multiprocessing.TimeoutError 異常。如果遠端調用發生異常，這個異常會通過 get() 重新拋出。
        #         #     wait([timeout])
        #         #         阻塞，直到返回結果，或者 timeout 秒後超時。
        #         #     ready()
        #         #         用於判斷執行狀態，是否已經完成。
        #         #     successful()
        #         #         Return whether the call completed without raising an exception. Will raise AssertionError if the result is not ready.
        #         # # 推入函數在進程池中啓動一個子進程，process_Pool.apply(func=, args=(,), kwds={})，同步函數會阻塞主進程直到返回結果，其中的執行函數 func 只能接受最外層的函數，不能是嵌套的内層函數;
        #         # apply_func_return = process_Pool.apply(func=pool_func, args=(read_file_do_Function, "", "", do_Function, "", "", "", "", time_sleep), kwds={})  # 同步函數，會阻塞主進程等待直到返回結果;
        #         # # print(apply_func_return)
        #         # if isinstance(apply_func_return, list):
        #         #     prcess_pid = int(apply_func_return[1])
        #         #     thread_ident = int(apply_func_return[2])
        #         #     # 記錄每個被調用的子進程的纍加總次數;
        #         #     if str(apply_func_return[1]) in total_worker_called_number:
        #         #         print(total_worker_called_number)
        #         #         # total_worker_called_number[str(apply_func_return[1])] = int(total_worker_called_number[str(apply_func_return[1])]) + int(1)
        #         #     else:
        #         #         total_worker_called_number[str(apply_func_return[1])] = int(0)
        #         # process_Pool.close()
        #         # process_Pool.join()
        #         # process_Pool.terminate()
        #     except Exception as error:
        #         print(error)

        # 判斷是否需要啓動進程池并發監聽操作指定的媒介文檔，is_Monitor_Concurrent = ""  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：0、"0"、"Multi-Threading"、"Multi-Processes";
        # 當 is_Monitor_Concurrent == 0 or "0" 時，不使用并發監聽;
        if is_Monitor_Concurrent == 0 or is_Monitor_Concurrent == "0":

            if isinstance(Monitor_Concurrent_process_Pool, dict):
                Monitor_Concurrent_process_Pool["Main_thread"] = threading.current_thread().ident

            # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
            # 創建看守進程，監聽指定的用於傳入數據的媒介文檔是否已經被創建;
            while True:

                # 使用Python原生模組os判斷目錄或文檔是否存在;
                if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
                    # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                    if not (os.access(monitor_file, os.R_OK) and os.access(monitor_file, os.W_OK)):
                        try:
                            os.chmod(monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
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

                    monitor_file_creat_host = os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                    monitor_file_creat_time = datetime.datetime.fromtimestamp(os.stat(monitor_file).st_atime).strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;
                    # monitor_file_creat_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.stat(monitor_file).st_atime))

                    input_file_NUM = int(input_file_NUM) + int(1)  # 監聽到的第幾次傳入媒介文檔增加一個;
                    # 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                    index_NUM = "_" + str(input_file_NUM)  # 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                    if len(input_queues_array) > 0:
                        index_NUM = "_" + str(int(os.path.split(input_queues_array[int(int(len(input_queues_array)) - int(1))])[0].split("_")[1]) + int(1))  # 字符串切片函數 str.split(" ", num=string.count(str));

                    temp_monitor_file = os.path.join(temp_cache_IO_data_dir + os.path.split(monitor_file)[1].split(os.path.splitext(monitor_file)[1])[0] + str(index_NUM) + os.path.splitext(monitor_file)[1])  # 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                    # print(temp_monitor_file)
                    temp_output_file = os.path.join(temp_cache_IO_data_dir + os.path.split(output_file)[1].split(os.path.splitext(output_file)[1])[0] + str(index_NUM) + os.path.splitext(output_file)[1])  # 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                    # print(temp_output_file)

                    # 判斷用於暫存接收和輸出傳值的臨時媒介文檔是否有重名的;
                    file_bool = False
                    try:
                        # 同步判斷，使用 Python 原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                        file_bool = (os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file)) or (os.path.exists(temp_output_file) and os.path.isfile(temp_output_file))
                        # print("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.")
                    except OSError as error:
                        print(f'Error: {temp_monitor_file} or {temp_output_file} : {error.strerror}')
                        print("用於暫存接收傳值的媒介文檔 [ " + temp_monitor_file + " 或用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否重名.")
                        return [temp_monitor_file, temp_output_file]

                    while file_bool:
                        # print("用於暫存接收傳值的媒介文檔: " + temp_monitor_file + " 已經存在.")
                        input_file_NUM = int(input_file_NUM) + int(1)  # 監聽到的第幾次傳入媒介文檔增加一個;
                        # 同步移動文檔，將用於傳入數據的媒介文檔 monitor_file 從媒介文件夾 monitor_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                        index_NUM = "_" + str(input_file_NUM)  # 傳入數據的臨時暫存文檔 temp_monitor_file 的序號尾;
                        # if len(input_queues_array) > 0:
                        #     index_NUM = "_" + str(int(os.path.split(input_queues_array[int(int(len(input_queues_array)) - int(1))])[0].split("_")[1]) + int(1))  # 字符串切片函數 str.split(" ", num=string.count(str));

                        temp_monitor_file = os.path.join(temp_cache_IO_data_dir + os.path.split(monitor_file)[1].split(os.path.splitext(monitor_file)[1])[0] + str(index_NUM) + os.path.splitext(monitor_file)[1])  # 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                        # print(temp_monitor_file)
                        temp_output_file = os.path.join(temp_cache_IO_data_dir + os.path.split(output_file)[1].split(os.path.splitext(output_file)[1])[0] + str(index_NUM) + os.path.splitext(output_file)[1])  # 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                        # print(temp_output_file)

                        # 判斷用於接收傳值的臨時媒介文檔是否有重名的;
                        file_bool = False
                        try:
                            # 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_monitor_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                            file_bool = (os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file)) or (os.path.exists(temp_output_file) and os.path.isfile(temp_output_file))
                            # print("文檔: " + temp_monitor_file + " 存在.")# print("文檔: " + temp_monitor_file + " 或文檔: " + temp_output_file + " 已經存在.")
                        except OSError as error:
                            print(f'Error: {temp_monitor_file} or {temp_output_file} : {error.strerror}')
                            print("用於暫存接收傳值的媒介文檔 [ " + temp_monitor_file + " 或用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否存在.")
                            return [temp_monitor_file, temp_output_file]

                    # # 判斷用於暫存輸出傳值的臨時媒介文檔是否有重名的;
                    # file_bool = False
                    # try:
                    #     # 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    #     file_bool = os.path.exists(temp_output_file) and os.path.isfile(temp_output_file)
                    #     # print("文檔: " + temp_output_file + " 存在.")
                    # except OSError as error:
                    #     print(f'Error: {temp_output_file} : {error.strerror}')
                    #     print("用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否存在.")
                    #     return temp_output_file

                    # while file_bool:
                    #     # print("用於暫存輸出傳值的媒介文檔: " + temp_output_file + " 已經存在.")
                    #     input_file_NUM = int(input_file_NUM) + int(1)  # 監聽到的第幾次傳入媒介文檔增加一個;
                    #     # 同步移動文檔，將用於傳出數據的媒介文檔 output_file 從媒介文件夾 output_dir 移動到臨時暫存媒介文件夾 temp_NodeJS_cache_IO_data_dir;
                    #     index_NUM = "_" + str(input_file_NUM)  # 傳出數據的臨時暫存文檔 temp_output_file 的序號尾;
                    #     # if len(input_queues_array) > 0:
                    #     #     index_NUM = "_" + str(int(os.path.split(input_queues_array[int(int(len(input_queues_array)) - int(1))])[0].split("_")[1]) + int(1))  # 字符串切片函數 str.split(" ", num=string.count(str));

                    #     temp_monitor_file = os.path.join(temp_cache_IO_data_dir + os.path.split(monitor_file)[1].split(os.path.splitext(monitor_file)[1])[0] + str(index_NUM) + os.path.splitext(monitor_file)[1])  # 用於傳入數據的臨時暫存文檔 temp_monitor_file 路徑全名;
                    #     # print(temp_monitor_file)
                    #     temp_output_file = os.path.join(temp_cache_IO_data_dir + os.path.split(output_file)[1].split(os.path.splitext(output_file)[1])[0] + str(index_NUM) + os.path.splitext(output_file)[1])  # 用於傳出數據的臨時暫存文檔 temp_output_file 路徑全名;
                    #     # print(temp_output_file)

                    #     # 判斷用於輸出傳值的臨時媒介文檔是否有重名的;
                    #     file_bool = False
                    #     try:
                    #         # 同步判斷，使用Node.js原生模組fs的fs.existsSync(temp_output_file)方法判斷目錄或文檔是否存在以及是否為文檔;
                    #         file_bool = os.path.exists(temp_output_file) and os.path.isfile(temp_output_file)
                    #         # print("文檔: " + temp_output_file + " 存在.")
                    #     except OSError as error:
                    #         print(f'Error: {temp_output_file} : {error.strerror}')
                    #         print("用於暫存輸出傳值的媒介文檔 [ " + temp_output_file + " ] 無法判斷是否存在.")
                    #         return temp_output_file

                    # 將指定用於傳入數據的媒介文檔，改名為臨時暫存傳入數據的媒介文檔;
                    try:                    
                        os.rename(monitor_file, temp_monitor_file)  # 移動或重命名文檔;
                        # 函數 shutil.move(src, dst) 不好用;
                    except Exception as error:
                        # print(f'Error: {monitor_file} : {error.strerror}')
                        # print("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file)
                        # "[Errno 13] Permission denied" in str(error)
                        if("[WinError 32]" in str(error)):
                            # print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試將文檔 " + monitor_file + " 移動更名為: " + temp_monitor_file)
                            time.sleep(time_sleep)
                            try:
                                os.rename(monitor_file, temp_monitor_file)  # 移動或重命名文檔;
                                # 函數 shutil.move(src, dst) 不好用;
                            except OSError as error:
                                print(f'Error: {monitor_file} : {error.strerror}')
                                print("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file)
                                # return monitor_file
                        else:
                            print(f'Error: {monitor_file} : {error.strerror}')
                            print("用於傳入數據的媒介文檔: " + monitor_file + " 無法移動更名為: " + temp_monitor_file)
                            # return monitor_file


                    # 使用Python原生模組os判斷指定的用於暫存輸入輸出數據的暫存媒介文檔，是否創建成功，如果已經被創建，則為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
                    if os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file):
                        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                        if not (os.access(temp_monitor_file, os.R_OK) and os.access(temp_monitor_file, os.W_OK)):
                            try:
                                os.chmod(temp_monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                                # os.chmod(temp_monitor_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                                # os.chmod(temp_monitor_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                                # os.chmod(temp_monitor_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                                # os.chmod(temp_monitor_file, stat.S_IWOTH)  # 可被其它用戶寫入;
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
                                print(f'Error: {temp_monitor_file} : {error.strerror}')
                                print("用於暫存接收傳值的媒介文檔 [ " + temp_monitor_file + " ] 無法修改為可讀可寫權限.")
                                # return temp_monitor_file
                    else:
                        # 如果指定創建的臨時文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                        print("用於暫存輸入傳值的媒介文檔 [ " + temp_monitor_file + " ] 無法創建.")
                        # return temp_monitor_file

                    # 使用Python原生模組os判斷用於輸入數據的媒介文檔，是否已經被刪除，如果仍然存在則報錯退出;
                    if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
                        # 如果指定創建的臨時文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                        print("用於輸入傳值的媒介文檔 [ " + monitor_file + " ] 無法被刪除.")
                        # return monitor_file

                    # 將新讀入的數據，推入待命任務隊列數組
                    if os.path.exists(temp_monitor_file) and os.path.isfile(temp_monitor_file) and os.access(temp_monitor_file, os.R_OK) and os.access(temp_monitor_file, os.W_OK):

                        worker_Data = {
                            # "read_file_do_Function": read_file_do_Function,
                            "monitor_file": temp_monitor_file,  # monitor_file;
                            "monitor_dir": temp_cache_IO_data_dir,  # monitor_dir;
                            # "do_Function": do_Function,  # do_Function_obj["do_Function"];
                            "output_dir": temp_cache_IO_data_dir,  # output_dir;
                            "output_file": temp_output_file,  # output_file，output_queues_array;
                            "to_executable": to_executable,
                            "to_script": to_script,
                            "monitor_file_creat_host": monitor_file_creat_host,
                            "monitor_file_creat_time": monitor_file_creat_time,
                        }

                        input_queues_array.append(worker_Data)  # 推入待處理隊列;

                        # # 使用 Python 原生的多執行緒（綫程）支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
                        # # 第一個參數 target=do_Function 是子執行緒（綫程）函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                        # t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
                        # t.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                        # t.start()  # 啓動子綫程;
                        # # threading.Condition()

                        # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
                        # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                        # p = multiprocessing.Process(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
                        # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                        # p.start()  # 啓動子進程;
                        # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
                        # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
                        # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
                        # # p.pid
                        # # p.name
                        # # p.ident
                        # # p.sentinel

                # 監聽待處理任務隊列數組 input_queues_array 和 空閑子綫程隊列 worker_free，當有待處理任務等待時，且有空閑子進程時，將待任務隊列中排在前面的第一個待處理任務，推入一個空閑子進程;
                if len(input_queues_array) > 0:

                    # 判斷傳入的等待處理的參數 JSON 對象的合法性;
                    if not(isinstance(input_queues_array[0], dict)) or input_queues_array[0]["monitor_file"] == None or not(os.path.exists(input_queues_array[0]["monitor_file"]) and os.path.isfile(input_queues_array[0]["monitor_file"])):
                        print("傳入的等待處理的參數 JSON 對象無法識別: " + input_queues_array[0])
                        temp = input_queues_array[0]
                        del input_queues_array[0]
                        return temp

                    if number_Worker_process > 0 and process_Pool != None:

                        # 將監聽到待處理的文檔信息推入進程池
                        # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
                        # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                        # p = multiprocessing.Process(target=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), kwds={}, name=None, daemon=True)
                        # # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                        # p.start()  # 啓動子進程;
                        # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
                        # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
                        # # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
                        # # p.pid
                        # # p.name
                        # # p.ident
                        # # p.sentinel
                        # worker_queues[str(p.pid)] = p
                        # worker_free[str(p.pid)] = True
                        # total_worker_called_number[str(p.pid)] = int(0)

                        monitor_file_creat_host = input_queues_array[0]["monitor_file_creat_host"]  # os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                        monitor_file_creat_time = input_queues_array[0]["monitor_file_creat_time"]  # os.stat(monitor_file).st_atime.strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;

                        # print(input_queues_array[0])
                        # 函數 process_Pool.apply_async(func=, args=(,), kwds={}, callback=, error_callback=) 中的執行函數 func 和 callback 只能接受最外層的函數，不能是嵌套的内層函數;
                        apply_async_func_return = process_Pool.apply_async(func=pool_func, args=(read_file_do_Function, input_queues_array[0]["monitor_file"], input_queues_array[0]["monitor_dir"], do_Function, input_queues_array[0]["output_dir"], input_queues_array[0]["output_file"], input_queues_array[0]["to_executable"], input_queues_array[0]["to_script"], time_sleep), kwds={}, callback=pool_call_back, error_callback=error_pool_call_back)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
                        # input_queues_array[0] == {
                        #     # "read_file_do_Function": read_file_do_Function,
                        #     "monitor_file": temp_monitor_file,  # monitor_file;
                        #     "monitor_dir": temp_cache_IO_data_dir,  # monitor_dir;
                        #     # "do_Function": do_Function,  # do_Function_obj["do_Function"];
                        #     "output_dir": temp_cache_IO_data_dir,  # output_dir;
                        #     "output_file": temp_output_file,  # output_file，output_queues_array;
                        #     "to_executable": to_executable,
                        #     "to_script": to_script,
                        #     "monitor_file_creat_host": monitor_file_creat_host,
                        #     "monitor_file_creat_time": monitor_file_creat_time
                        # }
                        # args == (
                        #     read_file_do_Function,
                        #     input_queues_array[0]["monitor_file"],
                        #     input_queues_array[0]["monitor_dir"],
                        #     do_Function,
                        #     input_queues_array[0]["output_dir"],
                        #     input_queues_array[0]["output_file"],
                        #     input_queues_array[0]["to_executable"],
                        #     input_queues_array[0]["to_script"],
                        #     time_sleep
                        # )
                        # print(apply_async_func_return.get(timeout=None))
                        # print(apply_async_func_return.ready())
                        # print(apply_async_func_return.successful())

                        del input_queues_array[0]

                        if isinstance(apply_async_func_return.get(timeout=None), list):

                            prcess_pid = int(apply_async_func_return.get(timeout=None)[1])
                            thread_ident = int(apply_async_func_return.get(timeout=None)[2])

                            # 記錄每個被調用的子進程的纍加總次數;
                            if str(prcess_pid) in total_worker_called_number:
                                total_worker_called_number[str(prcess_pid)] = int(total_worker_called_number[str(prcess_pid)]) + int(1)
                            else:
                                total_worker_called_number[str(prcess_pid)] = int(1)

                            result_Data = {
                                "monitor_file": apply_async_func_return.get(timeout=None)[0][2],
                                "output_file": apply_async_func_return.get(timeout=None)[0][1]
                            }
                            output_queues_array.append(result_Data)
                            # print(output_queues_array)

                            # multiprocessing.current_process().pid, multiprocessing.current_process().name, threading.current_thread().ident, threading.current_thread().getName()
                            print(str(monitor_file_creat_host) + " " + str(monitor_file_creat_time) + " process-" + str(prcess_pid) + " thread-" + str(thread_ident) + " " + result_Data["monitor_file"] + " " + output_file)
                            # print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) + " process-" + str(prcess_pid) + " thread-" + str(thread_ident) + " " + result_Data["monitor_file"] + " " + output_file)

                            # result = apply_async_func_return.get(timeout=None)[0][0],

                            # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔 apply_async_func_return.get(timeout=None)[0][2] == monitor_file;
                            try:
                                os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[0][2] == monitor_file;
                                # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                                # print(os.listdir(input_queues_array[0][monitor_dir]))
                            except Exception as error:
                                print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                                if("[WinError 32]" in str(error)):
                                    print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + result_Data["monitor_file"])
                                    time.sleep(time_sleep)
                                    try:
                                        os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[0][2] == monitor_file;
                                        # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                                        # print(os.listdir(input_queues_array[0][monitor_dir]))
                                    except OSError as error:
                                        print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                                # else:
                                #     print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')

                            # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                            if os.path.exists(result_Data["monitor_file"]) and os.path.isfile(result_Data["monitor_file"]):
                                print("用於接收傳值的媒介文檔 [ " + result_Data["monitor_file"] + " ] 無法刪除.")
                                # return result_Data["monitor_file"]

                        else:
                            print("函數 read_file_do_Function() 從硬盤媒介文檔 [ " + apply_async_func_return.get(timeout=None)[0][2] + " ] 讀取傳入數據并進行處理的過程出現錯誤.")
                            # return apply_async_func_return

                    if number_Worker_process <= 0 or process_Pool == None:

                        monitor_file_creat_host = input_queues_array[0]["monitor_file_creat_host"]  # os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                        monitor_file_creat_time = input_queues_array[0]["monitor_file_creat_time"]  # os.stat(monitor_file).st_atime.strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;

                        # multiprocessing.current_process().pid, multiprocessing.current_process().name, threading.current_thread().ident, threading.current_thread().getName()
                        print(str(monitor_file_creat_host) + " " + str(monitor_file_creat_time) + " process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " " + input_queues_array[0]["monitor_file"] + " " + output_file)
                        # print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) + " process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " " + input_queues_array[0]["monitor_file"] + " " + output_file)

                        prcess_pid = multiprocessing.current_process().pid
                        thread_ident = threading.current_thread().ident

                        # 記錄每個被調用的子進程的纍加總次數;
                        if str(prcess_pid) in total_worker_called_number:
                            total_worker_called_number[str(prcess_pid)] = int(total_worker_called_number[str(prcess_pid)]) + int(1)
                        else:
                            total_worker_called_number[str(prcess_pid)] = int(1)

                        # print(input_queues_array[0])
                        result_arr = read_file_do_Function(input_queues_array[0]["monitor_file"], input_queues_array[0]["monitor_dir"], do_Function, input_queues_array[0]["output_dir"], input_queues_array[0]["output_file"], input_queues_array[0]["to_executable"], input_queues_array[0]["to_script"], time_sleep)
                        # print(result_arr)
                        # input_queues_array[0] == {
                        #     # "read_file_do_Function": read_file_do_Function,
                        #     "monitor_file": temp_monitor_file,  # monitor_file;
                        #     "monitor_dir": temp_cache_IO_data_dir,  # monitor_dir;
                        #     # "do_Function": do_Function,  # do_Function_obj["do_Function"];
                        #     "output_dir": temp_cache_IO_data_dir,  # output_dir;
                        #     "output_file": temp_output_file,  # output_file，output_queues_array;
                        #     "to_executable": to_executable,
                        #     "to_script": to_script
                        # }

                        del input_queues_array[0]

                        # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
                        # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
                        # p = multiprocessing.Process(target=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), kwds={}, name=None, daemon=True)
                        # # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                        # p.start()  # 啓動子進程;
                        # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
                        # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
                        # # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
                        # # p.pid
                        # # p.name
                        # # p.ident
                        # # p.sentinel
                        # worker_queues[str(p.pid)] = p
                        # worker_free[str(p.pid)] = True
                        # total_worker_called_number[str(p.pid)] = int(0)

                        if isinstance(result_arr, tuple):

                            result_Data = {
                                "monitor_file": result_arr[2],
                                "output_file": result_arr[1]
                            }
                            output_queues_array.append(result_Data)
                            # print(output_queues_array)

                            # result = result_arr[0]

                            # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔 apply_async_func_return.get(timeout=None)[2] == monitor_file;
                            try:
                                os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[2] == monitor_file;
                                # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                                # print(os.listdir(input_queues_array[0][monitor_dir]))
                            except Exception as error:
                                print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                                if("[WinError 32]" in str(error)):
                                    print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + result_Data["monitor_file"])
                                    time.sleep(time_sleep)
                                    try:
                                        os.remove(result_Data["monitor_file"])  # os.unlink(monitor_file) 刪除文檔 apply_async_func_return.get(timeout=None)[2] == monitor_file;
                                        # os.listdir(input_queues_array[0][monitor_dir])  # 刷新目錄内容列表
                                        # print(os.listdir(input_queues_array[0][monitor_dir]))
                                    except OSError as error:
                                        print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')
                                else:
                                    print(f'Error: {result_Data["monitor_file"]} : {error.strerror}')

                            # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                            if os.path.exists(result_Data["monitor_file"]) and os.path.isfile(result_Data["monitor_file"]):
                                print("用於暫存接收傳值的臨時媒介文檔 [ " + result_Data["monitor_file"] + " ] 無法刪除.")
                                # return result_Data["monitor_file"]

                        else:
                            print("函數 read_file_do_Function() 從硬盤媒介文檔 [ " + result_arr[2] + " ] 讀取傳入數據并進行處理的過程出現錯誤.")
                            # return result_arr

                # 監聽待傳出數據結果隊列數組 output_queues_array，當有用於傳出數據的媒介目錄 output_dir 中不在含有 output_file 時，將待傳出數據結果隊列數組 output_queues_array 中排在前面的第一個結果文檔，更名移人用於傳出數據的媒介目錄 output_dir 中;
                if len(output_queues_array) > 0:

                    # 判斷傳入的等待寫入用於傳出數據的媒介文檔的參數 JSON 對象的合法性;
                    if isinstance(output_queues_array[0], dict) and output_queues_array[0]["output_file"] != None and os.path.exists(output_queues_array[0]["output_file"]) and os.path.isfile(output_queues_array[0]["output_file"]):
                        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                        if not (os.access(output_queues_array[0]["output_file"], os.R_OK) and os.access(output_queues_array[0]["output_file"], os.W_OK)):
                            try:
                                os.chmod(output_queues_array[0]["output_file"], stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                                # os.chmod(output_queues_array[0]["output_file"], stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                                # os.chmod(output_queues_array[0]["output_file"], stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                                # os.chmod(output_queues_array[0]["output_file"], stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                                # os.chmod(output_queues_array[0]["output_file"], stat.S_IWOTH)  # 可被其它用戶寫入;
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
                                print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                                print("用於暫存輸出傳值的臨時媒介文檔 [ " + output_queues_array[0]["output_file"] + " ] 無法修改為可讀可寫權限.")
                                temp = output_queues_array[0]
                                del output_queues_array[0]
                                # return temp["output_file"]
                    else:
                        print("用於傳出數據的暫存媒介文檔隊列中的: " + output_queues_array[0]["output_file"] + " 不存在.")
                        temp = output_queues_array[0]
                        del output_queues_array[0]
                        # return temp

                    # 判斷如果指定的用於輸出的正式媒介文檔不存在，則將用於傳出數據的臨時媒介文檔改名為指定的正式傳出媒介文檔;
                    if not (os.path.exists(output_file) and os.path.isfile(output_file)):

                        # 將用於傳出數據的臨時媒介文檔改名為指定的正式傳出媒介文檔;
                        try:
                            os.rename(output_queues_array[0]["output_file"], output_file)  # 移動或重命名文檔;
                            # 函數 shutil.move(src, dst) 不好用;
                            del output_queues_array[0]
                        except Exception as error:
                            print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                            print("用於暫存傳出數據的臨時媒介文檔: " + output_queues_array[0]["output_file"] + " 無法移動更名為指定的正式傳出媒介文檔: " + output_file)
                            # "[Errno 13] Permission denied" in str(error)
                            if("[WinError 32]" in str(error)):
                                print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試將文檔 " + output_queues_array[0]["output_file"] + " 移動更名為: " + output_file)
                                time.sleep(time_sleep)
                                try:
                                    os.rename(output_queues_array[0]["output_file"], output_file)  # 移動或重命名文檔;
                                    # 函數 shutil.move(src, dst) 不好用;
                                except OSError as error:
                                    print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                                    print("用於暫存傳出數據的臨時媒介文檔: " + output_queues_array[0]["output_file"] + " 無法移動更名為指定的正式傳出媒介文檔: " + output_file)
                                    # "[Errno 13] Permission denied" in str(error)
                                    # temp = output_queues_array[0]
                                    # del output_queues_array[0]
                                    # return temp["output_file"]
                            else:
                                temp = output_queues_array[0]
                                # del output_queues_array[0]
                                # return temp["output_file"]

                        # 使用Python原生模組os判斷指定的用於輸出數據的媒介文檔，是否創建成功，如果已經被創建，則為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
                        if os.path.exists(output_file) and os.path.isfile(output_file):
                            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                            if not (os.access(output_file, os.R_OK) and os.access(output_file, os.W_OK)):
                                try:
                                    os.chmod(output_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
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
                                    print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 無法修改為可讀可寫權限.")
                                    # del output_queues_array[0]
                                    # return output_file

                            # 運算處理完之後，給調用語言的回復，os.access(to_script, os.X_OK) 判斷脚本文檔是否具有被執行權限;
                            if type(to_executable) == str and to_executable != "" and os.path.exists(to_executable) and os.path.isfile(to_executable) and os.access(to_executable, os.X_OK):
                                if type(to_script) == str and to_script != "" and os.path.exists(to_script) and os.path.isfile(to_script):
                                    # node  環境;
                                    # test.js  待執行的JS的檔;
                                    # %s %s  傳遞給JS檔的參數;
                                    # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
                                    shell_to = os.popen('%s %s %s %s %s %s' % (to_executable, to_script, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;
                                    # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
                                    # let arg1 = process.argv[2];  // 解析出JS參數;
                                    # let arg2 = process.argv[3];
                                else:
                                    shell_to = os.popen('%s %s %s %s %s' % (to_executable, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;

                                # print(shell_to.readlines());
                                response = shell_to.read()  # 取出執行結果
                                # print(response)

                        # else:
                        #     # 如果指定創建的傳出數據的媒介文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                        #     print(f'Error: {output_file} : {error.strerror}')
                        #     print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 無法創建.")
                        #     temp = output_queues_array[0]
                        #     del output_queues_array[0]
                        #     return temp["output_file"]

                        # # 使用Python原生模組os判斷用於暫存數據的臨時輸出媒介文檔，是否已經被刪除，如果仍然存在則報錯退出;
                        # if os.path.exists(output_queues_array[0]["output_file"]) and os.path.isfile(output_queues_array[0]["output_file"]):
                        #     # 如果指定創建的臨時文檔不存在，則捕獲並抛出 FileExistsError 錯誤退出;
                        #     print(f'Error: {output_queues_array[0]["output_file"]} : {error.strerror}')
                        #     print("用於暫存傳出數據的臨時媒介文檔 [ " + output_queues_array[0]["output_file"] + " ] 無法被刪除.")
                        #     # temp = output_queues_array[0]
                        #     # del output_queues_array[0]
                        #     # return temp["output_file"]

                time.sleep(time_sleep)

        # 當 is_Monitor_Concurrent == "Multi-Threading" 時，表示使用多綫程并發監聽;
        if is_Monitor_Concurrent == "Multi-Threading":

            # # 使用 Python 原生的多執行緒（綫程）支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
            # # 第一個參數 target=do_Function 是子執行緒（綫程）函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
            # t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
            # t.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
            # t.start()  # 啓動子綫程;
            # # threading.Condition()
            # print(t.ident)  # 參數 t.ident 表示獲取綫程（t）的標識符;
            # print("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " ( name: " + str(threading.current_thread().name) + " )")
            if isinstance(Monitor_Concurrent_process_Pool, dict):
                Monitor_Concurrent_process_Pool["Main_thread"] = threading.current_thread().ident

            threading_monitor_file = threading.Thread(group=None, target=monitor_file_func, name="thread - monitor file", args=(monitor_file, temp_cache_IO_data_dir, output_file, to_executable, to_script, time_sleep, input_file_NUM), kwargs={})
            threading_monitor_file.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
            threading_monitor_file.start()  # 啓動子綫程;
            threading_monitor_file_is_alive = threading_monitor_file.is_alive()
            # print("thread-" + str(threading_monitor_file.ident) + " ( name: " + str(threading_monitor_file.name) + " ) be created.")
            # print(str(threading_monitor_file.name) + " ( thread-" + str(threading_monitor_file.ident) + " ) be created.")
            if isinstance(Monitor_Concurrent_process_Pool, dict):
                Monitor_Concurrent_process_Pool["thread_monitor_file"] = threading_monitor_file.ident

            threading_monitor_input_queues = threading.Thread(group=None, target=monitor_input_queues_func, name="thread - monitor input queues", args=(read_file_do_Function, do_Function, output_file, time_sleep, pool_func, pool_call_back, error_pool_call_back, number_Worker_process, process_Pool, total_worker_called_number), kwargs={})
            threading_monitor_input_queues.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
            threading_monitor_input_queues.start()  # 啓動子綫程;
            threading_monitor_input_queues_is_alive = threading_monitor_input_queues.is_alive()
            # print("thread-" + str(threading_monitor_input_queues.ident) + " ( name: " + str(threading_monitor_input_queues.name) + " ) be created.")
            # print(str(threading_monitor_input_queues.name) + " ( thread-" + str(threading_monitor_input_queues.ident) + " ) be created.")
            if isinstance(Monitor_Concurrent_process_Pool, dict):
                Monitor_Concurrent_process_Pool["thread_monitor_input_queues"] = threading_monitor_input_queues.ident

            threading_monitor_output_queues = threading.Thread(group=None, target=monitor_output_queues_func, name="thread - monitor output queues", args=(monitor_file, monitor_dir, output_dir, output_file, to_executable, to_script, time_sleep), kwargs={})
            threading_monitor_output_queues.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
            threading_monitor_output_queues.start()  # 啓動子綫程;
            threading_monitor_output_queues_is_alive = threading_monitor_output_queues.is_alive()
            # print("thread-" + str(threading_monitor_output_queues.ident) + " ( name: " + str(threading_monitor_output_queues.name) + " ) be created.")
            # print(str(threading_monitor_output_queues.name) + " ( thread-" + str(threading_monitor_output_queues.ident) + " ) be created.")
            if isinstance(Monitor_Concurrent_process_Pool, dict):
                Monitor_Concurrent_process_Pool["thread_monitor_output_queues"] = threading_monitor_output_queues.ident

            # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
            # 創建看守進程，監聽指定的用於傳入數據的媒介文檔是否已經被創建;
            while True:

                if threading_monitor_file_is_alive == False:

                    print("thread-" + str(threading_monitor_file.ident) + " ( name: " + str(threading_monitor_file.name) + " ) .is_alive() == False.")

                    # # 使用 ctypes 模組强制中止綫程，需要事先 import inspect 和 import ctypes;
                    # """raises the exception, performs cleanup if needed"""
                    # tid = ctypes.c_long(threading_monitor_file.ident)  # 方法 .ident 表示獲取綫程的 ID 號值;
                    # exctype = SystemExit  # 常量 SystemExit 表示中止運行綫程;
                    # if not inspect.isclass(exctype):
                    #     exctype = type(exctype)
                    # result = ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, ctypes.py_object(exctype))
                    # if result == 0:
                    #     raise ValueError("invalid thread id")
                    # elif result != 1:
                    #     """if it returns a number greater than one, you're in trouble, and you should call it again with exc=NULL to revert the effect"""
                    #     ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, None)
                    #     raise SystemError("PyThreadState_SetAsyncExc failed")
                    # # else:

                    # 重啓綫程;
                    threading_monitor_file = threading.Thread(group=None, target=monitor_file_func, name="thread - monitor file", args=(monitor_file, temp_cache_IO_data_dir, output_file, to_executable, to_script, time_sleep, input_file_NUM), kwargs={})
                    threading_monitor_file.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    threading_monitor_file.start()  # 啓動子綫程;
                    # # threading.Condition()
                    threading_monitor_file_is_alive = threading_monitor_file.is_alive()
                    print("thread-" + str(threading_monitor_file.ident) + " ( name: " + str(threading_monitor_file.name) + " ) be created.")
                    if isinstance(Monitor_Concurrent_process_Pool, dict):
                        Monitor_Concurrent_process_Pool["thread_monitor_file"] = threading_monitor_file.ident

                if threading_monitor_input_queues_is_alive == False:

                    print("thread-" + str(threading_monitor_input_queues.ident) + " ( name: " + str(threading_monitor_input_queues.name) + " ) .is_alive() == False.")

                    # # 使用 ctypes 模組强制中止綫程，需要事先 import inspect 和 import ctypes;
                    # """raises the exception, performs cleanup if needed"""
                    # tid = ctypes.c_long(threading_monitor_input_queues.ident)  # 方法 .ident 表示獲取綫程的 ID 號值;
                    # exctype = SystemExit  # 常量 SystemExit 表示中止運行綫程;
                    # if not inspect.isclass(exctype):
                    #     exctype = type(exctype)
                    # result = ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, ctypes.py_object(exctype))
                    # if result == 0:
                    #     raise ValueError("invalid thread id")
                    # elif result != 1:
                    #     """if it returns a number greater than one, you're in trouble, and you should call it again with exc=NULL to revert the effect"""
                    #     ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, None)
                    #     raise SystemError("PyThreadState_SetAsyncExc failed")
                    # # else:

                    # 重啓綫程;
                    threading_monitor_input_queues = threading.Thread(group=None, target=monitor_input_queues_func, name="thread - monitor input queues", args=(read_file_do_Function, do_Function, output_file, time_sleep, pool_func, pool_call_back, error_pool_call_back, number_Worker_process, process_Pool, total_worker_called_number), kwargs={})
                    threading_monitor_input_queues.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    threading_monitor_input_queues.start()  # 啓動子綫程;
                    # # threading.Condition()
                    threading_monitor_input_queues_is_alive = threading_monitor_input_queues.is_alive()
                    print("thread-" + str(threading_monitor_input_queues.ident) + " ( name: " + str(threading_monitor_input_queues.name) + " ) be created.")
                    if isinstance(Monitor_Concurrent_process_Pool, dict):
                        Monitor_Concurrent_process_Pool["thread_monitor_input_queues"] = threading_monitor_input_queues.ident

                if threading_monitor_output_queues_is_alive == False:

                    print("thread-" + str(threading_monitor_output_queues.ident) + " ( name: " + str(threading_monitor_output_queues.name) + " ) .is_alive() == False.")

                    # # 使用 ctypes 模組强制中止綫程，需要事先 import inspect 和 import ctypes;
                    # """raises the exception, performs cleanup if needed"""
                    # tid = ctypes.c_long(threading_monitor_output_queues.ident)  # 方法 .ident 表示獲取綫程的 ID 號值;
                    # exctype = SystemExit  # 常量 SystemExit 表示中止運行綫程;
                    # if not inspect.isclass(exctype):
                    #     exctype = type(exctype)
                    # result = ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, ctypes.py_object(exctype))
                    # if result == 0:
                    #     raise ValueError("invalid thread id")
                    # elif result != 1:
                    #     """if it returns a number greater than one, you're in trouble, and you should call it again with exc=NULL to revert the effect"""
                    #     ctypes.pythonapi.PyThreadState_SetAsyncExc(tid, None)
                    #     raise SystemError("PyThreadState_SetAsyncExc failed")
                    # # else:

                    # 重啓綫程;
                    threading_monitor_output_queues = threading.Thread(group=None, target=monitor_output_queues_func, name="thread - monitor output queues", args=(monitor_file, monitor_dir, output_dir, output_file, to_executable, to_script, time_sleep), kwargs={})
                    threading_monitor_output_queues.setDaemon(True)  # 把創建的子綫程設爲守護綫程，當主綫程關閉時，子綫程同時關閉，這個標識必須在 .start() 方法調用之前設置;
                    threading_monitor_output_queues.start()  # 啓動子綫程;
                    # # threading.Condition()
                    threading_monitor_output_queues_is_alive = threading_monitor_output_queues.is_alive()
                    print("thread-" + str(threading_monitor_output_queues.ident) + " ( name: " + str(threading_monitor_output_queues.name) + " ) be created.")
                    if isinstance(Monitor_Concurrent_process_Pool, dict):
                        Monitor_Concurrent_process_Pool["thread_monitor_output_queues"] = threading_monitor_output_queues.ident

                time.sleep(time_sleep)

        # # 當 is_Monitor_Concurrent == "Multi-Processes" 時，表示使用多進程并發監聽;
        # if is_Monitor_Concurrent == "Multi-Processes":
        #     # # 使用 Python 原生的多進程支持 multiprocessing 庫的 multiprocessing.Process(target=do_Function, args=(args1, args2)) 創建一個子進程，用於調用讀取指定文檔並處理數據函數;
        #     # # 第一個參數 target=do_Function 是子進程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        #     # p = multiprocessing.Process(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script))
        #     # p.setDaemon(True)  # 把創建的子進程設爲守護進程，當主綫程關閉時，子進程同時關閉，這個標識必須在 .start() 方法調用之前設置;
        #     # p.start()  # 啓動子進程;
        #     # P.close()  # 關閉Process物件，並釋放與之關聯的所有資源，如果底層進程仍在運行，則會引發ValueError。而且，一旦close()方法成功返回，Process物件的大多數方法和屬性也可能會引發ValueError;
        #     # # P.terminate  # 强制終止進程子進程，如果調用此函數,進程P將被立即終止，同時不會進行任何清理動作，在Unix上使用的是SIGTERM信號，在Windows上使用的是TerminateProcess()。注意，進程的後代進程不會被終止（會變成“孤兒”進程）。另外，如果被終止的進程在使用Pipe或Queue時，它們有可能會被損害，並無法被其他進程使用；如果被終止的進程已獲得鎖或信號量等，則有可能導致其他進程鎖死。所以請謹慎使用此方法，如果p保存了一個鎖或參與了進程間通信，那麼終止它可能會導致鎖死或I/O損壞;
        #     # p.join()  # .join() 函數會使得主進程阻塞等待，直到該被調用的子進程運行結束或超時，才繼續執行主進程，要在 .close() 和 .terminate 方法之後使用;
        #     # # p.pid
        #     # # p.name
        #     # # p.ident
        #     # # p.sentinel



        # # 監測指定目錄下是否有新增或刪除文檔或文件夾的動作;
        # now_file = dict([(f, None)for f in os.listdir(monitor_dir)])  # 讀取指定的監聽目錄的全部内容，作爲起始初始化值;
        # # 創建看守進程;
        # while True:
        #     new_file = dict([(f, None)for f in os.listdir(monitor_dir)])
        #     added = [f for f in new_file if not f in now_file]  # 數組類型 list，新增加的文檔名;
        #     removed = [f for f in now_file if not f in new_file]  # 數組類型 list，被刪除的文檔名;
        #     if added:
        #         # print("Added:", ",".join(added))
        #         # 判斷監聽目錄中新增的文檔名稱與指定監聽的文檔名稱是否相等;
        #         for i in range(len(added)):
        #             # print ("序號: %s 值: %s" % (i + 1, added[i]))
        #             # added[i] == monitor_file.split(monitor_dir, -1)[1]
        #             if added[i] == os.path.split(monitor_file)[1]:
        #                 # print("Added: " + added[i])
        #                 # 使用 Python 原生的多綫程支持 threading 庫的 threading.Thread(target=do_Function, args=(args1, args2)) 創建一個子綫程，用於調用讀取指定文檔並處理數據函數;
        #                 # 第一個參數 target=do_Function 是綫程函數變量，第二個參數 args=(args1, args2) 是一個數組變量參數，如果只傳遞一個參數就只需要 args1，如果要傳遞多個參數，可以使用元組，當元組中只包含一個元素時，需要在元素後面添加逗號，例如 args=(args1,) 形式;
        #                 t = threading.Thread(target=read_file_do_Function, args=(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep))
        #                 t.setDaemon(True)  # 設爲保護綫程，當主綫程關閉時，子綫程同時關閉;
        #                 t.start()  # 啓動子綫程;
        #                 # threading.Condition()
        #                 break
        #     if removed:
        #         # print("Removed:", ",".join(removed))
        #         # 判斷監聽目錄中被刪除的文檔名稱與指定的用於傳值的輸出文檔名稱是否相等;
        #         for i in range(len(removed)):
        #             # print ("序號: %s 值: %s" % (i + 1, removed[i]))
        #             # removed[i] == monitor_file.split(monitor_dir, -1)[1]
        #             if removed[i] == os.path.split(monitor_file)[1]:
        #                 print("Removed: " + removed[i])
        #                 break
        #     now_file = new_file
        #     time.sleep(time_sleep)

        # return (multiprocessing.current_process(), process_Pool, Monitor_Concurrent_process_Pool)
        return (multiprocessing.current_process(), Monitor_Concurrent_process_Pool, process_Pool)

    def start(self, is_monitor, read_file_do_Function, monitor_file_do_Function, monitor_file, monitor_dir, do_Function, number_Worker_process, temp_cache_IO_data_dir, output_dir, output_file, to_executable, to_script, time_sleep, total_worker_called_number, pool_func, initializer, pool_call_back, error_pool_call_back, is_Monitor_Concurrent, monitor_file_func, monitor_input_queues_func, monitor_output_queues_func):

        result_tuple = None  # multiprocessing.current_process();
        if is_monitor:

            try:
                # pid = multiprocessing.current_process().pid, threadID = threading.current_thread().ident
                # print("進程: process-" + str(multiprocessing.current_process().pid) + " , 執行緒: thread-" + str(threading.current_thread().ident) + " 正在監聽目錄「 " + monitor_dir + " 」文檔「 " + os.path.split(monitor_file)[1] + " 」 ...")
                print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on directory [ " + monitor_dir + " ] file [ " + os.path.split(monitor_file)[1] + " ] ...")
                print("Cache directory [ %s ]." % (temp_cache_IO_data_dir))
                print("Export at the directory [ %s ] file [ %s ]." % (output_dir, os.path.split(output_file)[1]))
                print('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.')
                print('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.')
                print("Keyboard Enter [ Ctrl ] + [ c ] to close.")
                print("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.")

                global Monitor_Concurrent_process_Pool
                Monitor_Concurrent_process_Pool = {}

                server_process = None
                process_Pool = None
                monitor_return_tuple = monitor_file_do_Function(read_file_do_Function, monitor_file, monitor_dir, do_Function, number_Worker_process, temp_cache_IO_data_dir, output_dir, output_file, to_executable, to_script, time_sleep, total_worker_called_number, pool_func, initializer, pool_call_back, error_pool_call_back, is_Monitor_Concurrent, monitor_file_func, monitor_input_queues_func, monitor_output_queues_func, Monitor_Concurrent_process_Pool)
                server_process = monitor_return_tuple[0]
                Monitor_Concurrent_process_Pool = monitor_return_tuple[1]
                process_Pool = monitor_return_tuple[2]

                # if isinstance(Monitor_Concurrent_process_Pool, dict) and len(Monitor_Concurrent_process_Pool) > 0:
                #     if "thread_monitor_file" in Monitor_Concurrent_process_Pool:
                #         print("thread - monitor file " + " ( thread-" + str(Monitor_Concurrent_process_Pool["thread_monitor_file"]) + " ) be created.")
                #     if "thread_monitor_input_queues" in Monitor_Concurrent_process_Pool:
                #         print("thread - monitor input queues " + " ( thread-" + str(Monitor_Concurrent_process_Pool["thread_monitor_input_queues"]) + " ) be created.")
                #     if "thread_monitor_output_queues" in Monitor_Concurrent_process_Pool:
                #         print("thread - monitor output queues " + " ( thread-" + str(Monitor_Concurrent_process_Pool["thread_monitor_output_queues"]) + " ) be created.")

                # result_tuple = ("process-" + str(server_process.pid), process_Pool, total_worker_called_number, Monitor_Concurrent_process_Pool)
                result_tuple = ("process-" + str(server_process.pid), total_worker_called_number, Monitor_Concurrent_process_Pool, process_Pool)

                pass

            except KeyboardInterrupt:
                # KeyboardInterrupt 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                # executor.shutdown(kill_workers=True)  # 當鍵盤輸入 [Ctrl]+[c] 信號中止進程運行時，使用 executor.shutdown(kill_workers=True) 方法不抛出錯誤;
                # executor.shutdown(wait=True)
                print('[ Ctrl ] + [ c ] received, will be stop the file monitor server.')

                print("綫程池(threading): " + str(threading.active_count()) + " " + str(threading.enumerate()))
                arr = []
                if isinstance(total_worker_called_number, dict) and any(total_worker_called_number):
                    for key in total_worker_called_number:
                        if key == str(multiprocessing.current_process().pid):
                            arr.append("listening Server process-" + str(key) + " [ " + str(total_worker_called_number[key]) + " ]")
                        else:
                            arr.append("Worker process-" + str(key) + " [ " + str(total_worker_called_number[key]) + " ]")
                if len(arr) > 0:
                    print(", ".join(arr))

                if process_Pool != None:
                    # process_Pool.close()
                    # process_Pool.join()
                    process_Pool.terminate()
                    # print(process_Pool)

                # 遞歸清空指定目錄（文件夾）下的所有内容（不包括這個文件夾），使用 Python 原生的標準 os 模組;
                def clear_Dir(dir_path):
                    # os.chdir(dir_path)  # 改變當前工作目錄到指定的路徑;
                    list_dir = os.listdir(dir_path)
                    if len(list_dir) > 0:
                        for f in list_dir:
                            if os.path.isfile(dir_path + "\\%s" % f):
                                os.remove(dir_path + "\\%s" % f)
                            else:
                                list_dir_2 = os.listdir(dir_path + "\\%s" % f)
                                if len(list_dir_2) > 0:
                                    clear_Dir(dir_path + "\\%s" % f)
                    list_dir = os.listdir(dir_path)
                    if len(list_dir) > 0:
                        for f in list_dir:
                            if os.path.isfile(dir_path + "\\%s" % f):
                                os.remove(dir_path + "\\%s" % f)
                            else:
                                list_dir_2 = os.listdir(dir_path + "\\%s" % f)
                                if len(list_dir_2) == 0:
                                    os.rmdir(dir_path + "\\%s" % f)
                    return list_dir

                # 清空用於暫存輸入輸出數據的臨時媒介文件夾 temp_cache_IO_data_dir;
                if temp_cache_IO_data_dir != output_dir and os.path.exists(temp_cache_IO_data_dir) and pathlib.Path(temp_cache_IO_data_dir).is_dir() and len(os.listdir(temp_cache_IO_data_dir)) > 0:
                    print("Clear the temporary interface directory [ %s ]." % (temp_cache_IO_data_dir))
                    # shutil.rmtree(temp_cache_IO_data_dir)  # 使用 shutil 模組中的 .rmtree() 方法遞歸刪除文件夾;
                    # os.mkdir(temp_cache_IO_data_dir)  # 重新創建一個空的與原來同名的文件夾，從而達到清空文件夾的效果;
                    clear_Dir(temp_cache_IO_data_dir)  # 使用自定義函數遞歸清空指定目錄（文件夾）下的所有内容（不包括這個文件夾），使用 Python 原生的標準 os 模組;

                # 清空用於輸入數據的媒介文件夾 monitor_dir;
                if monitor_dir != output_dir and os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir() and len(os.listdir(monitor_dir)) > 0:
                    print("Clear the import data interface directory [ %s ]." % (monitor_dir))
                    # shutil.rmtree(monitor_dir)  # 使用 shutil 模組中的 .rmtree() 方法遞歸刪除文件夾;
                    # os.mkdir(monitor_dir)  # 重新創建一個空的與原來同名的文件夾，從而達到清空文件夾的效果;
                    clear_Dir(monitor_dir)  # 使用自定義函數遞歸清空指定目錄（文件夾）下的所有内容（不包括這個文件夾），使用 Python 原生的標準 os 模組;

                print("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " exit.")

                # 關閉正在運行的服務器;
                # sys.exit(0)
                # try:
                #     return_value = os.kill(server.pid, signal.SIGKILL)  # a = os.kill(pid, signal.9)
                #     # SIGINT 終止進程，中斷進程
                #     # SIGTERM 終止進程，軟體終止信號
                #     # SIGKILL 終止進程，殺死進程
                #     # SIGALRM 鬧鐘信號
                #     print "已中止進程 pid = %s , 返回值為: %s" % (pid, return_value)
                # except OSError, error:
                #     print "未找到進程 pid = %s" % (pid)
                pass

            finally:
                """退出 try 時總會執行的語句，無論是否出錯都會繼續執行的語句;處理單獨綫程中的請求;处理单独线程中的请求。"""

        else:

            if not (os.path.exists(monitor_file) and os.path.isfile(monitor_file)):
                print("系統找不到用於傳入數據的自定義媒介文檔 [ " + monitor_file + " ].")

            if os.path.exists(monitor_file) and os.path.isfile(monitor_file):

                monitor_file_creat_host = os.stat(monitor_file).st_dev  # 文檔創建者設備名;
                monitor_file_creat_time = datetime.datetime.fromtimestamp(os.stat(monitor_file).st_atime).strftime("%Y-%m-%d %H:%M:%S.%f")  # 文檔創建時間（最後一次訪問時間）;
                # monitor_file_creat_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.stat(monitor_file).st_atime))

                dataArray = read_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep)

                result_tuple = (dataArray[0], dataArray[1], dataArray[2])

                # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔 monitor_file;
                try:
                    os.remove(monitor_file)  # os.unlink(monitor_file) 刪除文檔 monitor_file;
                    # os.listdir(monitor_dir)  # 刷新目錄内容列表
                    # print(os.listdir(monitor_dir))
                except Exception as error:
                    print(f'Error: {monitor_file} : {error.strerror}')
                    # print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
                    if("[WinError 32]" in str(error)):
                        print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + monitor_file)
                        time.sleep(time_sleep)
                        try:
                            # os.unlink(monitor_file) 刪除文檔 monitor_file;
                            os.remove(monitor_file)
                            # os.listdir(monitor_dir)  # 刷新目錄内容列表
                            # print(os.listdir(monitor_dir))
                        except OSError as error:
                            print(f'Error: {monitor_file} : {error.strerror}')
                            print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
                    # else:
                    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
                    #     print(f'Error: {monitor_file} : {error.strerror}')

                # # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
                # if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
                #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
                #     # return monitor_file

                if os.path.exists(output_file) and os.path.isfile(output_file):

                    # multiprocessing.current_process().pid, multiprocessing.current_process().name, threading.current_thread().ident, threading.current_thread().getName()
                    print(str(monitor_file_creat_host) + " " + str(monitor_file_creat_time) + " process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " " + monitor_file + " " + output_file)
                    # print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")) + " process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " " + monitor_file + " " + output_file)
                    # print(str(monitor_dir) + " " + str(os.path.split(monitor_file)[1]) + " " + str(output_dir) + " " + str(os.path.split(output_file)[1]) + " " + str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")))

                    # 運算處理完之後，給調用語言的回復，os.access(to_script, os.X_OK) 判斷脚本文檔是否具有被執行權限;
                    if type(to_executable) == str and to_executable != "" and os.path.exists(to_executable) and os.path.isfile(to_executable) and os.access(to_executable, os.X_OK):
                        if type(to_script) == str and to_script != "" and os.path.exists(to_script) and os.path.isfile(to_script):
                            # node  環境;
                            # test.js  待執行的JS的檔;
                            # %s %s  傳遞給JS檔的參數;
                            # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
                            shell_to = os.popen('%s %s %s %s %s %s' % (to_executable, to_script, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;
                            # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
                            # let arg1 = process.argv[2];  // 解析出JS參數;
                            # let arg2 = process.argv[3];
                        else:
                            shell_to = os.popen('%s %s %s %s %s' % (to_executable, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;

                        # print(shell_to.readlines());
                        response = shell_to.read()  # 取出執行結果
                        # print(response)

        return result_tuple

    def run(self):
        result_tuple = self.start(self.is_monitor, self.read_file_do_Function, self.monitor_file_do_Function, self.monitor_file, self.monitor_dir, self.do_Function, self.number_Worker_process, self.temp_cache_IO_data_dir, self.output_dir, self.output_file, self.to_executable, self.to_script, self.time_sleep, self.total_worker_called_number, self.pool_func, self.initializer, self.pool_call_back, self.error_pool_call_back, self.is_Monitor_Concurrent, self.monitor_file_func, self.monitor_input_queues_func, self.monitor_output_queues_func)
        # print(result_tuple)
        return result_tuple


# # 函數使用示例;
# # 控制臺命令行使用:
# # C:\>C:\Criss\Python\Python38\python.exe C:\Criss\py\src\Interface.py
# # C:\>C:\Criss\py\Scripts\python.exe C:\Criss\py\src\Interface.py
# # 啓動運行;
# # 參數 C:\Criss\py\Scripts\python.exe 表示使用隔離環境 py 中的 python.exe 啓動運行;
# # 使用示例，自定義類 File_Monitor 硬盤文檔監聽看守進程使用説明;
# if __name__ == '__main__':
#     # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
#     try:
#         monitor_dir = os.path.join(os.path.abspath(".."), "temp")  # 需要注意目錄操作權限，用於輸入傳值的媒介目錄;
#         # monitor_dir = pathlib.Path(os.path.abspath("..") + "temp")  # pathlib.Path("../temp/")
#         monitor_file = os.path.join(monitor_dir, "intermediary_write_Node.txt")  # "../temp/intermediary_write_Node.txt" 用於接收傳值的媒介文檔;
#         # os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
#         # os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
#         temp_cache_IO_data_dir = os.path.join(os.path.abspath(".."), "temp")  # 需要注意目錄操作權限，用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
#         number_Worker_process = int(4)  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
#         # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
#         read_file_do_Function = read_and_write_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function;
#         do_Function = do_data  # 用於接收執行功能的函數;
#         do_Function_obj = {
#             "do_Function": do_Function,  # 用於接收執行功能的函數;
#             "read_file_do_Function": read_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function;
#         }
#         output_dir = os.path.join(os.path.abspath(".."), "temp")  # 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
#         output_file = os.path.join(str(output_dir), "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
#         to_executable = os.path.join(os.path.abspath(".."), "NodeJS", "nodejs", "node.exe")  # "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
#         to_script = os.path.join(os.path.abspath(".."), "js", "test.js")  # "../js/test.js" 用於執行功能的被調用的脚步文檔;
#         return_obj = {
#             "output_dir": output_dir,  # os.path.join(os.path.abspath(".."), "/temp/"), "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
#             "output_file": output_file,  # os.path.join(str(return_obj["output_dir"]), "intermediary_write_Python.txt"),  "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
#             "to_executable": to_executable,  # os.path.join(os.path.abspath(".."), "/NodeJS/", "nodejs/node.exe"),  "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
#             "to_script": to_script  # os.path.join(os.path.abspath(".."), "/js/", "test.js"),  "../js/test.js" 用於執行功能的被調用的脚步文檔;
#         }
#         return_obj["output_file"] = os.path.join(return_obj["output_dir"], "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
#         is_monitor = True  # 判斷是只需要執行一次還是啓動監聽服務器，可取值為：True、False;
#         is_Monitor_Concurrent = "Multi-Threading"  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值為：0、"0"、"Multi-Threading"、"Multi-Processes";
#         time_sleep = float(0.02)  # 用於監聽程序的輪詢延遲參數，單位（秒）;

#         # pid = multiprocessing.current_process().pid, threading.current_thread().ident;
#         file_Monitor = File_Monitor(
#             is_monitor=is_monitor,
#             is_Monitor_Concurrent=is_Monitor_Concurrent,
#             monitor_file=monitor_file,
#             monitor_dir=monitor_dir,
#             read_file_do_Function=read_file_do_Function,
#             do_Function=do_Function,
#             # do_Function_obj=do_Function_obj,
#             output_dir=output_dir,
#             output_file=output_file,
#             to_executable=to_executable,
#             to_script=to_script,
#             # return_obj=return_obj,
#             number_Worker_process=number_Worker_process,
#             temp_cache_IO_data_dir=temp_cache_IO_data_dir,
#             time_sleep=time_sleep
#         )
#         # file_Monitor = File_Monitor()
#         result_data = file_Monitor.run()
#         # print(type(result_data))
#         # print(result_data[0])
#         # print(result_data)

#     except Exception as error:
#         print(error)




# # 示例函數，處理從客戶端 GET 或 POST 請求的信息，然後返回處理之後的結果JSON對象字符串數據;
# def do_Request(request_Dict):
#     # request_Dict = {
#     #     "Client_IP": Client_IP,
#     #     "request_Url": request_Url,
#     #     # "request_Path": request_Path,
#     #     "require_Authorization": self.request_Key,
#     #     "require_Cookie": self.Cookie_value,
#     #     # "Server_Authorization": Key,
#     #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
#     #     "request_body_string": request_form_value
#     # }

#     # print(type(request_Dict))
#     # print(request_Dict)

#     request_POST_String = ""  # request_Dict["request_body_string"];  # 客戶端發送 post 請求時的請求體數據;
#     request_Url = ""  # request_Dict["request_Url"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
#     request_Path = ""  # request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
#     request_Url_Query_String = ""  # request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
#     request_Url_Query_Dict = {}  # 客戶端請求 url 中的查詢字符串值解析字典 {"a": 1, "b": 2};
#     request_Authorization = ""  # request_Dict["require_Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
#     request_Cookie = ""  # request_Dict["require_Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
#     request_Key = ""
#     request_Nikename = ""  # request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
#     request_Password = ""  # request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
#     # request_time = ""  # request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
#     # request_Date = ""  # request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
#     request_IP = ""  # request_Dict["Client_IP"];  # 客戶端發送請求的 IP 地址字符串;
#     # request_Method = ""  # request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
#     request_Host = ""  # request_Dict["Host"];  # 客戶端發送請求的服務器主機域名或 IP 地址值字符串 "127.0.0.1"、"localhost";
#     # request_Protocol = ""  # request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "http:"、"https:";
#     request_User_Agent = ""  # request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
#     request_From = ""  # request_Dict["From"];  # 客戶端發送請求的來源值字符串;

#     # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
#     if request_Dict.__contains__("Host"):
#         # print(request_Dict["Host"])
#         request_Host = request_Dict["Host"]
#     if request_Dict.__contains__("request_Url"):
#         # print(request_Dict["request_Url"])
#         request_Url = request_Dict["request_Url"]
#         # request_Url = request_Url.decode('utf-8')
#     # if request_Dict.__contains__("request_Path"):
#     #     # print(request_Dict["request_Path"])
#     #     request_Path = request_Dict["request_Path"]
#     #     # request_Path = request_Path.decode('utf-8')
#     # if request_Dict.__contains__("request_Url_Query_String"):
#     #     # print(request_Dict["request_Url_Query_String"])
#     #     request_Url_Query_String = request_Dict["request_Url_Query_String"]
#     #     # request_Url_Query_String = request_Url_Query_String.decode('utf-8')
#     if request_Dict.__contains__("Client_IP"):
#         # print(request_Dict["Client_IP"])
#         request_IP = request_Dict["Client_IP"]
#     if request_Dict.__contains__("require_Authorization"):
#         # print(request_Dict["require_Authorization"])
#         request_Authorization = request_Dict["require_Authorization"]
#     if request_Dict.__contains__("require_Cookie"):
#         # print(request_Dict["require_Cookie"])
#          request_Cookie = request_Dict["require_Cookie"]
#     if request_Dict.__contains__("request_body_string"):
#         # print(request_Dict["request_body_string"])
#         request_POST_String = request_Dict["request_body_string"]
#         # request_POST_String = request_POST_String.decode('utf-8')
#     # if request_Dict.__contains__("time"):
#     #     print(request_Dict["time"])
#     #     request_time = request_Dict["time"]

#     # # print(request_Authorization)
#     # # 使用請求頭信息「self.headers["Authorization"]」簡單驗證訪問用戶名和密碼，"Basic username:password";
#     # if request_Authorization != None and request_Authorization != "":
#     #     # print("request Headers Authorization: ", request_Authorization)
#     #     # print("request Headers Authorization: ", request_Authorization.split(" ", -1)[0], base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False))
#     #     # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
#     #     # print(type(base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False)))

#     #     # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
#     #     if request_Authorization.find("Basic", 0, int(len(request_Authorization)-1)) != -1 and request_Authorization.split(" ", -1)[0] == "Basic" and len(request_Authorization.split("Basic ", -1)) > 1 and request_Authorization.split("Basic ", -1)[1] != "":
#     #         request_Key = str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
#     #         request_Authorization = "Basic " + str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "Basic username:password";
#     #         request_Nikename = request_Key.split(":", -1)[0]
#     #         request_Password = request_Key.split(":", -1)[1]
#     #     # print(type(request_Key))
#     #     # print(request_Key)

#     # # print(request_Cookie)
#     # # 使用請求頭信息「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼，"Session_ID=request_Key->username:password";
#     # if request_Cookie != None and request_Cookie != "":
#     #     Cookie_value = request_Cookie
#     #     # print("request Headers Cookie: ", self.headers["Cookie"])
#     #     # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
#     #     # request_Key = eval("'" + str(Cookie_value.split("=", -1)[1]) + "'", {'request_Key' : ''})  # exec('request_Key="username:password"', {'request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

#     #     # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
#     #     if Cookie_value.find("=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.find("Session_ID=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.split("=", -1)[0] == "Session_ID":
#     #         Session_ID = str(base64.b64decode(Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
#     #     else:
#     #         Session_ID = str(base64.b64decode(Cookie_value, altchars=None, validate=False), encoding="utf-8")

#     #     # print(type(Session_ID))
#     #     # print(Session_ID)

#     #     request_Key = Session_ID.split("request_Key->", -1)[1]
#     #     request_Cookie = "Session_ID=" + Session_ID  # "Session_ID=request_Key->username:password";
#     #     request_Nikename = request_Key.split(":", -1)[0]
#     #     request_Password = request_Key.split(":", -1)[1]

#     #     # # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
#     #     # if Session_ID != None and Session_ID != "" and type(Session_ID) == str and Session.__contains__(Session_ID) == True and Session[Session_ID] != None:
#     #     #     request_Key = str(Session[Session_ID])
#     #     #     # print(type(request_Key))
#     #     #     # print(request_Key)
#     #     # else:
#     #     #     # request_Key = ":"
#     #     #     request_Key = ""

#     #     # print(type(request_Key))
#     #     # print(request_Key)
#     #     # print(Key)


#     if request_Url != "":
#         if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
#             request_Path = str(request_Url.split("?", -1)[0])
#         elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
#             request_Path = str(request_Url.split("#", -1)[0])
#         else:
#             request_Path = str(request_Url)

#         if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
#             request_Url_Query_String = str(request_Url.split("?", -1)[1])
#             if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
#                 request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])

#     # print(request_Url_Query_String)
#     if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
#         if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
#             # for i in range(0, len(request_Url_Query_String.split("&", -1))):
#             for query_item in request_Url_Query_String.split("&", -1):
#                 if query_item.find("=", 0, int(len(query_item)-1)) != -1:
#                     # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
#                     temp_split_Array = query_item.split("=", -1)
#                     temp_split_value = ""
#                     if len(temp_split_Array) > 1:
#                         for i in range(1, len(temp_split_Array)):
#                             if int(i) == int(1):
#                                 temp_split_value = temp_split_value + str(temp_split_Array[i])
#                             if int(i) > int(1):
#                                 temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
#                     # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
#                     request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
#                 else:
#                     # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
#                     request_Url_Query_Dict[query_item] = ""
#         else:
#             if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
#                 # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
#                 temp_split_Array = request_Url_Query_String.split("=", -1)
#                 temp_split_value = ""
#                 if len(temp_split_Array) > 1:
#                     for i in range(1, len(temp_split_Array)):
#                         if int(i) == int(1):
#                             temp_split_value = temp_split_value + str(temp_split_Array[i])
#                         if int(i) > int(1):
#                             temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
#                 # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
#                 request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
#             else:
#                 # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
#                 request_Url_Query_Dict[request_Url_Query_String] = ""
#     # print(request_Url_Query_Dict)

#     # urllib.parse.urlparse(self.path)
#     # urllib.parse.urlparse(self.path).path
#     # parse_qs(urllib.parse.urlparse(self.path).query)
#     fileName = "";  # "/PythonServer.py" 自定義的待替換的文件路徑全名;
#     algorithmUser = "";  # 使用算法的驗證賬號;
#     algorithmPass = "";  # 使用算法的驗證密碼;
#     algorithmName = "";  # "Fitting"、"Simulation" 具體算法的名稱;
#     global Key  # 變量 Key 為全局變量;
#     # 使用函數 isinstance(request_Url_Query_Dict, dict) 判斷傳入的參數 request_Url_Query_Dict 是否為 dict 字典（JSON）格式對象;
#     if isinstance(request_Url_Query_Dict, dict):
#         # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
#         if (request_Url_Query_Dict.__contains__("fileName")):
#             fileName = str(request_Url_Query_Dict["fileName"])
#         if (request_Url_Query_Dict.__contains__("algorithmUser")):
#             algorithmUser = str(request_Url_Query_Dict["algorithmUser"])
#         if (request_Url_Query_Dict.__contains__("algorithmPass")):
#             algorithmPass = str(request_Url_Query_Dict["algorithmPass"])
#         if (request_Url_Query_Dict.__contains__("algorithmName")):
#             algorithmName = str(request_Url_Query_Dict["algorithmName"])
#         if (request_Url_Query_Dict.__contains__("Key")):
#             Key = str(request_Url_Query_Dict["Key"])


#     # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
#     request_data_Dict = {}  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
#     # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
#     # if check_json_format(request_POST_String):
#     #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
#     #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
#     # # print(request_data_Dict)

#     response_data_Dict = {}  # 函數返回值，聲明一個空字典;
#     response_data_String = ""

#     return_file_creat_time = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))
#     # print(return_file_creat_time)

#     response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)};
#     # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)};
#     # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)};
#     # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)};
#     response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)};
#     response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)};
#     # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)};
#     # response_data_Dict["request_Password"] = str(request_Password)  # {"request_Password": str(request_Password)};
#     response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)};
#     # response_data_Dict["Server_Authorization"] = str(key)  # "username:password"，{"Server_Authorization": str(key)};
#     response_data_Dict["Server_say"] = str(request_POST_String)  # {"Server_say": str(request_POST_String)};
#     response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)};
#     # print(response_data_Dict)

#     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
#     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
#     # 使用加號（+）拼接字符串;
#     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
#     # print(response_data_String)

#     # # webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
#     # web_path = "";  # str(os.path.join(os.path.abspath("."), str(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;

#     return response_data_String


# # http_Server_「http.server」
# # https://docs.python.org/3/library/http.server.html
# # https://chk668.blog.csdn.net/article/details/81979518
# # This class will handles any incoming request from the browser. 自定義類處理http請求;
# # 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
# # webPath = os.path.join(str(os.path.abspath(".")), 'html')  # "C:/Criss/py/src/html/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
# host = "::0"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
# port = int(10001)  # 監聽埠號
# # monitoring = (host, port)
# Is_multi_thread = ""  # True
# Key = ""  # "username:password"
# Session = {}  # {"request_Key->username:password":Key}
# # do_Function_obj = {}  # {"do_Function":do_Request}
# # 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# # print(type(sys.argv))
# # print(sys.argv)
# if len(sys.argv) > 1:
#     for i in range(len(sys.argv)):
#         # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
#         if i > 0:
#             # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
#             if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:
#                 # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
#                 if sys.argv[i].split("=", -1)[0] == "webPath":
#                     webPath = str(sys.argv[i].split("=", -1)[1])  # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
#                     # print("webPath:", webPath)
#                     continue
#                 # http 服務器監聽的IP地址 host = "0.0.0.0";
#                 if sys.argv[i].split("=", -1)[0] == "host":
#                     host = sys.argv[i].split("=", -1)[1]  # http 服務器監聽的IP地址 host = "0.0.0.0";
#                     # print("host:", host)
#                     continue
#                 # http 服務器監聽的埠號 port = int(8000);
#                 elif sys.argv[i].split("=", -1)[0] == "port":
#                     port = int(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的埠號 port = int(8000);
#                     # print("port:", port)
#                     continue
#                 # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
#                 elif sys.argv[i].split("=", -1)[0] == "Is_multi_thread":
#                     Is_multi_thread = bool(sys.argv[i].split("=", -1)[1])  # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
#                     # print("multi thread:", Is_multi_thread)
#                     continue
#                 # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 Key = "username:password";
#                 elif sys.argv[i].split("=", -1)[0] == "Key":
#                     Key = sys.argv[i].split("=", -1)[1]  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
#                     # print("Key:", Key)
#                     continue
#                 # 用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
#                 elif sys.argv[i].split("=", -1)[0] == "Session":
#                     # 使用自定義函數check_json_format(raw_msg)判斷傳入參數sys.argv[1]是否為JSON格式的字符串
#                     if check_json_format(str(sys.argv[i].split("=", -1)[1])):
#                         Session = json.loads(sys.argv[i].split("=", -1)[1], encoding='utf-8')  # 將讀取到的傳入參數字符串轉換爲JSON對象，用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
#                     else:
#                         print("控制臺傳入的 Session 參數 JSON 字符串無法轉換為 JSON 對象: " + sys.argv[i])
#                     # print("Session:", Session)
#                     continue
#                 # else:
#                 #     print(sys.argv[i], "unrecognized.")
#                 #     continue

# Python 自定義類時，類名第一個字母需要大寫，并且不能有參數;
class http_Server:
    # 可變參數
    # def Function(*args, **kwargs)  Function(a, b, c, a=1, b=2, c=3)
    # a --int
    # *args --tuple  args == (a, b, c)
    # **kwargs -- dict  kwargs == {'a': 1, 'b': 2, 'c': 3}

    # 在 Python 類 class 中的 def __init__(self) 函數，可以用於配置需要從類外部傳入的參數，預設會將實例化類時傳入的參數複製到這個函數中，並，在類啓動時先運行一下這個函數;
    def __init__(self, **kwargs):

        # 檢查函數需要用到的 Python 原生模組是否已經載入(import)，如果還沒載入，則執行載入操作;
        imported_package_list = dir(list)
        if not("os" in imported_package_list):
            import os  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("sys" in imported_package_list):
            import sys  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("signal" in imported_package_list):
            import signal  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("stat" in imported_package_list):
            import stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
        if not("platform" in imported_package_list):
            import platform  # 加載Python原生的與平臺屬性有關的模組;
        if not("subprocess" in imported_package_list):
            import subprocess  # 加載Python原生的創建子進程模組;
        if not("string" in imported_package_list):
            import string  # 加載Python原生的字符串處理模組;
        if not("datetime" in imported_package_list):
            import datetime  # 加載Python原生的日期數據處理模組;
        if not("time" in imported_package_list):
            import time  # 加載Python原生的日期數據處理模組;
        if not("json" in imported_package_list):
            import json  # import the module of json. 加載Python原生的Json處理模組;
        if not("re" in imported_package_list):
            import re  # 加載Python原生的正則表達式對象
        # if not("tempfile" in imported_package_list):
        #     import tempfile  # from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
        if not("pathlib" in imported_package_list):
            import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
        # if not("shutil" in imported_package_list):
        #     import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
        if not("multiprocessing" in imported_package_list):
            import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
        if not("threading" in imported_package_list):
            import threading  # 加載Python原生的支持多綫程（執行緒）模組;
        if not("inspect" in imported_package_list):
            import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型，以及用於强制終止綫程;
        if not("ctypes" in imported_package_list):
            import ctypes  # 用於强制終止綫程;
        if not("socketserver" in imported_package_list):
            import socketserver  # from socketserver import ThreadingMixIn  #, ForkingMixIn
        if not("urllib" in imported_package_list):
            import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
        if not("http.client" in imported_package_list):
            import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
        if not("http.server" in imported_package_list):
            # from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
            import http.server
            # https: // docs.python.org/3/library/http.server.html
        if not("cookiejar" in imported_package_list):
            from http import cookiejar  # 用於處理請求Cookie;
        if not("ssl" in imported_package_list):
            import ssl  # 用於處理請求證書驗證;
        if not("base64" in imported_package_list):
            import base64  # 加載加、解密模組;

        # # 檢查函數需要用到的 Python 第三方模組是否已經安裝成功(pip install)，如果還沒安裝，則執行安裝操作;
        # if "os" in dir(list):
        #     installed_package_list = os.popen("pip list").read()
        # if isinstance(installed_package_list, list) and not("Flask" in installed_package_list):
        #     os_popen_read = os.popen("pip install Flask --trusted-host -i https://pypi.tuna.tsinghua.edu.cn/simple").read()
        #     print(os_popen_read)

        # 配置預設值;
        # os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
        # os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
        self.host = "::0"
        self.port = int(8000)  # 監聽埠號 1 ~ 65535;
        self.Is_multi_thread = False
        self.Key = ""  # "username:password"
        self.Session = {}
        self.do_Function = self.temp_default_doFunction  # None 或匿名函數 lambda arguments: arguments
        # 用於判斷監聽創建子進程池數目的參數;
        self.number_Worker_process = int(0)  # 子進程數目默認 0 個;

        # 讀取傳入的服務器主機 IP 參數;
        if "host" in kwargs:
            self.host = str(kwargs["host"])  # "::0" "::1" "localhost" "0.0.0.0" "127.0.0.1"

        # 讀取傳入的服務器監聽端口號碼參數;
        if "port" in kwargs:
            self.port = int(kwargs["port"])  # 8000 監聽埠號 1 ~ 65535;

        # 讀取傳入的判斷監聽服務器是否使用多綫程啓動參數;
        if "Is_multi_thread" in kwargs:
            # True 多綫程啓動服務器，False 單綫程啓動服務器;
            self.Is_multi_thread = bool(kwargs["Is_multi_thread"])

        # 讀取傳入的預設的網站訪問密碼字符串;
        if "Key" in kwargs:
            self.Key = str(kwargs["Key"])  # "username:password" 訪問網站簡單驗證用戶名和密碼;

        # 用於判斷監聽創建子進程池數目的參數  and isinstance(number_Worker_process, str);
        if "number_Worker_process" in kwargs:
            self.number_Worker_process = int(kwargs["number_Worker_process"])  # 子進程數目默認 0 個;

        if "do_Function" in kwargs and inspect.isfunction(kwargs["do_Function"]):
            self.do_Function = kwargs["do_Function"]

        # 具體處理數據的函數;
        # self.do_Function = None
        if "do_Function_obj" in kwargs and isinstance(kwargs["do_Function_obj"], dict) and any(kwargs["do_Function_obj"]):
            # isinstance(do_Function_obj, dict) type(do_Function_obj) == dict do_Function_obj != {} any(do_Function_obj)
            for key in kwargs["do_Function_obj"]:
                # isinstance(do_Function_obj[key], FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                if key == "do_Function" and inspect.isfunction(kwargs["do_Function_obj"][key]):
                    self.do_Function = kwargs["do_Function_obj"][key]

        # 傳入服務器 Session 參數;
        # self.Session = {}
        if "Session" in kwargs and isinstance(kwargs["Session"], dict):
            # isinstance(return_obj, dict) type(return_obj) == dict return_obj != {} any(return_obj)
            self.Session = kwargs["Session"]
        elif "Session" in kwargs and isinstance(kwargs["Session"], str) and self.check_json_format(kwargs["Session"]):
            self.Session = json.loads(kwargs["Session"])

        self.total_worker_called_number = {}  # 預設的全局變量，記錄進程池中每個子進程被調用運算具體處理數據的纍加總次數;

    # 預設的可能被推入子進程執行功能的函數，可以在類實例化的時候輸入參數修改;
    def temp_default_doFunction(self, arguments):
        return arguments

    # 自定義封裝的函數check_ip(address)用於判斷是否爲 IP 地址的字符串，並判斷是：IPv6，還是：IPv4;
    def check_ip(self, address):
        """
        用於判斷一個字符串是否符合 IP 地址格式
        :param self:
        :return:
        """
        if isinstance(address, str):  # 首先判斷傳入的參數是否為一個字符串，如果不是直接返回false值
            # IPv6 格式由八組十六進制數字構成，並且每組之間通過符號「:」分隔;
            IPv6_pattern = r'^([A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4}$'
            # IPv4 格式爲四段數字，每段範圍從「0」至「255」，並且通過符號「.」分隔;
            IPv4_pattern = r'^(([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.){3}([1-9]|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])$'
            if re.match(IPv6_pattern, address):
                return "IPv6"
            elif re.match(IPv4_pattern, address):
                return "IPv4"
            else:
                return False
        else:
            return False

    # 自定義封裝的函數check_json_format(raw_msg)用於判斷是否為JSON格式的字符串;
    def check_json_format(self, raw_msg):
        """
        用於判斷一個字符串是否符合 JSON 格式
        :param self:
        :return:
        """
        if isinstance(raw_msg, str):  # 首先判斷傳入的參數是否為一個字符串，如果不是直接返回false值
            try:
                json.loads(raw_msg)  # , encoding='utf-8'
                return True
            except ValueError:
                return False
        else:
            return False

    # 進程池中的執行函數;
    def pool_func(self, request_data_JSON, do_Function):
        # request_data_JSON == {
        #     "Client_IP": Client_IP,
        #     "request_Url": request_Url,
        #     # "request_Path": request_Path,
        #     "require_Authorization": self.request_Key,
        #     "require_Cookie": self.Cookie_value,
        #     # "Server_Authorization": Key,
        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
        #     "request_body_string": request_form_value
        # }
        # print(type(request_data_JSON))
        # print(request_data_JSON)

        Client_IP = request_data_JSON["Client_IP"]
        request_Url = request_data_JSON["request_Url"]
        # request_Url = request_Url.decode('utf-8')
        # request_Path = request_data_JSON["request_Path"]
        # request_Path = request_Path.decode('utf-8')
        require_Authorization = request_data_JSON["require_Authorization"]
        require_Cookie = request_data_JSON["require_Cookie"]
        # Server_Authorization = request_data_JSON["Server_Authorization"]
        request_body_string = request_data_JSON["request_body_string"]
        # request_body_string = request_body_string.decode('utf-8')

        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
        if do_Function != None and hasattr(do_Function, '__call__'):
            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
            do_Function_return = do_Function(request_data_JSON)  # 最終發送的響應體字符串;

            if isinstance(do_Function_return, dict):
                # print("子進程函數 do_Function() 處理數據的返回值是一個 JSON 對象，不符合 http 協議傳送的合法類型字符串.")
                # response_Body_String = json.dumps(do_Function_return)  # 最終發送的響應體字符串;
                # # check_json_format(response_Body_JSON);
                # # String = json.dumps(JSON); JSON = json.loads(String);
                response_Body_String = request_body_string  # 最終發送的響應體字符串;

            elif isinstance(do_Function_return, str):
                response_Body_String = do_Function_return

            else:
                print("子進程函數 do_Function() 處理數據的返回值無法識別.")
                response_Body_JSON = {
                    "Client_IP": Client_IP,  # 127.0.0.1
                    "request_Url": request_Url,  # "/"
                    # "request_Path": request_Path,  # "/"
                    "require_Authorization": require_Authorization,  # "username:password",
                    "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                    # "Server_Authorization": Server_Authorization,  # "username:password",
                    "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                    "Server_say": do_Function_return
                }
                # check_json_format(response_Body_JSON);
                # String = json.dumps(JSON); JSON = json.loads(String);
                response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                # return do_Function_return  
                  
        else:
            # response_Body_JSON = {
            #     "Client_IP": Client_IP,  # 127.0.0.1
            #     "request_Url": request_Url,  # "/"
            #     # "request_Path": request_Path,  # "/"
            #     "require_Authorization": require_Authorization,  # "username:password",
            #     "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
            #     # "Server_Authorization": Server_Authorization,  # "username:password",
            #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
            #     "Server_say": request_body_string
            # }
            # # check_json_format(response_Body_JSON);
            # # String = json.dumps(JSON); JSON = json.loads(String);
            # response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
            response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;
    
        result_JSON = {
            "process_pid": multiprocessing.current_process().pid,  # 推入該次調用子進程的 pid 號碼;
            "thread_ident": threading.current_thread().ident,  # 推入該次調用子進程中執行緒的 id 號碼;
            "response_Body_String": response_Body_String
        }

        return result_JSON

    # 子進程中的初始化預設值（默認值）配置函數;
    def initializer(self):
        """Ignore SIGINT in child workers. 忽略子進程中的信號."""
        # 忽略子進程中的信號，不然鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，會報 Traceback (most recent call last) 和 KeyboardInterrupt 的錯誤;
        # 忽略子進程中的信號，不然鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，會報 Traceback (most recent call last) 和 KeyboardInterrupt 的錯誤;
        signal.signal(signal.SIGINT, signal.SIG_IGN)

    # 自定義的，進程池啓動子進程時用於引用的回調函數 apply_async_func_return = pool.apply_async(func=read_file_do_Function, args=(input_queues_array[0][monitor_file], input_queues_array[0][monitor_dir], do_Function, input_queues_array[0][output_dir], input_queues_array[0][output_file], input_queues_array[0][to_executable], input_queues_array[0][to_script]), callback=cb)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
    def pool_call_back(self, apply_async_func_return):

        # if isinstance(apply_async_func_return, dict):
        #     # apply_async_func_return = apply_async_func_return.get(timeout=None)
        #     # 判斷某個JSON對象中是否存在某個key值，使用：JSON.has_key(key) 或者 key in JSON 方法;
        #     if "response_Body_String" in apply_async_func_return:
        #         response_Body_String = apply_async_func_return["response_Body_String"]
        #     else:
        #         print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["response_Body_String"] 無法識別.')
        #         response_Body_String = json.dumps(apply_async_func_return)
        #         # response_Body_String = request_body_string

        #     if "process_pid" in apply_async_func_return:
        #         processing_return_pid = apply_async_func_return["process_pid"]
        #     else:
        #         print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["process_pid"] 無法識別.')
        #         processing_return_pid = ""

        #     if "thread_ident" in apply_async_func_return:
        #         processing_return_thread_ident = apply_async_func_return["thread_ident"]
        #     else:
        #         print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["thread_ident"] 無法識別.')
        #         processing_return_thread_ident = ""

        # elif isinstance(apply_async_func_return, str):
        #     print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
        #     response_Body_String = apply_async_func_return
        #     processing_return_pid = ""
        #     processing_return_thread_ident = ""
        #     # return apply_async_func_return

        # else:
        #     print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
        #     response_Body_JSON = {
        #         "Client_IP": Client_IP,  # 127.0.0.1
        #         "request_Url": request_Url,  # "/"
        #         # "request_Path": request_Path,  # "/"
        #         "require_Authorization": require_Authorization,  # "username:password",
        #         "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
        #         # "Server_Authorization": Server_Authorization,  # "username:password",
        #         "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
        #         "Server_say": apply_async_func_return
        #     }
        #     # check_json_format(response_Body_JSON);
        #     # String = json.dumps(JSON); JSON = json.loads(String);
        #     response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
        #     # response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;
        #     processing_return_pid = ""
        #     processing_return_thread_ident = ""
        #     # return apply_async_func_return

        # # 記錄每個被調用的子進程的纍加總次數;
        # if isinstance(total_worker_called_number, dict):
        #     if str(processing_return_pid) in total_worker_called_number:
        #         # isinstance(total_worker_called_number, dict) and str(apply_async_func_return.get(timeout=None)[1]) in total_worker_called_number
        #         total_worker_called_number[str(processing_return_pid)] = int(total_worker_called_number[str(processing_return_pid)]) + int(1)
        #     else:
        #         total_worker_called_number[str(processing_return_pid)] = int(1)

        # return (response_Body_String, processing_return_pid)
        return apply_async_func_return

    # 自定義的，進程池子進程運行出現異常時的回調函數;
    def error_pool_call_back(self, error):
        print(error)
        return error

    def Server(self, host, port, Is_multi_thread, Key, Session, do_Function, number_Worker_process, process_Pool, pool_func, pool_call_back, error_pool_call_back, total_worker_called_number):

        # 服務器接收到請求信息後的執行函數;
        def dispatch_func(request_data_JSON, do_Function):
            # request_data_JSON == {
            #     "Client_IP": Client_IP,
            #     "request_Url": request_Url,
            #     # "request_Path": request_Path,
            #     "require_Authorization": self.request_Key,
            #     "require_Cookie": self.Cookie_value,
            #     # "Server_Authorization": Key,
            #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
            #     "request_body_string": request_form_value
            # }

            # print(type(request_data_JSON))
            # print(request_data_JSON)

            request_Url = request_data_JSON["request_Url"]
            # request_Url = request_Url.decode('utf-8')
            # request_Path = request_data_JSON["request_Path"]
            # request_Path = request_Path.decode('utf-8')
            Client_IP = request_data_JSON["Client_IP"]
            require_Authorization = request_data_JSON["require_Authorization"]
            require_Cookie = request_data_JSON["require_Cookie"]
            # Server_Authorization = request_data_JSON["Server_Authorization"]
            request_body_string = request_data_JSON["request_body_string"]
            # request_body_string = request_body_string.decode('utf-8')

            if number_Worker_process > 0 and process_Pool != None:
                # 函數 process_Pool.apply_async(func=, args=(,), kwds={}, callback=, error_callback=) 中的執行函數 func 和 callback 只能接受最外層的函數，不能是嵌套的内層函數;
                apply_async_func_return = process_Pool.apply_async(func=pool_func, args=(request_data_JSON, do_Function), kwds={}, callback=pool_call_back, error_callback=error_pool_call_back)  # callback 是回調函數，預設值為 None，入參是 func 函數的返回值;
                # args == (
                #     request_data_JSON == {
                #         "Client_IP": Client_IP,
                #         "request_Url": request_Url,
                #         # "request_Path": request_Path,
                #         "require_Authorization": self.request_Key,
                #         "require_Cookie": self.Cookie_value,
                #         # "Server_Authorization": Key,
                #         "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                #         "request_body_string": request_form_value
                #     },
                #     do_Function
                # )
                # print(apply_async_func_return.get(timeout=None))
                # print(apply_async_func_return.ready())
                # print(apply_async_func_return.successful())

                Data_JSON = apply_async_func_return.get(timeout=None)

                if isinstance(Data_JSON, dict):
                    # Data_JSON = apply_async_func_return.get(timeout=None)
                    # 判斷某個JSON對象中是否存在某個key值，使用：JSON.has_key(key) 或者 key in JSON 方法;
                    if "response_Body_String" in Data_JSON:
                        response_Body_String = Data_JSON["response_Body_String"]
                    else:
                        print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["response_Body_String"] 無法識別.')
                        response_Body_String = json.dumps(Data_JSON)
                        # response_Body_String = request_body_string

                    if "process_pid" in Data_JSON:
                        processing_return_pid = Data_JSON["process_pid"]
                    else:
                        print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["process_pid"] 無法識別.')
                        processing_return_pid = ""

                    if "thread_ident" in Data_JSON:
                        processing_return_thread_ident = Data_JSON["thread_ident"]
                    else:
                        print('子進程函數 do_Function() 處理數據的返回值 JSON 對象中的鍵值 ["thread_ident"] 無法識別.')
                        processing_return_thread_ident = ""

                elif isinstance(Data_JSON, str):
                    print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
                    response_Body_String = Data_JSON
                    processing_return_pid = ""
                    processing_return_thread_ident = ""
                    # return apply_async_func_return

                else:
                    print('子進程函數 do_Function() 處理數據的返回值不是 JSON 對象 \{"process_pid": value, "thread_ident": value, "response_Body_String": value\}.')
                    response_Body_JSON = {
                        "Client_IP": Client_IP,  # 127.0.0.1
                        "request_Url": request_Url,  # "/"
                        # "request_Path": request_Path,  # "/"
                        "require_Authorization": require_Authorization,  # "username:password",
                        "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                        # "Server_Authorization": Server_Authorization,  # "username:password",
                        "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        "Server_say": Data_JSON
                    }
                    # check_json_format(response_Body_JSON);
                    # String = json.dumps(JSON); JSON = json.loads(String);
                    response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                    # response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;
                    processing_return_pid = ""
                    processing_return_thread_ident = ""
                    # return apply_async_func_return

                # 記錄每個被調用的子進程的纍加總次數;
                if isinstance(total_worker_called_number, dict):
                    if str(processing_return_pid) in total_worker_called_number:
                        # isinstance(total_worker_called_number, dict) and str(apply_async_func_return.get(timeout=None)[1]) in total_worker_called_number
                        total_worker_called_number[str(processing_return_pid)] = int(total_worker_called_number[str(processing_return_pid)]) + int(1)
                    else:
                        total_worker_called_number[str(processing_return_pid)] = int(1)

            if number_Worker_process <= 0 or process_Pool == None:

                # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                if do_Function != None and hasattr(do_Function, '__call__'):
                    # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                    # response_Body_String = do_Function(request_data_JSON)  # 最終發送的響應體字符串;
                    # processing_return_pid = multiprocessing.current_process().pid

                    do_Function_return = do_Function(request_data_JSON)  # 最終發送的響應體字符串;
                    if isinstance(do_Function_return, dict):
                        # print("子進程函數 do_Function() 處理數據的返回值是一個 JSON 對象，不符合 http 協議能夠傳送的合法類型字符串.")
                        # response_Body_String = json.dumps(do_Function_return)  # 最終發送的響應體字符串;
                        # # check_json_format(response_Body_JSON);
                        # # String = json.dumps(JSON); JSON = json.loads(String);
                        response_Body_String = request_body_string  # 最終發送的響應體字符串;

                    elif isinstance(do_Function_return, str):
                        response_Body_String = do_Function_return

                    else:
                        print("子進程函數 do_Function() 處理數據的返回值無法識別.")
                        response_Body_JSON = {
                            "Client_IP": Client_IP,  # 127.0.0.1
                            "request_Url": request_Url,  # "/"
                            # "request_Path": request_Path,  # "/"
                            "require_Authorization": require_Authorization,  # "username:password",
                            "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                            # "Server_Authorization": Server_Authorization,  # "username:password",
                            "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                            "Server_say": do_Function_return
                        }
                        # check_json_format(response_Body_JSON);
                        # String = json.dumps(JSON); JSON = json.loads(String);
                        response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                        # return do_Function_return

                else:
                    # response_Body_JSON = {
                    #     "Client_IP": Client_IP,  # 127.0.0.1
                    #     "request_Url": request_Url,  # "/"
                    #     # "request_Path": request_Path,  # "/"
                    #     "require_Authorization": require_Authorization,  # "username:password",
                    #     "require_Cookie": require_Cookie,  # "Session_ID=request_Key->username:password",
                    #     # "Server_Authorization": Server_Authorization,  # "username:password",
                    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                    #     "Server_say": request_body_string
                    # }
                    # # check_json_format(response_Body_JSON);
                    # # String = json.dumps(JSON); JSON = json.loads(String);
                    # response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;
                    response_Body_String = request_body_string  # 原樣返回，將JOSN對象轉換為JSON字符串;

                processing_return_pid = multiprocessing.current_process().pid
                processing_return_thread_ident = threading.current_thread().ident

                # 記錄每個被調用的子進程的纍加總次數;
                if isinstance(total_worker_called_number, dict):
                    if str(processing_return_pid) in total_worker_called_number:
                        # isinstance(total_worker_called_number, dict) and str(apply_async_func_return.get(timeout=None)[1]) in total_worker_called_number
                        total_worker_called_number[str(processing_return_pid)] = int(total_worker_called_number[str(processing_return_pid)]) + int(1)
                    else:
                        total_worker_called_number[str(processing_return_pid)] = int(1)

            return (response_Body_String, processing_return_pid)

        # BaseHTTPRequestHandler 官網源碼: https://github.com/python/cpython/blob/3.6/Lib/http/server.py
        class Resquest(BaseHTTPRequestHandler):

            request_Accept = ""
            response_Content_Type = "text/html; charset=utf-8"  # 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';
            request_Key = ""
            Cookie_value = ""
            Session_ID = ""
            response_Body_String_len = 0
            processing_return_pid = multiprocessing.current_process().pid

            # # BaseHTTPRequestHandler.handle(self)
            # def handle(self):
            #     """
            #     Handle multiple requests if necessary.
            #     """
            #     self.close_connection = True
            #     self.handle_one_request()
            #     while not self.close_connection:
            #         self.handle_one_request()

            # # BaseHTTPRequestHandler.handle_one_request(self)
            # def handle_one_request(self):
            #     """
            #     Handle a single HTTP request.
            #     You normally don't need to override this method; see the class __doc__ string for information on how to handle specific HTTP commands such as GET and POST.
            #     """
            #     try:
            #         self.raw_requestline = self.rfile.readline(65537)
            #         if len(self.raw_requestline) > 65536:
            #             self.requestline = ''
            #             self.request_version = ''
            #             self.command = ''
            #             self.send_error(HTTPStatus.REQUEST_URI_TOO_LONG)
            #             return
            #         if not self.raw_requestline:
            #             self.close_connection = True
            #             return
            #         if not self.parse_request():
            #             # An error code has been sent, just exit
            #             return
            #         mname = 'do_' + self.command
            #         if not hasattr(self, mname):
            #             self.send_error(HTTPStatus.NOT_IMPLEMENTED, "Unsupported method (%r)" % self.command)
            #             return
            #         method = getattr(self, mname)
            #         method()
            #         self.wfile.flush() #actually send the response if not already done.
            #     except socket.timeout as e:
            #         #a read or a write timed out.  Discard this connection
            #         self.log_error("Request timed out: %r", e)
            #         self.close_connection = True
            #         return

            # BaseHTTPRequestHandler.log_message(self, format, *args)
            def log_message(self, format, *args):
                """
                Log an arbitrary message.
                This is used by all other logging functions.  Override it if you have specific logging wishes.
                The first argument, FORMAT, is a format string for the message to be logged.  If the format string contains any % escapes requiring parameters, they should be specified as subsequent arguments (it's just like printf!).
                The client ip and current date/time are prefixed to every message.
                """
                # log_text = "Main process-" + str(multiprocessing.current_process().pid) + " listening server Worker thread-" + str(threading.current_thread().ident) + " doFunction Worker process-" + str(self.processing_return_pid) + " " + "%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), format % args)
                log_text = "listening server Worker thread-" + str(threading.current_thread().ident) + " doFunction Worker process-" + str(self.processing_return_pid) + " " + "%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), format % args)
                # sys.stderr.write("%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), format%args))
                sys.stderr.write(log_text)
                # print(log_text)

            # 配置多綫程響應監聽到的請求;
            # def process_request_thread(self, request, client_address):
            #     try:
            #         self.finish_request(request, client_address)
            #         self.shutdown_request(request)
            #     except:
            #         self.handle_error(request, client_address)
            #         self.shutdown_request(request)

            # def process_request(self, request, client_address):
            #     thread = threading.Thread(target=self.process_request_thread, args=(request, client_address))
            #     thread.daemon = True
            #     # threadName = thread.getName()  # 返回綫程thread的名字;
            #     # # threads.append(thread)  # 添加綫程thread到綫程列表threads;
            #     thread.start()

            # 配通過密碼驗證之後置響應頭;
            def do_HEAD(self):
                # print("response verified Header:")

                request_Path = ""
                request_Url_Query_String = ""
                request_Url = ""

                request_Url = self.path  # 客戶端請求 URL 字符串值;
                # print(request_Url)

                if request_Url != "":
                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("?", -1)[0])
                    elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("#", -1)[0])
                    else:
                        request_Path = str(request_Url)
                    # print(request_Path)

                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Url_Query_String = str(request_Url.split("?", -1)[1])
                        if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                            request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])
                    # print(request_Url_Query_String)

                request_Url_Query_Dict = {}
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

                # print(self.headers['Accept'])
                if self.headers['Accept'] != None:
                    request_Accept = self.headers['Accept']
                    if self.headers['Accept'] == "":
                        response_Content_Type = "text/html; charset=utf-8"
                    elif self.headers['Accept'].find("text/html", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "text/html; charset=utf-8"
                    elif self.headers['Accept'].find("text/javascript", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "text/javascript; charset=utf-8"
                    elif self.headers['Accept'].find("text/css", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "text/css; charset=utf-8"
                    elif self.headers['Accept'].find("application/octet-stream", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "application/octet-stream; charset=utf-8"
                    else:
                        response_Content_Type = self.headers['Accept']  # 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';
                if self.headers['Accept'] == None:
                    response_Content_Type = "text/html; charset=utf-8"  # 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';

                statusMessage_CN = "請求成功"
                statusMessage_EN = "OK."
                statusMessage = str(base64.b64encode(bytes(statusMessage_CN, encoding="utf-8"), altchars=None), encoding="utf-8") + " " + statusMessage_EN
                self.send_response(200, message=statusMessage)  # , message=None;
                # self.send_header('Www-Authenticate', 'Basic realm=\"domain name -> username:password\"')  # 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                self.send_header("Allow", "GET, POST, HEAD, PATCH")  # 服務器能接受的請求方式;
                # 服務器發送響應數據的類型及編碼方式
                self.send_header('Content-Type', response_Content_Type)  # self.send_header('Content-Type', 'text/html, text/plain; charset=utf-8') # 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';
                self.send_header('Content-Length', self.response_Body_String_len)  # 服務器發送的響應數據長度 response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                self.send_header('Content-Language', 'zh-Hant-TW; q=0.8, zh-Hant; q=0.7, zh-Hans-CN; q=0.7, zh-Hans; q=0.5, en-US, en; q=0.3')  # 服務器發送響應的自然語言類型;
                # self.send_header('Content-Encoding', 'gzip')  # 服務器發送響應的壓縮類型;
                # self.send_header('Expires', '100-continue header')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Cache-Control', 'no-cache')  # 'max-age=0' 或 no-store, must-revalidate 設置不允許瀏覽器緩存，必須刷新數據;
                # self.send_header('Pragma', 'no-cache')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Connection', 'close')  # 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                server_info = "Python_http.server(HTTPServer+BaseHTTPRequestHandler)"
                # server_info = "Python " + str(platform.python_version()) + "_http.server(HTTPServer+BaseHTTPRequestHandler)_" + str(platform.system())  # platform.platform()，platform.python_compiler() 獲取當前 Python 解釋器的信息;
                # print(server_info)
                self.send_header('Server', server_info)  # web 服務器名稱版本信息;
                # self.send_header('Refresh', '1;url=http://localhost:8000/')  # 服務端要求客戶端1秒鐘後刷新頁面，然後訪問指定的頁面路徑;
                # self.send_header('Content-Disposition', 'attachment; filename=Test.zip')  # 服務端要求客戶端以下載文檔的方式打開該文檔;
                # self.send_header('Transfer-Encoding', 'chunked')  # 以數據流形式分塊發送響應數據到客戶端;
                # self.send_header('Date', datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 服務端向客戶端返回響應的時間;
                self.send_header("Access-Control-Allow-Methods", "GET, POST, HEAD, PATCH")
                # self.send_header('Access-Control-Allow-Origin', 'http://[' + host + ']:' + str(port) + ',' + 'https://[' + host + ']:' + str(port))  # 設置允許跨域訪問;
                self.send_header('Access-Control-Allow-Origin', '*')  # 設置允許跨域訪問;
                self.send_header('Access-Control-Allow-Headers', 'content-type, Accept')
                self.send_header('Access-Control-Allow-Credentials', 'true')
                # self.send_header('Content-MD5', 'Q2hlY2sgSW50ZWdyaXR5IQ==')  # 返回實體 MD5 加密的校驗值;
                # Set-Cookie:name=value [ ;expires=date][ ;domain=domain][ ;path=path][ ;secure];
                # 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
                # 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
                # 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
                # 參數value部分，通常是一個name = value格式的字串，通常性的使用方式是以name = value的格式來指定cookie的值；
                # 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
                after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")  # 計算 30 日之後的日期;
                # print(after_30_Days)  # 打印30天之後的日期 datetime.datetime.now().date().strftime("%Y-%m-%d %H:%M:%S.%f")，datetime.date.today();
                cookieName = 'Session_ID=' + str(base64.b64encode(bytes('request_Key->' + str(self.request_Key), encoding="utf-8"), altchars=None), encoding="utf-8")
                # cookie_string = 'session_id=' + str(self.request_Key.split(":", -1)[0], encoding="utf-8") + ',request_Key->' + str(self.request_Key, encoding="utf-8") + '; expires=' + str(after_30_Days, encoding="utf-8") + '; domain=abc.com; path=/; HTTPOnly;'  # 拼接 cookie 字符串值;
                cookie_string = cookieName + '; expires=' + str(after_30_Days) + '; path=/;'  # 拼接 cookie 字符串值;
                # print(cookie_string)
                self.send_header('Set-Cookie', cookie_string)  # 設置 Cookie;
                self.end_headers()

            # 配置未驗證之前的響應頭（發送驗證賬號密碼輸入框）;
            def do_AUTHHEAD(self):
                # print("response verifying Header:")

                request_Path = ""
                request_Url_Query_String = ""
                request_Url = ""

                request_Url = self.path  # 客戶端請求 URL 字符串值;
                # print(request_Url)

                if request_Url != "":
                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("?", -1)[0])
                    elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("#", -1)[0])
                    else:
                        request_Path = str(request_Url)
                    # print(request_Path)

                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Url_Query_String = str(request_Url.split("?", -1)[1])
                        if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                            request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])
                    # print(request_Url_Query_String)

                request_Url_Query_Dict = {}
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

                # print(self.headers['Accept'])
                if self.headers['Accept'] != None:
                    request_Accept = self.headers['Accept']
                    if self.headers['Accept'] == "":
                        response_Content_Type = "text/html; charset=utf-8"
                    elif self.headers['Accept'].find("text/html", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "text/html; charset=utf-8"
                    elif self.headers['Accept'].find("text/javascript", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "text/javascript; charset=utf-8"
                    elif self.headers['Accept'].find("text/css", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "text/css; charset=utf-8"
                    elif self.headers['Accept'].find("application/octet-stream", 0, int(len(self.headers['Accept'])-1)) != -1:
                        response_Content_Type = "application/octet-stream; charset=utf-8"
                    else:
                        response_Content_Type = self.headers['Accept']  # 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';
                if self.headers['Accept'] == None:
                    response_Content_Type = "text/html; charset=utf-8"  # 'application/octet-stream, text/plain, text/html, text/javascript, text/css, image/jpeg, image/svg+xml, image/png; charset=utf-8';

                statusMessage_CN = "服務器要求客戶端身份驗證出具賬號密碼"
                statusMessage_EN = "Unauthorized."
                statusMessage = str(base64.b64encode(bytes(statusMessage_CN, encoding="utf-8"), altchars=None), encoding="utf-8") + " " + statusMessage_EN
                self.send_response(401, message=statusMessage)  # , message=None;
                self.send_header('Www-Authenticate', 'Basic realm=\"domain name -> username:password\"')  # 告訴客戶端應該在請求頭Authorization中提供什麽類型的身份驗證信息;
                self.send_header("Allow", "GET, POST, HEAD, PATCH")  # 服務器能接受的請求方式;
                self.send_header('Content-Type', response_Content_Type)  # 服務器發送響應數據的類型及編碼方式
                self.send_header('Content-Length', self.response_Body_String_len)  # 服務器發送的響應數據長度 response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                self.send_header('Content-Language', 'zh-tw,zh-cn,en-us; q=0.9')  # 服務器發送響應的自然語言類型;
                self.send_header('Content-Encoding', 'gzip')  # 服務器發送響應的壓縮類型;
                self.send_header('Expires', '100-continue header')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Cache-Control', 'no-cache')  # 'max-age=0' 或 no-store, must-revalidate 設置不允許瀏覽器緩存，必須刷新數據;
                # self.send_header('Pragma', 'no-cache')  # 服務端禁止客戶端緩存頁面數據;
                self.send_header('Connection', 'close')  # 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                server_info = "Python_http.server(HTTPServer+BaseHTTPRequestHandler)"
                # server_info = "Python " + str(platform.python_version()) + "_http.server(HTTPServer+BaseHTTPRequestHandler)_" + str(platform.system())  # platform.platform()，platform.python_compiler() 獲取當前 Python 解釋器的信息;
                # print(server_info)
                self.send_header('Server', server_info)  # web 服務器名稱版本信息;
                # self.send_header('Refresh', '1;url=http://localhost:8000/')  # 服務端要求客戶端1秒鐘後刷新頁面，然後訪問指定的頁面路徑;
                # self.send_header('Content-Disposition', 'attachment; filename=Test.zip')  # 服務端要求客戶端以下載文檔的方式打開該文檔;
                # self.send_header('Transfer-Encoding', 'chunked')  # 以數據流形式分塊發送響應數據到客戶端;
                # self.send_header('Date', datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 服務端向客戶端返回響應的時間;
                self.send_header("Access-Control-Allow-Methods", "GET, POST, HEAD, PATCH")
                self.send_header('Access-Control-Allow-Origin', '*')  # 設置允許跨域訪問;
                self.send_header('Access-Control-Allow-Headers', 'content-type, Accept')
                self.send_header('Access-Control-Allow-Credentials', 'true')
                # self.send_header('Content-MD5', 'Q2hlY2sgSW50ZWdyaXR5IQ==')  # 返回實體 MD5 加密的校驗值;
                # Set-Cookie:name=value [ ;expires=date][ ;domain=domain][ ;path=path][ ;secure];
                # 其中，參數secure選項只是一個標記沒有其它的值，表示一個secure cookie只有當請求是通過SSL和HTTPS創建時，才會發送到伺服器端；
                # 參數domain選項表示cookie作用域，不支持IP數值，只能使用功能變數名稱，指示cookie將要發送到哪個域或那些域中，預設情況下domain會被設置為創建該cookie的頁面所在的功能變數名稱，domain選項被用來擴展cookie值所要發送域的數量；
                # 參數Path選項（The path option），與domain選項相同的是，path指明了在發Cookie消息頭之前，必須在請求資源中存在一個URL路徑，這個比較是通過將path屬性值與請求的URL從頭開始逐字串比較完成的，如果字元匹配，則發送Cookie消息頭；
                # 參數value部分，通常是一個name = value格式的字串，通常性的使用方式是以name = value的格式來指定cookie的值；
                # 通常cookie的壽命僅限於單一的會話中，流覽器的關閉意味這一次會話的結束，所以會話cookie只存在於流覽器保持打開的狀態之下，參數expires選項用於設定這個cookie壽命（有效時長），一個expires選項會被附加到登錄的cookie中指定一個截止日期，如果expires選項設置了一個過去的時間點，那麼這個cookie會被立即刪除；
                after_1_Days = (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%d %H:%M:%S.%f")  # 計算 30 日之後的日期;
                # print(after_1_Days)  # 打印30天之後的日期 datetime.datetime.now().date().strftime("%Y-%m-%d %H:%M:%S.%f")，datetime.date.today();
                cookieName = 'Session_ID=' + str(base64.b64encode(bytes('request_Key->' + str(self.request_Key), encoding="utf-8"), altchars=None), encoding="utf-8")
                # cookie_string = 'session_id=' + str(self.request_Key.split(":", -1)[0], encoding="utf-8") + ',request_Key->' + str(self.request_Key, encoding="utf-8") + '; expires=' + str(after_30_Days, encoding="utf-8") + '; domain=abc.com; path=/; HTTPOnly;'  # 拼接 cookie 字符串值;
                cookie_string = cookieName + '; expires=' + str(after_1_Days) + '; path=/;'  # 拼接 cookie 字符串值;
                # print(cookie_string)
                self.send_header('Set-Cookie', cookie_string)  # 設置 Cookie;
                self.end_headers()

            # Handler for the AJAX-OPTIONS requests;
            def do_OPTIONS(self):
                # print("AJAX-OPTIONS request Header:")
                # print(self.headers)                
                # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                # print("\nrequest Command: ", self.command)  # 打印請求類型 "POST" or "GET";
                # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                # print("request Headers:")
                # print(self.headers)  # 換行打印請求頭;
                # print(type(request_headers))  # 打印請求頭的數據類型;
                # print("request Cookie: ", self.headers["Cookie"])  # 打印客戶端請求頭中的 Cookie 參數值;
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization";
                # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))
                # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                # self.request_Key = str(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                # print(type(self.request_Key))
                # print("request Nikename: [", self.request_Key.split(":", -1)[0], "], request Password: [", self.request_Key.split(":", -1)[1],"].")

                # print("當前進程ID: ", multiprocessing.current_process().pid)
                # print("當前進程名稱: ", multiprocessing.current_process().name)
                # print("當前綫程ID: ", threading.current_thread().ident)
                # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
                # global threads  # 自定義的全局變量綫程列表;
                # threads.append(threading.current_thread())  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;

                # global Key, Session

                # # 配置只接收目標為根目錄 / 的訪問;
                # if self.path != "/":
                #     self.send_error(404, "Page not Found!")
                #     return

                request_Path = ""
                request_Url_Query_String = ""
                request_Url = ""

                request_Url = self.path  # 客戶端請求 URL 字符串值;
                # print(request_Url)

                if request_Url != "":
                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("?", -1)[0])
                    elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("#", -1)[0])
                    else:
                        request_Path = str(request_Url)
                    # print(request_Path)

                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Url_Query_String = str(request_Url.split("?", -1)[1])
                        if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                            request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])
                    # print(request_Url_Query_String)

                request_Url_Query_Dict = {}
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
 
                # print(self.headers.items())
                request_data_JSON = {}
                for key, value in self.headers.items():
                    # request_data_JSON['"' + str(key) + '"'] = value
                    request_data_JSON[str(key)] = value
                # print(request_data_JSON)
                # request_data_JSON = {
                #     "Client_IP": Client_IP,
                #     "request_Url": request_Url,
                #     # "request_Path": request_Path,
                #     "require_Authorization": self.request_Key,
                #     "require_Cookie": self.Cookie_value,
                #     # "Server_Authorization": Key,
                #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                #     "request_body_string": ""
                # }

                request_form_value = ""
                # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                if self.headers['content-length'] != None and self.headers['content-length'] != "" and int(self.headers['content-length']) > 0:
                    # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                    request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')
                # print(request_form_value)

                response_Body_String = request_form_value
                # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                self.do_HEAD()  # 發送響應頭;

                # Send the response body ( html message );
                # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                self.wfile.write(response_Body_String.encode('utf-8'))
                # self.wfile.flush()
                # self.wfile.close()
                return

            # Handler for the GET requests;
            def do_GET(self):
                # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                # print("\nrequest Command: ", self.command)  # 打印請求類型 "POST" or "GET";
                # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                # print("request Headers:")
                # print(self.headers)  # 換行打印請求頭;
                # print(type(request_headers))  # 打印請求頭的數據類型;
                # print("request Cookie: ", self.headers["Cookie"])  # 打印客戶端請求頭中的 Cookie 參數值;
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization";
                # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))
                # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                # self.request_Key = str(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                # print(type(self.request_Key))
                # print("request Nikename: [", self.request_Key.split(":", -1)[0], "], request Password: [", self.request_Key.split(":", -1)[1],"].")

                # print("當前進程ID: ", multiprocessing.current_process().pid)
                # print("當前進程名稱: ", multiprocessing.current_process().name)
                # print("當前綫程ID: ", threading.current_thread().ident)
                # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
                # global threads  # 自定義的全局變量綫程列表;
                # threads.append(threading.current_thread())  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;

                # global Key, Session

                # # 配置只接收目標為根目錄 / 的訪問;
                # if self.path != "/":
                #     self.send_error(404, "Page not Found!")
                #     return

                request_Path = ""
                request_Url_Query_String = ""
                request_Url = ""

                request_Url = str(self.path)  # 客戶端請求 URL 字符串值;
                # print(request_Url)

                if request_Url != "":
                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("?", -1)[0])
                    elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("#", -1)[0])
                    else:
                        request_Path = str(request_Url)
                    # print(request_Path)

                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Url_Query_String = str(request_Url.split("?", -1)[1])
                        if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                            request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])
                    # print(request_Url_Query_String)

                request_Url_Query_Dict = {}
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

                # 提取請求 URL 字符串中的查詢（?）字段中的：key=value 鍵值，或使用請求頭信息「self.headers["Authorization"]」和「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼;
                if isinstance(request_Url_Query_Dict, dict) and len(request_Url_Query_Dict) > 0 and (("key" in request_Url_Query_Dict) or ("Key" in request_Url_Query_Dict) or ("KEY" in request_Url_Query_Dict)):
                    # 提取請求 URL 字符串中的查詢（?）字段中的：key=value 鍵值;

                    # print(len(request_Url_Query_Dict))
                    if len(request_Url_Query_Dict) > 0:
                        # 解析獲取客戶端請求 url 中的賬號密碼 "key" 參數;
                        # self.request_Key = ""
                        # print(request_Url_Query_Dict["Key"])
                        # print("key" in request_Url_Query_Dict)
                        if "key" in request_Url_Query_Dict:
                            # if isinstance(request_Url_Query_Dict["key"], str) and request_Url_Query_Dict["key"].find(":", 0, int(len(request_Url_Query_Dict["key"])-1)) != -1:
                            #     # for i in range(0, len(request_Url_Query_Dict["key"].split(":", -1))):
                                self.request_Key = str(request_Url_Query_Dict["key"])  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                        elif "Key" in request_Url_Query_Dict:
                            self.request_Key = str(request_Url_Query_Dict["Key"])  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                        elif "KEY" in request_Url_Query_Dict:
                            self.request_Key = str(request_Url_Query_Dict["KEY"])  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                        else:
                            # self.request_Key = ":"
                            self.request_Key = ""
                        # print("request url query key: [ " + self.request_Key + " ].")
                    pass
                elif self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                    # 使用請求頭信息「self.headers["Authorization"]」簡單驗證訪問用戶名和密碼;
                    # print("request Headers Authorization: ", self.headers["Authorization"])
                    # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                    # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                    # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))

                    # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
                    if self.headers["Authorization"].find("Basic", 0, int(len(self.headers["Authorization"])-1)) != -1 and self.headers["Authorization"].split(" ", -1)[0] == "Basic" and len(self.headers["Authorization"].split("Basic ", -1)) > 1 and self.headers["Authorization"].split("Basic ", -1)[1] != "":
                        self.request_Key = str(base64.b64decode(self.headers["Authorization"].split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.request_Key = ""
                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    pass
                elif self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                    # 使用請求頭信息「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼;
                    self.Cookie_value = self.headers['Cookie']
                    # print("request Headers Cookie: ", self.headers["Cookie"])
                    # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
                    # self.request_Key = eval("'" + str(self.Cookie_value.split("=", -1)[1]) + "'", {'self.request_Key' : ''})  # exec('self.request_Key="username:password"', {'self.request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

                    # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                    if self.Cookie_value.find("=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.find("Session_ID=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.split("=", -1)[0] == "Session_ID":
                        self.Session_ID = str(base64.b64decode(self.Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.Session_ID = str(base64.b64decode(self.Cookie_value, altchars=None, validate=False), encoding="utf-8")

                    # print(type(self.Session_ID))
                    # print(self.Session_ID)

                    # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / self.Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
                    if self.Session_ID != None and self.Session_ID != "" and type(self.Session_ID) == str and Session.__contains__(self.Session_ID) == True and Session[self.Session_ID] != None:
                        self.request_Key = str(Session[self.Session_ID])
                        # print(type(self.request_Key))
                        # print(self.request_Key)
                    else:
                        # self.request_Key = ":"
                        self.request_Key = ""

                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    # print(Key)
                    pass
                else:
                    # self.request_Key = ":"
                    self.request_Key = ""

                    if Key != "":

                        response_data = {
                            "Server_say": "No request Headers Authorization or Cookie received.",
                            "require_Authorization": Key
                        }
                        response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                        # self.send_header('Content-Length', len(bytes(response_data, "utf-8")))
                        self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                        self.do_AUTHHEAD()
                        self.wfile.write(response_data.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                # 判斷字符串中是否包含指定字符，也可以是用 "char" in String 語句判斷，判斷客戶端傳入的請求頭中Authorization參數值中是否包含 ":" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                if self.request_Key != "" and self.request_Key.find(":", 0, int(len(self.request_Key)-1)) != -1:
                    request_Nikename = self.request_Key.split(":", -1)[0]
                    request_Password = self.request_Key.split(":", -1)[1]
                    # print("request Nikename: [ ", self.request_Key.split(":", -1)[0], " ], request Password: [ ", self.request_Key.split(":", -1)[1]," ].")
                else:
                    request_Nikename = self.request_Key
                    request_Password = ""


                if Key != "" and (request_Nikename != Key.split(":", -1)[0] or request_Password != Key.split(":", -1)[1]):

                    response_data = {
                        "Server_say": "request Header Authorization [ " + request_Nikename + " ] not authenticated.",
                        "require_Authorization": Key
                    }
                    response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                    self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                    self.do_AUTHHEAD()
                    self.wfile.write(response_data.encode('utf-8'))
                    # self.wfile.flush()
                    # self.wfile.close()
                    return

                else:

                    # 路由，判斷請求URL字符串，如果請求的URL是："/"，則做如下處理;
                    if self.path == "/":
                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)
 
                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        #     "request_body_string": ""
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        # request_data_JSON["request_body_string"] = str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        request_data_JSON["request_body_string"] = ""
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                                "request_body_string": "",
                                "Server_say": "GET method require successful."
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # request_data_JSON = {
                        #     "Client_say": "Browser GET request test."
                        # }
                        # # print("Client say: ", request_data_JSON)

                        # response_Body_JSON = {
                        #     "request Nikename": request_Nikename,
                        #     "request Passwork": request_Password,
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    elif self.path == "/index.html":
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)
 
                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        #     "request_body_string": ""
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        # request_data_JSON["request_body_string"] = str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        request_data_JSON["request_body_string"] = ""
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                                "Server_say": "GET method require successful."
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # request_data_JSON = {
                        #     "Client_say": "Browser GET request test."
                        # }
                        # # print("Client say: ", request_data_JSON)

                        # response_Body_JSON = {
                        #     "request Nikename": request_Nikename,
                        #     "request Passwork": request_Password,
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    else:
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)
 
                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        #     "request_body_string": ""
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        # request_data_JSON["request_body_string"] = str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                        request_data_JSON["request_body_string"] = ""
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # "request_body_string": str(Client_IP) + " " + str(request_Url) + " " + str(self.request_Key) + " " + str(self.Cookie_value)
                                "request_body_string": "",
                                "Server_say": "GET method require successful."
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # request_data_JSON = {
                        #     "Client_say": "Browser GET request test."
                        # }
                        # # print("Client say: ", request_data_JSON)

                        # response_Body_JSON = {
                        #     "request Nikename": request_Nikename,
                        #     "request Passwork": request_Password,
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

            # Handler for the POST requests;
            def do_POST(self):
                # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                # print("\nrequest Command: ", self.command)  # 打印請求類型 "POST" or "GET";
                # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                # print("request Headers:")
                # print(self.headers)  # 換行打印請求頭;
                # print(type(request_headers))  # 打印請求頭的數據類型;
                # print("request Cookie: ", self.headers["Cookie"])  # 打印客戶端請求頭中的 Cookie 參數值;
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization";
                # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))
                # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型;
                # self.request_Key = str(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                # print(type(self.request_Key))
                # print("request Nikename: [ ", self.request_Key.split(":", -1)[0], " ], request Password: [ ", self.request_Key.split(":", -1)[1]," ].")

                # print("當前進程ID: ", multiprocessing.current_process().pid)
                # print("當前進程名稱: ", multiprocessing.current_process().name)
                # print("當前綫程ID: ", threading.current_thread().ident)
                # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;
                # global threads  # 自定義的全局變量綫程列表;
                # threads.append(threading.current_thread())  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;

                # global Key, Session

                # # 配置只接收目標為根目錄 / 的訪問;
                # if self.path != "/":
                #     self.send_error(404, "Page not Found!")
                #     return

                request_Path = ""
                request_Url_Query_String = ""
                request_Url = ""

                request_Url = str(self.path)  # 客戶端請求 URL 字符串值;
                # print(request_Url)

                if request_Url != "":
                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("?", -1)[0])
                    elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
                        request_Path = str(request_Url.split("#", -1)[0])
                    else:
                        request_Path = str(request_Url)
                    # print(request_Path)

                    if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
                        request_Url_Query_String = str(request_Url.split("?", -1)[1])
                        if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                            request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])
                    # print(request_Url_Query_String)

                request_Url_Query_Dict = {}
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

                # 提取請求 URL 字符串中的查詢（?）字段中的：key=value 鍵值，或使用請求頭信息「self.headers["Authorization"]」和「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼;
                if isinstance(request_Url_Query_Dict, dict) and len(request_Url_Query_Dict) > 0 and (("key" in request_Url_Query_Dict) or ("Key" in request_Url_Query_Dict) or ("KEY" in request_Url_Query_Dict)):
                    # 提取請求 URL 字符串中的查詢（?）字段中的：key=value 鍵值;

                    # print(len(request_Url_Query_Dict))
                    if len(request_Url_Query_Dict) > 0:
                        # 解析獲取客戶端請求 url 中的賬號密碼 "key" 參數;
                        # self.request_Key = ""
                        # print(request_Url_Query_Dict["Key"])
                        # print("key" in request_Url_Query_Dict)
                        if "key" in request_Url_Query_Dict:
                            # if isinstance(request_Url_Query_Dict["key"], str) and request_Url_Query_Dict["key"].find(":", 0, int(len(request_Url_Query_Dict["key"])-1)) != -1:
                            #     # for i in range(0, len(request_Url_Query_Dict["key"].split(":", -1))):
                                self.request_Key = str(request_Url_Query_Dict["key"])  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                        elif "Key" in request_Url_Query_Dict:
                            self.request_Key = str(request_Url_Query_Dict["Key"])  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                        elif "KEY" in request_Url_Query_Dict:
                            self.request_Key = str(request_Url_Query_Dict["KEY"])  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                        else:
                            # self.request_Key = ":"
                            self.request_Key = ""
                        # print("request url query key: [ " + self.request_Key + " ].")
                    pass
                elif self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                    # print("request Headers Authorization: ", self.headers["Authorization"])
                    # print("request Headers Authorization: ", self.headers["Authorization"].split(" ", -1)[0], base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False))
                    # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
                    # print(type(base64.b64decode(self.headers["Authorization"].split(" ", -1)[1], altchars=None, validate=False)))

                    # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
                    if self.headers["Authorization"].find("Basic", 0, int(len(self.headers["Authorization"])-1)) != -1 and self.headers["Authorization"].split(" ", -1)[0] == "Basic" and len(self.headers["Authorization"].split("Basic ", -1)) > 1 and self.headers["Authorization"].split("Basic ", -1)[1] != "":
                        self.request_Key = str(base64.b64decode(self.headers["Authorization"].split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.request_Key = ""
                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    pass
                elif self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                    self.Cookie_value = self.headers['Cookie']
                    # print("request Headers Cookie: ", self.headers["Cookie"])
                    # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
                    # self.request_Key = eval("'" + str(self.Cookie_value.split("=", -1)[1]) + "'", {'self.request_Key' : ''})  # exec('self.request_Key="username:password"', {'self.request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

                    # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                    if self.Cookie_value.find("=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.find("Session_ID=", 0, int(len(self.Cookie_value)-1)) != -1 and self.Cookie_value.split("=", -1)[0] == "Session_ID":
                        self.Session_ID = str(base64.b64decode(self.Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
                    else:
                        self.Session_ID = str(base64.b64decode(self.Cookie_value, altchars=None, validate=False), encoding="utf-8")
                    # print(type(self.Session_ID))
                    # print(self.Session_ID)

                    # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / self.Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
                    if self.Session_ID != None and self.Session_ID != "" and type(self.Session_ID) == str and Session.__contains__(self.Session_ID) == True and Session[self.Session_ID] != None:
                        self.request_Key = str(Session[self.Session_ID])
                        # print(type(self.request_Key))
                        # print(self.request_Key)
                    else:
                        # self.request_Key = ":"
                        self.request_Key = ""

                    # print(type(self.request_Key))
                    # print(self.request_Key)
                    # print(Key)
                    pass
                else:
                    # self.request_Key = ":"
                    self.request_Key = ""
                    if Key != "":
                        response_data = {
                            "Server_say": "No request Headers Authorization or Cookie received.",
                            "require_Authorization": Key
                        }
                        response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                        # self.send_header('Content-Length', len(bytes(response_data, "utf-8")))
                        self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                        self.do_AUTHHEAD()
                        self.wfile.write(response_data.encode('utf-8'))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return


                # 判斷字符串中是否包含指定字符，也可以是用 "char" in String 語句判斷，判斷客戶端傳入的請求頭中Authorization參數值中是否包含 ":" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
                if self.request_Key != "" and self.request_Key.find(":", 0, int(len(self.request_Key)-1)) != -1:
                    request_Nikename = self.request_Key.split(":", -1)[0]
                    request_Password = self.request_Key.split(":", -1)[1]
                    # print("request Nikename: [ ", self.request_Key.split(":", -1)[0], " ], request Password: [ ", self.request_Key.split(":", -1)[1]," ].")
                else:
                    request_Nikename = self.request_Key
                    request_Password = ""


                if Key != "" and (request_Nikename != Key.split(":", -1)[0] or request_Password != Key.split(":", -1)[1]):

                    response_data = {
                        "Server_say": "request Header Authorization [ " + request_Nikename + " ] not authenticated.",
                        "require_Authorization": Key
                    }
                    response_data = json.dumps(response_data)  # 將JOSN對象轉換為JSON字符串;
                    # print(response_data)
                    self.response_Body_String_len = len(bytes(response_data, "utf-8"))
                    self.do_AUTHHEAD()
                    self.wfile.write(response_data.encode('utf-8'))
                    # self.wfile.flush()
                    # self.wfile.close()
                    return

                else:

                    # 路由，判斷請求URL字符串，如果請求的URL是："/"，則做如下處理;
                    if self.path == "/":
                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # request_form_value 是客戶端以 POST 方法發送的請求躰表單 form 中的原始數據（以 utf-8 編碼），request_form 是原始數據（以 utf-8 編碼）使用 json.loads(request_form_value) 函數轉換後的 JSON 對象數據，response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)

                        # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                        # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                        request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')

                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     "request_body_string": request_form_value
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        request_data_JSON["request_body_string"] = request_form_value
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # request_data_JSON["request_body_string"] = request_form_value,
                                "Server_say": request_form_value
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
                        # if check_json_format(request_form_value):
                        #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
                        #     request_data_JSON = json.loads(request_form_value)  # , encoding='utf-8'
                        # else:
                        #     request_data_JSON = {
                        #         "Client_say": request_form_value
                        #     }

                        # # print("request POST Form:", request_form_value)  # 換行打印請求體;
                        # # 換行打印請求體;
                        # # print("Client say: ", request_data_JSON["Client_say"])

                        # response_Body_JSON = {
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))
                        # self.response_Body_String_len = len(response_Body_String)

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode("utf-8"))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    elif self.path == "/index.html":
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # request_form_value 是客戶端以 POST 方法發送的請求躰表單 form 中的原始數據（以 utf-8 編碼），request_form 是原始數據（以 utf-8 編碼）使用 json.loads(request_form_value) 函數轉換後的 JSON 對象數據，response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)

                        # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                        # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                        request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')

                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     "request_body_string": request_form_value
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        request_data_JSON["request_body_string"] = request_form_value
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # request_data_JSON["request_body_string"] = request_form_value,
                                "Server_say": request_form_value
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
                        # if check_json_format(request_form_value):
                        #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
                        #     request_data_JSON = json.loads(request_form_value)  # , encoding='utf-8'
                        # else:
                        #     request_data_JSON = {
                        #         "Client_say": request_form_value
                        #     }

                        # # print("request POST Form:", request_form_value)  # 換行打印請求體;
                        # # 換行打印請求體;
                        # # print("Client say: ", request_data_JSON["Client_say"])

                        # response_Body_JSON = {
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))
                        # self.response_Body_String_len = len(response_Body_String)

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode("utf-8"))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

                    else:
                        # self.send_error(404, "Page not Found!")

                        # 在這裏編寫需要的應用邏輯，request_Url 是客戶端發送的請求 URL 字符串值，Client_IP 是發送請求的客戶端的IP位址，request_headers 是客戶端發送的請求頭：
                        # request_form_value 是客戶端以 POST 方法發送的請求躰表單 form 中的原始數據（以 utf-8 編碼），request_form 是原始數據（以 utf-8 編碼）使用 json.loads(request_form_value) 函數轉換後的 JSON 對象數據，response_Body_String 是自定義的用於返回客戶端的響應躰字符串;

                        # print("\nrequest Requestline: ", self.requestline)  # 打印請求類型（POST）、URL值（/）、傳輸協議（HTTP/1.1）：POST / HTTP/1.1;
                        # print("\nrequest IP: ", self.client_address[0])  # 打印客戶端Client發送請求的IP位址;
                        # print("\nrequest URL: ", self.path)  # 打印請求 URL 字符串值;
                        # print("request Headers:")
                        # print(self.headers)  # 換行打印請求頭;

                        # request_headers = self.headers  # 讀取 POST 請求頭 <class 'http.client.HTTPMessage'> ;
                        request_Url = self.path  # 客戶端請求 URL 字符串值;
                        # request_Path = self.path  # 客戶端請求 URL 字符串值;
                        Client_IP = self.client_address[0]  # 客戶端Client發送請求的IP位址;

                        # urllib.parse.urlparse(self.path)
                        # urllib.parse.urlparse(self.path).path
                        # parse_qs(urllib.parse.urlparse(self.path).query)

                        # 讀取請求體表單"form"數據，按照請求"request"頭中'content-length'參數的值，控制讀取請求躰的響應時間，請求頭中必須有發送'content-length'數值;
                        # request_form_value = self.rfile.read(int(self.headers['content-length']))  # 二進制字節流;
                        request_form_value = self.rfile.read(int(self.headers['content-length'])).decode('utf-8')

                        request_data_JSON = {}
                        for key, value in self.headers.items():
                            # request_data_JSON['"' + str(key) + '"'] = value
                            request_data_JSON[str(key)] = value

                        # request_data_JSON = {
                        #     "Client_IP": Client_IP,
                        #     "request_Url": request_Url,
                        #     # "request_Path": request_Path,
                        #     "require_Authorization": self.request_Key,
                        #     "require_Cookie": self.Cookie_value,
                        #     # "Server_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                        #     "request_body_string": request_form_value
                        # }
                        request_data_JSON["Client_IP"] = Client_IP
                        request_data_JSON["request_Url"] = request_Url
                        request_data_JSON["request_body_string"] = request_form_value
                        request_data_JSON["time"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        if self.headers['Authorization'] != None and self.headers['Authorization'] != "":
                            request_data_JSON["require_Authorization"] = self.headers['Authorization']
                        else:
                            request_data_JSON["require_Authorization"] = ""
                        # request_data_JSON["require_Authorization"] = self.request_Key
                        if self.headers['Cookie'] != None and self.headers['Cookie'] != "":
                            request_data_JSON["require_Cookie"] = self.headers['Cookie']
                        else:
                            request_data_JSON["require_Cookie"] = ""
                        # request_data_JSON["require_Cookie"] = self.Cookie_value

                        # 將從從客戶端接收到的請求數據，傳入自定義函數 do_Function 處理，處理後的結果再返回發送給客戶端 self.wfile.write(response_Body_String.encode("utf-8"));
                        if dispatch_func != None and hasattr(dispatch_func, '__call__'):
                            # hasattr(do_Function, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
                            processing_return = dispatch_func(request_data_JSON, do_Function)
                            response_Body_String = processing_return[0]  # 最終發送的響應體字符串;
                            self.processing_return_pid = processing_return[1]
                        else:
                            response_Body_JSON = {
                                "Client_IP": Client_IP,
                                "request_Url": request_Url,
                                # "request_Path": request_Path,
                                "require_Authorization": self.request_Key,
                                "require_Cookie": self.Cookie_value,
                                # "Server_Authorization": Key,
                                "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
                                # request_data_JSON["request_body_string"] = request_form_value,
                                "Server_say": request_form_value
                            }
                            response_Body_String = json.dumps(response_Body_JSON)  # 原樣返回，將JOSN對象轉換為JSON字符串;

                        # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
                        # if check_json_format(request_form_value):
                        #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
                        #     request_data_JSON = json.loads(request_form_value)  # , encoding='utf-8'
                        # else:
                        #     request_data_JSON = {
                        #         "Client_say": request_form_value
                        #     }

                        # # print("request POST Form:", request_form_value)  # 換行打印請求體;
                        # # 換行打印請求體;
                        # # print("Client say: ", request_data_JSON["Client_say"])

                        # response_Body_JSON = {
                        #     "Server_say": "",
                        #     "require_Authorization": Key,
                        #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
                        # }

                        # response_data_JSON = do_Function(request_data_JSON)
                        # response_Body_JSON["Server_say"] = response_data_JSON["Server_say"]
                        # # print("Server say: ", response_Body_JSON["Server_say"])

                        # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
                        # response_Body_String = json.dumps(response_Body_JSON)  # 將JOSN對象轉換為JSON字符串;
                        # # response_Body_String = str(response_Body_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
                        # # response_Body_String = response_Body_String.encode("utf-8")  # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;

                        self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"))
                        # self.response_Body_String_len = len(response_Body_String)

                        # self.send_header('Content-Length', self.response_Body_String_len)  # self.response_Body_String_len = len(bytes(response_Body_String, "utf-8"));
                        self.do_HEAD()  # 發送響應頭;

                        # print(response_Body_String)
                        # Send the response body ( html message );
                        # .encode("utf-8") 表示轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
                        self.wfile.write(response_Body_String.encode("utf-8"))
                        # self.wfile.flush()
                        # self.wfile.close()
                        return

        # 使用 socketserver 庫的 ThreadingMixIn 方法（socketserver.ThreadingMixIn）配置啓動多綫程服務器；也可以使用socketserver.ForkingMixIn方法配置多進程服務器;
        # class ThreadedHTTPServer(socketserver.ForkingMixIn, HTTPServer):
        class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
            # Handle requests in a separate thread.
            ThreadingMixIn.daemon_threads = True  # 預設值為 False，將之改爲 True 值，從而設定當主綫程强制退出時，子綫程同步强制終止;
            address_family = socket.AF_INET6  # 配置服務器支持監聽 IPv6 版 IP 地址;
            pass

        # 使用 socketserver 庫的 HTTPServerV6 方法(HTTPServer)配置服務器支持監聽 IPv6 版 IP 地址;
        class HTTPServerV6(HTTPServer):
            address_family = socket.AF_INET6  # 配置服務器支持監聽 IPv6 版 IP 地址;
            pass
        # server = HTTPServerV6((monitoring, Resquest), MyHandler)
        # server.serve_forever()

        # 也可以不用 socketserver 庫裏的對象，自定義一個 ThreadingMinxIn 類;
        # class ThreadingMixIn:
 
        #     daemon_threads = True  # 預設值為 False，將之改爲 True 值，從而設定當主綫程强制退出時，子綫程同步强制終止;
 
        #     def process_request_thread(self, request, client_address):      
        #         try:
        #             self.finish_request(request, client_address)
        #             self.shutdown_request(request)
        #         except:
        #             self.handle_error(request, client_address)
        #             self.shutdown_request(request)
 
        #     def process_request(self, request, client_address):
 
        #         t = threading.Thread(target = self.process_request_thread, args = (request, client_address))
        #         t.daemon = self.daemon_threads
        #         # threads.append(t)  # 添加綫程threading.current_thread()到綫程自定義的全局變量綫程列表threads中;
        #         t.start()

        # 啓動服務器;
        # https://docs.python.org/zh-tw/3.6/library/multiprocessing.html
        def start_Server(host, port, Resquest, ThreadedHTTPServer, HTTPServerV6, HTTPServer, Is_multi_thread):
            # print("當前進程ID: ", multiprocessing.current_process().pid)
            # print("當前進程名稱: ", multiprocessing.current_process().name)
            # print("當前綫程ID: ", threading.current_thread().ident)
            # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;

            # print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/" % (host, port))
            # print('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.')
            # print('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.')
            # print("Keyboard Enter [ Ctrl ] + [ c ] to close.")
            # print("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.")

            # host = "0.0.0.0"  # 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
            # port = 8000  # 監聽埠號
            # 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
            monitoring = (host, port)

            # server = None
            # type(Is_multi_thread) == bool
            if Is_multi_thread:
                # Create a web server and define the handler to manage the incoming request;
                server = ThreadedHTTPServer(monitoring, Resquest)
                # threading.Thread(target=server.serve_forever).start()
                # threading.Event().wait()
            else:
                server = HTTPServerV6(monitoring, Resquest)  # 修改參數之後，支持 IPv6 版地址;
                # server = HTTPServer(monitoring, Resquest)  # 原始服務器包，支持 IPv4 版地址;

            try:
                # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
                server.serve_forever()  # Wait forever for incoming htto requests;
            except Exception as error:
                print(error)
            # except KeyboardInterrupt:
            #     # KeyboardInterrupt 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
            #     print('[ Ctrl ] + [ c ] received, shutting down the web server.')

            #     # for t in range(threading.enumerate()):
            #     #     print(t.getName())
            #     #     print(t.ident)
            #     #     # t.join()  # .join([time]) 等待至线程中止。这阻塞调用线程直至线程的join();
            #     #     # 使用 ctypes 庫强制殺掉正在運行的進程;
            #     #     if t.getName() != "MainThread":
            #     #         if not inspect.isclass(SystemExit):
            #     #             SystemExit = type(SystemExit)
            #     #         res = ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), ctypes.py_object(SystemExit))
            #     #         # print(res)
            #     #         if res == 0:
            #     #             raise ValueError("invalid thread id")
            #     #         elif res != 1:
            #     #             # """if it returns a number greater than one, you're in trouble,
            #     #             # # and you should call it again with exc=NULL to revert the effect"""
            #     #             ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), None)
            #     #             raise SystemError("PyThreadState_SetAsyncExc failed")
            #     #         # print(threading.active_count())

            #     # 關閉正在運行的服務器;
            #     if server:
            #         server.shutdown()
            #         # server.socket.close()

            #     print("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " exit.")

            # # finally:
            # #     """退出 try 時總會執行的語句，無論是否出錯都會繼續執行的語句;處理單獨綫程中的請求;处理单独线程中的请求。"""

            return server

        server = start_Server(host, port, Resquest, ThreadedHTTPServer, HTTPServerV6, HTTPServer, Is_multi_thread)
        return server

    # 配置啓動服務器參數;
    def start(self, host, port, Is_multi_thread, Key, Session, do_Function, number_Worker_process, initializer, pool_func, pool_call_back, error_pool_call_back, total_worker_called_number, check_json_format):
        # print("當前進程ID: ", multiprocessing.current_process().pid)
        # print("當前進程名稱: ", multiprocessing.current_process().name)
        # print("當前綫程ID: ", threading.current_thread().ident)
        # print("當前綫程名稱: ", threading.current_thread().getName())  # threading.current_thread() 表示返回當前綫程變量;

        # 判斷自定義封裝的函數check_ip(address)用於判斷是否爲 IP 地址的字符串，並判斷是：IPv6，還是：IPv4;
        if host == "::0" or host == "::1" or self.check_ip(host) == "IPv6":
            # print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://[%s]:%s/" % (host, port))
            sys.stderr.write("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://[%s]:%s/\n" % (host, port))
        elif host == "0.0.0.0" or host == "127.0.0.1" or self.check_ip(host) == "IPv4":
            # print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/" % (host, port))
            sys.stderr.write("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/\n" % (host, port))
        elif host == "localhost":
            # print("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/" % (host, port))
            sys.stderr.write("process-" + str(multiprocessing.current_process().pid) + " > thread-" + str(threading.current_thread().ident) + " listening on: http://%s:%s/\n" % (host, port))
        else:
            # print("Error: host IP [ " + host + " ] unrecognized.")
            sys.stderr.write("Error: host IP [ " + host + " ] unrecognized.\n")
            # return False
        if isinstance(Key, str) and Key != "":
            if Key != ":":
                Key_username = ""  # "username"
                Key_password = ""  # "password"
                if Key.find(":", 0, int(len(Key)-1)) != -1:
                    Key_username = Key.split(":", -1)[0]  # "username"
                    Key_password = Key.split(":", -1)[1]  # "password"
                else:
                    Key_username = Key
                if Key_username != "" and Key_password != "":
                    # print('Client key = [ ' + Key_username + ' ] : [ ' + Key_password + ' ].')
                    sys.stderr.write('Client key = [ ' + Key_username + ' ] : [ ' + Key_password + ' ].\n')
                if Key_username != "" and Key_password == "":
                    # print('Client key = ' + Key_username)
                    sys.stderr.write('Client key = ' + Key_username + '\n')
                if Key_username == "" and Key_password != "":
                    # print('Client key = :' + Key_password)
                    sys.stderr.write('Client key = :' + Key_password + '\n')
        sys.stderr.write('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.\n')
        # print('Import data interface JSON String: {"Client_say":"這裏是需要傳入的數據字符串 this is import string data"}.')
        sys.stderr.write('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.\n')
        # print('Export data interface JSON String: {"Server_say":"這裏是處理後傳出的數據字符串 this is export string data"}.')
        sys.stderr.write("Keyboard Enter [ Ctrl ] + [ c ] to close.\n")
        # print("Keyboard Enter [ Ctrl ] + [ c ] to close.")
        sys.stderr.write("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.\n")
        # print("鍵盤輸入 [ Ctrl ] + [ c ] 中止運行.")

        # 創建子進程池;
        process_Pool = None
        if number_Worker_process > 0:
            try:
                # start number_Worker_process worker processes, number_Worker_process = os.cpu_count();
                sys.stderr.write("Master process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " create process pool with spawning " + str(number_Worker_process) + " Worker process ...\n")
                # print("Master process-" + str(multiprocessing.current_process().pid) + " thread-" + str(threading.current_thread().ident) + " create process pool with spawning " + str(number_Worker_process) + " Worker process ...")
                process_Pool = multiprocessing.Pool(processes=number_Worker_process, initializer=initializer, initargs=(), maxtasksperchild=None)
                # 創建進程池，使用 Pool 類執行提交給它的任務，注意要設置參數 initializer，配置爲等於自定義的初始化函數 initializer()，作用是消除鍵盤輸入 [Ctrl]+[c] 中止主進程運行時，子進程被終止的報錯信息;
                # class multiprocessing.Pool([processes[, initializer[, initargs[, maxtasksperchild[, context]]]]])
                #     一個進程池物件，它控制可以提交作業的工作進程池。它支援帶有超時和回檔的非同步結果，以及一個並行的 map 實現;
                #     processes 是要使用的工作進程數目。如果 processes 為 None，則使用 os.cpu_count() 返回的值;
                #     如果 initializer 不為 None，則每個工作進程將會在啟動時調用 initializer(*initargs);
                #     maxtasksperchild 是一個工作進程在它退出或被一個新的工作進程代替之前能完成的任務數量，為了釋放未使用的資源。預設的 maxtasksperchild 是 None，意味著工作進程壽與池齊;
                #     context 可被用於指定啟動的工作進程的上下文。通常一個進程池是使用函數 multiprocessing.Pool() 或者一個上下文物件的 Pool() 方法創建的。在這兩種情況下， context 都是適當設置的;
                # 注意，進程池物件的方法只有創建它的進程能夠調用;
                # 備註 通常來說，Pool 中的 Worker 進程的生命週期和進程池的工作隊列一樣長。一些其他系統中（如 Apache, mod_wsgi 等）也可以發現另一種模式，他們會讓工作進程在完成一些任務後退出，清理、釋放資源，然後啟動一個新的進程代替舊的工作進程。 Pool 的 maxtasksperchild 參數給用戶提供了這種能力;
                # class multiprocessing.pool.AsyncResult
                #     Pool.apply_async() 和 Pool.map_async() 返回對象所屬的類;
                #     get([timeout])
                #         用於獲取執行結果。如果 timeout 不是 None 並且在 timeout 秒內仍然沒有執行完得到結果，則拋出 multiprocessing.TimeoutError 異常。如果遠端調用發生異常，這個異常會通過 get() 重新拋出。
                #     wait([timeout])
                #         阻塞，直到返回結果，或者 timeout 秒後超時。
                #     ready()
                #         用於判斷執行狀態，是否已經完成。
                #     successful()
                #         Return whether the call completed without raising an exception. Will raise AssertionError if the result is not ready.

                # # 推入函數在進程池中啓動一個子進程，process_Pool.apply(func=, args=(,), kwds={})，同步函數會阻塞主進程直到返回結果，其中的執行函數 func 只能接受最外層的函數，不能是嵌套的内層函數;
                # apply_func_return = process_Pool.apply(func=pool_func, args=(read_file_do_Function, "", "", do_Function, "", "", "", "", time_sleep), kwds={})  # 同步函數，會阻塞主進程等待直到返回結果;
                # # print(apply_func_return)
                # if isinstance(apply_func_return, list):
                #     prcess_pid = int(apply_func_return[1])
                #     thread_ident = int(apply_func_return[2])
                #     # 記錄每個被調用的子進程的纍加總次數;
                #     if str(apply_func_return[1]) in total_worker_called_number:
                #         print(total_worker_called_number)
                #         # total_worker_called_number[str(apply_func_return[1])] = int(total_worker_called_number[str(apply_func_return[1])]) + int(1)
                #     else:
                #         total_worker_called_number[str(apply_func_return[1])] = int(0)
                # process_Pool.close()
                # process_Pool.join()
                # process_Pool.terminate()
            except Exception as error:
                # print(error)
                sys.stderr.write(error + '\n')

        server = None
        try:
            # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
            server = self.Server(host, port, Is_multi_thread, Key, Session, do_Function, number_Worker_process, process_Pool, pool_func, pool_call_back, error_pool_call_back, total_worker_called_number)
        except KeyboardInterrupt:
            # KeyboardInterrupt 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
            # print('[ Ctrl ] + [ c ] received, shutting down the web server.')
            sys.stderr.write('[ Ctrl ] + [ c ] received, shutting down the web server.\n')

            # print("綫程池(threading): " + str(threading.active_count()) + " " + str(threading.enumerate()))
            sys.stderr.write("綫程池(threading): " + str(threading.active_count()) + " " + str(threading.enumerate()) + '\n')
            # worker_queues, worker_free, worker_pipe_queues
            arr = []
            if isinstance(total_worker_called_number, dict) and any(total_worker_called_number):
                for key in total_worker_called_number:
                    if key == str(multiprocessing.current_process().pid):
                        arr.append("listening Server process-" + str(key) + " [ " + str(total_worker_called_number[key]) + " ]")
                    else:
                        arr.append("Worker process-" + str(key) + " [ " + str(total_worker_called_number[key]) + " ]")
            if len(arr) > 0:
                print(", ".join(arr))

            if process_Pool != None:
                # process_Pool.close()
                # process_Pool.join()
                process_Pool.terminate()
                # print(process_Pool)

            # 關閉正在運行的服務器;
            if server:
                server.shutdown()
                # server.socket.close()

            # for t in threading.enumerate():
            #     print(t.getName())
            #     print(t.ident)
            #     # t.join()  # .join([time]) 等待至线程中止。这阻塞调用线程直至线程的join();
            #     # 使用 ctypes 庫强制殺掉正在運行的進程;
            #     if t.getName() != "MainThread":
            #         if not inspect.isclass(SystemExit):
            #             SystemExit = type(SystemExit)
            #         res = ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), ctypes.py_object(SystemExit))
            #         # print(res)
            #         if res == 0:
            #             raise ValueError("invalid thread id")
            #         elif res != 1:
            #             # """if it returns a number greater than one, you're in trouble,
            #             # # and you should call it again with exc=NULL to revert the effect"""
            #             ctypes.pythonapi.PyThreadState_SetAsyncExc(ctypes.c_long(t.ident), None)
            #             raise SystemError("PyThreadState_SetAsyncExc failed")
            #         # print(threading.active_count())

            # print("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " exit.")
            sys.stderr.write("Main process-" + str(multiprocessing.current_process().pid) + " Main thread-" + str(threading.current_thread().ident) + " exit.\n")

        # finally:
        #     """退出 try 時總會執行的語句，無論是否出錯都會繼續執行的語句;處理單獨綫程中的請求;处理单独线程中的请求。"""

        return (server, process_Pool, total_worker_called_number)

    # 配置啓動服務器參數;
    def run(self):
        return self.start(self.host, self.port, self.Is_multi_thread, self.Key, self.Session, self.do_Function, self.number_Worker_process, self.initializer, self.pool_func, self.pool_call_back, self.error_pool_call_back, self.total_worker_called_number, self.check_json_format)


# # 函數使用示例;
# # 控制臺命令行使用:
# # C:\>C:\Criss\Python\Python38\python.exe C:\Criss\py\src\Router.py
# # C:\>C:\Criss\py\Scripts\python.exe C:\Criss\py\src\Router.py
# # 啓動運行;
# # 參數 C:\Criss\py\Scripts\python.exe 表示使用隔離環境 py 中的 python.exe 啓動運行;
# # 使用示例，自定義類 http_Server Web 服務器使用説明;
# if __name__ == '__main__':
#     # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
#     try:
#         webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
#         # webPath = os.path.join(str(os.path.abspath(".")), 'html')  # "C:/Criss/py/src/html/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
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

#         server = http_Server(
#             host=host,
#             port=port,
#             Is_multi_thread=Is_multi_thread,
#             Key=Key,
#             Session=Session,
#             # do_Function_obj=do_Function_obj,
#             do_Function = do_Function,
#             number_Worker_process=number_Worker_process
#         )
#         # server = http_Server()
#         server.run()

#     except Exception as error:
#         print(error)





# # 示例函數，處理從服務器響應值讀取到的數據，然後返回處理之後的結果字符串數據的;
# def do_Response(response_Dict):
#     # response_Dict = {
#     #     "response_status": 200,
#     #     "response_message": "successful",
#     #     "response_body_string": response_form_value,
#     #     "Client_IP": Client_IP,
#     #     "request_Url": request_Url,
#     #     # "request_Path": request_Path,
#     #     "require_Authorization": self.request_Key,
#     #     "require_Cookie": self.Cookie_value,
#     #     # "Server_Authorization": Key,
#     #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
#     #     "request_body_string": request_form_value
#     # }

#     # print(type(response_Dict))
#     # print(response_Dict)

#     response_data_JSON = response_Dict

#     # print(require_data_String)
#     # print(typeof(require_data_String))

#     Server_say = ""
#     # 使用函數 isinstance(response_Dict, dict) 判斷傳入的參數 response_Dict 是否為 dict 字典（JSON）格式對象;
#     if isinstance(response_Dict, dict):
#         # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
#         if (response_Dict.__contains__("Server_say")):
#             Server_say = response_Dict["Server_say"]
#         else:
#             Server_say = ""
#             # print('服務端發送的響應 JSON 對象中無法找到目標鍵(key)信息 ["Server_say"].')
#             # print(response_Dict)
#     else:
#         Server_say = response_Dict
#     # print(Server_say)

#     now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
#     # print(str(now_date))

#     # response_data_JSON = {
#     #     "Server_say": Server_say,
#     #     "require_Authorization": "",
#     #     "time": str(now_date)
#     # }
#     # # check_json_format(request_data_JSON);
#     # # String = json.dumps(JSON); JSON = json.loads(String);

#     response_data_String = Server_say
#     if isinstance(response_data_JSON, dict):
#         response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;

#     # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
#     # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
#     response_data_bytes = response_data_String.encode("utf-8")
#     response_data_String_len = len(bytes(response_data_String, "utf-8"))

#     return response_data_String



# 客戶端發送請求 http_Client_「http.client」
# https://docs.python.org/zh-cn/3/library/http.client.html#module-http.client
# web 瀏覽器控制器文檔 https://docs.python.org/zh-cn/3/library/webbrowser.html
# url = "http://username:password@localhost:8000/"
# urllib.parse.quote(url)  # （URL編碼處理）主要對URL中的非ASCII碼字符做ASCII編碼處理;
# urllib.parse.unquote(url)  # （URL解碼處理）URL中的特殊字符還原;
# urllib.parse.urlencode  # 對請求的數據data進行格式轉換;
# urllib.robotparser  # 用解析網站 robots.txt 説明文檔;
def http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_String, time_out):
    # 檢查函數需要用到的 Python 原生模組是否已經載入(import)，如果還沒載入，則執行載入操作;
    imported_package_list = dir(list)
    if not("os" in imported_package_list):
        import os  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
    if not("sys" in imported_package_list):
        import sys  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
    if not("signal" in imported_package_list):
        import signal  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
    if not("stat" in imported_package_list):
        import stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
    if not("platform" in imported_package_list):
        import platform  # 加載Python原生的與平臺屬性有關的模組;
    if not("subprocess" in imported_package_list):
        import subprocess  # 加載Python原生的創建子進程模組;
    if not("string" in imported_package_list):
        import string  # 加載Python原生的字符串處理模組;
    if not("datetime" in imported_package_list):
        import datetime  # 加載Python原生的日期數據處理模組;
    if not("time" in imported_package_list):
        import time  # 加載Python原生的日期數據處理模組;
    if not("json" in imported_package_list):
        import json  # import the module of json. 加載Python原生的Json處理模組;
    if not("re" in imported_package_list):
        import re  # 加載Python原生的正則表達式對象
    # if not("tempfile" in imported_package_list):
    #     import tempfile  # from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
    if not("pathlib" in imported_package_list):
        import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
    # if not("shutil" in imported_package_list):
    #     import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
    if not("threading" in imported_package_list):
        import threading  # 加載Python原生的支持多綫程（執行緒）模組;
    if not("inspect" in imported_package_list):
        import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型，以及用於强制終止綫程;
    if not("ctypes" in imported_package_list):
        import ctypes  # 用於强制終止綫程;
    if not("urllib" in imported_package_list):
        import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
    if not("http.client" in imported_package_list):
        import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
        # https: // docs.python.org/3/library/http.server.html
    if not("cookiejar" in imported_package_list):
        from http import cookiejar  # 用於處理請求Cookie;
    if not("ssl" in imported_package_list):
        import ssl  # 用於處理請求證書驗證;
    if not("base64" in imported_package_list):
        import base64  # 加載加、解密模組;

    # # 檢查函數需要用到的 Python 第三方模組是否已經安裝成功(pip install)，如果還沒安裝，則執行安裝操作;
    # if "os" in dir(list):
    #     installed_package_list = os.popen("pip list").read()
    # if isinstance(installed_package_list, list) and not("Flask" in installed_package_list):
    #     os_popen_read = os.popen("pip install Flask --trusted-host -i https://pypi.tuna.tsinghua.edu.cn/simple").read()
    #     print(os_popen_read)

    # 讀取傳入的服務器主機 IP 參數;
    Host = str(Host)  # "localhost" "0.0.0.0" "127.0.0.1"
    # 讀取傳入的服務器監聽端口號碼參數;
    Port = int(Port)  # 8000 監聽埠號 1 ~ 65535;
    # 請求路徑;
    URL = str(URL)  # 根目錄 "/"
    # 請求方法
    Method = str(Method)  # "POST" or "GET"
    # 鏈接請求等待時長，單位（秒）;
    time_out = float(time_out)  # 10 鏈接請求等待時長，單位（秒）;

    # request_Authorization_Base64 = request_Auth  # "username:password"
    request_Auth = bytes(request_Auth, encoding="utf-8")
    request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
    # request_Auth = str(base64.b64decode(request_Authorization_Base64.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
    # 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
    # base64.b64encode(s, altchars=None)
    # 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
    # base64.b64decode(s, altchars=None, validate=False)

    # request_Cookie_Base64 = request_Cookie  # "Session_ID=request_Key->username:password"
    if isinstance(request_Cookie, str):
        if request_Cookie.find("=", 0, int(len(request_Cookie)-1)) != -1:
            Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
            Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
        elif request_Cookie == "":
            Cookie_key = ""  # "Session_ID"
            Cookie_value = ""  # "request_Key->username:password"
        else:
            Cookie_key = ""  # "Session_ID"
            Cookie_value = request_Cookie  # "request_Key->username:password"

    if Cookie_key != "" and Cookie_value != "":
        Cookie_value = bytes(Cookie_value, encoding="utf-8")
        request_Cookie_Base64 = Cookie_key + "=" + str(base64.b64encode(Cookie_value, altchars=None), encoding="utf-8")  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
    elif Cookie_key != "" and Cookie_value == "":
        request_Cookie_Base64 = Cookie_key + "="  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
    elif Cookie_key == "" and Cookie_value != "":
        Cookie_value = bytes(Cookie_value, encoding="utf-8")
        request_Cookie_Base64 = "=" + str(base64.b64encode(Cookie_value, altchars=None), encoding="utf-8")  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
    else:
        request_Cookie_Base64 = ""  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
    # request_Cookie = Cookie_key + "=" + str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
    # # request_Cookie = bytes(request_Cookie, encoding="utf-8")
    # # request_Cookie_Base64 = "Session_ID=" + base64.b64encode(request_Cookie, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
    # # request_Cookie = str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"

    # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
    now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")

    # 這裏是需要向服務器發送的參數數據JSON對象;
    if isinstance(post_Data_String, dict):
        # isinstance(return_obj, dict) type(return_obj) == dict return_obj != {} any(return_obj)
        post_Data_String = json.dumps(post_Data_String)
        # String = json.dumps(JSON); JSON = json.loads(String); check_json_format(JSON_String);
    # elif isinstance(post_Data_String, str):
    #     post_Data_String = post_Data_String
    else:
        post_Data_String = str(post_Data_String)
    len_post_Data_String = len(bytes(post_Data_String, "utf-8"))
    # argument = "How_are_you_!"
    # if argument.find("_", 0, int(len(argument)-1)) != -1:
    #     Python_say = argument.replace("_", " ")  # 將傳入參數字符串中的"_"字符替換為空" "字符
    # post_Data_JSON = {
    #     "Client_say": Python_say,
    #     "time": str(now_date)
    # }
    # post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + time + '\\"}'  # change the javascriptobject to jsonstring;
    # post_Data_String = json.dumps(post_Data_JSON)

    # User_Agent = 'Python3_http.client'
    User_Agent = str(platform.python_implementation()) + str(platform.python_version()) + "_http.client_" + str(platform.platform(aliased=True)) + "_" + str(platform.machine()) + "_" + str(platform.node())
    # print(platform.uname())

    Headers = {
        'accept': '*/*',
        'content-type': 'application/x-www-form-urlencoded; charset=utf-8',
        'content-length': len_post_Data_String,  # str(len_post_Data_String),
        # 'Transfer-Encoding': 'chunked',
        'accept-language': 'zh-Hant-TW; q=0.8, zh-Hant; q=0.7, zh-Hans-CN; q=0.7, zh-Hans; q=0.5, en-US, en; q=0.3',
        'accept-charset': 'utf-8',
        'accept-encoding': 'gzip, deflate',
        'cache-control': 'no-cache',
        'connection': 'close',
        'upgrade': 'HTTP/1.0, HTTP/1.1, HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11',
        'from': 'user@email.com',
        'cookie': request_Cookie_Base64,  # 'session_id=cmVxdWVzdF9LZXktPg==',
        'date': str(now_date),  # '2021-3-18 20:27:36.369',
        'user-agent': User_Agent,
        'host': str(Host) + ':' + str(Port),  # 'localhost:8000',
        'authorization': request_Authorization_Base64  # 'Basic dXNlcm5hbWU6cGFzc3dvcmQ='
    }


    try:
        # 創建鏈接器;
        # http.client.HTTPSConnection(host, port=None, [timeout, ]source_address=None, *, context=None, blocksize=8192)
        # http.client.HTTPConnection(host, port=None, [timeout, ]source_address=None)
        http_client_HTTPConnection = http.client.HTTPConnection(Host, port=Port, timeout=time_out, source_address=None)
        # 返回值為：http.client.HTTPResponse(sock, debuglevel=0, method=None, url=None) 類;

        # 配置調試級別，設爲 0 則不在控制臺輸出調試信息，任何大於 0 的值將使得所有當前定義的調試輸出被列印到 stdout;
        http_client_HTTPConnection.set_debuglevel(0)

        # # 配置通過代理服務器運行鏈接，對鏈接隧道設置主機和端口;
        # # http_client_HTTPConnection.set_tunnel(host, port=None, headers=None)
        # # host 和 port 參數指明隧道連接的位置（即 CONNECT 請求所包含的位址，注意是想通過代理服務器指向的最終目標網址，而不是代理伺服器的位址）;
        # # headers 參數應為一個隨 CONNECT 請求發送的額外 HTTP 標頭的映射，注意是想通過代理服務器指向的最終目標網址發送的標頭的映射，而不是發給代理伺服器的標頭;
        # # 例如，要通過一個運行於本機 8080 埠的 HTTPS 代理伺服器隧道，我們應當向 HTTPSConnection 構造器傳入代理的位址，並將我們最終想要訪問的主機位址傳給 set_tunnel() 方法:
        # conn = http.client.HTTPSConnection("localhost", 8080)
        # conn.set_tunnel("www.python.org", port=8000, headers=Headers)

        # http_client_HTTPConnection.connect()

        # 使用鏈接向服務器發送請求;
        http_client_HTTPConnection.request(Method, URL, body=post_Data_String, headers=Headers, encode_chunked=False)

        # 獲取服務器響應信息;
        http_Response = http_client_HTTPConnection.getresponse()
        # print(type(http_Response))
        # print(http_Response)

        http_Response_status = http_Response.status
        # print(http_Response_status)

        # http_Response_version = http_Response.version  # 11
        # print(http_Response_version)

        # http_Response_headers = http_Response.headers  # 返回值為 <class 'http.client.HTTPMessage'>
        # http_Response_headers = http_Response.getheaders()  #返回值為 Return a list of (header, value) tuples.
        # print(http_Response_headers)

        # 讀取響應頭中的響應數據長度信息;
        Response_headers_Content_Length = int(http_Response.getheader("Content-Length", default=None))
        # print("response Headers Content-Length: " + str(Response_headers_Content_Length))

        # 讀取響應頭中的 Cookie 參數值;
        Response_headers_Set_Cookie = http_Response.getheader("Set-Cookie", default=None)
        # print("response Headers Set-Cookie: " + str(Response_headers_Set_Cookie))
        if Response_headers_Set_Cookie != None and Response_headers_Set_Cookie != "" and isinstance(Response_headers_Set_Cookie, str):

            cookieName = ""
            # if Response_headers_Set_Cookie.find(",", 0, int(len(Response_headers_Set_Cookie)-1)) != -1:
            #     Response_headers_Set_Cookie = Response_headers_Set_Cookie.split(",", -1)[0]

            if Response_headers_Set_Cookie.find(";", 0, int(len(Response_headers_Set_Cookie)-1)) != -1:
                # 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
                cookieName = Response_headers_Set_Cookie.split(";", -1)[0]
            else:
                cookieName = Response_headers_Set_Cookie

            if cookieName.find("=", 0, int(len(cookieName)-1)) != -1:
                request_Cookie_name = cookieName.split("=", -1)[0]
                request_Cookie_value = ""
                for index in range(len(cookieName.split("=", -1))-int(1)):
                    if index == 0:
                        request_Cookie_value = request_Cookie_value + str(cookieName.split("=", -1)[int(index) + int(1)])
                    else:
                        request_Cookie_value = request_Cookie_value + "=" + str(cookieName.split("=", -1)[int(index) + int(1)])
                # request_Cookie = cookieName.split("=", -1)[0] + "=" + str(base64.b64decode(cookieName.split("=", -1)[1], altchars=None, validate=False), encoding="utf-8")
                request_Cookie = request_Cookie_name + "=" + str(base64.b64decode(request_Cookie_value, altchars=None, validate=False), encoding="utf-8")
                # Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
                # Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
                # Cookie_value = bytes(Cookie_value, encoding="utf-8")
                # request_Cookie_Base64 = Cookie_key + "=" + str(base64.b64encode(Cookie_value, altchars=None), encoding="utf-8")  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
            else:
                request_Cookie = str(base64.b64decode(cookieName, altchars=None, validate=False), encoding="utf-8")
            # print(request_Cookie)  # "Session_ID=request_Key->username:password"
            # print(request_Cookie_value)  # "request_Key->username:password"

        # 讀出響應頭中 www-authenticate 參數值;
        Response_headers_www_authenticate = http_Response.getheader("www-authenticate", default=None)
        # print("response Headers www-authenticate: " + str(Response_headers_www_authenticate))
        if Response_headers_www_authenticate != None and Response_headers_www_authenticate != "" and isinstance(Response_headers_www_authenticate, str):

            wwwauthenticate_Value = ""
            if Response_headers_www_authenticate.find("Basic realm=", 0, int(len(Response_headers_www_authenticate)-1)) != -1:
                # 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
                wwwauthenticate_Value = Response_headers_www_authenticate.split("Basic realm=", -1)[1]  # 'www-authenticate': 'Basic realm="domain name -> username:password"';
                # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                # # request_Auth = bytes(request_Auth, encoding="utf-8")
                # # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
            else:
                wwwauthenticate_Value = Response_headers_www_authenticate
                # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                # # request_Auth = bytes(request_Auth, encoding="utf-8")
                # # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;

            if wwwauthenticate_Value.find(" -> ", 0, int(len(wwwauthenticate_Value)-1)) != -1:
                request_Auth_name = wwwauthenticate_Value.split(" -> ", -1)[0]
                request_Auth_value = ""
                for index in range(len(wwwauthenticate_Value.split(" -> ", -1))-int(1)):
                    request_Auth_value = request_Auth_value + str(wwwauthenticate_Value.split(" -> ", -1)[int(index) + int(1)])
                # wwwauthenticate_Value = wwwauthenticate_Value.split(" -> ", -1)[0] + " -> " + str(base64.b64decode(wwwauthenticate_Value.split(" -> ", -1)[1], altchars=None, validate=False), encoding="utf-8")
                # wwwauthenticate_Value = request_Auth_name + " -> " + str(base64.b64decode(request_Auth_value, altchars=None, validate=False), encoding="utf-8")
                request_Auth = request_Auth_value  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                # request_Auth = str(base64.b64decode(request_Auth_value, altchars=None, validate=False), encoding="utf-8")
                # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
                # request_Auth = bytes(request_Auth, encoding="utf-8")
                # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
            else:
                request_Auth = wwwauthenticate_Value
                # request_Auth = str(base64.b64decode(wwwauthenticate_Value, altchars=None, validate=False), encoding="utf-8")
            # print(wwwauthenticate_Value)  # 'www-authenticate': 'Basic realm="domain name -> username:password"';
            # print(request_Auth)  # "username:password";

        Response_headers_location = http_Response.getheader("location", default=None)
        # print("response Headers location: " + str(Response_headers_location))
        # /^https?:\/\//.test(response.headers["location"]);  // 使用正則表達式判斷網址 URL 格式是否正確;

        Response_headers_Date = http_Response.getheader("Date", default=None)
        # print("response Headers Date: " + str(Response_headers_Date))

        Response_headers_JSON = {
            "Content-Length": Response_headers_Content_Length,
            "Set-Cookie": Response_headers_Set_Cookie,
            "location": Response_headers_location,
            "www-authenticate": Response_headers_www_authenticate,
            "Date": Response_headers_Date
        }

        # Reads and returns the response body, or up to the next amt bytes
        # http_Response_body_str = http_Response.read([amt])
        http_Response_body_bytes = http_Response.read(Response_headers_Content_Length)  # 二進制字節 b'bytes'
        # http_Response_body_bytes = http_Response.readinto()
        # bytes(strint, encoding="utf-8")
        # str(b'bytes', encoding="utf-8")
        http_Response_body_str = str(http_Response_body_bytes, encoding="utf-8")
        # print(http_Response_body_str)

        # print(http_Response.closed)
        # http_client_HTTPConnection.close()

        if str(http_Response_status) == str(200):
            # if isinstance(http_Response_body_str, str) and check_json_format(http_Response_body_str):
            #     Response_body_JSON = json.loads(http_Response_body_str)
            #     # String = json.dumps(JSON); JSON = json.loads(String); check_json_format(JSON_String);
            #     print(Response_body_JSON["Server_say"])
            return (http_Response_status, Response_headers_JSON, http_Response_body_str)

        # 處理響應頭中的要求身份驗證的情況，響應狀態碼為 401 表示無權訪問需要身份驗證;
        if str(http_Response_status) == str(401):
            print("服務器返回響應狀態碼「401」要求客戶端身份驗證.")
            # Response_body_JSON = None
            # if isinstance(http_Response_body_str, str) and check_json_format(http_Response_body_str):
            #     Response_body_JSON = json.loads(http_Response_body_str)
            #     # String = json.dumps(JSON); JSON = json.loads(String); check_json_format(JSON_String);
            #     # print(Response_body_JSON["Server_say"])
            # if Response_body_JSON != None and "Server_Authorization" in Response_body_JSON and Response_body_JSON["Server_Authorization"] != None and Response_body_JSON["Server_Authorization"] != "":
            #     request_Auth = str(Response_body_JSON["Server_Authorization"])

            request_Auth = input("「 nikename:password 」 -> ")
            # sys.stdin.readline("「 nikename:password 」 -> ")
            # print("輸入的 「 昵稱 : 密碼 」 -> 「 " + request_Auth + " 」.")

            return http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_String, time_out)

        # 處理響應頭中要求重定向的情況，響應狀態碼為 301 表示永久重定向、303 表示臨時重定向，將原POST請求重定向新URL的GET請求、307 表示臨時重定向;
        if str(http_Response_status) == str(301):
            print("服務器返回響應狀態碼「301」要求客戶端重定向.")
            # Response_body_JSON = None
            # if isinstance(http_Response_body_str, str) and check_json_format(http_Response_body_str):
            #     Response_body_JSON = json.loads(http_Response_body_str)
            #     # String = json.dumps(JSON); JSON = json.loads(String); check_json_format(JSON_String);
            #     # print(Response_body_JSON["Server_say"])
            # if Response_body_JSON != None and "Server_Authorization" in Response_body_JSON and Response_body_JSON["Location"] != None and Response_body_JSON["Location"] != "":
            #     Host = str(Response_body_JSON["Location"])

            # 配置請求網址 URL 值;
            if Response_headers_location != None and isinstance(Response_headers_location, str):
                Host = Response_headers_location  # "localhost";
                return http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_String, time_out)
            else:
                print("服務器返回的重定向位址(URL)無法識別.")
                print(Response_headers_location)
                return (http_Response_status, Response_headers_JSON, http_Response_body_str)
    
    except KeyboardInterrupt:
        # KeyboardInterrupt 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
        print('\n[ Ctrl ] + [ c ] received, shutting down the web client.')


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
#     result = http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_String, time_out)
#     # print(type(result))
#     # print(result)
#     Response_status = result[0]
#     # print(Response_status)
#     Response_headers_JSON = result[1]
#     # print(Response_headers_JSON)
#     Response_body_str = result[2]
#     # print(Response_body_str)
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
