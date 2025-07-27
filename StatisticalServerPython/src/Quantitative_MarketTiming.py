# !/usr/bin/python3
# coding=utf-8


#################################################################################

# Title: Python3 quantitative trading v20221214
# Explain: Python3 market timing, Python3 pick stock, Python3 size position, Python3 back testing, Python3 indicators, Python3 data cleaning
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在壬寅
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
# Interpreter: python-3.11.2-amd64.exe
# Interpreter: Python-3.11.2-tar.xz, Python-3.11.2-amd64.deb
# Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
# Interpreter: Python-3.10.6-tar.xz, python3-3.10.6-aarch64.deb

# 使用説明：
# 控制臺命令列運行指令：
# C:\QuantitativeTrading> C:/QuantitativeTrading/Python/Python311/python.exe C:/QuantitativeTrading/QuantitativeTradingPython/QuantitativeTradingServer.py configFile=C:/QuantitativeTrading/QuantitativeTradingPython/config.txt webPath=C:/QuantitativeTrading/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=C:/QuantitativeTrading/Intermediary/ monitor_file=C:/QuantitativeTrading/Intermediary/intermediary_write_C.txt output_dir=C:/QuantitativeTrading/Intermediary/ output_file=C:/QuantitativeTrading/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=C:/QuantitativeTrading/temp/
# root@localhost:~# /usr/bin/python3 /home/QuantitativeTrading/QuantitativeTradingPython/QuantitativeTradingServer.py configFile=/home/QuantitativeTrading/QuantitativeTradingPython/config.txt webPath=/home/QuantitativeTrading/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=/home/QuantitativeTrading/Intermediary/ monitor_file=/home/QuantitativeTrading/Intermediary/intermediary_write_C.txt output_dir=/home/QuantitativeTrading/Intermediary/ output_file=/home/QuantitativeTrading/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/QuantitativeTrading/temp/

#################################################################################


import math  # 導入 Python 原生包「math」，用於數學計算;
# import random  # 導入 Python 原生包「random」，用於生成隨機數;
# import copy  # 導入 Python 原生包「copy」，用於對字典對象的複製操作（深複製（傳值）、潛複製（傳址））;
# import json  # 導入 Python 原生模組「json」，用於解析 JSON 文檔;
# import csv  # 導入 Python 原生模組「csv」，用於解析 .csv 文檔;
# import pickle  # 導入 Python 原生模組「pickle」，用於將結構化的内存數據直接備份到硬盤二進制文檔，以及從硬盤文檔直接導入結構化内存數據;
# import multiprocessing
# from multiprocessing import Pool
# import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
# import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
# import string  # 加載Python原生的字符串處理模組;
# import time  # 加載Python原生的日期數據處理模組;
import datetime  # 加載Python原生的日期數據處理模組;
import warnings
# warnings.filterwarnings("ignore")  # 設置控制臺不打印所有警告信息;
warnings.filterwarnings("ignore", category=RuntimeWarning)  # 設置控制臺不打印指定（category = RuntimeWarning）的特定警告信息;
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
# 再安裝第三方擴展包：root@localhost:~# pip install sympy -i https://pypi.mirrors.ustc.edu.cn/simple
import numpy  # as np
# import pandas  # as pd
# from pandas import Series as pandas_Series  # 從第三方擴展包「pandas」中導入一維向量「Series」模組，用於構建擴展包「pandas」的一維向量「Series」類型變量;
# from pandas import DataFrame as pandas_DataFrame  # 從第三方擴展包「pandas」中導入二維矩陣「DataFrame」模組，用於構建擴展包「pandas」的二維矩陣「DataFrame」類型變量;
# import pyarrow
# import openpyxl
# import xlrd
# import matplotlib  # as mpl
# import matplotlib.pyplot as matplotlib_pyplot
# import matplotlib.font_manager as matplotlib_font_manager  # 導入第三方擴展包「matplotlib」中的字體管理器，用於設置生成圖片中文字的字體;
# %matplotlib inline
# matplotlib.rcParams['font.sans-serif'] = ['SimHei']
# matplotlib.rcParams['font.family'] = 'sans-serif'
# matplotlib.rcParams['axes.unicode_minus'] = False
# import mplfinance  # 導入第三方擴展包「mplfinance」，用於製作日棒缐（K Days Line）圖;
# from mplfinance.original_flavor import candlestick_ohlc as mplfinance_original_flavor_candlestick_ohlc  # 從第三方擴展包「mplfinance」中導入「original_flavor」模組的「candlestick_ohlc()」函數，用於繪製股票作日棒缐（K Days Line）圖;
# import seaborn  # as sns
# https://www.scipy.org/docs.html
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# import scipy.optimize
# from scipy.optimize import show_options
# from scipy.optimize import OptimizeWarning
# warnings.filterwarnings("ignore", category=OptimizeWarning)  # 設置控制臺不打印指定（category = OptimizeWarning）的特定警告信息;
from scipy.optimize import minimize as scipy_optimize_minimize  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「minimize()」函數，用於通用形式優化問題求解（optimization）;
# from scipy.optimize import linprog as scipy_optimize_linprog  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「linprog()」函數，用於缐性規劃問題求解（optimization）;
# from scipy.optimize import shgo as scipy_optimize_shgo  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「shgo()」函數，用於全跼優化問題求解（optimization）;
# from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
# from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# from scipy.optimize import fsolve as scipy_optimize_fsolve  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「fsolve()」函數，用於多元非缐性方程組求根計算;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合鏈條插值（Spline）函數;
# from scipy.interpolate import BSpline as scipy_interpolate_BSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「BSpline()」函數，用於擬合一維鏈條插值（1 Dimension BSpline）函數;
# from scipy.interpolate import interp1d as scipy_interpolate_interp1d  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「interp1d()」函數，用於擬合一維插值（1 Dimension）函數;
# from scipy.interpolate import UnivariateSpline as scipy_interpolate_UnivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「UnivariateSpline()」函數，用於擬合一維鏈條插值（1 Dimension spline）函數;
# from scipy.interpolate import lagrange as scipy_interpolate_lagrange  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「lagrange()」函數，用於擬合一維拉格朗日法（lagrange）插值（1 Dimension）函數;
# from scipy.interpolate import RectBivariateSpline as scipy_interpolate_RectBivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「RectBivariateSpline()」函數，用於擬合二維鏈條插值（2 Dimension BSpline）函數;
# from scipy.interpolate import griddata as scipy_interpolate_griddata  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「griddata()」函數，用於擬合二多維非結構化插值（2 Dimension）函數;
# from scipy.interpolate import Rbf as scipy_interpolate_Rbf  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「Rbf()」函數，用於擬合多維非結構化插值（n Dimension）函數;
# from scipy.misc import derivative as scipy_derivative_derivative  # 導入第三方擴展包「scipy」中的數值微分計算模組「misc」中的「derivative()」函數，用於一元方程（一維）（1 Dimension）微分計算;
# # from scipy.derivative import derivative as scipy_derivative_derivative  # 導入第三方擴展包「scipy」中的數值微分計算模組「derivative」中的「derivative()」函數，用於一元方程（一維）（1 Dimension）微分計算;
# from scipy.integrate import quad as scipy_integrate_quad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「quad()」函數，用於一元方程（一維）（1 Dimension）定積分計算;
# from scipy.integrate import dblquad as scipy_integrate_dblquad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「dblquad()」函數，用於二元方程（二維）（2 Dimension）定積分計算;
# from scipy.integrate import tplquad as scipy_integrate_tplquad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「tplquad()」函數，用於三元方程（三維）（3 Dimension）定積分計算;
# from scipy.integrate import nquad as scipy_integrate_nquad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「nquad()」函數，用於多元方程（多維）（n Dimension）定積分計算;
# from scipy.integrate import odeint as scipy_integrate_odeint  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「odeint()」函數，用於求解常微分方程（Ordinary Differential Equation）;
# from scipy.integrate import ode as scipy_integrate_ode  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「ode()」函數，用於求解常微分方程（大系統、複雜系統）（Ordinary Differential Equation）;
# from scipy.linalg import solve as scipy_linalg_solve  # 導入第三方擴展包「scipy」中的缐性代數模組「linalg」中的「solve()」函數，用於求解矩陣（matrix）乘、除法（multiplication, division）（求解缐性方程組）計算;
# from scipy.linalg import inv as scipy_linalg_inv  # 導入第三方擴展包「scipy」中的缐性代數模組「linalg」中的「inv()」函數，用於求解矩陣（matrix）的逆（Inverse matrix）計算;
# # https://www.statsmodels.org/stable/index.html
# import statsmodels.api as statsmodels_api  # 導入第三方擴展包「statsmodels」中的「api()」函數，用於模型方程式擬合自定義函數;
# import statsmodels.formula.api as statsmodels_formula_api  # 導入第三方擴展包「statsmodels」中的公式模組「formula」中的「api()」函數，用於模型方程式擬合;
# from statsmodels.tsa.arima_model import ARIMA as statsmodels_tsa_arima_model_ARIMA  # 導入第三方擴展包「statsmodels」中的時間序列（Time Series）分析模組「tsa」中的自回歸差分移動平均模型模組「arima_model」中的「ARIMA()」函數，用於擬合自回歸移動平均模型（ARIMA）;
# from statsmodels.tsa.seasonal import seasonal_decompose as statsmodels_tsa_seasonal_seasonal_decompose  # 導入第三方擴展包「statsmodels」中的時間序列（Time Series）分析模組「tsa」中的自回歸差分移動平均模型模組「seasonal」中的「seasonal_decompose()」函數，用於擬合自回歸移動平均模型（ARIMA）;
# https://docs.sympy.org/latest/tutorial/preliminaries.html#installation
# import sympy  # 導入第三方擴展包「sympy」，用於符號計算;
# https://dateutil.readthedocs.io/en/latest/
# https://github.com/dateutil/dateutil
# 先升級 pip 擴展包管理工具：root@localhost:~# python -m pip install --upgrade pip
# 再安裝第三方擴展包：root@localhost:~# pip install python-dateutil -i https://pypi.mirrors.ustc.edu.cn/simple
# from dateutil.relativedelta import relativedelta as dateutil_relativedelta_relativedelta    # 從第三方擴展包「dateutil」中導入「relativedelta」模組中的「relativedelta()」函數，用於處理日期數據加減量，需要事先安裝：pip install python-dateutil 配置成功;
# from dateutil.parser import parse as dateutil_parser_parse  # 從第三方擴展包「dateutil」中導入「parser」模組中的「parse()」函數，用於格式化日期數據，需要事先安裝：pip install python-dateutil 配置成功;
# https://alkaline-ml.com/pmdarima/
# https://github.com/alkaline-ml/pmdarima
# from pmdarima.arima import auto_arima as pmdarima_arima_auto_arima  # 導入第三方擴展包「pmdarima」中的自回歸差分移動平均模型模組「arima」中的「auto_arima()」函數，用於自動擬合含有季節周期的時間序列（Time Series）模型預測分析;

# 匯入自定義的描述統計模組脚本文檔「./Statis_Descript.py」;
# os.getcwd() # 獲取當前工作目錄路徑;
# os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# os.path.join(os.path.abspath("."), 'Statis_Descript')  # 拼接路徑字符串;
# pathlib.Path(os.path.join(os.path.abspath("."), Statis_Descript)  # 返回路徑對象;
# sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
# import Statis_Descript as Statis_Descript  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Statis_Descript」;
# Transformation = Statis_Descript.Transformation
# outliers_clean = Statis_Descript.outliers_clean
# from Statis_Descript import Transformation as Transformation  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的數據歸一化、數據變換函數「Transformation()」，用於將原始數據歸一化處理;
# from Statis_Descript import outliers_clean as outliers_clean  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的離群值檢查（含有粗大誤差的數據）函數「outliers_clean()」，用於檢查原始數據歸中的離群值;

# 匯入自定義的日棒缐（K-Line）原始數據整理模組脚本文檔「./Quantitative_Data_Cleaning.py」;
# import Quantitative_Data_Cleaning as Quantitative_Data_Cleaning

# 匯入自定義的量化交易指標計算模組脚本文檔「./Quantitative_Indicators.py」;
import Quantitative_Indicators as Quantitative_Indicators  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Quantitative_Indicators」;
Intuitive_Momentum = Quantitative_Indicators.Intuitive_Momentum
Intuitive_Momentum_KLine = Quantitative_Indicators.Intuitive_Momentum_KLine
# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["ticker_symbol"]["close_price"],  # = [],
#     int(3),  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# )
# print("closing price growth rate :\n", return_Intuitive_Momentum)
# return_Intuitive_Momentum_KLine = Intuitive_Momentum_KLine(
#     {
#         "date_transaction": training_data["ticker_symbol"]["date_transaction"],  # 交易日期;
#         "turnover_volume": training_data["ticker_symbol"]["turnover_volume"],  # 成交量;
#         # "turnover_amount": training_data["ticker_symbol"]["turnover_amount"],  # 成交總金額;
#         "opening_price": training_data["ticker_symbol"]["opening_price"],  # 開盤成交價;
#         "close_price": training_data["ticker_symbol"]["close_price"],  # 收盤成交價;
#         "low_price": training_data["ticker_symbol"]["low_price"],  # 最低成交價;
#         "high_price": training_data["ticker_symbol"]["high_price"],  # 最高成交價;
#         # "focus": training_data["ticker_symbol"]["focus"],  # 當日成交價重心;
#         # "amplitude": training_data["ticker_symbol"]["amplitude"],  # 當日成交價絕對振幅;
#         # "amplitude_rate": training_data["ticker_symbol"]["amplitude_rate"],  # 當日成交價相對振幅（%）;
#         # "opening_price_Standardization": training_data["ticker_symbol"]["opening_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
#         # "closing_price_Standardization": training_data["ticker_symbol"]["closing_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
#         # "low_price_Standardization": training_data["ticker_symbol"]["low_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
#         # "high_price_Standardization": training_data["ticker_symbol"]["high_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
#         "turnover_volume_growth_rate": training_data["ticker_symbol"]["turnover_volume_growth_rate"],  # 成交量的成長率;
#         "opening_price_growth_rate": training_data["ticker_symbol"]["opening_price_growth_rate"],  # 開盤價的成長率;
#         "closing_price_growth_rate": training_data["ticker_symbol"]["closing_price_growth_rate"],  # 收盤價的成長率;
#         "closing_minus_opening_price_growth_rate": training_data["ticker_symbol"]["closing_minus_opening_price_growth_rate"],  # 收盤價減開盤價的成長率;
#         "high_price_proportion": training_data["ticker_symbol"]["high_price_proportion"],  # 收盤價和開盤價裏的最大值占最高價的比例;
#         "low_price_proportion": training_data["ticker_symbol"]["low_price_proportion"],  # 最低價占收盤價和開盤價裏的最小值的比例;
#         # "turnover_rate": training_data["ticker_symbol"]["turnover_rate"],  # 成交量換手率;
#         # "price_earnings": training_data["ticker_symbol"]["price_earnings"],  # 每股收益（公司經營利潤率 ÷ 股本）;
#         # "book_value_per_share": training_data["ticker_symbol"]["book_value_per_share"],  # 每股净值（公司净資產 ÷ 股本）;
#         # "capitalization": training_data["ticker_symbol"]["capitalization"]  # 總市值;
#     },
#     int(3),  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = None,  # = [],  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
#     Intuitive_Momentum = Intuitive_Momentum
# )
# print("turnover volume growth rate :\n", return_Intuitive_Momentum_KLine["P1_turnover_volume_growth_rate"])
# print("opening price growth rate :\n", return_Intuitive_Momentum_KLine["P1_opening_price_growth_rate"])
# print("closing price growth rate :\n", return_Intuitive_Momentum_KLine["P1_closing_price_growth_rate"])
# print("closing minus opening price growth rate :\n", return_Intuitive_Momentum_KLine["P1_closing_minus_opening_price_growth_rate"])
# print("high price proportion :\n", return_Intuitive_Momentum_KLine["P1_high_price_proportion"])
# print("low price proportion :\n", return_Intuitive_Momentum_KLine["P1_low_price_proportion"])
# print("intuitive momentum indicator :\n", return_Intuitive_Momentum_KLine["P1_Intuitive_Momentum"])



# 一、擇時（Market Timing）;

# 含有約束條件的優化（Optimization）模型（Model）;
# import numpy
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合插值函數;
# from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# https://www.scipy.org/docs.html
# 擇時模型目標函數;
def MarketTiming_fit_model(
    trainingData,  # = {"ticker_symbol" : {"date_transaction" : [datetime.date("2024-01-02").strftime("%Y-%m-%d")], "turnover_volume" : [int], "opening_price" : [float], "close_price" : [float], "low_price" : [float], "high_price" : [float]}},
    P1,  # 觀察收益率歷史向前推的交易日長度，整型（int），離散型變量;
    P2,  # 買入閾值，浮點型（float），連續型變量;
    P3,  # 賣出閾值，浮點型（float），連續型變量;
    P4,  # risk threshold drawdown loss; # 風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
    Quantitative_Indicators_Function,
    investment_method = "Long_Position_and_Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
):

    # 函數返回值字典（Dict）;
    result = {}  # 函數返回值字典（Dict）;

    # 計算各股票擇時規則的參數值（收盤價的滑動平均值）的序列;
    if isinstance(trainingData, dict) and int(len(trainingData)) > int(0):
        # 遍歷字典的鍵:值對;
        for key, value in trainingData.items():
            # print(f"Key : {key}, Value : {value}")
            if isinstance(value, dict) and ("close_price" in value and isinstance(value["close_price"], list)):

                x0 = value["date_transaction"]  # 交易日期;
                x1 = value["turnover_volume"]  # 成交量;
                # x2 = value["turnover_amount"]  # 成交總金額;
                x3 = value["opening_price"]  # 開盤成交價;
                x4 = value["close_price"]  # 收盤成交價;
                x5 = value["low_price"]  # 最低成交價;
                x6 = value["high_price"]  # 最高成交價;
                # x7 = value["focus"]  # 當日成交價重心;
                # x8 = value["amplitude"]  # 當日成交價絕對振幅;
                # x9 = value["amplitude_rate"]  # 當日成交價相對振幅（%）;
                # x10 = value["opening_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                # x11 = value["closing_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                # x12 = value["low_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                # x13 = value["high_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
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

                # # 計算日棒缐（K Line Daily）數據的重心值（Focus）序列;
                # focus = []  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                # # 計算日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）序列;
                # amplitude = []  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                # # 計算日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）序列;
                # amplitude_rate = []  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                # # 計算日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值序列;
                # opening_price_Standardization = []  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                # # 計算日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值序列;
                # closing_price_Standardization = []  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                # # 計算日棒缐（K Line Daily）數據交易日最低成交價標準化值序列;
                # low_price_Standardization = []  # 日棒缐（K Line Daily）數據交易日最低成交價標準化;
                # # 計算日棒缐（K Line Daily）數據交易日最高成交價標準化值序列;
                # high_price_Standardization = []  # 日棒缐（K Line Daily）數據交易日最高成交價標準化;
                # # for i in range(int(0), int(min([len(value["opening_price"]), len(value["close_price"]), len(value["low_price"]), len(value["high_price"])])), int(1)):
                # for i in range(int(0), int(min([len(x3), len(x4), len(x5), len(x6)])), int(1)):
                #     # 計算日棒缐（K Line Daily）數據的重心值（Focus）序列;
                #     # date_i_focus = numpy.mean([value["opening_price"][i], value["close_price"][i], value["low_price"][i], value["high_price"][i]])
                #     date_i_focus = numpy.mean([x3[i], x4[i], x5[i], x6[i]])
                #     date_i_focus = float(date_i_focus)
                #     focus.append(date_i_focus)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                #     # 計算日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）序列;
                #     date_i_amplitude = numpy.std(
                #         [
                #             x3[i],  # value["opening_price"][i],
                #             x4[i],  # value["close_price"][i],
                #             x5[i],  # value["low_price"][i],
                #             x6[i]  # value["high_price"][i]
                #         ],
                #         ddof = 1
                #     )
                #     # if int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) == int(1):
                #     #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]])
                #     # elif int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) > int(1):
                #     #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]], ddof = 1)
                #     # # else:
                #     date_i_amplitude = float(date_i_amplitude)
                #     amplitude.append(date_i_amplitude)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                #     # 計算日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）序列;
                #     date_i_amplitude_rate = float(date_i_amplitude)  # None  # numpy.nan  # (+math.inf)
                #     if float(date_i_focus) == float(0.0):
                #         date_i_amplitude_rate = (+math.inf)  # float(date_i_amplitude)
                #     else:
                #         date_i_amplitude_rate = float(date_i_amplitude / date_i_focus)
                #     amplitude_rate.append(date_i_amplitude_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                #     # 計算日棒缐（K Line Daily）數據標準化值序列;
                #     date_i_opening_price_Standardization = x3[i]  # value["opening_price"][i]  # 計算日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                #     date_i_closing_price_Standardization = x4[i]  # value["close_price"][i]  # 計算日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                #     date_i_low_price_Standardization = x5[i]  # value["low_price"][i]  # 計算日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                #     date_i_high_price_Standardization = x6[i]  # value["high_price"][i]  # 計算日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                #     # if float(value["amplitude"][i]) == float(0.0):
                #     if float(date_i_amplitude) == float(0.0):
                #         date_i_opening_price_Standardization = float(x3[i] - date_i_focus)  # float(value["opening_price"][i] - value["focus"][i])
                #         date_i_closing_price_Standardization = float(x4[i] - date_i_focus)  # float(value["close_price"][i] - value["focus"][i])
                #         date_i_low_price_Standardization = float(x5[i] - date_i_focus)  # float(value["low_price"][i] - value["focus"][i])
                #         date_i_high_price_Standardization = float(x6[i] - date_i_focus)  # float(value["high_price"][i] - value["focus"][i])
                #     else:
                #         date_i_opening_price_Standardization = float((x3[i] - date_i_focus) / date_i_amplitude)  # float((value["opening_price"][i] - value["focus"][i]) / value["amplitude"][i])
                #         date_i_closing_price_Standardization = float((x4[i] - date_i_focus) / date_i_amplitude)  # float((value["close_price"][i] - value["focus"][i]) / value["amplitude"][i])
                #         date_i_low_price_Standardization = float((x5[i] - date_i_focus) / date_i_amplitude)  # float((value["low_price"][i] - value["focus"][i]) / value["amplitude"][i])
                #         date_i_high_price_Standardization = float((x6[i] - date_i_focus) / date_i_amplitude)  # float((value["high_price"][i] - value["focus"][i]) / value["amplitude"][i])
                #     opening_price_Standardization.append(date_i_opening_price_Standardization)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #     closing_price_Standardization.append(date_i_closing_price_Standardization)
                #     low_price_Standardization.append(date_i_low_price_Standardization)
                #     high_price_Standardization.append(date_i_high_price_Standardization)
                # trainingData[key]["focus"] = focus
                # focus = None  # 釋放内存;
                # trainingData[key]["amplitude"] = amplitude
                # amplitude = None  # 釋放内存;
                # trainingData[key]["amplitude_rate"] = amplitude_rate
                # amplitude_rate = None  # 釋放内存;
                # trainingData[key]["opening_price_Standardization"] = opening_price_Standardization
                # opening_price_Standardization = None  # 釋放内存;
                # trainingData[key]["closing_price_Standardization"] = closing_price_Standardization
                # closing_price_Standardization = None  # 釋放内存;
                # trainingData[key]["low_price_Standardization"] = low_price_Standardization
                # low_price_Standardization = None  # 釋放内存;
                # trainingData[key]["high_price_Standardization"] = high_price_Standardization
                # high_price_Standardization = None  # 釋放内存;

                # # 計算相鄰兩個交易日之間成交股票數量的變化率值的序列，並保存入 1 維數組;
                # turnover_volume_growth_rate_Dict_index_Array = []
                # # for i in range(int(0), int(len(value["turnover_volume"])), int(1)):
                # for i in range(int(0), int(len(x1)), int(1)):
                #     x_growth_rate = numpy.nan
                #     if int(i) < int(2):
                #         x_growth_rate = float(0.0)
                #         # x_growth_rate = numpy.nan
                #         # x_growth_rate = None
                #     else:
                #         if int(x1[i - 1]) != int(0):
                #             x_growth_rate = float(x1[i] / x1[i - 1]) - float(1.0)
                #         elif int(x1[i - 1]) == int(0) and int(x1[i]) == int(0):
                #             x_growth_rate = float(0.0)
                #             # x_growth_rate = numpy.nan
                #             # x_growth_rate = None
                #         elif int(x1[i - 1]) == int(0) and int(x1[i]) > int(0):
                #             x_growth_rate = (+math.inf)
                #         elif int(x1[i - 1]) == int(0) and int(x1[i]) < int(0):
                #             x_growth_rate = (-math.inf)
                #         # else:
                #     # print(x_growth_rate)
                #     turnover_volume_growth_rate_Dict_index_Array.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # trainingData[key]["turnover_volume_growth_rate"] = turnover_volume_growth_rate_Dict_index_Array
                # turnover_volume_growth_rate_Dict_index_Array = None  # 釋放内存;

                # # 計算相鄰兩個交易日之間開盤股票價格的變化率值的序列，並保存入 1 維數組;
                # opening_price_growth_rate_Dict_index_Array = []
                # # for i in range(int(0), int(len(value["opening_price"])), int(1)):
                # for i in range(int(0), int(len(x3)), int(1)):
                #     x_growth_rate = numpy.nan
                #     if int(i) < int(2):
                #         x_growth_rate = float(0.0)
                #         # x_growth_rate = numpy.nan
                #         # x_growth_rate = None
                #     else:
                #         if float(x3[i - 1]) != float(0.0):
                #             x_growth_rate = float(x3[i] / x3[i - 1]) - float(1.0)
                #         elif float(x3[i - 1]) == float(0.0) and float(x3[i]) == float(0.0):
                #             x_growth_rate = float(0.0)
                #             # x_growth_rate = numpy.nan
                #             # x_growth_rate = None
                #         elif float(x3[i - 1]) == float(0.0) and float(x3[i]) > float(0.0):
                #             x_growth_rate = (+math.inf)
                #         elif float(x3[i - 1]) == float(0.0) and float(x3[i]) < float(0.0):
                #             x_growth_rate = (-math.inf)
                #         # else:
                #     # print(x_growth_rate)
                #     opening_price_growth_rate_Dict_index_Array.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # trainingData[key]["opening_price_growth_rate"] = opening_price_growth_rate_Dict_index_Array
                # opening_price_growth_rate_Dict_index_Array = None  # 釋放内存;

                # # 計算相鄰兩個交易日之間收盤股票價格的變化率值的序列，並保存入 1 維數組;
                # closing_price_growth_rate_Dict_index_Array = []
                # # for i in range(int(0), int(len(value["close_price"])), int(1)):
                # for i in range(int(0), int(len(x4)), int(1)):
                #     x_growth_rate = numpy.nan
                #     if int(i) < int(2):
                #         x_growth_rate = float(0.0)
                #         # x_growth_rate = numpy.nan
                #         # x_growth_rate = None
                #     else:
                #         if float(x4[i - 1]) != float(0.0):
                #             x_growth_rate = float(x4[i] / x4[i - 1]) - float(1.0)
                #         elif float(x4[i - 1]) == float(0.0) and float(x4[i]) == float(0.0):
                #             x_growth_rate = float(0.0)
                #             # x_growth_rate = numpy.nan
                #             # x_growth_rate = None
                #         elif float(x4[i - 1]) == float(0.0) and float(x4[i]) > float(0.0):
                #             x_growth_rate = (+math.inf)
                #         elif float(x4[i - 1]) == float(0.0) and float(x4[i]) < float(0.0):
                #             x_growth_rate = (-math.inf)
                #         # else:
                #     # print(x_growth_rate)
                #     closing_price_growth_rate_Dict_index_Array.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # trainingData[key]["closing_price_growth_rate"] = closing_price_growth_rate_Dict_index_Array
                # closing_price_growth_rate_Dict_index_Array = None  # 釋放内存;

                # # 計算每個交易日股票收盤價格減去開盤價格的變化率值的序列，並保存入 1 維數組;
                # closing_minus_opening_price_growth_rate_Dict_index_Array = []
                # # for i in range(int(0), int(min([len(value["opening_price"]), len(value["close_price"])])), int(1)):
                # for i in range(int(0), int(min([len(x3), len(x4)])), int(1)):
                #     x_growth_rate = numpy.nan
                #     if float(x3[i]) != float(0.0):
                #         x_growth_rate = float(x4[i] / x3[i]) - float(1.0)
                #     elif float(x3[i]) == float(0.0) and float(x4[i]) == float(0.0):
                #         x_growth_rate = float(0.0)
                #         # x_growth_rate = numpy.nan
                #         # x_growth_rate = None
                #     elif float(x3[i]) == float(0.0) and float(x4[i]) > float(0.0):
                #         x_growth_rate = (+math.inf)
                #     elif float(x3[i]) == float(0.0) and float(x4[i]) < float(0.0):
                #         x_growth_rate = (-math.inf)
                #     # else:
                #     # print(x_growth_rate)
                #     closing_minus_opening_price_growth_rate_Dict_index_Array.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # trainingData[key]["closing_minus_opening_price_growth_rate"] = closing_minus_opening_price_growth_rate_Dict_index_Array
                # closing_minus_opening_price_growth_rate_Dict_index_Array = None  # 釋放内存;

                # # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列，並保存入 1 維數組;
                # high_price_proportion_Dict_index_Array = []
                # # for i in range(int(0), int(min([len(value["high_price"]), len(value["opening_price"]), len(value["close_price"])])), int(1)):
                # for i in range(int(0), int(min([len(x6), len(x3), len(x4)])), int(1)):
                #     x_growth_rate = numpy.nan
                #     if float(x6[i]) != float(0.0):
                #         x_growth_rate = float(max([x3[i], x4[i]])) / float(x6[i])
                #     elif float(x6[i]) == float(0.0) and float(max([x3[i], x4[i]])) == float(0.0):
                #         x_growth_rate = float(0.0)
                #         # x_growth_rate = numpy.nan
                #         # x_growth_rate = None
                #     elif float(x6[i]) == float(0.0) and float(max([x3[i], x4[i]])) > float(0.0):
                #         x_growth_rate = (+math.inf)
                #     elif float(x6[i]) == float(0.0) and float(max([x3[i], x4[i]])) < float(0.0):
                #         x_growth_rate = (-math.inf)
                #     # else:
                #     # print(x_growth_rate)
                #     high_price_proportion_Dict_index_Array.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # trainingData[key]["high_price_proportion"] = high_price_proportion_Dict_index_Array
                # high_price_proportion_Dict_index_Array = None  # 釋放内存;

                # # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列，並保存入 1 維數組;
                # low_price_proportion_Dict_index_Array = []
                # # for i in range(int(0), int(min([len(value["low_price"]), len(value["opening_price"]), len(value["close_price"])])), int(1)):
                # for i in range(int(0), int(min([len(x5), len(x3), len(x4)])), int(1)):
                #     x_growth_rate = numpy.nan
                #     if float(min([x3[i], x4[i]])) != float(0.0):
                #         x_growth_rate = float(x5[i]) / float(min([x3[i], x4[i]]))
                #     elif float(min([x3[i], x4[i]])) == float(0.0) and float(x5[i]) == float(0.0):
                #         x_growth_rate = float(0.0)
                #         # x_growth_rate = numpy.nan
                #         # x_growth_rate = None
                #     elif float(min([x3[i], x4[i]])) == float(0.0) and float(x5[i]) > float(0.0):
                #         x_growth_rate = (+math.inf)
                #     elif float(min([x3[i], x4[i]])) == float(0.0) and float(x5[i]) < float(0.0):
                #         x_growth_rate = (-math.inf)
                #     # else:
                #     # print(x_growth_rate)
                #     low_price_proportion_Dict_index_Array.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # trainingData[key]["low_price_proportion"] = low_price_proportion_Dict_index_Array
                # low_price_proportion_Dict_index_Array = None  # 釋放内存;

                # 複合指標擇時（勢强），依照擇時規則計算得到參數 P1、P2、P3 值的序列，並保存入數組;
                P1_Array = []  # 依照擇時規則計算得到參數 P1 值的序列，並保存入數組;
                for i in range(int(0), int(min([len(value["turnover_volume_growth_rate"]), len(value["opening_price_growth_rate"]), len(value["closing_price_growth_rate"]), len(value["closing_minus_opening_price_growth_rate"]), len(value["high_price_proportion"]), len(value["low_price_proportion"])])), int(1)):

                    index_PickStock_P1 = numpy.nan  # None  # numpy.nan  # (-math.inf)  # float(0.0)
                    if int(int(i) + int(1)) >= int(P1):

                        x0 = value["date_transaction"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                        x1 = value["turnover_volume"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                        # x2 = value["turnover_amount"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                        x3 = value["opening_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                        x4 = value["close_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                        x5 = value["low_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                        x6 = value["high_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                        # x7 = value["focus"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                        # x8 = value["amplitude"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                        # x9 = value["amplitude_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                        # x10 = value["opening_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                        # x11 = value["closing_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                        # x12 = value["low_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                        # x13 = value["high_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                        x14 = value["turnover_volume_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                        x15 = value["opening_price_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                        x16 = value["closing_price_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                        x17 = value["closing_minus_opening_price_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                        x18 = value["high_price_proportion"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                        x19 = value["low_price_proportion"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                        # x20 = value["turnover_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                        # x21 = value["price_earnings"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                        # x22 = value["book_value_per_share"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                        # x23 = value["capitalization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 總市值;
                        # x24 = value["moving_average_5"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 5 日滑動平均缐;
                        # x25 = value["moving_average_10"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 10 日滑動平均缐;
                        # x26 = value["moving_average_20"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 20 日滑動平均缐;
                        # x27 = value["moving_average_30"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 30 日滑動平均缐;

                        # 跳過序列中的第一個值，因爲第一個值無增長率;
                        if int(i) > int(0):

                            y = Quantitative_Indicators_Function(
                                {
                                    "date_transaction": x0,
                                    "turnover_volume": x1,
                                    # "turnover_volume": x2,
                                    "opening_price": x3,
                                    "close_price": x4,
                                    "low_price": x5,
                                    "high_price": x6,
                                    # "focus": x7,
                                    # "amplitude": x8,
                                    # "amplitude_rate": x9,
                                    # "opening_price_Standardization": x10,
                                    # "closing_price_Standardization": x11,
                                    # "low_price_Standardization": x12,
                                    # "high_price_Standardization": x13,
                                    "turnover_volume_growth_rate": x14,
                                    "opening_price_growth_rate": x15,
                                    "closing_price_growth_rate": x16,
                                    "closing_minus_opening_price_growth_rate": x17,
                                    "high_price_proportion": x18,
                                    "low_price_proportion": x19
                                },
                                P1,  # int(3),  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = None,  # = [],  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                                Intuitive_Momentum = Intuitive_Momentum
                            )
                            index_PickStock_P1_turnover_volume_growth_rate = y["P1_turnover_volume_growth_rate"][int(int(len(y["P1_turnover_volume_growth_rate"])) - int(1))]
                            index_PickStock_P1_opening_price_growth_rate = y["P1_opening_price_growth_rate"][int(int(len(y["P1_opening_price_growth_rate"])) - int(1))]
                            index_PickStock_P1_closing_price_growth_rate = y["P1_closing_price_growth_rate"][int(int(len(y["P1_closing_price_growth_rate"])) - int(1))]
                            index_PickStock_P1_closing_minus_opening_price_growth_rate = y["P1_closing_minus_opening_price_growth_rate"][int(int(len(y["P1_closing_minus_opening_price_growth_rate"])) - int(1))]
                            index_PickStock_P1_high_price_proportion = y["P1_high_price_proportion"][int(int(len(y["P1_high_price_proportion"])) - int(1))]
                            index_PickStock_P1_low_price_proportion = y["P1_low_price_proportion"][int(int(len(y["P1_low_price_proportion"])) - int(1))]
                            index_PickStock_P1 = y["P1_Intuitive_Momentum"][int(int(len(y["P1_Intuitive_Momentum"])) - int(1))]
                    P1_Array.append(index_PickStock_P1)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                trainingData[key]["P1_Array"] = P1_Array  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
                P1_Array = None  # 釋放内存;

                # 釋放内存;
                x0 = None
                x1 = None
                x3 = None
                x4 = None
                x5 = None
                x6 = None
                x14 = None
                x15 = None
                x16 = None
                x17 = None
                x18 = None
                x19 = None

    # 依照擇時規則查找操作日期，並計算此擇時規則的獲利率;
    if isinstance(trainingData, dict) and int(len(trainingData)) > int(0):
        # 遍歷字典的鍵:值對;
        for key, value in trainingData.items():
            # print(f"Key : {key}, Value : {value}")
            if isinstance(value, dict) and ("date_transaction" in value and isinstance(value["date_transaction"], list)) and ("turnover_volume" in value and isinstance(value["turnover_volume"], list)) and ("opening_price" in value and isinstance(value["opening_price"], list)) and ("close_price" in value and isinstance(value["close_price"], list)) and ("low_price" in value and isinstance(value["low_price"], list)) and ("high_price" in value and isinstance(value["high_price"], list)) and ("focus" in value and isinstance(value["focus"], list)) and ("amplitude" in value and isinstance(value["amplitude"], list)) and ("amplitude_rate" in value and isinstance(value["amplitude_rate"], list)) and ("P1_Array" in value and isinstance(value["P1_Array"], list)):

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
                # x10 = value["opening_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                # x11 = value["closing_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                # x12 = value["low_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                # x13 = value["high_price_Standardization"]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                # x14 = value["turnover_volume_growth_rate"]  # 成交量的成長率;
                # x15 = value["opening_price_growth_rate"]  # 開盤價的成長率;
                # x16 = value["closing_price_growth_rate"]  # 收盤價的成長率;
                # x17 = value["closing_minus_opening_price_growth_rate"]  # 收盤價減開盤價的成長率;
                # x18 = value["high_price_proportion"]  # 收盤價和開盤價裏的最大值占最高價的比例;
                # x19 = value["low_price_proportion"]  # 最低價占收盤價和開盤價裏的最小值的比例;
                # x20 = value["turnover_rate"]  # 成交量換手率;
                # x21 = value["price_earnings"]  # 每股收益（公司經營利潤率 ÷ 股本）;
                # x22 = value["book_value_per_share"]  # 每股净值（公司净資產 ÷ 股本）;
                # x23 = value["capitalization"]  # 總市值;
                # x24 = value["moving_average_5"]  # 收盤價 5 日滑動平均缐;
                # x25 = value["moving_average_10"]  # 收盤價 10 日滑動平均缐;
                # x26 = value["moving_average_20"]  # 收盤價 20 日滑動平均缐;
                # x27 = value["moving_average_30"]  # 收盤價 30 日滑動平均缐;

                # P1_Array = []  # 依照擇時規則計算得到參數 P1 值的序列，並保存入數組;
                P1_Array = value["P1_Array"]
                # print(P1_Array)

                # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                y_G = []  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                # 做多（Long Position）記錄;
                y_A_Long_Position = []  # 每兩次對衝交易的差價利潤;
                y_B_Long_Position = []  # 每兩次對衝交易差價盈虧標示;
                y_C_Long_Position = []  # 每兩次對衝交易的間隔日長;
                y_D_Long_Position = []  # 每兩次對衝交易的日成交價振幅平方和;
                y_E_Long_Position = []  # 每兩次對衝交易的日成交量（換手率）均值;
                y_F_Long_Position = []  # 按規則執行交易的日期;
                Index_date_transaction_Long_Position = int(0)  # 每兩次對衝交易序號標識;
                y_H_Long_Position = []  # 記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # 做空（Short Selling）記錄;
                y_A_Short_Selling = []  # 每兩次對衝交易的差價利潤;
                y_B_Short_Selling = []  # 每兩次對衝交易差價盈虧標示;
                y_C_Short_Selling = []  # 每兩次對衝交易的間隔日長;
                y_D_Short_Selling = []  # 每兩次對衝交易的日成交價振幅平方和;
                y_E_Short_Selling = []  # 每兩次對衝交易的日成交量（換手率）均值;
                y_F_Short_Selling = []  # 按規則執行交易的日期;
                Index_date_transaction_Short_Selling = int(0)  # 每兩次對衝交易序號標識;
                y_H_Short_Selling = []  # 記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                if (isinstance(P1_Array, list) and int(len(P1_Array)) > int(P1)) and (isinstance(x0, list) and int(len(x0)) > int(P1)) and (isinstance(x1, list) and int(len(x1)) > int(P1)) and (isinstance(x3, list) and int(len(x3)) > int(P1)) and (isinstance(x4, list) and int(len(x4)) > int(P1)) and (isinstance(x5, list) and int(len(x5)) > int(P1)) and (isinstance(x6, list) and int(len(x6)) > int(P1)):

                    # 伸縮框跳躍式遍歷;
                    i = int(-1)
                    while True:

                        i += int(1)
                        # i = int(int(i) + int(1))
                        # print(i)

                        if int(i) >= int(len(P1_Array)):
                            break  # 終止 while...end 循環;

                        # int(min([P2, P3]))
                        # int(max([P2, P3]))
                        if int(int(int(i) - int(1)) + int(1)) >= int(P1) and int(int(i) - int(1)) >= int(0):

                            x_P1 = P1_Array[int(i)]
                            # print(x_P1)

                            x_P1_previous = P1_Array[int(int(i) - int(1))]
                            # print(x_P1_previous)

                            if (not ((x_P1 is None) or numpy.isnan(x_P1))) and (not ((x_P1_previous is None) or numpy.isnan(x_P1_previous))):

                                # 依照選股規則挑選出的股票，計算（融資做多 buying long）交易利潤;
                                if investment_method == "Long_Position_and_Short_Selling" or investment_method == "Long_Position":

                                    # 做多（Long Position）記錄;
                                    y_A_Long_Position_I = float(0.0)  # 每兩次對衝交易差價利潤初值;
                                    y_B_Long_Position_I = int(0)  # 每兩次對衝交易差價盈虧標示初值;
                                    y_C_Long_Position_I = int(0)  #  (+math.inf);  # 每兩次對衝交易間隔日長初值;
                                    y_D_Long_Position_I = float(0.0)  # 每兩次對衝交易日成交價振幅平方和初值;
                                    y_E_Long_Position_I = float(0.0)  # 每兩次對衝交易日成交量（換手率）均值初值;
                                    # 判斷是否進行（融資做多 buying long）對衝交易的第一次買入交易;
                                    if (x_P1_previous <= P2) and (x_P1 > P2):

                                        if int(int(int(i) + int(1)) + int(1)) <= int(len(P1_Array)):

                                            # 記錄每個交易日的回撤值序列;
                                            drawdown_Array_Long_Position = []  # 記錄做多模式每個交易日的回撤值序列;

                                            Index_date_transaction_Long_Position += int(1)
                                            # Index_date_transaction_Long_Position = int(int(Index_date_transaction_Long_Position) + int(1))

                                            # 按規則執行第一次買入（融資做多 buying long）交易的日期;
                                            y_F_Long_Position_I = [None] * int(16)
                                            y_F_Long_Position_I[0] = x0[int(int(i) + int(1))]  # 交易時間日期（Dates.Date 或 Dates.DateTime 類型）;
                                            y_F_Long_Position_I[1] = str("buy")  # 買入或賣出;
                                            y_F_Long_Position_I[2] = x3[int(int(i) + int(1))]  # 成交價;
                                            y_F_Long_Position_I[3] = None  # 成交量;
                                            y_F_Long_Position_I[4] = int(Index_date_transaction_Long_Position)  # 每兩次對衝成交序號標識;
                                            y_F_Long_Position_I[5] = int(int(i) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                            y_F_Long_Position_I[6] = x0[int(int(i) + int(1))]  # 交易日（datetime.date 類型）;
                                            y_F_Long_Position_I[7] = x1[int(int(i) + int(1))]  # 當日總成交量（turnover volume）;
                                            y_F_Long_Position_I[8] = x3[int(int(i) + int(1))]  # 當日開盤（opening）成交價;
                                            y_F_Long_Position_I[9] = x4[int(int(i) + int(1))]  # 當日收盤（closing）成交價;
                                            y_F_Long_Position_I[10] = x5[int(int(i) + int(1))]  # 當日最低（low）成交價;
                                            y_F_Long_Position_I[11] = x6[int(int(i) + int(1))]  # 當日最高（high）成交價;
                                            # y_F_Long_Position_I[12] = x2[int(int(i) + int(1))]  # 當日總成交金額（turnover amount）;
                                            # y_F_Long_Position_I[13] = x20[int(int(i) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                            # y_F_Long_Position_I[14] = x21[int(int(i) + int(1))]  # 當日每股收益（price earnings）;
                                            # y_F_Long_Position_I[15] = x22[int(int(i) + int(1))]  # 當日每股净值（book value per share）;
                                            y_F_Long_Position.append(y_F_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                            y_G_Long_Position_I = float(float(-1.0) * float(x3[int(int(i) + int(1))]))
                                            y_G.append(y_G_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易差價利潤;
                                            y_A_Long_Position_I *= float(0.0)
                                            y_A_Long_Position_I += float(float(0.0) - float(x3[int(int(i) + int(1))]))
                                            # y_A_Long_Position_I = float(float(0.0) - float(x3[i + 1]))  # float(x3[j + 1] - x3[i + 1])
                                            # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                            #     y_A_Long_Position_I = float(y_A_Long_Position_I / x3[int(int(i) + int(1))]);
                                            # y_A_Long_Position.append(y_A_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易差價盈虧標示;
                                            y_B_Long_Position_I *= int(0)
                                            if float(y_A_Long_Position_I) > float(0.0):
                                                y_B_Long_Position_I += int(+1)
                                            elif float(y_A_Long_Position_I) < float(0.0):
                                                y_B_Long_Position_I += int(-1)
                                            elif float(y_A_Long_Position_I) == float(0.0):
                                                y_B_Long_Position_I += int(0)
                                            # else:
                                            # y_B_Long_Position.append(y_B_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易間隔日長;
                                            y_C_Long_Position_I *= int(0)
                                            y_C_Long_Position_I += int(int(len(P1_Array)) + int(1))
                                            # y_C_Long_Position_I = (+math.inf)  # int((j + 1) - (i + 1))
                                            # y_C_Long_Position.append(y_C_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易日成交價振幅平方和;
                                            y_D_Long_Position_I *= float(0.0)
                                            y_D_Long_Position_I += float(x8[int(int(i) + int(1))])
                                            # y_D_Long_Position_I = float(x8[i + 1])  # float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                            # y_D_Long_Position_I = float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))  # float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2));
                                            # y_D_Long_Position.append(y_D_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易日成交量（換手率）均值;
                                            y_E_Long_Position_I *= float(0.0)
                                            y_E_Long_Position_I += float(x1[int(int(i) + int(1))])
                                            # y_E_Long_Position_I = float(x1[i + 1])  # float(float(float(x1[i + 1]) + float(x1[j + 1])) / int(2))
                                            # y_E_Long_Position.append(y_E_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            i_2 = int(i)  # 記錄伸縮框的對衝 2 位置（j）初始值;
                                            # i += int(1)  # 將伸縮框跳躍到 (i + 1) 處的位置;
                                            # i = int(i + 1)  # 將伸縮框跳躍到 (i + 1) 處的位置;

                                            # 查找（融資做多 buying long）對衝交易的第二次賣出交易日期時間切面節點;
                                            if int(int(int(i) + int(1)) + int(1)) <= int(len(P1_Array)):
                                                for j in range(int(i), int(int(len(P1_Array)) - int(1)), int(1)):

                                                    risk_drawdown_loss_Long_Position = float(float(P4) + float(0.1))  # 回撤比例初值，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                                                    risk_drawdown_loss_Long_Position *= float(0.0)
                                                    risk_drawdown_loss_Long_Position += float(float(x3[int(int(j) + int(1))]) / float(x3[int(int(i) + int(1))]))  # 風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                                                    # risk_drawdown_loss_Long_Position += float(float(abs(x3[int(int(j) + int(1))])) / float(abs(x3[int(int(i) + int(1))])))  # 風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;

                                                    # 記錄做多模式每個交易日的回撤值序列;
                                                    drawdown_Array_Long_Position.append(risk_drawdown_loss_Long_Position)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                    # 判斷是否超過預設的風險（最大回撤）閾值，若超過閾值，則賣出强制平倉;
                                                    if float(risk_drawdown_loss_Long_Position) <= float(P4):

                                                        # Index_date_transaction_Long_Position += int(1)
                                                        # # Index_date_transaction_Long_Position = int(int(Index_date_transaction_Long_Position) + int(1))

                                                        # 按規則執行第二次賣出（融資做多 buying long）交易的日期;
                                                        y_F_Long_Position_I = [None] * int(16)
                                                        y_F_Long_Position_I[0] = x0[int(int(j) + int(1))]  # 交易日期;
                                                        y_F_Long_Position_I[1] = str("sell")  # 買入或賣出;
                                                        y_F_Long_Position_I[2] = x3[int(int(j) + int(1))]  # 成交價;
                                                        y_F_Long_Position_I[3] = None  # 成交量;
                                                        y_F_Long_Position_I[4] = int(Index_date_transaction_Long_Position)  # 每兩次對衝成交序號標識;
                                                        y_F_Long_Position_I[5] = int(int(j) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                                        y_F_Long_Position_I[6] = x0[int(int(j) + int(1))]  # 交易日（datetime.date 類型）;
                                                        y_F_Long_Position_I[7] = x1[int(int(j) + int(1))]  # 當日總成交量（turnover volume）;
                                                        y_F_Long_Position_I[8] = x3[int(int(j) + int(1))]  # 當日開盤（opening）成交價;
                                                        y_F_Long_Position_I[9] = x4[int(int(j) + int(1))]  # 當日收盤（closing）成交價;
                                                        y_F_Long_Position_I[10] = x5[int(int(j) + int(1))]  # 當日最低（low）成交價;
                                                        y_F_Long_Position_I[11] = x6[int(int(j) + int(1))]  # 當日最高（high）成交價;
                                                        # y_F_Long_Position_I[12] = x2[int(int(j) + int(1))]  # 當日總成交金額（turnover amount）;
                                                        # y_F_Long_Position_I[13] = x20[int(int(j) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                                        # y_F_Long_Position_I[14] = x21[int(int(j) + int(1))]  # 當日每股收益（price earnings）;
                                                        # y_F_Long_Position_I[15] = x22[int(int(j) + int(1))]  # 當日每股净值（book value per share）;
                                                        y_F_Long_Position.append(y_F_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                                        y_G_Long_Position_I = float(float(+1.0) * float(x3[int(int(j) + int(1))]))
                                                        y_G.append(y_G_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易差價利潤;
                                                        y_A_Long_Position_I *= float(0.0)
                                                        y_A_Long_Position_I += float(float(x3[int(int(j) + int(1))]) - float(x3[int(int(i) + int(1))]))
                                                        # y_A_Long_Position_I = float(x3[j + 1] - x3[i + 1])
                                                        # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                                        #     y_A_Long_Position_I = float(y_A_Long_Position_I / x3[int(int(i) + int(1))])
                                                        # y_A_Long_Position.append(y_A_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易盈虧標示;
                                                        y_B_Long_Position_I *= int(0)
                                                        if float(y_A_Long_Position_I) > float(0.0):
                                                            y_B_Long_Position_I += int(+1)
                                                        elif float(y_A_Long_Position_I) < float(0.0):
                                                            y_B_Long_Position_I += int(-1)
                                                        elif float(y_A_Long_Position_I) == float(0.0):
                                                            y_B_Long_Position_I += int(0)
                                                        # else:
                                                        # y_B_Long_Position.append(y_B_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易間隔日長;
                                                        y_C_Long_Position_I *= int(0)
                                                        y_C_Long_Position_I += int(int(int(j) + int(1)) - int(int(i) + int(1)))
                                                        # y_C_Long_Position_I = int((j + 1) - (i + 1))
                                                        # y_C_Long_Position.append(y_C_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易日成交價振幅平方和;
                                                        y_D_Long_Position_I *= float(0.0)
                                                        y_D_Long_Position_I += float(numpy.sqrt(float(x8[int(int(i) + int(1))])**2 + float(x8[int(int(j) + int(1))])**2))
                                                        # y_D_Long_Position_I = float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                                        # y_D_Long_Position_I = float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                                        # y_D_Long_Position.append(y_D_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易日成交量（換手率）均值;
                                                        y_E_Long_Position_I *= float(0.0)
                                                        y_E_Long_Position_I += float(float(float(x1[int(int(i) + int(1))]) + float(x1[int(int(j) + int(1))])) / int(2))
                                                        # y_E_Long_Position_I = float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                                        # y_E_Long_Position.append(y_E_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        i_2 *= int(0)  # 將伸縮框的對衝 2 位置（j）位置歸零（起始點）;
                                                        i_2 += int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;
                                                        # i_2 = int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;

                                                        break  # 終止 for...end 循環;

                                                    # 判斷是否超過預設的風險（最大回撤）閾值，若小於閾值，則執行擇時規則判斷是否做對衝交易的賣出操作;
                                                    if float(risk_drawdown_loss_Long_Position) > float(P4):

                                                        # 數據序列最後一個交易日，强制平倉;
                                                        if int(j + 1) == int(int(len(P1_Array)) - int(1)):

                                                            # Index_date_transaction_Long_Position += int(1)
                                                            # # Index_date_transaction_Long_Position = int(int(Index_date_transaction_Long_Position) + int(1))

                                                            # 按規則執行第二次賣出（融資做多 buying long）交易的日期;
                                                            y_F_Long_Position_I = [None] * int(16)
                                                            y_F_Long_Position_I[0] = x0[int(int(j) + int(1))]  # 交易日期;
                                                            y_F_Long_Position_I[1] = str("sell")  # 買入或賣出;
                                                            y_F_Long_Position_I[2] = x3[int(int(j) + int(1))]  # 成交價;
                                                            y_F_Long_Position_I[3] = None  # 成交量;
                                                            y_F_Long_Position_I[4] = int(Index_date_transaction_Long_Position)  # 每兩次對衝成交序號標識;
                                                            y_F_Long_Position_I[5] = int(int(j) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                                            y_F_Long_Position_I[6] = x0[int(int(j) + int(1))]  # 交易日（datetime.date 類型）;
                                                            y_F_Long_Position_I[7] = x1[int(int(j) + int(1))]  # 當日總成交量（turnover volume）;
                                                            y_F_Long_Position_I[8] = x3[int(int(j) + int(1))]  # 當日開盤（opening）成交價;
                                                            y_F_Long_Position_I[9] = x4[int(int(j) + int(1))]  # 當日收盤（closing）成交價;
                                                            y_F_Long_Position_I[10] = x5[int(int(j) + int(1))]  # 當日最低（low）成交價;
                                                            y_F_Long_Position_I[11] = x6[int(int(j) + int(1))]  # 當日最高（high）成交價;
                                                            # y_F_Long_Position_I[12] = x2[int(int(j) + int(1))]  # 當日總成交金額（turnover amount）;
                                                            # y_F_Long_Position_I[13] = x20[int(int(j) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                                            # y_F_Long_Position_I[14] = x21[int(int(j) + int(1))]  # 當日每股收益（price earnings）;
                                                            # y_F_Long_Position_I[15] = x22[int(int(j) + int(1))]  # 當日每股净值（book value per share）;
                                                            y_F_Long_Position.append(y_F_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                                            y_G_Long_Position_I = float(float(+1.0) * float(x3[int(int(j) + int(1))]))
                                                            y_G.append(y_G_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易差價利潤;
                                                            y_A_Long_Position_I *= float(0.0)
                                                            y_A_Long_Position_I += float(float(x3[int(int(j) + int(1))]) - float(x3[int(int(i) + int(1))]))
                                                            # y_A_Long_Position_I = float(x3[j + 1] - x3[i + 1])
                                                            # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                                            #     y_A_Long_Position_I = float(float(y_A_Long_Position_I) / float(x3[int(int(i) + int(1))]))
                                                            # y_A_Long_Position.append(y_A_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易盈虧標示;
                                                            y_B_Long_Position_I *= int(0)
                                                            if float(y_A_Long_Position_I) > float(0.0):
                                                                y_B_Long_Position_I += int(+1)
                                                            elif float(y_A_Long_Position_I) < float(0.0):
                                                                y_B_Long_Position_I += int(-1)
                                                            elif float(y_A_Long_Position_I) == float(0.0):
                                                                y_B_Long_Position_I += int(0)
                                                            # else:
                                                            # y_B_Long_Position.append(y_B_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易間隔日長;
                                                            y_C_Long_Position_I *= int(0)
                                                            y_C_Long_Position_I += int(int(int(j) + int(1)) - int(int(i) + int(1)))
                                                            # y_C_Long_Position_I = int((j + 1) - (i + 1))
                                                            # y_C_Long_Position.append(y_C_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易日成交價振幅平方和;
                                                            y_D_Long_Position_I *= float(0.0)
                                                            y_D_Long_Position_I += float(numpy.sqrt(float(x8[int(int(i) + int(1))])**2 + float(x8[int(int(j) + int(1))])**2))
                                                            # y_D_Long_Position_I = float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                                            # y_D_Long_Position_I = float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                                            # y_D_Long_Position.append(y_D_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易日成交量（換手率）均值;
                                                            y_E_Long_Position_I *= float(0.0)
                                                            y_E_Long_Position_I += float(float(float(x1[int(int(i) + int(1))]) + float(x1[int(int(j) + int(1))])) / int(2))
                                                            # y_E_Long_Position_I = float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                                            # y_E_Long_Position.append(y_E_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            i_2 *= int(0)  # 將伸縮框的對衝 2 位置（j）位置歸零（起始點）;
                                                            i_2 += int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;
                                                            # i_2 = int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;

                                                            break  # 終止 for...end 循環;

                                                        # 做多模式下，最後一個交易日之前的所有交易日，依次按照擇時規則，判斷是否執行對衝交易的賣出交易;
                                                        if int(j + 1) < int(int(len(P1_Array)) - int(1)):

                                                            x_P1_2 = P1_Array[j]
                                                            # print(x_P1_2)

                                                            if not ((x_P1_2 is None) or numpy.isnan(x_P1_2)):

                                                                # 判斷是否進行第二次賣出（融資做多 buying long）交易;
                                                                if (x_P1 >= P3) and (x_P1_2 < P3):

                                                                    # Index_date_transaction_Long_Position += int(1)
                                                                    # # Index_date_transaction_Long_Position = int(int(Index_date_transaction_Long_Position) + int(1))

                                                                    # 按規則執行第二次賣出（融資做多 buying long）交易的日期;
                                                                    y_F_Long_Position_I = [None] * int(16)
                                                                    y_F_Long_Position_I[0] = x0[int(int(j) + int(1))]  # 交易日期;
                                                                    y_F_Long_Position_I[1] = str("sell")  # 買入或賣出;
                                                                    y_F_Long_Position_I[2] = x3[int(int(j) + int(1))]  # 成交價;
                                                                    y_F_Long_Position_I[3] = None  # 成交量;
                                                                    y_F_Long_Position_I[4] = int(Index_date_transaction_Long_Position)  # 每兩次對衝成交序號標識;
                                                                    y_F_Long_Position_I[5] = int(int(j) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                                                    y_F_Long_Position_I[6] = x0[int(int(j) + int(1))]  # 交易日（datetime.date 類型）;
                                                                    y_F_Long_Position_I[7] = x1[int(int(j) + int(1))]  # 當日總成交量（turnover volume）;
                                                                    y_F_Long_Position_I[8] = x3[int(int(j) + int(1))]  # 當日開盤（opening）成交價;
                                                                    y_F_Long_Position_I[9] = x4[int(int(j) + int(1))]  # 當日收盤（closing）成交價;
                                                                    y_F_Long_Position_I[10] = x5[int(int(j) + int(1))]  # 當日最低（low）成交價;
                                                                    y_F_Long_Position_I[11] = x6[int(int(j) + int(1))]  # 當日最高（high）成交價;
                                                                    # y_F_Long_Position_I[12] = x2[int(int(j) + int(1))]  # 當日總成交金額（turnover amount）;
                                                                    # y_F_Long_Position_I[13] = x20[int(int(j) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                                                    # y_F_Long_Position_I[14] = x21[int(int(j) + int(1))]  # 當日每股收益（price earnings）;
                                                                    # y_F_Long_Position_I[15] = x22[int(int(j) + int(1))]  # 當日每股净值（book value per share）;
                                                                    y_F_Long_Position.append(y_F_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                                                    y_G_Long_Position_I = float(float(+1.0) * float(x3[int(int(j) + int(1))]))
                                                                    y_G.append(y_G_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易差價利潤;
                                                                    y_A_Long_Position_I *= float(0.0)
                                                                    y_A_Long_Position_I += float(float(x3[int(int(j) + int(1))]) - float(x3[int(int(i) + int(1))]))
                                                                    # y_A_Long_Position_I = float(x3[j + 1] - x3[i + 1])
                                                                    # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                                                    #     y_A_Long_Position_I = float(float(y_A_Long_Position_I) / float(x3[int(int(i) + int(1))]))
                                                                    # y_A_Long_Position.append(y_A_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易盈虧標示;
                                                                    y_B_Long_Position_I *= int(0)
                                                                    if float(y_A_Long_Position_I) > float(0.0):
                                                                        y_B_Long_Position_I += int(+1)
                                                                    elif float(y_A_Long_Position_I) < float(0.0):
                                                                        y_B_Long_Position_I += int(-1)
                                                                    elif float(y_A_Long_Position_I) == float(0.0):
                                                                        y_B_Long_Position_I += int(0)
                                                                    # else:
                                                                    # y_B_Long_Position.append(y_B_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易間隔日長;
                                                                    y_C_Long_Position_I *= int(0)
                                                                    y_C_Long_Position_I += int(int(int(j) + int(1)) - int(int(i) + int(1)))
                                                                    # y_C_Long_Position_I = int((j + 1) - (i + 1))
                                                                    # y_C_Long_Position.append(y_C_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易日成交價振幅平方和;
                                                                    y_D_Long_Position_I *= float(0.0)
                                                                    y_D_Long_Position_I += float(numpy.sqrt(float(x8[int(int(i) + int(1))])**2 + float(x8[int(int(j) + int(1))])**2))
                                                                    # y_D_Long_Position_I = float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                                                    # y_D_Long_Position_I = float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                                                    # y_D_Long_Position.append(y_D_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易日成交量（換手率）均值;
                                                                    y_E_Long_Position_I *= float(0.0)
                                                                    y_E_Long_Position_I += float(float(float(x1[int(int(i) + int(1))]) + float(x1[int(int(j) + int(1))])) / int(2))
                                                                    # y_E_Long_Position_I = float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                                                    # y_E_Long_Position.append(y_E_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    i_2 *= int(0)  # 將伸縮框的對衝 2 位置（j）位置歸零（起始點）;
                                                                    i_2 += int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;
                                                                    # i_2 = int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;

                                                                    break  # 終止 for...end 循環;

                                            # 做多（Long Position）記錄;
                                            y_A_Long_Position.append(y_A_Long_Position_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                                            y_B_Long_Position.append(y_B_Long_Position_I)
                                            y_C_Long_Position.append(y_C_Long_Position_I)
                                            y_D_Long_Position.append(y_D_Long_Position_I)
                                            y_E_Long_Position.append(y_E_Long_Position_I)
                                            # 記錄做多模式本輪對衝交易的回撤值序列;
                                            if isinstance(drawdown_Array_Long_Position, list) and int(len(drawdown_Array_Long_Position)) >= int(0):
                                                y_H_Long_Position.append(drawdown_Array_Long_Position)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            i *= int(0)  # 將伸縮框的位置歸零（起始點）;
                                            i += int(i_2)  # 將伸縮框跳躍到(j) 或 (j + 1) 處的位置;

                                # 依照選股規則挑選出的股票，計算（融券做空 short selling）交易利潤;
                                if investment_method == "Long_Position_and_Short_Selling" or investment_method == "Short_Selling":

                                    # 做空（Short Selling）記錄;
                                    y_A_Short_Selling_I = float(0.0)  # 每兩次對衝交易差價利潤初值;
                                    y_B_Short_Selling_I = int(0)  # 每兩次對衝交易差價盈虧標示初值;
                                    y_C_Short_Selling_I = int(0)  #  (+math.inf);  # 每兩次對衝交易間隔日長初值;
                                    y_D_Short_Selling_I = float(0.0)  # 每兩次對衝交易日成交價振幅平方和初值;
                                    y_E_Short_Selling_I = float(0.0)  # 每兩次對衝交易日成交量（換手率）均值初值;
                                    # 判斷是否進行（融券做空 short selling）對衝交易的第一次賣出交易;
                                    if (x_P1_previous >= P3) and (x_P1 < P3):

                                        if int(int(int(i) + int(1)) + int(1)) <= int(len(P1_Array)):

                                            # 記錄每個交易日的回撤值序列;
                                            drawdown_Array_Short_Selling = []  # 記錄做空模式每個交易日的回撤值序列;

                                            Index_date_transaction_Short_Selling += int(1)
                                            # Index_date_transaction_Short_Selling = int(int(Index_date_transaction_Short_Selling) + int(1))

                                            # 按規則執行第一次賣出（融券做空 short selling）交易的日期;
                                            y_F_Short_Selling_I = [None] * int(16)
                                            y_F_Short_Selling_I[0] = x0[int(int(i) + int(1))]  # 交易日期;
                                            y_F_Short_Selling_I[1] = str("sell")  # 買入或賣出;
                                            y_F_Short_Selling_I[2] = x3[int(int(i) + int(1))]  # 成交價;
                                            y_F_Short_Selling_I[3] = None  # 成交量;
                                            y_F_Short_Selling_I[4] = int(Index_date_transaction_Short_Selling)  # 每兩次對衝成交序號標識;
                                            y_F_Short_Selling_I[5] = int(int(i) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                            y_F_Short_Selling_I[6] = x0[int(int(i) + int(1))]  # 交易日（datetime.date 類型）;
                                            y_F_Short_Selling_I[7] = x1[int(int(i) + int(1))]  # 當日總成交量（turnover volume）;
                                            y_F_Short_Selling_I[8] = x3[int(int(i) + int(1))]  # 當日開盤（opening）成交價;
                                            y_F_Short_Selling_I[9] = x4[int(int(i) + int(1))]  # 當日收盤（closing）成交價;
                                            y_F_Short_Selling_I[10] = x5[int(int(i) + int(1))]  # 當日最低（low）成交價;
                                            y_F_Short_Selling_I[11] = x6[int(int(i) + int(1))]  # 當日最高（high）成交價;
                                            # y_F_Short_Selling_I[12] = x2[int(int(i) + int(1))]  # 當日總成交金額（turnover amount）;
                                            # y_F_Short_Selling_I[13] = x20[int(int(i) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                            # y_F_Short_Selling_I[14] = x21[int(int(i) + int(1))]  # 當日每股收益（price earnings）;
                                            # y_F_Short_Selling_I[15] = x22[int(int(i) + int(1))]  # 當日每股净值（book value per share）;
                                            y_F_Short_Selling.append(y_F_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                            y_G_Short_Selling_I = float(float(+1.0) * float(x3[int(int(i) + int(1))]))
                                            y_G.append(y_G_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易差價利潤;
                                            y_A_Short_Selling_I *= float(0.0)
                                            y_A_Short_Selling_I += float(float(0.0) - float(x3[int(int(i) + int(1))]))
                                            # y_A_Short_Selling_I = float(float(0.0) - float(x3[i + 1]))  # float(-(x3[j + 1] - x3[i + 1]))
                                            # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                            #     y_A_Short_Selling_I = float(float(y_A_Short_Selling_I) / float(x3[int(int(i) + int(1))]))
                                            # y_A_Short_Selling.append(y_A_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝差價盈虧標示;
                                            y_B_Short_Selling_I *= int(0)
                                            if float(y_A_Short_Selling_I) > float(0.0):
                                                y_B_Short_Selling_I += int(+1)
                                            elif float(y_A_Short_Selling_I) < float(0.0):
                                                y_B_Short_Selling_I += int(-1)
                                            elif float(y_A_Short_Selling_I) == float(0.0):
                                                y_B_Short_Selling_I += int(0)
                                            # else:
                                            # y_B_Short_Selling.append(y_B_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易間隔日長;
                                            y_C_Short_Selling_I *= int(0)
                                            y_C_Short_Selling_I += int(int(len(P1_Array)) + int(1))
                                            # y_C_Short_Selling_I = (+math.inf)  # int((j + 1) - (i + 1))
                                            # y_C_Short_Selling.append(y_C_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易日成交價振幅平方和;
                                            y_D_Short_Selling_I *= float(0.0)
                                            y_D_Short_Selling_I += float(x8[int(int(i) + int(1))])
                                            # y_D_Short_Selling_I = float(x8[i + 1])  # float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                            # y_D_Short_Selling_I = float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))  # float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                            # y_D_Short_Selling.append(y_D_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            # 每兩次對衝交易日成交量（換手率）均值;
                                            y_E_Short_Selling_I *= float(0.0)
                                            y_E_Short_Selling_I += float(x1[int(int(i) + int(1))])
                                            # y_E_Short_Selling_I = float(x1[i + 1])  # float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                            # y_E_Short_Selling.append(y_E_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            i_2 = int(i)  # 記錄伸縮框的對衝 2 位置（j）初始值;
                                            # i += int(1)  # 將伸縮框跳躍到 (i + 1) 處的位置;
                                            # i = int(i + 1)  # 將伸縮框跳躍到 (i + 1) 處的位置;

                                            # 查找（融券做空 short selling）對衝交易的第二次買入交易日期時間切面節點;
                                            if int(int(int(i) + int(1)) + int(1)) <= int(len(P1_Array)):
                                                for j in range(int(i), int(int(len(P1_Array)) - int(1)), int(1)):

                                                    risk_drawdown_loss_Short_Selling = float(float(P4) + float(0.1))  # 回撤比例初值，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                                                    risk_drawdown_loss_Short_Selling *= float(0.0)
                                                    risk_drawdown_loss_Short_Selling += float(float(1.0) + float(float(float(x3[int(int(i) + int(1))]) - float(x3[int(int(j) + int(1))])) / float(x3[int(int(i) + int(1))])))  # 風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                                                    # risk_drawdown_loss_Short_Selling += float(float(1.0) + float(float(float(abs(float(x3[int(int(i) + int(1))]))) - float(abs(float(x3[int(int(j) + int(1))])))) / float(abs(float(x3[int(int(i) + int(1))])))))  # 風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;

                                                    # 記錄做空模式每個交易日的回撤值序列;
                                                    drawdown_Array_Short_Selling.append(risk_drawdown_loss_Short_Selling)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                    # 判斷是否超過預設的風險（最大回撤）閾值，若超過閾值，則買入强制平倉;
                                                    if float(risk_drawdown_loss_Short_Selling) <= float(P4):

                                                        # Index_date_transaction_Short_Selling += int(1)
                                                        # # Index_date_transaction_Short_Selling = int(int(Index_date_transaction_Short_Selling) + int(1))

                                                        # 按規則執行第二次買入（融資做多 buying long）的日期;
                                                        y_F_Short_Selling_I = [None] * int(16)
                                                        y_F_Short_Selling_I[0] = x0[int(int(j) + int(1))]  # 交易日期;
                                                        y_F_Short_Selling_I[1] = str("buy")  # 買入或賣出;
                                                        y_F_Short_Selling_I[2] = x3[int(int(j) + int(1))]  # 成交價;
                                                        y_F_Short_Selling_I[3] = None  # 成交量;
                                                        y_F_Short_Selling_I[4] = int(Index_date_transaction_Short_Selling)  # 每兩次對衝成交序號標識;
                                                        y_F_Short_Selling_I[5] = int(int(j) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                                        y_F_Short_Selling_I[6] = x0[int(int(j) + int(1))]  # 交易日（datetime.date 類型）;
                                                        y_F_Short_Selling_I[7] = x1[int(int(j) + int(1))]  # 當日總成交量（turnover volume）;
                                                        y_F_Short_Selling_I[8] = x3[int(int(j) + int(1))]  # 當日開盤（opening）成交價;
                                                        y_F_Short_Selling_I[9] = x4[int(int(j) + int(1))]  # 當日收盤（closing）成交價;
                                                        y_F_Short_Selling_I[10] = x5[int(int(j) + int(1))]  # 當日最低（low）成交價;
                                                        y_F_Short_Selling_I[11] = x6[int(int(j) + int(1))]  # 當日最高（high）成交價;
                                                        # y_F_Short_Selling_I[12] = x2[int(int(j) + int(1))]  # 當日總成交金額（turnover amount）;
                                                        # y_F_Short_Selling_I[13] = x20[int(int(j) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                                        # y_F_Short_Selling_I[14] = x21[int(int(j) + int(1))]  # 當日每股收益（price earnings）;
                                                        # y_F_Short_Selling_I[15] = x22[int(int(j) + int(1))]  # 當日每股净值（book value per share）;
                                                        y_F_Short_Selling.append(y_F_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                                        y_G_Short_Selling_I = float(float(-1.0) * float(x3[int(int(j) + int(1))]))
                                                        y_G.append(y_G_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易差價利潤;
                                                        y_A_Short_Selling_I *= float(0.0)
                                                        y_A_Short_Selling_I += float(float(-1.0) * float(float(x3[int(int(j) + int(1))]) - float(x3[int(int(i) + int(1))])))
                                                        # y_A_Short_Selling_I = float(-(x3[j + 1] - x3[i + 1]))
                                                        # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                                        #     y_A_Short_Selling_I = float(float(y_A_Short_Selling_I) / float(x3[int(int(i) + int(1))]))
                                                        # y_A_Short_Selling.append(y_A_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易盈虧標示;
                                                        y_B_Short_Selling_I *= int(0)
                                                        if float(y_A_Short_Selling_I) > float(0.0):
                                                            y_B_Short_Selling_I += int(+1)
                                                        elif float(y_A_Short_Selling_I) < float(0.0):
                                                            y_B_Short_Selling_I += int(-1)
                                                        elif float(y_A_Short_Selling_I) == float(0.0):
                                                            y_B_Short_Selling_I += int(0)
                                                        # else:
                                                        # y_B_Short_Selling.append(y_B_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易間隔日長;
                                                        y_C_Short_Selling_I *= int(0)
                                                        y_C_Short_Selling_I += int(int(int(j) + int(1)) - int(int(i) + int(1)))
                                                        # y_C_Short_Selling_I = int((j + 1) - (i + 1))
                                                        # y_C_Short_Selling.append(y_C_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易日成交價振幅平方和;
                                                        y_D_Short_Selling_I *= float(0.0)
                                                        y_D_Short_Selling_I += float(numpy.sqrt(float(x8[int(int(i) + int(1))])**2 + float(x8[int(int(j) + int(1))])**2))
                                                        # y_D_Short_Selling_I = float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                                        # y_D_Short_Selling_I = float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                                        # y_D_Short_Selling.append(y_D_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        # 每兩次對衝交易日成交量（換手率）均值;
                                                        y_E_Short_Selling_I *= float(0.0)
                                                        y_E_Short_Selling_I += float(float(float(x1[int(int(i) + int(1))]) + float(x1[int(int(j) + int(1))])) / int(2))
                                                        # y_E_Short_Selling_I = float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                                        # y_E_Short_Selling.append(y_E_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                        i_2 *= int(0)  # 將伸縮框的對衝 2 位置（j）位置歸零（起始點）;
                                                        i_2 += int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;
                                                        # i_2 = int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;

                                                        break  # 終止 for...end 循環;

                                                    # 判斷是否超過預設的風險（最大回撤）閾值，若小於閾值，則執行擇時規則判斷是否做對衝交易的買入操作;
                                                    if float(risk_drawdown_loss_Short_Selling) > float(P4):

                                                        # 數據序列最後一個交易日，强制平倉;
                                                        if int(j + 1) == int(int(len(P1_Array)) - int(1)):

                                                            # Index_date_transaction_Short_Selling += int(1)
                                                            # # Index_date_transaction_Short_Selling = int(int(Index_date_transaction_Short_Selling) + int(1))

                                                            # 按規則執行第二次買入（融資做多 buying long）的日期;
                                                            y_F_Short_Selling_I = [None] * int(16)
                                                            y_F_Short_Selling_I[0] = x0[int(int(j) + int(1))]  # 交易日期;
                                                            y_F_Short_Selling_I[1] = str("buy")  # 買入或賣出;
                                                            y_F_Short_Selling_I[2] = x3[int(int(j) + int(1))]  # 成交價;
                                                            y_F_Short_Selling_I[3] = None  # 成交量;
                                                            y_F_Short_Selling_I[4] = int(Index_date_transaction_Short_Selling)  # 每兩次對衝成交序號標識;
                                                            y_F_Short_Selling_I[5] = int(int(j) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                                            y_F_Short_Selling_I[6] = x0[int(int(j) + int(1))]  # 交易日（datetime.date 類型）;
                                                            y_F_Short_Selling_I[7] = x1[int(int(j) + int(1))]  # 當日總成交量（turnover volume）;
                                                            y_F_Short_Selling_I[8] = x3[int(int(j) + int(1))]  # 當日開盤（opening）成交價;
                                                            y_F_Short_Selling_I[9] = x4[int(int(j) + int(1))]  # 當日收盤（closing）成交價;
                                                            y_F_Short_Selling_I[10] = x5[int(int(j) + int(1))]  # 當日最低（low）成交價;
                                                            y_F_Short_Selling_I[11] = x6[int(int(j) + int(1))]  # 當日最高（high）成交價;
                                                            # y_F_Short_Selling_I[12] = x2[int(int(j) + int(1))]  # 當日總成交金額（turnover amount）;
                                                            # y_F_Short_Selling_I[13] = x20[int(int(j) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                                            # y_F_Short_Selling_I[14] = x21[int(int(j) + int(1))]  # 當日每股收益（price earnings）;
                                                            # y_F_Short_Selling_I[15] = x22[int(int(j) + int(1))]  # 當日每股净值（book value per share）;
                                                            y_F_Short_Selling.append(y_F_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                                            y_G_Short_Selling_I = float(float(-1.0) * float(x3[int(int(j) + int(1))]))
                                                            y_G.append(y_G_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易差價利潤;
                                                            y_A_Short_Selling_I *= float(0.0)
                                                            y_A_Short_Selling_I += float(float(-1.0) * float(float(x3[int(int(j) + int(1))]) - float(x3[int(int(i) + int(1))])))
                                                            # y_A_Short_Selling_I = float(-(x3[j + 1] - x3[i + 1]))
                                                            # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                                            #     y_A_Short_Selling_I = float(float(y_A_Short_Selling_I) / float(x3[int(int(i) + int(1))]))
                                                            # y_A_Short_Selling.append(y_A_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易盈虧標示;
                                                            y_B_Short_Selling_I *= int(0)
                                                            if float(y_A_Short_Selling_I) > float(0.0):
                                                                y_B_Short_Selling_I += int(+1)
                                                            elif float(y_A_Short_Selling_I) < float(0.0):
                                                                y_B_Short_Selling_I += int(-1)
                                                            elif float(y_A_Short_Selling_I) == float(0.0):
                                                                y_B_Short_Selling_I += int(0)
                                                            # else:
                                                            # y_B_Short_Selling.append(y_B_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易間隔日長;
                                                            y_C_Short_Selling_I *= int(0)
                                                            y_C_Short_Selling_I += int(int(int(j) + int(1)) - int(int(i) + int(1)))
                                                            # y_C_Short_Selling_I = int((j + 1) - (i + 1))
                                                            # y_C_Short_Selling.append(y_C_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易日成交價振幅平方和;
                                                            y_D_Short_Selling_I *= float(0.0)
                                                            y_D_Short_Selling_I += float(numpy.sqrt(float(x8[int(int(i) + int(1))])**2 + float(x8[int(int(j) + int(1))])**2))
                                                            # y_D_Short_Selling_I = float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                                            # y_D_Short_Selling_I = float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                                            # y_D_Short_Selling.append(y_D_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            # 每兩次對衝交易日成交量（換手率）均值;
                                                            y_E_Short_Selling_I *= float(0.0)
                                                            y_E_Short_Selling_I += float(float(float(x1[int(int(i) + int(1))]) + float(x1[int(int(j) + int(1))])) / int(2))
                                                            # y_E_Short_Selling_I = float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                                            # y_E_Short_Selling.append(y_E_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                            i_2 *= int(0)  # 將伸縮框的對衝 2 位置（j）位置歸零（起始點）;
                                                            i_2 += int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;
                                                            # i_2 = int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;

                                                            break  # 終止 for...end 循環;

                                                        # 做空模式下，最後一個交易日之前的所有交易日，依次按照擇時規則，判斷是否執行對衝交易的買入交易;
                                                        if int(j + 1) < int(int(len(P1_Array)) - int(1)):

                                                            x_P1_2 = P1_Array[j]
                                                            # print(x_P1_2)

                                                            if not ((x_P1_2 is None) or numpy.isnan(x_P1_2)):

                                                                # 判斷是否進行第二次買入（融券做空 short selling）交易;
                                                                if (x_P1 <= P2) and (x_P1_2 > P2):

                                                                    # Index_date_transaction_Short_Selling += int(1)
                                                                    # # Index_date_transaction_Short_Selling = int(int(Index_date_transaction_Short_Selling) + int(1))

                                                                    # 按規則執行第二次買入（融資做多 buying long）的日期;
                                                                    y_F_Short_Selling_I = [None] * int(16)
                                                                    y_F_Short_Selling_I[0] = x0[int(int(j) + int(1))]  # 交易日期;
                                                                    y_F_Short_Selling_I[1] = str("buy")  # 買入或賣出;
                                                                    y_F_Short_Selling_I[2] = x3[int(int(j) + int(1))]  # 成交價;
                                                                    y_F_Short_Selling_I[3] = None  # 成交量;
                                                                    y_F_Short_Selling_I[4] = int(Index_date_transaction_Short_Selling)  # 每兩次對衝成交序號標識;
                                                                    y_F_Short_Selling_I[5] = int(int(j) + int(1))  # 交易日期的序列號，用於繪圖可視化;
                                                                    y_F_Short_Selling_I[6] = x0[int(int(j) + int(1))]  # 交易日（datetime.date 類型）;
                                                                    y_F_Short_Selling_I[7] = x1[int(int(j) + int(1))]  # 當日總成交量（turnover volume）;
                                                                    y_F_Short_Selling_I[8] = x3[int(int(j) + int(1))]  # 當日開盤（opening）成交價;
                                                                    y_F_Short_Selling_I[9] = x4[int(int(j) + int(1))]  # 當日收盤（closing）成交價;
                                                                    y_F_Short_Selling_I[10] = x5[int(int(j) + int(1))]  # 當日最低（low）成交價;
                                                                    y_F_Short_Selling_I[11] = x6[int(int(j) + int(1))]  # 當日最高（high）成交價;
                                                                    # y_F_Short_Selling_I[12] = x2[int(int(j) + int(1))]  # 當日總成交金額（turnover amount）;
                                                                    # y_F_Short_Selling_I[13] = x20[int(int(j) + int(1))]  # 當日成交量（turnover volume）換手率（turnover rate）;
                                                                    # y_F_Short_Selling_I[14] = x21[int(int(j) + int(1))]  # 當日每股收益（price earnings）;
                                                                    # y_F_Short_Selling_I[15] = x22[int(int(j) + int(1))]  # 當日每股净值（book value per share）;
                                                                    y_F_Short_Selling.append(y_F_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling）;
                                                                    y_G_Short_Selling_I = float(float(-1.0) * float(x3[int(int(j) + int(1))]))
                                                                    y_G.append(y_G_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易差價利潤;
                                                                    y_A_Short_Selling_I *= float(0.0)
                                                                    y_A_Short_Selling_I += float(float(-1.0) * float(float(x3[int(int(j) + int(1))]) - float(x3[int(int(i) + int(1))])))
                                                                    # y_A_Short_Selling_I = float(-(x3[j + 1] - x3[i + 1]))
                                                                    # if float(x3[int(int(i) + int(1))]) != float(0.0):
                                                                    #     y_A_Short_Selling_I = float(float(y_A_Short_Selling_I) / float(x3[int(int(i) + int(1))]))
                                                                    # y_A_Short_Selling.append(y_A_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易盈虧標示;
                                                                    y_B_Short_Selling_I *= int(0)
                                                                    if float(y_A_Short_Selling_I) > float(0.0):
                                                                        y_B_Short_Selling_I += int(+1)
                                                                    elif float(y_A_Short_Selling_I) < float(0.0):
                                                                        y_B_Short_Selling_I += int(-1)
                                                                    elif float(y_A_Short_Selling_I) == float(0.0):
                                                                        y_B_Short_Selling_I += int(0)
                                                                    # else:
                                                                    # y_B_Short_Selling.append(y_B_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易間隔日長;
                                                                    y_C_Short_Selling_I *= int(0)
                                                                    y_C_Short_Selling_I += int(int(int(j) + int(1)) - int(int(i) + int(1)))
                                                                    # y_C_Short_Selling_I = int((j + 1) - (i + 1))
                                                                    # y_C_Short_Selling.append(y_C_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易日成交價振幅平方和;
                                                                    y_D_Short_Selling_I *= float(0.0)
                                                                    y_D_Short_Selling_I += float(numpy.sqrt(float(x8[int(int(i) + int(1))])**2 + float(x8[int(int(j) + int(1))])**2))
                                                                    # y_D_Short_Selling_I = float(numpy.sqrt(float(x8[i + 1])**2 + float(x8[j + 1])**2))
                                                                    # y_D_Short_Selling_I = float(numpy.sqrt(float(numpy.std([x3[i + 1], x4[i + 1], x5[i + 1], x6[i + 1]], ddof = 1))**2 + float(numpy.std([x3[j + 1], x4[j + 1], x5[j + 1], x6[j + 1]], ddof = 1))**2))
                                                                    # y_D_Short_Selling.append(y_D_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    # 每兩次對衝交易日成交量（換手率）均值;
                                                                    y_E_Short_Selling_I *= float(0.0)
                                                                    y_E_Short_Selling_I += float(float(float(x1[int(int(i) + int(1))]) + float(x1[int(int(j) + int(1))])) / int(2))
                                                                    # y_E_Short_Selling_I = float(float(float(x1[i + 1]) + float(x1[j + 1])) / 2)
                                                                    # y_E_Short_Selling.append(y_E_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                                                    i_2 *= int(0)  # 將伸縮框的對衝 2 位置（j）位置歸零（起始點）;
                                                                    i_2 += int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;
                                                                    # i_2 = int(j)  # 記錄伸縮框的對衝 2 位置（j）跳躍到 (j) 處的位置;

                                                                    break  # 終止 for...end 循環;

                                            # 做空（Short Selling）記錄;
                                            y_A_Short_Selling.append(y_A_Short_Selling_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                                            y_B_Short_Selling.append(y_B_Short_Selling_I)
                                            y_C_Short_Selling.append(y_C_Short_Selling_I)
                                            y_D_Short_Selling.append(y_D_Short_Selling_I)
                                            y_E_Short_Selling.append(y_E_Short_Selling_I)
                                            # 記錄做空模式本輪對衝交易的回撤值序列;
                                            if isinstance(drawdown_Array_Short_Selling, list) and int(len(drawdown_Array_Short_Selling)) >= int(0):
                                                y_H_Short_Selling.append(drawdown_Array_Short_Selling)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                            i *= int(0)  # 將伸縮框的位置歸零（起始點）;
                                            i += int(i_2)  # 將伸縮框跳躍到(j) 或 (j + 1) 處的位置;

                    i = None

                # print(y_G)
                # print(y_A_Long_Position)
                # print(y_B_Long_Position)
                # print(y_C_Long_Position)
                # print(y_D_Long_Position)
                # print(y_E_Long_Position)
                # print(y_F_Long_Position)
                # print(y_H_Long_Position)
                # print(y_A_Short_Selling)
                # print(y_B_Short_Selling)
                # print(y_C_Short_Selling)
                # print(y_D_Short_Selling)
                # print(y_E_Short_Selling)
                # print(y_F_Short_Selling)
                # print(y_H_Short_Selling)

                # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                # 做多（Long Position）記錄;
                y_total_Long_Position = None  # float(0.0);  # 每兩次對衝交易利潤，纍加總計;
                y_maximum_drawdown_Long_Position = None  # float(0.0);  # 兩次對衝交易之間的最大回撤值，取極值統計;
                y_Positive_Long_Position = None  # float(0.0);  # 交易規則正利潤纍計;
                y_Negative_Long_Position = None  # float(0.0);  # 交易規則負利潤纍計;
                y_P_Positive_Long_Position = None  # float(0.0);
                y_P_Negative_Long_Position = None  # float(0.0);
                y_amplitude_Long_Position = None  # float(0.0);  # amplitude_rate;
                y_turnover_Long_Position = None  # float(0.0);  # turnover_volume; turnover_rate;
                y_date_transaction_between_Long_Position = None  # float(0.0);  # Between two date_transaction;
                y_Long_Position_profit = None  # float(0.0);  # 優化目標變量，利潤 × 權重;
                y_Long_Position_loss = None  # float(0.0);  # 優化目標變量，損失 × 權重;
                if investment_method == "Long_Position_and_Short_Selling" or investment_method == "Long_Position":
                    # print(y_A_Long_Position)
                    # y_total_Long_Position = float(0.0)  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                    if int(len(y_A_Long_Position)) > int(0):
                        y_total_Long_Position = float(sum([float(y_A_Long_Position[i]) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))  # 每兩次對衝交易利潤 × 頻率，纍加總計;

                    # print(y_maximum_drawdown_Long_Position)
                    # y_maximum_drawdown_Long_Position = float(0.0)  # 兩次對衝交易之間的最大回撤值，纍加總計;
                    if int(len(y_H_Long_Position)) > int(0) and int(max([int(len(y_H_Long_Position[i])) if isinstance(y_H_Long_Position[i], list) else (-math.inf) for i in range(int(0), int(len(y_H_Long_Position)), int(1))])) > int(0):
                        y_maximum_drawdown_Long_Position = float(min([float(min(y_H_Long_Position[i])) for i in range(int(0), int(len(y_H_Long_Position)), int(1)) if (isinstance(y_H_Long_Position[i], list) and int(len(y_H_Long_Position[i])) > int(0))]))  # 每兩次對衝交易最大回撤損失，取極值統計;
                        # y_maximum_drawdown_Long_Position = float(min([float(min(y_H_Long_Position[i])) if (isinstance(y_H_Long_Position[i], list) and int(len(y_H_Long_Position[i])) > int(0)) else (+math.inf) for i in range(int(0), int(len(y_H_Long_Position)), int(1))]))  # 每兩次對衝交易最大回撤損失，取極值統計;

                    # print(y_A_Long_Position);
                    # y_Positive_Long_Position = float(0.0)  # 交易規則正利潤纍計;
                    if int(len([float(y_A_Long_Position[i]) if float(y_A_Long_Position[i]) > float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))])) > int(0):
                        y_Positive_Long_Position = float(sum([float(y_A_Long_Position[i]) if float(y_A_Long_Position[i]) > float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))
                    # y_Negative_Long_Position = float(0.0)  # 交易規則負利潤纍計;
                    if int(len([float(y_A_Long_Position[i]) if float(y_A_Long_Position[i]) < float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))])) > int(0):
                        y_Negative_Long_Position = float(sum([float(y_A_Long_Position[i]) if float(y_A_Long_Position[i]) < float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))

                    # print(y_A_Long_Position)
                    # y_P_Positive_Long_Position = float(0.0)
                    # y_P_Negative_Long_Position = float(0.0)
                    if int(len(y_A_Long_Position)) > int(0):
                        y_P_Positive_Long_Position = float(int(sum([int(1) if float(y_A_Long_Position[i]) > float(0.0) else int(0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))])) / int(len(y_A_Long_Position)))
                        y_P_Negative_Long_Position = float(int(sum([int(1) if float(y_A_Long_Position[i]) < float(0.0) else int(0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))])) / int(len(y_A_Long_Position)))

                    # print(y_D_Long_Position)
                    # y_amplitude_Long_Position = float(0.0)  # amplitude_rate
                    if int(len(y_D_Long_Position)) > int(0):
                        y_amplitude_Long_Position = float(numpy.mean(y_D_Long_Position))  # amplitude_rate

                    # print(y_E_Long_Position)
                    # y_turnover_Long_Position = float(0.0)  # turnover_volume; turnover_rate
                    if int(len(y_E_Long_Position)) > int(0):
                        y_turnover_Long_Position = float(numpy.mean(y_E_Long_Position))  # turnover_volume; turnover_rate

                    # print(y_C_Long_Position)
                    # y_date_transaction_between_Long_Position = float(0.0)  # Between two date_transaction;
                    if int(len(y_C_Long_Position)) > int(0):
                        y_date_transaction_between_Long_Position = float(numpy.mean(y_C_Long_Position))  # Between two date_transaction

                    weight_Long_Position = []
                    # print(y_A_Long_Position)
                    if int(len(y_A_Long_Position)) > int(0):
                        if (not (y_P_Positive_Long_Position is None)) and (not (y_P_Negative_Long_Position is None)):
                            weight_Long_Position = [float(y_P_Positive_Long_Position) if float(y_A_Long_Position[i]) > float(0.0) else float(y_P_Negative_Long_Position) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]
                            # if float(y_P_Positive_Long_Position) > float(0.0) and float(y_P_Negative_Long_Position) > float(0.0):
                            #     weight_Long_Position = [float(y_P_Positive_Long_Position) if float(y_A_Long_Position[i]) > float(0.0) else float(y_P_Negative_Long_Position) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]
                            # elif float(y_P_Positive_Long_Position) > float(0.0) and float(y_P_Negative_Long_Position) <= float(0.0):
                            #     weight_Long_Position = [float(y_P_Positive_Long_Position) if float(y_A_Long_Position[i]) > float(0.0) else float(y_P_Negative_Long_Position) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]
                            # elif float(y_P_Positive_Long_Position) <= float(0.0) and float(y_P_Negative_Long_Position) > float(0.0):
                            #     weight_Long_Position = [float(y_P_Positive_Long_Position) if float(y_A_Long_Position[i]) > float(0.0) else float(y_P_Negative_Long_Position) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]
                            # else:
                            #     weight_Long_Position = [float(1.0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]
                        elif (y_P_Positive_Long_Position is None) or (y_P_Negative_Long_Position is None):
                            weight_Long_Position = [float(1.0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]
                        # else:
                    # # print(y_C_Long_Position)
                    # if int(len(y_C_Long_Position)) > int(0):
                    #     weight_Long_Position = [float(float(1.0) / float(y_C_Long_Position[i])) for i in range(int(0), int(len(y_C_Long_Position)), int(1))]  # 每兩次對衝交易間隔日長的倒數;
                    # # print(y_D_Long_Position)
                    # if int(len(y_D_Long_Position)) > int(0):
                    #     weight_Long_Position = [float(float(1.0) / float(y_D_Long_Position[i])) for i in range(int(0), int(len(y_D_Long_Position)), int(1))]  # 兩次對衝交易日成交價振幅平方和的倒數;
                    # # print(y_E_Long_Position)
                    # if int(len(y_E_Long_Position)) > int(0):
                    #     weight_Long_Position = [float(y_E_Long_Position[i]) for i in range(int(0), int(len(y_E_Long_Position)), int(1))]  # 兩次對衝交易日成交量（換手率）均值;
                    # print(weight_Long_Position)

                    # print(y_A_Long_Position)
                    # y_Long_Position_profit = float(0.0)  # 優化目標變量;
                    if int(len(y_A_Long_Position)) > int(0) and int(len(weight_Long_Position)) > int(0):
                        y_Long_Position_profit = float(sum([float(float(weight_Long_Position[i]) * float(y_A_Long_Position[i])) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                    elif int(len(y_A_Long_Position)) > int(0) and int(len(weight_Long_Position)) <= int(0):
                        y_Long_Position_profit = float(sum([float(y_A_Long_Position[i]) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                    # else:
                    # print(y_maximum_drawdown_Long_Position)
                    # y_Long_Position_loss = float(0.0)  # 優化目標變量;
                    if not (y_maximum_drawdown_Long_Position is None):
                        if float(y_maximum_drawdown_Long_Position) > float(0.0):
                            if (not (y_P_Positive_Long_Position is None)) and (not (y_P_Negative_Long_Position is None)):
                                if float(y_P_Positive_Long_Position) > float(y_P_Negative_Long_Position):
                                    y_Long_Position_loss = float(float(y_maximum_drawdown_Long_Position) * float(float(y_P_Positive_Long_Position) - float(y_P_Negative_Long_Position)))  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                                elif float(y_P_Positive_Long_Position) <= float(y_P_Negative_Long_Position):
                                    y_Long_Position_loss = float(float(y_maximum_drawdown_Long_Position) * float(0.0))  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                                # else:
                            elif (y_P_Positive_Long_Position is None) or (y_P_Negative_Long_Position is None):
                                y_Long_Position_loss = float(y_maximum_drawdown_Long_Position)  # 每兩次對衝交易最大回撤，加權取極值總計;
                            # else:
                        elif float(y_maximum_drawdown_Long_Position) <= float(0.0):
                            if (not (y_P_Positive_Long_Position is None)) and (not (y_P_Negative_Long_Position is None)):
                                y_Long_Position_loss = float(float(y_maximum_drawdown_Long_Position) * float(y_P_Negative_Long_Position))  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                            elif (y_P_Positive_Long_Position is None) or (y_P_Negative_Long_Position is None):
                                y_Long_Position_loss = float(y_maximum_drawdown_Long_Position)  # 每兩次對衝交易最大回撤，加權取極值總計;
                            # else:
                        # else:

                # print(y_total_Long_Position)
                # print(y_maximum_drawdown_Long_Position)
                # print(y_Positive_Long_Position)
                # print(y_Negative_Long_Position)
                # print(y_P_Positive_Long_Position)
                # print(y_P_Negative_Long_Position)
                # print(y_amplitude_Long_Position)
                # print(y_turnover_Long_Position)
                # print(y_date_transaction_between_Long_Position)
                # print(weight_Long_Position)
                # print(y_Long_Position_profit)
                # print(y_Long_Position_loss)

                # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                # 做空（Short Selling）記錄;
                y_total_Short_Selling = None  # float(0.0);  # 每兩次對衝交易利潤，纍加總計;
                y_maximum_drawdown_Short_Selling = None  # float(0.0);  # 兩次對衝交易之間的最大回撤值，取極值統計;
                y_Positive_Short_Selling = None  # float(0.0);  # 交易規則正利潤纍計;
                y_Negative_Short_Selling = None  # float(0.0);  # 交易規則負利潤纍計;
                y_P_Positive_Short_Selling = None  # float(0.0);
                y_P_Negative_Short_Selling = None  # float(0.0);
                y_amplitude_Short_Selling = None  # float(0.0);  # amplitude_rate;
                y_turnover_Short_Selling = None  # float(0.0);  # turnover_volume; turnover_rate;
                y_date_transaction_between_Short_Selling = None  # float(0.0);  # Between two date_transaction;
                y_Short_Selling_profit = None  # float(0.0);  # 優化目標變量，利潤 × 權重;
                y_Short_Selling_loss = None  # float(0.0);  # 優化目標變量，損失 × 權重;
                if investment_method == "Long_Position_and_Short_Selling" or investment_method == "Short_Selling":
                    # print(y_A_Short_Selling)
                    # y_total_Short_Selling = float(0.0)  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                    if int(len(y_A_Short_Selling)) > int(0):
                        y_total_Short_Selling = float(sum([float(y_A_Short_Selling[i]) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))  # 每兩次對衝交易利潤 × 頻率，纍加總計;

                    # print(y_maximum_drawdown_Short_Selling)
                    # y_maximum_drawdown_Short_Selling = float(0.0)  # 兩次對衝交易之間的最大回撤值，纍加總計;
                    if int(len(y_H_Short_Selling)) > int(0) and int(max([int(len(y_H_Short_Selling[i])) if isinstance(y_H_Short_Selling[i], list) else (-math.inf) for i in range(int(0), int(len(y_H_Short_Selling)), int(1))])) > int(0):
                        y_maximum_drawdown_Short_Selling = float(min([float(min(y_H_Short_Selling[i])) for i in range(int(0), int(len(y_H_Short_Selling)), int(1)) if (isinstance(y_H_Short_Selling[i], list) and int(len(y_H_Short_Selling[i])) > int(0))]))  # 每兩次對衝交易最大回撤損失，取極值統計;
                        # y_maximum_drawdown_Short_Selling = float(min([float(min(y_H_Short_Selling[i])) if (isinstance(y_H_Short_Selling[i], list) and int(len(y_H_Short_Selling[i])) > int(0)) else (+math.inf) for i in range(int(0), int(len(y_H_Short_Selling)), int(1))]))  # 每兩次對衝交易最大回撤損失，取極值統計;

                    # print(y_A_Short_Selling);
                    # y_Positive_Short_Selling = float(0.0)  # 交易規則正利潤纍計;
                    if int(len([float(y_A_Short_Selling[i]) if float(y_A_Short_Selling[i]) > float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))])) > int(0):
                        y_Positive_Short_Selling = float(sum([float(y_A_Short_Selling[i]) if float(y_A_Short_Selling[i]) > float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))
                    # y_Negative_Short_Selling = float(0.0)  # 交易規則負利潤纍計;
                    if int(len([float(y_A_Short_Selling[i]) if float(y_A_Short_Selling[i]) < float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))])) > int(0):
                        y_Negative_Short_Selling = float(sum([float(y_A_Short_Selling[i]) if float(y_A_Short_Selling[i]) < float(0.0) else float(0.0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))

                    # print(y_A_Short_Selling)
                    # y_P_Positive_Short_Selling = float(0.0)
                    # y_P_Negative_Short_Selling = float(0.0)
                    if int(len(y_A_Short_Selling)) > int(0):
                        y_P_Positive_Short_Selling = float(int(sum([int(1) if float(y_A_Short_Selling[i]) > float(0.0) else int(0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))])) / int(len(y_A_Short_Selling)))
                        y_P_Negative_Short_Selling = float(int(sum([int(1) if float(y_A_Short_Selling[i]) < float(0.0) else int(0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))])) / int(len(y_A_Short_Selling)))

                    # print(y_D_Short_Selling)
                    # y_amplitude_Short_Selling = float(0.0)  # amplitude_rate
                    if int(len(y_D_Short_Selling)) > int(0):
                        y_amplitude_Short_Selling = float(numpy.mean(y_D_Short_Selling))  # amplitude_rate

                    # print(y_E_Short_Selling)
                    # y_turnover_Short_Selling = float(0.0)  # turnover_volume; turnover_rate
                    if int(len(y_E_Short_Selling)) > int(0):
                        y_turnover_Short_Selling = float(numpy.mean(y_E_Short_Selling))  # turnover_volume; turnover_rate

                    # print(y_C_Short_Selling)
                    # y_date_transaction_between_Short_Selling = float(0.0)  # Between two date_transaction;
                    if int(len(y_C_Short_Selling)) > int(0):
                        y_date_transaction_between_Short_Selling = float(numpy.mean(y_C_Short_Selling))  # Between two date_transaction

                    weight_Short_Selling = []
                    # print(y_A_Short_Selling)
                    if int(len(y_A_Short_Selling)) > int(0):
                        if (not (y_P_Positive_Short_Selling is None)) and (not (y_P_Negative_Short_Selling is None)):
                            weight_Short_Selling = [float(y_P_Positive_Short_Selling) if float(y_A_Short_Selling[i]) > float(0.0) else float(y_P_Negative_Short_Selling) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]
                            # if float(y_P_Positive_Short_Selling) > float(0.0) and float(y_P_Negative_Short_Selling) > float(0.0):
                            #     weight_Short_Selling = [float(y_P_Positive_Short_Selling) if float(y_A_Short_Selling[i]) > float(0.0) else float(y_P_Negative_Short_Selling) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]
                            # elif float(y_P_Positive_Short_Selling) > float(0.0) and float(y_P_Negative_Short_Selling) <= float(0.0):
                            #     weight_Short_Selling = [float(y_P_Positive_Short_Selling) if float(y_A_Short_Selling[i]) > float(0.0) else float(y_P_Negative_Short_Selling) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]
                            # elif float(y_P_Positive_Short_Selling) <= float(0.0) and float(y_P_Negative_Short_Selling) > float(0.0):
                            #     weight_Short_Selling = [float(y_P_Positive_Short_Selling) if float(y_A_Short_Selling[i]) > float(0.0) else float(y_P_Negative_Short_Selling) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]
                            # else:
                            #     weight_Short_Selling = [float(1.0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]
                        elif (y_P_Positive_Short_Selling is None) or (y_P_Negative_Short_Selling is None):
                            weight_Short_Selling = [float(1.0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]
                        # else:
                    # # print(y_C_Short_Selling)
                    # if int(len(y_C_Short_Selling)) > int(0):
                    #     weight_Short_Selling = [float(float(1.0) / float(y_C_Short_Selling[i])) for i in range(int(0), int(len(y_C_Short_Selling)), int(1))]  # 每兩次對衝交易間隔日長的倒數;
                    # # print(y_D_Short_Selling)
                    # if int(len(y_D_Short_Selling)) > int(0):
                    #     weight_Short_Selling = [float(float(1.0) / float(y_D_Short_Selling[i])) for i in range(int(0), int(len(y_D_Short_Selling)), int(1))]  # 兩次對衝交易日成交價振幅平方和的倒數;
                    # # print(y_E_Short_Selling)
                    # if int(len(y_E_Short_Selling)) > int(0):
                    #     weight_Short_Selling = [float(y_E_Short_Selling[i]) for i in range(int(0), int(len(y_E_Short_Selling)), int(1))]  # 兩次對衝交易日成交量（換手率）均值;
                    # print(weight_Short_Selling)

                    # print(y_A_Short_Selling)
                    # y_Short_Selling_profit = float(0.0)  # 優化目標變量;
                    if int(len(y_A_Short_Selling)) > int(0) and int(len(weight_Short_Selling)) > int(0):
                        y_Short_Selling_profit = float(sum([float(float(weight_Short_Selling[i]) * float(y_A_Short_Selling[i])) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                    elif int(len(y_A_Short_Selling)) > int(0) and int(len(weight_Short_Selling)) <= int(0):
                        y_Short_Selling_profit = float(sum([float(y_A_Short_Selling[i]) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))  # 每兩次對衝交易利潤 × 權重，加權纍加總計;
                    # else:
                    # print(y_maximum_drawdown_Short_Selling)
                    # y_Short_Selling_loss = float(0.0)  # 優化目標變量;
                    if not (y_maximum_drawdown_Short_Selling is None):
                        if float(y_maximum_drawdown_Short_Selling) > float(0.0):
                            if (not (y_P_Positive_Short_Selling is None)) and (not (y_P_Negative_Short_Selling is None)):
                                if float(y_P_Positive_Short_Selling) > float(y_P_Negative_Short_Selling):
                                    y_Short_Selling_loss = float(float(y_maximum_drawdown_Short_Selling) * float(float(y_P_Positive_Short_Selling) - float(y_P_Negative_Short_Selling)))  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                                elif float(y_P_Positive_Short_Selling) <= float(y_P_Negative_Short_Selling):
                                    y_Short_Selling_loss = float(float(y_maximum_drawdown_Short_Selling) * float(0.0))  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                                # else:
                            elif (y_P_Positive_Short_Selling is None) or (y_P_Negative_Short_Selling is None):
                                y_Short_Selling_loss = float(y_maximum_drawdown_Short_Selling)  # 每兩次對衝交易最大回撤，加權取極值總計;
                            # else:
                        elif float(y_maximum_drawdown_Short_Selling) <= float(0.0):
                            if (not (y_P_Positive_Short_Selling is None)) and (not (y_P_Negative_Short_Selling is None)):
                                y_Short_Selling_loss = float(float(y_maximum_drawdown_Short_Selling) * float(y_P_Negative_Short_Selling))  # 每兩次對衝交易最大回撤 × 權重，加權取極值總計;
                            elif (y_P_Positive_Short_Selling is None) or (y_P_Negative_Short_Selling is None):
                                y_Short_Selling_loss = float(y_maximum_drawdown_Short_Selling)  # 每兩次對衝交易最大回撤，加權取極值總計;
                            # else:
                        # else:

                # print(y_total_Short_Selling)
                # print(y_maximum_drawdown_Short_Selling)
                # print(y_Positive_Short_Selling)
                # print(y_Negative_Short_Selling)
                # print(y_P_Positive_Short_Selling)
                # print(y_P_Negative_Short_Selling)
                # print(y_amplitude_Short_Selling)
                # print(y_turnover_Short_Selling)
                # print(y_date_transaction_between_Short_Selling)
                # print(weight_Short_Selling)
                # print(y_Short_Selling_profit)
                # print(y_Short_Selling_loss)

                # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
                # 做多（Long Position）記錄 + 做空（Short Selling）記錄，纍計求和;
                y_total = None  # float(y_total_Long_Position + y_total_Short_Selling)  # 每兩次對衝交易利潤，纍加總計;
                if (not (y_total_Long_Position is None)) and (not (y_total_Short_Selling is None)):
                    y_total = float(sum([float(y_total_Long_Position), float(y_total_Short_Selling)]))  # 每兩次對衝交易利潤，纍加總計;
                elif (not (y_total_Long_Position is None)) and (y_total_Short_Selling is None):
                    y_total = float(y_total_Long_Position)
                elif (y_total_Long_Position is None) and (not (y_total_Short_Selling is None)):
                    y_total = float(y_total_Short_Selling)
                else:
                    y_total = None
                y_maximum_drawdown = None  # float(min([y_maximum_drawdown_Long_Position, y_maximum_drawdown_Short_Selling]))  # 兩次對衝交易之間的最大回撤值，取極值統計;
                if (not (y_maximum_drawdown_Long_Position is None)) and (not (y_maximum_drawdown_Short_Selling is None)):
                    y_maximum_drawdown = float(min([y_maximum_drawdown_Long_Position, y_maximum_drawdown_Short_Selling]))  # 兩次對衝交易之間的最大回撤值，取極值統計;
                elif (not (y_maximum_drawdown_Long_Position is None)) and (y_maximum_drawdown_Short_Selling is None):
                    y_maximum_drawdown = float(y_maximum_drawdown_Long_Position)
                elif (y_maximum_drawdown_Long_Position is None) and (not (y_maximum_drawdown_Short_Selling is None)):
                    y_maximum_drawdown = float(y_maximum_drawdown_Short_Selling)
                else:
                    y_maximum_drawdown = None
                y_Positive = None  # float(y_Positive_Long_Position + y_Positive_Short_Selling)  # 交易規則正利潤纍計;
                if (not (y_Positive_Long_Position is None)) and (not (y_Positive_Short_Selling is None)):
                    y_Positive = float(sum([float(y_Positive_Long_Position), float(y_Positive_Short_Selling)]))  # 交易規則正利潤纍計;
                elif (not (y_Positive_Long_Position is None)) and (y_Positive_Short_Selling is None):
                    y_Positive = float(y_Positive_Long_Position)
                elif (y_Positive_Long_Position is None) and (not (y_Positive_Short_Selling is None)):
                    y_Positive = float(y_Positive_Short_Selling)
                else:
                    y_Positive = None
                y_Negative = None  # float(y_Negative_Long_Position + y_Negative_Short_Selling)  # 交易規則負利潤纍計;
                if (not (y_Negative_Long_Position is None)) and (not (y_Negative_Short_Selling is None)):
                    y_Negative = float(sum([float(y_Negative_Long_Position), float(y_Negative_Short_Selling)]))  # 交易規則負利潤纍計;
                elif (not (y_Negative_Long_Position is None)) and (y_Negative_Short_Selling is None):
                    y_Negative = float(y_Negative_Long_Position)
                elif (y_Negative_Long_Position is None) and (not (y_Negative_Short_Selling is None)):
                    y_Negative = float(y_Negative_Short_Selling)
                else:
                    y_Negative = None
                y_P_Positive = None  # float(0.0)
                y_P_Negative = None  # float(0.0)
                if int(len(y_A_Long_Position)) > int(0) or int(len(y_A_Short_Selling)) > int(0):
                    y_Positive_count_Long_Position = int(0)
                    y_Negative_count_Long_Position = int(0)
                    y_Positive_count_Short_Selling = int(0)
                    y_Negative_count_Short_Selling = int(0)
                    if int(len(y_A_Long_Position)) > int(0):
                        y_Positive_count_Long_Position = float(sum([int(1) if float(y_A_Long_Position[i]) > float(0.0) else int(0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))
                        y_Negative_count_Long_Position = float(sum([int(1) if float(y_A_Long_Position[i]) < float(0.0) else int(0) for i in range(int(0), int(len(y_A_Long_Position)), int(1))]))
                    if int(len(y_A_Short_Selling)) > int(0):
                        y_Positive_count_Short_Selling = float(sum([int(1) if float(y_A_Short_Selling[i]) > float(0.0) else int(0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))
                        y_Negative_count_Short_Selling = float(sum([int(1) if float(y_A_Short_Selling[i]) < float(0.0) else int(0) for i in range(int(0), int(len(y_A_Short_Selling)), int(1))]))
                    y_P_Positive = float(int(int(y_Positive_count_Long_Position) + int(y_Positive_count_Short_Selling)) / int(int(len(y_A_Long_Position)) + int(len(y_A_Short_Selling))))
                    y_P_Negative = float(int(int(y_Negative_count_Long_Position) + int(y_Negative_count_Short_Selling)) / int(int(len(y_A_Long_Position)) + int(len(y_A_Short_Selling))))
                y_amplitude = None
                if (not (y_amplitude_Long_Position is None)) and (not (y_amplitude_Short_Selling is None)):
                    y_amplitude = float(numpy.median([float(y_amplitude_Long_Position), float(y_amplitude_Short_Selling)]))  # 取中位數;
                    # y_amplitude = float(max([float(y_amplitude_Long_Position), float(y_amplitude_Short_Selling)]))  # 取極大值;
                    # y_amplitude = float(min([float(y_amplitude_Long_Position), float(y_amplitude_Short_Selling)]))  # 取極小值;
                    # y_amplitude = float(sum([float(y_amplitude_Long_Position), float(y_amplitude_Short_Selling)]))  # 取總和;
                    # y_amplitude = float(numpy.mean([float(y_amplitude_Long_Position), float(y_amplitude_Short_Selling)]))  # 取均值;
                elif (not (y_amplitude_Long_Position is None)) and (y_amplitude_Short_Selling is None):
                    y_amplitude = float(y_amplitude_Long_Position)
                elif (y_amplitude_Long_Position is None) and (not (y_amplitude_Short_Selling is None)):
                    y_amplitude = float(y_amplitude_Short_Selling)
                else:
                    y_amplitude = None
                y_turnover = None  # float(float(y_turnover_Long_Position + y_turnover_Short_Selling) / int(2))
                if (not (y_turnover_Long_Position is None)) and (not (y_turnover_Short_Selling is None)):
                    y_turnover = float(numpy.median([float(y_turnover_Long_Position), float(y_turnover_Short_Selling)]))  # 取中位數;
                    # y_turnover = float(max([float(y_turnover_Long_Position), float(y_turnover_Short_Selling)]))  # 取極大值;
                    # y_turnover = float(min([float(y_turnover_Long_Position), float(y_turnover_Short_Selling)]))  # 取極小值;
                    # y_turnover = float(sum([float(y_turnover_Long_Position), float(y_turnover_Short_Selling)]))  # 取總和;
                    # y_turnover = float(numpy.mean([float(y_turnover_Long_Position), float(y_turnover_Short_Selling)]))  # 取均值;
                elif (not (y_turnover_Long_Position is None)) and (y_turnover_Short_Selling is None):
                    y_turnover = float(y_turnover_Long_Position)
                elif (y_turnover_Long_Position is None) and (not (y_turnover_Short_Selling is None)):
                    y_turnover = float(y_turnover_Short_Selling)
                else:
                    y_turnover = None
                y_date_transaction_between = None  # float(float(y_date_transaction_between_Long_Position + y_date_transaction_between_Short_Selling) / int(2))  # Between two date_transaction;
                if (not (y_date_transaction_between_Long_Position is None)) and (not (y_date_transaction_between_Short_Selling is None)):
                    y_date_transaction_between = float(numpy.median([float(y_date_transaction_between_Long_Position), float(y_date_transaction_between_Short_Selling)]))  # 取中位數;
                    # y_date_transaction_between = float(max([float(y_date_transaction_between_Long_Position), float(y_date_transaction_between_Short_Selling)]))  # 取極大值;
                    # y_date_transaction_between = float(min([float(y_date_transaction_between_Long_Position), float(y_date_transaction_between_Short_Selling)]))  # 取極小值;
                    # y_date_transaction_between = float(sum([float(y_date_transaction_between_Long_Position), float(y_date_transaction_between_Short_Selling)]))  # 取總和;
                    # y_date_transaction_between = float(numpy.mean([float(y_date_transaction_between_Long_Position), float(y_date_transaction_between_Short_Selling)]))  # 取均值;
                elif (not (y_date_transaction_between_Long_Position is None)) and (y_date_transaction_between_Short_Selling is None):
                    y_date_transaction_between = float(y_date_transaction_between_Long_Position)
                elif (y_date_transaction_between_Long_Position is None) and (not (y_date_transaction_between_Short_Selling is None)):
                    y_date_transaction_between = float(y_date_transaction_between_Short_Selling)
                else:
                    y_date_transaction_between = None
                y_profit = None  # float(y_Long_Position_profit + y_Short_Selling_profit)  # 優化目標變量;
                if (y_Long_Position_profit is None) and (y_Short_Selling_profit is None):
                    y_profit = None
                elif (not (y_Long_Position_profit is None)) and (y_Short_Selling_profit is None):
                    y_profit = float(y_Long_Position_profit)
                elif (y_Long_Position_profit is None) and (not (y_Short_Selling_profit is None)):
                    y_profit = float(y_Short_Selling_profit)
                else:
                    # y_profit = float(max([float(y_Long_Position_profit), float(y_Short_Selling_profit)]))  # 取極大值;
                    # y_profit = float(min([float(y_Long_Position_profit), float(y_Short_Selling_profit)]))  # 取極小值;
                    # y_profit = float(numpy.mean([float(y_Long_Position_profit), float(y_Short_Selling_profit)]))  # 取均值;
                    # y_profit = float(numpy.median([float(y_Long_Position_profit), float(y_Short_Selling_profit)]))  # 取中位數;
                    y_profit = float(sum([float(y_Long_Position_profit), float(y_Short_Selling_profit)]))  # 取總和;
                y_loss = None  # float(y_Long_Position_loss + y_Short_Selling_loss)  # 優化目標變量;
                if (y_Long_Position_loss is None) and (y_Short_Selling_loss is None):
                    y_loss = None
                elif (not (y_Long_Position_loss is None)) and (y_Short_Selling_loss is None):
                    y_loss = float(y_Long_Position_loss)
                elif (y_Long_Position_loss is None) and (not (y_Short_Selling_loss is None)):
                    y_loss = float(y_Short_Selling_loss)
                else:
                    # y_loss = float(max([float(y_Long_Position_loss), float(y_Short_Selling_loss)]))  # 取極大值;
                    # y_loss = float(min([float(y_Long_Position_loss), float(y_Short_Selling_loss)]))  # 取極小值;
                    # y_loss = float(numpy.mean([float(y_Long_Position_loss), float(y_Short_Selling_loss)]))  # 取均值;
                    # y_loss = float(numpy.median([float(y_Long_Position_loss), float(y_Short_Selling_loss)]))  # 取中位數;
                    y_loss = float(sum([float(y_Long_Position_loss), float(y_Short_Selling_loss)]))  # 取總和;

                # 擇時權重，每兩次對衝交易的盈利概率占比;
                weight_MarketTiming_Dict = {}
                if (not (y_P_Positive_Long_Position is None)) and (not (y_P_Negative_Long_Position is None)):
                    if float(y_P_Positive_Long_Position) > float(y_P_Negative_Long_Position):
                        weight_MarketTiming_Dict["Long_Position"] = float(float(y_P_Positive_Long_Position) - float(y_P_Negative_Long_Position))
                    else:
                        weight_MarketTiming_Dict["Long_Position"] = float(0.0)
                if (not (y_P_Positive_Short_Selling is None)) and (not (y_P_Negative_Short_Selling is None)):
                    if float(y_P_Positive_Short_Selling) > float(y_P_Negative_Short_Selling):
                        weight_MarketTiming_Dict["Short_Selling"] = float(float(y_P_Positive_Short_Selling) - float(y_P_Negative_Short_Selling))
                    else:
                        weight_MarketTiming_Dict["Short_Selling"] = float(0.0)
                # print(weight_MarketTiming_Dict)

                # 每一股票（ticker symbol）函數返回值;
                result_ticker_symbol = {
                    "y_profit": y_profit,  # 優化目標變量，每兩次對衝交易利潤 × 權重，加權纍加總計;
                    "y_Long_Position_profit": y_Long_Position_profit,  # 優化目標變量，做多（Long Position），每兩次對衝交易利潤 × 權重，加權纍加總計;
                    "y_Short_Selling_profit": y_Short_Selling_profit,  # 優化目標變量，做空（Short Selling），每兩次對衝交易利潤 × 權重，加權纍加總計;
                    "y_loss": y_loss,  # 優化目標變量，每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                    "y_Long_Position_loss": y_Long_Position_loss,  # 優化目標變量，做多（Long Position），每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                    "y_Short_Selling_loss": y_Short_Selling_loss,  # 優化目標變量，做空（Short Selling），每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                    "maximum_drawdown": y_maximum_drawdown,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                    "maximum_drawdown_Long_Position": y_maximum_drawdown_Long_Position,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                    "maximum_drawdown_Short_Selling": y_maximum_drawdown_Short_Selling,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                    "profit_total": y_total,  # 每兩次對衝交易利潤 × 權重，纍加總計;
                    "Long_Position_profit_total": y_total_Long_Position,  # 每兩次對衝交易利潤 × 權重，纍加總計;
                    "Short_Selling_profit_total": y_total_Short_Selling,  # 每兩次對衝交易利潤 × 權重，纍加總計;
                    "profit_Positive": y_Positive,  # 每兩次對衝交易收益纍加總計;
                    "Long_Position_profit_Positive": y_Positive_Long_Position,  # 每兩次對衝交易收益纍加總計;
                    "Short_Selling_profit_Positive": y_Positive_Short_Selling,  # 每兩次對衝交易收益纍加總計;
                    "profit_Positive_probability": y_P_Positive,  # 每兩次對衝交易正利潤概率;
                    "Long_Position_profit_Positive_probability": y_P_Positive_Long_Position,  # 每兩次對衝交易正利潤概率;
                    "Short_Selling_profit_Positive_probability": y_P_Positive_Short_Selling,  # 每兩次對衝交易正利潤概率;
                    "profit_Negative": y_Negative,  # 每兩次對衝交易損失纍加總計;
                    "Long_Position_profit_Negative": y_Negative_Long_Position,  # 每兩次對衝交易損失纍加總計;
                    "Short_Selling_profit_Negative": y_Negative_Short_Selling,  # 每兩次對衝交易損失纍加總計;
                    "profit_Negative_probability": y_P_Negative,  # 每兩次對衝交易負利潤概率;
                    "Long_Position_profit_Negative_probability": y_P_Negative_Long_Position,  # 每兩次對衝交易負利潤概率;
                    "Short_Selling_profit_Negative_probability": y_P_Negative_Short_Selling,  # 每兩次對衝交易負利潤概率;
                    "Long_Position_profit_date_transaction": y_A_Long_Position,  # 每兩次對衝交易利潤，向量;
                    "Short_Selling_profit_date_transaction": y_A_Short_Selling,  # 每兩次對衝交易利潤，向量;
                    "Long_Position_drawdown_date_transaction": y_H_Long_Position,  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                    "Short_Selling_drawdown_date_transaction": y_H_Short_Selling,  # 向量，記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                    "average_price_amplitude_date_transaction": y_amplitude,  # 兩次對衝交易日成交價振幅平方和，均值;
                    "Long_Position_average_price_amplitude_date_transaction": y_amplitude_Long_Position,  # 兩次對衝交易日成交價振幅平方和，均值;
                    "Short_Selling_average_price_amplitude_date_transaction": y_amplitude_Short_Selling,  # 兩次對衝交易日成交價振幅平方和，均值;
                    "Long_Position_price_amplitude_date_transaction": y_D_Long_Position,  # 兩次對衝交易日成交價振幅平方和，向量;
                    "Short_Selling_price_amplitude_date_transaction": y_D_Short_Selling,  # 兩次對衝交易日成交價振幅平方和，向量;
                    "average_volume_turnover_date_transaction": y_turnover,  # 兩次對衝交易日成交量（換手率）均值;
                    "Long_Position_average_volume_turnover_date_transaction": y_turnover_Long_Position,  # 兩次對衝交易日成交量（換手率）均值;
                    "Short_Selling_average_volume_turnover_date_transaction": y_turnover_Short_Selling,  # 兩次對衝交易日成交量（換手率）均值;
                    "Long_Position_volume_turnover_date_transaction": y_E_Long_Position,  # 兩次對衝交易日成交量（換手率）向量;
                    "Short_Selling_volume_turnover_date_transaction": y_E_Short_Selling,  # 兩次對衝交易日成交量（換手率）向量;
                    "average_date_transaction_between": y_date_transaction_between,  # 兩次對衝交易間隔日長，均值;
                    "Long_Position_average_date_transaction_between": y_date_transaction_between_Long_Position,  # 兩次對衝交易間隔日長，均值;
                    "Short_Selling_average_date_transaction_between": y_date_transaction_between_Short_Selling,  # 兩次對衝交易間隔日長，均值;
                    "Long_Position_date_transaction_between": y_C_Long_Position,  # 兩次對衝交易間隔日長，向量;
                    "Short_Selling_date_transaction_between": y_C_Short_Selling,  # 兩次對衝交易間隔日長，向量;
                    "Long_Position_date_transaction": y_F_Long_Position,  # 按規則執行交易的日期，向量;
                    "Short_Selling_date_transaction": y_F_Short_Selling,  # 按規則執行交易的日期，向量;
                    "P1_Array": P1_Array,  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
                    "revenue_and_expenditure_records_date_transaction": y_G,  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
                    "weight_MarketTiming": weight_MarketTiming_Dict  # 擇時權重，每兩次對衝交易的盈利概率占比;
                }

                # 釋放内存;
                x0 = None
                x1 = None
                x3 = None
                x4 = None
                x5 = None
                x6 = None
                x7 = None
                x8 = None
                x9 = None
                P1_Array = None
                y_G = None
                y_A_Long_Position = None
                y_B_Long_Position = None
                y_C_Long_Position = None
                y_D_Long_Position = None
                y_E_Long_Position = None
                y_F_Long_Position = None
                y_H_Long_Position = None
                Index_date_transaction_Long_Position = None
                y_A_Short_Selling = None
                y_B_Short_Selling = None
                y_C_Short_Selling = None
                y_D_Short_Selling = None
                y_E_Short_Selling = None
                y_F_Short_Selling = None
                y_H_Short_Selling = None
                Index_date_transaction_Short_Selling = None

                # 全部股票的函數返回值;
                result[key] = result_ticker_symbol
                result_ticker_symbol = None  # 釋放内存;

    return result

# MarketTiming_f_fit_model = lambda x, P: (MarketTiming_fit_model(x[0], P[0], P[1], P[2], P[3], x[1], x[2], x[3]))
# 必須將自變量作爲第一個參數，將待估參數作爲單獨的數組參數;
# 應變量 y 為執行交易規則之後獲得利潤;
# 自變量 x 為日棒缐（K Line Days）數據;
# 參數 P[1] 為觀察收益率歷史向前推的交易日長度，整型（int），離散型變量;
# 參數 P[2] 為買入閾值，浮點型（float），連續型變量;
# 參數 P[3] 為賣出閾值，浮點型（float），連續型變量;


# 擇時模型參數的優化函數（Optimization）;
def MarketTiming(
    training_data = {},  # = {"ticker_symbol" : {"date_transaction" : [datetime.date("2024-01-02").strftime("%Y-%m-%d")], "turnover_volume" : [int], "opening_price" : [float], "close_price" : [float], "low_price" : [float], "high_price" : [float]}},
    testing_data = {},  # = {"ticker_symbol" : {"date_transaction" : [datetime.date("2024-01-02").strftime("%Y-%m-%d")], "turnover_volume" : [int], "opening_price" : [float], "close_price" : [float], "low_price" : [float], "high_price" : [float]}},
    Pdata_0 = [],  # = [int, float, float, float],
    weight = [],  # [float(1.0) for i in range(int(0), int(len(training_data)), int(1))],
    Plower = [-math.inf, -math.inf, -math.inf, -math.inf],
    Pupper = [+math.inf, +math.inf, +math.inf, +math.inf],
    MarketTiming_fit_model = lambda argument : argument,
    Quantitative_Indicators_Function = lambda argument : argument,
    investment_method = "Long_Position_and_Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
):

    # 函數傳入參數 testing_data 的預設值，設置爲等於傳入參數 training_data ;
    if isinstance(testing_data, dict) and int(len(testing_data)) == int(0):
        testing_data = training_data

    # 函數的傳出參數，預設爲字典類型;
    resultDict = {}  # 函數的傳出參數;

    # 讀取從函數參數傳入的訓練數據集;
    # training_date_transaction = []  # 訓練集數據交易日期;
    # training_opening_price = []  # 訓練集數據交易日首筆成交價（開盤價）;
    # training_close_price = []  # 訓練集數據交易日尾筆成交價（收盤價）;
    # training_low_price = []  # 訓練集數據交易日最低成交價;
    # training_high_price = []  # 訓練集數據交易日最高成交價;
    # training_turnover_volume = []  # 訓練集數據交易日總成交量;
    # training_turnover_amount = []  # 訓練集數據交易日總成交金額;
    # training_turnover_rate = []  # 訓練集數據交易日換手率;
    # training_price_earnings = []  # 訓練集數據市盈率;
    # training_book_value_per_share = []  # 訓練集數據净值;
    trainingData = {}
    if isinstance(training_data, dict) and int(len(training_data)) > int(0):

        trainingData = training_data

        # if "date_transaction" in training_data and int(len(training_data["date_transaction"])) > int(0):
        #     training_date_transaction = training_data["date_transaction"]
        # if "turnover_volume" in training_data and int(len(training_data["turnover_volume"])) > int(0):
        #     training_turnover_volume = training_data["turnover_volume"]
        # if "turnover_amount" in training_data and int(len(training_data["turnover_amount"])) > int(0):
        #     training_turnover_amount = training_data["turnover_amount"]
        # if "opening_price" in training_data and int(len(training_data["opening_price"])) > int(0):
        #     training_opening_price = training_data["opening_price"]
        # if "close_price" in training_data and int(len(training_data["close_price"])) > int(0):
        #     training_close_price = training_data["close_price"]
        # if "low_price" in training_data and int(len(training_data["low_price"])) > int(0):
        #     training_low_price = training_data["low_price"]
        # if "high_price" in training_data and int(len(training_data["high_price"])) > int(0):
        #     training_high_price = training_data["high_price"]
        # if "turnover_rate" in training_data and int(len(training_data["turnover_rate"])) > int(0):
        #     training_turnover_rate = training_data["turnover_rate"]
        # if "price_earnings" in training_data and int(len(training_data["price_earnings"])) > int(0):
        #     training_price_earnings = training_data["price_earnings"]
        # if "book_value_per_share" in training_data and int(len(training_data["book_value_per_share"])) > int(0):
        #     training_book_value_per_share = training_data["book_value_per_share"]

        # # 遍歷字典的鍵:值對;
        # for key, value in training_data.items():
        #     # print("Key: {key}, Value: {value}")

        #     # date_i = str(key)
        #     # date_i = datetime.datetime.strptime(date_i, "%Y-%m-%d").date()  # 將日期字符串，轉換爲日期對象;  # datetime.datetime.strptime(str(str(str(date_i).replace("/", "-")).strip()), "%Y-%m-%d").date()
        #     # # if isinstance(key, str):
        #     # #     # key == "" # str(key).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     # #     date_i = key;
        #     # #     # date_i = str(key)
        #     # #     date_i = datetime.datetime.strptime(date_i, "%Y-%m-%d").date()
        #     # # elif isinstance(key, int):
        #     # #     # date_i = int(key)
        #     # #     # the_Unix_time = now_day.timestamp()  # 1723177781.518 seconds  # 轉換爲時間戳;
        #     # #     # the_date_time = datetime.datetime.fromtimestamp(the_Unix_time)  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
        #     # #     date_i = datetime.datetime.fromtimestamp(key)  # 將時間戳轉換爲時間對象;
        #     # # elif isinstance(key, datetime.date):
        #     # #     date_i = key
        #     # # # else:
        #     # training_date_transaction.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     # if isinstance(value, dict) and int(len(value)) > int(0):
        #     #     for key_1, value_1 in value.items():
        #     #         if str(key_1) == str("turnover_volume"):
        #     #             date_i = value_1
        #     #             # if value_1 is None:
        #     #             #     date_i = None
        #     #             # elif isinstance(value_1, str) and value_1 == "":
        #     #             #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #             #     date_i = str("")
        #     #             # # elif isinstance(value_1, int):
        #     #             # #     date_i = int(value_1)
        #     #             # else:
        #     #             #     date_i = value_1
        #     #             training_turnover_volume.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #         if str(key_1) == str("turnover_amount"):
        #     #             date_i = value_1
        #     #             # if value_1 is None:
        #     #             #     date_i = None
        #     #             # elif isinstance(value_1, str) and value_1 == "":
        #     #             #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #             #     date_i = str("")
        #     #             # # elif isinstance(value_1, float):
        #     #             # #     date_i = float(value_1)
        #     #             # else:
        #     #             #     date_i = value_1
        #     #             training_turnover_amount.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #         if str(key_1) == str("opening_price"):
        #     #             date_i = value_1
        #     #             # if value_1 is None:
        #     #             #     date_i = None
        #     #             # elif isinstance(value_1, str) and value_1 == "":
        #     #             #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #             #     date_i = str("")
        #     #             # # elif isinstance(value_1, float):
        #     #             # #     date_i = float(value_1)
        #     #             # else:
        #     #             #     date_i = value_1
        #     #             training_opening_price.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        #     # if str(key) == str("date_transaction"):
        #     #     training_date_transaction = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")  # str(value[i])
        #     #     #         # # elif isinstance(value_1, int):
        #     #     #         # #     # date_i = int(value[i])
        #     #     #         # #     # the_Unix_time = now_day.timestamp()  # 1723177781.518 seconds  # 轉換爲時間戳;
        #     #     #         # #     # the_date_time = datetime.datetime.fromtimestamp(the_Unix_time)  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
        #     #     #         # #     date_i = datetime.datetime.fromtimestamp(value[i])  # 將時間戳轉換爲時間對象;
        #     #     #         # # elif isinstance(key, datetime.date):
        #     #     #         # #     date_i = value[i]
        #     #     #         # #     # date_i = datetime.datetime.strptime(value[i], "%Y-%m-%d").date()
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         training_date_transaction.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     training_date_transaction = value
        #     # if str(key) == str("turnover_volume"):
        #     #     training_turnover_volume = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")
        #     #     #         # # elif isinstance(value_1, int):
        #     #     #         # #     # date_i = int(value[i])
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         training_turnover_volume.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     training_turnover_volume = value
        #     # if str(key) == str("turnover_amount"):
        #     #     training_turnover_amount = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")
        #     #     #         # # elif isinstance(value[i], float):
        #     #     #         # #     date_i = float(value[i])
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         training_turnover_amount.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     training_turnover_amount = value
        #     # if str(key) == str("opening_price"):
        #     #     training_opening_price = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")
        #     #     #         # # elif isinstance(value[i], float):
        #     #     #         # #     date_i = float(value[i])
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         training_opening_price.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     training_opening_price = value
    # print(trainingData)


    # 計算訓練集日棒缐（K Line Daily）數據本徵（characteristic）;
    if isinstance(trainingData, dict) and int(len(trainingData)) > int(0):

        # 求解各股票裏的最長交易天數;
        # 交易過股票的總隻數，求解各股票裏的最長交易天數;
        maximum_PickStock_transaction_training = int(0)  # 交易過股票的總隻數;
        maximum_dates_transaction_training = int(0)  # 各股票裏的最長交易天數;
        minimum_dates_transaction_training = int(0)  # 各股票裏的最短交易天數;

        # 交易過股票的總隻數，函數 Base.keys(Dict) 表示獲取字典的所有 key 值，返回值爲字符串向量（Base.Vector）;
        maximum_PickStock_transaction_training_2 = int(len([key for key in trainingData.keys()]))  # 交易過股票的總隻數;
        maximum_PickStock_transaction_training *= int(0)
        maximum_PickStock_transaction_training += int(maximum_PickStock_transaction_training_2)
        # print(maximum_PickStock_transaction_training)

        dates_transaction_Array_training = []
        # 遍歷字典的鍵:值對;
        for key, value in trainingData.items():
            # print("Key: {key}, Value: {value}")
            if isinstance(value, dict):
                if "date_transaction" in value and isinstance(value["date_transaction"], list):
                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                    dates_transaction_Array_training.append(int(len(value["date_transaction"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 篩選最長交易天數;
                    if int(len(value["date_transaction"])) > int(maximum_dates_transaction_training):
                        maximum_dates_transaction_training_2 = int(len(value["date_transaction"]))
                        maximum_dates_transaction_training *= int(0)
                        maximum_dates_transaction_training += int(maximum_dates_transaction_training_2)
                if "turnover_volume" in value and isinstance(value["turnover_volume"], list):
                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                    dates_transaction_Array_training.append(int(len(value["turnover_volume"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 篩選最長交易天數;
                    if int(len(value["turnover_volume"])) > int(maximum_dates_transaction_training):
                        maximum_dates_transaction_training_2 = int(len(value["turnover_volume"]))
                        maximum_dates_transaction_training *= int(0)
                        maximum_dates_transaction_training += int(maximum_dates_transaction_training_2)
                if "opening_price" in value and isinstance(value["opening_price"], list):
                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                    dates_transaction_Array_training.append(int(len(value["opening_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 篩選最長交易天數;
                    if int(len(value["opening_price"])) > int(maximum_dates_transaction_training):
                        maximum_dates_transaction_training_2 = int(len(value["opening_price"]))
                        maximum_dates_transaction_training *= int(0)
                        maximum_dates_transaction_training += int(maximum_dates_transaction_training_2)
                if "close_price" in value and isinstance(value["close_price"], list):
                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                    dates_transaction_Array_training.append(int(len(value["close_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 篩選最長交易天數;
                    if int(len(value["close_price"])) > int(maximum_dates_transaction_training):
                        maximum_dates_transaction_training_2 = int(len(value["close_price"]))
                        maximum_dates_transaction_training *= int(0)
                        maximum_dates_transaction_training += int(maximum_dates_transaction_training_2)
                if "low_price" in value and isinstance(value["low_price"], list):
                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                    dates_transaction_Array_training.append(int(len(value["low_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 篩選最長交易天數;
                    if int(len(value["low_price"])) > int(maximum_dates_transaction_training):
                        maximum_dates_transaction_training_2 = int(len(value["low_price"]))
                        maximum_dates_transaction_training *= int(0)
                        maximum_dates_transaction_training += int(maximum_dates_transaction_training_2)
                if "high_price" in value and isinstance(value["high_price"], list):
                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                    dates_transaction_Array_training.append(int(len(value["high_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 篩選最長交易天數;
                    if int(len(value["high_price"])) > int(maximum_dates_transaction_training):
                        maximum_dates_transaction_training_2 = int(len(value["high_price"]))
                        maximum_dates_transaction_training *= int(0)
                        maximum_dates_transaction_training += int(maximum_dates_transaction_training_2)
        # print(maximum_dates_transaction_training)

        if int(len(dates_transaction_Array_training)) > int(0):
            minimum_dates_transaction_training_2 = int(min(dates_transaction_Array_training))
            minimum_dates_transaction_training *= int(0)
            minimum_dates_transaction_training += int(minimum_dates_transaction_training_2)
        # print(minimum_dates_transaction_training)
        dates_transaction_Array_training = None  # 釋放内存;

        # 求解量化規則使用的各項指標數值;
        for key, value in trainingData.items():

            # 計算訓練集日棒缐（K Line Daily）數據本徵（characteristic）;
            training_focus = []  # 日棒缐（K Line Daily）數據的重心值（Focus）;
            training_amplitude = []  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
            training_amplitude_rate = []  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
            training_opening_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
            training_closing_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
            training_low_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
            training_high_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
            training_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
            training_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
            training_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
            training_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
            training_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
            training_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;
            if isinstance(value, dict) and int(len(value)) > int(0):

                # if (isinstance(training_turnover_volume, list) and int(len(training_turnover_volume)) > int(0)) and (isinstance(training_opening_price, list) and int(len(training_opening_price)) > int(0)) and (isinstance(training_close_price, list) and int(len(training_close_price)) > int(0)) and (isinstance(training_low_price, list) and int(len(training_low_price)) > int(0)) and (isinstance(training_high_price, list) and int(len(training_high_price)) > int(0)):
                if ("turnover_volume" in value and isinstance(value["turnover_volume"], list) and int(len(value["turnover_volume"])) > int(0)) and ("opening_price" in value and isinstance(value["opening_price"], list) and int(len(value["opening_price"])) > int(0)) and ("close_price" in value and isinstance(value["close_price"], list) and int(len(value["close_price"])) > int(0)) and ("low_price" in value and isinstance(value["low_price"], list) and int(len(value["low_price"])) > int(0)) and ("high_price" in value and isinstance(value["high_price"], list) and int(len(value["high_price"])) > int(0)):

                    # 計算訓練集日棒缐（K Line Daily）數據的最少數目（minimum count time series）;
                    # training_minimum_count_time_series = int(0)
                    # training_minimum_count_time_series = (+math.inf)
                    training_minimum_count_time_series = int(min([int(len(value["turnover_volume"])), int(len(value["opening_price"])), int(len(value["close_price"])), int(len(value["low_price"])), int(len(value["high_price"]))]))
                    # training_minimum_count_time_series = int(min([int(len(training_turnover_volume)), int(len(training_opening_price)), int(len(training_close_price)), int(len(training_low_price)), int(len(training_high_price))]))

                    if int(training_minimum_count_time_series) > int(0):

                        # 計算訓練集日棒缐（K Line Daily）數據本徵（characteristic）;
                        # training_focus = []  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                        # training_amplitude = []  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                        # training_amplitude_rate = []  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                        # training_opening_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                        # training_closing_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                        # training_low_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                        # training_high_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                        # training_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
                        # training_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                        # training_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                        # training_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                        # training_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                        # training_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;
                        # for i in range(int(0), int(len(value["opening_price"])), int(1)):
                        # for i in range(int(0), int(len(training_opening_price)), int(1)):
                        for i in range(int(0), int(training_minimum_count_time_series), int(1)):

                            # 計算日棒缐（K Line Daily）數據的重心值（Focus）序列;
                            date_i_focus = numpy.mean([value["opening_price"][i], value["close_price"][i], value["low_price"][i], value["high_price"][i]])
                            date_i_focus = float(date_i_focus)
                            training_focus.append(date_i_focus)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）序列;
                            date_i_amplitude = numpy.std(
                                [
                                    value["opening_price"][i],
                                    value["close_price"][i],
                                    value["low_price"][i],
                                    value["high_price"][i]
                                ],
                                ddof = 1
                            )
                            # if int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) == int(1):
                            #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]])
                            # elif int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) > int(1):
                            #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]], ddof = 1)
                            # # else:
                            date_i_amplitude = float(date_i_amplitude)
                            training_amplitude.append(date_i_amplitude)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）序列;
                            date_i_amplitude_rate = float(date_i_amplitude)  # numpy.nan  # None  # +math.inf
                            if float(date_i_focus) == float(0.0):
                                date_i_amplitude_rate = (+math.inf)  # float(date_i_amplitude)
                            else:
                                date_i_amplitude_rate = float(date_i_amplitude / date_i_focus)
                            training_amplitude_rate.append(date_i_amplitude_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 訓練集日棒缐（K Line Daily）數據標準化（Standardization）轉換;
                            # training_opening_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                            # training_closing_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                            # training_low_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                            # training_high_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                            date_i_opening_price_Standardization = value["opening_price"][i]
                            date_i_closing_price_Standardization = value["close_price"][i]
                            date_i_low_price_Standardization = value["low_price"][i]
                            date_i_high_price_Standardization = value["high_price"][i]
                            if float(value["amplitude"][i]) == float(0.0):
                                date_i_opening_price_Standardization = float(value["opening_price"][i] - value["focus"][i])
                                date_i_closing_price_Standardization = float(value["close_price"][i] - value["focus"][i])
                                date_i_low_price_Standardization = float(value["low_price"][i] - value["focus"][i])
                                date_i_high_price_Standardization = float(value["high_price"][i] - value["focus"][i])
                            else:
                                date_i_opening_price_Standardization = float((value["opening_price"][i] - value["focus"][i]) / value["amplitude"][i])
                                date_i_closing_price_Standardization = float((value["close_price"][i] - value["focus"][i]) / value["amplitude"][i])
                                date_i_low_price_Standardization = float((value["low_price"][i] - value["focus"][i]) / value["amplitude"][i])
                                date_i_high_price_Standardization = float((value["high_price"][i] - value["focus"][i]) / value["amplitude"][i])
                            training_opening_price_Standardization.append(date_i_opening_price_Standardization)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                            training_closing_price_Standardization.append(date_i_closing_price_Standardization)
                            training_low_price_Standardization.append(date_i_low_price_Standardization)
                            training_high_price_Standardization.append(date_i_high_price_Standardization)

                            # 計算相鄰兩個交易日之間成交股票數量的變化率值的序列，並保存入 1 維數組;
                            # training_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值; x_growth_rate = numpy.nan
                            if int(int(i) + int(1)) < int(2):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            else:
                                if int(value["turnover_volume"][i - 1]) != int(0):
                                    x_growth_rate = float(value["turnover_volume"][i] / value["turnover_volume"][i - 1]) - float(1.0)
                                elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) == int(0):
                                    x_growth_rate = float(0.0)
                                    # x_growth_rate = numpy.nan
                                elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) > int(0):
                                    x_growth_rate = (+math.inf)
                                elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) < int(0):
                                    x_growth_rate = (-math.inf)
                                # else:
                            # print(x_growth_rate)
                            training_turnover_volume_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算相鄰兩個交易日之間開盤股票價格的變化率值的序列，並保存入 1 維數組;
                            # training_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                            x_growth_rate = numpy.nan
                            if int(int(i) + int(1)) < int(2):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            else:
                                if float(value["opening_price"][i - 1]) != float(0.0):
                                    x_growth_rate = float(value["opening_price"][i] / value["opening_price"][i - 1]) - float(1.0)
                                elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) == float(0.0):
                                    x_growth_rate = float(0.0)
                                    # x_growth_rate = numpy.nan
                                elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) > float(0.0):
                                    x_growth_rate = (+math.inf)
                                elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) < float(0.0):
                                    x_growth_rate = (-math.inf)
                                # else:
                            # print(x_growth_rate)
                            training_opening_price_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算相鄰兩個交易日之間收盤股票價格的變化率值的序列，並保存入 1 維數組;
                            # training_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                            x_growth_rate = numpy.nan
                            if int(int(i) + int(1)) < int(2):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            else:
                                if float(value["close_price"][i - 1]) != float(0.0):
                                    x_growth_rate = float(value["close_price"][i] / value["close_price"][i - 1]) - float(1.0)
                                elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) == float(0.0):
                                    x_growth_rate = float(0.0)
                                    # x_growth_rate = numpy.nan
                                elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) > float(0.0):
                                    x_growth_rate = (+math.inf)
                                elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) < float(0.0):
                                    x_growth_rate = (-math.inf)
                                # else:
                            # print(x_growth_rate)
                            training_closing_price_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算每個交易日股票收盤價格減去開盤價格的變化率值的序列，並保存入 1 維數組;
                            # training_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                            x_growth_rate = numpy.nan
                            if float(value["opening_price"][i]) != float(0.0):
                                x_growth_rate = float(value["close_price"][i] / value["opening_price"][i]) - float(1.0)
                            elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) == float(0.0):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) > float(0.0):
                                x_growth_rate = (+math.inf)
                            elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) < float(0.0):
                                x_growth_rate = (-math.inf)
                            # else:
                            # print(x_growth_rate)
                            training_closing_minus_opening_price_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列，並保存入 1 維數組;
                            # training_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                            x_growth_rate = numpy.nan
                            if float(value["high_price"][i]) != float(0.0):
                                x_growth_rate = float(max([value["opening_price"][i], value["close_price"][i]])) / float(value["high_price"][i])
                            elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) == float(0.0):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) > float(0.0):
                                x_growth_rate = (+math.inf)
                            elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) < float(0.0):
                                x_growth_rate = (-math.inf)
                            # else:
                            # print(x_growth_rate)
                            training_high_price_proportion.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列，並保存入 1 維數組;
                            # training_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;
                            x_growth_rate = numpy.nan
                            if float(min([value["opening_price"][i], value["close_price"][i]])) != float(0.0):
                                x_growth_rate = float(value["low_price"][i]) / float(min([value["opening_price"][i], value["close_price"][i]]))
                            elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) == float(0.0):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) > float(0.0):
                                x_growth_rate = (+math.inf)
                            elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) < float(0.0):
                                x_growth_rate = (-math.inf)
                            # else:
                            # print(x_growth_rate)
                            training_low_price_proportion.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                        # trainingData[key]["focus"] = training_focus
                        # trainingData[key]["amplitude"] = training_amplitude
                        # trainingData[key]["amplitude_rate"] = training_amplitude_rate
                        # trainingData[key]["opening_price_Standardization"] = training_opening_price_Standardization
                        # trainingData[key]["closing_price_Standardization"] = training_closing_price_Standardization
                        # trainingData[key]["low_price_Standardization"] = training_low_price_Standardization
                        # trainingData[key]["high_price_Standardization"] = training_high_price_Standardization
                        # trainingData[key]["turnover_volume_growth_rate"] = training_turnover_volume_growth_rate
                        # trainingData[key]["opening_price_growth_rate"] = training_opening_price_growth_rate
                        # trainingData[key]["closing_price_growth_rate"] = training_closing_price_growth_rate
                        # trainingData[key]["closing_minus_opening_price_growth_rate"] = training_closing_minus_opening_price_growth_rate
                        # trainingData[key]["high_price_proportion"] = training_high_price_proportion
                        # trainingData[key]["low_price_proportion"] = training_low_price_proportion
                        # # 釋放内存;
                        # training_focus = None
                        # training_amplitude = None
                        # training_amplitude_rate = None
                        # training_opening_price_Standardization = None
                        # training_closing_price_Standardization = None
                        # training_low_price_Standardization = None
                        # training_high_price_Standardization = None
                        # training_turnover_volume_growth_rate = None
                        # training_opening_price_growth_rate = None
                        # training_closing_price_growth_rate = None
                        # training_closing_minus_opening_price_growth_rate = None
                        # training_high_price_proportion = None
                        # training_low_price_proportion = None

                # 從 trainingData 讀出;
                if "focus" in value and isinstance(value["focus"], list):
                    training_focus = value["focus"]  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                if "amplitude" in value and isinstance(value["amplitude"], list):
                    training_amplitude = value["amplitude"]  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                if "amplitude_rate" in value and isinstance(value["amplitude_rate"], list):
                    training_amplitude_rate = value["amplitude_rate"]  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                if "opening_price_Standardization" in value and isinstance(value["opening_price_Standardization"], list):
                    training_opening_price_Standardization = value["opening_price_Standardization"]  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                if "closing_price_Standardization" in value and isinstance(value["closing_price_Standardization"], list):
                    training_closing_price_Standardization = value["closing_price_Standardization"]  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                if "low_price_Standardization" in value and isinstance(value["low_price_Standardization"], list):
                    training_low_price_Standardization = value["low_price_Standardization"]  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                if "high_price_Standardization" in value and isinstance(value["high_price_Standardization"], list):
                    training_high_price_Standardization = value["high_price_Standardization"]  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                if "turnover_volume_growth_rate" in value and isinstance(value["turnover_volume_growth_rate"], list):
                    training_turnover_volume_growth_rate = value["turnover_volume_growth_rate"]  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
                if "opening_price_growth_rate" in value and isinstance(value["opening_price_growth_rate"], list):
                    training_opening_price_growth_rate = value["opening_price_growth_rate"]  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                if "closing_price_growth_rate" in value and isinstance(value["closing_price_growth_rate"], list):
                    training_closing_price_growth_rate = value["closing_price_growth_rate"]  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                if "closing_minus_opening_price_growth_rate" in value and isinstance(value["closing_minus_opening_price_growth_rate"], list):
                    training_closing_minus_opening_price_growth_rate = value["closing_minus_opening_price_growth_rate"]  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                if "high_price_proportion" in value and isinstance(value["high_price_proportion"], list):
                    training_high_price_proportion = value["high_price_proportion"]  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                if "low_price_proportion" in value and isinstance(value["low_price_proportion"], list):
                    training_low_price_proportion = value["low_price_proportion"]  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;

                # # 向 trainingData 寫入;
                # if not ("focus" in value):
                #     trainingData[key]["focus"] = training_focus  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                # if not ("amplitude" in value):
                #     trainingData[key]["amplitude"] = training_amplitude  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                # if not ("amplitude_rate" in value):
                #     trainingData[key]["amplitude_rate"] = training_amplitude_rate  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                # if not ("opening_price_Standardization" in value):
                #     trainingData[key]["opening_price_Standardization"] = training_opening_price_Standardization  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                # if not ("closing_price_Standardization" in value):
                #     trainingData[key]["closing_price_Standardization"] = training_closing_price_Standardization  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                # if not ("low_price_Standardization" in value):
                #     trainingData[key]["low_price_Standardization"] = training_low_price_Standardization  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                # if not ("high_price_Standardization" in value):
                #     trainingData[key]["high_price_Standardization"] = training_high_price_Standardization  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                # if not ("turnover_volume_growth_rate" in value):
                #     trainingData[key]["turnover_volume_growth_rate"] = training_turnover_volume_growth_rate  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
                # if not ("opening_price_growth_rate" in value):
                #     trainingData[key]["opening_price_growth_rate"] = training_opening_price_growth_rate  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                # if not ("closing_price_growth_rate" in value):
                #     trainingData[key]["closing_price_growth_rate"] = training_closing_price_growth_rate  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                # if not ("closing_minus_opening_price_growth_rate" in value):
                #     trainingData[key]["closing_minus_opening_price_growth_rate"] = training_closing_minus_opening_price_growth_rate  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                # if not ("high_price_proportion" in value):
                #     trainingData[key]["high_price_proportion"] = training_high_price_proportion  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                # if not ("low_price_proportion" in value):
                #     trainingData[key]["low_price_proportion"] = training_low_price_proportion  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;

            # y = Base.log(x);  # 對數函數，返回以 e 爲底 x 的對數;
            # y = math.exp(x)  # 指數函數，返回 e 的 x 次冪;
            # y = math.pow(x, 2)  # 冪函數，返回 x 的 2 次方;
            # min([2, 1, 0, -1, -2])  # 求最小值;
            # max([-2, -1, 0, 1, 2])  # 求最大值;

            YdataMean = training_focus
            YdataSTD = training_amplitude_rate  # training_amplitude
            Xdata = [int(int(i) + int(1)) for i in range(int(0), int(len(YdataMean)), int(1))]
            if isinstance(training_focus, list) and isinstance(training_amplitude, list) and isinstance(training_amplitude_rate, list):
                # 觀測值（Observation）;
                # 求 Ydata 均值向量;
                YdataMean = training_focus
                # YdataMean = []
                # for i in range(int(0), int(len(Ydata)), int(1)):
                #     if isinstance(Ydata[i], list):
                #         yMean = float(numpy.mean(Ydata[i]))
                #         YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #     else:
                #         yMean = float(Ydata[i])
                #         YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # print(YdataMean)
                # # 求 Ydata 標準差向量;
                # YdataSTD = training_amplitude
                # # YdataSTD = []
                # # for i in range(int(0), int(len(Ydata)), int(1)):
                # #     if isinstance(Ydata[i], list):
                # #         if int(len(Ydata[i])) == int(1):
                # #             ySTD = float(numpy.std(Ydata[i]))
                # #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # #         elif int(len(Ydata[i])) > int(1):
                # #             ySTD = float(numpy.std(Ydata[i], ddof = 1))
                # #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # #     else:
                # #         ySTD = float(0.0)
                # #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # 求 Ydata 變異係數（與重心比較的相對標準差）向量;
                YdataSTD = training_amplitude_rate
                # YdataSTD = []
                # for i in range(int(0), int(len(Ydata)), int(1)):
                #     if isinstance(Ydata[i], list):
                #         if int(len(Ydata[i])) == int(1):
                #             ySTD = float(float(numpy.std(Ydata[i])) / float(numpy.mean(Ydata[i])))
                #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #         elif int(len(Ydata[i])) > int(1):
                #             ySTD = float(float(numpy.std(Ydata[i], ddof = 1)) / float(numpy.mean(Ydata[i])))
                #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #     else:
                #         ySTD = float(0.0)
                #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # print(YdataSTD)
                # 求 Xdata 均值向量;
                Xdata = [int(int(i) + int(1)) for i in range(int(0), int(len(YdataMean)), int(1))]
                # Xdata = training_date_transaction
                # Xdata = value["date_transaction"]
                # print(Xdata)

            # 擬合參數預設值（Parameter default）;
            if (isinstance(YdataMean, list) and int(len(YdataMean)) > int(0)) and (isinstance(YdataSTD, list) and int(len(YdataSTD)) > int(0)) and (isinstance(Xdata, list) and int(len(Xdata)) > int(0)):

                # 擬合參數（Parameter）;
                # 參數初始值（Initialization）;
                Pdata_0_P1 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        Pdata_0_P1_I = float(YdataMean[i] / Xdata[i]**3)
                    else:
                        Pdata_0_P1_I = float(YdataMean[i] - Xdata[i]**3)
                    Pdata_0_P1.append(Pdata_0_P1_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P1 = float(numpy.mean(Pdata_0_P1))
                # print(Pdata_0_P1)

                Pdata_0_P2 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        Pdata_0_P2_I = float(YdataMean[i] / Xdata[i]**2)
                    else:
                        Pdata_0_P2_I = float(YdataMean[i] - Xdata[i]**2)
                    Pdata_0_P2.append(Pdata_0_P2_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P2 = float(numpy.mean(Pdata_0_P2))
                # print(Pdata_0_P2)

                Pdata_0_P3 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        Pdata_0_P3_I = float(YdataMean[i] / Xdata[i]**1)
                    else:
                        Pdata_0_P3_I = float(YdataMean[i] - Xdata[i]**1)
                    Pdata_0_P3.append(Pdata_0_P3_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P3 = float(numpy.mean(Pdata_0_P3))
                # print(Pdata_0_P3)

                Pdata_0_P4 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        # 符號 / 表示常規除法，符號 % 表示除法取餘，符號 ÷ 表示除法取整，符號 * 表示乘法，符號 ** 表示冪運算，符號 + 表示加法，符號 - 表示減法;
                        Pdata_0_P4_I_1 = float(float(YdataMean[i] % float(Pdata_0_P3 * Xdata[i]**1)) * float(Pdata_0_P3 * Xdata[i]**1))
                        Pdata_0_P4_I_2 = float(float(YdataMean[i] % float(Pdata_0_P2 * Xdata[i]**2)) * float(Pdata_0_P2 * Xdata[i]**2))
                        Pdata_0_P4_I_3 = float(float(YdataMean[i] % float(Pdata_0_P1 * Xdata[i]**3)) * float(Pdata_0_P1 * Xdata[i]**3))
                        Pdata_0_P4_I = float(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3)
                    else:
                        Pdata_0_P4_I = float(YdataMean[i] - Xdata[i])
                    Pdata_0_P4.append(Pdata_0_P4_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P4 = float(numpy.mean(Pdata_0_P4))
                # print(Pdata_0_P4)

                # Pdata_0 = []
                # Pdata_0 = [
                #     float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in 1:len(YdataMean)])),
                #     float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in 1:len(YdataMean)])),
                #     float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in 1:len(YdataMean)])),
                #     float(numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**1)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**1)) for i in range(int(0), int(len(YdataMean)), int(1))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**2)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**2)) for i in range(int(0), int(len(YdataMean)), int(1))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**3)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**3)) for i in range(int(0), int(len(YdataMean)), int(1))]))
                # ]
                if int(len(Pdata_0)) == int(0):
                    Pdata_0 = [
                        int(3),
                        float(+0.1),
                        float(-0.1),
                        float(0.0)
                    ]
                    # Pdata_0 = [
                    #     Pdata_0_P1,
                    #     Pdata_0_P2,
                    #     Pdata_0_P3,
                    #     Pdata_0_P4
                    # ]
                # print(Pdata_0)

                # # 參數值上下限;
                # # Plower = []
                # Plower = [
                #     -math.inf,  # P[1];
                #     -math.inf,  # P[2];
                #     -math.inf,  # P[3];
                #     -math.inf  # P[4];
                # ]
                if int(len(Plower)) == int(0):
                    Plower = [
                        int(1),  # -math.inf,  # P[1];
                        -math.inf,  # P[2];
                        -math.inf,  # P[3];
                        -math.inf  # P[4];
                    ]
                if int(len(Plower)) == int(1):
                    if math.isinf(Plower[0]) and Plower[0] < float(0.0):
                        Plower = [
                            int(1),  # -math.inf,  # P[1];
                            -math.inf,  # P[2];
                            -math.inf,  # P[3];
                            -math.inf  # P[4];
                        ]
                    elif float(Plower[0]) < float(1.0):
                        Plower = [
                            int(1),  # -math.inf,  # P[1];
                            -math.inf,  # P[2];
                            -math.inf,  # P[3];
                            -math.inf  # P[4];
                        ]
                    else:
                        Plower = [
                            int(round(Plower[0], 0)),  # -math.inf,  # P[1];  # 函數：round(P1, 0) 表示四捨五入取整;
                            -math.inf,  # P[2];
                            -math.inf,  # P[3];
                            -math.inf  # P[4];
                        ]
                if int(len(Plower)) > int(1):
                    if math.isinf(Plower[0]) and Plower[0] < float(0.0):
                        Plower[0] = int(1)  # -math.inf  # P[1];
                    elif float(Plower[0]) < float(1.0):
                        Plower[0] = int(1)  # -math.inf  # P[1];
                    else:
                        Plower[0] = int(round(Plower[0], 0))  # -math.inf  # P[1];  # 函數：round(P1, 0) 表示四捨五入取整;
                # # print(Plower)
                # # Pupper = []
                # Pupper = [
                #     +math.inf,  # P[1];
                #     +math.inf,  # P[2];
                #     +math.inf,  # P[3];
                #     +math.inf  # P[4];
                # ]
                if int(len(Pupper)) == int(0):
                    Pupper = [
                        int(min([int(len(value["turnover_volume"])), int(len(value["opening_price"])), int(len(value["close_price"])), int(len(value["low_price"])), int(len(value["high_price"]))])),  # int(minimum_dates_transaction_training),  # int(60),  # +math.inf,  # P[1];
                        +math.inf,  # P[2];
                        +math.inf,  # P[3];
                        +math.inf  # P[4];
                    ]
                if int(len(Pupper)) == int(1):
                    if math.isinf(Pupper[0]) and Pupper[0] > float(0.0):
                        Pupper = [
                            int(min([int(len(value["turnover_volume"])), int(len(value["opening_price"])), int(len(value["close_price"])), int(len(value["low_price"])), int(len(value["high_price"]))])),  # int(minimum_dates_transaction_training),  # +math.inf,  # P[1];
                            +math.inf,  # P[2];
                            +math.inf,  # P[3];
                            +math.inf  # P[4];
                        ]
                    elif float(Pupper[0]) < float(1.0):
                        Pupper = [
                            int(1),  # +math.inf,  # P[1];
                            +math.inf,  # P[2];
                            +math.inf,  # P[3];
                            +math.inf  # P[4];
                        ]
                    else:
                        Pupper = [
                            int(round(Pupper[0], 0)),  # +math.inf,  # P[1];  # 函數：round(P1, 0) 表示四捨五入取整;
                            +math.inf,  # P[2];
                            +math.inf,  # P[3];
                            +math.inf  # P[4];
                        ]
                if int(len(Pupper)) > int(1):
                    if math.isinf(Pupper[0]) and Pupper[0] > float(0.0):
                        Pupper[0] = int(min([int(len(value["turnover_volume"])), int(len(value["opening_price"])), int(len(value["close_price"])), int(len(value["low_price"])), int(len(value["high_price"]))]))  # int(minimum_dates_transaction_training)  # +math.inf  # P[1];
                    elif float(Pupper[0]) < float(1.0):
                        Pupper[0] = int(1)  # +math.inf  # P[1];
                    else:
                        Pupper[0] = int(round(Pupper[0], 0))  # +math.inf  # P[1];  # 函數：round(P1, 0) 表示四捨五入取整;
                # # print(Pupper)

                # 變量實測值擬合權重;
                # # weight = []
                # # 使用高斯核賦權法;
                # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
                # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
                # for i in range(int(0), int(len(YdataMean)), int(1)):
                #     wei = math.exp((YdataMean[i] / YdataMean[target] - 1)**2 / ((-2) * af**2))
                #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # # # 使用方差倒數值賦權法;
                # # for i in range(int(0), int(len(YdataSTD)), int(1)):
                # #     wei = 1 / YdataSTD[i]  # numpy.std(Ydata[i])  # numpy.var(Ydata[i])
                # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                if int(len(weight)) == int(0):
                    weight = [float(1.0) for i in range(int(0), int(len(YdataMean)), int(1))]
                    # weight = [float(1.0 / YdataMean[i]) for i in range(int(0), int(len(YdataMean)), int(1))]  # 每日成交價振幅倒數;
                    # weight = [float(training_turnover_rate[i]) for i in range(int(0), int(len(training_turnover_rate)), int(1))]  # 每日成交量（換手率）;
                    # weight = [float(1.0 / y_C[i]) for i in range(int(0), int(len(y_C)), int(1))]  # 每次交易間隔日長的倒數;
                # print(weight)

                # trainingData[key]["Pdata_0"] = Pdata_0
                # trainingData[key]["Plower"] = Plower
                # trainingData[key]["Pupper"] = Pupper
                # trainingData[key]["weight"] = weight
                # # 釋放内存;
                # Pdata_0 = None
                # Plower = None
                # Pupper = None
                # weight = None

            # 優化（Optimization）求解;
            P1 = int(3)  # None
            P2 = float(+0.1)  # None
            P3 = float(-0.1)  # None
            P4 = float(0.0)  # None
            sdP1 = int(0)  # None
            sdP2 = float(0.0)  # None
            sdP3 = float(0.0)  # None
            sdP4 = float(0.0)  # None
            if int(len(Pdata_0)) > int(0):
                P1 = Pdata_0[0]
                P2 = Pdata_0[1]
                P3 = Pdata_0[2]
                P4 = Pdata_0[3]
                # sdP1 = float(0.0)
                # sdP2 = float(0.0)
                # sdP3 = float(0.0)
                # sdP4 = float(0.0)
            coefficient_from_fit = []  # 擬合得到的參數值;
            margin_of_error = []  # 擬合得到的參數解的標準差，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.margin_error(fit, 0.05;) 求解擬合得到的參數解的標準差;
            confidence_inter = []  # 擬合得到的參數解的 95% 水平的致信區間，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.confidence_interval(fit, 0.05;) 求解擬合得到的參數解的 95% 水平的致信區間;
            Yvals = []  # 應變量 y 的擬合值;
            YvalsUncertaintyLower = []  # 擬合的應變量 Yvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            YvalsUncertaintyUpper = []  # 擬合的應變量 Yvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            Residual = []  # 擬合殘差向量;
            P1_Array = []  # 依照擇時規則計算得到參數 P1 值的序列，並保存入數組;
            # if (isinstance(YdataMean, list) and int(len(YdataMean)) > int(0)) and (isinstance(YdataSTD, list) and int(len(YdataSTD)) > int(0)) and (isinstance(Xdata, list) and int(len(Xdata)) > int(0)):
            if isinstance(value, dict) and int(len(value)) > int(0):

                # 優化函數;
                # https://www.scipy.org/docs.html
                # Independent variable = Xdata;
                # Dependent variable = YdataMean;
                def MarketTiming_optim_model(trainingData, P1, P2, P3, P4, Quantitative_Indicators_Function, investment_method):
                    # print("P1 = ", P1, ", P2 = ", P2, ", P3 = ", P3, P4 = ", P4)

                    # 交易過股票的總隻數，求解各股票裏的最長交易天數;
                    maximum_PickStock_transaction = int(0)  # 交易過股票的總隻數;
                    maximum_dates_transaction = int(0)  # 各股票裏的最長交易天數;
                    minimum_dates_transaction = int(0)  # 各股票裏的最短交易天數;
                    if isinstance(trainingData, dict) and int(len(trainingData)) > int(0):

                        # 交易過股票的總隻數，函數 Base.keys(Dict) 表示獲取字典的所有 key 值，返回值爲字符串向量（Base.Vector）;
                        maximum_PickStock_transaction_2 = int(len([key for key in trainingData.keys()]))  # 交易過股票的總隻數;
                        maximum_PickStock_transaction *= int(0)
                        maximum_PickStock_transaction += int(maximum_PickStock_transaction_2)
                        # print(maximum_PickStock_transaction)

                        dates_transaction_Array = []
                        # 遍歷字典的鍵:值對;
                        for key, value in trainingData.items():
                            # print("Key: {key}, Value: {value}")
                            if isinstance(value, dict):
                                if "date_transaction" in value and isinstance(value["date_transaction"], list):
                                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                                    dates_transaction_Array.append(int(len(value["date_transaction"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                    # 篩選最長交易天數;
                                    if int(len(value["date_transaction"])) > int(maximum_dates_transaction):
                                        maximum_dates_transaction_2 = int(len(value["date_transaction"]))
                                        maximum_dates_transaction *= int(0)
                                        maximum_dates_transaction += int(maximum_dates_transaction_2)
                                if "turnover_volume" in value and isinstance(value["turnover_volume"], list):
                                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                                    dates_transaction_Array.append(int(len(value["turnover_volume"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                    # 篩選最長交易天數;
                                    if int(len(value["turnover_volume"])) > int(maximum_dates_transaction):
                                        maximum_dates_transaction_2 = int(len(value["turnover_volume"]))
                                        maximum_dates_transaction *= int(0)
                                        maximum_dates_transaction += int(maximum_dates_transaction_2)
                                if "opening_price" in value and isinstance(value["opening_price"], list):
                                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                                    dates_transaction_Array.append(int(len(value["opening_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                    # 篩選最長交易天數;
                                    if int(len(value["opening_price"])) > int(maximum_dates_transaction):
                                        maximum_dates_transaction_2 = int(len(value["opening_price"]))
                                        maximum_dates_transaction *= int(0)
                                        maximum_dates_transaction += int(maximum_dates_transaction_2)
                                if "close_price" in value and isinstance(value["close_price"], list):
                                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                                    dates_transaction_Array.append(int(len(value["close_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                    # 篩選最長交易天數;
                                    if int(len(value["close_price"])) > int(maximum_dates_transaction):
                                        maximum_dates_transaction_2 = int(len(value["close_price"]))
                                        maximum_dates_transaction *= int(0)
                                        maximum_dates_transaction += int(maximum_dates_transaction_2)
                                if "low_price" in value and isinstance(value["low_price"], list):
                                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                                    dates_transaction_Array.append(int(len(value["low_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                    # 篩選最長交易天數;
                                    if int(len(value["low_price"])) > int(maximum_dates_transaction):
                                        maximum_dates_transaction_2 = int(len(value["low_price"]))
                                        maximum_dates_transaction *= int(0)
                                        maximum_dates_transaction += int(maximum_dates_transaction_2)
                                if "high_price" in value and isinstance(value["high_price"], list):
                                    # 記錄交易天數，使用 list.append() 函數在數組末尾追加推入新元;
                                    dates_transaction_Array.append(int(len(value["high_price"])))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                                    # 篩選最長交易天數;
                                    if int(len(value["high_price"])) > int(maximum_dates_transaction):
                                        maximum_dates_transaction_2 = int(len(value["high_price"]))
                                        maximum_dates_transaction *= int(0)
                                        maximum_dates_transaction += int(maximum_dates_transaction_2)
                        # print(maximum_dates_transaction)

                        if int(len(dates_transaction_Array)) > int(0):
                            minimum_dates_transaction_2 = int(min(dates_transaction_Array))
                            minimum_dates_transaction *= int(0)
                            minimum_dates_transaction += int(minimum_dates_transaction_2)
                        # print(minimum_dates_transaction)
                        dates_transaction_Array = None  # 釋放内存;

                    P1 = int(round(P1, 0))  # 函數：round(P1, 0) 表示四捨五入取整;

                    y_Dict = {}
                    for key, value in trainingData.items():

                        # 增設優化（Optimizion）懲罰（Penalty）函數，增加約束條件：P2 > P3 , P1 >= 1 當約束條件成立時，優化目標函數取最大值，目的是，回避參數：P2 <= P3 和 P1 < 1 的情況;
                        if P2 <= P3 or (P1 < 1 or P1 > minimum_dates_transaction):
                            y_Dict[key] = (+math.inf)

                        # 最優化目標函數，回避參數：P2 <= P3 或 P1 < 1 的情況;
                        if P2 > P3 and (P1 >= 1 and P1 <= minimum_dates_transaction):
                            # y = MarketTiming_f_fit_model([{key : value}, Quantitative_Indicators_Function, investment_method], [P1, P2, P3, P4])
                            y = MarketTiming_fit_model({key : value}, P1, P2, P3, P4, Quantitative_Indicators_Function, investment_method)
                            # print(y)
                            if isinstance(y, dict) and int(len(y)) > int(0) and str(key) in y:
                                if investment_method == "Long_Position_and_Short_Selling":
                                    if isinstance(y[key], dict) and int(len(y[key])) > int(0) and "y_profit" in y[key]:
                                        if y[key]["y_profit"] is None or numpy.isnan(y[key]["y_profit"]):
                                            y_Dict[key] = (+math.inf)
                                        else:
                                            # print(y[key]["y_profit"])
                                            y_Dict[key] = (-(y[key]["y_profit"]))  # 取負號（-）表示，將最優化目標函數最小值，轉換爲，最優化目標函數最大值;
                                    else:
                                        y_Dict[key] = (+math.inf)
                                elif investment_method == "Long_Position":
                                    if isinstance(y[key], dict) and int(len(y[key])) > int(0) and "y_Long_Position_profit" in y[key]:
                                        if y[key]["y_Long_Position_profit"] is None or numpy.isnan(y[key]["y_Long_Position_profit"]):
                                            y_Dict[key] = (+math.inf)
                                        else:
                                            # print(y[key]["y_Long_Position_profit"])
                                            y_Dict[key] = (-(y[key]["y_Long_Position_profit"]))  # 取負號（-）表示，將最優化目標函數最小值，轉換爲，最優化目標函數最大值;
                                    else:
                                        y_Dict[key] = (+math.inf)
                                elif investment_method == "Short_Selling":
                                    if isinstance(y[key], dict) and int(len(y[key])) > int(0) and "y_Short_Selling_profit" in y[key]:
                                        if y[key]["y_Short_Selling_profit"] is None or numpy.isnan(y[key]["y_Short_Selling_profit"]):
                                            y_Dict[key] = (+math.inf)
                                        else:
                                            # print(y[key]["y_Short_Selling_profit"])
                                            y_Dict[key] = (-(y[key]["y_Short_Selling_profit"]))  # 取負號（-）表示，將最優化目標函數最小值，轉換爲，最優化目標函數最大值;
                                    else:
                                        y_Dict[key] = (+math.inf)
                                # else:
                            else:
                                y_Dict[key] = (+math.inf)

                            # if isinstance(y, dict) and int(len(y)) > int(0) and str(key) in y:
                            #     if investment_method == "Long_Position_and_Short_Selling":
                            #         if isinstance(y[key], dict) and int(len(y[key])) > int(0) and "y_loss" in y[key]:
                            #             if y[key]["y_loss"] is None or numpy.isnan(y[key]["y_loss"]):
                            #                 y_Dict[key] = (+math.inf)
                            #             else:
                            #                 # print(y[key]["y_loss"])
                            #                 y_Dict[key] = (+(y[key]["y_loss"]))  # 取負號（+）表示，取最優化目標函數最小值;
                            #         else:
                            #             y_Dict[key] = (+math.inf)
                            #     elif investment_method == "Long_Position":
                            #         if isinstance(y[key], dict) and int(len(y[key])) > int(0) and "y_Long_Position_loss" in y[key]:
                            #             if y[key]["y_Long_Position_loss"] is None or numpy.isnan(y[key]["y_Long_Position_loss"]):
                            #                 y_Dict[key] = (+math.inf)
                            #             else:
                            #                 # print(y[key]["y_Long_Position_loss"])
                            #                 y_Dict[key] = (+(y[key]["y_Long_Position_loss"]))  # 取負號（+）表示，取最優化目標函數最小值;
                            #         else:
                            #             y_Dict[key] = (+math.inf)
                            #     elif investment_method == "Short_Selling":
                            #         if isinstance(y[key], dict) and int(len(y[key])) > int(0) and "y_Short_Selling_loss" in y[key]:
                            #             if y[key]["y_Short_Selling_loss"] is None or numpy.isnan(y[key]["y_Short_Selling_loss"]):
                            #                 y_Dict[key] = (+math.inf)
                            #             else:
                            #                 # print(y[key]["y_Short_Selling_loss"])
                            #                 y_Dict[key] = (+(y[key]["y_Short_Selling_loss"]))  # 取負號（+）表示，取最優化目標函數最小值;
                            #         else:
                            #             y_Dict[key] = (+math.inf)
                            #     # else:
                            # else:
                            #     y_Dict[key] = (+math.inf)

                        # print(y_Dict[key])

                    return y_Dict

                # MarketTiming_f_optim_model = lambda P: (
                #     MarketTiming_optim_model(
                #         {
                #             key: {
                #                 "date_transaction": value["date_transaction"],
                #                 "turnover_volume": value["turnover_volume"],
                #                 "turnover_amount": value["turnover_amount"],
                #                 "opening_price": value["opening_price"],
                #                 "close_price": value["close_price"],
                #                 "low_price": value["low_price"],
                #                 "high_price": value["high_price"],
                #                 "focus": training_focus,
                #                 "amplitude": training_amplitude,
                #                 "amplitude_rate": training_amplitude_rate,
                #                 "opening_price_Standardization": training_opening_price_Standardization,
                #                 "closing_price_Standardization": training_closing_price_Standardization,
                #                 "low_price_Standardization": training_low_price_Standardization,
                #                 "high_price_Standardization": training_high_price_Standardization,
                #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                #                 "high_price_proportion": training_high_price_proportion,
                #                 "low_price_proportion": training_low_price_proportion
                #             }
                #         },
                #         P[0],
                #         P[1],
                #         P[2],
                #         P[3],
                #         Quantitative_Indicators_Function,
                #         investment_method
                #     )[key]
                # )

                # MarketTiming_f_optim_model = lambda P: (
                #     MarketTiming_fit_model(
                #         {
                #             key: {
                #                 "date_transaction": value["date_transaction"],
                #                 "turnover_volume": value["turnover_volume"],
                #                 "turnover_amount": value["turnover_amount"],
                #                 "opening_price": value["opening_price"],
                #                 "close_price": value["close_price"],
                #                 "low_price": value["low_price"],
                #                 "high_price": value["high_price"],
                #                 "focus": training_focus,
                #                 "amplitude": training_amplitude,
                #                 "amplitude_rate": training_amplitude_rate,
                #                 "opening_price_Standardization": training_opening_price_Standardization,
                #                 "closing_price_Standardization": training_closing_price_Standardization,
                #                 "low_price_Standardization": training_low_price_Standardization,
                #                 "high_price_Standardization": training_high_price_Standardization,
                #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                #                 "high_price_proportion": training_high_price_proportion,
                #                 "low_price_proportion": training_low_price_proportion
                #             }
                #         },
                #         P[0],
                #         P[1],
                #         P[2],
                #         P[3],
                #         Quantitative_Indicators_Function,
                #         investment_method
                #     )[key]["y"]
                # )

                # 自定義手動優化過程求最大值;
                P1_I = [P1]  # [int(3)]
                P2_I = [P2]  # [float(+1.0)]
                P3_I = [P3]  # [float(-1.0)]
                P4_I = [P4]  # [float(0.0)]
                f_y_max = [float(0.0)]  # [-math.inf]
                # for i in range(int(0), int(min([len(value["date_transaction"]), len(value["turnover_volume"]), len(value["turnover_amount"]), len(value["opening_price"]), len(value["close_price"]), len(value["low_price"]), len(value["high_price"]), len(training_focus), len(training_amplitude), len(training_amplitude_rate), len(training_opening_price_Standardization), len(training_closing_price_Standardization), len(training_low_price_Standardization), len(training_high_price_Standardization), len(training_turnover_volume_growth_rate), len(training_opening_price_growth_rate), len(training_closing_price_growth_rate), len(training_closing_minus_opening_price_growth_rate), len(training_high_price_proportion), len(training_low_price_proportion)])), int(1)):
                # for i in range(int(0), int(60), int(1)):
                for i in range(int(Plower[0] - int(1)), int(Pupper[0]), int(1)):

                    # 定義優化目標函數;
                    MarketTiming_f_optim_model = lambda P: (
                        MarketTiming_optim_model(
                            {
                                key: {
                                    "date_transaction": value["date_transaction"],
                                    "turnover_volume": value["turnover_volume"],
                                    # "turnover_amount": value["turnover_amount"],
                                    "opening_price": value["opening_price"],
                                    "close_price": value["close_price"],
                                    "low_price": value["low_price"],
                                    "high_price": value["high_price"],
                                    "focus": training_focus,
                                    "amplitude": training_amplitude,
                                    "amplitude_rate": training_amplitude_rate,
                                    "opening_price_Standardization": training_opening_price_Standardization,
                                    "closing_price_Standardization": training_closing_price_Standardization,
                                    "low_price_Standardization": training_low_price_Standardization,
                                    "high_price_Standardization": training_high_price_Standardization,
                                    "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                                    "opening_price_growth_rate": training_opening_price_growth_rate,
                                    "closing_price_growth_rate": training_closing_price_growth_rate,
                                    "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                                    "high_price_proportion": training_high_price_proportion,
                                    "low_price_proportion": training_low_price_proportion
                                }
                            },
                            int(int(i) + int(1)),
                            P[0],
                            P[1],
                            P[2],
                            Quantitative_Indicators_Function,
                            investment_method
                        )[key]
                    )

                    # from scipy.optimize import minimize as scipy_optimize_minimize  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「minimize()」函數，用於通用形式優化問題求解（optimization）;
                    # https://www.scipy.org/docs.html
                    # scipy.optimize.linprog()  # 缐性規劃;
                    # scipy.optimize.shgo()  # 全跼優化;
                    # res = scipy.optimize.minimize(fun, x0, args=(), method=None, jac=None, hess=None, hessp=None, bounds=None, constraints=(), tol=None, callback=None, options=None)
                    # 創建優化對象;
                    result_optim = scipy_optimize_minimize(
                        MarketTiming_f_optim_model,
                        [
                            # P1,  # P1_I[1],  # int(i),
                            P2,  # P2_I[1],
                            P3,  # P3_I[1],
                            P4  # P4_I[1]
                        ],
                        method = 'Nelder-Mead',  # 'Nelder-Mead',  # 'SLSQP',  # 'L-BFGS-B',  # 'BFGS',  # 'CG',  # 'TNC',  # 'COBYLA',  # 參數 bounds 只支持：方法：'SLSQP'、'L-BFGS-B' ;
                        bounds = (
                            # (Plower[0], Pupper[0]),  # (int(1), int(20)),  # (int(1), None),
                            (Plower[1], Pupper[1]),  # (-math.inf, +math.inf),
                            (Plower[2], Pupper[2]),  # (-math.inf, +math.inf),
                            (Plower[3], Pupper[3])  # (-math.inf, +math.inf)
                        ),
                        # constraints = (
                        #     # {'type': 'ineq', 'fun': lambda x : (x[0] - 1)},  # 參數 'type' 取 'ineq' 值表示不等式約束，取 'eq' 值表示等式約束。參數 'fun' 表示約束條件計算式，例如若要求：x1 + x2 = 1，可如下配置：{'type': 'eq', 'fun': lambda x : (x[0] + x[1] - 1)} ;
                        #     # {'type': 'ineq', 'fun': lambda x : (20 - x[0])},
                        #     # {'type': 'ineq', 'fun': lambda x : (x[1] - (-math.inf))},
                        #     # {'type': 'ineq', 'fun': lambda x : ((+math.inf) - x[1])},
                        #     # {'type': 'ineq', 'fun': lambda x : (x[2] - (-math.inf))},
                        #     # {'type': 'ineq', 'fun': lambda x : ((+math.inf) - x[2])},
                        #     # {'type': 'ineq', 'fun': lambda x : (x[3] - (-math.inf))},
                        #     # {'type': 'ineq', 'fun': lambda x : ((+math.inf) - x[3])}
                        #     {'type': 'ineq', 'fun': lambda x : (x[0] - Plower[1])},
                        #     {'type': 'ineq', 'fun': lambda x : (Pupper[1] - x[0])},
                        #     {'type': 'ineq', 'fun': lambda x : (x[1] - Plower[2])},
                        #     {'type': 'ineq', 'fun': lambda x : (Pupper[2] - x[1])},
                        #     {'type': 'ineq', 'fun': lambda x : (x[2] - Plower[3])},
                        #     {'type': 'ineq', 'fun': lambda x : (Pupper[3] - x[2])}
                        # ),
                        jac = None,  # None,  # '2-point',  # '3-point',  # 'cs',  # 自定義的梯度函數：lambda x : (dy/dx),
                        tol = 1e-6,
                        options = {
                            'maxiter': 10000,
                            # 'gtol': 1e-6,
                            # "ftol‌": 1e-6,
                            # '‌xtol‌': 1e-6,
                            'disp': False  # 配置是否打印輸出每一步（Run）優化的信息，取 True 表示打印輸出每一步（Run）優化的信息，取取 False 表示不打印輸出每一步（Run）優化的信息;
                        }
                        # callback = print_iteration
                    )
                    # print(result_optim)
                    # print("優化結果狀態標示 : ", result_optim.success)
                    # print("優化算法迭代次數 : ", result_optim.nit)
                    # print("目標函數被調用的次數 : ", result_optim.nfev)
                    # print("最優解 : ", result_optim.x)
                    # print("最優解對應的目標函數值 : ", result_optim.fun)
                    # print("優化結果狀態信息 : ", result_optim.message)

                    # 讀取優化結果;
                    f_min_x = result_optim.x  # 貨的最小值點（x 值）（總是一個向量 Vector）;
                    # print(f_min_x)
                    # print(f_min_x[0])
                    # print(f_min_x[1])
                    # print(f_min_x[2])
                    # print("最優解: ", result_optim.x[0], result_optim.x[1], result_optim.x[2], result_optim.x[3])  # 輸出最優解參數 P 向量;
                    f_min_y = result_optim.fun  # 獲得最小值（y 值）;
                    # print(f_min_y)
                    f_min_y = float(-float(f_min_y))
                    # print(f_min_y)
                    if float(f_min_y) > float(f_y_max[0]):
                        f_y_max[0] = float(f_min_y)
                        # print(f_y_max[0])
                        P1_I[0] = int(int(i) + int(1))  # int(f_min_x[0])
                        # print(P1_I[0])
                        P2_I[0] = float(f_min_x[0])  # float(f_min_x[1])
                        # print(P2_I[0])
                        P3_I[0] = float(f_min_x[1])  # float(f_min_x[2])
                        # print(P3_I[0])
                        P4_I[0] = float(f_min_x[2])  # float(f_min_x[3])
                        # print(P4_I[0])
                    # MarketTiming_f_optim_model = None  # 釋放内存;

                P1 = int(P1_I[0])
                P1 = int(round(P1, 0))  # 函數：round(P1, 0) 表示四捨五入取整;
                # print(P1)
                P2 = float(P2_I[0])
                # print(P2)
                P3 = float(P3_I[0])
                # print(P3)
                P4 = float(P4_I[0])
                # print(P4)

                # # 定義優化目標函數;
                # MarketTiming_f_optim_model = lambda P: (
                #     MarketTiming_optim_model(
                #         {
                #             key: {
                #                 "date_transaction": value["date_transaction"],
                #                 "turnover_volume": value["turnover_volume"],
                #                 # "turnover_amount": value["turnover_amount"],
                #                 "opening_price": value["opening_price"],
                #                 "close_price": value["close_price"],
                #                 "low_price": value["low_price"],
                #                 "high_price": value["high_price"],
                #                 "focus": training_focus,
                #                 "amplitude": training_amplitude,
                #                 "amplitude_rate": training_amplitude_rate,
                #                 "opening_price_Standardization": training_opening_price_Standardization,
                #                 "closing_price_Standardization": training_closing_price_Standardization,
                #                 "low_price_Standardization": training_low_price_Standardization,
                #                 "high_price_Standardization": training_high_price_Standardization,
                #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                #                 "high_price_proportion": training_high_price_proportion,
                #                 "low_price_proportion": training_low_price_proportion
                #             }
                #         },
                #         P[0],
                #         P[1],
                #         P[2],
                #         P[3],
                #         Quantitative_Indicators_Function,
                #         investment_method
                #     )[key]
                # )
                # # 創建優化對象;
                # result_optim = scipy_optimize_minimize(
                #     MarketTiming_f_optim_model,
                #     [
                #         P1,  # P1_I[0],
                #         P2,  # P2_I[0],
                #         P3,  # P3_I[0],
                #         P4  # P4_I[0]
                #     ],
                #     method = 'Nelder-Mead',  # 'Nelder-Mead',  # 'SLSQP',  # 'L-BFGS-B',  # 'BFGS',  # 'CG',  # 'TNC',  # 'COBYLA',  # 參數 bounds 只支持：方法：'SLSQP'、'L-BFGS-B' ;
                #     bounds = (
                #         (Plower[0], Pupper[0]),  # (int(1), int(20)),  # (int(1), None),  # (-math.inf, +math.inf),
                #         (Plower[1], Pupper[1]),  # (-math.inf, +math.inf),
                #         (Plower[2], Pupper[2]),  # (-math.inf, +math.inf),
                #         (Plower[3], Pupper[3])  # (-math.inf, +math.inf))
                #     ),
                #     constraints = (
                #         # {'type': 'ineq', 'fun': lambda x : (x[0] - 1)},  # 參數 'type' 取 'ineq' 值表示不等式約束，取 'eq' 值表示等式約束。參數 'fun' 表示約束條件計算式，例如若要求：x1 + x2 = 1，可如下配置：{'type': 'eq', 'fun': lambda x : (x[0] + x[1] - 1)} ;
                #         # {'type': 'ineq', 'fun': lambda x : (20 - x[0])},
                #         # {'type': 'ineq', 'fun': lambda x : (x[1] - (-math.inf))},
                #         # {'type': 'ineq', 'fun': lambda x : ((+math.inf) - x[1])},
                #         # {'type': 'ineq', 'fun': lambda x : (x[2] - (-math.inf))},
                #         # {'type': 'ineq', 'fun': lambda x : ((+math.inf) - x[2])},
                #         # {'type': 'ineq', 'fun': lambda x : (x[3] - (-math.inf))},
                #         # {'type': 'ineq', 'fun': lambda x : ((+math.inf) - x[3])}
                #         {'type': 'ineq', 'fun': lambda x : (x[0] - Plower[0])},
                #         {'type': 'ineq', 'fun': lambda x : (Pupper[0] - x[0])},
                #         {'type': 'ineq', 'fun': lambda x : (x[1] - Plower[1])},
                #         {'type': 'ineq', 'fun': lambda x : (Pupper[1] - x[1])},
                #         {'type': 'ineq', 'fun': lambda x : (x[2] - Plower[2])},
                #         {'type': 'ineq', 'fun': lambda x : (Pupper[2] - x[2])},
                #         {'type': 'ineq', 'fun': lambda x : (x[3] - Plower[3])},
                #         {'type': 'ineq', 'fun': lambda x : (Pupper[3] - x[3])}
                #     ),
                #     jac = '2-point',  # None,  # '2-point',  # '3-point',  # 'cs',  # 自定義的梯度函數：lambda x : (dy/dx),
                #     tol = 1e-6,
                #     options = {
                #         'maxiter': 10000,
                #         # 'gtol': 1e-6,
                #         # "ftol‌": 1e-6,
                #         # '‌xtol‌': 1e-6,
                #         'disp': False  # True
                #     }
                # )
                # # print("優化結果狀態標示 : ", result_optim.success)
                # # print("優化算法迭代次數 : ", result_optim.nit)
                # # print("目標函數被調用的次數 : ", result_optim.nfev)
                # # print("最優解 : ", result_optim.x)
                # # print("最優解對應的目標函數值 : ", result_optim.fun)
                # # print("優化結果狀態信息 : ", result_optim.message)
                # # 讀取優化結果;
                # f_min_x = result_optim.x  # 貨的最小值點（x 值）（總是一個向量 Vector）;
                # # print(f_min_x)
                # # print("最優解: ", result_optim.x[0], result_optim.x[1], result_optim.x[2], result_optim.x[3])  # 輸出最優解參數 P 向量;
                # f_min_y = result_optim.fun  # 獲得最小值（y 值）;
                # f_min_y = float(-float(f_min_y))
                # # print(f_min_y)
                # if float(f_min_y) > float(f_y_max[0]):
                #     f_y_max[0] = float(f_min_y)
                #     # print(f_y_max[0])
                #     P1_I[0] = int(round(f_min_x[0], 0))  # 函數：round(P1, 0) 表示四捨五入取整;
                #     # print(P1_I[0])
                #     P2_I[0] = float(f_min_x[1])
                #     # print(P2_I[0])
                #     P3_I[0] = float(f_min_x[2])
                #     # print(P3_I[0])
                #     P4_I[0] = float(f_min_x[3])
                #     # print(P4_I[0])
                # # MarketTiming_f_optim_model = None  # 釋放内存;
                # P1 = int(P1_I[0])
                # P1 = int(round(P1, 0))  # 函數：round(P1, 0) 表示四捨五入取整;
                # # print(P1)
                # P2 = float(P2_I[0])
                # # print(P2)
                # P3 = float(P3_I[0])
                # # print(P3)
                # P4 = float(P4_I[0])
                # # print(P4)

                sdP1 = int(0)  # 優化之後獲得的參數的標準差;
                sdP2 = float(0.0)  # 優化之後獲得的參數的標準差;
                sdP3 = float(0.0)  # 優化之後獲得的參數的標準差;
                sdP4 = float(0.0)  # 優化之後獲得的參數的標準差;

                # coefficient_from_fit = []  # 優化之後得到的參數值;
                coefficient_from_fit.append(P1)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                coefficient_from_fit.append(P2)
                coefficient_from_fit.append(P3)
                coefficient_from_fit.append(P4)
                # coefficient_from_fit[0] = P1
                # coefficient_from_fit[1] = P2
                # coefficient_from_fit[2] = P3
                # coefficient_from_fit[3] = P4

                # margin_of_error = []  # 優化之後得到的參數解的標準差;
                # margin_of_error[0] = sdP1
                # margin_of_error[1] = sdP2
                # margin_of_error[2] = sdP3
                # margin_of_error[3] = sdP4
                margin_of_error.append(sdP1)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                margin_of_error.append(sdP2)
                margin_of_error.append(sdP3)
                margin_of_error.append(sdP4)
                # print(margin_of_error)  # margin_of_error 擬合參數解的標準差;

                # confidence_inter = []  # 擬合得到的參數解的 95% 水平的致信區間;
                # confidence_inter[0] = [(P1 - sdP1), (P1 + sdP1)]
                # confidence_inter[1] = [(P2 - sdP2), (P2 + sdP2)]
                # confidence_inter[2] = [(P3 - sdP3), (P3 + sdP3)]
                # confidence_inter[3] = [(P4 - sdP4), (P4 + sdP4)]
                confidence_inter.append([(P1 - sdP1), (P1 + sdP1)])  # 使用 list.append() 函數在列表末尾追加推入新元素;
                confidence_inter.append([(P2 - sdP2), (P2 + sdP2)])
                confidence_inter.append([(P3 - sdP3), (P3 + sdP3)])
                confidence_inter.append([(P4 - sdP4), (P4 + sdP4)])
                # print(confidence_inter)  # confidence_inter 擬合參數解的 95% 水平的致信區間;

                # 計算擬合的應變量 Yvals 值;
                # Yvals = []  # 應變量 y 的擬合值;
                yv = MarketTiming_fit_model(
                    {
                        key: {
                            "date_transaction": value["date_transaction"],
                            "turnover_volume": value["turnover_volume"],
                            # "turnover_amount": value["turnover_amount"],
                            "opening_price": value["opening_price"],
                            "close_price": value["close_price"],
                            "low_price": value["low_price"],
                            "high_price": value["high_price"],
                            "focus": training_focus,
                            "amplitude": training_amplitude,
                            "amplitude_rate": training_amplitude_rate,
                            "opening_price_Standardization": training_opening_price_Standardization,
                            "closing_price_Standardization": training_closing_price_Standardization,
                            "low_price_Standardization": training_low_price_Standardization,
                            "high_price_Standardization": training_high_price_Standardization,
                            "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                            "opening_price_growth_rate": training_opening_price_growth_rate,
                            "closing_price_growth_rate": training_closing_price_growth_rate,
                            "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                            "high_price_proportion": training_high_price_proportion,
                            "low_price_proportion": training_low_price_proportion
                        }
                    },
                    P1,
                    P2,
                    P3,
                    P4,
                    Quantitative_Indicators_Function,
                    investment_method
                )[key]
                # yv = MarketTiming_f_fit_model(
                #     [
                #         {
                #             key: {
                #                 "date_transaction": value["date_transaction"],
                #                 "turnover_volume": value["turnover_volume"],
                #                 # "turnover_amount": value["turnover_amount"],
                #                 "opening_price": value["opening_price"],
                #                 "close_price": value["close_price"],
                #                 "low_price": value["low_price"],
                #                 "high_price": value["high_price"],
                #                 "focus": training_focus,
                #                 "amplitude": training_amplitude,
                #                 "amplitude_rate": training_amplitude_rate,
                #                 "opening_price_Standardization": training_opening_price_Standardization,
                #                 "closing_price_Standardization": training_closing_price_Standardization,
                #                 "low_price_Standardization": training_low_price_Standardization,
                #                 "high_price_Standardization": training_high_price_Standardization,
                #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                #                 "high_price_proportion": training_high_price_proportion,
                #                 "low_price_proportion": training_low_price_proportion
                #             }
                #         },
                #         Quantitative_Indicators_Function,
                #         investment_method
                #     ],
                #     [
                #         P1,
                #         P2,
                #         P3,
                #         P4
                #     ]
                # )[key]
                if not (yv["profit_total"] is None):
                    yv = float(yv["profit_total"])
                    Yvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # 計算擬合的應變量 Yvals 誤差上下限;
                # YvalsUncertaintyLower = []  # 擬合的應變量 Yvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
                # YvalsUncertaintyUpper = []  # 擬合的應變量 Yvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
                for i in range(int(0), int(len(Yvals)), int(1)):
                    yvsd = MarketTiming_fit_model(
                        {
                            key: {
                                "date_transaction": value["date_transaction"],
                                "turnover_volume": value["turnover_volume"],
                                # "turnover_amount": value["turnover_amount"],
                                "opening_price": value["opening_price"],
                                "close_price": value["close_price"],
                                "low_price": value["low_price"],
                                "high_price": value["high_price"],
                                "focus": training_focus,
                                "amplitude": training_amplitude,
                                "amplitude_rate": training_amplitude_rate,
                                "opening_price_Standardization": training_opening_price_Standardization,
                                "closing_price_Standardization": training_closing_price_Standardization,
                                "low_price_Standardization": training_low_price_Standardization,
                                "high_price_Standardization": training_high_price_Standardization,
                                "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                                "opening_price_growth_rate": training_opening_price_growth_rate,
                                "closing_price_growth_rate": training_closing_price_growth_rate,
                                "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                                "high_price_proportion": training_high_price_proportion,
                                "low_price_proportion": training_low_price_proportion
                            }
                        },
                        (P1 - sdP1),
                        (P2 - sdP2),
                        (P3 - sdP3),
                        (P4 - sdP4),
                        Quantitative_Indicators_Function,
                        investment_method
                    )[key]
                    # yvsd = MarketTiming_f_fit_model(
                    #     [
                    #         {
                    #             key: {
                    #                 "date_transaction": value["date_transaction"],
                    #                 "turnover_volume": value["turnover_volume"],
                    #                 # "turnover_amount": value["turnover_amount"],
                    #                 "opening_price": value["opening_price"],
                    #                 "close_price": value["close_price"],
                    #                 "low_price": value["low_price"],
                    #                 "high_price": value["high_price"],
                    #                 "focus": training_focus,
                    #                 "amplitude": training_amplitude,
                    #                 "amplitude_rate": training_amplitude_rate,
                    #                 "opening_price_Standardization": training_opening_price_Standardization,
                    #                 "closing_price_Standardization": training_closing_price_Standardization,
                    #                 "low_price_Standardization": training_low_price_Standardization,
                    #                 "high_price_Standardization": training_high_price_Standardization,
                    #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                    #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                    #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                    #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                    #                 "high_price_proportion": training_high_price_proportion,
                    #                 "low_price_proportion": training_low_price_proportion
                    #             )
                    #         ),
                    #         Quantitative_Indicators_Function,
                    #         investment_method
                    #     ],
                    #     [
                    #         (P1 - sdP1),
                    #         (P2 - sdP2),
                    #         (P3 - sdP3),
                    #         (P4 - sdP4)
                    #     ]
                    # )[key]
                    yvLower = float(Yvals[i] * float(float(1.0) - yvsd["average_price_amplitude_date_transaction"]))
                    # yvLower = Yvals[i] - numpy.sqrt((Yvals[i] - yvsd)**2 + float(numpy.std(YdataSTD))**2)  # numpy.std(YdataSTD, ddof = 1)
                    yvLower = float(yvLower)
                    YvalsUncertaintyLower.append(yvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    yvsd = MarketTiming_fit_model(
                        {
                            key: {
                                "date_transaction": value["date_transaction"],
                                "turnover_volume": value["turnover_volume"],
                                # "turnover_amount": value["turnover_amount"],
                                "opening_price": value["opening_price"],
                                "close_price": value["close_price"],
                                "low_price": value["low_price"],
                                "high_price": value["high_price"],
                                "focus": training_focus,
                                "amplitude": training_amplitude,
                                "amplitude_rate": training_amplitude_rate,
                                "opening_price_Standardization": training_opening_price_Standardization,
                                "closing_price_Standardization": training_closing_price_Standardization,
                                "low_price_Standardization": training_low_price_Standardization,
                                "high_price_Standardization": training_high_price_Standardization,
                                "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                                "opening_price_growth_rate": training_opening_price_growth_rate,
                                "closing_price_growth_rate": training_closing_price_growth_rate,
                                "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                                "high_price_proportion": training_high_price_proportion,
                                "low_price_proportion": training_low_price_proportion
                            }
                        },
                        (P1 + sdP1),
                        (P2 + sdP2),
                        (P3 + sdP3),
                        (P4 + sdP4),
                        Quantitative_Indicators_Function,
                        investment_method
                    )[key]
                    # yvsd = MarketTiming_f_fit_model(
                    #     [
                    #         {
                    #             key: {
                    #                 "date_transaction": value["date_transaction"],
                    #                 "turnover_volume": value["turnover_volume"],
                    #                 # "turnover_amount": value["turnover_amount"],
                    #                 "opening_price": value["opening_price"],
                    #                 "close_price": value["close_price"],
                    #                 "low_price": value["low_price"],
                    #                 "high_price": value["high_price"],
                    #                 "focus": training_focus,
                    #                 "amplitude": training_amplitude,
                    #                 "amplitude_rate": training_amplitude_rate,
                    #                 "opening_price_Standardization": training_opening_price_Standardization,
                    #                 "closing_price_Standardization": training_closing_price_Standardization,
                    #                 "low_price_Standardization": training_low_price_Standardization,
                    #                 "high_price_Standardization": training_high_price_Standardization,
                    #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                    #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                    #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                    #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                    #                 "high_price_proportion": training_high_price_proportion,
                    #                 "low_price_proportion": training_low_price_proportion
                    #             }
                    #         },
                    #         Quantitative_Indicators_Function,
                    #         investment_method
                    #     ],
                    #     [
                    #         (P1 + sdP1),
                    #         (P2 + sdP2),
                    #         (P3 + sdP3),
                    #         (P4 + sdP4)
                    #     ]
                    # )[key]
                    yvUpper = float(Yvals[i] * float(float(1.0) + yvsd["average_price_amplitude_date_transaction"]))
                    # yvUpper = Yvals[i] + numpy.sqrt((yvsd - Yvals[i])**2 + float(numpy.std(YdataSTD))**2)  # numpy.std(YdataSTD, ddof = 1)
                    yvUpper = float(yvUpper)
                    YvalsUncertaintyUpper.append(yvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # 計算擬合殘差;
                # Residual = []  # 擬合殘差向量;
                for i in range(int(0), int(len(Yvals)), int(1)):
                    # resi = float(numpy.std(YdataSTD)) * Yvals[i]  # numpy.std(YdataSTD, ddof = 1)
                    yvsd = MarketTiming_fit_model(
                        {
                            key: {
                                "date_transaction": value["date_transaction"],
                                "turnover_volume": value["turnover_volume"],
                                # "turnover_amount": value["turnover_amount"],
                                "opening_price": value["opening_price"],
                                "close_price": value["close_price"],
                                "low_price": value["low_price"],
                                "high_price": value["high_price"],
                                "focus": training_focus,
                                "amplitude": training_amplitude,
                                "amplitude_rate": training_amplitude_rate,
                                "opening_price_Standardization": training_opening_price_Standardization,
                                "closing_price_Standardization": training_closing_price_Standardization,
                                "low_price_Standardization": training_low_price_Standardization,
                                "high_price_Standardization": training_high_price_Standardization,
                                "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                                "opening_price_growth_rate": training_opening_price_growth_rate,
                                "closing_price_growth_rate": training_closing_price_growth_rate,
                                "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                                "high_price_proportion": training_high_price_proportion,
                                "low_price_proportion": training_low_price_proportion
                            }
                        },
                        P1,
                        P2,
                        P3,
                        P4,
                        Quantitative_Indicators_Function,
                        investment_method
                    )[key]
                    # yvsd = MarketTiming_f_fit_model(
                    #     [
                    #         {
                    #             key: {
                    #                 "date_transaction": value["date_transaction"],
                    #                 "turnover_volume": value["turnover_volume"],
                    #                 # "turnover_amount": value["turnover_amount"],
                    #                 "opening_price": value["opening_price"],
                    #                 "close_price": value["close_price"],
                    #                 "low_price": value["low_price"],
                    #                 "high_price": value["high_price"],
                    #                 "focus": training_focus,
                    #                 "amplitude": training_amplitude,
                    #                 "amplitude_rate": training_amplitude_rate,
                    #                 "opening_price_Standardization": training_opening_price_Standardization,
                    #                 "closing_price_Standardization": training_closing_price_Standardization,
                    #                 "low_price_Standardization": training_low_price_Standardization,
                    #                 "high_price_Standardization": training_high_price_Standardization,
                    #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                    #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                    #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                    #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                    #                 "high_price_proportion": training_high_price_proportion,
                    #                 "low_price_proportion": training_low_price_proportion
                    #             }
                    #         },
                    #         Quantitative_Indicators_Function,
                    #         investment_method
                    #     ],
                    #     [
                    #         P1,
                    #         P2,
                    #         P3,
                    #         P4
                    #     ]
                    # )[key]
                    resi = float(yvsd["average_price_amplitude_date_transaction"] * Yvals[i])
                    Residual.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # training_result = MarketTiming_f_fit_model(
                #     [
                #         {
                #             key: {
                #                 "date_transaction": value["date_transaction"],
                #                 "turnover_volume": value["turnover_volume"],
                #                 # "turnover_amount": value["turnover_amount"],
                #                 "opening_price": value["opening_price"],
                #                 "close_price": value["close_price"],
                #                 "low_price": value["low_price"],
                #                 "high_price": value["high_price"],
                #                 "focus": training_focus,
                #                 "amplitude": training_amplitude,
                #                 "amplitude_rate": training_amplitude_rate,
                #                 "opening_price_Standardization": training_opening_price_Standardization,
                #                 "closing_price_Standardization": training_closing_price_Standardization,
                #                 "low_price_Standardization": training_low_price_Standardization,
                #                 "high_price_Standardization": training_high_price_Standardization,
                #                 "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                #                 "opening_price_growth_rate": training_opening_price_growth_rate,
                #                 "closing_price_growth_rate": training_closing_price_growth_rate,
                #                 "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                #                 "high_price_proportion": training_high_price_proportion,
                #                 "low_price_proportion": training_low_price_proportion
                #             }
                #         },
                #         Quantitative_Indicators_Function,
                #         investment_method
                #     ],
                #     [
                #         P1,
                #         P2,
                #         P3,
                #         P4
                #     ]
                # )[key]
                training_result = MarketTiming_fit_model(
                    {
                        key: {
                            "date_transaction": value["date_transaction"],
                            "turnover_volume": value["turnover_volume"],
                            # "turnover_amount": value["turnover_amount"],
                            "opening_price": value["opening_price"],
                            "close_price": value["close_price"],
                            "low_price": value["low_price"],
                            "high_price": value["high_price"],
                            "focus": training_focus,
                            "amplitude": training_amplitude,
                            "amplitude_rate": training_amplitude_rate,
                            "opening_price_Standardization": training_opening_price_Standardization,
                            "closing_price_Standardization": training_closing_price_Standardization,
                            "low_price_Standardization": training_low_price_Standardization,
                            "high_price_Standardization": training_high_price_Standardization,
                            "turnover_volume_growth_rate": training_turnover_volume_growth_rate,
                            "opening_price_growth_rate": training_opening_price_growth_rate,
                            "closing_price_growth_rate": training_closing_price_growth_rate,
                            "closing_minus_opening_price_growth_rate": training_closing_minus_opening_price_growth_rate,
                            "high_price_proportion": training_high_price_proportion,
                            "low_price_proportion": training_low_price_proportion
                        }
                    },
                    P1,
                    P2,
                    P3,
                    P4,
                    Quantitative_Indicators_Function,
                    investment_method
                )[key]
                # {
                #     "y_profit": y_profit,  # 優化目標變量，每兩次對衝交易利潤 × 權重，加權纍加總計;
                #     "y_Long_Position_profit": y_Long_Position_profit,  # 優化目標變量，做多（Long Position），每兩次對衝交易利潤 × 權重，加權纍加總計;
                #     "y_Short_Selling_profit": y_Short_Selling_profit,  # 優化目標變量，做空（Short Selling），每兩次對衝交易利潤 × 權重，加權纍加總計;
                #     "y_loss": y_loss,  # 優化目標變量，每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                #     "y_Long_Position_loss": y_Long_Position_loss,  # 優化目標變量，做多（Long Position），每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                #     "y_Short_Selling_loss": y_Short_Selling_loss,  # 優化目標變量，做空（Short Selling），每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                #     "profit_total": y_total,  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                #     "Long_Position_profit_total": y_total_Long_Position,  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                #     "Short_Selling_profit_total": y_total_Short_Selling,  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                #     "profit_Positive": y_Positive,  # 每兩次對衝交易收益纍加總計;
                #     "Long_Position_profit_Positive": y_Positive_Long_Position,  # 每兩次對衝交易收益纍加總計;
                #     "Short_Selling_profit_Positive": y_Positive_Short_Selling,  # 每兩次對衝交易收益纍加總計;
                #     "profit_Positive_probability": y_P_Positive,  # 每兩次對衝交易正利潤概率;
                #     "Long_Position_profit_Positive_probability": y_P_Positive_Long_Position,  # 每兩次對衝交易正利潤概率;
                #     "Short_Selling_profit_Positive_probability": y_P_Positive_Short_Selling,  # 每兩次對衝交易正利潤概率;
                #     "profit_Negative": y_Negative,  # 每兩次對衝交易損失纍加總計;
                #     "Long_Position_profit_Negative": y_Negative_Long_Position,  # 每兩次對衝交易損失纍加總計;
                #     "Short_Selling_profit_Negative": y_Negative_Short_Selling,  # 每兩次對衝交易損失纍加總計;
                #     "profit_Negative_probability": y_P_Negative,  # 每兩次對衝交易負利潤概率;
                #     "Long_Position_profit_Negative_probability": y_P_Negative_Long_Position,  # 每兩次對衝交易負利潤概率;
                #     "Short_Selling_profit_Negative_probability": y_P_Negative_Short_Selling,  # 每兩次對衝交易負利潤概率;
                #     "Long_Position_profit_date_transaction": y_A_Long_Position,  # 每兩次對衝交易利潤，向量;
                #     "Short_Selling_profit_date_transaction": y_A_Short_Selling,  # 每兩次對衝交易利潤，向量;
                #     "maximum_drawdown": y_maximum_drawdown,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                #     "maximum_drawdown_Long_Position": y_maximum_drawdown_Long_Position,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                #     "maximum_drawdown_Short_Selling": y_maximum_drawdown_Short_Selling,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                #     "Long_Position_drawdown_date_transaction": y_H_Long_Position,  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                #     "Short_Selling_drawdown_date_transaction": y_H_Short_Selling,  # 向量，記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                #     "average_price_amplitude_date_transaction": y_amplitude,  # 兩兩次對衝交易日成交價振幅平方和，均值;
                #     "Long_Position_average_price_amplitude_date_transaction": y_amplitude_Long_Position,  # 兩兩次對衝交易日成交價振幅平方和，均值;
                #     "Short_Selling_average_price_amplitude_date_transaction": y_amplitude_Short_Selling,  # 兩兩次對衝交易日成交價振幅平方和，均值;
                #     "Long_Position_price_amplitude_date_transaction": y_D_Long_Position,  # 兩次對衝交易日成交價振幅平方和，向量;
                #     "Short_Selling_price_amplitude_date_transaction": y_D_Short_Selling,  # 兩次對衝交易日成交價振幅平方和，向量;
                #     "average_volume_turnover_date_transaction": y_turnover,  # 兩次對衝交易日成交量（換手率）均值;
                #     "Long_Position_average_volume_turnover_date_transaction": y_turnover_Long_Position,  # 兩次對衝交易日成交量（換手率）均值;
                #     "Short_Selling_average_volume_turnover_date_transaction": y_turnover_Short_Selling,  # 兩次對衝交易日成交量（換手率）均值;
                #     "Long_Position_volume_turnover_date_transaction": y_E_Long_Position,  # 兩次對衝交易日成交量（換手率）向量;
                #     "Short_Selling_volume_turnover_date_transaction": y_E_Short_Selling,  # 兩次對衝交易日成交量（換手率）向量;
                #     "average_date_transaction_between": y_date_transaction_between,  # 兩次對衝交易間隔日長，均值;
                #     "Long_Position_average_date_transaction_between": y_date_transaction_between_Long_Position,  # 兩次對衝交易間隔日長，均值;
                #     "Short_Selling_average_date_transaction_between": y_date_transaction_between_Short_Selling,  # 兩次對衝交易間隔日長，均值;
                #     "Long_Position_date_transaction_between": y_C_Long_Position,  # 兩次對衝交易間隔日長，向量;
                #     "Short_Selling_date_transaction_between": y_C_Short_Selling,  # 兩次對衝交易間隔日長，向量;
                #     "Long_Position_date_transaction": y_F_Long_Position,  # 按規則執行交易的日期，向量;
                #     "Short_Selling_date_transaction": y_F_Short_Selling,  # 按規則執行交易的日期，向量;
                #     "P1_Array": P1_Array,  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
                #     "revenue_and_expenditure_records_date_transaction": y_G  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
                # }
                # print(training_result["y_profit"])  # 每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
                # print(training_result["y_Long_Position_profit"])  # 優化目標變量;
                # print(training_result["y_Short_Selling_profit"])  # 優化目標變量;
                # print(training_result["y_loss"])  # 每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
                # print(training_result["y_Long_Position_loss"])  # 優化目標變量;
                # print(training_result["y_Short_Selling_loss"])  # 優化目標變量;
                # print(training_result["profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # print(training_result["Long_Position_profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # print(training_result["Short_Selling_profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # print(training_result["profit_Positive"])  # 每兩次對衝交易收益纍加總計;
                # print(training_result["Long_Position_profit_Positive"])  # 每兩次對衝交易收益纍加總計;
                # print(training_result["Short_Selling_profit_Positive"])  # 每兩次對衝交易收益纍加總計;
                # print(training_result["profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
                # print(training_result["Long_Position_profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
                # print(training_result["Short_Selling_profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
                # print(training_result["profit_Negative"])  # 每兩次對衝交易損失纍加總計;
                # print(training_result["Long_Position_profit_Negative"])  # 每兩次對衝交易損失纍加總計;
                # print(training_result["Short_Selling_profit_Negative"])  # 每兩次對衝交易損失纍加總計;
                # print(training_result["profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
                # print(training_result["Long_Position_profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
                # print(training_result["Short_Selling_profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
                # print(training_result["Long_Position_profit_date_transaction"])  # 每兩次對衝交易利潤，向量;
                # print(training_result["Short_Selling_profit_date_transaction"])  # 每兩次對衝交易利潤，向量;
                # print("maximum_drawdown = ", training_result["maximum_drawdown"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # print("maximum_drawdown_Long_Position = ", training_result["maximum_drawdown_Long_Position"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # print("maximum_drawdown_Short_Selling = ", training_result["maximum_drawdown_Short_Selling"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # print("Long_Position_drawdown_date_transaction = ", training_result["Long_Position_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # print("Short_Selling_drawdown_date_transaction = ", training_result["Short_Selling_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # print(training_result["average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # print(training_result["Long_Position_average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # print(training_result["Short_Selling_average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # print(training_result["Long_Position_price_amplitude_date_transaction"])  # 兩次對衝交易日成交價振幅平方和，向量;
                # print(training_result["Short_Selling_price_amplitude_date_transaction"])  # 兩次對衝交易日成交價振幅平方和，向量;
                # print(training_result["average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
                # print(training_result["Long_Position_average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
                # print(training_result["Short_Selling_average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
                # print(training_result["Long_Position_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）向量;
                # print(training_result["Short_Selling_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）向量;
                # print(training_result["average_date_transaction_between"])  # 兩次交易間隔日長，均值;
                # print(training_result["Long_Position_average_date_transaction_between"])  # 兩次對衝交易間隔日長，均值;
                # print(training_result["Short_Selling_average_date_transaction_between"])  # 兩次對衝交易間隔日長，均值;
                # print(training_result["Long_Position_date_transaction_between"])  # 兩次對衝交易間隔日長，向量;
                # print(training_result["Short_Selling_date_transaction_between"])  # 兩次對衝交易間隔日長，向量;
                # print(training_result["Long_Position_date_transaction"])  # 按規則執行交易的日期，向量;
                # print(training_result["Long_Position_date_transaction"][0])  # 交易規則自動選取的交易日期;
                # print(training_result["Long_Position_date_transaction"][1])  # 交易規則自動選取的買入或賣出;
                # print(training_result["Long_Position_date_transaction"][2])  # 交易規則自動選取的成交價;
                # print(training_result["Long_Position_date_transaction"][3])  # 交易規則自動選取的成交量;
                # print(training_result["Long_Position_date_transaction"][4])  # 交易規則自動選取的成交次數記錄;
                # print(training_result["Long_Position_date_transaction"][5])  # 交易規則自動選取的交易日期的序列號，用於繪圖可視化;
                # print(training_result["Long_Position_date_transaction"][6])  # 交易日（datetime.date 類型）;
                # print(training_result["Long_Position_date_transaction"][7])  # 當日總成交量（turnover volume）;
                # print(training_result["Long_Position_date_transaction"][8])  # 當日開盤（opening）成交價;
                # print(training_result["Long_Position_date_transaction"][9])  # 當日收盤（closing）成交價;
                # print(training_result["Long_Position_date_transaction"][10])  # 當日最低（low）成交價;
                # print(training_result["Long_Position_date_transaction"][11])  # 當日最高（high）成交價;
                # print(training_result["Long_Position_date_transaction"][12])  # 當日總成交金額（turnover amount）;
                # print(training_result["Long_Position_date_transaction"][13])  # 當日成交量（turnover volume）換手率（turnover rate）;
                # print(training_result["Long_Position_date_transaction"][14])  # 當日每股收益（price earnings）;
                # print(training_result["Long_Position_date_transaction"][15])  # 當日每股净值（book value per share）;
                # print(training_result["Short_Selling_date_transaction"])  # 按規則執行交易的日期，向量;
                # print(training_result["Short_Selling_date_transaction"][0])  # 交易規則自動選取的交易日期;
                # print(training_result["Short_Selling_date_transaction"][1])  # 交易規則自動選取的買入或賣出;
                # print(training_result["Short_Selling_date_transaction"][2])  # 交易規則自動選取的成交價;
                # print(training_result["Short_Selling_date_transaction"][3])  # 交易規則自動選取的成交量;
                # print(training_result["Short_Selling_date_transaction"][4])  # 交易規則自動選取的成交次數記錄;
                # print(training_result["Short_Selling_date_transaction"][5])  # 交易規則自動選取的交易日期的序列號，用於繪圖可視化;
                # print(training_result["Short_Selling_date_transaction"][6])  # 交易日（datetime.date 類型）;
                # print(training_result["Short_Selling_date_transaction"][7])  # 當日總成交量（turnover volume）;
                # print(training_result["Short_Selling_date_transaction"][8])  # 當日開盤（opening）成交價;
                # print(training_result["Short_Selling_date_transaction"][9])  # 當日收盤（closing）成交價;
                # print(training_result["Short_Selling_date_transaction"][10])  # 當日最低（low）成交價;
                # print(training_result["Short_Selling_date_transaction"][11])  # 當日最高（high）成交價;
                # print(training_result["Short_Selling_date_transaction"][12])  # 當日總成交金額（turnover amount）;
                # print(training_result["Short_Selling_date_transaction"][13])  # 當日成交量（turnover volume）換手率（turnover rate）;
                # print(training_result["Short_Selling_date_transaction"][14])  # 當日每股收益（price earnings）;
                # print(training_result["Short_Selling_date_transaction"][15])  # 當日每股净值（book value per share）;
                # print(training_result["revenue_and_expenditure_records_date_transaction"])  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
                # print(training_result["P1_Array"])  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;

                # P1_Array = training_result["P1_Array"]  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;

                # y_profit = training_result["y_Long_Position_profit"]  # 優化目標變量，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
                # y_profit = training_result["y_Short_Selling_profit"]  # 優化目標變量，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
                y_profit = training_result["y_profit"]  # 優化目標變量，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
                # y_loss = training_result["y_Long_Position_loss"]  # 優化目標變量，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
                # y_loss = training_result["y_Short_Selling_loss"]  # 優化目標變量，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
                y_loss = training_result["y_loss"]  # 優化目標變量，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
                # y_total = training_result["profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # y_total_Long_Position = training_result["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # y_total_Short_Selling = training_result["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # y_Positive = training_result["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                # y_Positive_Long_Position = training_result["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                # y_Positive_Short_Selling = training_result["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
                # y_P_Positive = training_result["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                # y_P_Positive_Long_Position = training_result["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                # y_P_Positive_Short_Selling = training_result["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
                # y_Negative = training_result["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                # y_Negative_Long_Position = training_result["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                # y_Negative_Short_Selling = training_result["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
                # y_P_Negative = training_result["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                # y_P_Negative_Long_Position = training_result["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                # y_P_Negative_Short_Selling = training_result["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
                # y_A_Long_Position = training_result["Long_Position_profit_date_transaction"]  # 每兩次對衝交易利潤，向量;
                # y_A_Short_Selling = training_result["Short_Selling_profit_date_transaction"]  # 每兩次對衝交易利潤，向量;
                # y_maximum_drawdown = training_result["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # y_maximum_drawdown_Long_Position = training_result["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # y_maximum_drawdown_Short_Selling = training_result["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # y_H_Long_Position = training_result["Long_Position_drawdown_date_transaction"]  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # y_H_Short_Selling = training_result["Short_Selling_drawdown_date_transaction"]  # 向量，記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # y_amplitude = training_result["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # y_amplitude_Long_Position = training_result["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # y_amplitude_Short_Selling = training_result["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # y_D_Long_Position = training_result["Long_Position_price_amplitude_date_transaction"]  # 兩次對衝交易日成交價振幅平方和，向量;
                # y_D_Short_Selling = training_result["Short_Selling_price_amplitude_date_transaction"]  # 兩次對衝交易日成交價振幅平方和，向量;
                # y_turnover = training_result["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                # y_turnover_Long_Position = training_result["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                # y_turnover_Short_Selling = training_result["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
                # y_E_Long_Position = training_result["Long_Position_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）向量;
                # y_E_Short_Selling = training_result["Short_Selling_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）向量;
                # y_date_transaction_between = training_result["average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                # y_date_transaction_between_Long_Position = training_result["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                # y_date_transaction_between_Short_Selling = training_result["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
                # y_C_Long_Position = training_result["Long_Position_date_transaction_between"]  # 兩次對衝交易間隔日長，向量;
                # y_C_Short_Selling = training_result["Short_Selling_date_transaction_between"]  # 兩次對衝交易間隔日長，向量;
                # y_F_Long_Position = training_result["Long_Position_date_transaction"]  # 按規則執行交易的日期，向量;
                # y_F_Short_Selling = training_result["Short_Selling_date_transaction"]  # 按規則執行交易的日期，向量;
                # y_G = training_result["revenue_and_expenditure_records_date_transaction"]  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;

            # 優化參數 P1, P2 的初始值，使用 push! 函數在數組末尾追加推入新元;
            if int(len(coefficient_from_fit)) == int(0):
                coefficient_from_fit.append(P1)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                coefficient_from_fit.append(P2)
                coefficient_from_fit.append(P3)
                coefficient_from_fit.append(P4)

            resultDict_ticker_symbol = {}
            # resultDict_ticker_symbol["test_profit"] = test_profit_estimate
            # resultDict_ticker_symbol["test_odds_ratio"] = test_odds_ratio_estimate
            # resultDict_ticker_symbol["test_date_transaction_between"] = test_date_transaction_between
            resultDict_ticker_symbol["Coefficient"] = coefficient_from_fit  # 擬合得到的參數解;
            # resultDict_ticker_symbol["Coefficient-StandardDeviation"] = margin_of_error  # 擬合得到的參數解的標準差;
            # resultDict_ticker_symbol["Coefficient-Confidence-Lower-95%"] = [confidence_inter[1][1], confidence_inter[2][1]]  # 擬合得到的參數解的區間估計下限;
            # resultDict_ticker_symbol["Coefficient-Confidence-Upper-95%"] = [confidence_inter[1][2], confidence_inter[2][2]]  # 擬合得到的參數解的區間估計上限;
            resultDict_ticker_symbol["Yfit"] = Yvals  # 擬合 y 值;
            resultDict_ticker_symbol["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower  # 擬合的應變量 Yvals 誤差下限;
            resultDict_ticker_symbol["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper  # 擬合的應變量 Yvals 誤差上限;
            # resultDict_ticker_symbol["Residual"] = Residual  # 擬合殘差;
            resultDict_ticker_symbol["P1_Array"] = training_result["P1_Array"]  # P1_Array  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
            resultDict_ticker_symbol["y_profit"] = training_result["y_profit"]  # 最優化目標值，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
            resultDict_ticker_symbol["y_Long_Position_profit"] = training_result["y_Long_Position_profit"]  # 最優化目標值，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
            resultDict_ticker_symbol["y_Short_Selling_profit"] = training_result["y_Short_Selling_profit"]  # 最優化目標值，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
            resultDict_ticker_symbol["y_loss"] = training_result["y_loss"]  # 最優化目標值，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
            resultDict_ticker_symbol["y_Long_Position_loss"] = training_result["y_Long_Position_loss"]  # 最優化目標值，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
            resultDict_ticker_symbol["y_Short_Selling_loss"] = training_result["y_Short_Selling_loss"]  # 最優化目標值，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
            resultDict_ticker_symbol["profit_total"] = training_result["profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
            resultDict_ticker_symbol["Long_Position_profit_total"] = training_result["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
            resultDict_ticker_symbol["Short_Selling_profit_total"] = training_result["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
            resultDict_ticker_symbol["profit_Positive"] = training_result["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            resultDict_ticker_symbol["Long_Position_profit_Positive"] = training_result["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            resultDict_ticker_symbol["Short_Selling_profit_Positive"] = training_result["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            resultDict_ticker_symbol["profit_Positive_probability"] = training_result["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            resultDict_ticker_symbol["Long_Position_profit_Positive_probability"] = training_result["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            resultDict_ticker_symbol["Short_Selling_profit_Positive_probability"] = training_result["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            resultDict_ticker_symbol["profit_Negative"] = training_result["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            resultDict_ticker_symbol["Long_Position_profit_Negative"] = training_result["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            resultDict_ticker_symbol["Short_Selling_profit_Negative"] = training_result["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            resultDict_ticker_symbol["profit_Negative_probability"] = training_result["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            resultDict_ticker_symbol["Long_Position_profit_Negative_probability"] = training_result["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            resultDict_ticker_symbol["Short_Selling_profit_Negative_probability"] = training_result["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            resultDict_ticker_symbol["Long_Position_profit_date_transaction"] = training_result["Long_Position_profit_date_transaction"]  # 每兩次對衝交易利潤，向量;
            resultDict_ticker_symbol["Short_Selling_profit_date_transaction"] = training_result["Short_Selling_profit_date_transaction"]  # 每兩次對衝交易利潤，向量;
            resultDict_ticker_symbol["maximum_drawdown"] = training_result["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            resultDict_ticker_symbol["maximum_drawdown_Long_Position"] = training_result["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            resultDict_ticker_symbol["maximum_drawdown_Short_Selling"] = training_result["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            resultDict_ticker_symbol["Long_Position_drawdown_date_transaction"] = training_result["Long_Position_drawdown_date_transaction"]  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
            resultDict_ticker_symbol["Short_Selling_drawdown_date_transaction"] = training_result["Short_Selling_drawdown_date_transaction"]  # 向量，記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
            resultDict_ticker_symbol["average_price_amplitude_date_transaction"] = training_result["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            resultDict_ticker_symbol["Long_Position_average_price_amplitude_date_transaction"] = training_result["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            resultDict_ticker_symbol["Short_Selling_average_price_amplitude_date_transaction"] = training_result["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            resultDict_ticker_symbol["Long_Position_price_amplitude_date_transaction"] = training_result["Long_Position_price_amplitude_date_transaction"]  # 兩次對衝交易日成交價振幅平方和，向量;
            resultDict_ticker_symbol["Short_Selling_price_amplitude_date_transaction"] = training_result["Short_Selling_price_amplitude_date_transaction"]  # 兩次對衝交易日成交價振幅平方和，向量;
            resultDict_ticker_symbol["average_volume_turnover_date_transaction"] = training_result["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            resultDict_ticker_symbol["Long_Position_average_volume_turnover_date_transaction"] = training_result["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            resultDict_ticker_symbol["Short_Selling_average_volume_turnover_date_transaction"] = training_result["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            resultDict_ticker_symbol["Long_Position_volume_turnover_date_transaction"] = training_result["Long_Position_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）向量;
            resultDict_ticker_symbol["Short_Selling_volume_turnover_date_transaction"] = training_result["Short_Selling_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）向量;
            resultDict_ticker_symbol["average_date_transaction_between"] = training_result["average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            resultDict_ticker_symbol["Long_Position_average_date_transaction_between"] = training_result["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            resultDict_ticker_symbol["Short_Selling_average_date_transaction_between"] = training_result["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            resultDict_ticker_symbol["Long_Position_date_transaction_between"] = training_result["Long_Position_date_transaction_between"]  # 兩次對衝交易間隔日長，向量;
            resultDict_ticker_symbol["Short_Selling_date_transaction_between"] = training_result["Short_Selling_date_transaction_between"]  # 兩次對衝交易間隔日長，向量;
            resultDict_ticker_symbol["Long_Position_date_transaction"] = training_result["Long_Position_date_transaction"]  # 按規則執行交易的日期，向量;
            resultDict_ticker_symbol["Short_Selling_date_transaction"] = training_result["Short_Selling_date_transaction"]  # 按規則執行交易的日期，向量;
            resultDict_ticker_symbol["revenue_and_expenditure_records_date_transaction"] = training_result["revenue_and_expenditure_records_date_transaction"]  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
            resultDict_ticker_symbol["weight_MarketTiming"] = training_result["weight_MarketTiming"]  # 擇時權重，每兩次對衝交易的盈利概率占比;
            # resultDict_ticker_symbol["testData"] = test_result  # 傳入測試數據集的計算結果;
            # resultDict_ticker_symbol["Curve-fit-image"] = img1  # 擬合曲綫繪圖;
            # resultDict_ticker_symbol["Residual-image"] = img2  # 擬合殘差繪圖;

            # resultDict = {}
            resultDict[key] = resultDict_ticker_symbol
            resultDict_ticker_symbol = None  # 釋放内存;

    # 讀取從函數參數傳入的測試數據集;
    # testing_date_transaction = []  # 測試集數據交易日期;
    # testing_opening_price = []  # 測試集數據交易日首筆成交價（開盤價）;
    # testing_close_price = []  # 測試集數據交易日尾筆成交價（收盤價）;
    # testing_low_price = []  # 測試集數據交易日最低成交價;
    # testing_high_price = []  # 測試集數據交易日最高成交價;
    # testing_turnover_volume = []  # 測試集數據交易日總成交量;
    # testing_turnover_amount = []  # 測試集數據交易日總成交金額;
    # testing_turnover_rate = []  # 測試集數據交易日換手率;
    # testing_price_earnings = []  # 測試集數據市盈率;
    # testing_book_value_per_share = []  # 測試集數據净值;
    testData = {}
    if isinstance(testing_data, dict) and int(len(testing_data)) > int(0):

        testData = testing_data

        # if "date_transaction" in testing_data and int(len(testing_data["date_transaction"])) > int(0):
        #     testing_date_transaction = testing_data["date_transaction"]
        # if "turnover_volume" in testing_data and int(len(testing_data["turnover_volume"])) > int(0):
        #     testing_turnover_volume = testing_data["turnover_volume"]
        # if "turnover_amount" in testing_data and int(len(testing_data["turnover_amount"])) > int(0):
        #     testing_turnover_amount = testing_data["turnover_amount"]
        # if "opening_price" in testing_data and int(len(testing_data["opening_price"])) > int(0):
        #     testing_opening_price = testing_data["opening_price"]
        # if "close_price" in testing_data and int(len(testing_data["close_price"])) > int(0):
        #     testing_close_price = testing_data["close_price"]
        # if "low_price" in testing_data and int(len(testing_data["low_price"])) > int(0):
        #     testing_low_price = testing_data["low_price"]
        # if "high_price" in testing_data and int(len(testing_data["high_price"])) > int(0):
        #     testing_high_price = testing_data["high_price"]
        # if "turnover_rate" in testing_data and int(len(testing_data["turnover_rate"])) > int(0):
        #     testing_turnover_rate = testing_data["turnover_rate"]
        # if "price_earnings" in testing_data and int(len(testing_data["price_earnings"])) > int(0):
        #     testing_price_earnings = testing_data["price_earnings"]
        # if "book_value_per_share" in testing_data and int(len(testing_data["book_value_per_share"])) > int(0):
        #     testing_book_value_per_share = testing_data["book_value_per_share"]

        # # 遍歷字典的鍵:值對;
        # for key, value in testing_data.items():
        #     # print("Key: {key}, Value: {value}")

        #     # date_i = str(key)
        #     # date_i = datetime.datetime.strptime(date_i, "%Y-%m-%d").date()  # 將日期字符串，轉換爲日期對象;  # datetime.datetime.strptime(str(str(str(date_i).replace("/", "-")).strip()), "%Y-%m-%d").date()
        #     # # if isinstance(key, str):
        #     # #     # key == "" # str(key).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     # #     date_i = key;
        #     # #     # date_i = str(key)
        #     # #     date_i = datetime.datetime.strptime(date_i, "%Y-%m-%d").date()
        #     # # elif isinstance(key, int):
        #     # #     # date_i = int(key)
        #     # #     # the_Unix_time = now_day.timestamp()  # 1723177781.518 seconds  # 轉換爲時間戳;
        #     # #     # the_date_time = datetime.datetime.fromtimestamp(the_Unix_time)  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
        #     # #     date_i = datetime.datetime.fromtimestamp(key)  # 將時間戳轉換爲時間對象;
        #     # # elif isinstance(key, datetime.date):
        #     # #     date_i = key
        #     # # # else:
        #     # testing_date_transaction.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     # if isinstance(value, dict) and int(len(value)) > int(0):
        #     #     for key_1, value_1 in value.items():
        #     #         if str(key_1) == str("turnover_volume"):
        #     #             date_i = value_1
        #     #             # if value_1 is None:
        #     #             #     date_i = None
        #     #             # elif isinstance(value_1, str) and value_1 == "":
        #     #             #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #             #     date_i = str("")
        #     #             # # elif isinstance(value_1, int):
        #     #             # #     date_i = int(value_1)
        #     #             # else:
        #     #             #     date_i = value_1
        #     #             testing_turnover_volume.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #         if str(key_1) == str("turnover_amount"):
        #     #             date_i = value_1
        #     #             # if value_1 is None:
        #     #             #     date_i = None
        #     #             # elif isinstance(value_1, str) and value_1 == "":
        #     #             #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #             #     date_i = str("")
        #     #             # # elif isinstance(value_1, float):
        #     #             # #     date_i = float(value_1)
        #     #             # else:
        #     #             #     date_i = value_1
        #     #             testing_turnover_amount.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #         if str(key_1) == str("opening_price"):
        #     #             date_i = value_1
        #     #             # if value_1 is None:
        #     #             #     date_i = None
        #     #             # elif isinstance(value_1, str) and value_1 == "":
        #     #             #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #             #     date_i = str("")
        #     #             # # elif isinstance(value_1, float):
        #     #             # #     date_i = float(value_1)
        #     #             # else:
        #     #             #     date_i = value_1
        #     #             testing_opening_price.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        #     # if str(key) == str("date_transaction"):
        #     #     testing_date_transaction = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")  # str(value[i])
        #     #     #         # # elif isinstance(value_1, int):
        #     #     #         # #     # date_i = int(value[i])
        #     #     #         # #     # the_Unix_time = now_day.timestamp()  # 1723177781.518 seconds  # 轉換爲時間戳;
        #     #     #         # #     # the_date_time = datetime.datetime.fromtimestamp(the_Unix_time)  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
        #     #     #         # #     date_i = datetime.datetime.fromtimestamp(value[i])  # 將時間戳轉換爲時間對象;
        #     #     #         # # elif isinstance(key, datetime.date):
        #     #     #         # #     date_i = value[i]
        #     #     #         # #     # date_i = datetime.datetime.strptime(value[i], "%Y-%m-%d").date()
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         testing_date_transaction.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     testing_date_transaction = value
        #     # if str(key) == str("turnover_volume"):
        #     #     testing_turnover_volume = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")
        #     #     #         # # elif isinstance(value_1, int):
        #     #     #         # #     # date_i = int(value[i])
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         testing_turnover_volume.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     testing_turnover_volume = value
        #     # if str(key) == str("turnover_amount"):
        #     #     testing_turnover_amount = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")
        #     #     #         # # elif isinstance(value[i], float):
        #     #     #         # #     date_i = float(value[i])
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         testing_turnover_amount.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     testing_turnover_amount = value
        #     # if str(key) == str("opening_price"):
        #     #     testing_opening_price = value
        #     #     # if isinstance(value, list) and int(len(value)) > int(0):
        #     #     #     for i in range(int(0), int(len(value)), int(1)):
        #     #     #         date_i = value[i]
        #     #     #         # if value[i] is None:
        #     #     #         #     date_i = None
        #     #     #         # elif isinstance(value[i], str) and value[i] == "":
        #     #     #         #     # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
        #     #     #         #     date_i = str("")
        #     #     #         # # elif isinstance(value[i], float):
        #     #     #         # #     date_i = float(value[i])
        #     #     #         # else:
        #     #     #         #     date_i = value[i]
        #     #     #         testing_opening_price.append(date_i)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        #     #     # else:
        #     #     #     testing_opening_price = value
    # print(testData);

    # 計算測試集日棒缐（K Line Daily）數據本徵（characteristic）;
    if isinstance(testData, dict) and int(len(testData)) > int(0):

        # 求解各股票裏的最長交易天數;
        maximum_dates_transaction_test = int(0)
        for key, value in testData.items():
            # print("Key: {key}, Value: {value}")
            if isinstance(value, dict):
                if "date_transaction" in value and isinstance(value["date_transaction"], list):
                    if int(len(value["date_transaction"])) > int(maximum_dates_transaction_test):
                        maximum_dates_transaction_test_2 = int(len(value["date_transaction"]))
                        maximum_dates_transaction_test *= int(0)
                        maximum_dates_transaction_test += int(maximum_dates_transaction_test_2)
                if "turnover_volume" in value and isinstance(value["turnover_volume"], list):
                    if int(len(value["turnover_volume"])) > int(maximum_dates_transaction_test):
                        maximum_dates_transaction_test_2 = int(len(value["turnover_volume"]))
                        maximum_dates_transaction_test *= int(0)
                        maximum_dates_transaction_test += int(maximum_dates_transaction_test_2)
                if "opening_price" in value and isinstance(value["opening_price"], list):
                    if int(len(value["opening_price"])) > int(maximum_dates_transaction_test):
                        maximum_dates_transaction_test_2 = int(len(value["opening_price"]))
                        maximum_dates_transaction_test *= int(0)
                        maximum_dates_transaction_test += int(maximum_dates_transaction_test_2)
                if "close_price" in value and isinstance(value["close_price"], list):
                    if int(len(value["close_price"])) > int(maximum_dates_transaction_test):
                        maximum_dates_transaction_test_2 = int(len(value["close_price"]))
                        maximum_dates_transaction_test *= int(0)
                        maximum_dates_transaction_test += int(maximum_dates_transaction_test_2)
                if "low_price" in value and isinstance(value["low_price"], list):
                    if int(len(value["low_price"])) > int(maximum_dates_transaction_test):
                        maximum_dates_transaction_test_2 = int(len(value["low_price"]))
                        maximum_dates_transaction_test *= int(0)
                        maximum_dates_transaction_test += int(maximum_dates_transaction_test_2)
                if "high_price" in value and isinstance(value["high_price"], list):
                    if int(len(value["high_price"])) > int(maximum_dates_transaction_test):
                        maximum_dates_transaction_test_2 = int(len(value["high_price"]))
                        maximum_dates_transaction_test *= int(0)
                        maximum_dates_transaction_test += int(maximum_dates_transaction_test_2)
        # print(maximum_dates_transaction_test)

        for key, value in testData.items():

            # 計算測試集日棒缐（K Line Daily）數據本徵（characteristic）;
            testing_focus = []  # 日棒缐（K Line Daily）數據的重心值（Focus）;
            testing_amplitude = []  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
            testing_amplitude_rate = []  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
            testing_opening_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
            testing_closing_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
            testing_low_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日最低成交價標準化;
            testing_high_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日最高成交價標準化;
            testing_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
            testing_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
            testing_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
            testing_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
            testing_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
            testing_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;
            if isinstance(value, dict) and int(len(value)) > int(0):

                # if (isinstance(testing_turnover_volume, list) and int(len(testing_turnover_volume)) > int(0)) and (isinstance(testing_opening_price, list) and int(len(testing_opening_price)) > int(0)) and (isinstance(testing_close_price, list) and int(len(testing_close_price)) > int(0)) and (isinstance(testing_low_price, list) and int(len(testing_low_price)) > int(0)) and (isinstance(testing_high_price, list) and int(len(testing_high_price)) > int(0)):
                if ("turnover_volume" in value and isinstance(value["turnover_volume"], list) and int(len(value["turnover_volume"])) > int(0)) and ("opening_price" in value and isinstance(value["opening_price"], list) and int(len(value["opening_price"])) > int(0)) and ("close_price" in value and isinstance(value["close_price"], list) and int(len(value["close_price"])) > int(0)) and ("low_price" in value and isinstance(value["low_price"], list) and int(len(value["low_price"])) > int(0)) and ("high_price" in value and isinstance(value["high_price"], list) and int(len(value["high_price"])) > int(0)):

                    # 計算測試集日棒缐（K Line Daily）數據的最少數目（minimum count time series）;
                    # testing_minimum_count_time_series = int(0)
                    # testing_minimum_count_time_series = (+math.inf)
                    testing_minimum_count_time_series = int(min([int(len(value["turnover_volume"])), int(len(value["opening_price"])), int(len(value["close_price"])), int(len(value["low_price"])), int(len(value["high_price"]))]))
                    # testing_minimum_count_time_series = int(min([int(len(testing_turnover_volume)), int(len(testing_opening_price)), int(len(testing_close_price)), int(len(testing_low_price)), int(len(testing_high_price))]))

                    if int(testing_minimum_count_time_series) > int(0):

                        # 計算測試集日棒缐（K Line Daily）數據本徵（characteristic）;
                        # testing_focus = []  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                        # testing_amplitude = []  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                        # testing_amplitude_rate = []  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                        # testing_opening_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                        # testing_closing_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                        # testing_low_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                        # testing_high_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                        # testing_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
                        # testing_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                        # testing_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                        # testing_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                        # testing_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                        # testing_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;
                        # for i in range(int(0), int(len(value["opening_price"])), int(1)):
                        # for i in range(int(0), int(len(testing_opening_price)), int(1)):
                        for i in range(int(0), int(testing_minimum_count_time_series), int(1)):

                            # 計算日棒缐（K Line Daily）數據的重心值（Focus）序列;
                            date_i_focus = numpy.mean([value["opening_price"][i], value["close_price"][i], value["low_price"][i], value["high_price"][i]])
                            date_i_focus = float(date_i_focus)
                            testing_focus.append(date_i_focus)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）序列;
                            date_i_amplitude = numpy.std(
                                [
                                    value["opening_price"][i],
                                    value["close_price"][i],
                                    value["low_price"][i],
                                    value["high_price"][i]
                                ],
                                ddof = 1
                            )
                            # if int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) == int(1):
                            #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]])
                            # elif int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) > int(1):
                            #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]], ddof = 1)
                            # # else:
                            date_i_amplitude = float(date_i_amplitude)
                            testing_amplitude.append(date_i_amplitude)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）序列;
                            date_i_amplitude_rate = float(date_i_amplitude)  # numpy.nan  # None  # +math.inf
                            if float(date_i_focus) == float(0.0):
                                date_i_amplitude_rate = (+math.inf)  # float(date_i_amplitude)
                            else:
                                date_i_amplitude_rate = float(date_i_amplitude / date_i_focus)
                            testing_amplitude_rate.append(date_i_amplitude_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 測試集日棒缐（K Line Daily）數據標準化（Standardization）轉換;
                            # testing_opening_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                            # testing_closing_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                            # testing_low_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                            # testing_high_price_Standardization = []  # 測試集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                            date_i_opening_price_Standardization = value["opening_price"][i]
                            date_i_closing_price_Standardization = value["close_price"][i]
                            date_i_low_price_Standardization = value["low_price"][i]
                            date_i_high_price_Standardization = value["high_price"][i]
                            if float(value["amplitude"][i]) == float(0.0):
                                date_i_opening_price_Standardization = float(value["opening_price"][i] - value["focus"][i])
                                date_i_closing_price_Standardization = float(value["close_price"][i] - value["focus"][i])
                                date_i_low_price_Standardization = float(value["low_price"][i] - value["focus"][i])
                                date_i_high_price_Standardization = float(value["high_price"][i] - value["focus"][i])
                            else:
                                date_i_opening_price_Standardization = float((value["opening_price"][i] - value["focus"][i]) / value["amplitude"][i])
                                date_i_closing_price_Standardization = float((value["close_price"][i] - value["focus"][i]) / value["amplitude"][i])
                                date_i_low_price_Standardization = float((value["low_price"][i] - value["focus"][i]) / value["amplitude"][i])
                                date_i_high_price_Standardization = float((value["high_price"][i] - value["focus"][i]) / value["amplitude"][i])
                            testing_opening_price_Standardization.append(date_i_opening_price_Standardization)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                            testing_closing_price_Standardization.append(date_i_closing_price_Standardization)
                            testing_low_price_Standardization.append(date_i_low_price_Standardization)
                            testing_high_price_Standardization.append(date_i_high_price_Standardization)

                            # 計算相鄰兩個交易日之間成交股票數量的變化率值的序列，並保存入 1 維數組;
                            # testing_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值; x_growth_rate = numpy.nan
                            if int(int(i) + int(1)) < int(2):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            else:
                                if int(value["turnover_volume"][i - 1]) != int(0):
                                    x_growth_rate = float(value["turnover_volume"][i] / value["turnover_volume"][i - 1]) - float(1.0)
                                elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) == int(0):
                                    x_growth_rate = float(0.0)
                                    # x_growth_rate = numpy.nan
                                elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) > int(0):
                                    x_growth_rate = (+math.inf)
                                elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) < int(0):
                                    x_growth_rate = (-math.inf)
                                # else:
                            # print(x_growth_rate)
                            testing_turnover_volume_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算相鄰兩個交易日之間開盤股票價格的變化率值的序列，並保存入 1 維數組;
                            # testing_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                            x_growth_rate = numpy.nan
                            if int(int(i) + int(1)) < int(2):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            else:
                                if float(value["opening_price"][i - 1]) != float(0.0):
                                    x_growth_rate = float(value["opening_price"][i] / value["opening_price"][i - 1]) - float(1.0)
                                elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) == float(0.0):
                                    x_growth_rate = float(0.0)
                                    # x_growth_rate = numpy.nan
                                elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) > float(0.0):
                                    x_growth_rate = (+math.inf)
                                elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) < float(0.0):
                                    x_growth_rate = (-math.inf)
                                # else:
                            # print(x_growth_rate)
                            testing_opening_price_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算相鄰兩個交易日之間收盤股票價格的變化率值的序列，並保存入 1 維數組;
                            # testing_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                            x_growth_rate = numpy.nan
                            if int(int(i) + int(1)) < int(2):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            else:
                                if float(value["close_price"][i - 1]) != float(0.0):
                                    x_growth_rate = float(value["close_price"][i] / value["close_price"][i - 1]) - float(1.0)
                                elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) == float(0.0):
                                    x_growth_rate = float(0.0)
                                    # x_growth_rate = numpy.nan
                                elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) > float(0.0):
                                    x_growth_rate = (+math.inf)
                                elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) < float(0.0):
                                    x_growth_rate = (-math.inf)
                                # else:
                            # print(x_growth_rate)
                            testing_closing_price_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算每個交易日股票收盤價格減去開盤價格的變化率值的序列，並保存入 1 維數組;
                            # testing_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                            x_growth_rate = numpy.nan
                            if float(value["opening_price"][i]) != float(0.0):
                                x_growth_rate = float(value["close_price"][i] / value["opening_price"][i]) - float(1.0)
                            elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) == float(0.0):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) > float(0.0):
                                x_growth_rate = (+math.inf)
                            elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) < float(0.0):
                                x_growth_rate = (-math.inf)
                            # else:
                            # print(x_growth_rate)
                            testing_closing_minus_opening_price_growth_rate.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列，並保存入 1 維數組;
                            # testing_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                            x_growth_rate = numpy.nan
                            if float(value["high_price"][i]) != float(0.0):
                                x_growth_rate = float(max([value["opening_price"][i], value["close_price"][i]])) / float(value["high_price"][i])
                            elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) == float(0.0):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) > float(0.0):
                                x_growth_rate = (+math.inf)
                            elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) < float(0.0):
                                x_growth_rate = (-math.inf)
                            # else:
                            # print(x_growth_rate)
                            testing_high_price_proportion.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                            # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列，並保存入 1 維數組;
                            # testing_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;
                            x_growth_rate = numpy.nan
                            if float(min([value["opening_price"][i], value["close_price"][i]])) != float(0.0):
                                x_growth_rate = float(value["low_price"][i]) / float(min([value["opening_price"][i], value["close_price"][i]]))
                            elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) == float(0.0):
                                x_growth_rate = float(0.0)
                                # x_growth_rate = numpy.nan
                            elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) > float(0.0):
                                x_growth_rate = (+math.inf)
                            elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) < float(0.0):
                                x_growth_rate = (-math.inf)
                            # else:
                            # print(x_growth_rate)
                            testing_low_price_proportion.append(x_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                        # testData[key]["focus"] = testing_focus
                        # testData[key]["amplitude"] = testing_amplitude
                        # testData[key]["amplitude_rate"] = testing_amplitude_rate
                        # testData[key]["opening_price_Standardization"] = testing_opening_price_Standardization
                        # testData[key]["closing_price_Standardization"] = testing_closing_price_Standardization
                        # testData[key]["low_price_Standardization"] = testing_low_price_Standardization
                        # testData[key]["high_price_Standardization"] = testing_high_price_Standardization
                        # testData[key]["turnover_volume_growth_rate"] = testing_turnover_volume_growth_rate
                        # testData[key]["opening_price_growth_rate"] = testing_opening_price_growth_rate
                        # testData[key]["closing_price_growth_rate"] = testing_closing_price_growth_rate
                        # testData[key]["closing_minus_opening_price_growth_rate"] = testing_closing_minus_opening_price_growth_rate
                        # testData[key]["high_price_proportion"] = testing_high_price_proportion
                        # testData[key]["low_price_proportion"] = testing_low_price_proportion
                        # # 釋放内存;
                        # testing_focus = None
                        # testing_amplitude = None
                        # testing_amplitude_rate = None
                        # testing_opening_price_Standardization = None
                        # testing_closing_price_Standardization = None
                        # testing_low_price_Standardization = None
                        # testing_high_price_Standardization = None
                        # testing_turnover_volume_growth_rate = None
                        # testing_opening_price_growth_rate = None
                        # testing_closing_price_growth_rate = None
                        # testing_closing_minus_opening_price_growth_rate = None
                        # testing_high_price_proportion = None
                        # testing_low_price_proportion = None

                # 從 testData 讀出;
                if "focus" in value and isinstance(value["focus"], list):
                    testing_focus = value["focus"]  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                if "amplitude" in value and isinstance(value["amplitude"], list):
                    testing_amplitude = value["amplitude"]  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                if "amplitude_rate" in value and isinstance(value["amplitude_rate"], list):
                    testing_amplitude_rate = value["amplitude_rate"]  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                if "opening_price_Standardization" in value and isinstance(value["opening_price_Standardization"], list):
                    testing_opening_price_Standardization = value["opening_price_Standardization"]  # 測試集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                if "closing_price_Standardization" in value and isinstance(value["closing_price_Standardization"], list):
                    testing_closing_price_Standardization = value["closing_price_Standardization"]  # 測試集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                if "low_price_Standardization" in value and isinstance(value["low_price_Standardization"], list):
                    testing_low_price_Standardization = value["low_price_Standardization"]  # 測試集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                if "high_price_Standardization" in value and isinstance(value["high_price_Standardization"], list):
                    testing_high_price_Standardization = value["high_price_Standardization"]  # 測試集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                if "turnover_volume_growth_rate" in value and isinstance(value["turnover_volume_growth_rate"], list):
                    testing_turnover_volume_growth_rate = value["turnover_volume_growth_rate"]  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
                if "opening_price_growth_rate" in value and isinstance(value["opening_price_growth_rate"], list):
                    testing_opening_price_growth_rate = value["opening_price_growth_rate"]  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                if "closing_price_growth_rate" in value and isinstance(value["closing_price_growth_rate"], list):
                    testing_closing_price_growth_rate = value["closing_price_growth_rate"]  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                if "closing_minus_opening_price_growth_rate" in value and isinstance(value["closing_minus_opening_price_growth_rate"], list):
                    testing_closing_minus_opening_price_growth_rate = value["closing_minus_opening_price_growth_rate"]  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                if "high_price_proportion" in value and isinstance(value["high_price_proportion"], list):
                    testing_high_price_proportion = value["high_price_proportion"]  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                if "low_price_proportion" in value and isinstance(value["low_price_proportion"], list):
                    testing_low_price_proportion = value["low_price_proportion"]  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;

                # # 向 testData 寫入;
                # if not ("focus" in value):
                #     testData[key]["focus"] = testing_focus  # 日棒缐（K Line Daily）數據的重心值（Focus）;
                # if not ("amplitude" in value):
                #     testData[key]["amplitude"] = testing_amplitude  # 日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                # if not ("amplitude_rate" in value):
                #     testData[key]["amplitude_rate"] = testing_amplitude_rate  # 日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                # if not ("opening_price_Standardization" in value):
                #     testData[key]["opening_price_Standardization"] = testing_opening_price_Standardization  # 測試集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                # if not ("closing_price_Standardization" in value):
                #     testData[key]["closing_price_Standardization"] = testing_closing_price_Standardization  # 測試集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                # if not ("low_price_Standardization" in value):
                #     testData[key]["low_price_Standardization"] = testing_low_price_Standardization  # 測試集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                # if not ("high_price_Standardization" in value):
                #     testData[key]["high_price_Standardization"] = testing_high_price_Standardization  # 測試集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                # if not ("turnover_volume_growth_rate" in value):
                #     testData[key]["turnover_volume_growth_rate"] = testing_turnover_volume_growth_rate  # 計算相鄰兩個交易日之間成交股票數量的變化率值;
                # if not ("opening_price_growth_rate" in value):
                #     testData[key]["opening_price_growth_rate"] = testing_opening_price_growth_rate  # 計算相鄰兩個交易日之間開盤股票價格的變化率值;
                # if not ("closing_price_growth_rate" in value):
                #     testData[key]["closing_price_growth_rate"] = testing_closing_price_growth_rate  # 計算相鄰兩個交易日之間收盤股票價格的變化率值;
                # if not ("closing_minus_opening_price_growth_rate" in value):
                #     testData[key]["closing_minus_opening_price_growth_rate"] = testing_closing_minus_opening_price_growth_rate  # 計算每個交易日股票收盤價格減去開盤價格的變化率值;
                # if not ("high_price_proportion" in value):
                #     testData[key]["high_price_proportion"] = testing_high_price_proportion  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值;
                # if not ("low_price_proportion" in value):
                #     testData[key]["low_price_proportion"] = testing_low_price_proportion  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值;

            # y = Base.log(x);  # 對數函數，返回以 e 爲底 x 的對數;
            # y = math.exp(x)  # 指數函數，返回 e 的 x 次冪;
            # y = math.pow(x, 2)  # 冪函數，返回 x 的 2 次方;
            # min([2, 1, 0, -1, -2])  # 求最小值;
            # max([-2, -1, 0, 1, 2])  # 求最大值;

            YdataMean = testing_focus
            YdataSTD = testing_amplitude_rate  # testing_amplitude
            Xdata = [int(int(i) + int(1)) for i in range(int(0), int(len(YdataMean)), int(1))]
            if isinstance(testing_focus, list) and isinstance(testing_amplitude, list) and isinstance(testing_amplitude_rate, list):
                # 觀測值（Observation）;
                # 求 Ydata 均值向量;
                YdataMean = testing_focus
                # YdataMean = []
                # for i in range(int(0), int(len(Ydata)), int(1)):
                #     if isinstance(Ydata[i], list):
                #         yMean = float(numpy.mean(Ydata[i]))
                #         YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #     else:
                #         yMean = float(Ydata[i])
                #         YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # print(YdataMean)
                # # 求 Ydata 標準差向量;
                # YdataSTD = testing_amplitude
                # # YdataSTD = []
                # # for i in range(int(0), int(len(Ydata)), int(1)):
                # #     if isinstance(Ydata[i], list):
                # #         if int(len(Ydata[i])) == int(1):
                # #             ySTD = float(numpy.std(Ydata[i]))
                # #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # #         elif int(len(Ydata[i])) > int(1):
                # #             ySTD = float(numpy.std(Ydata[i], ddof = 1))
                # #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # #     else:
                # #         ySTD = float(0.0)
                # #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # 求 Ydata 變異係數（與重心比較的相對標準差）向量;
                YdataSTD = testing_amplitude_rate
                # YdataSTD = []
                # for i in range(int(0), int(len(Ydata)), int(1)):
                #     if isinstance(Ydata[i], list):
                #         if int(len(Ydata[i])) == int(1):
                #             ySTD = float(float(numpy.std(Ydata[i])) / float(numpy.mean(Ydata[i])))
                #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #         elif int(len(Ydata[i])) > int(1):
                #             ySTD = float(float(numpy.std(Ydata[i], ddof = 1)) / float(numpy.mean(Ydata[i])))
                #             YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                #     else:
                #         ySTD = float(0.0)
                #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # print(YdataSTD)
                # 求 Xdata 均值向量;
                Xdata = [int(int(i) + int(1)) for i in range(int(0), int(len(YdataMean)), int(1))]
                # Xdata = testing_date_transaction
                # Xdata = value["date_transaction"]
                # print(Xdata)

            # 擬合參數預設值（Parameter default）;
            if (isinstance(YdataMean, list) and int(len(YdataMean)) > int(0)) and (isinstance(YdataSTD, list) and int(len(YdataSTD)) > int(0)) and (isinstance(Xdata, list) and int(len(Xdata)) > int(0)):

                # 擬合參數（Parameter）;
                # 參數初始值（Initialization）;
                Pdata_0_P1 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        Pdata_0_P1_I = float(YdataMean[i] / Xdata[i]**3)
                    else:
                        Pdata_0_P1_I = float(YdataMean[i] - Xdata[i]**3)
                    Pdata_0_P1.append(Pdata_0_P1_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P1 = float(numpy.mean(Pdata_0_P1))
                # print(Pdata_0_P1)

                Pdata_0_P2 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        Pdata_0_P2_I = float(YdataMean[i] / Xdata[i]**2)
                    else:
                        Pdata_0_P2_I = float(YdataMean[i] - Xdata[i]**2)
                    Pdata_0_P2.append(Pdata_0_P2_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P2 = float(numpy.mean(Pdata_0_P2))
                # print(Pdata_0_P2)

                Pdata_0_P3 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        Pdata_0_P3_I = float(YdataMean[i] / Xdata[i]**1)
                    else:
                        Pdata_0_P3_I = float(YdataMean[i] - Xdata[i]**1)
                    Pdata_0_P3.append(Pdata_0_P3_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P3 = float(numpy.mean(Pdata_0_P3))
                # print(Pdata_0_P3)

                Pdata_0_P4 = []
                for i in range(int(0), int(len(YdataMean)), int(1)):
                    if float(Xdata[i]) != float(0.0):
                        # 符號 / 表示常規除法，符號 % 表示除法取餘，符號 ÷ 表示除法取整，符號 * 表示乘法，符號 ** 表示冪運算，符號 + 表示加法，符號 - 表示減法;
                        Pdata_0_P4_I_1 = float(float(YdataMean[i] % float(Pdata_0_P3 * Xdata[i]**1)) * float(Pdata_0_P3 * Xdata[i]**1))
                        Pdata_0_P4_I_2 = float(float(YdataMean[i] % float(Pdata_0_P2 * Xdata[i]**2)) * float(Pdata_0_P2 * Xdata[i]**2))
                        Pdata_0_P4_I_3 = float(float(YdataMean[i] % float(Pdata_0_P1 * Xdata[i]**3)) * float(Pdata_0_P1 * Xdata[i]**3))
                        Pdata_0_P4_I = float(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3)
                    else:
                        Pdata_0_P4_I = float(YdataMean[i] - Xdata[i])
                    Pdata_0_P4.append(Pdata_0_P4_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                Pdata_0_P4 = float(numpy.mean(Pdata_0_P4))
                # print(Pdata_0_P4)

                # Pdata_0 = []
                # Pdata_0 = [
                #     float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in 1:len(YdataMean)])),
                #     float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in 1:len(YdataMean)])),
                #     float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in 1:len(YdataMean)])),
                #     float(numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**1)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**1)) for i in range(int(0), int(len(YdataMean)), int(1))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**2)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**2)) for i in range(int(0), int(len(YdataMean)), int(1))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**3)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(int(0), int(len(YdataMean)), int(1))])) * Xdata[i]**3)) for i in range(int(0), int(len(YdataMean)), int(1))]))
                # ]
                if int(len(Pdata_0)) == int(0):
                    Pdata_0 = [
                        int(3),
                        float(+0.1),
                        float(-0.1),
                        float(0.0)
                    ]
                    # Pdata_0 = [
                    #     Pdata_0_P1,
                    #     Pdata_0_P2,
                    #     Pdata_0_P3,
                    #     Pdata_0_P4
                    # ]
                # print(Pdata_0)

                # # 參數值上下限;
                # # Plower = []
                # Plower = [
                #     -math.inf,  # P[1];
                #     -math.inf,  # P[2];
                #     -math.inf,  # P[3];
                #     -math.inf  # P[4];
                # ]
                # # print(Plower)
                # # Pupper = []
                # Pupper = [
                #     +math.inf,  # P[1];
                #     +math.inf,  # P[2];
                #     +math.inf,  # P[3];
                #     +math.inf  # P[4];
                # ]
                # # print(Pupper)

                # 變量實測值擬合權重;
                # # weight = []
                # # 使用高斯核賦權法;
                # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
                # af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
                # for i in range(int(0), int(len(YdataMean)), int(1)):
                #     wei = math.exp((YdataMean[i] / YdataMean[target] - 1)**2 / ((-2) * af**2))
                #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # # # 使用方差倒數值賦權法;
                # # for i in range(int(0), int(len(YdataSTD)), int(1)):
                # #     wei = 1 / YdataSTD[i]  # numpy.std(Ydata[i])  # numpy.var(Ydata[i])
                # #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                if int(len(weight)) == int(0):
                    weight = [float(1.0) for i in range(int(0), int(len(YdataMean)), int(1))]
                    # weight = [float(1.0 / YdataMean[i]) for i in range(int(0), int(len(YdataMean)), int(1))]  # 每日成交價振幅倒數;
                    # weight = [float(testing_turnover_rate[i]) for i in range(int(0), int(len(testing_turnover_rate)), int(1))]  # 每日成交量（換手率）;
                    # weight = [float(1.0 / y_C[i]) for i in range(int(0), int(len(y_C)), int(1))]  # 每次交易間隔日長的倒數;
                # print(weight)

                # testData[key]["Pdata_0"] = Pdata_0
                # testData[key]["Plower"] = Plower
                # testData[key]["Pupper"] = Pupper
                # testData[key]["weight"] = weight
                # # 釋放内存;
                # Pdata_0 = None
                # Plower = None
                # Pupper = None
                # weight = None


            # 測試集數據預測（Test Estimate）;
            test_profit_estimate = float(0.0)  # 預測收益;
            test_odds_ratio_estimate = float(0.0)  # 預測概率;
            test_date_transaction_between = float(0.0)  # 兩次交易間隔日長均值;
            # test_P1_Array = []  # 依照擇時規則計算得到參數 P1 值的序列，並保存入數組;
            test_result = {}
            if isinstance(value, dict) and int(len(value)) > int(0):
                # test_result = MarketTiming_f_fit_model(
                #     [
                #         {
                #             key: {
                #                 "date_transaction": value["date_transaction"],
                #                 "turnover_volume": value["turnover_volume"],
                #                 # "turnover_amount": value["turnover_amount"],
                #                 "opening_price": value["opening_price"],
                #                 "close_price": value["close_price"],
                #                 "low_price": value["low_price"],
                #                 "high_price": value["high_price"],
                #                 "focus": testing_focus,
                #                 "amplitude": testing_amplitude,
                #                 "amplitude_rate": testing_amplitude_rate,
                #                 "opening_price_Standardization": testing_opening_price_Standardization,
                #                 "closing_price_Standardization": testing_closing_price_Standardization,
                #                 "low_price_Standardization": testing_low_price_Standardization,
                #                 "high_price_Standardization": testing_high_price_Standardization,
                #                 "turnover_volume_growth_rate": testing_turnover_volume_growth_rate,
                #                 "opening_price_growth_rate": testing_opening_price_growth_rate,
                #                 "closing_price_growth_rate": testing_closing_price_growth_rate,
                #                 "closing_minus_opening_price_growth_rate": testing_closing_minus_opening_price_growth_rate,
                #                 "high_price_proportion": testing_high_price_proportion,
                #                 "low_price_proportion": testing_low_price_proportion
                #             }
                #         },
                #         Quantitative_Indicators_Function,
                #         investment_method
                #     ],
                #     [
                #         resultDict[key]["Coefficient"][0],
                #         resultDict[key]["Coefficient"][1],
                #         resultDict[key]["Coefficient"][2],
                #         resultDict[key]["Coefficient"][3]
                #     ]
                # )[key]
                test_result = MarketTiming_fit_model(
                    {
                        key: {
                            "date_transaction": value["date_transaction"],
                            "turnover_volume": value["turnover_volume"],
                            # "turnover_amount": value["turnover_amount"],
                            "opening_price": value["opening_price"],
                            "close_price": value["close_price"],
                            "low_price": value["low_price"],
                            "high_price": value["high_price"],
                            "focus": testing_focus,
                            "amplitude": testing_amplitude,
                            "amplitude_rate": testing_amplitude_rate,
                            "opening_price_Standardization": testing_opening_price_Standardization,
                            "closing_price_Standardization": testing_closing_price_Standardization,
                            "low_price_Standardization": testing_low_price_Standardization,
                            "high_price_Standardization": testing_high_price_Standardization,
                            "turnover_volume_growth_rate": testing_turnover_volume_growth_rate,
                            "opening_price_growth_rate": testing_opening_price_growth_rate,
                            "closing_price_growth_rate": testing_closing_price_growth_rate,
                            "closing_minus_opening_price_growth_rate": testing_closing_minus_opening_price_growth_rate,
                            "high_price_proportion": testing_high_price_proportion,
                            "low_price_proportion": testing_low_price_proportion
                        }
                    },
                    resultDict[key]["Coefficient"][0],
                    resultDict[key]["Coefficient"][1],
                    resultDict[key]["Coefficient"][2],
                    resultDict[key]["Coefficient"][3],
                    Quantitative_Indicators_Function,
                    investment_method
                )[key]
                # {
                #     "y_profit": y_profit,  # 優化目標變量，每兩次對衝交易利潤 × 權重，加權纍加總計;
                #     "y_Long_Position_profit": y_Long_Position_profit,  # 優化目標變量，做多（Long Position），每兩次對衝交易利潤 × 權重，加權纍加總計;
                #     "y_Short_Selling_profit": y_Short_Selling_profit,  # 優化目標變量，做空（Short Selling），每兩次對衝交易利潤 × 權重，加權纍加總計;
                #     "y_loss": y_loss,  # 優化目標變量，每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                #     "y_Long_Position_loss": y_Long_Position_loss,  # 優化目標變量，做多（Long Position），每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                #     "y_Short_Selling_loss": y_Short_Selling_loss,  # 優化目標變量，做空（Short Selling），每兩次對衝交易最大回撤 × 權重，加權纍加總計;
                #     "profit_total": y_total,  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                #     "Long_Position_profit_total": y_total_Long_Position,  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                #     "Short_Selling_profit_total": y_total_Short_Selling,  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                #     "profit_Positive": y_Positive,  # 每兩次對衝交易收益纍加總計;
                #     "Long_Position_profit_Positive": y_Positive_Long_Position,  # 每兩次對衝交易收益纍加總計;
                #     "Short_Selling_profit_Positive": y_Positive_Short_Selling,  # 每兩次對衝交易收益纍加總計;
                #     "profit_Positive_probability": y_P_Positive,  # 每兩次對衝交易正利潤概率;
                #     "Long_Position_profit_Positive_probability": y_P_Positive_Long_Position,  # 每兩次對衝交易正利潤概率;
                #     "Short_Selling_profit_Positive_probability": y_P_Positive_Short_Selling,  # 每兩次對衝交易正利潤概率;
                #     "profit_Negative": y_Negative,  # 每兩次對衝交易損失纍加總計;
                #     "Long_Position_profit_Negative": y_Negative_Long_Position,  # 每兩次對衝交易損失纍加總計;
                #     "Short_Selling_profit_Negative": y_Negative_Short_Selling,  # 每兩次對衝交易損失纍加總計;
                #     "profit_Negative_probability": y_P_Negative,  # 每兩次對衝交易負利潤概率;
                #     "Long_Position_profit_Negative_probability": y_P_Negative_Long_Position,  # 每兩次對衝交易負利潤概率;
                #     "Short_Selling_profit_Negative_probability": y_P_Negative_Short_Selling,  # 每兩次對衝交易負利潤概率;
                #     "Long_Position_profit_date_transaction": y_A_Long_Position,  # 每兩次對衝交易利潤，向量;
                #     "Short_Selling_profit_date_transaction": y_A_Short_Selling,  # 每兩次對衝交易利潤，向量;
                #     "maximum_drawdown": y_maximum_drawdown,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                #     "maximum_drawdown_Long_Position": y_maximum_drawdown_Long_Position,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                #     "maximum_drawdown_Short_Selling": y_maximum_drawdown_Short_Selling,  # 兩次對衝交易之間的最大回撤值，取極值統計;
                #     "Long_Position_drawdown_date_transaction": y_H_Long_Position,  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                #     "Short_Selling_drawdown_date_transaction": y_H_Short_Selling,  # 向量，記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                #     "average_price_amplitude_date_transaction": y_amplitude,  # 兩兩次對衝交易日成交價振幅平方和，均值;
                #     "Long_Position_average_price_amplitude_date_transaction": y_amplitude_Long_Position,  # 兩兩次對衝交易日成交價振幅平方和，均值;
                #     "Short_Selling_average_price_amplitude_date_transaction": y_amplitude_Short_Selling,  # 兩兩次對衝交易日成交價振幅平方和，均值;
                #     "Long_Position_price_amplitude_date_transaction": y_D_Long_Position,  # 兩次對衝交易日成交價振幅平方和，向量;
                #     "Short_Selling_price_amplitude_date_transaction": y_D_Short_Selling,  # 兩次對衝交易日成交價振幅平方和，向量;
                #     "average_volume_turnover_date_transaction": y_turnover,  # 兩次對衝交易日成交量（換手率）均值;
                #     "Long_Position_average_volume_turnover_date_transaction": y_turnover_Long_Position,  # 兩次對衝交易日成交量（換手率）均值;
                #     "Short_Selling_average_volume_turnover_date_transaction": y_turnover_Short_Selling,  # 兩次對衝交易日成交量（換手率）均值;
                #     "Long_Position_volume_turnover_date_transaction": y_E_Long_Position,  # 兩次對衝交易日成交量（換手率）向量;
                #     "Short_Selling_volume_turnover_date_transaction": y_E_Short_Selling,  # 兩次對衝交易日成交量（換手率）向量;
                #     "average_date_transaction_between": y_date_transaction_between,  # 兩次對衝交易間隔日長，均值;
                #     "Long_Position_average_date_transaction_between": y_date_transaction_between_Long_Position,  # 兩次對衝交易間隔日長，均值;
                #     "Short_Selling_average_date_transaction_between": y_date_transaction_between_Short_Selling,  # 兩次對衝交易間隔日長，均值;
                #     "Long_Position_date_transaction_between": y_C_Long_Position,  # 兩次對衝交易間隔日長，向量;
                #     "Short_Selling_date_transaction_between": y_C_Short_Selling,  # 兩次對衝交易間隔日長，向量;
                #     "Long_Position_date_transaction": y_F_Long_Position,  # 按規則執行交易的日期，向量;
                #     "Short_Selling_date_transaction": y_F_Short_Selling,  # 按規則執行交易的日期，向量;
                #     "P1_Array": P1_Array,  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
                #     "revenue_and_expenditure_records_date_transaction": y_G  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
                # }
                # print(test_result["y_profit"])  # 每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
                # print(test_result["y_Long_Position_profit"])  # 優化目標變量;
                # print(test_result["y_Short_Selling_profit"])  # 優化目標變量;
                # print(test_result["y_loss"])  # 每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
                # print(test_result["y_Long_Position_loss"])  # 優化目標變量;
                # print(test_result["y_Short_Selling_loss"])  # 優化目標變量;
                # print(test_result["profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # print(test_result["Long_Position_profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # print(test_result["Short_Selling_profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
                # print(test_result["profit_Positive"])  # 每兩次對衝交易收益纍加總計;
                # print(test_result["Long_Position_profit_Positive"])  # 每兩次對衝交易收益纍加總計;
                # print(test_result["Short_Selling_profit_Positive"])  # 每兩次對衝交易收益纍加總計;
                # print(test_result["profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
                # print(test_result["Long_Position_profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
                # print(test_result["Short_Selling_profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
                # print(test_result["profit_Negative"])  # 每兩次對衝交易損失纍加總計;
                # print(test_result["Long_Position_profit_Negative"])  # 每兩次對衝交易損失纍加總計;
                # print(test_result["Short_Selling_profit_Negative"])  # 每兩次對衝交易損失纍加總計;
                # print(test_result["profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
                # print(test_result["Long_Position_profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
                # print(test_result["Short_Selling_profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
                # print(test_result["Long_Position_profit_date_transaction"])  # 每兩次對衝交易利潤，向量;
                # print(test_result["Short_Selling_profit_date_transaction"])  # 每兩次對衝交易利潤，向量;
                # print("maximum_drawdown = ", test_result["maximum_drawdown"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # print("maximum_drawdown_Long_Position = ", test_result["maximum_drawdown_Long_Position"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # print("maximum_drawdown_Short_Selling = ", test_result["maximum_drawdown_Short_Selling"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
                # print("Long_Position_drawdown_date_transaction = ", test_result["Long_Position_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # print("Short_Selling_drawdown_date_transaction = ", test_result["Short_Selling_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
                # print(test_result["average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # print(test_result["Long_Position_average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # print(test_result["Short_Selling_average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
                # print(test_result["Long_Position_price_amplitude_date_transaction"])  # 兩次對衝交易日成交價振幅平方和，向量;
                # print(test_result["Short_Selling_price_amplitude_date_transaction"])  # 兩次對衝交易日成交價振幅平方和，向量;
                # print(test_result["average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
                # print(test_result["Long_Position_average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
                # print(test_result["Short_Selling_average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
                # print(test_result["Long_Position_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）向量;
                # print(test_result["Short_Selling_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）向量;
                # print(test_result["average_date_transaction_between"])  # 兩次交易間隔日長，均值;
                # print(test_result["Long_Position_average_date_transaction_between"])  # 兩次對衝交易間隔日長，均值;
                # print(test_result["Short_Selling_average_date_transaction_between"])  # 兩次對衝交易間隔日長，均值;
                # print(test_result["Long_Position_date_transaction_between"])  # 兩次對衝交易間隔日長，向量;
                # print(test_result["Short_Selling_date_transaction_between"])  # 兩次對衝交易間隔日長，向量;
                # print(test_result["Long_Position_date_transaction"])  # 按規則執行交易的日期，向量;
                # print(test_result["Long_Position_date_transaction"][0])  # 交易規則自動選取的交易日期;
                # print(test_result["Long_Position_date_transaction"][1])  # 交易規則自動選取的買入或賣出;
                # print(test_result["Long_Position_date_transaction"][2])  # 交易規則自動選取的成交價;
                # print(test_result["Long_Position_date_transaction"][3])  # 交易規則自動選取的成交量;
                # print(test_result["Long_Position_date_transaction"][4])  # 交易規則自動選取的成交次數記錄;
                # print(test_result["Long_Position_date_transaction"][5])  # 交易規則自動選取的交易日期的序列號，用於繪圖可視化;
                # print(test_result["Long_Position_date_transaction"][6])  # 交易日（datetime.date 類型）;
                # print(test_result["Long_Position_date_transaction"][7])  # 當日總成交量（turnover volume）;
                # print(test_result["Long_Position_date_transaction"][8])  # 當日開盤（opening）成交價;
                # print(test_result["Long_Position_date_transaction"][9])  # 當日收盤（closing）成交價;
                # print(test_result["Long_Position_date_transaction"][10])  # 當日最低（low）成交價;
                # print(test_result["Long_Position_date_transaction"][11])  # 當日最高（high）成交價;
                # print(test_result["Long_Position_date_transaction"][12])  # 當日總成交金額（turnover amount）;
                # print(test_result["Long_Position_date_transaction"][13])  # 當日成交量（turnover volume）換手率（turnover rate）;
                # print(test_result["Long_Position_date_transaction"][14])  # 當日每股收益（price earnings）;
                # print(test_result["Long_Position_date_transaction"][15])  # 當日每股净值（book value per share）;
                # print(test_result["Short_Selling_date_transaction"])  # 按規則執行交易的日期，向量;
                # print(test_result["Short_Selling_date_transaction"][0])  # 交易規則自動選取的交易日期;
                # print(test_result["Short_Selling_date_transaction"][1])  # 交易規則自動選取的買入或賣出;
                # print(test_result["Short_Selling_date_transaction"][2])  # 交易規則自動選取的成交價;
                # print(test_result["Short_Selling_date_transaction"][3])  # 交易規則自動選取的成交量;
                # print(test_result["Short_Selling_date_transaction"][4])  # 交易規則自動選取的成交次數記錄;
                # print(test_result["Short_Selling_date_transaction"][5])  # 交易規則自動選取的交易日期的序列號，用於繪圖可視化;
                # print(test_result["Short_Selling_date_transaction"][6])  # 交易日（datetime.date 類型）;
                # print(test_result["Short_Selling_date_transaction"][7])  # 當日總成交量（turnover volume）;
                # print(test_result["Short_Selling_date_transaction"][8])  # 當日開盤（opening）成交價;
                # print(test_result["Short_Selling_date_transaction"][9])  # 當日收盤（closing）成交價;
                # print(test_result["Short_Selling_date_transaction"][10])  # 當日最低（low）成交價;
                # print(test_result["Short_Selling_date_transaction"][11])  # 當日最高（high）成交價;
                # print(test_result["Short_Selling_date_transaction"][12])  # 當日總成交金額（turnover amount）;
                # print(test_result["Short_Selling_date_transaction"][13])  # 當日成交量（turnover volume）換手率（turnover rate）;
                # print(test_result["Short_Selling_date_transaction"][14])  # 當日每股收益（price earnings）;
                # print(test_result["Short_Selling_date_transaction"][15])  # 當日每股净值（book value per share）;
                # print(test_result["revenue_and_expenditure_records_date_transaction"])  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
                # print(test_result["P1_Array"])  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;

                test_profit_estimate = None  # float(test_result["profit_total"])
                if not (test_result["profit_total"] is None):
                    test_profit_estimate = float(test_result["profit_total"])
                test_odds_ratio_estimate = None  # float(test_result["profit_Positive_probability"] / test_result["profit_Negative_probability"])
                if (not (test_result["profit_Positive_probability"] is None)) and (not (test_result["profit_Negative_probability"] is None)):
                    if test_result["profit_Negative_probability"] != 0:
                        test_odds_ratio_estimate = float(test_result["profit_Positive_probability"] / test_result["profit_Negative_probability"])
                test_date_transaction_between = None  # float(test_result["average_date_transaction_between"])
                if not (test_result["average_date_transaction_between"] is None):
                    test_date_transaction_between = float(test_result["average_date_transaction_between"])
                # test_P1_Array = test_result["P1_Array"]  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;

            # resultDict_ticker_symbol = {}
            # resultDict_ticker_symbol["test_profit"] = test_profit_estimate
            # resultDict_ticker_symbol["test_odds_ratio"] = test_odds_ratio_estimate
            # resultDict_ticker_symbol["test_date_transaction_between"] = test_date_transaction_between
            # # resultDict_ticker_symbol["Coefficient"] = coefficient_from_fit  # 擬合得到的參數解;
            # # resultDict_ticker_symbol["Coefficient-StandardDeviation"] = margin_of_error  # 擬合得到的參數解的標準差;
            # # resultDict_ticker_symbol["Coefficient-Confidence-Lower-95%"] = [confidence_inter[1][1], confidence_inter[2][1]]  # 擬合得到的參數解的區間估計下限;
            # # resultDict_ticker_symbol["Coefficient-Confidence-Upper-95%"] = [confidence_inter[1][2], confidence_inter[2][2]]  # 擬合得到的參數解的區間估計上限;
            # # resultDict_ticker_symbol["Yfit"] = Yvals  # 擬合 y 值;
            # # resultDict_ticker_symbol["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower  # 擬合的應變量 Yvals 誤差下限;
            # # resultDict_ticker_symbol["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper  # 擬合的應變量 Yvals 誤差上限;
            # # resultDict_ticker_symbol["Residual"] = Residual  # 擬合殘差;
            # # resultDict_ticker_symbol["P1_Array"] = training_result["P1_Array"]  # P1_Array;  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
            # # resultDict_ticker_symbol["y_profit"] = training_result["y_profit"]  # 最優化目標值，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
            # # resultDict_ticker_symbol["y_Long_Position_profit"] = training_result["y_Long_Position_profit"]  # 最優化目標值，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
            # # resultDict_ticker_symbol["y_Short_Selling_profit"] = training_result["y_Short_Selling_profit"]  # 最優化目標值，每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
            # # resultDict_ticker_symbol["y_loss"] = training_result["y_loss"]  # 最優化目標值，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
            # # resultDict_ticker_symbol["y_Long_Position_loss"] = training_result["y_Long_Position_loss"]  # 最優化目標值，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
            # # resultDict_ticker_symbol["y_Short_Selling_loss"] = training_result["y_Short_Selling_loss"]  # 最優化目標值，每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
            # # resultDict_ticker_symbol["profit_total"] = training_result["profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
            # # resultDict_ticker_symbol["Long_Position_profit_total"] = training_result["Long_Position_profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
            # # resultDict_ticker_symbol["Short_Selling_profit_total"] = training_result["Short_Selling_profit_total"]  # 每兩次對衝交易利潤 × 頻率，纍加總計;
            # # resultDict_ticker_symbol["profit_Positive"] = training_result["profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            # # resultDict_ticker_symbol["Long_Position_profit_Positive"] = training_result["Long_Position_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            # # resultDict_ticker_symbol["Short_Selling_profit_Positive"] = training_result["Short_Selling_profit_Positive"]  # 每兩次對衝交易收益纍加總計;
            # # resultDict_ticker_symbol["profit_Positive_probability"] = training_result["profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            # # resultDict_ticker_symbol["Long_Position_profit_Positive_probability"] = training_result["Long_Position_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            # # resultDict_ticker_symbol["Short_Selling_profit_Positive_probability"] = training_result["Short_Selling_profit_Positive_probability"]  # 每兩次對衝交易正利潤概率;
            # # resultDict_ticker_symbol["profit_Negative"] = training_result["profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            # # resultDict_ticker_symbol["Long_Position_profit_Negative"] = training_result["Long_Position_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            # # resultDict_ticker_symbol["Short_Selling_profit_Negative"] = training_result["Short_Selling_profit_Negative"]  # 每兩次對衝交易損失纍加總計;
            # # resultDict_ticker_symbol["profit_Negative_probability"] = training_result["profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            # # resultDict_ticker_symbol["Long_Position_profit_Negative_probability"] = training_result["Long_Position_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            # # resultDict_ticker_symbol["Short_Selling_profit_Negative_probability"] = training_result["Short_Selling_profit_Negative_probability"]  # 每兩次對衝交易負利潤概率;
            # # resultDict_ticker_symbol["Long_Position_profit_date_transaction"] = training_result["Long_Position_profit_date_transaction"]  # 每兩次對衝交易利潤，向量;
            # # resultDict_ticker_symbol["Short_Selling_profit_date_transaction"] = training_result["Short_Selling_profit_date_transaction"]  # 每兩次對衝交易利潤，向量;
            # # resultDict_ticker_symbol["maximum_drawdown"] = training_result["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            # # resultDict_ticker_symbol["maximum_drawdown_Long_Position"] = training_result["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            # # resultDict_ticker_symbol["maximum_drawdown_Short_Selling"] = training_result["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            # # resultDict_ticker_symbol["Long_Position_drawdown_date_transaction"] = training_result["Long_Position_drawdown_date_transaction"]  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
            # # resultDict_ticker_symbol["Short_Selling_drawdown_date_transaction"] = training_result["Short_Selling_drawdown_date_transaction"]  # 向量，記錄做空模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
            # # resultDict_ticker_symbol["average_price_amplitude_date_transaction"] = training_result["average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            # # resultDict_ticker_symbol["Long_Position_average_price_amplitude_date_transaction"] = training_result["Long_Position_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            # # resultDict_ticker_symbol["Short_Selling_average_price_amplitude_date_transaction"] = training_result["Short_Selling_average_price_amplitude_date_transaction"]  # 兩兩次對衝交易日成交價振幅平方和，均值;
            # # resultDict_ticker_symbol["Long_Position_price_amplitude_date_transaction"] = training_result["Long_Position_price_amplitude_date_transaction"]  # 兩次對衝交易日成交價振幅平方和，向量;
            # # resultDict_ticker_symbol["Short_Selling_price_amplitude_date_transaction"] = training_result["Short_Selling_price_amplitude_date_transaction"]  # 兩次對衝交易日成交價振幅平方和，向量;
            # # resultDict_ticker_symbol["average_volume_turnover_date_transaction"] = training_result["average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            # # resultDict_ticker_symbol["Long_Position_average_volume_turnover_date_transaction"] = training_result["Long_Position_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            # # resultDict_ticker_symbol["Short_Selling_average_volume_turnover_date_transaction"] = training_result["Short_Selling_average_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）均值;
            # # resultDict_ticker_symbol["Long_Position_volume_turnover_date_transaction"] = training_result["Long_Position_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）向量;
            # # resultDict_ticker_symbol["Short_Selling_volume_turnover_date_transaction"] = training_result["Short_Selling_volume_turnover_date_transaction"]  # 兩次對衝交易日成交量（換手率）向量;
            # # resultDict_ticker_symbol["average_date_transaction_between"] = training_result["average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            # # resultDict_ticker_symbol["Long_Position_average_date_transaction_between"] = training_result["Long_Position_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            # # resultDict_ticker_symbol["Short_Selling_average_date_transaction_between"] = training_result["Short_Selling_average_date_transaction_between"]  # 兩次對衝交易間隔日長，均值;
            # # resultDict_ticker_symbol["Long_Position_date_transaction_between"] = training_result["Long_Position_date_transaction_between"]  # 兩次對衝交易間隔日長，向量;
            # # resultDict_ticker_symbol["Short_Selling_date_transaction_between"] = training_result["Short_Selling_date_transaction_between"]  # 兩次對衝交易間隔日長，向量;
            # # resultDict_ticker_symbol["Long_Position_date_transaction"] = training_result["Long_Position_date_transaction"]  # 按規則執行交易的日期，向量;
            # # resultDict_ticker_symbol["Short_Selling_date_transaction"] = training_result["Short_Selling_date_transaction"]  # 按規則執行交易的日期，向量;
            # # resultDict_ticker_symbol["revenue_and_expenditure_records_date_transaction"] = training_result["revenue_and_expenditure_records_date_transaction"]  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
            # resultDict_ticker_symbol["testData"] = test_result  # 傳入測試數據集的計算結果;
            # # resultDict_ticker_symbol["Curve-fit-image"] = img1  # 擬合曲綫繪圖;
            # # resultDict_ticker_symbol["Residual-image"] = img2  # 擬合殘差繪圖;

            # # resultDict = {}
            # resultDict[key] = resultDict_ticker_symbol
            # resultDict_ticker_symbol = None  # 釋放内存;

            resultDict[key]["test_profit"] = test_profit_estimate
            resultDict[key]["test_maximum_drawdown"] = test_result["maximum_drawdown"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            resultDict[key]["test_maximum_drawdown_Long_Position"] = test_result["maximum_drawdown_Long_Position"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            resultDict[key]["test_maximum_drawdown_Short_Selling"] = test_result["maximum_drawdown_Short_Selling"]  # 兩次對衝交易之間的最大回撤值，取極值統計;
            resultDict[key]["test_odds_ratio"] = test_odds_ratio_estimate
            resultDict[key]["test_date_transaction_between"] = test_date_transaction_between
            resultDict[key]["testData"] = test_result  # 傳入測試數據集的計算結果;


    # 繪圖;
    # https://matplotlib.org/stable/contents.html
    # 使用第三方擴展包「matplotlib」中的「pyplot()」函數繪製散點圖示;
    # import matplotlib  # as mpl
    # import matplotlib.pyplot as matplotlib_pyplot
    # import matplotlib.font_manager as matplotlib_font_manager  # 導入第三方擴展包「matplotlib」中的字體管理器，用於設置生成圖片中文字的字體;
    # %matplotlib inline
    # matplotlib.rcParams['font.sans-serif'] = ['SimHei']
    # matplotlib.rcParams['font.family'] = 'sans-serif'
    # matplotlib.rcParams['axes.unicode_minus'] = False
    # import mplfinance  # 導入第三方擴展包「mplfinance」，用於製作日棒缐（K Days Line）圖;
    # from mplfinance.original_flavor import candlestick_ohlc as mplfinance_original_flavor_candlestick_ohlc  # 從第三方擴展包「mplfinance」中導入「original_flavor」模組的「candlestick_ohlc()」函數，用於繪製股票作日棒缐（K Days Line）圖;
    # matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, clear=False, **kwargs)
    # 參數 figsize=(float,float) 表示繪圖板的長、寬數，預設值為 figsize=[6.4,4.8] 單位為英寸；參數 dpi=float 表示圖形分辨率，預設值為 dpi=100，單位為每平方英尺中的點數；參數 constrained_layout=True 設置子圖區域不要有重叠;
    fig = None
    if False:

        ticker_symbol = str("002611")  # 流通代碼;

        # import matplotlib  # as mpl
        import matplotlib.pyplot as matplotlib_pyplot
        # import mplfinance  # 導入第三方擴展包「mplfinance」，用於製作日棒缐（K Days Line）圖;
        # from mplfinance.original_flavor import candlestick_ohlc as mplfinance_original_flavor_candlestick_ohlc  # 從第三方擴展包「mplfinance」中導入「original_flavor」模組的「candlestick_ohlc()」函數，用於繪製股票作日棒缐（K Days Line）圖;

        fig = matplotlib_pyplot.figure(figsize=(16, 9), dpi=300, constrained_layout=True)  # 參數 constrained_layout=True 設置子圖區域不要有重叠
        # fig.tight_layout()  # 自動調整子圖參數，使之填充整個圖像區域;
        # matplotlib.pyplot.subplot2grid(shape, loc, rowspan=1, colspan=1, fig=None, **kwargs)
        # 參數 shape=(int,int) 表示創建網格行列數，傳入參數值類型為一維整型數組[int,int]；參數 loc=(int,int) 表示一個畫布所占網格起點的橫縱坐標，傳入參數值類型為一維整型數組[int,int]；參數 rowspan=1 表示該畫布占一行的長度，參數 colspan=1 表示該畫布占一列的寬度;
        axes_1 = matplotlib_pyplot.subplot2grid((2, 1), (0, 0), rowspan=1, colspan=1)  # 參數 (2,1) 表示創建 2 行 1 列的網格，參數 (0,0) 表示第一個畫布 axes_1 的起點在橫坐標為 0 縱坐標為 0 的網格，參數 rowspan=1 表示該畫布占一行的長度，參數 colspan=1 表示該畫布占一列的寬度;
        axes_2 = matplotlib_pyplot.subplot2grid((2, 1), (1, 0), rowspan=1, colspan=1)
        # 繪製擬合曲綫圖;
        # plot1 = matplotlib_pyplot.scatter(
        #     Xdata,
        #     Ydata,
        #     s=None,
        #     c='blue',
        #     edgecolors=None,
        #     linewidths=1,
        #     marker='o',
        #     alpha=0.5,
        #     label='observation values'
        # )  # 繪製散點圖;
        # # plot2 = matplotlib_pyplot.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
        # plot2 = matplotlib_pyplot.plot(
        #     Xnew,
        #     Ynew,
        #     color='red',
        #     linewidth=2.0,
        #     linestyle='-',
        #     alpha=1,
        #     label='polyfit values'
        # )  # 繪製平滑折綫圖;
        # matplotlib_pyplot.xticks(idx, Xdata)  # 設置顯示坐標橫軸刻度標簽;
        # matplotlib_pyplot.xlabel('Independent Variable ( x )')  # 設置顯示橫軸標題為 'Independent Variable ( x )'
        # matplotlib_pyplot.ylabel('Dependent Variable ( y )')  # 設置顯示縱軸標題為 'Dependent Variable ( y )'
        # matplotlib_pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
        # matplotlib_pyplot.title('4 parameter logistic model')  # 設置顯示圖標題;
        # matplotlib_pyplot.show()  # 顯示圖片;

        # 繪製訓練集折缐圖示;
        # img1 = None
        if isinstance(trainingData, dict) and int(len(trainingData)) > int(0):

            trainingData_index = trainingData[ticker_symbol]
            training_result = resultDict[ticker_symbol]

            # 繪製均值散點圖;
            axes_1.scatter(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                trainingData_index["focus"],  # YdataMean,  # Ydata,
                s = 15,  # 點大小，取 0 表示不顯示;
                c = 'black',  # 點顔色;
                edgecolors = 'black',  # 邊顔色;  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidths = 0.25,  # 邊粗細;
                marker = 'o',  # 點標志;
                alpha = 1,  # 點透明度;
                label = ''
            )
            # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
            # 繪製均值平滑折綫圖;
            axes_1.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                trainingData_index["focus"],  # YdataMean,  # Yvals,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 1.0,
                linestyle = '-',
                alpha = 1,
                label = 'focus'
            )
            # 繪製極小值平滑折綫圖;
            axes_1.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                trainingData_index["low_price"],  # YvalsUncertaintyLower,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'low'
            )
            # 繪製極大值平滑折綫圖;
            axes_1.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                trainingData_index["high_price"],  # YvalsUncertaintyUpper,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'high'
            )
            # 描繪曲綫的填充置信區間;
            axes_1.fill_between(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                # trainingData_index["focus"],  # YdataMean,  # Yvals,
                trainingData_index["low_price"],  # YvalsUncertaintyLower,
                trainingData_index["high_price"],  # YvalsUncertaintyUpper,
                color = 'grey',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linestyle = ':',
                linewidth = 0.5,
                alpha = 0.15,
            )
            # 繪製開盤值平滑折綫圖;
            axes_1.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                trainingData_index["opening_price"],  # YvalsUncertaintyLower,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'low'
            )
            # 繪製收盤值平滑折綫圖;
            axes_1.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                trainingData_index["close_price"],  # YvalsUncertaintyUpper,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'high'
            )
            # 描繪曲綫的填充置信區間;
            axes_1.fill_between(
                [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["date_transaction"])), int(1))],  # trainingData_index["date_transaction"],  # Xdata,
                # trainingData_index["focus"],  # YdataMean,  # Yvals,
                [float(min([float(trainingData_index["opening_price"][i]), float(trainingData_index["close_price"][i])])) for i in range(int(0), int(len(trainingData_index["focus"])), int(1))],  # trainingData_index["opening_price"],  # YvalsUncertaintyLower,
                [float(max([float(trainingData_index["opening_price"][i]), float(trainingData_index["close_price"][i])])) for i in range(int(0), int(len(trainingData_index["focus"])), int(1))],  # trainingData_index["close_price"],  # YvalsUncertaintyUpper,
                color = 'grey',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linestyle = ':',
                linewidth = 0.5,
                alpha = 0.15,
            )
            # 繪製交易數據;
            buy_x = []
            # [int(training_result["Long_Position_date_transaction"][i][5]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))]
            # [int(training_result["Short_Selling_date_transaction"][i][5]) if str(training_result["Short_Selling_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1))]
            buy_y = []
            # [float(training_result["Long_Position_date_transaction"][i][2]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))]
            # [float(training_result["Short_Selling_date_transaction"][i][2]) if str(training_result["Short_Selling_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1))]
            buy_label = []
            # [str(str(training_result["Long_Position_date_transaction"][i][1]) * " " * str(training_result["Long_Position_date_transaction"][i][4])) if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))]
            # [str(str(training_result["Short_Selling_date_transaction"][i][1]) * " " * str(training_result["Short_Selling_date_transaction"][i][4])) if str(training_result["Short_Selling_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1))]
            for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1)):
                if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy"):
                    # buy_x.append(training_result["Long_Position_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    buy_x.append(int(training_result["Long_Position_date_transaction"][i][5]))
                    buy_y.append(float(training_result["Long_Position_date_transaction"][i][2]))
                    buy_label.append(str(str(training_result["Long_Position_date_transaction"][i][1]) * " " * str(training_result["Long_Position_date_transaction"][i][4])))
            # for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1)):
            #     if str(training_result["Short_Selling_date_transaction"][i][1]) == str("buy"):
            #         # buy_x.append(training_result["Short_Selling_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
            #         buy_x.append(int(training_result["Short_Selling_date_transaction"][i][5]))
            #         buy_y.append(float(training_result["Short_Selling_date_transaction"][i][2]))
            #         buy_label.append(str(str(training_result["Short_Selling_date_transaction"][i][1]) * " " * str(training_result["Short_Selling_date_transaction"][i][4])))
            axes_1.scatter(
                buy_x,  # [int(training_result["Long_Position_date_transaction"][i][5]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))],  # [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["Long_Position_date_transaction"])), int(1))],  # trainingData_index["Long_Position_date_transaction"],  # Xdata,
                buy_y,  # [float(training_result["Long_Position_date_transaction"][i][2]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))],  # trainingData_index["focus"],  # YdataMean,  # Ydata,
                s = 15,  # 點大小，取 0 表示不顯示;
                c = 'red',  # 點顔色;
                edgecolors = 'red',  # 邊顔色;  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidths = 0.25,  # 邊粗細;
                marker = 'o',  # 點標志;
                alpha = 1,  # 點透明度;
                label = buy_label,  # [str(str(training_result["Long_Position_date_transaction"][i][1]) * " " * str(training_result["Long_Position_date_transaction"][i][4])) if str(training_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))],
            )
            sell_x = []
            # [int(training_result["Long_Position_date_transaction"][i][5]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))]
            # [int(training_result["Short_Selling_date_transaction"][i][5]) if str(training_result["Short_Selling_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1))]
            sell_y = []
            # [float(training_result["Long_Position_date_transaction"][i][2]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))]
            # [float(training_result["Short_Selling_date_transaction"][i][2]) if str(training_result["Short_Selling_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1))]
            sell_label = []
            # [str(str(training_result["Long_Position_date_transaction"][i][1]) * " " * str(training_result["Long_Position_date_transaction"][i][4])) if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))]
            # [str(str(training_result["Short_Selling_date_transaction"][i][1]) * " " * str(training_result["Short_Selling_date_transaction"][i][4])) if str(training_result["Short_Selling_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1))]
            for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1)):
                if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell"):
                    # sell_x.append(training_result["Long_Position_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    sell_x.append(int(training_result["Long_Position_date_transaction"][i][5]))
                    sell_y.append(float(training_result["Long_Position_date_transaction"][i][2]))
                    sell_label.append(str(str(training_result["Long_Position_date_transaction"][i][1]) * " " * str(training_result["Long_Position_date_transaction"][i][4])))
            # for i in range(int(0), int(len(training_result["Short_Selling_date_transaction"])), int(1)):
            #     if str(training_result["Short_Selling_date_transaction"][i][1]) == str("sell"):
            #         # sell_x.append(training_result["Short_Selling_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
            #         sell_x.append(int(training_result["Short_Selling_date_transaction"][i][5]))
            #         sell_y.append(float(training_result["Short_Selling_date_transaction"][i][2]))
            #         sell_label.append(str(str(training_result["Short_Selling_date_transaction"][i][1]) * " " * str(training_result["Short_Selling_date_transaction"][i][4])))
            axes_1.scatter(
                sell_x,  # [int(training_result["Long_Position_date_transaction"][i][5]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))],  # [int(int(i) + int(1)) for i in range(int(0), int(len(trainingData_index["Long_Position_date_transaction"])), int(1))],  # trainingData_index["Long_Position_date_transaction"],  # Xdata,
                sell_y,  # [float(training_result["Long_Position_date_transaction"][i][2]) if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))],  # trainingData_index["focus"],  # YdataMean,  # Ydata,
                s = 15,  # 點大小，取 0 表示不顯示;
                c = 'green',  # 點顔色;
                edgecolors = 'green',  # 邊顔色;  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidths = 0.25,  # 邊粗細;
                marker = 'o',  # 點標志;
                alpha = 1,  # 點透明度;
                label = sell_label,  # [str(str(training_result["Long_Position_date_transaction"][i][1]) * " " * str(training_result["Long_Position_date_transaction"][i][4])) if str(training_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(training_result["Long_Position_date_transaction"])), int(1))],
            )
            # 設置坐標軸標題
            axes_1.set_xlabel(
                'date transaction',  # 'Independent Variable ( x )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            axes_1.set_ylabel(
                'price transaction',  # 'Dependent Variable ( y )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            # # 確定橫縱坐標範圍;
            # axes_1.set_xlim(
            #     float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
            #     float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
            # )
            # axes_1.set_ylim(
            #     float(numpy.min(Ydata)) - float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1),
            #     float(numpy.max(Ydata)) + float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1)
            # )
            # # 設置坐標軸間隔和標簽
            # axes_1.set_xticks(Xdata)
            # # axes_1.set_xticklabels(
            # #     [
            # #         str(round(int(Xdata[0]), 0)),
            # #         str(round(int(Xdata[1]), 0)),
            # #         str(round(int(Xdata[2]), 0)),
            # #         str(round(int(Xdata[3]), 0)),
            # #         str(round(int(Xdata[4]), 0)),
            # #         str(round(int(Xdata[5]), 0)),
            # #         str(round(int(Xdata[6]), 0)),
            # #         str(round(int(Xdata[7]), 0)),
            # #         str(round(int(Xdata[8]), 0)),
            # #         str(round(int(Xdata[9]), 0)),
            # #         str(round(int(Xdata[10]), 0))
            # #     ],
            # #     rotation=0,
            # #     ha='center',
            # #     fontdict={"family": "SimSun", "size": 7},
            # #     fontsize='xx-small'
            # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
            # axes_1.set_xticklabels(
            #     [str(round(int(Xdata[i]), 0)) for i in range(len(Xdata))],
            #     rotation=0,
            #     ha='center',
            #     fontdict={"family": "SimSun", "size": 7},
            #     fontsize='xx-small'
            # )
            for tl in axes_1.get_xticklabels():
                tl.set_rotation(0)
                tl.set_ha('center')
                tl.set_fontsize(7)
                tl.set_fontfamily('SimSun')
                # tl.set_color('red')
            # axes_1.set_yticks(YdataMean)  # Ydata;
            # # axes_1.set_yticklabels(
            # #     [
            # #         str(round(int(YdataMean[0]), 0)),
            # #         str(round(int(YdataMean[1]), 0)),
            # #         str(round(int(YdataMean[2]), 0)),
            # #         str(round(int(YdataMean[3]), 0)),
            # #         str(round(int(YdataMean[4]), 0)),
            # #         str(round(int(YdataMean[5]), 0)),
            # #         str(round(int(YdataMean[6]), 0)),
            # #         str(round(int(YdataMean[7]), 0)),
            # #         str(round(int(YdataMean[8]), 0)),
            # #         str(round(int(YdataMean[9]), 0)),
            # #         str(round(int(YdataMean[10]), 0))
            # #     ],
            # #     rotation=0,
            # #     ha='right',
            # #     fontdict={"family": "SimSun", "size": 7},
            # #     fontsize='xx-small'
            # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
            # axes_1.set_yticklabels(
            #     [str(round(int(YdataMean[i]), 0)) for i in range(len(YdataMean))],
            #     rotation=0,
            #     ha='right',
            #     fontdict={"family": "SimSun", "size": 7},
            #     fontsize='xx-small'
            # )
            for tl in axes_1.get_yticklabels():
                tl.set_rotation(0)
                tl.set_ha('right')
                tl.set_fontsize(7)
                tl.set_fontfamily('SimSun')
                # tl.set_color('red')
            axes_1.grid(True, which='major', linestyle=':', color='grey', linewidth=0.25, alpha=0.3)  # which='minor'
            axes_1.legend(
                loc='lower right',
                shadow=False,
                frameon=False,
                edgecolor='grey',
                framealpha=0,
                facecolor="none",
                prop={"family": "Times New Roman", "size": 7},
                fontsize='xx-small'
            )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
            axes_1.spines['left'].set_linewidth(0.1)
            # axes_1.spines['left'].set_visible(False)  # 去除邊框;
            axes_1.spines['top'].set_visible(False)
            axes_1.spines['right'].set_visible(False)
            # axes_1.spines['bottom'].set_visible(False)
            axes_1.spines['bottom'].set_linewidth(0.1)
            axes_1.set_title(
                "market timing model ( training )",
                fontdict={"family": "SimSun", "size": 7},
                fontsize='xx-small'
            )

            # # https://github.com/matplotlib/mplfinance
            # # 使用第三方擴展包「mplfinance」繪製日棒缐（K Days Line）圖;
            # # import mplfinance  # 導入第三方擴展包「mplfinance」，用於製作日棒缐（K Days Line）圖;
            # # from mplfinance.original_flavor import candlestick_ohlc as mplfinance_original_flavor_candlestick_ohlc  # 從第三方擴展包「mplfinance」中導入「original_flavor」模組的「candlestick_ohlc()」函數，用於繪製股票作日棒缐（K Days Line）圖;
            # mplfinance.plot(
            #     pandas.DataFrame({
            #         "Date": [str(item) for item in trainingData_index["date_transaction"]],  # trainingData_index["date_transaction"],
            #         "Open": trainingData_index["opening_price"],
            #         "High": trainingData_index["high_price"],
            #         "Low": trainingData_index["low_price"],
            #         "Close": trainingData_index["close_price"],
            #         "Volume": trainingData_index["turnover_volume"],
            #     }),
            #     type = "candle",  # 指定繪圖類型爲日棒缐圖（K Days Line），可取值：type="candle", type="line", type="renko", or type="pnf" ;
            #     mav = (
            #         # 1,  # 添加滑動平均缐（1 日）;
            #         5,  # 添加滑動平均缐（5 日~周）;
            #         20,  # 添加滑動平均缐（20 日~月）;
            #         60  # 添加滑動平均缐（60 日~季）;
            #     ),  # 添加滑動平均缐;
            #     volume = True,  # 添加成交量柱形圖;
            #     show_nontrading = False,  # 取 True 時，表示設定顯示非交易日，將非交易日添加爲空白;
            #     # study = [
            #     #     "macd",
            #     #     "rsi"
            #     # ],
            #     # macd_n_fast = 12,
            #     # macd_n_slow = 26,
            #     # rsi_n = 14,
            #     # style = mplfinance.make_mpf_style(
            #     #     gridaxis = "both",  # 設置圖片網格缐位置;
            #     #     gridstyle = "-.",  # 設置圖片網格缐形狀;
            #     #     y_on_right = False,  # 設置 y 軸位置是否在右側;
            #     #     marketcolors = mplfinance.make_marketcolors(
            #     #         up = "green",
            #     #         down = "red",
            #     #         edge = "i",  # 設置棒圖方框邊缐顔色，取 "i" 值，表示繼承參數：up、down 的顔色配置;
            #     #         wick = "i",  # 設置棒圖上下影缐顔色，，取 "i" 值，表示繼承參數：up、down 的顔色配置;
            #     #         volume = "in",  # 設置成交量柱形圖顔色;
            #     #         inherit = True  # 指定是否繼承;
            #     #     )
            #     # ),
            #     # savefig = {"fname": "stock_K_Days_Line.png"},  # 將圖片存儲爲硬盤文檔;
            #     ylabel = "transaction price",
            #     ylabel_lower = "shares\ntransaction volume",
            #     xlabel = "transaction date",
            #     title = "\nstock %s candle line" % (ticker_symbol),
            #     figratio = (15, 10),  # 設置圖片長、寬比;
            #     figscale = 5  # 設置圖片質量等級;
            # )

        # 繪製測試集折缐圖示;
        if isinstance(testData, dict) and int(len(testData)) > int(0):

            testData_index = testData[ticker_symbol]
            test_result = resultDict[ticker_symbol]["testData"]

            # 繪製均值散點圖;
            axes_2.scatter(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                testData_index["focus"],  # YdataMean,  # Ydata,
                s = 15,  # 點大小，取 0 表示不顯示;
                c = 'black',  # 點顔色;
                edgecolors = 'black',  # 邊顔色;  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidths = 0.25,  # 邊粗細;
                marker = 'o',  # 點標志;
                alpha = 1,  # 點透明度;
                label = ''
            )
            # axes_2.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
            # 繪製均值平滑折綫圖;
            axes_2.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                testData_index["focus"],  # YdataMean,  # Yvals,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 1.0,
                linestyle = '-',
                alpha = 1,
                label = 'focus'
            )
            # 繪製極小值平滑折綫圖;
            axes_2.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                testData_index["low_price"],  # YvalsUncertaintyLower,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'low'
            )
            # 繪製極大值平滑折綫圖;
            axes_2.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                testData_index["high_price"],  # YvalsUncertaintyUpper,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'high'
            )
            # 描繪曲綫的填充置信區間;
            axes_2.fill_between(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                # testData_index["focus"],  # YdataMean,  # Yvals,
                testData_index["low_price"],  # YvalsUncertaintyLower,
                testData_index["high_price"],  # YvalsUncertaintyUpper,
                color = 'grey',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linestyle = ':',
                linewidth = 0.5,
                alpha = 0.15,
            )
            # 繪製開盤值平滑折綫圖;
            axes_2.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                testData_index["opening_price"],  # YvalsUncertaintyLower,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'low'
            )
            # 繪製收盤值平滑折綫圖;
            axes_2.plot(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                testData_index["close_price"],  # YvalsUncertaintyUpper,
                color = 'black',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidth = 0.5,
                linestyle = ':',
                alpha = 1,
                label = 'high'
            )
            # 描繪曲綫的填充置信區間;
            axes_2.fill_between(
                [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["date_transaction"])), int(1))],  # testData_index["date_transaction"],  # Xdata,
                # testData_index["focus"],  # YdataMean,  # Yvals,
                [float(min([float(testData_index["opening_price"][i]), float(testData_index["close_price"][i])])) for i in range(int(0), int(len(testData_index["focus"])), int(1))],  # testData_index["opening_price"],  # YvalsUncertaintyLower,
                [float(max([float(testData_index["opening_price"][i]), float(testData_index["close_price"][i])])) for i in range(int(0), int(len(testData_index["focus"])), int(1))],  # testData_index["close_price"],  # YvalsUncertaintyUpper,
                color = 'grey',  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linestyle = ':',
                linewidth = 0.5,
                alpha = 0.15,
            )
            # 繪製交易數據;
            buy_x = []
            # [int(test_result["Long_Position_date_transaction"][i][5]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))]
            # [int(test_result["Short_Selling_date_transaction"][i][5]) if str(test_result["Short_Selling_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1))]
            buy_y = []
            # [float(test_result["Long_Position_date_transaction"][i][2]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))]
            # [float(test_result["Short_Selling_date_transaction"][i][2]) if str(test_result["Short_Selling_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1))]
            buy_label = []
            # [str(str(test_result["Long_Position_date_transaction"][i][1]) * " " * str(test_result["Long_Position_date_transaction"][i][4])) if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))]
            # [str(str(test_result["Short_Selling_date_transaction"][i][1]) * " " * str(test_result["Short_Selling_date_transaction"][i][4])) if str(test_result["Short_Selling_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1))]
            for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1)):
                if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy"):
                    # buy_x.append(test_result["Long_Position_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    buy_x.append(int(test_result["Long_Position_date_transaction"][i][5]))
                    buy_y.append(float(test_result["Long_Position_date_transaction"][i][2]))
                    buy_label.append(str(str(test_result["Long_Position_date_transaction"][i][1]) * " " * str(test_result["Long_Position_date_transaction"][i][4])))
            # for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1)):
            #     if str(test_result["Short_Selling_date_transaction"][i][1]) == str("buy"):
            #         # buy_x.append(test_result["Short_Selling_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
            #         buy_x.append(int(test_result["Short_Selling_date_transaction"][i][5]))
            #         buy_y.append(float(test_result["Short_Selling_date_transaction"][i][2]))
            #         buy_label.append(str(str(test_result["Short_Selling_date_transaction"][i][1]) * " " * str(test_result["Short_Selling_date_transaction"][i][4])))
            axes_2.scatter(
                buy_x,  # [int(test_result["Long_Position_date_transaction"][i][5]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))],  # [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["Long_Position_date_transaction"])), int(1))],  # testData_index["Long_Position_date_transaction"],  # Xdata,
                buy_y,  # [float(test_result["Long_Position_date_transaction"][i][2]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))],  # testData_index["focus"],  # YdataMean,  # Ydata,
                s = 15,  # 點大小，取 0 表示不顯示;
                c = 'red',  # 點顔色;
                edgecolors = 'red',  # 邊顔色;  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidths = 0.25,  # 邊粗細;
                marker = 'o',  # 點標志;
                alpha = 1,  # 點透明度;
                label = buy_label,  # [str(str(test_result["Long_Position_date_transaction"][i][1]) * " " * str(test_result["Long_Position_date_transaction"][i][4])) if str(test_result["Long_Position_date_transaction"][i][1]) == str("buy") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))],
            )
            sell_x = []
            # [int(test_result["Long_Position_date_transaction"][i][5]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))]
            # [int(test_result["Short_Selling_date_transaction"][i][5]) if str(test_result["Short_Selling_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1))]
            sell_y = []
            # [float(test_result["Long_Position_date_transaction"][i][2]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))]
            # [float(test_result["Short_Selling_date_transaction"][i][2]) if str(test_result["Short_Selling_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1))]
            sell_label = []
            # [str(str(test_result["Long_Position_date_transaction"][i][1]) * " " * str(test_result["Long_Position_date_transaction"][i][4])) if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))]
            # [str(str(test_result["Short_Selling_date_transaction"][i][1]) * " " * str(test_result["Short_Selling_date_transaction"][i][4])) if str(test_result["Short_Selling_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1))]
            for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1)):
                if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell"):
                    # sell_x.append(test_result["Long_Position_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    sell_x.append(int(test_result["Long_Position_date_transaction"][i][5]))
                    sell_y.append(float(test_result["Long_Position_date_transaction"][i][2]))
                    sell_label.append(str(str(test_result["Long_Position_date_transaction"][i][1]) * " " * str(test_result["Long_Position_date_transaction"][i][4])))
            # for i in range(int(0), int(len(test_result["Short_Selling_date_transaction"])), int(1)):
            #     if str(test_result["Short_Selling_date_transaction"][i][1]) == str("sell"):
            #         # sell_x.append(test_result["Short_Selling_date_transaction"][i][0])  # 使用 list.append() 函數在列表末尾追加推入新元素;
            #         sell_x.append(int(test_result["Short_Selling_date_transaction"][i][5]))
            #         sell_y.append(float(test_result["Short_Selling_date_transaction"][i][2]))
            #         sell_label.append(str(str(test_result["Short_Selling_date_transaction"][i][1]) * " " * str(test_result["Short_Selling_date_transaction"][i][4])))
            axes_2.scatter(
                sell_x,  # [int(test_result["Long_Position_date_transaction"][i][5]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))],  # [int(int(i) + int(1)) for i in range(int(0), int(len(testData_index["Long_Position_date_transaction"])), int(1))],  # testData_index["Long_Position_date_transaction"],  # Xdata,
                sell_y,  # [float(test_result["Long_Position_date_transaction"][i][2]) if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))],  # testData_index["focus"],  # YdataMean,  # Ydata,
                s = 15,  # 點大小，取 0 表示不顯示;
                c = 'green',  # 點顔色;
                edgecolors = 'green',  # 邊顔色;  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
                linewidths = 0.25,  # 邊粗細;
                marker = 'o',  # 點標志;
                alpha = 1,  # 點透明度;
                label = sell_label,  # [str(str(test_result["Long_Position_date_transaction"][i][1]) * " " * str(test_result["Long_Position_date_transaction"][i][4])) if str(test_result["Long_Position_date_transaction"][i][1]) == str("sell") else None for i in range(int(0), int(len(test_result["Long_Position_date_transaction"])), int(1))],
            )
            # 設置坐標軸標題
            axes_2.set_xlabel(
                'date transaction',  # 'Independent Variable ( x )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            axes_2.set_ylabel(
                'price transaction',  # 'Dependent Variable ( y )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            # # 確定橫縱坐標範圍;
            # axes_2.set_xlim(
            #     float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
            #     float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
            # )
            # axes_2.set_ylim(
            #     float(numpy.min(Ydata)) - float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1),
            #     float(numpy.max(Ydata)) + float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1)
            # )
            # # 設置坐標軸間隔和標簽
            # axes_2.set_xticks(Xdata)
            # # axes_2.set_xticklabels(
            # #     [
            # #         str(round(int(Xdata[0]), 0)),
            # #         str(round(int(Xdata[1]), 0)),
            # #         str(round(int(Xdata[2]), 0)),
            # #         str(round(int(Xdata[3]), 0)),
            # #         str(round(int(Xdata[4]), 0)),
            # #         str(round(int(Xdata[5]), 0)),
            # #         str(round(int(Xdata[6]), 0)),
            # #         str(round(int(Xdata[7]), 0)),
            # #         str(round(int(Xdata[8]), 0)),
            # #         str(round(int(Xdata[9]), 0)),
            # #         str(round(int(Xdata[10]), 0))
            # #     ],
            # #     rotation=0,
            # #     ha='center',
            # #     fontdict={"family": "SimSun", "size": 7},
            # #     fontsize='xx-small'
            # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
            # axes_2.set_xticklabels(
            #     [str(round(int(Xdata[i]), 0)) for i in range(len(Xdata))],
            #     rotation=0,
            #     ha='center',
            #     fontdict={"family": "SimSun", "size": 7},
            #     fontsize='xx-small'
            # )
            for tl in axes_2.get_xticklabels():
                tl.set_rotation(0)
                tl.set_ha('center')
                tl.set_fontsize(7)
                tl.set_fontfamily('SimSun')
                # tl.set_color('red')
            # axes_2.set_yticks(YdataMean)  # Ydata;
            # # axes_2.set_yticklabels(
            # #     [
            # #         str(round(int(YdataMean[0]), 0)),
            # #         str(round(int(YdataMean[1]), 0)),
            # #         str(round(int(YdataMean[2]), 0)),
            # #         str(round(int(YdataMean[3]), 0)),
            # #         str(round(int(YdataMean[4]), 0)),
            # #         str(round(int(YdataMean[5]), 0)),
            # #         str(round(int(YdataMean[6]), 0)),
            # #         str(round(int(YdataMean[7]), 0)),
            # #         str(round(int(YdataMean[8]), 0)),
            # #         str(round(int(YdataMean[9]), 0)),
            # #         str(round(int(YdataMean[10]), 0))
            # #     ],
            # #     rotation=0,
            # #     ha='right',
            # #     fontdict={"family": "SimSun", "size": 7},
            # #     fontsize='xx-small'
            # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
            # axes_2.set_yticklabels(
            #     [str(round(int(YdataMean[i]), 0)) for i in range(len(YdataMean))],
            #     rotation=0,
            #     ha='right',
            #     fontdict={"family": "SimSun", "size": 7},
            #     fontsize='xx-small'
            # )
            for tl in axes_2.get_yticklabels():
                tl.set_rotation(0)
                tl.set_ha('right')
                tl.set_fontsize(7)
                tl.set_fontfamily('SimSun')
                # tl.set_color('red')
            axes_2.grid(True, which='major', linestyle=':', color='grey', linewidth=0.25, alpha=0.3)  # which='minor'
            axes_2.legend(
                loc='lower right',
                shadow=False,
                frameon=False,
                edgecolor='grey',
                framealpha=0,
                facecolor="none",
                prop={"family": "Times New Roman", "size": 7},
                fontsize='xx-small'
            )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
            axes_2.spines['left'].set_linewidth(0.1)
            # axes_2.spines['left'].set_visible(False)  # 去除邊框;
            axes_2.spines['top'].set_visible(False)
            axes_2.spines['right'].set_visible(False)
            # axes_2.spines['bottom'].set_visible(False)
            axes_2.spines['bottom'].set_linewidth(0.1)
            axes_2.set_title(
                "market timing model ( test )",
                fontdict={"family": "SimSun", "size": 7},
                fontsize='xx-small'
            )

            # # https://github.com/matplotlib/mplfinance
            # # 使用第三方擴展包「mplfinance」繪製日棒缐（K Days Line）圖;
            # # import mplfinance  # 導入第三方擴展包「mplfinance」，用於製作日棒缐（K Days Line）圖;
            # # from mplfinance.original_flavor import candlestick_ohlc as mplfinance_original_flavor_candlestick_ohlc  # 從第三方擴展包「mplfinance」中導入「original_flavor」模組的「candlestick_ohlc()」函數，用於繪製股票作日棒缐（K Days Line）圖;
            # mplfinance.plot(
            #     pandas.DataFrame({
            #         "Date": [str(item) for item in testData_index["date_transaction"]],  # testData_index["date_transaction"],
            #         "Open": testData_index["opening_price"],
            #         "High": testData_index["high_price"],
            #         "Low": testData_index["low_price"],
            #         "Close": testData_index["close_price"],
            #         "Volume": testData_index["turnover_volume"],
            #     }),
            #     type = "candle",  # 指定繪圖類型爲日棒缐圖（K Days Line），可取值：type="candle", type="line", type="renko", or type="pnf" ;
            #     mav = (
            #         # 1,  # 添加滑動平均缐（1 日）;
            #         5,  # 添加滑動平均缐（5 日~周）;
            #         20,  # 添加滑動平均缐（20 日~月）;
            #         60  # 添加滑動平均缐（60 日~季）;
            #     ),  # 添加滑動平均缐;
            #     volume = True,  # 添加成交量柱形圖;
            #     show_nontrading = False,  # 取 True 時，表示設定顯示非交易日，將非交易日添加爲空白;
            #     # study = [
            #     #     "macd",
            #     #     "rsi"
            #     # ],
            #     # macd_n_fast = 12,
            #     # macd_n_slow = 26,
            #     # rsi_n = 14,
            #     # style = mplfinance.make_mpf_style(
            #     #     gridaxis = "both",  # 設置圖片網格缐位置;
            #     #     gridstyle = "-.",  # 設置圖片網格缐形狀;
            #     #     y_on_right = False,  # 設置 y 軸位置是否在右側;
            #     #     marketcolors = mplfinance.make_marketcolors(
            #     #         up = "green",
            #     #         down = "red",
            #     #         edge = "i",  # 設置棒圖方框邊缐顔色，取 "i" 值，表示繼承參數：up、down 的顔色配置;
            #     #         wick = "i",  # 設置棒圖上下影缐顔色，，取 "i" 值，表示繼承參數：up、down 的顔色配置;
            #     #         volume = "in",  # 設置成交量柱形圖顔色;
            #     #         inherit = True  # 指定是否繼承;
            #     #     )
            #     # ),
            #     # savefig = {"fname": "stock_K_Days_Line.png"},  # 將圖片存儲爲硬盤文檔;
            #     ylabel = "transaction price",
            #     ylabel_lower = "shares\ntransaction volume",
            #     xlabel = "transaction date",
            #     title = "\nstock %s candle line" % (ticker_symbol),
            #     figratio = (15, 10),  # 設置圖片長、寬比;
            #     figscale = 5  # 設置圖片質量等級;
            # )

        # matplotlib_pyplot.xlabel('date transaction')  # 設置顯示橫軸標題為 'Independent Variable ( x )'
        # matplotlib_pyplot.ylabel('price transaction')  # 設置顯示縱軸標題為 'Dependent Variable ( y )'
        # # matplotlib_pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
        # matplotlib_pyplot.title('market timing model')  # 設置顯示圖標題;
        # # fig.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()  # 顯示圖片;
        # # plot_Thread = threading.Thread(target=matplotlib.pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;

        resultDict["fit-image"] = fig  # 擬合曲綫繪圖;

    return resultDict



# # 函數使用示例;
# import pickle  # 導入 Python 原生模組「pickle」，用於將結構化的内存數據直接備份到硬盤二進制文檔，以及從硬盤文檔直接導入結構化内存數據;
# # import string  # 加載Python原生的字符串處理模組;
# # import time  # 加載Python原生的日期數據處理模組;
# # import datetime  # 加載Python原生的日期數據處理模組;
# # 將字典（Dict）類型數據，寫入磁盤（hide disk）的 Python 語言特有類型的 pickle 類型（.pickle）的變量存儲文檔;
# # 使用 pickle 模組，從保存到硬盤的（.pickle）文檔，導入 Python 結構化的數據;
# pickle_K_Line_Daily_file = "C:/QuantitativeTrading/Data/steppingData.pickle"
# stepping_data = None
# with open(pickle_K_Line_Daily_file, "rb") as f:
#     stepping_data = pickle.load(f)
#     f.close()
# # print(stepping_data)
# # # 使用 pickle 模組，將 Python 字典類型的數據，保存到硬盤（.pickle）文檔;
# # with open(pickle_K_Line_Daily_file, "wb") as f:
# #     pickle.dump(stepping_data, f)
# #     f.close()

# training_data = {}
# training_data = stepping_data

# testing_data = {}
# testing_data = stepping_data

# return_MarketTiming_fit_model = MarketTiming_fit_model(
#     {"002611": training_data["002611"]},  # training_data,  # = Base.Dict{Core.String, Core.Any}(),  # = testing_data,  # Core.Array{float, 2}(undef, (0, 0)), # ::Core.Array{Core.Array{float, 1}, 1} = Core.Array{Core.Array{float, 1}, 1}(),
#     int(10),  # P1,  # 觀察收益率歷史向前推的交易日長度;
#     float(+0.58),  # P2  # 買入閾值;
#     float(-0.02),  # P3  # 賣出閾值;
#     float(0.0),  # P4,  # risk threshold drawdown loss; # 風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
#     Intuitive_Momentum_KLine,
#     "Long_Position_and_Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
# )
# print("y_profit = ", return_MarketTiming_fit_model["002611"]["y_profit"])  # 每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
# print("y_Long_Position_profit = ", return_MarketTiming_fit_model["002611"]["y_Long_Position_profit"])  # 每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
# print("y_Short_Selling_profit = ", return_MarketTiming_fit_model["002611"]["y_Short_Selling_profit"])  # 每兩次對衝交易利潤 × 頻率 × 權重，加權纍加總計;
# print("y_loss = ", return_MarketTiming_fit_model["002611"]["y_loss"])  # 每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
# print("y_Long_Position_loss = ", return_MarketTiming_fit_model["002611"]["y_Long_Position_loss"])  # 每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
# print("y_Short_Selling_loss = ", return_MarketTiming_fit_model["002611"]["y_Short_Selling_loss"])  # 每兩次對衝交易最大回撤 × 頻率 × 權重，加權取極值總計;
# print("profit_total = ", return_MarketTiming_fit_model["002611"]["profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
# print("profit_Positive = ", return_MarketTiming_fit_model["002611"]["profit_Positive"])  # 每兩次對衝交易收益纍加總計;
# print("profit_Negative = ", return_MarketTiming_fit_model["002611"]["profit_Negative"])  # 每兩次對衝交易損失纍加總計;
# print("Long_Position_profit_total = ", return_MarketTiming_fit_model["002611"]["Long_Position_profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
# print("Long_Position_profit_Positive = ", return_MarketTiming_fit_model["002611"]["Long_Position_profit_Positive"])  # 每兩次對衝交易收益纍加總計;
# print("Long_Position_profit_Negative = ", return_MarketTiming_fit_model["002611"]["Long_Position_profit_Negative"])  # 每兩次對衝交易損失纍加總計;
# print("Short_Selling_profit_total = ", return_MarketTiming_fit_model["002611"]["Short_Selling_profit_total"])  # 每兩次對衝交易利潤 × 頻率，纍加總計;
# print("Short_Selling_profit_Positive = ", return_MarketTiming_fit_model["002611"]["Short_Selling_profit_Positive"])  # 每兩次對衝交易收益纍加總計;
# print("Short_Selling_profit_Negative = ", return_MarketTiming_fit_model["002611"]["Short_Selling_profit_Negative"])  # 每兩次對衝交易損失纍加總計;
# print("profit_Positive_probability = ", return_MarketTiming_fit_model["002611"]["profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
# print("profit_Negative_probability = ", return_MarketTiming_fit_model["002611"]["profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
# print("Long_Position_profit_Positive_probability = ", return_MarketTiming_fit_model["002611"]["Long_Position_profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
# print("Long_Position_profit_Negative_probability = ", return_MarketTiming_fit_model["002611"]["Long_Position_profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
# print("Short_Selling_profit_Positive_probability = ", return_MarketTiming_fit_model["002611"]["Short_Selling_profit_Positive_probability"])  # 每兩次對衝交易正利潤概率;
# print("Short_Selling_profit_Negative_probability = ", return_MarketTiming_fit_model["002611"]["Short_Selling_profit_Negative_probability"])  # 每兩次對衝交易負利潤概率;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_profit_date_transaction"])  # 每兩次對衝交易利潤，向量;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_profit_date_transaction"])  # 每兩次對衝交易利潤，向量;
# print("maximum_drawdown = ", return_MarketTiming_fit_model["002611"]["maximum_drawdown"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
# print("maximum_drawdown_Long_Position = ", return_MarketTiming_fit_model["002611"]["maximum_drawdown_Long_Position"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
# print("maximum_drawdown_Short_Selling = ", return_MarketTiming_fit_model["002611"]["maximum_drawdown_Short_Selling"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
# # print("Long_Position_drawdown_date_transaction = ", return_MarketTiming_fit_model["002611"]["Long_Position_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
# # print("Short_Selling_drawdown_date_transaction = ", return_MarketTiming_fit_model["002611"]["Short_Selling_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
# print("average_price_amplitude_date_transaction = ", return_MarketTiming_fit_model["002611"]["average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
# print("Long_Position_average_price_amplitude_date_transaction = ", return_MarketTiming_fit_model["002611"]["Long_Position_average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
# print("Short_Selling_average_price_amplitude_date_transaction = ", return_MarketTiming_fit_model["002611"]["Short_Selling_average_price_amplitude_date_transaction"])  # 兩兩次對衝交易日成交價振幅平方和，均值;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_price_amplitude_date_transaction"])  # 兩次對衝交易日成交價振幅平方和，向量;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_price_amplitude_date_transaction"])  # 兩次對衝交易日成交價振幅平方和，向量;
# print("average_volume_turnover_date_transaction = ", return_MarketTiming_fit_model["002611"]["average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
# print("Long_Position_average_volume_turnover_date_transaction = ", return_MarketTiming_fit_model["002611"]["Long_Position_average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
# print("Short_Selling_average_volume_turnover_date_transaction = ", return_MarketTiming_fit_model["002611"]["Short_Selling_average_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）均值;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）向量;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_volume_turnover_date_transaction"])  # 兩次對衝交易日成交量（換手率）向量;
# print("average_date_transaction_between = ", return_MarketTiming_fit_model["002611"]["average_date_transaction_between"])  # 兩次交易間隔日長，均值;
# print("Long_Position_average_date_transaction_between = ", return_MarketTiming_fit_model["002611"]["Long_Position_average_date_transaction_between"])  # 兩次對衝交易間隔日長，均值;
# print("Short_Selling_average_date_transaction_between = ", return_MarketTiming_fit_model["002611"]["Short_Selling_average_date_transaction_between"])  # 兩次對衝交易間隔日長，均值;
# print("weight_MarketTiming = ", return_MarketTiming_fit_model["002611"]["weight_MarketTiming"])  # 擇時權重，每兩次對衝交易的盈利概率占比;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction_between"])  # 兩次對衝交易間隔日長，向量;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction_between"])  # 兩次對衝交易間隔日長，向量;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"])  # 按規則執行交易的日期，向量;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][0])  # 交易規則自動選取的交易日期;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][1])  # 交易規則自動選取的買入或賣出;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][2])  # 交易規則自動選取的成交價;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][3])  # 交易規則自動選取的成交量;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][4])  # 交易規則自動選取的成交次數記錄;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][5])  # 交易規則自動選取的交易日期的序列號，用於繪圖可視化;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][6])  # 交易日（datetime.date 類型）;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][7])  # 當日總成交量（turnover volume）;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][8])  # 當日開盤（opening）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][9])  # 當日收盤（closing）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][10])  # 當日最低（low）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][11])  # 當日最高（high）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][12])  # 當日總成交金額（turnover amount）;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][13])  # 當日成交量（turnover volume）換手率（turnover rate）;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][14])  # 當日每股收益（price earnings）;
# # print(return_MarketTiming_fit_model["002611"]["Long_Position_date_transaction"][15])  # 當日每股净值（book value per share）;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"])  # 按規則執行交易的日期，向量;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][0])  # 交易規則自動選取的交易日期;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][1])  # 交易規則自動選取的買入或賣出;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][2])  # 交易規則自動選取的成交價;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][3])  # 交易規則自動選取的成交量;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][4])  # 交易規則自動選取的成交次數記錄;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][5])  # 交易規則自動選取的交易日期的序列號，用於繪圖可視化;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][6])  # 交易日（datetime.date 類型）;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][7])  # 當日總成交量（turnover volume）;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][8])  # 當日開盤（opening）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][9])  # 當日收盤（closing）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][10])  # 當日最低（low）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][11])  # 當日最高（high）成交價;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][12])  # 當日總成交金額（turnover amount）;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][13])  # 當日成交量（turnover volume）換手率（turnover rate）;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][14])  # 當日每股收益（price earnings）;
# # print(return_MarketTiming_fit_model["002611"]["Short_Selling_date_transaction"][15])  # 當日每股净值（book value per share）;
# # print(return_MarketTiming_fit_model["002611"]["revenue_and_expenditure_records_date_transaction"])  # 每次交易的收支記錄序列，不區分做多（Long Position）或做空（Short Selling），向量;
# # print(return_MarketTiming_fit_model["002611"]["P1_Array"])  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;

# result = MarketTiming(
#     training_data = {"002611": training_data["002611"]},
#     testing_data = {"002611": testing_data["002611"]},
#     Pdata_0 = [int(3), float(+0.1), float(-0.1), float(0.0)],  # training_data["002611"]["Pdata_0"],
#     # weight = []  # training_data["002611"]["weight"],
#     Plower = [-math.inf, -math.inf, -math.inf, -math.inf],  # training_data["002611"]["Plower"],
#     Pupper = [+math.inf, +math.inf, +math.inf, +math.inf],  # training_data["002611"]["Pupper"],
#     MarketTiming_fit_model = MarketTiming_fit_model,
#     Quantitative_Indicators_Function = Intuitive_Momentum_KLine,
#     investment_method = "Long_Position_and_Short_Selling"  # "Long_Position_and_Short_Selling" , "Long_Position" , "Short_Selling" ;
# )
# print("Coefficient : ", result["002611"]["Coefficient"])  # 優化得到的參數;
# # print(result["002611"]["P1_Array"])  # 依照擇時規則計算得到參數 P1 值的序列存儲數組;
# print("profit total per share : ", result["002611"]["testData"]["profit_total"])
# print("profit positive per share : ", result["002611"]["testData"]["profit_Positive"])
# print("profit negative per share : ", result["002611"]["testData"]["profit_Negative"])
# print("Long Position profit total per share : ", result["002611"]["testData"]["Long_Position_profit_total"])
# print("Long Position profit positive per share : ", result["002611"]["testData"]["Long_Position_profit_Positive"])
# print("Long Position profit negative per share : ", result["002611"]["testData"]["Long_Position_profit_Negative"])
# print("Short Selling profit total per share : ", result["002611"]["testData"]["Short_Selling_profit_total"])
# print("Short Selling profit positive per share : ", result["002611"]["testData"]["Short_Selling_profit_Positive"])
# print("Short Selling profit negative per share : ", result["002611"]["testData"]["Short_Selling_profit_Negative"])
# print("maximum drawdown per share : ", result["002611"]["testData"]["maximum_drawdown"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
# print("maximum drawdown Long Position per share : ", result["002611"]["testData"]["maximum_drawdown_Long_Position"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
# print("maximum drawdown Short Selling per share : ", result["002611"]["testData"]["maximum_drawdown_Short_Selling"])  # 兩次對衝交易之間的最大回撤值，取極值統計;
# # print("Long Position drawdown date transaction : ", result["002611"]["testData"]["Long_Position_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
# # print("Short Selling drawdown date transaction : ", result["002611"]["testData"]["Short_Selling_drawdown_date_transaction"])  # 向量，記錄做多模式每組對衝交易日的回撤值序列，風險控制閾值，强制平倉，可接受的最大回撤比例：Long_Position = sell_price ÷ buy_price、Short_Selling = 1 + ((sell_price - buy_price) ÷ sell_price) ;
# print("profit positive probability : ", result["002611"]["testData"]["profit_Positive_probability"])
# print("profit negative probability : ", result["002611"]["testData"]["profit_Negative_probability"])
# print("Long Position profit positive probability : ", result["002611"]["testData"]["Long_Position_profit_Positive_probability"])
# print("Long Position profit negative probability : ", result["002611"]["testData"]["Long_Position_profit_Negative_probability"])
# print("Short Selling profit positive probability : ", result["002611"]["testData"]["Short_Selling_profit_Positive_probability"])
# print("Short Selling profit negative probability : ", result["002611"]["testData"]["Short_Selling_profit_Negative_probability"])
# print("average date transaction between : ", result["002611"]["testData"]["average_date_transaction_between"])
# print("Long Position average date transaction between : ", result["002611"]["testData"]["Long_Position_average_date_transaction_between"])
# print("Short Selling average date transaction between : ", result["002611"]["testData"]["Short_Selling_average_date_transaction_between"])
# print("number Long Position date transaction : ", len(result["002611"]["testData"]["Long_Position_date_transaction"]))
# print("number Short Selling date transaction : ", len(result["002611"]["testData"]["Short_Selling_date_transaction"]))
# print("weight MarketTiming : ", result["002611"]["testData"]["weight_MarketTiming"])  # 擇時權重，每兩次對衝交易的盈利概率占比;
# # print(result["002611"]["testData"]["P1_Array"])
# # print(result["002611"]["testData"]["Long_Position_date_transaction"])
# # print(result["002611"]["testData"]["Short_Selling_date_transaction"])
# # print(result["002611"]["testData"])
# # result["fit-image"].savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
# # import matplotlib
# # matplotlib.pyplot.show()
# # plot_Thread = threading.Thread(target=matplotlib.pyplot.show, args=(), daemon=False)
# # plot_Thread.start()
# # matplotlib.pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
