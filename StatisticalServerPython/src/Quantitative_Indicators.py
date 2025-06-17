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

# 匯入自定義的日棒缐（K-Line）原始數據整理模組脚本文檔「./Quantitative_Data_Cleaning.py」;
# import Quantitative_Data_Cleaning as Quantitative_Data_Cleaning



# 零（0）、量化指標：勢;

# 計算趨勢抽象指標（勢强）示意值;
def Intuitive_Momentum(
    Series_Array,  # = [],
    P1,  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight = None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
):

    index_P1_random = []
    if isinstance(Series_Array, list) and len(Series_Array) > 0:

        # index_P1_random = []
        for i in range(len(Series_Array)):

            index_P1 = numpy.nan  # None  # (-math.inf)  # float(0.0)
            if int(int(i) + int(1)) >= int(P1):

                # 用滑動筐遍歷序列數據截取指定區段;
                sliding_basket_Array = Series_Array[int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 用滑動筐遍歷序列數據截取指定區段;

                # 跳過序列中的第一個值，因爲第一個值無增長率;
                if int(int(i) + int(1)) > int(1):

                    # 計算强度（變化劇烈程度）示意;
                    # 增長率（正）纍計求和;
                    y_Positive = float(0.0)  # 增長率（正）纍計求和;
                    if int(len([float(sliding_basket_Array[j]) if (float(sliding_basket_Array[j]) > float(0.0)) else float(0.0) for j in range(len(sliding_basket_Array))])) > int(0):
                        y_Positive = float(sum([float(sliding_basket_Array[j]) if (float(sliding_basket_Array[j]) > float(0.0)) else float(0.0) for j in range(len(sliding_basket_Array))]))
                    # 衰退率（負）纍計求和;
                    y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                    if int(len([float(sliding_basket_Array[j]) if (float(sliding_basket_Array[j]) < float(0.0)) else float(0.0) for j in range(len(sliding_basket_Array))])) > int(0):
                        y_Negative = float(sum([float(sliding_basket_Array[j]) if (float(sliding_basket_Array[j]) < float(0.0)) else float(0.0) for j in range(len(sliding_basket_Array))]))
                    # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                    # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                    # for j in range(len(sliding_basket_Array)):
                    #     if float(sliding_basket_Array[j]) > float(0.0):
                    #         y_Positive = float(y_Positive + sliding_basket_Array[j])
                    #     elif float(sliding_basket_Array[j]) < float(0.0):
                    #         y_Negative = float(y_Negative + sliding_basket_Array[j])
                    #     # else:

                    # # 計算恆度（持續度，同向變化歷時）示意;
                    # # 增長率（正）的可能性（頻率）示意;
                    # y_P_Positive = float(1.0)  # 增長率（正）的可能性（頻率）示意;
                    if not (y_P_Positive is not None):
                        y_P_Positive = float(int(sum([int(1) if (float(sliding_basket_Array[j]) > float(0.0)) else int(0) for j in range(len(sliding_basket_Array))])) / int(len(sliding_basket_Array)))
                    # # 衰退率（負）的可能性（頻率）示意;
                    # y_P_Negative = float(1.0)  # 衰退率（負）的可能性（頻率）示意;
                    if not (y_P_Negative is not None):
                        y_P_Negative = float(int(sum([int(1) if (float(sliding_basket_Array[j]) < float(0.0)) else int(0) for j in range(len(sliding_basket_Array))])) / int(len(sliding_basket_Array)))
                    # if int(len(sliding_basket_Array)) > int(0):
                    #     y_P_Positive = float(int(sum([int(1) if (float(sliding_basket_Array[j]) > float(0.0)) else int(0) for j in range(len(sliding_basket_Array))])) / int(len(sliding_basket_Array)))
                    #     y_P_Negative = float(int(sum([int(1) if (float(sliding_basket_Array[j]) < float(0.0)) else int(0) for j in range(len(sliding_basket_Array))])) / int(len(sliding_basket_Array)))
                    # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                    # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                    # # for j in range(len(sliding_basket_Array)):
                    # #     if float(sliding_basket_Array[j]) > float(0.0):
                    # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                    # #     elif float(sliding_basket_Array[j]) < float(0.0):
                    # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                    # #     else:
                    # # if int(len(sliding_basket_Array)) > int(0):
                    # #     y_P_Positive = float(int(y_P_Positive) / int(len(sliding_basket_Array)))
                    # #     y_P_Negative = float(int(y_P_Negative) / int(len(sliding_basket_Array)))

                    # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                    # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                    # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                    # 增長率（正）並衰退率（負）的纍加總計;
                    y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                    if int(len(sliding_basket_Array)) > int(0):
                        # y_total = float(sum([float(sliding_basket_Array[j] * y_P_Positive) if (float(sliding_basket_Array[j]) > float(0.0)) else float(sliding_basket_Array[j] * y_P_Negative) for j in range(len(sliding_basket_Array))]))
                        # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        y_total = float(sum([float(sliding_basket_Array[j]) for j in range(len(sliding_basket_Array))]))  # 每次交易利潤 × 頻率，纍加總計;
                        # y_total = float(sum([float(sliding_basket_Array[j] * y_P_Positive) for j in range(len(sliding_basket_Array))]))  # 每次交易利潤 × 頻率，纍加總計;

                    # 增長率（正）並衰退率（負）值的位置（重心）示意;
                    y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                    if int(len(sliding_basket_Array)) > int(0):
                        y_focus = float(numpy.mean(sliding_basket_Array))

                    # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                    y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                    if int(len(sliding_basket_Array)) > int(0):
                        if int(len(sliding_basket_Array)) == int(1):
                            y_amplitude = numpy.std(sliding_basket_Array)
                        elif int(len(sliding_basket_Array)) > int(1):
                            y_amplitude = numpy.std(sliding_basket_Array, ddof=1)
                        # else:
                        y_amplitude = float(y_amplitude)

                    # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                    # # weight = []
                    # if isinstance(weight, list) and len(weight) <= 0:
                    #     # weight = [float(1.0) for j in range(len(sliding_basket_Array))]
                    #     weight = [float(int(int(j) + int(1)) / int(len(sliding_basket_Array))) for j in range(len(sliding_basket_Array))]
                    if not (weight is not None):
                        # weight = []
                        # weight = [float(1.0) for j in range(len(sliding_basket_Array))]
                        weight = [float(int(int(j) + int(1)) / int(len(sliding_basket_Array))) for j in range(len(sliding_basket_Array))]
                    # print(weight)

                    y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                    if (isinstance(sliding_basket_Array, list) and len(sliding_basket_Array) > 0) and (isinstance(weight, list) and len(weight) > 0):
                        y = float(sum([float(weight[j] * sliding_basket_Array[j] * y_P_Positive) if (float(sliding_basket_Array[j]) > float(0.0)) else float(weight[j] * sliding_basket_Array[j] * y_P_Negative) for j in range(len(sliding_basket_Array))]))
                        # y = float(sum([float(weight[j] * sliding_basket_Array[j]) for j in range(len(sliding_basket_Array))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        # for j in range(len(sliding_basket_Array)):
                        #     # y = y + float(weight[j] * sliding_basket_Array[j])
                        #     if float(sliding_basket_Array[j]) > float(0.0):
                        #         y = y + float(weight[j] * sliding_basket_Array[j] * y_P_Positive)
                        #     else:
                        #         y = y + float(weight[j] * sliding_basket_Array[j] * y_P_Negative)
                    elif (isinstance(sliding_basket_Array, list) and len(sliding_basket_Array) > 0) and (isinstance(weight, list) and len(weight) <= 0):
                        y = float(sum([float(sliding_basket_Array[j] * y_P_Positive) if (float(sliding_basket_Array[j]) > float(0.0)) else float(sliding_basket_Array[j] * y_P_Negative) for j in range(len(sliding_basket_Array))]))
                        # y = float(sum([float(sliding_basket_Array[j]) for j in range(len(sliding_basket_Array))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        # for j in range(len(sliding_basket_Array)):
                        #     # y = y + float(sliding_basket_Array[j])
                        #     if float(sliding_basket_Array[j]) > float(0.0):
                        #         y = y + float(sliding_basket_Array[j] * y_P_Positive)
                        #     else:
                        #         y = y + float(sliding_basket_Array[j] * y_P_Negative)
                    # else:

                    # # 優化目標變量合入風險因素優勢比 Logistic 化;
                    # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                    index_P1 = float(y)
            index_P1_random.append(index_P1)  # 使用 list.append() 函數在列表末尾追加推入新元素;

    return index_P1_random

# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["ticker_symbol"]["close_price"],  # = [],
#     int(3),  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# )
# print("closing price growth rate :\n", return_Intuitive_Momentum)


# 計算日棒缐趨勢抽象指標（勢强）示意值;
def Intuitive_Momentum_KLine(
    KLine_Series_Dict,  # = {},
    P1,  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight = None,  # = [],  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
    Intuitive_Momentum = lambda argument : argument
):
    # index_PickStock_P1 = float((index_PickStock_P1_turnover_volume_growth_rate) + ((index_PickStock_P1_opening_price_growth_rate + index_PickStock_P1_closing_price_growth_rate) * (index_PickStock_P1_closing_minus_opening_price_growth_rate * index_PickStock_P1_high_price_proportion * index_PickStock_P1_low_price_proportion)))  # 選股指標，勢強示意;

    index_P1_random = {}
    if isinstance(KLine_Series_Dict, dict) and len(KLine_Series_Dict) > 0:
        if ("date_transaction" in KLine_Series_Dict and isinstance(KLine_Series_Dict["date_transaction"], list)) and ("turnover_volume" in KLine_Series_Dict and isinstance(KLine_Series_Dict["turnover_volume"], list)) and ("opening_price" in KLine_Series_Dict and isinstance(KLine_Series_Dict["opening_price"], list)) and ("close_price" in KLine_Series_Dict and isinstance(KLine_Series_Dict["close_price"], list)) and ("low_price" in KLine_Series_Dict and isinstance(KLine_Series_Dict["low_price"], list)) and ("high_price" in KLine_Series_Dict and isinstance(KLine_Series_Dict["high_price"], list)) and ("turnover_volume_growth_rate" in KLine_Series_Dict and isinstance(KLine_Series_Dict["turnover_volume_growth_rate"], list)) and ("opening_price_growth_rate" in KLine_Series_Dict and isinstance(KLine_Series_Dict["opening_price_growth_rate"], list)) and ("closing_price_growth_rate" in KLine_Series_Dict and isinstance(KLine_Series_Dict["closing_price_growth_rate"], list)) and ("closing_minus_opening_price_growth_rate" in KLine_Series_Dict and isinstance(KLine_Series_Dict["closing_minus_opening_price_growth_rate"], list)) and ("high_price_proportion" in KLine_Series_Dict and isinstance(KLine_Series_Dict["high_price_proportion"], list)) and ("low_price_proportion" in KLine_Series_Dict and isinstance(KLine_Series_Dict["low_price_proportion"], list)):

            # index_P1_random["P1_turnover_volume_growth_rate"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            # index_P1_random["P1_opening_price_growth_rate"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            # index_P1_random["P1_closing_price_growth_rate"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            # index_P1_random["P1_closing_minus_opening_price_growth_rate"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            # index_P1_random["P1_high_price_proportion"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            # index_P1_random["P1_low_price_proportion"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            # index_P1_random["P1_Intuitive_Momentum"] = [None] * int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))
            index_P1_random["P1_turnover_volume_growth_rate"] = []
            index_P1_random["P1_opening_price_growth_rate"] = []
            index_P1_random["P1_closing_price_growth_rate"] = []
            index_P1_random["P1_closing_minus_opening_price_growth_rate"] = []
            index_P1_random["P1_high_price_proportion"] = []
            index_P1_random["P1_low_price_proportion"] = []
            index_P1_random["P1_Intuitive_Momentum"] = []
            for i in range(int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])]))):
                if int(i) < int(min([len(KLine_Series_Dict["date_transaction"]), len(KLine_Series_Dict["turnover_volume"]), len(KLine_Series_Dict["opening_price"]), len(KLine_Series_Dict["close_price"]), len(KLine_Series_Dict["low_price"]), len(KLine_Series_Dict["high_price"]), len(KLine_Series_Dict["turnover_volume_growth_rate"]), len(KLine_Series_Dict["opening_price_growth_rate"]), len(KLine_Series_Dict["closing_price_growth_rate"]), len(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), len(KLine_Series_Dict["high_price_proportion"]), len(KLine_Series_Dict["low_price_proportion"])])):
                    if int(int(i) + int(1)) < int(P1) or int(int(i) + int(1)) <= int(1):

                        # 使用 list.append() 函數在列表末尾追加推入新元素;
                        index_P1_random["P1_turnover_volume_growth_rate"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                        index_P1_random["P1_opening_price_growth_rate"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)
                        index_P1_random["P1_closing_price_growth_rate"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)
                        index_P1_random["P1_closing_minus_opening_price_growth_rate"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)
                        index_P1_random["P1_high_price_proportion"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)
                        index_P1_random["P1_low_price_proportion"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)
                        index_P1_random["P1_Intuitive_Momentum"].append(numpy.nan)  # None  # (-math.inf)  # float(0.0)

                    elif int(int(i) + int(1)) >= int(P1) and int(int(i) + int(1)) > int(1):

                        # x0 = KLine_Series_Dict["date_transaction"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 交易日期;
                        # x1 = KLine_Series_Dict["turnover_volume"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交量;
                        # x2 = KLine_Series_Dict["turnover_amount"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交總金額;
                        # x3 = KLine_Series_Dict["opening_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 開盤成交價;
                        # x4 = KLine_Series_Dict["close_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤成交價;
                        # x5 = KLine_Series_Dict["low_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 最低成交價;
                        # x6 = KLine_Series_Dict["high_price"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 最高成交價;
                        # x7 = KLine_Series_Dict["focus"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 當日成交價重心;
                        # x8 = KLine_Series_Dict["amplitude"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 當日成交價絕對振幅;
                        # x9 = KLine_Series_Dict["amplitude_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 當日成交價相對振幅（%）;
                        # x10 = KLine_Series_Dict["opening_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                        # x11 = KLine_Series_Dict["closing_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                        # x12 = KLine_Series_Dict["low_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                        # x13 = KLine_Series_Dict["high_price_Standardization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                        x14 = KLine_Series_Dict["turnover_volume_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交量的成長率;
                        x15 = KLine_Series_Dict["opening_price_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 開盤價的成長率;
                        x16 = KLine_Series_Dict["closing_price_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價的成長率;
                        x17 = KLine_Series_Dict["closing_minus_opening_price_growth_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價減開盤價的成長率;
                        x18 = KLine_Series_Dict["high_price_proportion"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價和開盤價裏的最大值占最高價的比例;
                        x19 = KLine_Series_Dict["low_price_proportion"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 最低價占收盤價和開盤價裏的最小值的比例;
                        # x20 = KLine_Series_Dict["turnover_rate"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 成交量換手率;
                        # x21 = KLine_Series_Dict["price_earnings"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 每股收益（公司經營利潤率 ÷ 股本）;
                        # x22 = KLine_Series_Dict["book_value_per_share"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 每股净值（公司净資產 ÷ 股本）;
                        # x23 = KLine_Series_Dict["capitalization"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 總市值;
                        # x24 = KLine_Series_Dict["moving_average_5"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 5 日滑動平均缐;
                        # x25 = KLine_Series_Dict["moving_average_10"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 10 日滑動平均缐;
                        # x26 = KLine_Series_Dict["moving_average_20"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 20 日滑動平均缐;
                        # x27 = KLine_Series_Dict["moving_average_30"][int(int(i) - int(P1) + int(1)):int(int(i) + int(1)):1]  # 收盤價 30 日滑動平均缐;

                        # # 成交量指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # if int(len([float(x14[j]) if (float(x14[j]) > float(0.0)) else float(0.0) for j in range(len(x14))])) > int(0):
                        #     y_Positive = float(sum([float(x14[j]) if (float(x14[j]) > float(0.0)) else float(0.0) for j in range(len(x14))]))
                        # # 衰退率（負）纍計求和;
                        # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # if int(len([float(x14[j]) if (float(x14[j]) < float(0.0)) else float(0.0) for j in range(len(x14))])) > int(0):
                        #     y_Negative = float(sum([float(x14[j]) if (float(x14[j]) < float(0.0)) else float(0.0) for j in range(len(x14))]))
                        # # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # # for j in range(len(x14)):
                        # #     if float(x14[j]) > float(0.0):
                        # #         y_Positive = float(y_Positive + x14[j])
                        # #     elif float(x14[j]) < float(0.0):
                        # #         y_Negative = float(y_Negative + x14[j])
                        # #     # else:

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # if int(len(x14)) > int(0):
                        #     y_P_Positive = float(int(sum([int(1) if (float(x14[j]) > float(0.0)) else int(0) for j in range(len(x14))])) / int(len(x14)))
                        #     y_P_Negative = float(int(sum([int(1) if (float(x14[j]) < float(0.0)) else int(0) for j in range(len(x14))])) / int(len(x14)))
                        # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # # for j in range(len(x14)):
                        # #     if float(x14[j]) > float(0.0):
                        # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                        # #     elif float(x14[j]) < float(0.0):
                        # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                        # #     # else:
                        # # if int(len(x14)) > int(0):
                        # #     y_P_Positive = float(int(y_P_Positive) / int(len(x14)))
                        # #     y_P_Negative = float(int(y_P_Negative) / int(len(x14)))

                        # # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                        # # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                        # # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                        # if int(len(x14)) > int(0):
                        #     # y_total = float(sum([float(x14[j] * y_P_Positive) if (float(x14[j]) > float(0.0)) else float(x14[j] * y_P_Negative) for j in range(len(x14))]))
                        #     # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        #     y_total = float(sum([float(x14[j]) for j in range(len(x14))]))  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = float(sum([float(x14[j] * y_P_Positive) for j in range(len(x14))]))  # 每次交易利潤 × 頻率，纍加總計;

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if int(len(x14)) > int(0):
                        #     y_focus = float(numpy.mean(x14))

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if int(len(x14)) > int(0):
                        #     if int(len(x14)) == int(1):
                        #         y_amplitude = numpy.std(x14)
                        #     elif int(len(x14)) > int(1):
                        #         y_amplitude = numpy.std(x14, ddof=1)
                        #     # else:
                        #     y_amplitude = float(y_amplitude)

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = []
                        # # weight = [float(1.0) for j in range(len(x14))]
                        # weight = [float(int(int(j) + int(1)) / int(len(x14))) for j in range(len(x14))]
                        # # print(weight)

                        # y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if int(len(x14)) > int(0) and int(len(weight)) > int(0):
                        #     y = float(sum([float(weight[j] * x14[j] * y_P_Positive) if (float(x14[j]) > float(0.0)) else float(weight[j] * x14[j] * y_P_Negative) for j in range(len(x14))]))
                        #     # y = float(sum([float(weight[j] * x14[j]) for j in range(len(x14))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x14)):
                        #     #     # y = y + float(weight[j] * x14[j])
                        #     #     if float(x14[j]) > float(0.0):
                        #     #         y = y + float(weight[j] * x14[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(weight[j] * x14[j] * y_P_Negative)
                        # elif int(len(x14)) > int(0) and int(len(weight)) <= int(0):
                        #     y = float(sum([float(x14[j] * y_P_Positive) if (float(x14[j]) > float(0.0)) else float(x14[j] * y_P_Negative) for j in range(len(x14))]))
                        #     # y = float(sum([float(x14[j]) for j in range(len(x14))]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x14)):
                        #     #     # y = y + float(x14[j])
                        #     #     if float(x14[j]) > float(0.0):
                        #     #         y = y + float(x14[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(x14[j] * y_P_Negative)
                        # # else:

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                        # index_PickStock_P1_turnover_volume_growth_rate = float(y)

                        y = Intuitive_Momentum(
                            x14,  # = [],
                            P1,  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        )
                        index_PickStock_P1_turnover_volume_growth_rate = float(y[int(int(len(y)) - int(1))])
                        index_P1_random["P1_turnover_volume_growth_rate"].append(float(index_PickStock_P1_turnover_volume_growth_rate))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # # 開盤價指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # if int(len([float(x15[j]) if (float(x15[j]) > float(0.0)) else float(0.0) for j in range(len(x15))])) > int(0):
                        #     y_Positive = float(sum([float(x15[j]) if (float(x15[j]) > float(0.0)) else float(0.0) for j in range(len(x15))]))
                        # # 衰退率（負）纍計求和;
                        # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # if int(len([float(x15[j]) if (float(x15[j]) < float(0.0)) else float(0.0) for j in range(len(x15))])) > int(0):
                        #     y_Negative = float(sum([float(x15[j]) if (float(x15[j]) < float(0.0)) else float(0.0) for j in range(len(x15))]))
                        # # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # # for j in range(len(x15)):
                        # #     if float(x15[j]) > float(0.0):
                        # #         y_Positive = float(y_Positive + x15[j])
                        # #     elif float(x15[j]) < float(0.0):
                        # #         y_Negative = float(y_Negative + x15[j])
                        # #     # else:

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # if int(len(x15)) > int(0):
                        #     y_P_Positive = float(int(sum([int(1) if (float(x15[j]) > float(0.0)) else int(0) for j in range(len(x15))])) / int(len(x15)))
                        #     y_P_Negative = float(int(sum([int(1) if (float(x15[j]) < float(0.0)) else int(0) for j in range(len(x15))])) / int(len(x15)))
                        # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # # for j in range(len(x15)):
                        # #     if float(x15[j]) > float(0.0):
                        # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                        # #     elif float(x15[j]) < float(0.0):
                        # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                        # #     # else:
                        # # if int(len(x15)) > int(0):
                        # #     y_P_Positive = float(int(y_P_Positive) / int(len(x15)))
                        # #     y_P_Negative = float(int(y_P_Negative) / int(len(x15)))

                        # # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                        # # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                        # # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                        # if int(len(x15)) > int(0):
                        #     # y_total = float(sum([float(x15[j] * y_P_Positive) if (float(x15[j]) > float(0.0)) else float(x15[j] * y_P_Negative) for j in range(len(x15))]))
                        #     # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        #     y_total = float(sum([float(x15[j]) for j in range(len(x15))]))  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = float(sum([float(x15[j] * y_P_Positive) for j in range(len(x15))]))  # 每次交易利潤 × 頻率，纍加總計;

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if int(len(x15)) > int(0):
                        #     y_focus = float(numpy.mean(x15))

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if int(len(x15)) > int(0):
                        #     if int(len(x15)) == int(1):
                        #         y_amplitude = numpy.std(x15)
                        #     elif int(len(x15)) > int(1):
                        #         y_amplitude = numpy.std(x15, ddof=1)
                        #     # else:
                        #     y_amplitude = float(y_amplitude)

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = []
                        # # weight = [float(1.0) for j in range(len(x15))]
                        # weight = [float(int(int(j) + int(1)) / int(len(x15))) for j in range(len(x15))]
                        # # print(weight)

                        # y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if int(len(x15)) > int(0) and int(len(weight)) > int(0):
                        #     y = float(sum([float(weight[j] * x15[j] * y_P_Positive) if (float(x15[j]) > float(0.0)) else float(weight[j] * x15[j] * y_P_Negative) for j in range(len(x15))]))
                        #     # y = float(sum([float(weight[j] * x15[j]) for j in range(len(x15))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x15)):
                        #     #     # y = y + float(weight[j] * x15[j])
                        #     #     if float(x15[j]) > float(0.0):
                        #     #         y = y + float(weight[j] * x15[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(weight[j] * x15[j] * y_P_Negative)
                        # elif int(len(x15)) > int(0) and int(len(weight)) <= int(0):
                        #     y = float(sum([float(x15[j] * y_P_Positive) if (float(x15[j]) > float(0.0)) else float(x15[j] * y_P_Negative) for j in range(len(x15))]))
                        #     # y = float(sum([float(x15[j]) for j in range(len(x15))]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x15)):
                        #     #     # y = y + float(x15[j])
                        #     #     if float(x15[j]) > float(0.0):
                        #     #         y = y + float(x15[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(x15[j] * y_P_Negative)
                        # # else:

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                        # index_PickStock_P1_opening_price_growth_rate = float(y);

                        y = Intuitive_Momentum(
                            x15,  # = [],
                            P1,  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        )
                        index_PickStock_P1_opening_price_growth_rate = float(y[int(int(len(y)) - int(1))])
                        index_P1_random["P1_opening_price_growth_rate"].append(float(index_PickStock_P1_opening_price_growth_rate))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # # 收盤價指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # if int(len([float(x16[j]) if (float(x16[j]) > float(0.0)) else float(0.0) for j in range(len(x16))])) > int(0):
                        #     y_Positive = float(sum([float(x16[j]) if (float(x16[j]) > float(0.0)) else float(0.0) for j in range(len(x16))]))
                        # # 衰退率（負）纍計求和;
                        # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # if int(len([float(x16[j]) if (float(x16[j]) < float(0.0)) else float(0.0) for j in range(len(x16))])) > int(0):
                        #     y_Negative = float(sum([float(x16[j]) if (float(x16[j]) < float(0.0)) else float(0.0) for j in range(len(x16))]))
                        # # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # # for j in range(len(x16)):
                        # #     if float(x16[j]) > float(0.0):
                        # #         y_Positive = float(y_Positive + x16[j])
                        # #     elif float(x16[j]) < float(0.0):
                        # #         y_Negative = float(y_Negative + x16[j])
                        # #     # else:

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # if int(len(x16)) > int(0):
                        #     y_P_Positive = float(int(sum([int(1) if (float(x16[j]) > float(0.0)) else int(0) for j in range(len(x16))])) / int(len(x16)))
                        #     y_P_Negative = float(int(sum([int(1) if (float(x16[j]) < float(0.0)) else int(0) for j in range(len(x16))])) / int(len(x16)))
                        # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # # for j in range(len(x16)):
                        # #     if float(x16[j]) > float(0.0):
                        # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                        # #     elif float(x16[j]) < float(0.0):
                        # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                        # #     # else:
                        # # if int(len(x16)) > int(0):
                        # #     y_P_Positive = float(int(y_P_Positive) / int(len(x16)))
                        # #     y_P_Negative = float(int(y_P_Negative) / int(len(x16)))

                        # # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                        # # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                        # # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                        # if int(len(x16)) > int(0):
                        #     # y_total = float(sum([float(x16[j] * y_P_Positive) if (float(x16[j]) > float(0.0)) else float(x16[j] * y_P_Negative) for j in range(len(x16))]))
                        #     # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        #     y_total = float(sum([float(x16[j]) for j in range(len(x16))]))  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = float(sum([float(x16[j] * y_P_Positive) for j in range(len(x16))]))  # 每次交易利潤 × 頻率，纍加總計;

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if int(len(x16)) > int(0):
                        #     y_focus = float(numpy.mean(x16))

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if int(len(x16)) > int(0):
                        #     if int(len(x16)) == int(1):
                        #         y_amplitude = numpy.std(x16)
                        #     elif int(len(x16)) > int(1):
                        #         y_amplitude = numpy.std(x16, ddof=1)
                        #     # else:
                        #     y_amplitude = float(y_amplitude)

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = []
                        # # weight = [float(1.0) for j in range(len(x16))]
                        # weight = [float(int(int(j) + int(1)) / int(len(x16))) for j in range(len(x16))]
                        # # print(weight)

                        # y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if int(len(x16)) > int(0) and int(len(weight)) > int(0):
                        #     y = float(sum([float(weight[j] * x16[j] * y_P_Positive) if (float(x16[j]) > float(0.0)) else float(weight[j] * x16[j] * y_P_Negative) for j in range(len(x16))]))
                        #     # y = float(sum([float(weight[j] * x16[j]) for j in range(len(x16))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x16)):
                        #     #     # y = y + float(weight[j] * x16[j])
                        #     #     if float(x16[j]) > float(0.0):
                        #     #         y = y + float(weight[j] * x16[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(weight[j] * x16[j] * y_P_Negative)
                        # elif int(len(x16)) > int(0) and int(len(weight)) <= int(0):
                        #     y = float(sum([float(x16[j] * y_P_Positive) if (float(x16[j]) > float(0.0)) else float(x16[j] * y_P_Negative) for j in range(len(x16))]))
                        #     # y = float(sum([float(x16[j]) for j in range(len(x16))]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x16)):
                        #     #     # y = y + float(x16[j])
                        #     #     if float(x16[j]) > float(0.0):
                        #     #         y = y + float(x16[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(x16[j] * y_P_Negative)
                        # # else:

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                        # index_PickStock_P1_closing_price_growth_rate = float(y);

                        y = Intuitive_Momentum(
                            x16,  # = [],
                            P1,  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        )
                        index_PickStock_P1_closing_price_growth_rate = float(y[int(int(len(y)) - int(1))])
                        index_P1_random["P1_closing_price_growth_rate"].append(float(index_PickStock_P1_closing_price_growth_rate))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # # 開盤價與收盤價差值（日情緒）指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # if int(len([float(x17[j]) if (float(x17[j]) > float(0.0)) else float(0.0) for j in range(len(x17))])) > int(0):
                        #     y_Positive = float(sum([float(x17[j]) if (float(x17[j]) > float(0.0)) else float(0.0) for j in range(len(x17))]))
                        # # 衰退率（負）纍計求和;
                        # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # if int(len([float(x17[j]) if (float(x17[j]) < float(0.0)) else float(0.0) for j in range(len(x17))])) > int(0):
                        #     y_Negative = float(sum([float(x17[j]) if (float(x17[j]) < float(0.0)) else float(0.0) for j in range(len(x17))]))
                        # # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # # for j in range(len(x17)):
                        # #     if float(x17[j]) > float(0.0):
                        # #         y_Positive = float(y_Positive + x17[j])
                        # #     elif float(x17[j]) < float(0.0):
                        # #         y_Negative = float(y_Negative + x17[j])
                        # #     # else:

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # if int(len(x17)) > int(0):
                        #     y_P_Positive = float(int(sum([int(1) if (float(x17[j]) > float(0.0)) else int(0) for j in range(len(x17))])) / int(len(x17)))
                        #     y_P_Negative = float(int(sum([int(1) if (float(x17[j]) < float(0.0)) else int(0) for j in range(len(x17))])) / int(len(x17)))
                        # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # # for j in range(len(x17)):
                        # #     if float(x17[j]) > float(0.0):
                        # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                        # #     elif float(x17[j]) < float(0.0):
                        # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                        # #     # else:
                        # # if int(len(x17)) > int(0):
                        # #     y_P_Positive = float(int(y_P_Positive) / int(len(x17)))
                        # #     y_P_Negative = float(int(y_P_Negative) / int(len(x17)))

                        # # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                        # # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                        # # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                        # if int(len(x17)) > int(0):
                        #     # y_total = float(sum([float(x17[j] * y_P_Positive) if (float(x17[j]) > float(0.0)) else float(x17[j] * y_P_Negative) for j in range(len(x17))]))
                        #     # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        #     y_total = float(sum([float(x17[j]) for j in range(len(x17))]))  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = float(sum([float(x17[j] * y_P_Positive) for j in range(len(x17))]))  # 每次交易利潤 × 頻率，纍加總計;

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if int(len(x17)) > int(0):
                        #     y_focus = float(numpy.mean(x17))

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if int(len(x17)) > int(0):
                        #     if int(len(x17)) == int(1):
                        #         y_amplitude = numpy.std(x17)
                        #     elif int(len(x17)) > int(1):
                        #         y_amplitude = numpy.std(x17, ddof=1)
                        #     # else:
                        #     y_amplitude = float(y_amplitude)

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = []
                        # # weight = [float(1.0) for j in range(len(x17))]
                        # weight = [float(int(int(j) + int(1)) / int(len(x17))) for j in range(len(x17))]
                        # # print(weight)

                        # y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if int(len(x17)) > int(0) and int(len(weight)) > int(0):
                        #     y = float(sum([float(weight[j] * x17[j] * y_P_Positive) if (float(x17[j]) > float(0.0)) else float(weight[j] * x17[j] * y_P_Negative) for j in range(len(x17))]))
                        #     # y = float(sum([float(weight[j] * x17[j]) for j in range(len(x17))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x17)):
                        #     #     # y = y + float(weight[j] * x17[j])
                        #     #     if float(x17[j]) > float(0.0):
                        #     #         y = y + float(weight[j] * x17[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(weight[j] * x17[j] * y_P_Negative)
                        # elif int(len(x17)) > int(0) and int(len(weight)) <= int(0):
                        #     y = float(sum([float(x17[j] * y_P_Positive) if (float(x17[j]) > float(0.0)) else float(x17[j] * y_P_Negative) for j in range(len(x17))]))
                        #     # y = float(sum([float(x17[j]) for j in range(len(x17))]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x17)):
                        #     #     # y = y + float(x17[j])
                        #     #     if float(x17[j]) > float(0.0):
                        #     #         y = y + float(x17[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(x17[j] * y_P_Negative)
                        # # else:

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                        # index_PickStock_P1_closing_minus_opening_price_growth_rate = float(y);

                        y = Intuitive_Momentum(
                            x17,  # = [],
                            P1,  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        )
                        index_PickStock_P1_closing_minus_opening_price_growth_rate = float(y[int(int(len(y)) - int(1))])
                        index_P1_random["P1_closing_minus_opening_price_growth_rate"].append(float(index_PickStock_P1_closing_minus_opening_price_growth_rate))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # # 最高價挑高（日情緒）指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # if int(len([float(x18[j]) if (float(x18[j]) > float(0.0)) else float(0.0) for j in range(len(x18))])) > int(0):
                        #     y_Positive = float(sum([float(x18[j]) if (float(x18[j]) > float(0.0)) else float(0.0) for j in range(len(x18))]))
                        # # 衰退率（負）纍計求和;
                        # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # if int(len([float(x18[j]) if (float(x18[j]) < float(0.0)) else float(0.0) for j in range(len(x18))])) > int(0):
                        #     y_Negative = float(sum([float(x18[j]) if (float(x18[j]) < float(0.0)) else float(0.0) for j in range(len(x18))]))
                        # # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # # for j in range(len(x18)):
                        # #     if float(x18[j]) > float(0.0):
                        # #         y_Positive = float(y_Positive + x18[j])
                        # #     elif float(x18[j]) < float(0.0):
                        # #         y_Negative = float(y_Negative + x18[j])
                        # #     # else:

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # if int(len(x18)) > int(0):
                        #     y_P_Positive = float(int(sum([int(1) if (float(x18[j]) > float(0.0)) else int(0) for j in range(len(x18))])) / int(len(x18)))
                        #     y_P_Negative = float(int(sum([int(1) if (float(x18[j]) < float(0.0)) else int(0) for j in range(len(x18))])) / int(len(x18)))
                        # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # # for j in range(len(x18)):
                        # #     if float(x18[j]) > float(0.0):
                        # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                        # #     elif float(x18[j]) < float(0.0):
                        # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                        # #     # else:
                        # # if int(len(x18)) > int(0):
                        # #     y_P_Positive = float(int(y_P_Positive) / int(len(x18)))
                        # #     y_P_Negative = float(int(y_P_Negative) / int(len(x18)))

                        # # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                        # # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                        # # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                        # if int(len(x18)) > int(0):
                        #     # y_total = float(sum([float(x18[j] * y_P_Positive) if (float(x18[j]) > float(0.0)) else float(x18[j] * y_P_Negative) for j in range(len(x18))]))
                        #     # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        #     y_total = float(sum([float(x18[j]) for j in range(len(x18))]))  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = float(sum([float(x18[j] * y_P_Positive) for j in range(len(x18))]))  # 每次交易利潤 × 頻率，纍加總計;

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if int(len(x18)) > int(0):
                        #     y_focus = float(numpy.mean(x18))

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if int(len(x18)) > int(0):
                        #     if int(len(x18)) == int(1):
                        #         y_amplitude = numpy.std(x18)
                        #     elif int(len(x18)) > int(1):
                        #         y_amplitude = numpy.std(x18, ddof=1)
                        #     # else:
                        #     y_amplitude = float(y_amplitude)

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = []
                        # # weight = [float(1.0) for j in range(len(x18))]
                        # weight = [float(int(int(j) + int(1)) / int(len(x18))) for j in range(len(x18))]
                        # # print(weight)

                        # y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if int(len(x18)) > int(0) and int(len(weight)) > int(0):
                        #     y = float(sum([float(weight[j] * x18[j] * y_P_Positive) if (float(x18[j]) > float(0.0)) else float(weight[j] * x18[j] * y_P_Negative) for j in range(len(x18))]))
                        #     # y = float(sum([float(weight[j] * x18[j]) for j in range(len(x18))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x18)):
                        #     #     # y = y + float(weight[j] * x18[j])
                        #     #     if float(x18[j]) > float(0.0):
                        #     #         y = y + float(weight[j] * x18[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(weight[j] * x18[j] * y_P_Negative)
                        # elif int(len(x18)) > int(0) and int(len(weight)) <= int(0):
                        #     y = float(sum([float(x18[j] * y_P_Positive) if (float(x18[j]) > float(0.0)) else float(x18[j] * y_P_Negative) for j in range(len(x18))]))
                        #     # y = float(sum([float(x18[j]) for j in range(len(x18))]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x18)):
                        #     #     # y = y + float(x18[j])
                        #     #     if float(x18[j]) > float(0.0):
                        #     #         y = y + float(x18[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(x18[j] * y_P_Negative)
                        # # else:

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                        # index_PickStock_P1_high_price_proportion = float(y);

                        y = Intuitive_Momentum(
                            x18,  # = [],
                            P1,  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        )
                        index_PickStock_P1_high_price_proportion = float(y[int(int(len(y)) - int(1))])
                        index_P1_random["P1_high_price_proportion"].append(float(index_PickStock_P1_high_price_proportion))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # # 最低價落低（日情緒）指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # if int(len([float(x19[j]) if (float(x19[j]) > float(0.0)) else float(0.0) for j in range(len(x19))])) > int(0):
                        #     y_Positive = float(sum([float(x19[j]) if (float(x19[j]) > float(0.0)) else float(0.0) for j in range(len(x19))]))
                        # # 衰退率（負）纍計求和;
                        # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # if int(len([float(x19[j]) if (float(x19[j]) < float(0.0)) else float(0.0) for j in range(len(x19))])) > int(0):
                        #     y_Negative = float(sum([float(x19[j]) if (float(x19[j]) < float(0.0)) else float(0.0) for j in range(len(x19))]))
                        # # y_Positive = float(0.0)  # 增長率（正）纍計求和;
                        # # y_Negative = float(0.0)  # 衰退率（負）纍計求和;
                        # # for j in range(len(x19)):
                        # #     if float(x19[j]) > float(0.0):
                        # #         y_Positive = float(y_Positive + x19[j])
                        # #     elif float(x19[j]) < float(0.0):
                        # #         y_Negative = float(y_Negative + x19[j])
                        # #     # else:

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # if int(len(x19)) > int(0):
                        #     y_P_Positive = float(int(sum([int(1) if (float(x19[j]) > float(0.0)) else int(0) for j in range(len(x19))])) / int(len(x19)))
                        #     y_P_Negative = float(int(sum([int(1) if (float(x19[j]) < float(0.0)) else int(0) for j in range(len(x19))])) / int(len(x19)))
                        # # y_P_Positive = int(0)  # float(0.0)  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = int(0)  # float(0.0)  # 衰退率（負）的可能性（頻率）示意;
                        # # for j in range(len(x19)):
                        # #     if float(x19[j]) > float(0.0):
                        # #         y_P_Positive = int(int(y_P_Positive) + int(1))
                        # #     elif float(x19[j]) < float(0.0):
                        # #         y_P_Negative = int(int(y_P_Negative) + int(1))
                        # #     # else:
                        # # if int(len(x19)) > int(0):
                        # #     y_P_Positive = float(int(y_P_Positive) / int(len(x19)))
                        # #     y_P_Negative = float(int(y_P_Negative) / int(len(x19)))

                        # # # y = float(y_Positive * y_P_Positive)  # 增長率（正） × 頻率，纍加總計;
                        # # # y = float(y_Negative * y_P_Negative)  # 衰退率（負） × 頻率，纍加總計;
                        # # y = float(y_Positive * y_P_Positive) - float(y_Negative * y_P_Negative)

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = float(0.0)  # 增長率（正）並衰退率（負）的纍加總計;
                        # if int(len(x19)) > int(0):
                        #     # y_total = float(sum([float(x19[j] * y_P_Positive) if (float(x19[j]) > float(0.0)) else float(x19[j] * y_P_Negative) for j in range(len(x19))]))
                        #     # y_total = float(y_Positive * y_P_Positive) + float(y_Negative * y_P_Negative)
                        #     y_total = float(sum([float(x19[j]) for j in range(len(x19))]))  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = float(sum([float(x19[j] * y_P_Positive) for j in range(len(x19))]))  # 每次交易利潤 × 頻率，纍加總計;

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = float(0.0)  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if int(len(x19)) > int(0):
                        #     y_focus = float(numpy.mean(x19))

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = float(0.0)  # amplitude_rate  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if int(len(x19)) > int(0):
                        #     if int(len(x19)) == int(1):
                        #         y_amplitude = numpy.std(x19)
                        #     elif int(len(x19)) > int(1):
                        #         y_amplitude = numpy.std(x19, ddof=1)
                        #     # else:
                        #     y_amplitude = float(y_amplitude)

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = []
                        # # weight = [float(1.0) for j in range(len(x19))]
                        # weight = [float(int(int(j) + int(1)) / int(len(x19))) for j in range(len(x19))]
                        # # print(weight)

                        # y = float(0.0)  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if int(len(x19)) > int(0) and int(len(weight)) > int(0):
                        #     y = float(sum([float(weight[j] * x19[j] * y_P_Positive) if (float(x19[j]) > float(0.0)) else float(weight[j] * x19[j] * y_P_Negative) for j in range(len(x19))]))
                        #     # y = float(sum([float(weight[j] * x19[j]) for j in range(len(x19))]))  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x19)):
                        #     #     # y = y + float(weight[j] * x19[j])
                        #     #     if float(x19[j]) > float(0.0):
                        #     #         y = y + float(weight[j] * x19[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(weight[j] * x19[j] * y_P_Negative)
                        # elif int(len(x19)) > int(0) and int(len(weight)) <= int(0):
                        #     y = float(sum([float(x19[j] * y_P_Positive) if (float(x19[j]) > float(0.0)) else float(x19[j] * y_P_Negative) for j in range(len(x19))]))
                        #     # y = float(sum([float(x19[j]) for j in range(len(x19))]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = float(0.0)  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j in range(len(x19)):
                        #     #     # y = y + float(x19[j])
                        #     #     if float(x19[j]) > float(0.0):
                        #     #         y = y + float(x19[j] * y_P_Positive)
                        #     #     else:
                        #     #         y = y + float(x19[j] * y_P_Negative)
                        # # else:

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = float(y * float(y_Positive / y_Negative))  # 增長率 × 優勢比;

                        # index_PickStock_P1_low_price_proportion = float(y);

                        y = Intuitive_Momentum(
                            x19,  # = [],
                            P1,  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        )
                        index_PickStock_P1_low_price_proportion = float(y[int(int(len(y)) - int(1))])
                        index_P1_random["P1_low_price_proportion"].append(float(index_PickStock_P1_low_price_proportion))  # 使用 list.append() 函數在列表末尾追加推入新元素;

                        # 選股指標，勢強示意;
                        # abs(index_PickStock_P1_turnover_volume_growth_rate)
                        index_PickStock_P1 = float((index_PickStock_P1_turnover_volume_growth_rate) + ((index_PickStock_P1_opening_price_growth_rate + index_PickStock_P1_closing_price_growth_rate) * (index_PickStock_P1_closing_minus_opening_price_growth_rate * index_PickStock_P1_high_price_proportion * index_PickStock_P1_low_price_proportion)))  # 選股指標，勢強示意;
                        index_P1_random["P1_Intuitive_Momentum"].append(float(index_PickStock_P1))  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:

    return index_P1_random

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

# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["002611"]["close_price"],  # = [],
#     int(3),  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = None,  # = float(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = None,  # = float(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = None  # = []  # [float(int(int(i) + int(1)) / int(P1)) for i in range(P1)]  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# )
# print("closing price growth rate :\n", return_Intuitive_Momentum)

# return_Intuitive_Momentum_KLine = Intuitive_Momentum_KLine(
#     {
#         "date_transaction": training_data["002611"]["date_transaction"],  # 交易日期;
#         "turnover_volume": training_data["002611"]["turnover_volume"],  # 成交量;
#         # "turnover_amount": training_data["002611"]["turnover_amount"],  # 成交總金額;
#         "opening_price": training_data["002611"]["opening_price"],  # 開盤成交價;
#         "close_price": training_data["002611"]["close_price"],  # 收盤成交價;
#         "low_price": training_data["002611"]["low_price"],  # 最低成交價;
#         "high_price": training_data["002611"]["high_price"],  # 最高成交價;
#         # "focus": training_data["002611"]["focus"],  # 當日成交價重心;
#         # "amplitude": training_data["002611"]["amplitude"],  # 當日成交價絕對振幅;
#         # "amplitude_rate": training_data["002611"]["amplitude_rate"],  # 當日成交價相對振幅（%）;
#         # "opening_price_Standardization": training_data["002611"]["opening_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
#         # "closing_price_Standardization": training_data["002611"]["closing_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
#         # "low_price_Standardization": training_data["002611"]["low_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
#         # "high_price_Standardization": training_data["002611"]["high_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
#         "turnover_volume_growth_rate": training_data["002611"]["turnover_volume_growth_rate"],  # 成交量的成長率;
#         "opening_price_growth_rate": training_data["002611"]["opening_price_growth_rate"],  # 開盤價的成長率;
#         "closing_price_growth_rate": training_data["002611"]["closing_price_growth_rate"],  # 收盤價的成長率;
#         "closing_minus_opening_price_growth_rate": training_data["002611"]["closing_minus_opening_price_growth_rate"],  # 收盤價減開盤價的成長率;
#         "high_price_proportion": training_data["002611"]["high_price_proportion"],  # 收盤價和開盤價裏的最大值占最高價的比例;
#         "low_price_proportion": training_data["002611"]["low_price_proportion"],  # 最低價占收盤價和開盤價裏的最小值的比例;
#         # "turnover_rate": training_data["002611"]["turnover_rate"],  # 成交量換手率;
#         # "price_earnings": training_data["002611"]["price_earnings"],  # 每股收益（公司經營利潤率 ÷ 股本）;
#         # "book_value_per_share": training_data["002611"]["book_value_per_share"],  # 每股净值（公司净資產 ÷ 股本）;
#         # "capitalization": training_data["002611"]["capitalization"]  # 總市值;
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
