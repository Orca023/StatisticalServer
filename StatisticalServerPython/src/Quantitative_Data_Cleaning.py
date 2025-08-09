# !/usr/bin/python3
# coding=utf-8

# # str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "Quantitative_Data_Cleaning.py")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/Quantitative_Data_Cleaning.py" # "/home/StatisticalServer/StatisticalServerPython/Quantitative_Data_Cleaning.py";
# Python_exe_path = str(sys.executable).replace('\\', '/')  # "C:/StatisticalServer/Python/Python311/python.exe" # "C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"
# print(Python_exe_path)  # "C:/StatisticalServer/Python/Python311/python.exe" # "C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"
# Python_program_path = str(sys.prefix).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/"
# print(Python_program_path)  # "C:/StatisticalServer/StatisticalServerPython/"
# Python_script_path = str(os.path.join(os.path.dirname(os.path.realpath(__file__)), "Quantitative_Data_Cleaning.py")).replace('\\', '/')  # "C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py" # "/home/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py";
# print(Python_script_path)  # "C:/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py" # "/home/StatisticalServer/StatisticalServerPython/src/Quantitative_Data_Cleaning.py";


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
# C:\QuantitativeTrading> C:/QuantitativeTrading/Python/Python311/python.exe C:/QuantitativeTrading/QuantitativeTradingPython/src/Quantitative_Data_Cleaning.py configFile=C:/QuantitativeTrading/QuantitativeTradingPython/config.txt input_K_Line=C:/QuantitativeTrading/Data/K-Day-source/ is_save_pickle=True output_pickle_K_Line=C:/QuantitativeTrading/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=C:/QuantitativeTrading/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=C:/QuantitativeTrading/Data/K-Day/
# root@localhost:~# /usr/bin/python3 /home/QuantitativeTrading/QuantitativeTradingPython/src/Quantitative_Data_Cleaning.py configFile=/home/QuantitativeTrading/QuantitativeTradingPython/config.txt input_K_Line=/home/QuantitativeTrading/Data/K-Day-source/ is_save_pickle=True output_pickle_K_Line=C:/QuantitativeTrading/Data/steppingData.pickle is_save_csv=False output_csv_K_Line=/home/QuantitativeTrading/Data/K-Day/ is_save_xlsx=False output_xlsx_K_Line=/home/QuantitativeTrading/Data/K-Day/

#################################################################################


import math  # 導入 Python 原生包「math」，用於數學計算;
# import random  # 導入 Python 原生包「random」，用於生成隨機數;
import copy  # 導入 Python 原生包「copy」，用於對字典對象的複製操作（深複製（傳值）、潛複製（傳址））;
import json  # 導入 Python 原生模組「json」，用於解析 JSON 文檔;
import csv  # 導入 Python 原生模組「csv」，用於解析 .csv 文檔;
import pickle  # 導入 Python 原生模組「pickle」，用於將結構化的内存數據直接備份到硬盤二進制文檔，以及從硬盤文檔直接導入結構化内存數據;
# import multiprocessing
# from multiprocessing import Pool
import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
import string  # 加載Python原生的字符串處理模組;
# import time  # 加載Python原生的日期數據處理模組;
import datetime  # 加載Python原生的日期數據處理模組;
# import warnings
# # warnings.filterwarnings("ignore")  # 設置控制臺不打印所有警告信息;
# warnings.filterwarnings("ignore", category=RuntimeWarning)  # 設置控制臺不打印指定（category = RuntimeWarning）的特定警告信息;
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
import pandas  # as pd
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
# from scipy.optimize import minimize as scipy_optimize_minimize  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「minimize()」函數，用於通用形式優化問題求解（optimization）;
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

# 匯入自定義的量化交易指標計算模組脚本文檔「./Quantitative_Indicators.py」;
import Quantitative_Indicators as Quantitative_Indicators  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Router.py」;
Intuitive_Momentum = Quantitative_Indicators.Intuitive_Momentum
Intuitive_Momentum_KLine = Quantitative_Indicators.Intuitive_Momentum_KLine
# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["ticker_symbol"]["close_price"],  # = [],
#     int(3),  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# )
# print("closing price growth rate", return_Intuitive_Momentum)
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
# print("turnover volume growth rate", return_Intuitive_Momentum_KLine["P1_turnover_volume_growth_rate"])
# print("opening price growth rate", return_Intuitive_Momentum_KLine["P1_opening_price_growth_rate"])
# print("closing price growth rate", return_Intuitive_Momentum_KLine["P1_closing_price_growth_rate"])
# print("closing minus opening price growth rate", return_Intuitive_Momentum_KLine["P1_closing_minus_opening_price_growth_rate"])
# print("high price proportion", return_Intuitive_Momentum_KLine["P1_high_price_proportion"])
# print("low price proportion", return_Intuitive_Momentum_KLine["P1_low_price_proportion"])
# print("intuitive momentum indicator", return_Intuitive_Momentum_KLine["P1_Intuitive_Momentum"])



# 測試集日棒缐（K Line Daily）數據標準化（Standardization）;
# ticker_symbol = str("002611")  # 流通代碼;
# shares_tradable = int(200000)  # 可流通量;
# date_transaction = [datetime.date("2024-01-02").strftime("%Y-%m-%d")]  # 交易日期;
# opening_price = [float(0.0)]  # 交易日首筆成交價（開盤價）;
# close_price = [float(0.0)]  # 交易日尾筆成交價（收盤價）;
# low_price = [float(0.0)]  # 交易日最低成交價;
# high_price = [float(0.0)]  # 交易日最高成交價;
# turnover_volume = [int(0.0)]  # 交易日總成交量;
# turnover_rate = [float(0.0)]  # 交易日換手率;
# price_earnings = [float(0.0)]  # 市盈率;
# book_value_per_share = [float(0.0)]  # 净值;
# moving_average_5 = [None,float(0.0)]  # 五日尾筆成交價（收盤價）移動平均（Moving Average）;
# moving_average_10 = [None,float(0.0)]  # 十日尾筆成交價（收盤價）移動平均（Moving Average）;
# moving_average_20 = [None,float(0.0)]  # 二十日尾筆成交價（收盤價）移動平均（Moving Average）;
# moving_average_30 = [None,float(0.0)]  # 三十日尾筆成交價（收盤價）移動平均（Moving Average）;

# K_Line_Daily = {
#     str(ticker_symbol): {
#         "shares_tradable": int(0),
#         # "date_transaction": [datetime.datetime("2024-08-09T12:29:41.518000").strftime("%Y-%m-%d %H:%M:%S.%f")],
#         "date_transaction": [datetime.date("2024-08-09").strftime("%Y-%m-%d")],
#         "opening_price": [float(0.0)],
#         "close_price": [float(0.0)],
#         "low_price": [float(0.0)],
#         "high_price": [float(0.0)],
#         "turnover_volume": [int(0.0)],
#         "turnover_rate": [float(0.0)],
#         "price_earnings": [float(0.0)],
#         "book_value_per_share": [float(0.0)],
#         "moving_average_5": [None,float(0.0)],
#         "moving_average_10": [None,float(0.0)],
#         "moving_average_20": [None,float(0.0)],
#         "moving_average_30": [None,float(0.0)],
#     },
# }

# K_Line_Daily = {
#     str(ticker_symbol): {
#         str(date_transaction): {
#             "opening_price": float(0.0),
#             "close_price": float(0.0),
#             "low_price": float(0.0),
#             "high_price": float(0.0),
#             "turnover_volume": int(0.0),
#             "turnover_rate": float(0.0),
#             "price_earnings": float(0.0),
#             "book_value_per_share": float(0.0),
#             "moving_average_5": None,float(0.0),
#             "moving_average_10": None,float(0.0),
#             "moving_average_20": None,float(0.0),
#             "moving_average_30": None,float(0.0)
#         }
#     },
# }


# # import json  # 導入 Python 原生模組「json」，用於解析 JSON 文檔;
# # json.loads(s[, encoding[, cls[, object_hook[, parse_float[, parse_int[, parse_constant[, object_pairs_hook[, **kw]]]]]]]])
# # json.dumps(obj, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, encoding="utf-8", default=None, sort_keys=False, **kw)
# # 將字符串（String）類型的日棒缐（K Line Daily）數據集，轉化爲 Python 字典（Python-Dictionary）類型的日棒缐（K Line Daily）數據集;
# input_K_Line_Daily_Dict = json.loads(input_K_Line_Daily_String)
# # # 判斷字典中是否包含某個鍵;
# # if "date_transaction" in input_K_Line_Daily_Dict:
# # # 遍歷字典的鍵:值對;
# # if isinstance(input_K_Line_Daily_Dict, dict):
# #     for key, value in input_K_Line_Daily_Dict.items():
# #         print(key, ':', value)
# # # 獲取 JSON 的所有鍵;
# # Dict_keys = input_K_Line_Daily_Dict.keys()
# # # 遍歷數組;
# # if isinstance(input_K_Line_Daily_Dict, list):
# #     for idx, item in enumerate(input_K_Line_Daily_Dict):
# #         print(idx, ':', item)
# # for i in range(len(input_K_Line_Daily_Dict)):
# #     print(input_K_Line_Daily_Dict[i])
# # # 判斷變量類型是否爲字符串類型;
# # if isinstance(input_K_Line_Daily_Dict["date_transaction"][0], str):
# # # 判斷字符串中是否包含等號（"="）子字符串;
# # if str(input_K_Line_Daily_Dict["date_transaction"][0]).find("=") != -1:

# # 創建日棒缐（K Line Daily）數據載體數組（Python-Array）;
# date_transaction = []  # 測試集數據交易日期，datetime.date("2024-01-02").strftime("%Y-%m-%d")，datetime.datetime("2024-08-09T12:29:41.518000").strftime("%Y-%m-%d %H:%M:%S.%f") ;
# opening_price = []  # 測試集數據交易日首筆成交價（開盤價），float(0.0) ;
# close_price = []  # 測試集數據交易日尾筆成交價（收盤價），float(0.0) ;
# low_price = []  # 測試集數據交易日最低成交價，float(0.0) ;
# high_price = []  # 測試集數據交易日最高成交價，float(0.0) ;
# turnover_volume = []  # 測試集數據交易日總成交量，int(0) ;
# turnover_amount = []  # 測試集數據交易日總成交金額，float(0.0) ;
# turnover_rate = []  # 測試集數據交易日換手率，float(0.0) ;
# price_earnings = []  # 測試集數據市盈率，float(0.0) ;
# book_value_per_share = []  # 測試集數據净值，float(0.0) ;

# # 從字典（Dictionary）類型的日棒缐（K Line Daily）數據集中逐個讀取數據;
# if "date_transaction" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["date_transaction"]) > 0:
#     date_transaction = input_K_Line_Daily_Dict["date_transaction"]
# if "turnover_volume" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["turnover_volume"]) > 0:
#     turnover_volume = input_K_Line_Daily_Dict["turnover_volume"]
# if "turnover_amount" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["turnover_amount"]) > 0:
#     turnover_amount = input_K_Line_Daily_Dict["turnover_amount"]
# if "opening_price" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["opening_price"]) > 0:
#     opening_price = input_K_Line_Daily_Dict["opening_price"]
# if "close_price" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["close_price"]) > 0:
#     close_price = input_K_Line_Daily_Dict["close_price"]
# if "low_price" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["low_price"]) > 0:
#     low_price = input_K_Line_Daily_Dict["low_price"]
# if "high_price" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["high_price"]) > 0:
#     high_price = input_K_Line_Daily_Dict["high_price"]
# if "turnover_rate" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["turnover_rate"]) > 0:
#     turnover_rate = input_K_Line_Daily_Dict["turnover_rate"]
# if "price_earnings" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["price_earnings"]) > 0:
#     price_earnings = input_K_Line_Daily_Dict["price_earnings"]
# if "book_value_per_share" in input_K_Line_Daily_Dict and len(input_K_Line_Daily_Dict["book_value_per_share"]) > 0:
#     book_value_per_share = input_K_Line_Daily_Dict["book_value_per_share"]

# # 遍歷字典的鍵:值對;
# for key, value in input_K_Line_Daily_Dict.items():
#     # print("Key: ${key}, Value: ${value}")
#     if key == "date_transaction":
#         date_transaction = value
#         # if isinstance(value, list) and len(value) > 0:
#         #     for i in range(len(value)):
#         #         date_i = value[i]
#         #         if value[i] is None:
#         #             date_i = None
#         #         elif isinstance(value[i], str) and value[i] == "":
#         #             # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#         #             # date_i = str(value[i])
#         #             date_i = datetime.date(value[i])
#         #             # datetime.date(value[i])  # 2024-08-09
#         #             # datetime.date(value[i]).strftime("%Y-%m-%d")  # 2024-08-09
#         #             # datetime.datetime(value[i])  # 2024-08-09T12:29:41.518000
#         #             # datetime.datetime(value[i]).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09T12:29:41.518000
#         #         elif isinstance(value[i], int):
#         #             # date_i = int(value[i])
#         #             # the_Unix_time = now_day.timestamp()  # 1723177781.518 seconds  # 轉換爲時間戳;
#         #             # the_date_time = datetime.datetime.fromtimestamp(the_Unix_time)  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
#         #             # # the_date_time = (datetime.fromtimestamp(the_Unix_time)).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
#         #             date_i = datetime.datetime.fromtimestamp(value[i])  # 將時間戳轉換爲時間對象;
#         #         elif isinstance(value[i], datetime.date):
#         #             date_i = value[i]
#         #             # datetime.date(value[i])  # 2024-08-09
#         #             # datetime.date(value[i]).strftime("%Y-%m-%d")  # 2024-08-09
#         #             # datetime.datetime(value[i])  # 2024-08-09T12:29:41.518000
#         #             # datetime.datetime(value[i]).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09T12:29:41.518000
#         #         else:
#         #             date_i = value[i]
#         #         date_transaction.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#         # else:
#         #     date_transaction = value
#     if key == "turnover_volume":
#         turnover_volume = value
#         # if isinstance(value, list) and len(value) > 0:
#         #     for i in range(len(value)):
#         #         date_i = value[i]
#         #         if value[i] is None:
#         #             date_i = None
#         #         elif isinstance(value[i], str) and value[i] == "":
#         #             # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#         #             date_i = str(value[i])
#         #         elif isinstance(value[i], int):
#         #             date_i = int(value[i])
#         #         else:
#         #             date_i = value[i]
#         #         turnover_volume.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#         # else:
#         #     turnover_volume = value
#     if key == "turnover_amount":
#         turnover_amount = value
#         # if isinstance(value, list) and len(value) > 0:
#         #     for i in range(len(value)):
#         #         date_i = value[i]
#         #         if value[i] is None:
#         #             date_i = None
#         #         elif isinstance(value[i], str) and value[i] == "":
#         #             # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#         #             date_i = str(value[i])
#         #         elif isinstance(value[i], float):
#         #             date_i = float(value[i])
#         #         else:
#         #             date_i = value[i]
#         #         turnover_amount.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#         # else:
#         #     turnover_amount = value
#     if key == "opening_price":
#         opening_price = value
#         # if isinstance(value, list) and len(value) > 0:
#         #     for i in range(len(value)):
#         #         date_i = value[i]
#         #         if value[i] is None:
#         #             date_i = None
#         #         elif isinstance(value[i], str) and value[i] == "":
#         #             # str(value[i]).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#         #             date_i = str(value[i])
#         #         elif isinstance(value[i], float):
#         #             date_i = float(value[i])
#         #         else:
#         #             date_i = value[i]
#         #         opening_price.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#         # else:
#         #     opening_price = value
#     if key == "close_price":
#         close_price = value
#     if key == "low_price":
#         low_price = value
#     if key == "high_price":
#         high_price = value
#     if key == "turnover_rate":
#         turnover_rate = value
#     if key == "price_earnings":
#         price_earnings = value
#     if key == "book_value_per_share":
#         book_value_per_share = value

# # 從字典（Dictionary）類型的日棒缐（K Line Daily）數據集中逐個讀取數據;
# if isinstance(input_K_Line_Daily_Dict, dict):
#     # 遍歷字典的鍵:值對;
#     for key, value in input_K_Line_Daily_Dict.items():
#         # print("Key: ${key}, Value: ${value}")
#         date_i = key
#         date_i = datetime.date(date_i)
#         # datetime.date(value[i])  # 2024-08-09
#         # datetime.date(value[i]).strftime("%Y-%m-%d")  # 2024-08-09
#         # datetime.datetime(value[i])  # 2024-08-09T12:29:41.518000
#         # datetime.datetime(value[i]).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09T12:29:41.518000
#         # if isinstance(key, str):
#         #     # key == "" # str(key).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#         #     # date_i = str(key)
#         #     date_i = datetime.date(key)
#         #     # datetime.date(key)  # 2024-08-09
#         #     # datetime.date(key).strftime("%Y-%m-%d")  # 2024-08-09
#         #     # datetime.datetime(key)  # 2024-08-09T12:29:41.518000
#         #     # datetime.datetime(key).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09T12:29:41.518000
#         # elif isinstance(key, int):
#         #     # date_i = int(key)
#         #     # the_Unix_time = now_day.timestamp()  # 1723177781.518 seconds  # 轉換爲時間戳;
#         #     # the_date_time = datetime.datetime.fromtimestamp(the_Unix_time)  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
#         #     # # the_date_time = (datetime.fromtimestamp(the_Unix_time)).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09 12:29:41.518000  # 轉換爲日期對象;
#         #     date_i = datetime.datetime.fromtimestamp(key)  # 將時間戳轉換爲時間對象;
#         # elif isinstance(key, datetime.date):
#         #     date_i = key
#         #     # datetime.date(key)  # 2024-08-09
#         #     # datetime.date(key).strftime("%Y-%m-%d")  # 2024-08-09
#         #     # datetime.datetime(key)  # 2024-08-09T12:29:41.518000
#         #     # datetime.datetime(key).strftime("%Y-%m-%d %H:%M:%S.%f")  # 2024-08-09T12:29:41.518000
#         # else:
#         date_transaction.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#         if isinstance(value, dict):
#             # 遍歷字典的鍵:值對;
#             for key_1, value_1 in value.items():
#                 if key_1 == "turnover_volume":
#                     date_i = value_1
#                     # if value_1 is None:
#                     #     date_i = None
#                     # elif isinstance(value_1, str) and value_1 == "":
#                     #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = str(value_1)
#                     # elif isinstance(value_1, int):
#                     #     date_i = int(value_1)
#                     # else:
#                     #     date_i = value_1
#                     turnover_volume.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#                 if key_1 == "turnover_amount":
#                     date_i = value_1
#                     # if value_1 is None:
#                     #     date_i = None
#                     # elif isinstance(value_1, str) and value_1 == "":
#                     #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = str(value_1)
#                     # elif isinstance(value_1, float):
#                     #     date_i = float(value_1)
#                     # else:
#                     #     date_i = value_1
#                     turnover_amount.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#                 if key_1 == "opening_price":
#                     date_i = value_1
#                     # if value_1 is None:
#                     #     date_i = None
#                     # elif isinstance(value_1, str) and value_1 == "":
#                     #     # str(value_1).find("=") != -1  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = str(value_1)
#                     # elif isinstance(value_1, float):
#                     #     date_i = float(value_1)
#                     # else:
#                     #     date_i = value_1
#                     opening_price.append(date_i)  # 使用 .append() 函數在數組末尾追加推入新元素;
#                 if key_1 == "close_price":
#                     date_i = value_1
#                     close_price.append(date_i)
#                 if key_1 == "low_price":
#                     date_i = value_1
#                     low_price.append(date_i)
#                 if key_1 == "high_price":
#                     date_i = value_1
#                     high_price.append(date_i)
#                 if key_1 == "turnover_rate":
#                     date_i = value_1
#                     turnover_rate.append(date_i)
#                 if key_1 == "price_earnings":
#                     date_i = value_1
#                     price_earnings.append(date_i)
#                 if key_1 == "book_value_per_share":
#                     date_i = value_1
#                     book_value_per_share.append(date_i)

# stepping_data = {}
# stepping_data["date_transaction"] = date_transaction
# stepping_data["turnover_volume"] = turnover_volume
# stepping_data["turnover_amount"] = turnover_amount
# stepping_data["opening_price"] = opening_price
# stepping_data["close_price"] = close_price
# stepping_data["low_price"] = low_price
# stepping_data["high_price"] = high_price
# stepping_data["turnover_rate"] = turnover_rate
# stepping_data["price_earnings"] = price_earnings
# stepping_data["book_value_per_share"] = book_value_per_share


# 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值;
input_K_Line_Daily_Dict_String = str("")  # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值;

# 預設參數初值;
input_K_Line_Daily_file = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day-source")).replace('\\', '/')
input_K_Line_Daily_file = ""
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/"
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv"
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/SZ#002611.xlsx"
# print(input_K_Line_Daily_file)
is_save_pickle = False  # true or false;
output_pickle_K_Line_Daily_file = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "steppingData.pickle")).replace('\\', '/')  # "C:/QuantitativeTrading/Data/steppingData.pickle"
output_pickle_K_Line_Daily_file = ""
# print(output_pickle_K_Line_Daily_file)
is_save_csv = False  # true or false;
output_csv_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day")).replace('\\', '/')  # "C:/QuantitativeTrading/Data/K-Day/"
output_csv_K_Line_Daily_file_dir = ""
# print(output_csv_K_Line_Daily_file_dir)
is_save_xlsx = False  # true or false;
output_xlsx_K_Line_Daily_file_dir = str(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))), "Data", "K-Day")).replace('\\', '/')  # "C:/QuantitativeTrading/Data/K-Day/"
output_xlsx_K_Line_Daily_file_dir = ""
# print(output_xlsx_K_Line_Daily_file_dir)


# os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
# os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
configFile = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "config.txt")).replace('\\', '/')  # "C:/QuantitativeTrading/QuantitativeTradingPython/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingPython/config.txt"
configFile = ""
# configFile = pathlib.Path(os.path.abspath("..") + "config.txt")  # pathlib.Path("../config.txt")
# print(configFile)
# 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的配置文檔（config.txt）參數的保存路徑全名："C:/QuantitativeTrading/QuantitativeTradingPython/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingPython/config.txt" ;
# print(type(sys.argv))
# print(sys.argv)
if len(sys.argv) > 1:
    for i in range(len(sys.argv)):
        # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
        if i > 0:
            # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
            if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:
                if sys.argv[i].split("=", -1)[0] == "configFile":
                    configFile = sys.argv[i].split("=", -1)[1]  # 指定的配置文檔（config.txt）保存路徑全名："C:/QuantitativeTrading/QuantitativeTradingPython/config.txt" "/home/QuantitativeTrading/QuantitativeTradingPython/config.txt" ;
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
# "/home/QuantitativeTrading/QuantitativeTradingPython/config.txt"
# "C:/QuantitativeTrading/QuantitativeTradingPython/config.txt"
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
                # print("Config file = " + str(configFile))
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

                        # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/" ; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv" ; "C:/QuantitativeTrading/Data/SZ#002611.xlsx" ;
                        if line_Key == "input_K_Line":
                            input_K_Line_Daily_file = str(line_Value)  # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/"; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv"; "C:/QuantitativeTrading/Data/SZ#002611.xlsx";
                            # print("input K-Line file : ", input_K_Line_Daily_file)
                            continue
                        # "True / False";
                        elif line_Key == "is_save_pickle":
                            # is_save_pickle = bool(line_Value)  # 使用 bool() 將字符串類型(str)變量解析為布爾型變量，用於判別處理結果保存文檔類型的開關 "True / False";
                            is_save_pickle_name_str = line_Value  # "True" or "False";
                            if isinstance(is_save_pickle_name_str, str) and is_save_pickle_name_str != "" and (is_save_pickle_name_str == "True" or is_save_pickle_name_str == "true" or is_save_pickle_name_str == "TRUE" or is_save_pickle_name_str == "1"):
                                is_save_pickle = True
                            if isinstance(is_save_pickle_name_str, str) and (is_save_pickle_name_str == "" or is_save_pickle_name_str == "False" or is_save_pickle_name_str == "false" or is_save_pickle_name_str == "FALSE" or is_save_pickle_name_str == "0"):
                                is_save_pickle = False
                            # print("is save .pickle : ", is_save_pickle)
                            continue
                        # 用於輸出保存處理結果的（.pickle）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.pickle" ;
                        elif line_Key == "output_pickle_K_Line":
                            output_pickle_K_Line_Daily_file = str(line_Value)  # 用於輸出保存處理結果的（.pickle）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.pickle";
                            # print("output K-Line file ( .pickle ) : ", output_pickle_K_Line_Daily_file)
                            continue
                        # "True / False";
                        elif line_Key == "is_save_csv":
                            # is_save_csv = bool(line_Value)  # 使用 bool() 將字符串類型(str)變量解析為布爾型變量，用於判別處理結果保存文檔類型的開關 "True / False";
                            is_save_csv_name_str = line_Value  # "True" or "False";
                            if isinstance(is_save_csv_name_str, str) and is_save_csv_name_str != "" and (is_save_csv_name_str == "True" or is_save_csv_name_str == "true" or is_save_csv_name_str == "TRUE" or is_save_csv_name_str == "1"):
                                is_save_csv = True
                            if isinstance(is_save_csv_name_str, str) and (is_save_csv_name_str == "" or is_save_csv_name_str == "False" or is_save_csv_name_str == "false" or is_save_csv_name_str == "FALSE" or is_save_csv_name_str == "0"):
                                is_save_csv = False
                            # print("is save .csv : ", is_save_csv)
                            continue
                        # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                        elif line_Key == "output_csv_K_Line":
                            output_csv_K_Line_Daily_file_dir = str(line_Value)  # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                            # print("output K-Line file ( .csv ) directory : ", output_csv_K_Line_Daily_file_dir)
                            continue
                        # "True / False";
                        elif line_Key == "is_save_xlsx":
                            # is_save_xlsx = bool(line_Value)  # 使用 bool() 將字符串類型(str)變量解析為布爾型變量，用於判別處理結果保存文檔類型的開關 "True / False";
                            is_save_xlsx_name_str = line_Value  # "True" or "False";
                            if isinstance(is_save_xlsx_name_str, str) and is_save_xlsx_name_str != "" and (is_save_xlsx_name_str == "True" or is_save_xlsx_name_str == "true" or is_save_xlsx_name_str == "TRUE" or is_save_xlsx_name_str == "1"):
                                is_save_xlsx = True
                            if isinstance(is_save_xlsx_name_str, str) and (is_save_xlsx_name_str == "" or is_save_xlsx_name_str == "False" or is_save_xlsx_name_str == "false" or is_save_xlsx_name_str == "FALSE" or is_save_xlsx_name_str == "0"):
                                is_save_xlsx = False
                            # print("is save .xlsx : ", is_save_xlsx)
                            continue
                        # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                        elif line_Key == "output_xlsx_K_Line":
                            output_xlsx_K_Line_Daily_file_dir = str(line_Value)  # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                            # print("output K-Line file ( .xlsx ) directory : ", output_xlsx_K_Line_Daily_file_dir)
                            continue
                        # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" : [str(datetime.date("2024-08-09"))], "turnover_volume" : [int()], "opening_price" : [float()], "close_price" : [float()], "low_price" : [float()], "high_price" : [float()]}" ;
                        elif line_Key == "K_Line_source":
                            input_K_Line_Daily_Dict_String = str(line_Value)  # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" : [str(datetime.date("2024-08-09"))], "turnover_volume" : [int()], "opening_price" : [float()], "close_price" : [float()], "low_price" : [float()], "high_price" : [float()]}" ;
                            # print("input K-Line source JSON string :\n", input_K_Line_Daily_Dict_String)
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

                # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/" ; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv" ; "C:/QuantitativeTrading/Data/SZ#002611.xlsx" ;
                if sys.argv[i].split("=", -1)[0] == "input_K_Line":
                    input_K_Line_Daily_file = str(sys.argv[i].split("=", -1)[1])  # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/"; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv"; "C:/QuantitativeTrading/Data/SZ#002611.xlsx";
                    # print("input K-Line file : ", input_K_Line_Daily_file)
                    continue
                # "True / False";
                elif sys.argv[i].split("=", -1)[0] == "is_save_pickle":
                    # is_save_pickle = bool(sys.argv[i].split("=", -1)[1])  # 使用 bool() 函數將字符串類型(str)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "True / False";
                    is_save_pickle_name_str = sys.argv[i].split("=", -1)[1]  # "True" or "False";
                    if isinstance(is_save_pickle_name_str, str) and is_save_pickle_name_str != "" and (is_save_pickle_name_str == "True" or is_save_pickle_name_str == "true" or is_save_pickle_name_str == "TRUE" or is_save_pickle_name_str == "1"):
                        is_save_pickle = True
                    if isinstance(is_save_pickle_name_str, str) and (is_save_pickle_name_str == "" or is_save_pickle_name_str == "False" or is_save_pickle_name_str == "false" or is_save_pickle_name_str == "FALSE" or is_save_pickle_name_str == "0"):
                        is_save_pickle = False
                    # print("is save .pickle : ", is_save_pickle)
                    continue
                # 用於輸出保存處理結果的（.pickle）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.pickle" ;
                elif sys.argv[i].split("=", -1)[0] == "output_pickle_K_Line":
                    output_pickle_K_Line_Daily_file = str(sys.argv[i].split("=", -1)[1])  # 用於輸出保存處理結果的（.pickle）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.pickle";
                    # print("output K-Line file ( .pickle ) : ", output_pickle_K_Line_Daily_file)
                    continue
                # "True / False";
                elif sys.argv[i].split("=", -1)[0] == "is_save_csv":
                    # is_save_csv = bool(sys.argv[i].split("=", -1)[1])  # 使用 bool() 函數將字符串類型(str)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "True / False";
                    is_save_csv_name_str = sys.argv[i].split("=", -1)[1]  # "True" or "False";
                    if isinstance(is_save_csv_name_str, str) and is_save_csv_name_str != "" and (is_save_csv_name_str == "True" or is_save_csv_name_str == "true" or is_save_csv_name_str == "TRUE" or is_save_csv_name_str == "1"):
                        is_save_csv = True
                    if isinstance(is_save_csv_name_str, str) and (is_save_csv_name_str == "" or is_save_csv_name_str == "False" or is_save_csv_name_str == "false" or is_save_csv_name_str == "FALSE" or is_save_csv_name_str == "0"):
                        is_save_csv = False
                    # print("is save .csv : ", is_save_csv)
                    continue
                # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                elif sys.argv[i].split("=", -1)[0] == "output_csv_K_Line":
                    output_csv_K_Line_Daily_file_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                    # print("output K-Line file ( .csv ) directory : ", output_csv_K_Line_Daily_file_dir)
                    continue
                # "True / False";
                elif sys.argv[i].split("=", -1)[0] == "is_save_xlsx":
                    # is_save_xlsx = bool(sys.argv[i].split("=", -1)[1])  # 使用 bool() 函數將字符串類型(str)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "True / False";
                    is_save_xlsx_name_str = sys.argv[i].split("=", -1)[1]  # "True" or "False";
                    if isinstance(is_save_xlsx_name_str, str) and is_save_xlsx_name_str != "" and (is_save_xlsx_name_str == "True" or is_save_xlsx_name_str == "true" or is_save_xlsx_name_str == "TRUE" or is_save_xlsx_name_str == "1"):
                        is_save_xlsx = True
                    if isinstance(is_save_xlsx_name_str, str) and (is_save_xlsx_name_str == "" or is_save_xlsx_name_str == "False" or is_save_xlsx_name_str == "false" or is_save_xlsx_name_str == "FALSE" or is_save_xlsx_name_str == "0"):
                        is_save_xlsx = False
                    # print("is save .xlsx : ", is_save_xlsx)
                    continue
                # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                elif sys.argv[i].split("=", -1)[0] == "output_xlsx_K_Line":
                    output_xlsx_K_Line_Daily_file_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                    # print("output K-Line file ( .xlsx ) directory : ", output_xlsx_K_Line_Daily_file_dir)
                    continue
                # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" : [str(datetime.date("2024-08-09"))], "turnover_volume" : [int()], "opening_price" : [float()], "close_price" : [float()], "low_price" : [float()], "high_price" : [float()]}" ;
                elif sys.argv[i].split("=", -1)[0] == "K_Line_source":
                    input_K_Line_Daily_Dict_String = str(sys.argv[i].split("=", -1)[1])  # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" : [str(datetime.date("2024-08-09"))], "turnover_volume" : [int()], "opening_price" : [float()], "close_price" : [float()], "low_price" : [float()], "high_price" : [float()]}" ;
                    # print("input K-Line source JSON string :\n", input_K_Line_Daily_Dict_String)
                    continue
                else:
                    # print(sys.argv[i], "unrecognized.")
                    continue


# import pandas  # as pd
# from pandas import Series as pandas_Series  # 從第三方擴展包「pandas」中導入一維向量「Series」模組，用於構建擴展包「pandas」的一維向量「Series」類型變量;
# from pandas import DataFrame as pandas_DataFrame  # 從第三方擴展包「pandas」中導入二維矩陣「DataFrame」模組，用於構建擴展包「pandas」的二維矩陣「DataFrame」類型變量;
# import pyarrow
# import openpyxl
# import xlrd
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/"
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv"
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/SZ#002611.xlsx"
input_K_Line_Daily_Data = {}
# input_K_Line_Daily_Data = []
# 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;

if os.path.exists(input_K_Line_Daily_file) and os.path.isfile(input_K_Line_Daily_file):

    # file_path = str(os.path.dirname(input_K_Line_Daily_file))  # "C:/QuantitativeTrading/Data/K-Day";
    # file_name = str(os.path.basename(input_K_Line_Daily_file))  # "SZ#002611.csv" ;
    # file_name_2 = str(os.path.splitext(file_name)[1])  # ".csv" ;
    # file_name_1 = str(os.path.splitext(file_name)[0])  # "SZ#002611" ;
    # ticker_symbol = str(file_name_1.split("#")[1])  # "002611" ;

    ticker_symbol = str(str(os.path.splitext(str(os.path.basename(input_K_Line_Daily_file)))[0]).split("#")[1])  # "002611" ;
    input_K_Line_Daily_Data_I = None

    if str(os.path.splitext(str(os.path.basename(input_K_Line_Daily_file)))[1]) == str(".csv") or str(os.path.splitext(str(os.path.basename(input_K_Line_Daily_file)))[1]) == str(".txt"):

        input_K_Line_Daily_Data_Frame = None
        with open(input_K_Line_Daily_file, mode='r', newline='') as f:
            row_array = [row_list for row_list in csv.reader(f)]
            # csv_reader = csv.reader(f)
            # row_array = []
            # for row_list in csv_reader:
            #     row_array.append(row_list)
            # # print(row_array)
            # csv_reader = None  # 釋放内存;

            csvreader_name = []  # 列名稱;
            csvreader_date_transaction = []  # 測試集數據交易日期，datetime.date("2024-01-02").strftime("%Y-%m-%d")，datetime.datetime("2024-08-09T12:29:41.518000").strftime("%Y-%m-%d %H:%M:%S.%f") ;
            csvreader_opening_price = []  # 測試集數據交易日首筆成交價（開盤價），float(0.0) ;
            csvreader_close_price = []  # 測試集數據交易日尾筆成交價（收盤價），float(0.0) ;
            csvreader_low_price = []  # 測試集數據交易日最低成交價，float(0.0) ;
            csvreader_high_price = []  # 測試集數據交易日最高成交價，float(0.0) ;
            csvreader_turnover_volume = []  # 測試集數據交易日總成交量，int(0) ;
            csvreader_turnover_amount = []  # 測試集數據交易日總成交金額，float(0.0) ;
            # csvreader_turnover_rate = []  # 測試集數據交易日換手率，float(0.0) ;
            # csvreader_price_earnings = []  # 測試集數據市盈率，float(0.0) ;
            # csvreader_book_value_per_share = []  # 測試集數據净值，float(0.0) ;

            # skip_blank_lines = True,  # 跳過空行（row）;
            skiprows = 1  # 跳過首 1 行（row）;
            skiprows = int(int(skiprows) - int(1))
            header = 1  # 使用第 2 個橫向行（row）數據作爲數據框的列（column）名稱，取 header = None 時表示不包含列名稱;
            skipfooter = 1  # 跳過尾 1 行（row）;
            skipfooter = int(int(len(row_array)) - int(skipfooter))
            # print(skipfooter)
            for i in range(len(row_array)):
                # print(i, row_array[i])
                row = row_array[i]
                if i > skiprows and i < skipfooter:
                    # print(row)
                    if len(row) > 0:
                        # row.split(',')  # 以逗號爲分隔符，將字符串分割爲 1 維數組（list）;
                        if int(i) == int(header):
                            csvreader_name = [str(str(item).strip()) for item in str(str(row[0]).strip()).split('\t')]
                            # print(csvreader_name)
                        elif int(i) != int(header):
                            csvreader_date_transaction.append(row[0])  # 使用 .append() 函數在數組末尾追加推入新元素;
                            csvreader_opening_price.append(row[1])
                            csvreader_high_price.append(row[2])
                            csvreader_low_price.append(row[3])
                            csvreader_close_price.append(row[4])
                            csvreader_turnover_volume.append(row[5])
                            csvreader_turnover_amount.append(row[6])
                        # else:
            row_array = None  # 釋放内存;

            input_K_Line_Daily_Data_Frame = pandas.DataFrame({
                str(csvreader_name[0]): csvreader_date_transaction,
                str(csvreader_name[1]): csvreader_opening_price,
                str(csvreader_name[2]): csvreader_high_price,
                str(csvreader_name[3]): csvreader_low_price,
                str(csvreader_name[4]): csvreader_close_price,
                str(csvreader_name[5]): csvreader_turnover_volume,
                str(csvreader_name[6]): csvreader_turnover_amount,
            })

            csvreader_name = None  # 釋放内存;
            csvreader_date_transaction = None  # 釋放内存;
            csvreader_opening_price = None
            csvreader_close_price = None
            csvreader_low_price = None
            csvreader_high_price = None
            csvreader_turnover_volume = None
            csvreader_turnover_amount = None
            # csvreader_turnover_rate = None
            # csvreader_price_earnings = None
            # csvreader_book_value_per_share = None

            f.close()  # 關閉文檔;

        # input_K_Line_Daily_Data_Frame = pandas.read_csv(
        #     input_K_Line_Daily_file,
        #     header = 0,  # 使用第 2 個橫向行（row）數據作爲數據框的列（column）名稱，取 header = None 時表示不包含列名稱;
        #     skiprows = 1,  # range(1, 1),  # 跳過首 1 行;
        #     skipfooter = 1,  # range(1, 1),  # 跳過尾 1 行;
        #     skip_blank_lines = True,  # 跳過空行;
        #     # usecols = [
        #     #     0,  # "date_transaction",
        #     #     1,  # "opening_price",
        #     #     2,  # "close_price",
        #     #     3,  # "low_price",
        #     #     4,  # "high_price",
        #     #     5,  # "turnover_volume",
        #     #     6  # "turnover_amount"
        #     # ],  # 祇讀取指定的幾個列數據;
        #     # nrows = 5,  # 祇讀取前 5 行的數據;
        #     # names = [
        #     #     "date_transaction",
        #     #     "opening_price",
        #     #     "close_price",
        #     #     "low_price",
        #     #     "high_price",
        #     #     "turnover_volume",
        #     #     "turnover_amount"
        #     # ],
        #     index_col = None,  # 0,  # 指定使用哪一列（column）的數據，作爲行（row）索引，取 header = None 時表示不包含行（row）名稱;
        #     # dtype = {
        #     #     0 : datetime.date, # str, # datetime.datetime,
        #     #     5 : int,
        #     #     6 : float,
        #     #     1 : float,
        #     #     4 : float,
        #     #     3 : float,
        #     #     2 : float
        #     # },
        #     # dtype = {
        #     #     "date_transaction": datetime.date, # str, # datetime.datetime,
        #     #     "turnover_volume": int,
        #     #     "turnover_amount": float,
        #     #     "opening_price": float,
        #     #     "close_price": float,
        #     #     "low_price": float,
        #     #     "high_price": float
        #     # },
        #     # parse_dates = {
        #     #     0 : "%Y-%m-%d",  # "date_transaction": "%Y-%m-%d",
        #     # },  # 將指定列數據解析爲日期類型;
        #     parse_dates = False,  # 設定不將指定列數據解析爲日期類型;
        #     sep = ',',  # 指定 .csv 文件的分隔符號爲逗號（,）；
        #     # comment = '#',  # 指定行首的注釋標志符號爲井號（#），即不會讀取以井號（#）開頭的行數據;
        #     encoding = "utf-8",
        #     engine = "python"
        # )
        # print(input_K_Line_Daily_Data_Frame.head(7))

        input_K_Line_Daily_Data_I = pandas.DataFrame({
            input_K_Line_Daily_Data_Frame.columns.tolist()[0]: [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d").date() for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[0]).tolist()],  # [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d %H:%M:%S.%f").datetime() for item in input_K_Line_Daily_Data_Frame.iloc[:, input_K_Line_Daily_Data_Frame.columns.tolist()[0]].tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[1]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[1]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[2]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[2]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[3]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[3]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[4]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[4]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[5]: [int(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[5]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[6]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[6]).tolist()],
        })
        # print(input_K_Line_Daily_Data_I.head(7))

        input_K_Line_Daily_Data_Frame = None  # 釋放内存;

    elif str(os.path.splitext(str(os.path.basename(input_K_Line_Daily_file)))[1]) == str(".xlsx"):

        input_K_Line_Daily_Data_Frame = pandas.read_excel(
            input_K_Line_Daily_file,
            sheet_name = 0,  # "Sheet1",  # str(ticker_symbol),  # 指定讀取的工作簿（Sheet）名稱，預設值爲："Sheet1" ;
            # skiprows = range(1, 1),  # 跳過首 1 行;
            header = 0,  # 使用第 1 個橫向行（row）數據作爲數據框的列（column）名稱，取 header = None 時表示不包含列（column）名稱;
            # skip_footer = range(1, 1),  # 跳過尾 1 行;
            # usecols = [
            #     0,  # 'A', # "date_transaction",
            #     1,  # 'B', # "opening_price",
            #     2,  # 'C', # "close_price",
            #     3,  # 'D', # "low_price",
            #     4,  # 'E', # "high_price",
            #     5,  # 'F', # "turnover_volume",
            #     6  # 'G' # "turnover_amount"
            # ],  # 祇讀取指定的幾個列數據;
            # nrows = 416,  # 祇讀取前 416 行的數據;
            # names = [
            #     "date_transaction",
            #     "opening_price",
            #     "close_price",
            #     "low_price",
            #     "high_price",
            #     "turnover_volume",
            #     "turnover_amount"
            # ],
            index_col = None,  # 0,  # 指定使用哪一列（column）的數據，作爲行（row）索引，取 header = None 時表示不包含行（row）名稱;
            # dtype = {
            #     0 : datetime.date, # str, # datetime.datetime,
            #     5 : int,
            #     6 : float,
            #     1 : float,
            #     4 : float,
            #     3 : float,
            #     2 : float
            # },
            # dtype = {
            #     "A": datetime.date, # str, # datetime.datetime,  # "date_transaction"
            #     "B": int,  # "turnover_volume"
            #     "C": float,  # "turnover_amount"
            #     "D": float,  # "opening_price"
            #     "E": float,  # "close_price"
            #     "F": float,  # "low_price"
            #     "G": float  # "high_price"
            # },
            parse_dates = False,  # 將指定列數據解析爲日期類型;
            # parse_dates = {
            #     0 : "%Y-%m-%d",  # "date_transaction": "%Y-%m-%d",  # "%Y-%m-%d %H:%M:%S.%f"
            # },  # 將指定列數據解析爲日期類型;
            engine = "openpyxl"  # 指定解析引擎，，對於 .xlsx 文檔預設值爲："xlwt"，這裏設置爲：使用解析引擎「openpyxl」，需要事先安裝：pip install openpyxl 配置成功;
        )
        # print(input_K_Line_Daily_Data_Frame.head(7))

        input_K_Line_Daily_Data_Frame.dropna()  # 刪除空行;

        input_K_Line_Daily_Data_I = pandas.DataFrame({
            input_K_Line_Daily_Data_Frame.columns.tolist()[0]: [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d %H:%M:%S").date() for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[0]).tolist()],  # [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d %H:%M:%S.%f").datetime() for item in input_K_Line_Daily_Data_Frame.iloc[:, input_K_Line_Daily_Data_Frame.columns.tolist()[0]].tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[1]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[1]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[2]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[2]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[3]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[3]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[4]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[4]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[5]: [int(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[5]).tolist()],
            input_K_Line_Daily_Data_Frame.columns.tolist()[6]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[6]).tolist()],
        })
        # print(input_K_Line_Daily_Data_I.head(7))

        input_K_Line_Daily_Data_Frame = None  # 釋放内存;

    # else:

    input_K_Line_Daily_Data[ticker_symbol] = input_K_Line_Daily_Data_I
    # input_K_Line_Daily_Data.append(input_K_Line_Daily_Data_I)  # 使用 .append() 函數在數組末尾追加推入新元素;

    input_K_Line_Daily_Data_I = None  # 釋放内存;

elif os.path.exists(input_K_Line_Daily_file) and pathlib.Path(input_K_Line_Daily_file).is_dir():

    dir_list_Arror = os.listdir(input_K_Line_Daily_file)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
    # len(os.listdir(input_K_Line_Daily_file))
    # if len(os.listdir(input_K_Line_Daily_file)) > 0:
    for item in dir_list_Arror:

        # item == "SZ#002611.csv"
        # file_name_2 = str(os.path.splitext(item)[1])  # ".csv" ;
        # file_name_1 = str(os.path.splitext(item)[0])  # "SZ#002611" ;
        # ticker_symbol = str(file_name_1.split("#")[1])  # "002611" ;

        ticker_symbol = str(str(os.path.splitext(item)[0]).split("#")[1])  # "002611" ;
        input_K_Line_Daily_Data_I = None

        item_Path = str(os.path.join(str(input_K_Line_Daily_file), str(item)))  # 拼接本地當前目錄下的請求文檔名;
        statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

        if os.path.exists(item_Path) and os.path.isfile(item_Path):

            if str(os.path.splitext(str(os.path.basename(item_Path)))[1]) == str(".csv") or str(os.path.splitext(str(os.path.basename(item_Path)))[1]) == str(".txt"):

                input_K_Line_Daily_Data_Frame = None
                with open(item_Path, mode='r', newline='') as f:
                    row_array = [row_list for row_list in csv.reader(f)]
                    # csv_reader = csv.reader(f)
                    # row_array = []
                    # for row_list in csv_reader:
                    #     row_array.append(row_list)
                    # # print(row_array)
                    # csv_reader = None  # 釋放内存;

                    csvreader_name = []  # 列名稱;
                    csvreader_date_transaction = []  # 測試集數據交易日期，datetime.date("2024-01-02").strftime("%Y-%m-%d")，datetime.datetime("2024-08-09T12:29:41.518000").strftime("%Y-%m-%d %H:%M:%S.%f") ;
                    csvreader_opening_price = []  # 測試集數據交易日首筆成交價（開盤價），float(0.0) ;
                    csvreader_close_price = []  # 測試集數據交易日尾筆成交價（收盤價），float(0.0) ;
                    csvreader_low_price = []  # 測試集數據交易日最低成交價，float(0.0) ;
                    csvreader_high_price = []  # 測試集數據交易日最高成交價，float(0.0) ;
                    csvreader_turnover_volume = []  # 測試集數據交易日總成交量，int(0) ;
                    csvreader_turnover_amount = []  # 測試集數據交易日總成交金額，float(0.0) ;
                    # csvreader_turnover_rate = []  # 測試集數據交易日換手率，float(0.0) ;
                    # csvreader_price_earnings = []  # 測試集數據市盈率，float(0.0) ;
                    # csvreader_book_value_per_share = []  # 測試集數據净值，float(0.0) ;

                    # skip_blank_lines = True,  # 跳過空行（row）;
                    skiprows = 1  # 跳過首 1 行（row）;
                    skiprows = int(int(skiprows) - int(1))
                    header = 1  # 使用第 2 個橫向行（row）數據作爲數據框的列（column）名稱，取 header = None 時表示不包含列名稱;
                    skipfooter = 1  # 跳過尾 1 行（row）;
                    skipfooter = int(int(len(row_array)) - int(skipfooter))
                    # print(skipfooter)
                    for i in range(len(row_array)):
                        # print(i, row_array[i])
                        row = row_array[i]
                        if i > skiprows and i < skipfooter:
                            # print(row)
                            if len(row) > 0:
                                # row.split(',')  # 以逗號爲分隔符，將字符串分割爲 1 維數組（list）;
                                if int(i) == int(header):
                                    csvreader_name = [str(str(item).strip()) for item in str(str(row[0]).strip()).split('\t')]
                                    # print(csvreader_name)
                                elif int(i) != int(header):
                                    csvreader_date_transaction.append(row[0])  # 使用 .append() 函數在數組末尾追加推入新元素;
                                    csvreader_opening_price.append(row[1])
                                    csvreader_high_price.append(row[2])
                                    csvreader_low_price.append(row[3])
                                    csvreader_close_price.append(row[4])
                                    csvreader_turnover_volume.append(row[5])
                                    csvreader_turnover_amount.append(row[6])
                                # else:
                    row_array = None  # 釋放内存;

                    input_K_Line_Daily_Data_Frame = pandas.DataFrame({
                        str(csvreader_name[0]): csvreader_date_transaction,
                        str(csvreader_name[1]): csvreader_opening_price,
                        str(csvreader_name[2]): csvreader_high_price,
                        str(csvreader_name[3]): csvreader_low_price,
                        str(csvreader_name[4]): csvreader_close_price,
                        str(csvreader_name[5]): csvreader_turnover_volume,
                        str(csvreader_name[6]): csvreader_turnover_amount,
                    })

                    csvreader_name = None  # 釋放内存;
                    csvreader_date_transaction = None  # 釋放内存;
                    csvreader_opening_price = None
                    csvreader_close_price = None
                    csvreader_low_price = None
                    csvreader_high_price = None
                    csvreader_turnover_volume = None
                    csvreader_turnover_amount = None
                    # csvreader_turnover_rate = None
                    # csvreader_price_earnings = None
                    # csvreader_book_value_per_share = None

                    f.close()  # 關閉文檔;

                # input_K_Line_Daily_Data_Frame = pandas.read_csv(
                #     item_Path,
                #     header = 0,  # 使用第 2 個橫向行（row）數據作爲數據框的列（column）名稱，取 header = None 時表示不包含列名稱;
                #     skiprows = 1,  # range(1, 1),  # 跳過首 1 行;
                #     skipfooter = 1,  # range(1, 1),  # 跳過尾 1 行;
                #     skip_blank_lines = True,  # 跳過空行;
                #     # usecols = [
                #     #     0,  # "date_transaction",
                #     #     1,  # "opening_price",
                #     #     2,  # "close_price",
                #     #     3,  # "low_price",
                #     #     4,  # "high_price",
                #     #     5,  # "turnover_volume",
                #     #     6  # "turnover_amount"
                #     # ],  # 祇讀取指定的幾個列數據;
                #     # nrows = 5,  # 祇讀取前 5 行的數據;
                #     # names = [
                #     #     "date_transaction",
                #     #     "opening_price",
                #     #     "close_price",
                #     #     "low_price",
                #     #     "high_price",
                #     #     "turnover_volume",
                #     #     "turnover_amount"
                #     # ],
                #     index_col = None,  # 0,  # 指定使用哪一列（column）的數據，作爲行（row）索引，取 header = None 時表示不包含行（row）名稱;
                #     # dtype = {
                #     #     0 : datetime.date, # str, # datetime.datetime,
                #     #     5 : int,
                #     #     6 : float,
                #     #     1 : float,
                #     #     4 : float,
                #     #     3 : float,
                #     #     2 : float
                #     # },
                #     # dtype = {
                #     #     "date_transaction": datetime.date, # str, # datetime.datetime,
                #     #     "turnover_volume": int,
                #     #     "turnover_amount": float,
                #     #     "opening_price": float,
                #     #     "close_price": float,
                #     #     "low_price": float,
                #     #     "high_price": float
                #     # },
                #     # parse_dates = {
                #     #     0 : "%Y-%m-%d",  # "date_transaction": "%Y-%m-%d",
                #     # },  # 將指定列數據解析爲日期類型;
                #     parse_dates = False,  # 設定不將指定列數據解析爲日期類型;
                #     sep = ',',  # 指定 .csv 文件的分隔符號爲逗號（,）；
                #     # comment = '#',  # 指定行首的注釋標志符號爲井號（#），即不會讀取以井號（#）開頭的行數據;
                #     encoding = "utf-8",
                #     engine = "python"
                # )
                # print(input_K_Line_Daily_Data_Frame.head(7))

                input_K_Line_Daily_Data_I = pandas.DataFrame({
                    input_K_Line_Daily_Data_Frame.columns.tolist()[0]: [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d").date() for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[0]).tolist()],  # [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d %H:%M:%S.%f").datetime() for item in input_K_Line_Daily_Data_Frame.iloc[:, input_K_Line_Daily_Data_Frame.columns.tolist()[0]].tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[1]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[1]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[2]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[2]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[3]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[3]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[4]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[4]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[5]: [int(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[5]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[6]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[6]).tolist()],
                })
                # print(input_K_Line_Daily_Data_I.head(7))

                input_K_Line_Daily_Data_Frame = None  # 釋放内存;

            elif str(os.path.splitext(str(os.path.basename(item_Path)))[1]) == str(".xlsx"):

                input_K_Line_Daily_Data_Frame = pandas.read_excel(
                    item_Path,
                    sheet_name = 0,  # "Sheet1",  # str(ticker_symbol),  # 指定讀取的工作簿（Sheet）名稱，預設值爲："Sheet1" ;
                    # skiprows = range(1, 1),  # 跳過首 1 行;
                    header = 0,  # 使用第 1 個橫向行（row）數據作爲數據框的列（column）名稱，取 header = None 時表示不包含列（column）名稱;
                    # skip_footer = range(1, 1),  # 跳過尾 1 行;
                    # usecols = [
                    #     0,  # 'A', # "date_transaction",
                    #     1,  # 'B', # "opening_price",
                    #     2,  # 'C', # "close_price",
                    #     3,  # 'D', # "low_price",
                    #     4,  # 'E', # "high_price",
                    #     5,  # 'F', # "turnover_volume",
                    #     6  # 'G' # "turnover_amount"
                    # ],  # 祇讀取指定的幾個列數據;
                    # nrows = 416,  # 祇讀取前 416 行的數據;
                    # names = [
                    #     "date_transaction",
                    #     "opening_price",
                    #     "close_price",
                    #     "low_price",
                    #     "high_price",
                    #     "turnover_volume",
                    #     "turnover_amount"
                    # ],
                    index_col = None,  # 0,  # 指定使用哪一列（column）的數據，作爲行（row）索引，取 header = None 時表示不包含行（row）名稱;
                    # dtype = {
                    #     0 : datetime.date, # str, # datetime.datetime,
                    #     5 : int,
                    #     6 : float,
                    #     1 : float,
                    #     4 : float,
                    #     3 : float,
                    #     2 : float
                    # },
                    # dtype = {
                    #     "A": datetime.date, # str, # datetime.datetime,  # "date_transaction"
                    #     "B": int,  # "turnover_volume"
                    #     "C": float,  # "turnover_amount"
                    #     "D": float,  # "opening_price"
                    #     "E": float,  # "close_price"
                    #     "F": float,  # "low_price"
                    #     "G": float  # "high_price"
                    # },
                    parse_dates = False,  # 將指定列數據解析爲日期類型;
                    # parse_dates = {
                    #     0 : "%Y-%m-%d",  # "date_transaction": "%Y-%m-%d",  # "%Y-%m-%d %H:%M:%S.%f"
                    # },  # 將指定列數據解析爲日期類型;
                    engine = "openpyxl"  # 指定解析引擎，，對於 .xlsx 文檔預設值爲："xlwt"，這裏設置爲：使用解析引擎「openpyxl」，需要事先安裝：pip install openpyxl 配置成功;
                )
                # print(input_K_Line_Daily_Data_Frame.head(7))

                input_K_Line_Daily_Data_Frame.dropna()  # 刪除空行;

                input_K_Line_Daily_Data_I = pandas.DataFrame({
                    input_K_Line_Daily_Data_Frame.columns.tolist()[0]: [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d %H:%M:%S").date() for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[0]).tolist()],  # [datetime.datetime.strptime(str(str(str(item).replace("/", "-")).strip()), "%Y-%m-%d %H:%M:%S.%f").datetime() for item in input_K_Line_Daily_Data_Frame.iloc[:, input_K_Line_Daily_Data_Frame.columns.tolist()[0]].tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[1]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[1]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[2]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[2]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[3]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[3]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[4]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[4]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[5]: [int(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[5]).tolist()],
                    input_K_Line_Daily_Data_Frame.columns.tolist()[6]: [float(item) for item in input_K_Line_Daily_Data_Frame.get(input_K_Line_Daily_Data_Frame.columns.tolist()[6]).tolist()],
                })
                # print(input_K_Line_Daily_Data_I.head(7))

                input_K_Line_Daily_Data_Frame = None  # 釋放内存;

        # elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
        # else:

        input_K_Line_Daily_Data[ticker_symbol] = input_K_Line_Daily_Data_I
        # input_K_Line_Daily_Data.append(input_K_Line_Daily_Data_I)  # 使用 .append() 函數在數組末尾追加推入新元素;

        input_K_Line_Daily_Data_I = None  # 釋放内存;

# input_K_Line_Daily_Dict = []
# for i in range(len(input_K_Line_Daily_Data)):
#     input_K_Line_Daily_Dict_I = {}
#     input_K_Line_Daily_Dict_I["date_transaction"] = input_K_Line_Daily_Data[i].iloc[:, 0].tolist()  # 參數 .iloc[:, 0].tolist() 表示獲取數據框（pandas.DataFrame）第 1 列的全部值轉換爲 1 維數組（list）;
#     # print(input_K_Line_Daily_Dict_I["date_transaction"])
#     input_K_Line_Daily_Dict_I["opening_price"] = input_K_Line_Daily_Data[i].iloc[:, 1].tolist()
#     # print(input_K_Line_Daily_Dict_I["opening_price"])
#     input_K_Line_Daily_Dict_I["close_price"] = input_K_Line_Daily_Data[i].iloc[:, 4].tolist()
#     # print(input_K_Line_Daily_Dict_I["close_price"])
#     input_K_Line_Daily_Dict_I["low_price"] = input_K_Line_Daily_Data[i].iloc[:, 3].tolist()
#     # print(input_K_Line_Daily_Dict_I["low_price"])
#     input_K_Line_Daily_Dict_I["high_price"] = input_K_Line_Daily_Data[i].iloc[:, 2].tolist()
#     # print(input_K_Line_Daily_Dict_I["high_price"])
#     input_K_Line_Daily_Dict_I["turnover_volume"] = input_K_Line_Daily_Data[i].iloc[:, 5].tolist()
#     # print(input_K_Line_Daily_Dict_I["turnover_volume"])
#     input_K_Line_Daily_Dict_I["turnover_amount"] = input_K_Line_Daily_Data[i].iloc[:, 6].tolist()
#     # print(input_K_Line_Daily_Dict_I["turnover_amount"])
#     input_K_Line_Daily_Dict.append(input_K_Line_Daily_Dict_I)  # 使用 .append() 函數在數組末尾追加推入新元素;
#     input_K_Line_Daily_Dict_I = None

input_K_Line_Daily_Dict = {}
for key, value in input_K_Line_Daily_Data.items():
    # print("Key: ${key}, Value: ${value}")
    input_K_Line_Daily_Dict_I = {}
    input_K_Line_Daily_Dict_I["date_transaction"] = value.iloc[:, 0].tolist()  # 參數 .iloc[:, 0].tolist() 表示獲取數據框（pandas.DataFrame）第 1 列的全部值轉換爲 1 維數組（list）;
    # print(input_K_Line_Daily_Dict_I["date_transaction"])
    input_K_Line_Daily_Dict_I["opening_price"] = value.iloc[:, 1].tolist()
    # print(input_K_Line_Daily_Dict_I["opening_price"])
    input_K_Line_Daily_Dict_I["close_price"] = value.iloc[:, 4].tolist()
    # print(input_K_Line_Daily_Dict_I["close_price"])
    input_K_Line_Daily_Dict_I["low_price"] = value.iloc[:, 3].tolist()
    # print(input_K_Line_Daily_Dict_I["low_price"])
    input_K_Line_Daily_Dict_I["high_price"] = value.iloc[:, 2].tolist()
    # print(input_K_Line_Daily_Dict_I["high_price"])
    input_K_Line_Daily_Dict_I["turnover_volume"] = value.iloc[:, 5].tolist()
    # print(input_K_Line_Daily_Dict_I["turnover_volume"])
    input_K_Line_Daily_Dict_I["turnover_amount"] = value.iloc[:, 6].tolist()
    # print(input_K_Line_Daily_Dict_I["turnover_amount"])
    input_K_Line_Daily_Dict[key] = input_K_Line_Daily_Dict_I
    input_K_Line_Daily_Dict_I = None
# print(len(input_K_Line_Daily_Dict))
# print(input_K_Line_Daily_Dict.keys())

input_K_Line_Daily_Data = None  # 釋放内存;

# 從控制臺傳入值，初始日棒缐（K-Line）初始數據字典字符串，轉換爲 Python 的字典（dict）類型;
if isinstance(input_K_Line_Daily_Dict_String, str) and (len(input_K_Line_Daily_Dict_String) > 0):
    input_K_Line_Daily_Dict = json.loads(input_K_Line_Daily_Dict_String)  # 使用 Python 原生 JSON 模組中的 json.loads() 函數將 JSON 字符串轉換爲 Python 字典（dict）對象;

# 計算加載數據中不包括的，自定義的觀測數據參數;
if isinstance(input_K_Line_Daily_Dict, dict):
    for key, value in input_K_Line_Daily_Dict.items():
        # print(key)
        if isinstance(value, dict):
            if ("opening_price" in value and isinstance(value["opening_price"], list) and len(value["opening_price"]) > 0) and ("close_price" in value and isinstance(value["close_price"], list) and len(value["close_price"]) > 0) and ("low_price" in value and isinstance(value["low_price"], list) and len(value["low_price"]) > 0) and ("high_price" in value and isinstance(value["high_price"], list) and len(value["high_price"]) > 0):
                # 計算訓練集日棒缐（K Line Daily）數據本徵（characteristic）;
                K_Line_focus = []  # 訓練集日棒缐（K Line Daily）數據的重心值（Focus）;
                K_Line_amplitude = []  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                K_Line_amplitude_rate = []  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                K_Line_opening_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                K_Line_closing_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                K_Line_low_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                K_Line_high_price_Standardization = []  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                K_Line_turnover_rate = []  # 交易日換手率;
                K_Line_price_earnings = []  # 每股市盈率;
                K_Line_book_value_per_share = []  # 每股净值;
                K_Line_capitalization = []  # 總市值;
                K_Line_turnover_volume_growth_rate = []  # 訓練集日棒缐（K Line Daily）數據，計算相鄰兩個交易日之間成交股票數量的變化率值的序列;
                K_Line_opening_price_growth_rate = []  # 訓練集日棒缐（K Line Daily）數據，計算相鄰兩個交易日之間開盤股票價格的變化率值的序列;
                K_Line_closing_price_growth_rate = []  # 訓練集日棒缐（K Line Daily）數據，計算相鄰兩個交易日之間收盤股票價格的變化率值的序列;
                K_Line_closing_minus_opening_price_growth_rate = []  # 訓練集日棒缐（K Line Daily）數據，計算每個交易日股票收盤價格減去開盤價格的變化率值的序列;
                K_Line_high_price_proportion = []  # 訓練集日棒缐（K Line Daily）數據，計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列;
                K_Line_low_price_proportion = []  # 訓練集日棒缐（K Line Daily）數據，計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列;
                K_Line_sum_2_turnover_volume_growth_rate = []
                K_Line_sum_2_opening_price_growth_rate = []
                K_Line_sum_2_closing_price_growth_rate = []
                K_Line_sum_2_closing_minus_opening_price_growth_rate = []
                K_Line_sum_2_high_price_proportion = []
                K_Line_sum_2_low_price_proportion = []
                K_Line_sum_2_KLine_Intuitive_Momentum = []
                K_Line_sum_3_turnover_volume_growth_rate = []
                K_Line_sum_3_opening_price_growth_rate = []
                K_Line_sum_3_closing_price_growth_rate = []
                K_Line_sum_3_closing_minus_opening_price_growth_rate = []
                K_Line_sum_3_high_price_proportion = []
                K_Line_sum_3_low_price_proportion = []
                K_Line_sum_3_KLine_Intuitive_Momentum = []
                K_Line_sum_5_turnover_volume_growth_rate = []
                K_Line_sum_5_opening_price_growth_rate = []
                K_Line_sum_5_closing_price_growth_rate = []
                K_Line_sum_5_closing_minus_opening_price_growth_rate = []
                K_Line_sum_5_high_price_proportion = []
                K_Line_sum_5_low_price_proportion = []
                K_Line_sum_5_KLine_Intuitive_Momentum = []
                K_Line_sum_7_turnover_volume_growth_rate = []
                K_Line_sum_7_opening_price_growth_rate = []
                K_Line_sum_7_closing_price_growth_rate = []
                K_Line_sum_7_closing_minus_opening_price_growth_rate = []
                K_Line_sum_7_high_price_proportion = []
                K_Line_sum_7_low_price_proportion = []
                K_Line_sum_7_KLine_Intuitive_Momentum = []
                K_Line_sum_10_turnover_volume_growth_rate = []
                K_Line_sum_10_opening_price_growth_rate = []
                K_Line_sum_10_closing_price_growth_rate = []
                K_Line_sum_10_closing_minus_opening_price_growth_rate = []
                K_Line_sum_10_high_price_proportion = []
                K_Line_sum_10_low_price_proportion = []
                K_Line_sum_10_KLine_Intuitive_Momentum = []
                K_Line_average_5_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 5 日滑動平均值（closing price average 5）;
                K_Line_average_10_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 10 日滑動平均值（closing price average 10）;
                K_Line_average_20_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 20 日滑動平均值（closing price average 20）;
                K_Line_average_30_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 30 日滑動平均值（closing price average 30）;
                Pdata_0 = []  # 擬合優化迭代初始值;
                Plower = []  # 擬合優化的約束上限值;
                Pupper = []  # 擬合優化的約束下限值;
                weight = []  # 加權擬合優化自變量（Independent variable , X）的權重值;

                # 計算訓練集日棒缐（K Line Daily）數據的最少數目（minimum count time series）;
                # minimum_count_time_series = int(0)
                # minimum_count_time_series = (+math.inf)
                minimum_count_time_series = int(min([len(value["opening_price"]), len(value["close_price"]), len(value["low_price"]), len(value["high_price"])]))
                # minimum_count_time_series = int(min([len(opening_price), len(close_price), len(low_price), len(high_price)]))

                if minimum_count_time_series > 0:

                    # for i in range(len(value["opening_price"])):
                    # for i in range(len(opening_price)):
                    for i in range(minimum_count_time_series):

                        # 計算訓練集日棒缐（K Line Daily）數據的重心值（Focus）;
                        # K_Line_focus = []  # 訓練集日棒缐（K Line Daily）數據的重心值（Focus）;
                        date_i_focus = numpy.mean([value["opening_price"][i], value["close_price"][i], value["low_price"][i], value["high_price"][i]])
                        # date_i_focus = numpy.mean([opening_price[i], close_price[i], low_price[i], high_price[i]])
                        date_i_focus = float(date_i_focus)
                        K_Line_focus.append(date_i_focus)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據的變化程度標示值（振幅）（Amplitude）;
                        # K_Line_amplitude = []  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                        date_i_amplitude = numpy.std(
                            [
                                value["opening_price"][i],  # opening_price[i],
                                value["close_price"][i],  # close_price[i],
                                value["low_price"][i],  # low_price[i],
                                value["high_price"][i]  # high_price[i]
                            ],
                            ddof = 1
                        )
                        # if int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) == int(1):
                        #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]])
                        # elif int(len([opening_price[i], close_price[i], low_price[i], high_price[i]])) > int(1):
                        #     date_i_amplitude = numpy.std([opening_price[i], close_price[i], low_price[i], high_price[i]], ddof=1)
                        date_i_amplitude = float(date_i_amplitude)
                        K_Line_amplitude.append(date_i_amplitude)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                        # K_Line_amplitude_rate = []  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                        date_i_amplitude_rate = float(date_i_amplitude)  # numpy.nan  # None  # +math.inf
                        if float(date_i_focus) == float(0.0):
                            date_i_amplitude_rate = (+math.inf)  # float(date_i_amplitude)
                        else:
                            date_i_amplitude_rate = float(date_i_amplitude / date_i_focus)
                        K_Line_amplitude_rate.append(date_i_amplitude_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 訓練集日棒缐（K Line Daily）數據標準化（Standardization）轉換;
                        date_i_opening_price_Standardization = value["opening_price"][i]  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                        date_i_closing_price_Standardization = value["close_price"][i]  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                        date_i_low_price_Standardization = value["low_price"][i]  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                        date_i_high_price_Standardization = value["high_price"][i]  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                        # if float(value["amplitude"][i]) == float(0.0):
                        if float(date_i_amplitude) == float(0.0):
                            date_i_opening_price_Standardization = float(value["opening_price"][i] - date_i_focus)
                            date_i_closing_price_Standardization = float(value["close_price"][i] - date_i_focus)
                            date_i_low_price_Standardization = float(value["low_price"][i] - date_i_focus)
                            date_i_high_price_Standardization = float(value["high_price"][i] - date_i_focus)
                        else:
                            date_i_opening_price_Standardization = float((value["opening_price"][i] - date_i_focus) / date_i_amplitude)
                            date_i_closing_price_Standardization = float((value["close_price"][i] - date_i_focus) / date_i_amplitude)
                            date_i_low_price_Standardization = float((value["low_price"][i] - date_i_focus) / date_i_amplitude)
                            date_i_high_price_Standardization = float((value["high_price"][i] - date_i_focus) / date_i_amplitude)
                        K_Line_opening_price_Standardization.append(date_i_opening_price_Standardization)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                        K_Line_closing_price_Standardization.append(date_i_closing_price_Standardization)
                        K_Line_low_price_Standardization.append(date_i_low_price_Standardization)
                        K_Line_high_price_Standardization.append(date_i_high_price_Standardization)

                        # 計算訓練集日棒缐（K Line Daily）數據相鄰兩個交易日之間成交股票數量的變化率值的序列，並保存入 1 維數組;
                        # K_Line_turnover_volume_growth_rate = []  # 計算相鄰兩個交易日之間成交股票數量的變化率值的序列;
                        date_i_turnover_volume_growth_rate = float(0.0)  # numpy.nan  # None
                        if int(i) > int(0):
                            if int(value["turnover_volume"][i - 1]) != int(0):
                                date_i_turnover_volume_growth_rate = float(float(value["turnover_volume"][i] / value["turnover_volume"][i - 1]) - float(1.0))
                            elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) == int(0):
                                date_i_turnover_volume_growth_rate = float(0.0)
                                # date_i_turnover_volume_growth_rate = numpy.nan
                                # date_i_turnover_volume_growth_rate = None
                            elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) > int(0):
                                date_i_turnover_volume_growth_rate = (+math.inf)
                            elif int(value["turnover_volume"][i - 1]) == int(0) and int(value["turnover_volume"][i]) < int(0):
                                date_i_turnover_volume_growth_rate = (-math.inf)
                            # else:
                        # print(date_i_turnover_volume_growth_rate)
                        K_Line_turnover_volume_growth_rate.append(date_i_turnover_volume_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據相鄰兩個交易日之間開盤股票價格的變化率值的序列，並保存入 1 維數組;
                        # K_Line_opening_price_growth_rate = []  # 計算相鄰兩個交易日之間開盤股票價格的變化率值的序列;
                        date_i_opening_price_growth_rate = float(0.0)  # numpy.nan  # None
                        if int(i) > int(0):
                            if float(value["opening_price"][i - 1]) != float(0.0):
                                date_i_opening_price_growth_rate = float(float(value["opening_price"][i] / value["opening_price"][i - 1]) - float(1.0))
                            elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) == float(0.0):
                                date_i_opening_price_growth_rate = float(0.0)
                                # date_i_opening_price_growth_rate = numpy.nan
                                # date_i_opening_price_growth_rate = None
                            elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) > float(0.0):
                                date_i_opening_price_growth_rate = (+math.inf)
                            elif float(value["opening_price"][i - 1]) == float(0.0) and float(value["opening_price"][i]) < float(0.0):
                                date_i_opening_price_growth_rate = (-math.inf)
                            # else:
                        # print(date_i_opening_price_growth_rate)
                        K_Line_opening_price_growth_rate.append(date_i_opening_price_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據相鄰兩個交易日之間收盤股票價格的變化率值的序列，並保存入 1 維數組;
                        # K_Line_closing_price_growth_rate = []  # 計算相鄰兩個交易日之間收盤股票價格的變化率值的序列;
                        date_i_closing_price_growth_rate = float(0.0)  # numpy.nan  # None
                        if int(i) > int(0):
                            if float(value["close_price"][i - 1]) != float(0.0):
                                date_i_closing_price_growth_rate = float(float(value["close_price"][i] / value["close_price"][i - 1]) - float(1.0))
                            elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) == float(0.0):
                                date_i_closing_price_growth_rate = float(0.0)
                                # date_i_closing_price_growth_rate = numpy.nan
                                # date_i_closing_price_growth_rate = None
                            elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) > float(0.0):
                                date_i_closing_price_growth_rate = (+math.inf)
                            elif float(value["close_price"][i - 1]) == float(0.0) and float(value["close_price"][i]) < float(0.0):
                                date_i_closing_price_growth_rate = (-math.inf)
                            # else:
                        # print(date_i_closing_price_growth_rate)
                        K_Line_closing_price_growth_rate.append(date_i_closing_price_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據每個交易日股票收盤價格減去開盤價格的變化率值的序列，並保存入 1 維數組;
                        # K_Line_closing_minus_opening_price_growth_rate = []  # 計算每個交易日股票收盤價格減去開盤價格的變化率值的序列;
                        date_i_closing_minus_opening_price_growth_rate = float(0.0)  # numpy.nan  # None
                        if float(value["opening_price"][i]) != float(0.0):
                            date_i_closing_minus_opening_price_growth_rate = float(float(value["close_price"][i] / value["opening_price"][i]) - float(1.0))
                        elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) == float(0.0):
                            date_i_closing_minus_opening_price_growth_rate = float(0.0)
                            # date_i_closing_minus_opening_price_growth_rate = numpy.nan
                            # date_i_closing_minus_opening_price_growth_rate = None
                        elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) > float(0.0):
                            date_i_closing_minus_opening_price_growth_rate = (+math.inf)
                        elif float(value["opening_price"][i]) == float(0.0) and float(value["close_price"][i]) < float(0.0):
                            date_i_closing_minus_opening_price_growth_rate = (-math.inf)
                        # else:
                        # print(date_i_closing_minus_opening_price_growth_rate)
                        K_Line_closing_minus_opening_price_growth_rate.append(date_i_closing_minus_opening_price_growth_rate)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列，並保存入 1 維數組;
                        # K_Line_high_price_proportion = []  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列;
                        date_i_high_price_proportion = float(0.0)  # numpy.nan  # None
                        if float(value["high_price"][i]) != float(0.0):
                            date_i_high_price_proportion = float(float(max([value["opening_price"][i], value["close_price"][i]])) / float(value["high_price"][i]))
                        elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) == float(0.0):
                            date_i_high_price_proportion = float(0.0)
                            # date_i_high_price_proportion = numpy.nan
                            # date_i_high_price_proportion = None
                        elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) > float(0.0):
                            date_i_high_price_proportion = (+math.inf)
                        elif float(value["high_price"][i]) == float(0.0) and float(max([value["opening_price"][i], value["close_price"][i]])) < float(0.0):
                            date_i_high_price_proportion = (-math.inf)
                        # else:
                        # print(date_i_high_price_proportion)
                        K_Line_high_price_proportion.append(date_i_high_price_proportion)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列，並保存入 1 維數組;
                        # K_Line_low_price_proportion = []  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列;
                        date_i_low_price_proportion = float(0.0)  # numpy.nan  # None
                        if float(min([value["opening_price"][i], value["close_price"][i]])) != float(0.0):
                            date_i_low_price_proportion = float(float(value["low_price"][i]) / float(min([value["opening_price"][i], value["close_price"][i]])))
                        elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) == float(0.0):
                            date_i_low_price_proportion = float(0.0)
                            # date_i_low_price_proportion = numpy.nan
                            # date_i_low_price_proportion = None
                        elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) > float(0.0):
                            date_i_low_price_proportion = (+math.inf)
                        elif float(min([value["opening_price"][i], value["close_price"][i]])) == float(0.0) and float(value["low_price"][i]) < float(0.0):
                            date_i_low_price_proportion = (-math.inf)
                        # else:
                        # print(date_i_low_price_proportion)
                        K_Line_low_price_proportion.append(date_i_low_price_proportion)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # K_Line_sum_2_turnover_volume_growth_rate = []
                        # K_Line_sum_2_opening_price_growth_rate = []
                        # K_Line_sum_2_closing_price_growth_rate = []
                        # K_Line_sum_2_closing_minus_opening_price_growth_rate = []
                        # K_Line_sum_2_high_price_proportion = []
                        # K_Line_sum_2_low_price_proportion = []
                        # K_Line_sum_2_KLine_Intuitive_Momentum = []
                        date_i_sum_2_turnover_volume_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_2_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_2_closing_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_2_closing_minus_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_2_high_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_2_low_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_2_KLine_Intuitive_Momentum = numpy.nan  # float(0.0)  # None
                        if int(int(i) + int(1)) >= int(2) and int(int(i) + int(1)) > int(1):

                            x0 = value["date_transaction"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                            x1 = value["turnover_volume"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                            # x2 = value["turnover_amount"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                            x3 = value["opening_price"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                            x4 = value["close_price"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                            x5 = value["low_price"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                            x6 = value["high_price"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                            # x7 = K_Line_focus[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                            # x8 = K_Line_amplitude[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                            # x21 = value["price_earnings"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][int(int(i) - int(2) + int(1)):int(int(i) + int(1)):1]  # 總市值;

                            y = Intuitive_Momentum_KLine(
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
                                int(2),  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = None,  # float(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = None,  # float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = None,  # [float(int(1) / int(2)), float(int(2) / int(2))]
                                Intuitive_Momentum = Intuitive_Momentum
                            )
                            date_i_sum_2_turnover_volume_growth_rate = float(y["P1_turnover_volume_growth_rate"][int(int(len(y["P1_turnover_volume_growth_rate"])) - int(1))])
                            date_i_sum_2_opening_price_growth_rate = float(y["P1_opening_price_growth_rate"][int(int(len(y["P1_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_2_closing_price_growth_rate = float(y["P1_closing_price_growth_rate"][int(int(len(y["P1_closing_price_growth_rate"])) - int(1))])
                            date_i_sum_2_closing_minus_opening_price_growth_rate = float(y["P1_closing_minus_opening_price_growth_rate"][int(int(len(y["P1_closing_minus_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_2_high_price_proportion = float(y["P1_high_price_proportion"][int(int(len(y["P1_high_price_proportion"])) - int(1))])
                            date_i_sum_2_low_price_proportion = float(y["P1_low_price_proportion"][int(int(len(y["P1_low_price_proportion"])) - int(1))])
                            date_i_sum_2_KLine_Intuitive_Momentum = float(y["P1_Intuitive_Momentum"][int(int(len(y["P1_Intuitive_Momentum"])) - int(1))])
                        K_Line_sum_2_turnover_volume_growth_rate.append(date_i_sum_2_turnover_volume_growth_rate)
                        K_Line_sum_2_opening_price_growth_rate.append(date_i_sum_2_opening_price_growth_rate)
                        K_Line_sum_2_closing_price_growth_rate.append(date_i_sum_2_closing_price_growth_rate)
                        K_Line_sum_2_closing_minus_opening_price_growth_rate.append(date_i_sum_2_closing_minus_opening_price_growth_rate)
                        K_Line_sum_2_high_price_proportion.append(date_i_sum_2_high_price_proportion)
                        K_Line_sum_2_low_price_proportion.append(date_i_sum_2_low_price_proportion)
                        K_Line_sum_2_KLine_Intuitive_Momentum.append(date_i_sum_2_KLine_Intuitive_Momentum)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # K_Line_sum_3_turnover_volume_growth_rate = []
                        # K_Line_sum_3_opening_price_growth_rate = []
                        # K_Line_sum_3_closing_price_growth_rate = []
                        # K_Line_sum_3_closing_minus_opening_price_growth_rate = []
                        # K_Line_sum_3_high_price_proportion = []
                        # K_Line_sum_3_low_price_proportion = []
                        # K_Line_sum_3_KLine_Intuitive_Momentum = []
                        date_i_sum_3_turnover_volume_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_3_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_3_closing_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_3_closing_minus_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_3_high_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_3_low_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_3_KLine_Intuitive_Momentum = numpy.nan  # float(0.0)  # None
                        if int(int(i) + int(1)) >= int(3) and int(int(i) + int(1)) > int(1):

                            x0 = value["date_transaction"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                            x1 = value["turnover_volume"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                            # x2 = value["turnover_amount"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                            x3 = value["opening_price"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                            x4 = value["close_price"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                            x5 = value["low_price"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                            x6 = value["high_price"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                            # x7 = K_Line_focus[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                            # x8 = K_Line_amplitude[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                            # x21 = value["price_earnings"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][int(int(i) - int(3) + int(1)):int(int(i) + int(1)):1]  # 總市值;

                            y = Intuitive_Momentum_KLine(
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
                                int(3),  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = None,  # float(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = None,  # float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = None,  # [float(int(1) / int(3)), float(int(2) / int(3)), float(int(3) / int(3))]
                                Intuitive_Momentum = Intuitive_Momentum
                            )
                            date_i_sum_3_turnover_volume_growth_rate = float(y["P1_turnover_volume_growth_rate"][int(int(len(y["P1_turnover_volume_growth_rate"])) - int(1))])
                            date_i_sum_3_opening_price_growth_rate = float(y["P1_opening_price_growth_rate"][int(int(len(y["P1_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_3_closing_price_growth_rate = float(y["P1_closing_price_growth_rate"][int(int(len(y["P1_closing_price_growth_rate"])) - int(1))])
                            date_i_sum_3_closing_minus_opening_price_growth_rate = float(y["P1_closing_minus_opening_price_growth_rate"][int(int(len(y["P1_closing_minus_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_3_high_price_proportion = float(y["P1_high_price_proportion"][int(int(len(y["P1_high_price_proportion"])) - int(1))])
                            date_i_sum_3_low_price_proportion = float(y["P1_low_price_proportion"][int(int(len(y["P1_low_price_proportion"])) - int(1))])
                            date_i_sum_3_KLine_Intuitive_Momentum = float(y["P1_Intuitive_Momentum"][int(int(len(y["P1_Intuitive_Momentum"])) - int(1))])
                        K_Line_sum_3_turnover_volume_growth_rate.append(date_i_sum_3_turnover_volume_growth_rate)
                        K_Line_sum_3_opening_price_growth_rate.append(date_i_sum_3_opening_price_growth_rate)
                        K_Line_sum_3_closing_price_growth_rate.append(date_i_sum_3_closing_price_growth_rate)
                        K_Line_sum_3_closing_minus_opening_price_growth_rate.append(date_i_sum_3_closing_minus_opening_price_growth_rate)
                        K_Line_sum_3_high_price_proportion.append(date_i_sum_3_high_price_proportion)
                        K_Line_sum_3_low_price_proportion.append(date_i_sum_3_low_price_proportion)
                        K_Line_sum_3_KLine_Intuitive_Momentum.append(date_i_sum_3_KLine_Intuitive_Momentum)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # K_Line_sum_5_turnover_volume_growth_rate = []
                        # K_Line_sum_5_opening_price_growth_rate = []
                        # K_Line_sum_5_closing_price_growth_rate = []
                        # K_Line_sum_5_closing_minus_opening_price_growth_rate = []
                        # K_Line_sum_5_high_price_proportion = []
                        # K_Line_sum_5_low_price_proportion = []
                        # K_Line_sum_5_KLine_Intuitive_Momentum = []
                        date_i_sum_5_turnover_volume_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_5_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_5_closing_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_5_closing_minus_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_5_high_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_5_low_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_5_KLine_Intuitive_Momentum = numpy.nan  # float(0.0)  # None
                        if int(int(i) + int(1)) >= int(5) and int(int(i) + int(1)) > int(1):

                            x0 = value["date_transaction"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                            x1 = value["turnover_volume"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                            # x2 = value["turnover_amount"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                            x3 = value["opening_price"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                            x4 = value["close_price"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                            x5 = value["low_price"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                            x6 = value["high_price"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                            # x7 = K_Line_focus[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                            # x8 = K_Line_amplitude[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                            # x21 = value["price_earnings"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][int(int(i) - int(5) + int(1)):int(int(i) + int(1)):1]  # 總市值;

                            y = Intuitive_Momentum_KLine(
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
                                int(5),  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = None,  # float(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = None,  # float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = None,  # [float(int(1) / int(5)), float(int(2) / int(5)), float(int(3) / int(5)), float(int(4) / int(5)), float(int(5) / int(5))]
                                Intuitive_Momentum = Intuitive_Momentum
                            )
                            date_i_sum_5_turnover_volume_growth_rate = float(y["P1_turnover_volume_growth_rate"][int(int(len(y["P1_turnover_volume_growth_rate"])) - int(1))])
                            date_i_sum_5_opening_price_growth_rate = float(y["P1_opening_price_growth_rate"][int(int(len(y["P1_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_5_closing_price_growth_rate = float(y["P1_closing_price_growth_rate"][int(int(len(y["P1_closing_price_growth_rate"])) - int(1))])
                            date_i_sum_5_closing_minus_opening_price_growth_rate = float(y["P1_closing_minus_opening_price_growth_rate"][int(int(len(y["P1_closing_minus_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_5_high_price_proportion = float(y["P1_high_price_proportion"][int(int(len(y["P1_high_price_proportion"])) - int(1))])
                            date_i_sum_5_low_price_proportion = float(y["P1_low_price_proportion"][int(int(len(y["P1_low_price_proportion"])) - int(1))])
                            date_i_sum_5_KLine_Intuitive_Momentum = float(y["P1_Intuitive_Momentum"][int(int(len(y["P1_Intuitive_Momentum"])) - int(1))])
                        K_Line_sum_5_turnover_volume_growth_rate.append(date_i_sum_5_turnover_volume_growth_rate)
                        K_Line_sum_5_opening_price_growth_rate.append(date_i_sum_5_opening_price_growth_rate)
                        K_Line_sum_5_closing_price_growth_rate.append(date_i_sum_5_closing_price_growth_rate)
                        K_Line_sum_5_closing_minus_opening_price_growth_rate.append(date_i_sum_5_closing_minus_opening_price_growth_rate)
                        K_Line_sum_5_high_price_proportion.append(date_i_sum_5_high_price_proportion)
                        K_Line_sum_5_low_price_proportion.append(date_i_sum_5_low_price_proportion)
                        K_Line_sum_5_KLine_Intuitive_Momentum.append(date_i_sum_5_KLine_Intuitive_Momentum)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # K_Line_sum_7_turnover_volume_growth_rate = []
                        # K_Line_sum_7_opening_price_growth_rate = []
                        # K_Line_sum_7_closing_price_growth_rate = []
                        # K_Line_sum_7_closing_minus_opening_price_growth_rate = []
                        # K_Line_sum_7_high_price_proportion = []
                        # K_Line_sum_7_low_price_proportion = []
                        # K_Line_sum_7_KLine_Intuitive_Momentum = []
                        date_i_sum_7_turnover_volume_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_7_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_7_closing_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_7_closing_minus_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_7_high_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_7_low_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_7_KLine_Intuitive_Momentum = numpy.nan  # float(0.0)  # None
                        if int(int(i) + int(1)) >= int(7) and int(int(i) + int(1)) > int(1):

                            x0 = value["date_transaction"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                            x1 = value["turnover_volume"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                            # x2 = value["turnover_amount"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                            x3 = value["opening_price"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                            x4 = value["close_price"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                            x5 = value["low_price"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                            x6 = value["high_price"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                            # x7 = K_Line_focus[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                            # x8 = K_Line_amplitude[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                            # x21 = value["price_earnings"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][int(int(i) - int(7) + int(1)):int(int(i) + int(1)):1]  # 總市值;

                            y = Intuitive_Momentum_KLine(
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
                                int(7),  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = None,  # float(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = None,  # float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = None,  # [float(int(1) / int(7)), float(int(2) / int(7)), float(int(3) / int(7)), float(int(4) / int(7)), float(int(5) / int(7)), float(int(6) / int(7)), float(int(7) / int(7))]
                                Intuitive_Momentum = Intuitive_Momentum
                            )
                            date_i_sum_7_turnover_volume_growth_rate = float(y["P1_turnover_volume_growth_rate"][int(int(len(y["P1_turnover_volume_growth_rate"])) - int(1))])
                            date_i_sum_7_opening_price_growth_rate = float(y["P1_opening_price_growth_rate"][int(int(len(y["P1_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_7_closing_price_growth_rate = float(y["P1_closing_price_growth_rate"][int(int(len(y["P1_closing_price_growth_rate"])) - int(1))])
                            date_i_sum_7_closing_minus_opening_price_growth_rate = float(y["P1_closing_minus_opening_price_growth_rate"][int(int(len(y["P1_closing_minus_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_7_high_price_proportion = float(y["P1_high_price_proportion"][int(int(len(y["P1_high_price_proportion"])) - int(1))])
                            date_i_sum_7_low_price_proportion = float(y["P1_low_price_proportion"][int(int(len(y["P1_low_price_proportion"])) - int(1))])
                            date_i_sum_7_KLine_Intuitive_Momentum = float(y["P1_Intuitive_Momentum"][int(int(len(y["P1_Intuitive_Momentum"])) - int(1))])
                        K_Line_sum_7_turnover_volume_growth_rate.append(date_i_sum_7_turnover_volume_growth_rate)
                        K_Line_sum_7_opening_price_growth_rate.append(date_i_sum_7_opening_price_growth_rate)
                        K_Line_sum_7_closing_price_growth_rate.append(date_i_sum_7_closing_price_growth_rate)
                        K_Line_sum_7_closing_minus_opening_price_growth_rate.append(date_i_sum_7_closing_minus_opening_price_growth_rate)
                        K_Line_sum_7_high_price_proportion.append(date_i_sum_7_high_price_proportion)
                        K_Line_sum_7_low_price_proportion.append(date_i_sum_7_low_price_proportion)
                        K_Line_sum_7_KLine_Intuitive_Momentum.append(date_i_sum_7_KLine_Intuitive_Momentum)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # K_Line_sum_10_turnover_volume_growth_rate = []
                        # K_Line_sum_10_opening_price_growth_rate = []
                        # K_Line_sum_10_closing_price_growth_rate = []
                        # K_Line_sum_10_closing_minus_opening_price_growth_rate = []
                        # K_Line_sum_10_high_price_proportion = []
                        # K_Line_sum_10_low_price_proportion = []
                        # K_Line_sum_10_KLine_Intuitive_Momentum = []
                        date_i_sum_10_turnover_volume_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_10_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_10_closing_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_10_closing_minus_opening_price_growth_rate = numpy.nan  # float(0.0)  # None
                        date_i_sum_10_high_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_10_low_price_proportion = numpy.nan  # float(0.0)  # None
                        date_i_sum_10_KLine_Intuitive_Momentum = numpy.nan  # float(0.0)  # None
                        if int(int(i) + int(1)) >= int(10) and int(int(i) + int(1)) > int(1):

                            x0 = value["date_transaction"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                            x1 = value["turnover_volume"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                            # x2 = value["turnover_amount"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                            x3 = value["opening_price"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                            x4 = value["close_price"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                            x5 = value["low_price"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                            x6 = value["high_price"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                            # x7 = K_Line_focus[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                            # x8 = K_Line_amplitude[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                            # x21 = value["price_earnings"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][int(int(i) - int(10) + int(1)):int(int(i) + int(1)):1]  # 總市值;

                            y = Intuitive_Momentum_KLine(
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
                                int(10),  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = None,  # float(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = None,  # float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = None,  # [float(int(1) / int(10)), float(int(2) / int(10)), float(int(3) / int(10)), float(int(4) / int(10)), float(int(5) / int(10)), float(int(6) / int(10)), float(int(7) / int(10)), float(int(8) / int(10)), float(int(9) / int(10)), float(int(10) / int(10))]
                                Intuitive_Momentum = Intuitive_Momentum
                            )
                            date_i_sum_10_turnover_volume_growth_rate = float(y["P1_turnover_volume_growth_rate"][int(int(len(y["P1_turnover_volume_growth_rate"])) - int(1))])
                            date_i_sum_10_opening_price_growth_rate = float(y["P1_opening_price_growth_rate"][int(int(len(y["P1_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_10_closing_price_growth_rate = float(y["P1_closing_price_growth_rate"][int(int(len(y["P1_closing_price_growth_rate"])) - int(1))])
                            date_i_sum_10_closing_minus_opening_price_growth_rate = float(y["P1_closing_minus_opening_price_growth_rate"][int(int(len(y["P1_closing_minus_opening_price_growth_rate"])) - int(1))])
                            date_i_sum_10_high_price_proportion = float(y["P1_high_price_proportion"][int(int(len(y["P1_high_price_proportion"])) - int(1))])
                            date_i_sum_10_low_price_proportion = float(y["P1_low_price_proportion"][int(int(len(y["P1_low_price_proportion"])) - int(1))])
                            date_i_sum_10_KLine_Intuitive_Momentum = float(y["P1_Intuitive_Momentum"][int(int(len(y["P1_Intuitive_Momentum"])) - int(1))])
                        K_Line_sum_10_turnover_volume_growth_rate.append(date_i_sum_10_turnover_volume_growth_rate)
                        K_Line_sum_10_opening_price_growth_rate.append(date_i_sum_10_opening_price_growth_rate)
                        K_Line_sum_10_closing_price_growth_rate.append(date_i_sum_10_closing_price_growth_rate)
                        K_Line_sum_10_closing_minus_opening_price_growth_rate.append(date_i_sum_10_closing_minus_opening_price_growth_rate)
                        K_Line_sum_10_high_price_proportion.append(date_i_sum_10_high_price_proportion)
                        K_Line_sum_10_low_price_proportion.append(date_i_sum_10_low_price_proportion)
                        K_Line_sum_10_KLine_Intuitive_Momentum.append(date_i_sum_10_KLine_Intuitive_Momentum)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 5 日滑動平均值（closing price average 5）;
                        # K_Line_average_5_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 5 日滑動平均值（closing price average 5）;
                        date_i_average_5_closing_price = float(0.0)  # numpy.nan  # None
                        if int(int(i) + int(1)) >= int(5):
                            date_i_average_5_closing_price = float(float(sum([value["close_price"][k] for k in range(int(int(i) - int(5) + int(1)), int(int(i) + int(1)), int(1))])) / int(5))
                            # x_sum_5 = float(0.0)
                            # for k in range(int(int(i) - int(5) + int(1)), int(int(i) + int(1)), int(1)):
                            #     x_sum_5 = float(float(x_sum_5) + float(value["close_price"][k]))
                            # date_i_average_5_closing_price = float(float(x_sum_5) / int(5))
                        # print(date_i_average_5_closing_price)
                        K_Line_average_5_closing_price.append(date_i_average_5_closing_price)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 10 日滑動平均值（closing price average 10）;
                        # K_Line_average_10_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 10 日滑動平均值（closing price average 10）;
                        date_i_average_10_closing_price = float(0.0)  # numpy.nan  # None
                        if int(int(i) + int(1)) >= int(10):
                            date_i_average_10_closing_price = float(float(sum([value["close_price"][k] for k in range(int(int(i) - int(10) + int(1)), int(int(i) + int(1)), int(1))])) / int(10))
                            # x_sum_10 = float(0.0)
                            # for k in range(int(int(i) - int(10) + int(1)), int(int(i) + int(1)), int(1)):
                            #     x_sum_10 = float(float(x_sum_10) + float(value["close_price"][k]))
                            # date_i_average_10_closing_price = float(float(x_sum_10) / int(10))
                        # print(date_i_average_10_closing_price)
                        K_Line_average_10_closing_price.append(date_i_average_10_closing_price)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 20 日滑動平均值（closing price average 20）;
                        # K_Line_average_20_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 20 日滑動平均值（closing price average 20）;
                        date_i_average_20_closing_price = float(0.0)  # numpy.nan  # None
                        if int(int(i) + int(1)) >= int(20):
                            date_i_average_20_closing_price = float(float(sum([value["close_price"][k] for k in range(int(int(i) - int(20) + int(1)), int(int(i) + int(1)), int(1))])) / int(20))
                            # x_sum_20 = float(0.0)
                            # for k in range(int(int(i) - int(20) + int(1)), int(int(i) + int(1)), int(1)):
                            #     x_sum_20 = float(float(x_sum_20) + float(value["close_price"][k]))
                            # date_i_average_20_closing_price = float(float(x_sum_20) / int(20))
                        # print(date_i_average_20_closing_price)
                        K_Line_average_20_closing_price.append(date_i_average_20_closing_price)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 30 日滑動平均值（closing price average 30）;
                        # K_Line_average_30_closing_price = []  # 訓練集日棒缐（K Line Daily）數據收盤價的 30 日滑動平均值（closing price average 30）;
                        date_i_average_30_closing_price = float(0.0)  # numpy.nan  # None
                        if int(int(i) + int(1)) >= int(30):
                            date_i_average_30_closing_price = float(float(sum([value["close_price"][k] for k in range(int(int(i) - int(30) + int(1)), int(int(i) + int(1)), int(1))])) / int(30))
                            # x_sum_30 = float(0.0)
                            # for k = in range(int(int(i) - int(30) + int(1)), int(int(i) + int(1)), int(1)):
                            #     x_sum_30 = float(float(x_sum_30) + float(value["close_price"][k]))
                            # date_i_average_30_closing_price = float(float(x_sum_30) / int(30))
                        # print(date_i_average_30_closing_price)
                        K_Line_average_30_closing_price.append(date_i_average_30_closing_price)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 計算擬合優化迭代的各項輸入參數值;
                    # y = Base.log(x);  # 對數函數，返回以 e 爲底 x 的對數;
                    # y = math.exp(x)  # 指數函數，返回 e 的 x 次冪;
                    # y = math.pow(x, 2)  # 冪函數，返回 x 的 2 次方;
                    # min([2, 1, 0, -1, -2]);  # 求最小值;
                    # max([-2, -1, 0, 1, 2]);  # 求最大值;

                    # 觀測值（Observation）;
                    # 求 Ydata 均值向量;
                    YdataMean = K_Line_focus
                    # YdataMean = []
                    # for i in range(len(Ydata)):
                    #     yMean = numpy.mean(Ydata[i])
                    #     YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # print(YdataMean)

                    # 求 Ydata 標準差向量;
                    YdataSTD = K_Line_amplitude
                    # YdataSTD = []
                    # for i in range(len(Ydata)):
                    #     if len(Ydata[i]) > 1:
                    #         ySTD = numpy.std(Ydata[i], ddof=1)
                    #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    #     elif len(Ydata[i]) == 1:
                    #         ySTD = numpy.std(Ydata[i])
                    #         YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # print(YdataSTD)

                    # 求 Xdata 均值向量;
                    Xdata = [int(int(i) + int(1)) for i in range(len(YdataMean))]
                    # Xdata = date_transaction
                    # Xdata = stepping_data["date_transaction"]
                    # print(Xdata)

                    # 參數初始值;
                    Pdata_0 = [
                        float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])),
                        float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])),
                        float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])),
                        float(numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])) * Xdata[i]**1)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])) * Xdata[i]**1)) for i in range(len(YdataMean))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])) * Xdata[i]**2)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])) * Xdata[i]**2)) for i in range(len(YdataMean))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])) * Xdata[i]**3)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])) * Xdata[i]**3)) for i in range(len(YdataMean))]))
                    ]

                    # 參數上下限值;
                    Plower = [
                        -math.inf,
                        -math.inf,
                        -math.inf,
                        -math.inf
                    ]
                    Pupper = [
                        +math.inf,
                        +math.inf,
                        +math.inf,
                        +math.inf
                    ]

                    # 變量實測值擬合權重;
                    # weight = []
                    # target = 2  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
                    # for i in range(len(YdataMean)):
                    #     wei = math.exp(-(abs(YdataMean[i] - YdataMean[target]) / (max(YdataMean) - min(YdataMean))))
                    #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # 使用高斯核賦權法;
                    target = 1  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
                    af = float(0.9)  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
                    for i in range(len(YdataMean)):
                        wei = math.exp(math.pow(YdataMean[i] / YdataMean[target] - 1, 2) / ((-2) * math.pow(af, 2)))
                        weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # # 使用方差倒數值賦權法;
                    # for i in range(len(YdataSTD)):
                    #     wei = 1 / YdataSTD[i]  # numpy.std(Ydata[i], ddof=1), numpy.var(Ydata[i], ddof = 1);
                    #     weight.append(wei)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # print(weight)

                input_K_Line_Daily_Dict[key]["focus"] = K_Line_focus
                input_K_Line_Daily_Dict[key]["amplitude"] = K_Line_amplitude
                input_K_Line_Daily_Dict[key]["amplitude_rate"] = K_Line_amplitude_rate
                input_K_Line_Daily_Dict[key]["opening_price_Standardization"] = K_Line_opening_price_Standardization
                input_K_Line_Daily_Dict[key]["closing_price_Standardization"] = K_Line_closing_price_Standardization
                input_K_Line_Daily_Dict[key]["low_price_Standardization"] = K_Line_low_price_Standardization
                input_K_Line_Daily_Dict[key]["high_price_Standardization"] = K_Line_high_price_Standardization
                input_K_Line_Daily_Dict[key]["turnover_rate"] = K_Line_turnover_rate
                input_K_Line_Daily_Dict[key]["price_earnings"] = K_Line_price_earnings
                input_K_Line_Daily_Dict[key]["book_value_per_share"] = K_Line_book_value_per_share
                input_K_Line_Daily_Dict[key]["capitalization"] = K_Line_capitalization
                input_K_Line_Daily_Dict[key]["turnover_volume_growth_rate"] = K_Line_turnover_volume_growth_rate
                input_K_Line_Daily_Dict[key]["opening_price_growth_rate"] = K_Line_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["closing_price_growth_rate"] = K_Line_closing_price_growth_rate
                input_K_Line_Daily_Dict[key]["closing_minus_opening_price_growth_rate"] = K_Line_closing_minus_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["high_price_proportion"] = K_Line_high_price_proportion
                input_K_Line_Daily_Dict[key]["low_price_proportion"] = K_Line_low_price_proportion
                input_K_Line_Daily_Dict[key]["sum_2_turnover_volume_growth_rate"] = K_Line_sum_2_turnover_volume_growth_rate
                input_K_Line_Daily_Dict[key]["sum_2_opening_price_growth_rate"] = K_Line_sum_2_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_2_closing_price_growth_rate"] = K_Line_sum_2_closing_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_2_closing_minus_opening_price_growth_rate"] = K_Line_sum_2_closing_minus_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_2_high_price_proportion"] = K_Line_sum_2_high_price_proportion
                input_K_Line_Daily_Dict[key]["sum_2_low_price_proportion"] = K_Line_sum_2_low_price_proportion
                input_K_Line_Daily_Dict[key]["sum_2_KLine_Intuitive_Momentum"] = K_Line_sum_2_KLine_Intuitive_Momentum
                input_K_Line_Daily_Dict[key]["sum_3_turnover_volume_growth_rate"] = K_Line_sum_3_turnover_volume_growth_rate
                input_K_Line_Daily_Dict[key]["sum_3_opening_price_growth_rate"] = K_Line_sum_3_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_3_closing_price_growth_rate"] = K_Line_sum_3_closing_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_3_closing_minus_opening_price_growth_rate"] = K_Line_sum_3_closing_minus_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_3_high_price_proportion"] = K_Line_sum_3_high_price_proportion
                input_K_Line_Daily_Dict[key]["sum_3_low_price_proportion"] = K_Line_sum_3_low_price_proportion
                input_K_Line_Daily_Dict[key]["sum_3_KLine_Intuitive_Momentum"] = K_Line_sum_3_KLine_Intuitive_Momentum
                input_K_Line_Daily_Dict[key]["sum_5_turnover_volume_growth_rate"] = K_Line_sum_5_turnover_volume_growth_rate
                input_K_Line_Daily_Dict[key]["sum_5_opening_price_growth_rate"] = K_Line_sum_5_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_5_closing_price_growth_rate"] = K_Line_sum_5_closing_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_5_closing_minus_opening_price_growth_rate"] = K_Line_sum_5_closing_minus_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_5_high_price_proportion"] = K_Line_sum_5_high_price_proportion
                input_K_Line_Daily_Dict[key]["sum_5_low_price_proportion"] = K_Line_sum_5_low_price_proportion
                input_K_Line_Daily_Dict[key]["sum_5_KLine_Intuitive_Momentum"] = K_Line_sum_5_KLine_Intuitive_Momentum
                input_K_Line_Daily_Dict[key]["sum_7_turnover_volume_growth_rate"] = K_Line_sum_7_turnover_volume_growth_rate
                input_K_Line_Daily_Dict[key]["sum_7_opening_price_growth_rate"] = K_Line_sum_7_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_7_closing_price_growth_rate"] = K_Line_sum_7_closing_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_7_closing_minus_opening_price_growth_rate"] = K_Line_sum_7_closing_minus_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_7_high_price_proportion"] = K_Line_sum_7_high_price_proportion
                input_K_Line_Daily_Dict[key]["sum_7_low_price_proportion"] = K_Line_sum_7_low_price_proportion
                input_K_Line_Daily_Dict[key]["sum_7_KLine_Intuitive_Momentum"] = K_Line_sum_7_KLine_Intuitive_Momentum
                input_K_Line_Daily_Dict[key]["sum_10_turnover_volume_growth_rate"] = K_Line_sum_10_turnover_volume_growth_rate
                input_K_Line_Daily_Dict[key]["sum_10_opening_price_growth_rate"] = K_Line_sum_10_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_10_closing_price_growth_rate"] = K_Line_sum_10_closing_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_10_closing_minus_opening_price_growth_rate"] = K_Line_sum_10_closing_minus_opening_price_growth_rate
                input_K_Line_Daily_Dict[key]["sum_10_high_price_proportion"] = K_Line_sum_10_high_price_proportion
                input_K_Line_Daily_Dict[key]["sum_10_low_price_proportion"] = K_Line_sum_10_low_price_proportion
                input_K_Line_Daily_Dict[key]["sum_10_KLine_Intuitive_Momentum"] = K_Line_sum_10_KLine_Intuitive_Momentum
                input_K_Line_Daily_Dict[key]["average_5_closing_price"] = K_Line_average_5_closing_price
                input_K_Line_Daily_Dict[key]["average_10_closing_price"] = K_Line_average_10_closing_price
                input_K_Line_Daily_Dict[key]["average_20_closing_price"] = K_Line_average_20_closing_price
                input_K_Line_Daily_Dict[key]["average_30_closing_price"] = K_Line_average_30_closing_price
                input_K_Line_Daily_Dict[key]["Pdata_0"] = Pdata_0
                input_K_Line_Daily_Dict[key]["Plower"] = Plower
                input_K_Line_Daily_Dict[key]["Pupper"] = Pupper
                input_K_Line_Daily_Dict[key]["weight"] = weight

                # 釋放内存;
                K_Line_focus = None  # 釋放内存;
                K_Line_amplitude = None
                K_Line_amplitude_rate = None
                K_Line_opening_price_Standardization = None
                K_Line_closing_price_Standardization = None
                K_Line_low_price_Standardization = None
                K_Line_high_price_Standardization = None
                K_Line_turnover_rate = None
                K_Line_price_earnings = None
                K_Line_book_value_per_share = None
                K_Line_capitalization = None
                K_Line_turnover_volume_growth_rate = None
                K_Line_opening_price_growth_rate = None
                K_Line_closing_price_growth_rate = None
                K_Line_closing_minus_opening_price_growth_rate = None
                K_Line_high_price_proportion = None
                K_Line_low_price_proportion = None
                K_Line_sum_2_turnover_volume_growth_rate = None
                K_Line_sum_2_opening_price_growth_rate = None
                K_Line_sum_2_closing_price_growth_rate = None
                K_Line_sum_2_closing_minus_opening_price_growth_rate = None
                K_Line_sum_2_high_price_proportion = None
                K_Line_sum_2_low_price_proportion = None
                K_Line_sum_2_KLine_Intuitive_Momentum = None
                K_Line_sum_3_turnover_volume_growth_rate = None
                K_Line_sum_3_opening_price_growth_rate = None
                K_Line_sum_3_closing_price_growth_rate = None
                K_Line_sum_3_closing_minus_opening_price_growth_rate = None
                K_Line_sum_3_high_price_proportion = None
                K_Line_sum_3_low_price_proportion = None
                K_Line_sum_3_KLine_Intuitive_Momentum = None
                K_Line_sum_5_turnover_volume_growth_rate = None
                K_Line_sum_5_opening_price_growth_rate = None
                K_Line_sum_5_closing_price_growth_rate = None
                K_Line_sum_5_closing_minus_opening_price_growth_rate = None
                K_Line_sum_5_high_price_proportion = None
                K_Line_sum_5_low_price_proportion = None
                K_Line_sum_5_KLine_Intuitive_Momentum = None
                K_Line_sum_7_turnover_volume_growth_rate = None
                K_Line_sum_7_opening_price_growth_rate = None
                K_Line_sum_7_closing_price_growth_rate = None
                K_Line_sum_7_closing_minus_opening_price_growth_rate = None
                K_Line_sum_7_high_price_proportion = None
                K_Line_sum_7_low_price_proportion = None
                K_Line_sum_7_KLine_Intuitive_Momentum = None
                K_Line_sum_10_turnover_volume_growth_rate = None
                K_Line_sum_10_opening_price_growth_rate = None
                K_Line_sum_10_closing_price_growth_rate = None
                K_Line_sum_10_closing_minus_opening_price_growth_rate = None
                K_Line_sum_10_high_price_proportion = None
                K_Line_sum_10_low_price_proportion = None
                K_Line_sum_10_KLine_Intuitive_Momentum = None
                K_Line_average_5_closing_price = None
                K_Line_average_10_closing_price = None
                K_Line_average_20_closing_price = None
                K_Line_average_30_closing_price = None
                Pdata_0 = None
                Plower = None
                Pupper = None
                weight = None

stepping_data = input_K_Line_Daily_Dict

input_K_Line_Daily_Dict = None  # 釋放内存;


# training_data = {}
# training_data = stepping_data

# testing_data = {}
# testing_data = stepping_data


# import numpy
# import pickle  # 導入 Python 原生模組「pickle」，用於將結構化的内存數據直接備份到硬盤二進制文檔，以及從硬盤文檔直接導入結構化内存數據;
# import string  # 加載Python原生的字符串處理模組;
# import time  # 加載Python原生的日期數據處理模組;
# import datetime  # 加載Python原生的日期數據處理模組;
# 將字典（Dict）類型數據，寫入磁盤（hide disk）的 Python 語言特有類型的 pickle 類型（.pickle）的變量存儲文檔;
# is_save_pickle = False
if is_save_pickle:
    # output_pickle_K_Line_Daily_file = "C:/QuantitativeTrading/Data/steppingData.pickle"
    # 使用 pickle 模組，將 Python 字典類型的數據，保存到硬盤（.pickle）文檔;
    with open(output_pickle_K_Line_Daily_file, "wb") as f:
        pickle.dump(stepping_data, f)
        f.close()

    # # 使用 pickle 模組，從保存到硬盤的（.pickle）文檔，導入 Python 結構化的數據;
    # stepping_data = None
    # with open(output_pickle_K_Line_Daily_file, "rb") as f:
    #     stepping_data = pickle.load(f)
    #     f.close()
    #     print(stepping_data)


# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
# using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
# https://github.com/JuliaData/CSV.jl
# https://csv.juliadata.org/stable/
# 將字典（Base.Dict）類型數據，寫入磁盤（hide disk）的（.csv）類型的文檔;
# is_save_csv = True
if is_save_csv:
    # output_csv_K_Line_Daily_file_dir = "C:/QuantitativeTrading/Data/K-Day/"
    # print(stepping_data.keys());
    for key, value in stepping_data.items():

        output_K_Line_Daily_file_name = str(str(key) + ".csv")  # 使用加號（+）運算符拼接字符串;
        output_K_Line_Daily_file_I = str(os.path.join(str(output_csv_K_Line_Daily_file_dir), str(output_K_Line_Daily_file_name)))  # 拼接本地當前目錄下的請求文檔名;

        stepping_data_I_Equal_Length = copy.deepcopy(value)  # copy.deepcopy(stepping_data[key]);  # 深複製（傳值）字典副本，以防原字典數據被修改;
        stepping_data_I_Equal_Length["date_transaction"] = [str(stepping_data_I_Equal_Length["date_transaction"][i]) for i in range(len(stepping_data_I_Equal_Length["date_transaction"]))]  # 將日期（Dates.Date）類型數據轉換爲字符串（Core.String）類型數據;

        # del stepping_data_I_Equal_Length["Pdata_0"]  # 刪除字典中不等長的列;
        # del stepping_data_I_Equal_Length["Plower"]  # 刪除字典中不等長的列;
        # del stepping_data_I_Equal_Length["Pupper"]  # 刪除字典中不等長的列;
        # del stepping_data_I_Equal_Length["weight"]  # 刪除字典中不等長的列;
        # 補齊字典中不等長的列，以 numpy.nan 值填充;
        max_row = int(max([len(value_list_I) for value_list_I in stepping_data_I_Equal_Length.values()]))
        for key1, value1 in stepping_data_I_Equal_Length.items():
            if len(value1) < max_row:
                stepping_data_I_Equal_Length[key1] = [value1[i] if i < len(value1) else numpy.nan for i in range(0, max_row)]
                # for i in range(int(len(value1)), max_row):
                #     stepping_data_I_Equal_Length[key1].append(numpy.nan)  # 使用 .append() 函數在數組末尾追加推入新元素;

        # with open(output_K_Line_Daily_file_I, mode='w', newline='') as f:
        #     csv_writer = csv.writer(
        #         f,
        #         dialect = "excel",
        #         # quotechar = '"',
        #         # quoting = csv.QUOTE_MINIMAL,
        #         lineterminator = '\n',  # '\r\n',
        #         delimiter = ','  # '\t'
        #     )
        #     csv_writer.writerow(stepping_data_I_Equal_Length.keys())
        #     for i in range(0, max_row):
        #         row_array = []
        #         for key2 in stepping_data_I_Equal_Length.keys():
        #             if i >= len(value[key2]):
        #                 row_array.append("")  # 使用 .append() 函數在數組末尾追加推入新元素;
        #             else:
        #                 row_array.append(stepping_data_I_Equal_Length[key2][i])  # 使用 .append() 函數在數組末尾追加推入新元素;
        #         csv_writer.writerow(row_array)
        #         row_array = None  # 釋放内存;
        #     csv_writer = None  # 釋放内存;
        #     f.close()

        stepping_data_I_Frame = pandas.DataFrame(stepping_data_I_Equal_Length)  # 將字典（Dict）類型的數據包裝爲數據框（pandas.DataFrame）類型的數據，使用 pandas.DataFrame.to_csv() 函數，將數據框（DataFrames.DataFrame）類型的數據寫入 .csv 文檔;
        stepping_data_I_Frame.to_csv(
            output_K_Line_Daily_file_I,
            index = False,  # 預設爲 True 值，設定是否寫入行（row）索引（名稱）值;
            # index_label = ["date_transaction"],  # 指定使用哪個列（column）的值作爲行（row）索引（名稱）;
            header = True,  # 預設爲 True 值，設定是否寫入列（column）索引（名稱）值;
            sep = ',',  # 設定字段之間的分隔符爲逗號（,）符號，預設爲：逗號（,）符號;
            na_rep = "",  # 設定將空值替換爲指定的字符串，當值爲 "N/A" 表示設定將空值替換爲 "N/A" 字符串，預設爲："NaN";
            # quotechar = '"',  # 使用雙引號（"）引用樣式;
            # quoting = csv.QUOTE_ALL,  # 使用雙引號（"）引用樣式，並在引用中包含換行符和逗號;
            # float_format = "%.2f",  # lambda x: format(x, '.2f') if numpy.isfinite(x) else "null",  # 自定義 16 進制（float）數字格式，這裏設定爲保留兩位小數，預設值爲：None ;
            date_format = "%Y-%m-%d",  # "%Y-%m-%d %H:%M:%S.%f",  # 設置日期解析格式，預設值爲：None ;
            # columns = [
            #     0,  # "date_transaction",
            #     1,  # "opening_price",
            #     2,  # "close_price",
            #     3,  # "low_price",
            #     4,  # "high_price",
            #     5,  # "turnover_volume",
            #     6  # "turnover_amount"
            # ],  設置祇寫入指定列（column）數據;
            mode = 'w',  # 設置模式爲：覆蓋寫入，若想改爲追加續寫模式，可取：mode = 'a' 值，預設值爲：mode = 'w' ;
            encoding = "utf-8"
        )

        stepping_data_I_Equal_Length = None  # 釋放内存;
        stepping_data_I_Frame = None  # 釋放内存;


# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
# using XLSX;  # 導入第三方擴展包「XLSX」，用於操作「.xlsx」文檔（Microsoft Office Excel），需要在控制臺先安裝第三方擴展包「XLSX」：julia> using Pkg; Pkg.add("XLSX") 成功之後才能使用;
# https://github.com/felipenoris/XLSX.jl
# https://felipenoris.github.io/XLSX.jl/stable/
# 將字典（Base.Dict）類型數據，寫入磁盤（hide disk）的 Excel（.xlsx）類型的文檔;
# is_save_xlsx = True
if is_save_xlsx:
    # output_xlsx_K_Line_Daily_file_dir = "C:/QuantitativeTrading/Data/K-Day/"
    # print(stepping_data.keys());
    for key, value in stepping_data.items():

        output_K_Line_Daily_file_name = str(str(key) + ".xlsx")  # 使用加號（+）運算符拼接字符串;
        output_K_Line_Daily_file_I = str(os.path.join(str(output_xlsx_K_Line_Daily_file_dir), str(output_K_Line_Daily_file_name)))  # 拼接本地當前目錄下的請求文檔名;

        stepping_data_I_Equal_Length = copy.deepcopy(value)  # copy.deepcopy(stepping_data[key]);  # 深複製（傳值）字典副本，以防原字典數據被修改;
        stepping_data_I_Equal_Length["date_transaction"] = [str(stepping_data_I_Equal_Length["date_transaction"][i]) for i in range(len(stepping_data_I_Equal_Length["date_transaction"]))]  # 將日期（Dates.Date）類型數據轉換爲字符串（Core.String）類型數據;

        # del stepping_data_I_Equal_Length["Pdata_0"]  # 刪除字典中不等長的列;
        # del stepping_data_I_Equal_Length["Plower"]  # 刪除字典中不等長的列;
        # del stepping_data_I_Equal_Length["Pupper"]  # 刪除字典中不等長的列;
        # del stepping_data_I_Equal_Length["weight"]  # 刪除字典中不等長的列;
        # 補齊字典中不等長的列，以 numpy.nan 值填充;
        max_row = int(max([len(value_list_I) for value_list_I in stepping_data_I_Equal_Length.values()]))
        for key1, value1 in stepping_data_I_Equal_Length.items():
            if len(value1) < max_row:
                stepping_data_I_Equal_Length[key1] = [value1[i] if i < len(value1) else numpy.nan for i in range(0, max_row)]
                # for i in range(int(len(value1)), max_row):
                #     stepping_data_I_Equal_Length[key1].append(numpy.nan)  # 使用 .append() 函數在數組末尾追加推入新元素;

        stepping_data_I_Frame = pandas.DataFrame(stepping_data_I_Equal_Length)  # 將字典（Dict）類型的數據包裝爲數據框（pandas.DataFrame）類型的數據，使用 pandas.DataFrame.to_excel() 函數，將數據框（DataFrames.DataFrame）類型的數據寫入 .csv 文檔;
        stepping_data_I_Frame.to_excel(
            output_K_Line_Daily_file_I,
            sheet_name = str(key),  # 0,  # "Sheet1",  # 指定讀取的工作簿（Sheet）名稱，預設值爲："Sheet1" ;
            index = False,  # 預設爲 True 值，設定是否寫入行（row）索引（名稱）值;
            # index_label = ["date_transaction"],  # 指定使用哪個列（column）的值作爲行（row）索引（名稱）;
            header = True,  # 預設爲 True 值，設定是否寫入列（column）索引（名稱）值;
            startrow = 0,  # 設置起始行（row），預設值爲 0 ;
            startcol = 0,  # 設置起始列（column），預設值爲 0 ;
            na_rep = "",  # 設定將空值替換爲指定的字符串，當值爲 "N/A" 表示設定將空值替換爲 "N/A" 字符串，預設爲："NaN";
            # quotechar = '"',  # 使用雙引號（"）引用樣式;
            # quoting = csv.QUOTE_ALL,  # 使用雙引號（"）引用樣式，並在引用中包含換行符和逗號;
            inf_rep = "Infinity",  # 指定無情大的標記符號寫法，預設值爲："inf" ;
            # float_format = "%.2f",  # lambda x: format(x, '.2f') if numpy.isfinite(x) else "null",  # 自定義 16 進制（float）數字格式，這裏設定爲保留兩位小數，預設值爲：None ;
            # columns = [
            #     0,  # "date_transaction",
            #     1,  # "opening_price",
            #     2,  # "close_price",
            #     3,  # "low_price",
            #     4,  # "high_price",
            #     5,  # "turnover_volume",
            #     6  # "turnover_amount"
            # ],  設置祇寫入指定列（column）數據;
            engine = "openpyxl"  # 指定解析引擎，，對於 .xlsx 文檔預設值爲："xlwt"，這裏設置爲：使用解析引擎「openpyxl」，需要事先安裝：pip install openpyxl 配置成功;
        )

        stepping_data_I_Equal_Length = None  # 釋放内存;
        stepping_data_I_Frame = None  # 釋放内存;


# # 繪圖;
# # https://matplotlib.org/stable/contents.html
# # 使用第三方擴展包「matplotlib」中的「pyplot()」函數繪製散點圖示;
# # import matplotlib
# is_visualization = False
# fig = None
# if is_visualization:

#     # https://matplotlib.org/stable/contents.html
#     # 使用第三方擴展包「matplotlib」中的「pyplot()」函數繪製散點圖示;
#     # matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, clear=False, **kwargs)
#     # 參數 figsize=(float,float) 表示繪圖板的長、寬數，預設值為 figsize=[6.4,4.8] 單位為英寸；參數 dpi=float 表示圖形分辨率，預設值為 dpi=100，單位為每平方英尺中的點數；參數 constrained_layout=True 設置子圖區域不要有重叠;
#     fig = matplotlib.pyplot.figure(figsize=(16, 9), dpi=300, constrained_layout=True)  # 參數 constrained_layout=True 設置子圖區域不要有重叠
#     # fig.tight_layout()  # 自動調整子圖參數，使之填充整個圖像區域;
#     # matplotlib.pyplot.subplot2grid(shape, loc, rowspan=1, colspan=1, fig=None, **kwargs)
#     # 參數 shape=(int,int) 表示創建網格行列數，傳入參數值類型為一維整型數組[int,int]；參數 loc=(int,int) 表示一個畫布所占網格起點的橫縱坐標，傳入參數值類型為一維整型數組[int,int]；參數 rowspan=1 表示該畫布占一行的長度，參數 colspan=1 表示該畫布占一列的寬度;
#     axes_1 = matplotlib.pyplot.subplot2grid((2, 1), (0, 0), rowspan=1, colspan=1)  # 參數 (2,1) 表示創建 2 行 1 列的網格，參數 (0,0) 表示第一個畫布 axes_1 的起點在橫坐標為 0 縱坐標為 0 的網格，參數 rowspan=1 表示該畫布占一行的長度，參數 colspan=1 表示該畫布占一列的寬度;
#     axes_2 = matplotlib.pyplot.subplot2grid((2, 1), (1, 0), rowspan=1, colspan=1)

#     if isinstance(stepping_data, dict) and len(stepping_data) > 0:
#         symbol = "002611"
#         stepping_data_Index = stepping_data[symbol]

#         # 繪製擬合曲綫圖;
#         # plot1 = matplotlib.pyplot.scatter(
#         #     [int(i) for i in range(0, len(stepping_data_Index["date_transaction"]))],  # stepping_data_Index["date_transaction"],  # Xdata,
#         #     stepping_data_Index["focus"],  # YdataMean,
#         #     s=None,
#         #     c='blue',
#         #     edgecolors=None,
#         #     linewidths=1,
#         #     marker='o',
#         #     alpha=0.5,
#         #     label='observation values'
#         # )  # 繪製散點圖;
#         # plot2 = matplotlib.pyplot.plot(
#         #     [int(i) for i in range(0, len(stepping_data_Index["date_transaction"]))],  # stepping_data_Index["date_transaction"],  # Xdata,
#         #     stepping_data_Index["focus"],  # YdataMean,  # Yvals,
#         #     color='red',
#         #     linewidth=2.0,
#         #     linestyle='-',
#         #     alpha=1,
#         #     label='polyfit values'
#         # )  # 繪製平滑折綫圖;
#         # matplotlib.pyplot.xticks(idx, Xdata)  # 設置顯示坐標橫軸刻度標簽;
#         # matplotlib.pyplot.xlabel('Independent Variable ( x )')  # 設置顯示橫軸標題為 'Independent Variable ( x )'
#         # matplotlib.pyplot.ylabel('Dependent Variable ( y )')  # 設置顯示縱軸標題為 'Dependent Variable ( y )'
#         # matplotlib.pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
#         # matplotlib.pyplot.title('4 parameter logistic model')  # 設置顯示圖標題;
#         # matplotlib.pyplot.show()  # 顯示圖片;
#         # 繪製散點圖;
#         axes_1.scatter(
#             [int(i) for i in range(0, len(stepping_data_Index["date_transaction"]))],  # stepping_data_Index["date_transaction"],  # Xdata,
#             stepping_data_Index["focus"],  # YdataMean,
#             s=15,  # 點大小，取 0 表示不顯示;
#             c='blue',  # 點顔色;
#             edgecolors='blue',  # 邊顔色;
#             linewidths=0.25,  # 邊粗細;
#             marker='o',  # 點標志;
#             alpha=1,  # 點透明度;
#             label='observation values'
#         )
#         # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
#         # 繪製平滑折綫圖;
#         axes_1.plot(
#             [int(i) for i in range(0, len(stepping_data_Index["date_transaction"]))],  # stepping_data_Index["date_transaction"],  # Xdata,
#             stepping_data_Index["focus"],  # YdataMean,  # Yvals,
#             color='red',
#             linewidth=1.0,
#             linestyle='-',
#             alpha=1,
#             label='polyfit values'
#         )

#         # 描繪擬合曲綫的置信區間;
#         axes_1.fill_between(
#             [int(i) for i in range(0, len(stepping_data_Index["date_transaction"]))],  # stepping_data_Index["date_transaction"],  # Xdata,
#             stepping_data_Index["low_price"],  # YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
#             stepping_data_Index["high_price"],  # YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
#             color='grey',  # 'black',
#             linestyle=':',
#             linewidth=0.5,
#             alpha=0.15,
#         )
#         # axes_1.fill_between(
#         #     [int(i) for i in range(0, len(stepping_data_Index["date_transaction"]))],  # stepping_data_Index["date_transaction"],  # Xdata,
#         #     [float(min([float(stepping_data_Index["opening_price"][i]), float(stepping_data_Index["close_price"][i])])) for i in range(0, len(stepping_data_Index["focus"]))],  # stepping_data_Index["opening_price"],  # YvalsUncertaintyLower,
#         #     [float(max([float(stepping_data_Index["opening_price"][i]), float(stepping_data_Index["close_price"][i])])) for i in range(0, len(stepping_data_Index["focus"]))],  # stepping_data_Index["close_price"],  # YvalsUncertaintyUpper,
#         #     color='grey',  # 'black',
#         #     linestyle=':',
#         #     linewidth=0.5,
#         #     alpha=0.15,
#         # )

#         # 設置坐標軸標題
#         axes_1.set_xlabel(
#             "transaction date",
#             fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
#             fontsize='xx-small'
#         )
#         axes_1.set_ylabel(
#             "transaction price",
#             fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
#             fontsize='xx-small'
#         )
#         # # 確定橫縱坐標範圍;
#         # axes_1.set_xlim(
#         #     float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
#         #     float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
#         # )
#         # axes_1.set_ylim(
#         #     float(numpy.min(Ydata)) - float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1),
#         #     float(numpy.max(Ydata)) + float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1)
#         # )
#         # # 設置坐標軸間隔和標簽
#         # axes_1.set_xticks(Xdata)
#         # # axes_1.set_xticklabels(
#         # #     [
#         # #         str(round(int(Xdata[0]), 0)),
#         # #         str(round(int(Xdata[1]), 0)),
#         # #         str(round(int(Xdata[2]), 0)),
#         # #         str(round(int(Xdata[3]), 0)),
#         # #         str(round(int(Xdata[4]), 0)),
#         # #         str(round(int(Xdata[5]), 0)),
#         # #         str(round(int(Xdata[6]), 0)),
#         # #         str(round(int(Xdata[7]), 0)),
#         # #         str(round(int(Xdata[8]), 0)),
#         # #         str(round(int(Xdata[9]), 0)),
#         # #         str(round(int(Xdata[10]), 0))
#         # #     ],
#         # #     rotation=0,
#         # #     ha='center',
#         # #     fontdict={"family": "SimSun", "size": 7},
#         # #     fontsize='xx-small'
#         # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
#         # axes_1.set_xticklabels(
#         #     [str(stepping_data_Index["date_transaction"][i]) for i in range(0, len(stepping_data_Index["date_transaction"]))],
#         #     rotation=0,
#         #     ha='center',
#         #     fontdict={"family": "SimSun", "size": 7},
#         #     fontsize='xx-small'
#         # )
#         for tl in axes_1.get_xticklabels():
#             tl.set_rotation(90)  # 旋轉角度;
#             tl.set_ha('center')
#             tl.set_fontsize(7)
#             tl.set_fontfamily('SimSun')
#             # tl.set_color('red')
#         # axes_1.set_yticks(YdataMean)  # Ydata;
#         # # axes_1.set_yticklabels(
#         # #     [
#         # #         str(round(int(YdataMean[0]), 0)),
#         # #         str(round(int(YdataMean[1]), 0)),
#         # #         str(round(int(YdataMean[2]), 0)),
#         # #         str(round(int(YdataMean[3]), 0)),
#         # #         str(round(int(YdataMean[4]), 0)),
#         # #         str(round(int(YdataMean[5]), 0)),
#         # #         str(round(int(YdataMean[6]), 0)),
#         # #         str(round(int(YdataMean[7]), 0)),
#         # #         str(round(int(YdataMean[8]), 0)),
#         # #         str(round(int(YdataMean[9]), 0)),
#         # #         str(round(int(YdataMean[10]), 0))
#         # #     ],
#         # #     rotation=0,
#         # #     ha='right',
#         # #     fontdict={"family": "SimSun", "size": 7},
#         # #     fontsize='xx-small'
#         # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
#         # axes_1.set_yticklabels(
#         #     [str(round(int(stepping_data_Index["focus"][i]), 0)) for i in range(0, len(stepping_data_Index["focus"]))],
#         #     rotation=0,
#         #     ha='right',
#         #     fontdict={"family": "SimSun", "size": 7},
#         #     fontsize='xx-small'
#         # )
#         for tl in axes_1.get_yticklabels():
#             tl.set_rotation(0)
#             tl.set_ha('right')
#             tl.set_fontsize(7)
#             tl.set_fontfamily('SimSun')
#             # tl.set_color('red')
#         axes_1.grid(True, which='major', linestyle=':', color='grey', linewidth=0.25, alpha=0.3)  # which='minor'
#         axes_1.legend(
#             loc='lower right',
#             shadow=False,
#             frameon=False,
#             edgecolor='grey',
#             framealpha=0,
#             facecolor="none",
#             prop={"family": "Times New Roman", "size": 7},
#             fontsize='xx-small'
#         )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
#         axes_1.spines['left'].set_linewidth(0.1)
#         # axes_1.spines['left'].set_visible(False)  # 去除邊框;
#         axes_1.spines['top'].set_visible(False)
#         axes_1.spines['right'].set_visible(False)
#         # axes_1.spines['bottom'].set_visible(False)
#         axes_1.spines['bottom'].set_linewidth(0.1)
#         axes_1.set_title(
#             "market timing model ( training )",
#             fontdict={"family": "SimSun", "size": 7},
#             fontsize='xx-small'
#         )

#         # # https://github.com/matplotlib/mplfinance
#         # # 使用第三方擴展包「mplfinance」繪製日棒缐（K Days Line）圖;
#         # mplfinance.plot(
#         #     pandas.DataFrame({
#         #         "Date": [str(item) for item in stepping_data_Index["date_transaction"]],  # stepping_data_Index["date_transaction"],
#         #         "Open": stepping_data_Index["opening_price"],
#         #         "High": stepping_data_Index["high_price"],
#         #         "Low": stepping_data_Index["low_price"],
#         #         "Close": stepping_data_Index["close_price"],
#         #         "Volume": stepping_data_Index["turnover_volume"],
#         #     }),
#         #     type = "candle",  # 指定繪圖類型爲日棒缐圖（K Days Line），可取值：type="candle", type="line", type="renko", or type="pnf" ;
#         #     mav = (
#         #         # 1,  # 添加滑動平均缐（1 日）;
#         #         5,  # 添加滑動平均缐（5 日~周）;
#         #         20,  # 添加滑動平均缐（20 日~月）;
#         #         60  # 添加滑動平均缐（60 日~季）;
#         #     ),  # 添加滑動平均缐;
#         #     volume = True,  # 添加成交量柱形圖;
#         #     show_nontrading = False,  # 取 True 時，表示設定顯示非交易日，將非交易日添加爲空白;
#         #     # study = [
#         #     #     "macd",
#         #     #     "rsi"
#         #     # ],
#         #     # macd_n_fast = 12,
#         #     # macd_n_slow = 26,
#         #     # rsi_n = 14,
#         #     # style = mplfinance.make_mpf_style(
#         #     #     gridaxis = "both",  # 設置圖片網格缐位置;
#         #     #     gridstyle = "-.",  # 設置圖片網格缐形狀;
#         #     #     y_on_right = False,  # 設置 y 軸位置是否在右側;
#         #     #     marketcolors = mplfinance.make_marketcolors(
#         #     #         up = "green",
#         #     #         down = "red",
#         #     #         edge = "i",  # 設置棒圖方框邊缐顔色，取 "i" 值，表示繼承參數：up、down 的顔色配置;
#         #     #         wick = "i",  # 設置棒圖上下影缐顔色，，取 "i" 值，表示繼承參數：up、down 的顔色配置;
#         #     #         volume = "in",  # 設置成交量柱形圖顔色;
#         #     #         inherit = True  # 指定是否繼承;
#         #     #     )
#         #     # ),
#         #     # savefig = {"fname": "stock_K_Days_Line.png"},  # 將圖片存儲爲硬盤文檔;
#         #     ylabel = "transaction price",
#         #     ylabel_lower = "shares\ntransaction volume",
#         #     xlabel = "transaction date",
#         #     title = "\nstock %s candle line" % (symbol),
#         #     figratio = (15, 10),  # 設置圖片長、寬比;
#         #     figscale = 5  # 設置圖片質量等級;
#         # )

#     # if isinstance(testing_data, dict) and len(testing_data) > 0:
#     #     symbol = "002611"
#     #     testing_data_Index = testing_data[symbol]

#     #     # 繪製擬合曲綫圖;
#     #     # plot1 = matplotlib.pyplot.scatter(
#     #     #     [int(i) for i in range(0, len(testing_data_Index["date_transaction"]))],  # testing_data_Index["date_transaction"],  # Xdata,
#     #     #     testing_data_Index["focus"],  # YdataMean,
#     #     #     s=None,
#     #     #     c='blue',
#     #     #     edgecolors=None,
#     #     #     linewidths=1,
#     #     #     marker='o',
#     #     #     alpha=0.5,
#     #     #     label='observation values'
#     #     # )  # 繪製散點圖;
#     #     # plot2 = matplotlib.pyplot.plot(
#     #     #     [int(i) for i in range(0, len(testing_data_Index["date_transaction"]))],  # testing_data_Index["date_transaction"],  # Xdata,
#     #     #     testing_data_Index["focus"],  # YdataMean,  # Yvals,
#     #     #     color='red',
#     #     #     linewidth=2.0,
#     #     #     linestyle='-',
#     #     #     alpha=1,
#     #     #     label='polyfit values'
#     #     # )  # 繪製平滑折綫圖;
#     #     # matplotlib.pyplot.xticks(idx, Xdata)  # 設置顯示坐標橫軸刻度標簽;
#     #     # matplotlib.pyplot.xlabel('Independent Variable ( x )')  # 設置顯示橫軸標題為 'Independent Variable ( x )'
#     #     # matplotlib.pyplot.ylabel('Dependent Variable ( y )')  # 設置顯示縱軸標題為 'Dependent Variable ( y )'
#     #     # matplotlib.pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
#     #     # matplotlib.pyplot.title('4 parameter logistic model')  # 設置顯示圖標題;
#     #     # matplotlib.pyplot.show()  # 顯示圖片;
#     #     # 繪製散點圖;
#     #     axes_1.scatter(
#     #         [int(i) for i in range(0, len(testing_data_Index["date_transaction"]))],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         testing_data_Index["focus"],  # YdataMean,
#     #         s=15,  # 點大小，取 0 表示不顯示;
#     #         c='blue',  # 點顔色;
#     #         edgecolors='blue',  # 邊顔色;
#     #         linewidths=0.25,  # 邊粗細;
#     #         marker='o',  # 點標志;
#     #         alpha=1,  # 點透明度;
#     #         label='observation values'
#     #     )
#     #     # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
#     #     # 繪製平滑折綫圖;
#     #     axes_1.plot(
#     #         [int(i) for i in range(0, len(testing_data_Index["date_transaction"]))],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         testing_data_Index["focus"],  # YdataMean,  # Yvals,
#     #         color='red',
#     #         linewidth=1.0,
#     #         linestyle='-',
#     #         alpha=1,
#     #         label='polyfit values'
#     #     )

#     #     # 描繪擬合曲綫的置信區間;
#     #     axes_1.fill_between(
#     #         [int(i) for i in range(0, len(testing_data_Index["date_transaction"]))],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         testing_data_Index["low_price"],  # YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
#     #         testing_data_Index["high_price"],  # YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
#     #         color='grey',  # 'black',
#     #         linestyle=':',
#     #         linewidth=0.5,
#     #         alpha=0.15,
#     #     )
#     #     # axes_1.fill_between(
#     #     #     [int(i) for i in range(0, len(testing_data_Index["date_transaction"]))],  # testing_data_Index["date_transaction"],  # Xdata,
#     #     #     [float(min([float(testing_data_Index["opening_price"][i]), float(testing_data_Index["close_price"][i])])) for i in range(0, len(testing_data_Index["focus"]))],  # testing_data_Index["opening_price"],  # YvalsUncertaintyLower,
#     #     #     [float(max([float(testing_data_Index["opening_price"][i]), float(testing_data_Index["close_price"][i])])) for i in range(0, len(testing_data_Index["focus"]))],  # testing_data_Index["close_price"],  # YvalsUncertaintyUpper,
#     #     #     color='grey',  # 'black',
#     #     #     linestyle=':',
#     #     #     linewidth=0.5,
#     #     #     alpha=0.15,
#     #     # )

#     #     # 設置坐標軸標題
#     #     axes_1.set_xlabel(
#     #         "transaction date",
#     #         fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
#     #         fontsize='xx-small'
#     #     )
#     #     axes_1.set_ylabel(
#     #         "transaction price",
#     #         fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
#     #         fontsize='xx-small'
#     #     )
#     #     # # 確定橫縱坐標範圍;
#     #     # axes_1.set_xlim(
#     #     #     float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
#     #     #     float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
#     #     # )
#     #     # axes_1.set_ylim(
#     #     #     float(numpy.min(Ydata)) - float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1),
#     #     #     float(numpy.max(Ydata)) + float((numpy.max(Ydata) - numpy.min(Ydata)) * 0.1)
#     #     # )
#     #     # # 設置坐標軸間隔和標簽
#     #     # axes_1.set_xticks(Xdata)
#     #     # # axes_1.set_xticklabels(
#     #     # #     [
#     #     # #         str(round(int(Xdata[0]), 0)),
#     #     # #         str(round(int(Xdata[1]), 0)),
#     #     # #         str(round(int(Xdata[2]), 0)),
#     #     # #         str(round(int(Xdata[3]), 0)),
#     #     # #         str(round(int(Xdata[4]), 0)),
#     #     # #         str(round(int(Xdata[5]), 0)),
#     #     # #         str(round(int(Xdata[6]), 0)),
#     #     # #         str(round(int(Xdata[7]), 0)),
#     #     # #         str(round(int(Xdata[8]), 0)),
#     #     # #         str(round(int(Xdata[9]), 0)),
#     #     # #         str(round(int(Xdata[10]), 0))
#     #     # #     ],
#     #     # #     rotation=0,
#     #     # #     ha='center',
#     #     # #     fontdict={"family": "SimSun", "size": 7},
#     #     # #     fontsize='xx-small'
#     #     # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
#     #     # axes_1.set_xticklabels(
#     #     #     [str(testing_data_Index["date_transaction"][i]) for i in range(0, len(testing_data_Index["date_transaction"]))],
#     #     #     rotation=0,
#     #     #     ha='center',
#     #     #     fontdict={"family": "SimSun", "size": 7},
#     #     #     fontsize='xx-small'
#     #     # )
#     #     for tl in axes_1.get_xticklabels():
#     #         tl.set_rotation(90)  # 旋轉角度;
#     #         tl.set_ha('center')
#     #         tl.set_fontsize(7)
#     #         tl.set_fontfamily('SimSun')
#     #         # tl.set_color('red')
#     #     # axes_1.set_yticks(YdataMean)  # Ydata;
#     #     # # axes_1.set_yticklabels(
#     #     # #     [
#     #     # #         str(round(int(YdataMean[0]), 0)),
#     #     # #         str(round(int(YdataMean[1]), 0)),
#     #     # #         str(round(int(YdataMean[2]), 0)),
#     #     # #         str(round(int(YdataMean[3]), 0)),
#     #     # #         str(round(int(YdataMean[4]), 0)),
#     #     # #         str(round(int(YdataMean[5]), 0)),
#     #     # #         str(round(int(YdataMean[6]), 0)),
#     #     # #         str(round(int(YdataMean[7]), 0)),
#     #     # #         str(round(int(YdataMean[8]), 0)),
#     #     # #         str(round(int(YdataMean[9]), 0)),
#     #     # #         str(round(int(YdataMean[10]), 0))
#     #     # #     ],
#     #     # #     rotation=0,
#     #     # #     ha='right',
#     #     # #     fontdict={"family": "SimSun", "size": 7},
#     #     # #     fontsize='xx-small'
#     #     # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
#     #     # axes_1.set_yticklabels(
#     #     #     [str(round(int(testing_data_Index["focus"][i]), 0)) for i in range(0, len(testing_data_Index["focus"]))],
#     #     #     rotation=0,
#     #     #     ha='right',
#     #     #     fontdict={"family": "SimSun", "size": 7},
#     #     #     fontsize='xx-small'
#     #     # )
#     #     for tl in axes_1.get_yticklabels():
#     #         tl.set_rotation(0)
#     #         tl.set_ha('right')
#     #         tl.set_fontsize(7)
#     #         tl.set_fontfamily('SimSun')
#     #         # tl.set_color('red')
#     #     axes_1.grid(True, which='major', linestyle=':', color='grey', linewidth=0.25, alpha=0.3)  # which='minor'
#     #     axes_1.legend(
#     #         loc='lower right',
#     #         shadow=False,
#     #         frameon=False,
#     #         edgecolor='grey',
#     #         framealpha=0,
#     #         facecolor="none",
#     #         prop={"family": "Times New Roman", "size": 7},
#     #         fontsize='xx-small'
#     #     )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
#     #     axes_1.spines['left'].set_linewidth(0.1)
#     #     # axes_1.spines['left'].set_visible(False)  # 去除邊框;
#     #     axes_1.spines['top'].set_visible(False)
#     #     axes_1.spines['right'].set_visible(False)
#     #     # axes_1.spines['bottom'].set_visible(False)
#     #     axes_1.spines['bottom'].set_linewidth(0.1)
#     #     axes_1.set_title(
#     #         "market timing model ( testing )",
#     #         fontdict={"family": "SimSun", "size": 7},
#     #         fontsize='xx-small'
#     #     )

#     #     # # https://github.com/matplotlib/mplfinance
#     #     # # 使用第三方擴展包「mplfinance」繪製日棒缐（K Days Line）圖;
#     #     # mplfinance.plot(
#     #     #     pandas.DataFrame({
#     #     #         "Date": [str(item) for item in testing_data_Index["date_transaction"]],  # testing_data_Index["date_transaction"],
#     #     #         "Open": testing_data_Index["opening_price"],
#     #     #         "High": testing_data_Index["high_price"],
#     #     #         "Low": testing_data_Index["low_price"],
#     #     #         "Close": testing_data_Index["close_price"],
#     #     #         "Volume": testing_data_Index["turnover_volume"],
#     #     #     }),
#     #     #     type = "candle",  # 指定繪圖類型爲日棒缐圖（K Days Line），可取值：type="candle", type="line", type="renko", or type="pnf" ;
#     #     #     mav = (
#     #     #         # 1,  # 添加滑動平均缐（1 日）;
#     #     #         5,  # 添加滑動平均缐（5 日~周）;
#     #     #         20,  # 添加滑動平均缐（20 日~月）;
#     #     #         60  # 添加滑動平均缐（60 日~季）;
#     #     #     ),  # 添加滑動平均缐;
#     #     #     volume = True,  # 添加成交量柱形圖;
#     #     #     show_nontrading = False,  # 取 True 時，表示設定顯示非交易日，將非交易日添加爲空白;
#     #     #     # study = [
#     #     #     #     "macd",
#     #     #     #     "rsi"
#     #     #     # ],
#     #     #     # macd_n_fast = 12,
#     #     #     # macd_n_slow = 26,
#     #     #     # rsi_n = 14,
#     #     #     # style = mplfinance.make_mpf_style(
#     #     #     #     gridaxis = "both",  # 設置圖片網格缐位置;
#     #     #     #     gridstyle = "-.",  # 設置圖片網格缐形狀;
#     #     #     #     y_on_right = False,  # 設置 y 軸位置是否在右側;
#     #     #     #     marketcolors = mplfinance.make_marketcolors(
#     #     #     #         up = "green",
#     #     #     #         down = "red",
#     #     #     #         edge = "i",  # 設置棒圖方框邊缐顔色，取 "i" 值，表示繼承參數：up、down 的顔色配置;
#     #     #     #         wick = "i",  # 設置棒圖上下影缐顔色，，取 "i" 值，表示繼承參數：up、down 的顔色配置;
#     #     #     #         volume = "in",  # 設置成交量柱形圖顔色;
#     #     #     #         inherit = True  # 指定是否繼承;
#     #     #     #     )
#     #     #     # ),
#     #     #     # savefig = {"fname": "stock_K_Days_Line.png"},  # 將圖片存儲爲硬盤文檔;
#     #     #     ylabel = "transaction price",
#     #     #     ylabel_lower = "shares\ntransaction volume",
#     #     #     xlabel = "transaction date",
#     #     #     title = "\nstock %s candle line" % (symbol),
#     #     #     figratio = (15, 10),  # 設置圖片長、寬比;
#     #     #     figscale = 5  # 設置圖片質量等級;
#     #     # )

#     # fig.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
#     matplotlib.pyplot.show()
#     # plot_Thread = threading.Thread(target=matplotlib.pyplot.show, args=(), daemon=False)
#     # plot_Thread.start()
#     # matplotlib.pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;


# print(str("configFile=" + str(configFile) + "\n" + "input_K_Line=" + str(input_K_Line_Daily_file) + "\n" + "is_save_pickle=" + str(is_save_pickle) + "\n" + "output_pickle_K_Line=" + str(output_pickle_K_Line_Daily_file) + "\n" + "is_save_csv=" + str(is_save_csv) + "\n" + "output_csv_K_Line=" + str(output_csv_K_Line_Daily_file_dir) + "\n" + "is_save_xlsx=" + str(is_save_xlsx) + "\n" + "output_xlsx_K_Line=" + str(output_xlsx_K_Line_Daily_file_dir)), end = '')
sys.stdout.write(str("configFile=" + str(configFile) + "\n" + "input_K_Line=" + str(input_K_Line_Daily_file) + "\n" + "is_save_pickle=" + str(is_save_pickle) + "\n" + "output_pickle_K_Line=" + str(output_pickle_K_Line_Daily_file) + "\n" + "is_save_csv=" + str(is_save_csv) + "\n" + "output_csv_K_Line=" + str(output_csv_K_Line_Daily_file_dir) + "\n" + "is_save_xlsx=" + str(is_save_xlsx) + "\n" + "output_xlsx_K_Line=" + str(output_xlsx_K_Line_Daily_file_dir)))

sys.stdout.write(str(r"\r\n\r\n"))  # 寫入區隔符（"\r\n\r\n"）;

# 將 Python 數據類型 numpy.NaN 轉換爲 "NaN" 字符串類型;
stepping_data_2 = {}
if isinstance(stepping_data, dict):
    for key_1, value_1 in stepping_data.items():
        # print("Key_1: %s, Value_1:\n%s" % (key_1, value_1))
        if isinstance(value_1, dict):
            stepping_data_2[key_1] = {}
            for key_2, value_2 in value_1.items():
                # print("Key_2: %s, Value_2:\n%s" % (key_2, value_2))
                if isinstance(value_2, list):
                    stepping_data_2[key_1][key_2] = []
                    for i in range(0, len(value_2), 1):
                        if (not (isinstance(value_2[i], dict) or isinstance(value_2[i], list) or isinstance(value_2[i], str) or (isinstance(value_2[i], datetime.date) or isinstance(value_2[i], datetime.datetime) or isinstance(value_2[i], datetime.time)))) and ((value_2[i] is None) or numpy.isnan(value_2[i])):
                            # stepping_data_2[key_1][key_2][i] = str("NaN")
                            stepping_data_2[key_1][key_2].append(str("NaN"))  # 使用 list.append() 函數在列表末尾追加推入新元素;
                        elif (not (isinstance(value_2[i], dict) or isinstance(value_2[i], list) or isinstance(value_2[i], str) or (isinstance(value_2[i], datetime.date) or isinstance(value_2[i], datetime.datetime) or isinstance(value_2[i], datetime.time)))) and ((isinstance(value_2[i], float) or isinstance(value_2[i], int)) and math.isinf(value_2[i]) and (value_2[i] > 0.0)):
                            # stepping_data_2[key_1][key_2][i] = str("+Infinity")
                            stepping_data_2[key_1][key_2].append(str("+Infinity"))
                        elif (not (isinstance(value_2[i], dict) or isinstance(value_2[i], list) or isinstance(value_2[i], str) or (isinstance(value_2[i], datetime.date) or isinstance(value_2[i], datetime.datetime) or isinstance(value_2[i], datetime.time)))) and ((isinstance(value_2[i], float) or isinstance(value_2[i], int)) and math.isinf(value_2[i]) and (value_2[i] < 0.0)):
                            # stepping_data_2[key_1][key_2][i] = str("-Infinity")
                            stepping_data_2[key_1][key_2].append(str("-Infinity"))
                        elif (not (isinstance(value_2[i], dict) or isinstance(value_2[i], list) or isinstance(value_2[i], str))) and (isinstance(value_2[i], datetime.date) or isinstance(value_2[i], datetime.datetime) or isinstance(value_2[i], datetime.time)):
                            # stepping_data_2[key_1][key_2][i] = str(value_2[i].strftime("%Y-%m-%d"))
                            stepping_data_2[key_1][key_2].append(str(value_2[i].strftime("%Y-%m-%d")))
                        else:
                            stepping_data_2[key_1][key_2].append(value_2[i])
                elif (not (isinstance(value_2, dict) or isinstance(value_2, list) or isinstance(value_2, str) or (isinstance(value_2, datetime.date) or isinstance(value_2, datetime.datetime) or isinstance(value_2, datetime.time)))) and ((value_2 is None) or numpy.isnan(value_2)):
                    stepping_data_2[key_1][key_2] = str("NaN")
                elif (not (isinstance(value_2, dict) or isinstance(value_2, list) or isinstance(value_2, str) or (isinstance(value_2, datetime.date) or isinstance(value_2, datetime.datetime) or isinstance(value_2, datetime.time)))) and ((isinstance(value_2, float) or isinstance(value_2, int)) and math.isinf(value_2) and (value_2 > 0.0)):
                    stepping_data_2[key_1][key_2] = str("+Infinity")
                elif (not (isinstance(value_2, dict) or isinstance(value_2, list) or isinstance(value_2, str) or (isinstance(value_2, datetime.date) or isinstance(value_2, datetime.datetime) or isinstance(value_2, datetime.time)))) and ((isinstance(value_2, float) or isinstance(value_2, int)) and math.isinf(value_2) and (value_2 < 0.0)):
                    stepping_data_2[key_1][key_2] = str("-Infinity")
                elif (not (isinstance(value_2, dict) or isinstance(value_2, list) or isinstance(value_2, str))) and (isinstance(value_2, datetime.date) or isinstance(value_2, datetime.datetime) or isinstance(value_2, datetime.time)):
                    stepping_data_2[key_1][key_2] = str(value_2.strftime("%Y-%m-%d"))
                else:
                    stepping_data_2[key_1][key_2] = value_2
# print(stepping_data_2)

sys.stdout.write(str(json.dumps(stepping_data_2)))  # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（dict）對象轉換爲 JSON 字符串;

exit(0)
