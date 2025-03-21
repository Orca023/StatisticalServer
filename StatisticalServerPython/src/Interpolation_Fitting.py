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


import math  # 導入 Python 原生包「math」，用於數學計算;
# import random  # 導入 Python 原生包「random」，用於生成隨機數;
# import json  # 導入 Python 原生模組「json」，用於解析 JSON 文檔;
# import multiprocessing
# from multiprocessing import Pool
# import os
# import sys
# import string  # 加載Python原生的字符串處理模組;
# import time  # 加載Python原生的日期數據處理模組;
# import datetime  # 加載Python原生的日期數據處理模組;
# import warnings
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
# import matplotlib  # as mpl
import matplotlib.pyplot as matplotlib_pyplot
# import matplotlib.font_manager as matplotlib_font_manager  # 導入第三方擴展包「matplotlib」中的字體管理器，用於設置生成圖片中文字的字體;
# import seaborn  # as sns
# https://www.scipy.org/docs.html
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# from scipy.optimize import minimize as scipy_optimize_minimize  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「minimize()」函數，用於通用形式優化問題求解（optimization）;
from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# from scipy.optimize import fsolve as scipy_optimize_fsolve  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「fsolve()」函數，用於多元非缐性方程組求根計算;
from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合鏈條插值（Spline）函數;
from scipy.interpolate import BSpline as scipy_interpolate_BSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「BSpline()」函數，用於擬合一維鏈條插值（1 Dimension BSpline）函數;
from scipy.interpolate import interp1d as scipy_interpolate_interp1d  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「interp1d()」函數，用於擬合一維插值（1 Dimension）函數;
from scipy.interpolate import UnivariateSpline as scipy_interpolate_UnivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「UnivariateSpline()」函數，用於擬合一維鏈條插值（1 Dimension spline）函數;
from scipy.interpolate import lagrange as scipy_interpolate_lagrange  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「lagrange()」函數，用於擬合一維拉格朗日法（lagrange）插值（1 Dimension）函數;
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

# # 匯入自定義路由模組脚本文檔「./Router.py」;
# # os.getcwd() # 獲取當前工作目錄路徑;
# # os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# # os.path.join(os.path.abspath("."), 'Router.py')  # 拼接路徑字符串;
# # pathlib.Path(os.path.join(os.path.abspath("."), Router.py)  # 返回路徑對象;
# # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# import Interface as Interface  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Router.py」;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
# File_Monitor = Router.Interface_File_Monitor
# http_Server = Router.Interface_http_Server
# http_Client = Router.Interface_http_Client
# check_json_format = Router.check_json_format
# win_file_is_Used = Router.win_file_is_Used
# clear_Directory = Router.clear_Directory
# formatByte = Router.formatByte

# # 匯入自定義統計描述模組脚本文檔「./Statis_Descript.py」;
# # # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」;
# from Statis_Descript import Transformation as Transformation  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的數據歸一化、數據變換函數「Transformation()」，用於將原始數據歸一化處理;
# from Statis_Descript import outliers_clean as outliers_clean  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的離群值檢查（含有粗大誤差的數據）函數「outliers_clean()」，用於檢查原始數據歸中的離群值;



# 任意形式一元方程函數曲缐擬合（Curve Fitting）;

# import numpy
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合插值函數;
# from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# https://www.scipy.org/docs.html
# 邏輯 5 參數模型（5-parameter logistic curve）曲缐擬合 f(x, P) = P[4] - (P[4] - P[1])/((1.0 + (x/P[2])^P[3])^P[5]) ;
def LC5Pfit(training_data, **args):

    # 變量實測值;
    # Xdata = [
    #     float(0),
    #     float(1),
    #     float(2),
    #     float(3),
    #     float(4),
    #     float(5),
    #     float(6),
    #     float(7),
    #     float(8),
    #     float(9),
    #     float(10)
    # ]  # 自變量 x 的實測數據;
    Xdata = numpy.array(training_data["Xdata"])
    # Ydata = [
    #     [float(1000), float(2000), float(3000)],
    #     [float(2000), float(3000), float(4000)],
    #     [float(3000), float(4000), float(5000)],
    #     [float(4000), float(5000), float(6000)],
    #     [float(5000), float(6000), float(7000)],
    #     [float(6000), float(7000), float(8000)],
    #     [float(7000), float(8000), float(9000)],
    #     [float(8000), float(9000), float(10000)],
    #     [float(9000), float(10000), float(11000)],
    #     [float(10000), float(11000), float(12000)],
    #     [float(11000), float(12000), float(13000)]
    # ]  # 應變量 y 的實測數據;
    Ydata = numpy.array(training_data["Ydata"])

    # 計算應變量 y 的實測值 Ydata 的均值;
    YdataMean = []
    for i in range(len(Ydata)):
        # if type(Ydata[i]) is list:
        # if isinstance(Ydata[i], list):
        if type(Ydata[i]) is numpy.ndarray:
            # yMean = float(numpy.mean(Ydata[i]))
            yMean = numpy.mean(Ydata[i])
            YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        else:
            # yMean = float(Ydata[i])
            yMean = Ydata[i]
            YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    # print(YdataMean)

    # 計算應變量 y 的實測值 Ydata 的均值;
    YdataSTD = []
    for i in range(len(Ydata)):
        # if type(Ydata[i]) is list:
        # if isinstance(Ydata[i], list):
        if type(Ydata[i]) is numpy.ndarray:
            if len(Ydata[i]) > 1:
                # ySTD = float(numpy.std(Ydata[i], ddof=1))
                ySTD = numpy.std(Ydata[i], ddof=1)
                YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            elif len(Ydata[i]) == 1:
                # ySTD = float(numpy.std(Ydata[i]))
                ySTD = numpy.std(Ydata[i])
                YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        else:
            ySTD = float(0.0)
            YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    # print(YdataSTD)

    # 配置函數參數默認值;
    # 參數上下限值;
    Plower = [
        -math.inf,
        -math.inf,
        -math.inf,
        -math.inf
        # -math.inf
    ]  # 參數上限值;
    Pupper = [
        math.inf,
        math.inf,
        math.inf,
        math.inf
        # math.inf
    ]  # 參數下限值;

    # 求參數初值;
    Pdata_0_P1 = min(YdataMean) * 0.9
    Pdata_0_P4 = max(YdataMean) * 1.1

    ln_Xdata = numpy.log(Xdata)
    # ln_Xdata = []
    # for i in range(len(Xdata)):
    #     ln_x = math.log(Xdata[i], math.e)
    #     ln_Xdata.append(ln_x)  # 使用 list.append() 函數在列表末尾追加推入新元素;

    ln_YdataMean = numpy.log((YdataMean - Pdata_0_P1) / (Pdata_0_P4 - YdataMean))  # numpy.log(numpy.divide((YdataMean - Pdata_0_P1), (Pdata_0_P4 - YdataMean)))
    # ln_YdataMean = []
    # for i in range(len(YdataMean)):
    #     temp = (YdataMean[i] - Pdata_0_P1) / (Pdata_0_P4 - YdataMean[i])
    #     ln_y = math.log(temp, math.e)
    #     ln_YdataMean.append(ln_y)  # 使用 list.append() 函數在列表末尾追加推入新元素;

    # 一元一次方程模型;
    def f_1(x, A, B):
        y = B - A*x
        return y

    # 一元一次方程擬合;
    A1, B1 = scipy_optimize_curve_fit(
        f_1,
        ln_Xdata,
        ln_YdataMean
        # p0=[
        #     (1 - min(YdataMean) / max(YdataMean)) / (1 - min(Xdata) / max(Xdata)),
        #     numpy.mean(Xdata)
        # ]
    )[0]

    Pdata_0_P3 = -A1  # (1 - min(YdataMean) / max(YdataMean)) / (1 - min(Xdata) / max(Xdata));
    # Pdata_0_P2 = float(math.pow(math.e, (B1 / Pdata_0_P3)))
    Pdata_0_P2 = math.exp(B1 / Pdata_0_P3)  # numpy.mean(Xdata);

    Pdata_0_P5 = float(1.0)

    # 參數初始值數組;
    # Pdata_0 = [
    #     min(YdataMean) * 0.9,
    #     numpy.mean(Xdata),
    #     (1 - min(YdataMean) / max(YdataMean)) / (1 - min(Xdata) / max(Xdata)),
    #     max(YdataMean) * 1.1
    #     # float(1)
    # ]
    Pdata_0 = [
        Pdata_0_P1,
        Pdata_0_P2,
        Pdata_0_P3,
        Pdata_0_P4
        # Pdata_0_P5
    ]

    # # 變量實測值擬合權重;
    weight = []
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

    testing_data = {}

    # 讀取傳入函數的可變參數值;
    for key, value in args.items():
        if key == "Pdata_0":
            Pdata_0 = value
        if key == "weight":
            weight = value
        if key == "Plower":
            Plower = value
        if key == "Pupper":
            Pupper = value
        if key == "testing_data":
            testing_data = value
        else:
            testing_data = training_data

    # 自定義的邏輯四參數模型（4-parameter logistic model）方程;
    # LC4P = lambda x, P1, P2, P3, P4: (P4 - (P4 - P1)/(1.0 + (x/P2)**P3))  # 參數 lambda 表示定義一個匿名函數，參數 arguments 表示傳入的自變量參數，冒號（:）之後的表達式表示函數返回值;
    def LC4P(x, P1, P2, P3, P4):
        # 應變量 y 為反應度光强度（relative light unit,RLU）;
        # 自變量 x 為含量劑量濃度（Dosage Concentration）;
        # 參數 P1 為 –∞ ≈ 0 劑量時的反應度相對光子數，是模型方程曲綫負向最小值漸近綫;
        # 參數 P2 為反應度相對光子數的最大值與最小值之差的一半時的含量劑量濃度值，即 y = ( ymax – ymin ) ÷ 2 對應的 x 值;
        # 參數 P3 為模型方程曲綫的斜率;
        # 參數 P4 為 +∞ 劑量時的反應度相對光子數，是模型方程曲綫正向最大值漸近綫;
        y = P4 - (P4 - P1)/(1.0 + (x/P2)**P3)
        return y

    # # 自定義的邏輯五參數模型（5-parameter logistic model）方程;
    # # LC5P = lambda x, P1, P2, P3, P4, P5: (P4 - (P4 - P1)/((1.0 + (x/P2)**P3)**P5))  # 參數 lambda 表示定義一個匿名函數，參數 arguments 表示傳入的自變量參數，冒號（:）之後的表達式表示函數返回值;
    # def LC5P(x, P1, P2, P3, P4, P5):
    #     # 應變量 y 為反應度光强度（relative light unit,RLU）;
    #     # 自變量 x 為含量劑量濃度（Dosage Concentration）;
    #     # 參數 P1 為 –∞ ≈ 0 劑量時的反應度相對光子數，是模型方程曲綫負向最小值漸近綫;
    #     # 參數 P2 為反應度相對光子數的最大值與最小值之差的一半時的含量劑量濃度值，即 y = ( ymax – ymin ) ÷ 2 對應的 x 值;
    #     # 參數 P3 為模型方程曲綫的斜率;
    #     # 參數 P4 為 +∞ 劑量時的反應度相對光子數，是模型方程曲綫正向最大值漸近綫;
    #     # 參數 P5 為不對稱因子，當參數 P5 = 1 時，函數曲綫是圍繞拐點的對稱圖形，5 參數模型退化等效於 4 參數模型;
    #     y = P4 - (P4 - P1)/((1.0 + (x/P2)**P3)**P5)
    #     return y

    # 使用第三方擴展包「scipy」中「optimize」模組的「curve_fit()」函數，使用非綫性最小二乘法擬合曲綫方程;
    # scipy.optimize.curve_fit(f, xdata, ydata, p0=None, sigma=None, absolute_sigma=False, check_finite=True, bounds=(-inf,inf), method=None, jac=None, **kwargs)
    # 參數 f 表示模型函數 f(x, ...) ，注意，必須將自變量作爲第一個參數，將待估參數作爲單獨的其餘參數;
    # 參數 xdata 表示實測值自變量數據;
    # 參數 ydata 表示實測值應變量數據;
    # 參數 p0 表i是待估參數的初值，預設初始值為 1 ;
    # 參數 sigma 表示 Ydata 的不確定度;
    # 參數 bounds 表示待估參數的上下限，輸入值為元組類型，元組裏的上下限元素必須是一個數組，數組長度等於待估參數的數目，可以使用帶有適當符號的 numpy.inf 值，來禁用部分參數的邊界，預設為無界限;
    # 參數 method 表示用於優化的方法，可取 'lm', 'trf', 'dogbox' 三個值之一，預設值為 'lm' ;
    # 加權最小二乘法擬合;
    if len(weight) > 0:
        popt, pcov, infodict, errmsg, ier = scipy_optimize_curve_fit(
            LC4P,  # LC5P,
            Xdata,
            YdataMean,  # Ydata,
            p0=Pdata_0,
            sigma=[1/we for we in weight if we > 0],  # 權重值的倒數列表;
            absolute_sigma=True,  # 表示參數 sigma 傳入的標準差是絕對的，而不只是一個相對的比例值;
            check_finite=True,
            bounds=(Plower, Pupper),
            method='lm',
            full_output=True
        )
    elif len(weight) == 0:
        popt, pcov, infodict, errmsg, ier = scipy_optimize_curve_fit(
            LC4P,  # LC5P,
            Xdata,
            YdataMean,  # Ydata,
            p0=Pdata_0,
            # sigma=[1/we for we in weight if we > 0],  # 權重值的倒數列表;
            # absolute_sigma=True,  # 表示參數 sigma 傳入的標準差是絕對的，而不只是一個相對的比例值;
            check_finite=True,
            bounds=(Plower, Pupper),
            method='lm',
            full_output=True
        )
    # print("P1 = ", popt[0])
    # print("P2 = ", popt[1])
    # print("P3 = ", popt[2])
    # print("P4 = ", popt[3])
    # print("P5 = ", popt[4])

    # 計算應變量 y 的擬合值;
    Yvals = LC4P(Xdata, popt[0], popt[1], popt[2], popt[3])
    # Yvals = LC5P(Xdata, popt[0], popt[1], popt[2], popt[3], popt[4])
    # Yvals_NDArray = LC4P(Xdata, popt[0], popt[1], popt[2], popt[3])
    # # Yvals_NDArray = LC5P(Xdata, popt[0], popt[1], popt[2], popt[3], popt[4])
    # Yvals = []
    # for i in range(len(Yvals_NDArray)):
    #     Yvals.append(float(Yvals_NDArray[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;

    # 計算擬合殘差值;
    Residual = YdataMean - Yvals  # Ydata;
    # Residual = []
    # for i in range(len(Yvals)):
    #     trainingResidual_1D = []
    #     for j in range(len(Ydata[i])):
    #         tres = Ydata[i][j] - Yvals[i]
    #         tres = float(tres)
    #         trainingResidual_1D.append(tres)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    #     Residual.append(trainingResidual_1D)

    # 計算擬合參數的誤差上下限;
    if len(weight) == 0:

        sigma_std = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
        # sigma_std = math.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
        # sigma_std_NDArray = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
        # sigma_std = []
        # for i in range(len(sigma_std_NDArray)):
        #     sigma_std.append(float(sigma_std_NDArray[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # 使用 curve_fit() 函數的返回值 pcov 矩陣的對角綫向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 pcov 矩陣的對角綫向量獲得的擬合誤差，得到總的不確定度;
        # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
        # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差向量傳遞給 curve_fit() 函數的 sigma 參數，同時將 absolute_sigma=True 設定爲 True 值，表示，傳入的 sigma 參數的標準差是絕對的，而不只是一個相對的比例值;
        CoefficientSTDlower = popt - sigma_std
        CoefficientSTDupper = popt + sigma_std

        # 計算應變量 y 的擬合值的誤差上下限;
        YvalsSTDlower = LC4P(Xdata, CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
        # YvalsSTDlower = LC5P(Xdata, CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3], CoefficientSTDlower[4])
        YvalsUncertaintyLower = []
        for i in range(len(YvalsSTDlower)):
            yul = Yvals[i] - numpy.sqrt(math.pow(YvalsSTDlower[i] - Yvals[i], 2) + math.pow(YdataSTD[i], 2))
            yul = float(yul)
            YvalsUncertaintyLower.append(yul)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        YvalsSTDupper = LC4P(Xdata, CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
        # YvalsSTDupper = LC5P(Xdata, CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3], CoefficientSTDupper[4])
        YvalsUncertaintyUpper = []
        for i in range(len(YvalsSTDupper)):
            yuu = Yvals[i] + numpy.sqrt(math.pow(YvalsSTDupper[i] - Yvals[i], 2) + math.pow(YdataSTD[i], 2))
            yuu = float(yuu)
            YvalsUncertaintyUpper.append(yuu)  # 使用 list.append() 函數在列表末尾追加推入新元素;

    # 生成插值數據，使繪製的擬合折綫圖平滑;
    # idx = range(len(Xdata))  # 記錄橫軸刻度標簽數;
    # Xnew = numpy.linspace(min(idx), max(idx), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
    # spl = scipy_interpolate_make_interp_spline(idx, Yvals, k=3)  # 使用第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，擬合三次多項式插值函數;
    Xnew = numpy.linspace(min(Xdata), max(Xdata), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
    spl = scipy_interpolate_make_interp_spline(Xdata, Yvals, k=3)  # 使用第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，擬合三次多項式插值函數;
    Ynew = spl(Xnew)  # 生成插值縱坐標值;

    # 生成置信區間上下限插值縱坐標值;
    if len(weight) == 0:
        # splLower = scipy_interpolate_make_interp_spline(idx, YvalsUncertaintyLower, k=3)
        splLower = scipy_interpolate_make_interp_spline(Xdata, YvalsUncertaintyLower, k=3)
        Ynewlower = splLower(Xnew)  # 生成置信區間下限插值縱坐標值;
        # splUpper = scipy_interpolate_make_interp_spline(idx, YvalsUncertaintyUpper, k=3)
        splUpper = scipy_interpolate_make_interp_spline(Xdata, YvalsUncertaintyUpper, k=3)
        Ynewupper = splUpper(Xnew)  # 生成置信區間上限插值縱坐標值;

    # 計算測試集數據的擬合值;
    testData = {}
    if isinstance(testing_data, dict) and len(testing_data) > 0:

        testData = testing_data

        if testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    yMean = float(numpy.mean(testing_data["Ydata"][i]))
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    yMean = float(testing_data["Ydata"][i])
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-Mean"] = testYdataMean
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    if len(testing_data["Ydata"][i]) > 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i], ddof=1))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    elif len(testing_data["Ydata"][i]) == 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i]))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:
                else:
                    ySTD = float(0.0)
                    testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-StandardDeviation"] = testYdataSTD

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = []  # 應變量 y 的擬合值;
            for i in range(len(testing_data["Xdata"])):
                # testYvals = LC4P(testing_data["Xdata"], popt[0], popt[1], popt[2], popt[3])
                # # testYvals = LC5P(testing_data["Xdata"], popt[0], popt[1], popt[2], popt[3], popt[4])
                yv = popt[3] - (popt[3] - popt[0]) / (1.0 + (testing_data["Xdata"][i] / popt[1])**popt[2])  # p4 - (p4 - p1)/(1.0 + (x[i]/p2)**p3);
                # yv = popt[3] - (popt[3] - popt[0]) / ((1.0 + (testing_data["Xdata"][i] / popt[1])**popt[2])**popt[4])  # p4 - (p4 - p1)/(1.0 + (x[i]/p2)**p3)**P5;
                yv = float(yv)
                testYvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit"] = testYvals

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = []  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = []  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if len(weight) == 0:
                # sigma_std = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
                # # 使用 curve_fit() 函數的返回值 pcov 矩陣的對角綫向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 pcov 矩陣的對角綫向量獲得的擬合誤差，得到總的不確定度;
                # # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
                # # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差向量傳遞給 curve_fit() 函數的 sigma 參數，同時將 absolute_sigma=True 設定爲 True 值，表示，傳入的 sigma 參數的標準差是絕對的，而不只是一個相對的比例值;
                # CoefficientSTDlower = popt - sigma_std
                # CoefficientSTDupper = popt + sigma_std

                # 計算應變量 y 的擬合值的誤差上下限;
                testYvalsSTDlower = LC4P(testing_data["Xdata"], CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
                # testYvalsSTDlower = LC5P(Xdata, CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3], CoefficientSTDlower[4])
                # testYvalsUncertaintyLower = []
                for i in range(len(testYvalsSTDlower)):
                    yul = testYvals[i] - numpy.sqrt(math.pow(testYvalsSTDlower[i] - testYvals[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyLower.append(yul)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                testYvalsSTDupper = LC4P(testing_data["Xdata"], CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
                # testYvalsSTDupper = LC5P(Xdata, CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3], CoefficientSTDupper[4])
                # testYvalsUncertaintyUpper = []
                for i in range(len(testYvalsSTDupper)):
                    yuu = testYvals[i] + numpy.sqrt(math.pow(testYvalsSTDupper[i] - testYvals[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyUpper.append(yuu)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper

            # 計算測試集數據的擬合殘差;
            testResidual = []  # 擬合殘差向量;
            for i in range(len(testing_data["Ydata"])):
                # resi = float(testYdataMean[i] - testYvals[i])
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    testResidual_1D = []
                    for j in range(len(testing_data["Ydata"][i])):
                        resi = float(testing_data["Ydata"][i][j] - testYvals[i])
                        testResidual_1D.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    testResidual.append(testResidual_1D)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    resi = float(testing_data["Ydata"][i] - testYvals[i])
                    testResidual.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Residual"] = testResidual

        elif (not(testing_data.__contains__("Xdata")) or len(testing_data["Xdata"]) <= 0) and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    yMean = float(numpy.mean(testing_data["Ydata"][i]))
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    yMean = float(testing_data["Ydata"][i])
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-Mean"] = testYdataMean
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    if len(testing_data["Ydata"][i]) > 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i], ddof=1))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    elif len(testing_data["Ydata"][i]) == 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i]))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:
                else:
                    ySTD = float(0.0)
                    testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-StandardDeviation"] = testYdataSTD

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = []  # 應變量 X 的擬合值;
            for i in range(len(testYdataMean)):
                xv = ((((popt[3] - popt[0]) / (popt[3] - testYdataMean[i])) - 1.0)**(1.0 / popt[2])) * popt[1]  # ((((P4 - P1) / (P4 - x[i])) - 1.0)**(1.0 / P3)) * P2;
                # xv = (((((popt[3] - popt[0]) / (popt[3] - testYdataMean[i])))**(1.0 / popt[4]) - 1.0)**(1.0 / popt[2])) * popt[1]  # (((((P4 - P1) / (P4 - x[i])))**(1.0 / P5) - 1.0)**(1.0 / P3)) * P2;
                testXvals.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Xvals"] = testXvals

            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = []  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = []  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if len(weight) == 0:
                # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲方程擬合（Curve Fitting）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
                testXdataSTD = []
                for j in range(len(testYdataSTD)):
                    xv = abs((((((popt[3] - popt[0]) / (popt[3] - testYdataMean[j])) - 1.0)**(1.0 / popt[2])) * popt[1]) - (((((popt[3] - popt[0]) / (popt[3] - (testYdataMean[j] + testYdataSTD[j]))) - 1.0)**(1.0 / popt[2])) * popt[1]))
                    # xv = abs(((((((popt[3] - popt[0]) / (popt[3] - testYdataMean[j])))**(1.0 / popt[4]) - 1.0)**(1.0 / popt[2])) * popt[1]) - ((((((popt[3] - popt[0]) / (popt[3] - (testYdataMean[j] + testYdataSTD[j]))))**(1.0 / popt[4]) - 1.0)**(1.0 / popt[2])) * popt[1]))
                    testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # 通過方程擬合算法（Curve Fitting Algorithm）的標準差（Standard Deviation）（擬合獲得方程參數的標準差），轉換爲擬合（Curve Fitting）之後的 X 值的擬合算法（Curve Fitting Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲擬合（Curve Fitting）之後的 X 值的總標準差（Standard Deviation）;
                for i in range(len(testYdataMean)):
                    xvsd = (((((popt[3] - sigma_std[3]) - (popt[0] - sigma_std[0])) / ((popt[3] - sigma_std[3]) - testYdataMean[i])) - 1.0)**(1.0 / (popt[2] - sigma_std[2]))) * (popt[1] - sigma_std[1])  # (((((P4 - sdP4) - (P1 - sdP1)) / ((P4 - sdP4) - x[i])) - 1.0)**(1.0 / (P3 - sdP3))) * (P2 - sdP2);
                    # xvsd = ((((((popt[3] - sigma_std[3]) - (popt[0] - sigma_std[0])) / ((popt[3] - sigma_std[3]) - testYdataMean[i])))**(1.0 / (popt[4] - sigma_std[4])) - 1.0)**(1.0 / (popt[2] - sigma_std[2]))) * (popt[1] - sigma_std[1])  # ((((((P4 - sdP4) - (P1 - sdP1)) / ((P4 - sdP4) - x[i])))**(1.0 / (P5 - sdP5)) - 1.0)**(1.0 / (P3 - sdP3))) * (P2 - sdP2);
                    xvLower = testXvals[i] - math.sqrt((testXvals[i] - xvsd)**2 + testXdataSTD[i]**2)
                    testXvalsUncertaintyLower.append(xvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    xvsd = (((((popt[3] + sigma_std[3]) - (popt[0] + sigma_std[0])) / ((popt[3] + sigma_std[3]) - testYdataMean[i])) - 1.0)**(1.0 / (popt[2] + sigma_std[2]))) * (popt[1] + sigma_std[1])  # (((((P4 + sdP4) - (P1 + sdP1)) / ((P4 + sdP4) - x[i])) - 1.0)**(1.0 / (P3 + sdP3))) * (P2 + sdP2);
                    # xvsd = ((((((popt[3] + sigma_std[3]) - (popt[0] + sigma_std[0])) / ((popt[3] + sigma_std[3]) - testYdataMean[i])))**(1.0 / (popt[4] + sigma_std[4])) - 1.0)**(1.0 / (popt[2] + sigma_std[2]))) * (popt[1] + sigma_std[1])  # ((((((P4 + sdP4) - (P1 + sdP1)) / ((P4 + sdP4) - x[i])))**(1.0 / (P5 + sdP5)) - 1.0)**(1.0 / (P3 + sdP3))) * (P2 + sdP2);
                    xvUpper = testXvals[i] + math.sqrt((xvsd - testXvals[i])**2 + testXdataSTD[i]**2)
                    testXvalsUncertaintyUpper.append(xvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper

        elif testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and (not(testing_data.__contains__("Ydata")) or len(testing_data["Ydata"]) <= 0):

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = []  # 應變量 y 的擬合值;
            for i in range(len(testing_data["Xdata"])):
                # testYvals = LC4P(testing_data["Xdata"], popt[0], popt[1], popt[2], popt[3])
                # # testYvals = LC5P(testing_data["Xdata"], popt[0], popt[1], popt[2], popt[3], popt[4])
                yv = popt[3] - (popt[3] - popt[0]) / (1.0 + (testing_data["Xdata"][i] / popt[1])**popt[2])  # p4 - (p4 - p1)/(1.0 + (x[i]/p2)**p3);
                # yv = popt[3] - (popt[3] - popt[0]) / ((1.0 + (testing_data["Xdata"][i] / popt[1])**popt[2])**popt[4])  # p4 - (p4 - p1)/(1.0 + (x[i]/p2)**p3)**P5;
                yv = float(yv)
                testYvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit"] = testYvals

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = []  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = []  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if len(weight) == 0:
                # sigma_std = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
                # # 使用 curve_fit() 函數的返回值 pcov 矩陣的對角綫向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 pcov 矩陣的對角綫向量獲得的擬合誤差，得到總的不確定度;
                # # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
                # # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差向量傳遞給 curve_fit() 函數的 sigma 參數，同時將 absolute_sigma=True 設定爲 True 值，表示，傳入的 sigma 參數的標準差是絕對的，而不只是一個相對的比例值;
                # CoefficientSTDlower = popt - sigma_std
                # CoefficientSTDupper = popt + sigma_std

                # 計算應變量 y 的擬合值的誤差上下限;
                testYvalsSTDlower = LC4P(testing_data["Xdata"], CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
                # testYvalsSTDlower = LC5P(Xdata, CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3], CoefficientSTDlower[4])
                # testYvalsUncertaintyLower = []
                for i in range(len(testYvalsSTDlower)):
                    yul = float(testYvalsSTDlower[i])
                    # yul = testYvals[i] - numpy.sqrt(math.pow(testYvals[i] - testYvalsSTDlower[i], 2))
                    # yul = testYvals[i] - numpy.sqrt(math.pow(testYvals[i] - testYvalsSTDlower[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyLower.append(yul)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                testYvalsSTDupper = LC4P(testing_data["Xdata"], CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
                # testYvalsSTDupper = LC5P(Xdata, CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3], CoefficientSTDupper[4])
                # testYvalsUncertaintyUpper = []
                for i in range(len(testYvalsSTDupper)):
                    yuu = float(testYvalsSTDupper[i])
                    # yuu = testYvals[i] + numpy.sqrt(math.pow(testYvalsSTDupper[i] - testYvals[i], 2))
                    # yuu = testYvals[i] + numpy.sqrt(math.pow(testYvalsSTDupper[i] - testYvals[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyUpper.append(yuu)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper
        # else:

    # 判斷是否輸出繪圖;
    fig = None
    if True:
        # https://matplotlib.org/stable/contents.html
        # 使用第三方擴展包「matplotlib」中的「pyplot()」函數繪製散點圖示;
        # matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, clear=False, **kwargs)
        # 參數 figsize=(float,float) 表示繪圖板的長、寬數，預設值為 figsize=[6.4,4.8] 單位為英寸；參數 dpi=float 表示圖形分辨率，預設值為 dpi=100，單位為每平方英尺中的點數；參數 constrained_layout=True 設置子圖區域不要有重叠;
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
        #     label='original values'
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
        # matplotlib_pyplot.xlabel('Dosage')  # 設置顯示橫軸標題為 'Dosage'
        # matplotlib_pyplot.ylabel('relative light unit , RLU')  # 設置顯示縱軸標題為 'relative light unit , RLU'
        # matplotlib_pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
        # matplotlib_pyplot.title('4 parameter logistic model')  # 設置顯示圖標題;
        # matplotlib_pyplot.show()  # 顯示圖片;
        # 繪製散點圖;
        axes_1.scatter(
            Xdata,
            YdataMean,  # Ydata,
            s=15,  # 點大小，取 0 表示不顯示;
            c='blue',  # 點顔色;
            edgecolors='blue',  # 邊顔色;
            linewidths=0.25,  # 邊粗細;
            marker='o',  # 點標志;
            alpha=1,  # 點透明度;
            label='original values'
        )
        # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
        # 繪製平滑折綫圖;
        axes_1.plot(
            Xnew,
            Ynew,
            color='red',
            linewidth=1.0,
            linestyle='-',
            alpha=1,
            label='polyfit values'
        )

        # 描繪擬合曲綫的置信區間;
        if len(weight) == 0:
            axes_1.fill_between(
                Xnew,
                Ynewlower,
                Ynewupper,
                color='grey',  # 'black',
                linestyle=':',
                linewidth=0.5,
                alpha=0.15,
            )

        # 設置坐標軸標題
        axes_1.set_xlabel(
            'Dosage',
            fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
            fontsize='xx-small'
        )
        axes_1.set_ylabel(
            'relative light unit , RLU',
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
            "4-parameter logistic model",
            fontdict={"family": "SimSun", "size": 7},
            fontsize='xx-small'
        )
        # 繪製殘差散點圖;
        # matplotlib_pyplot.figure()
        # plot3 = matplotlib_pyplot.plot(
        #     Xdata,
        #     Residual,
        #     color='blue',
        #     linewidth=1.0,
        #     linestyle=':',
        #     alpha=1,
        #     marker='o',
        #     markersize=5.0,
        #     markerfacecolor='blue',
        #     markeredgewidth=1,
        #     markeredgecolor="blue",
        #     label='polyfit values'
        # )  # 繪製無綫的點圖;
        # matplotlib_pyplot.xlabel('Dosage')  # 設置顯示橫軸標題為 'Dosage'
        # matplotlib_pyplot.ylabel('Residual')  # 設置顯示縱軸標題為 'Residual'
        # # matplotlib_pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
        # matplotlib_pyplot.title('Residual')  # 設置顯示圖標題;
        # matplotlib_pyplot.show()  # 顯示圖片;
        axes_2.plot(
            Xdata,
            Residual,
            color='blue',
            linewidth=1.0,
            linestyle=':',
            alpha=1,
            marker='o',
            markersize=4.0,
            markerfacecolor='blue',
            markeredgewidth=0.25,
            markeredgecolor="blue",
            label='Residual'
        )
        # axes_2.scatter(
        #     Xdata,
        #     Residual,
        #     s=15,  # 點大小，取 0 表示不顯示;
        #     c='blue',  # 點顔色;
        #     edgecolors='blue',  # 邊顔色;
        #     linewidths=1,  # 邊粗細;
        #     marker='o',  # 點標志;
        #     alpha=0.5,  # 點透明度;
        #     label='Residual'
        # )
        # 繪製殘差均值綫;
        axes_2.plot(
            [min(Xdata), max(Xdata)],
            [numpy.mean(Residual), numpy.mean(Residual)],
            color='red',
            linewidth=1.0,
            linestyle='-',
            alpha=1,
            label='Residual mean'
        )
        # 設置坐標軸標題
        axes_2.set_xlabel(
            'Dosage',
            fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
            fontsize='xx-small'
        )
        axes_2.set_ylabel(
            'Residual',
            fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
            fontsize='xx-small'
        )
        # # 確定橫縱坐標範圍;
        # axes_2.set_xlim(
        #     float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
        #     float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
        # )
        # axes_2.set_ylim(
        #     float(numpy.min(Residual)) - float((numpy.max(Residual) - numpy.min(Residual)) * 0.1),
        #     float(numpy.max(Residual)) + float((numpy.max(Residual) - numpy.min(Residual)) * 0.1)
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
        # axes_2.set_yticks(Residual)
        # # axes_2.set_yticklabels(
        # #     [
        # #         str(round(Residual[0], 0)),
        # #         str(round(Residual[1], 0)),
        # #         str(round(Residual[2], 0)),
        # #         str(round(Residual[3], 0)),
        # #         str(round(Residual[4], 0)),
        # #         str(round(Residual[5], 0)),
        # #         str(round(Residual[6], 0)),
        # #         str(round(Residual[7], 0)),
        # #         str(round(Residual[8], 0)),
        # #         str(round(Residual[9], 0)),
        # #         str(round(Residual[10], 0))
        # #     ],
        # #     rotation=0,
        # #     ha='right',
        # #     fontdict={"family": "SimSun", "size": 7},
        # #     fontsize='xx-small'
        # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
        # axes_2.set_yticklabels(
        #     [str(round(Residual[i], 3)) for i in range(len(Residual))],
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
        # axes_2.legend(
        #     loc='lower right',
        #     shadow=False,
        #     frameon=False,
        #     edgecolor='grey',
        #     framealpha=1,
        #     facecolor="none",
        #     prop={"family": "Times New Roman", "size": 7},
        #     fontsize='xx-small'
        # )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
        axes_2.spines['left'].set_linewidth(0.1)
        # axes_2.spines['left'].set_visible(False)  # 去除邊框;
        axes_2.spines['top'].set_visible(False)
        axes_2.spines['right'].set_visible(False)
        # axes_2.spines['bottom'].set_visible(False)
        axes_2.spines['bottom'].set_linewidth(0.1)

        # # fig.savefig('./LC4P-fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()
        # # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./LC4P-fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;

    resultDict = {}
    if len(weight) > 0:
        # resultDict["Coefficient"] = popt
        resultDict["Coefficient"] = []
        for i in range(len(popt)):
            resultDict["Coefficient"].append(float(popt[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Residual"] = Residual
        resultDict["Residual"] = []
        # for i in range(len(Residual)):
        #     trainingResidual_1D = []
        #     for j in range(len(Residual[i])):
        #         trainingResidual_1D.append(float(Residual[i][j]))
        #     resultDict["Residual"].append(trainingResidual_1D)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        for i in range(len(Residual)):
            resultDict["Residual"].append(float(Residual[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit"] = Yvals
        resultDict["Yfit"] = []
        for i in range(len(Yvals)):
            resultDict["Yfit"].append(float(Yvals[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Coefficient-StandardDeviation"] = sigma_std  # 使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差;
        resultDict["Coefficient-StandardDeviation"] = []
        # for i in range(len(sigma_std)):
        #     resultDict["Coefficient-StandardDeviation"].append(float(sigma_std[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Lower"] = CoefficientSTDlower
        # resultDict["Coefficient-StandardDeviation-Lower"] = []
        # for i in range(len(CoefficientSTDlower)):
        #     resultDict["Coefficient-StandardDeviation-Lower"].append(float(CoefficientSTDlower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Upper"] = CoefficientSTDupper
        # resultDict["Coefficient-StandardDeviation-Upper"] = []
        # for i in range(len(CoefficientSTDupper)):
        #     resultDict["Coefficient-StandardDeviation-Upper"].append(float(CoefficientSTDupper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower  # 擬合的應變量 Yvals 誤差下限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Lower"] = []
        # for i in range(len(YvalsUncertaintyLower)):
        #     resultDict["Yfit-Uncertainty-Lower"].append(float(YvalsUncertaintyLower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper  # 擬合的應變量 Yvals 誤差上限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Upper"] = []
        # for i in range(len(YvalsUncertaintyUpper)):
        #     resultDict["Yfit-Uncertainty-Upper"].append(float(YvalsUncertaintyUpper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        resultDict["testData"] = testData  # 傳入測試數據集的計算結果;
        resultDict["fit-image"] = fig  # 擬合曲綫繪圖;
    elif len(weight) == 0:
        # resultDict["Coefficient"] = popt
        resultDict["Coefficient"] = []
        for i in range(len(popt)):
            resultDict["Coefficient"].append(float(popt[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Residual"] = Residual
        resultDict["Residual"] = []
        # for i in range(len(Residual)):
        #     trainingResidual_1D = []
        #     for j in range(len(Residual[i])):
        #         trainingResidual_1D.append(float(Residual[i][j]))
        #     resultDict["Residual"].append(trainingResidual_1D)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        for i in range(len(Residual)):
            resultDict["Residual"].append(float(Residual[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit"] = Yvals
        resultDict["Yfit"] = []
        for i in range(len(Yvals)):
            resultDict["Yfit"].append(float(Yvals[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Coefficient-StandardDeviation"] = sigma_std  # 使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差;
        resultDict["Coefficient-StandardDeviation"] = []
        for i in range(len(sigma_std)):
            resultDict["Coefficient-StandardDeviation"].append(float(sigma_std[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Lower"] = CoefficientSTDlower
        # resultDict["Coefficient-StandardDeviation-Lower"] = []
        # for i in range(len(CoefficientSTDlower)):
        #     resultDict["Coefficient-StandardDeviation-Lower"].append(float(CoefficientSTDlower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Upper"] = CoefficientSTDupper
        # resultDict["Coefficient-StandardDeviation-Upper"] = []
        # for i in range(len(CoefficientSTDupper)):
        #     resultDict["Coefficient-StandardDeviation-Upper"].append(float(CoefficientSTDupper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower  # 擬合的應變量 Yvals 誤差下限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Lower"] = []
        for i in range(len(YvalsUncertaintyLower)):
            resultDict["Yfit-Uncertainty-Lower"].append(float(YvalsUncertaintyLower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper  # 擬合的應變量 Yvals 誤差上限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Upper"] = []
        for i in range(len(YvalsUncertaintyUpper)):
            resultDict["Yfit-Uncertainty-Upper"].append(float(YvalsUncertaintyUpper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        resultDict["testData"] = testData  # 傳入測試數據集的計算結果;
        resultDict["fit-image"] = fig  # 擬合曲綫繪圖;

    return resultDict


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
# #     "Xdata": Xdata[1:len(Xdata)-1:1],  # 數組切片刪除首、尾兩個元素;
# #     "Ydata": Ydata[1:len(Ydata)-1:1]  # 數組切片刪除首、尾兩個元素;
# # }
# testing_data = {
#     # "Xdata": Xdata[1:len(Xdata)-1:1],  # 數組切片刪除首、尾兩個元素;
#     "Ydata": YdataMean[1:len(YdataMean)-1:1]  # 數組切片刪除首、尾兩個元素;
# }

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



# import numpy
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合插值函數;
# from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# https://www.scipy.org/docs.html
# 3 階多項式（Polynomial(Cubic)）曲缐擬合 f(x, P) = P4·x**0 + P3·x**1 + P2·x**2 + P1·x**3 ;
def Polynomial3Fit(training_data, **args):

    # 變量實測值;
    # Xdata = [
    #     float(0),
    #     float(1),
    #     float(2),
    #     float(3),
    #     float(4),
    #     float(5),
    #     float(6),
    #     float(7),
    #     float(8),
    #     float(9),
    #     float(10)
    # ]  # 自變量 x 的實測數據;
    Xdata = numpy.array(training_data["Xdata"])
    # Ydata = [
    #     [float(1000), float(2000), float(3000)],
    #     [float(2000), float(3000), float(4000)],
    #     [float(3000), float(4000), float(5000)],
    #     [float(4000), float(5000), float(6000)],
    #     [float(5000), float(6000), float(7000)],
    #     [float(6000), float(7000), float(8000)],
    #     [float(7000), float(8000), float(9000)],
    #     [float(8000), float(9000), float(10000)],
    #     [float(9000), float(10000), float(11000)],
    #     [float(10000), float(11000), float(12000)],
    #     [float(11000), float(12000), float(13000)]
    # ]  # 應變量 y 的實測數據;
    Ydata = numpy.array(training_data["Ydata"])

    # 計算應變量 y 的實測值 Ydata 的均值;
    YdataMean = []
    for i in range(len(Ydata)):
        # if type(Ydata[i]) is list:
        # if isinstance(Ydata[i], list):
        if type(Ydata[i]) is numpy.ndarray:
            # yMean = float(numpy.mean(Ydata[i]))
            yMean = numpy.mean(Ydata[i])
            YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        else:
            # yMean = float(Ydata[i])
            yMean = Ydata[i]
            YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    # print(YdataMean)

    # 計算應變量 y 的實測值 Ydata 的均值;
    YdataSTD = []
    for i in range(len(Ydata)):
        # if type(Ydata[i]) is list:
        # if isinstance(Ydata[i], list):
        if type(Ydata[i]) is numpy.ndarray:
            if len(Ydata[i]) > 1:
                # ySTD = float(numpy.std(Ydata[i], ddof=1))
                ySTD = numpy.std(Ydata[i], ddof=1)
                YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            elif len(Ydata[i]) == 1:
                # ySTD = float(numpy.std(Ydata[i]))
                ySTD = numpy.std(Ydata[i])
                YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        else:
            ySTD = float(0.0)
            YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    # print(YdataSTD)

    # 配置函數參數默認值;
    # 參數上下限值;
    Plower = [
        -math.inf,
        -math.inf,
        -math.inf,
        -math.inf
    ]  # 參數上限值;
    Pupper = [
        math.inf,
        math.inf,
        math.inf,
        math.inf
    ]  # 參數下限值;

    # 求參數初值;
    Pdata_0_P1 = []
    for i in range(len(YdataMean)):
        if float(Xdata[i]) != float(0.0):
            Pdata_0_P1_I = float(YdataMean[i] / Xdata[i]**3)
        else:
            Pdata_0_P1_I = float(YdataMean[i] - Xdata[i]**3)
        Pdata_0_P1.append(Pdata_0_P1_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    Pdata_0_P1 = float(numpy.mean(Pdata_0_P1))
    # print(Pdata_0_P1)

    Pdata_0_P2 = []
    for i in range(len(YdataMean)):
        if float(Xdata[i]) != float(0.0):
            Pdata_0_P2_I = float(YdataMean[i] / Xdata[i]**2)
        else:
            Pdata_0_P2_I = float(YdataMean[i] - Xdata[i]**2)
        Pdata_0_P2.append(Pdata_0_P2_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    Pdata_0_P2 = float(numpy.mean(Pdata_0_P2))
    # print(Pdata_0_P2)

    Pdata_0_P3 = []
    for i in range(len(YdataMean)):
        if float(Xdata[i]) != float(0.0):
            Pdata_0_P3_I = float(YdataMean[i] / Xdata[i]**1)
        else:
            Pdata_0_P3_I = float(YdataMean[i] - Xdata[i]**1)
        Pdata_0_P3.append(Pdata_0_P3_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    Pdata_0_P3 = float(numpy.mean(Pdata_0_P3))
    # print(Pdata_0_P3)

    Pdata_0_P4 = []
    for i in range(len(YdataMean)):
        if float(Xdata[i]) != float(0.0):
            # 符號 / 表示常規除法，符號 % 表示除法取餘，符號 // 表示除法取整，符號 * 表示乘法，符號 ** 表示冪運算，符號 + 表示加法，符號 - 表示減法;
            Pdata_0_P4_I_1 = float(float(YdataMean[i] % float(Pdata_0_P3 * Xdata[i]**1)) * float(Pdata_0_P3 * Xdata[i]**1))
            Pdata_0_P4_I_2 = float(float(YdataMean[i] % float(Pdata_0_P2 * Xdata[i]**2)) * float(Pdata_0_P2 * Xdata[i]**2))
            Pdata_0_P4_I_3 = float(float(YdataMean[i] % float(Pdata_0_P1 * Xdata[i]**3)) * float(Pdata_0_P1 * Xdata[i]**3))
            Pdata_0_P4_I = float(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3)
        else:
            Pdata_0_P4_I = float(YdataMean[i] - Xdata[i])
        Pdata_0_P4.append(Pdata_0_P4_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    Pdata_0_P4 = float(numpy.mean(Pdata_0_P4))
    # print(Pdata_0_P4)

    # 參數初始值數組;
    # Pdata_0 = [
    #     float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])),
    #     float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])),
    #     float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])),
    #     float(numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])) * Xdata[i]**1)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])) * Xdata[i]**1)) for i in range(len(YdataMean))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])) * Xdata[i]**2)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])) * Xdata[i]**2)) for i in range(len(YdataMean))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])) * Xdata[i]**3)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])) * Xdata[i]**3)) for i in range(len(YdataMean))]))
    # ]
    Pdata_0 = [
        Pdata_0_P1,
        Pdata_0_P2,
        Pdata_0_P3,
        Pdata_0_P4
    ]

    # # 變量實測值擬合權重;
    weight = []
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

    testing_data = {}

    # 讀取傳入函數的可變參數值;
    for key, value in args.items():
        if key == "Pdata_0":
            Pdata_0 = value
        if key == "weight":
            weight = value
        if key == "Plower":
            Plower = value
        if key == "Pupper":
            Pupper = value
        if key == "testing_data":
            testing_data = value
        else:
            testing_data = training_data

    # 自定義的 3 階多項式（Polynomial - Cubic - model）方程模型：f(x, P) = P4·x**0 + P3·x**1 + P2·x**2 + P1·x**3 ;
    # f_fit_model = lambda x, P1, P2, P3, P4: ((P4*(x**0)) + (P3*(x**1)) + (P2*(x**2)) + (P1*(x**3)))  # 參數 lambda 表示定義一個匿名函數，參數 arguments 表示傳入的自變量參數，冒號（:）之後的表達式表示函數返回值;
    def f_fit_model(x, P1, P2, P3, P4):
        # 應變量 y（Dependent Variable）;
        # 自變量 x（Independent Variable）;
        # 參數 P1 為自變量 x（Independent Variable）的 3 次項系數;
        # 參數 P2 為自變量 x（Independent Variable）的 2 次項系數;
        # 參數 P3 為自變量 x（Independent Variable）的 1 次項系數;
        # 參數 P4 為常數項（自變量 x（Independent Variable）的 0 次項）系數;
        y = (P4*(x**0)) + (P3*(x**1)) + (P2*(x**2)) + (P1*(x**3))
        return y

    # 使用第三方擴展包「scipy」中「optimize」模組的「curve_fit()」函數，使用非綫性最小二乘法擬合曲綫方程;
    # scipy.optimize.curve_fit(f, xdata, ydata, p0=None, sigma=None, absolute_sigma=False, check_finite=True, bounds=(-inf,inf), method=None, jac=None, **kwargs)
    # 參數 f 表示模型函數 f(x, ...) ，注意，必須將自變量作爲第一個參數，將待估參數作爲單獨的其餘參數;
    # 參數 xdata 表示實測值自變量數據;
    # 參數 ydata 表示實測值應變量數據;
    # 參數 p0 表i是待估參數的初值，預設初始值為 1 ;
    # 參數 sigma 表示 Ydata 的不確定度;
    # 參數 bounds 表示待估參數的上下限，輸入值為元組類型，元組裏的上下限元素必須是一個數組，數組長度等於待估參數的數目，可以使用帶有適當符號的 numpy.inf 值，來禁用部分參數的邊界，預設為無界限;
    # 參數 method 表示用於優化的方法，可取 'lm', 'trf', 'dogbox' 三個值之一，預設值為 'lm' ;
    # 加權最小二乘法擬合;
    if len(weight) > 0:
        popt, pcov, infodict, errmsg, ier = scipy_optimize_curve_fit(
            f_fit_model,
            Xdata,
            YdataMean,  # Ydata,
            p0=Pdata_0,
            sigma=[1/we for we in weight if we > 0],  # 權重值的倒數列表;
            absolute_sigma=True,  # 表示參數 sigma 傳入的標準差是絕對的，而不只是一個相對的比例值;
            check_finite=True,
            bounds=(Plower, Pupper),
            method='lm',
            full_output=True
        )
    elif len(weight) == 0:
        popt, pcov, infodict, errmsg, ier = scipy_optimize_curve_fit(
            f_fit_model,
            Xdata,
            YdataMean,  # Ydata,
            p0=Pdata_0,
            # sigma=[1/we for we in weight if we > 0],  # 權重值的倒數列表;
            # absolute_sigma=True,  # 表示參數 sigma 傳入的標準差是絕對的，而不只是一個相對的比例值;
            check_finite=True,
            bounds=(Plower, Pupper),
            method='lm',
            full_output=True
        )
    # print("P1 = ", popt[0])
    # print("P2 = ", popt[1])
    # print("P3 = ", popt[2])
    # print("P4 = ", popt[3])

    # 計算應變量 y 的擬合值;
    # Yvals = []
    # for i in range(len(Xdata)):
    #     Yvals_I = f_fit_model(Xdata[i], popt[0], popt[1], popt[2], popt[3])
    #     Yvals.append(float(Yvals_I))  # 使用 list.append() 函數在列表末尾追加推入新元素;
    Yvals = f_fit_model(Xdata, popt[0], popt[1], popt[2], popt[3])
    # Yvals_NDArray = f_fit_model(Xdata, popt[0], popt[1], popt[2], popt[3])
    # for i in range(len(Yvals_NDArray)):
    #     Yvals.append(float(Yvals_NDArray[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;

    # 計算擬合殘差值;
    Residual = YdataMean - Yvals  # Ydata;
    # Residual = []
    # for i in range(len(Yvals)):
    #     trainingResidual_1D = []
    #     for j in range(len(Ydata[i])):
    #         tres = Ydata[i][j] - Yvals[i]
    #         tres = float(tres)
    #         trainingResidual_1D.append(tres)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    #     Residual.append(trainingResidual_1D)

    # 計算擬合參數的誤差上下限;
    if len(weight) == 0:

        sigma_std = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
        # sigma_std = math.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
        # sigma_std_NDArray = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
        # sigma_std = []
        # for i in range(len(sigma_std_NDArray)):
        #     sigma_std.append(float(sigma_std_NDArray[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;

        # 使用 curve_fit() 函數的返回值 pcov 矩陣的對角綫向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 pcov 矩陣的對角綫向量獲得的擬合誤差，得到總的不確定度;
        # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
        # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差向量傳遞給 curve_fit() 函數的 sigma 參數，同時將 absolute_sigma=True 設定爲 True 值，表示，傳入的 sigma 參數的標準差是絕對的，而不只是一個相對的比例值;
        CoefficientSTDlower = popt - sigma_std
        CoefficientSTDupper = popt + sigma_std

        # 計算應變量 y 的擬合值的誤差上下限;
        YvalsSTDlower = f_fit_model(Xdata, CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
        YvalsUncertaintyLower = []
        for i in range(len(YvalsSTDlower)):
            yul = Yvals[i] - numpy.sqrt(math.pow(YvalsSTDlower[i] - Yvals[i], 2) + math.pow(YdataSTD[i], 2))
            yul = float(yul)
            YvalsUncertaintyLower.append(yul)  # 使用 list.append() 函數在列表末尾追加推入新元素;

        YvalsSTDupper = f_fit_model(Xdata, CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
        YvalsUncertaintyUpper = []
        for i in range(len(YvalsSTDupper)):
            yuu = Yvals[i] + numpy.sqrt(math.pow(YvalsSTDupper[i] - Yvals[i], 2) + math.pow(YdataSTD[i], 2))
            yuu = float(yuu)
            YvalsUncertaintyUpper.append(yuu)  # 使用 list.append() 函數在列表末尾追加推入新元素;

    # 生成插值數據，使繪製的擬合折綫圖平滑;
    # idx = range(len(Xdata))  # 記錄橫軸刻度標簽數;
    # Xnew = numpy.linspace(min(idx), max(idx), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
    # spl = scipy_interpolate_make_interp_spline(idx, Yvals, k=3)  # 使用第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，擬合三次多項式插值函數;
    Xnew = numpy.linspace(min(Xdata), max(Xdata), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
    spl = scipy_interpolate_make_interp_spline(Xdata, Yvals, k=3)  # 使用第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，擬合三次多項式插值函數;
    Ynew = spl(Xnew)  # 生成插值縱坐標值;

    # 生成置信區間上下限插值縱坐標值;
    if len(weight) == 0:
        # splLower = scipy_interpolate_make_interp_spline(idx, YvalsUncertaintyLower, k=3)
        splLower = scipy_interpolate_make_interp_spline(Xdata, YvalsUncertaintyLower, k=3)
        Ynewlower = splLower(Xnew)  # 生成置信區間下限插值縱坐標值;
        # splUpper = scipy_interpolate_make_interp_spline(idx, YvalsUncertaintyUpper, k=3)
        splUpper = scipy_interpolate_make_interp_spline(Xdata, YvalsUncertaintyUpper, k=3)
        Ynewupper = splUpper(Xnew)  # 生成置信區間上限插值縱坐標值;

    # 計算測試集數據的擬合值;
    testData = {}
    if isinstance(testing_data, dict) and len(testing_data) > 0:

        testData = testing_data

        if testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    yMean = float(numpy.mean(testing_data["Ydata"][i]))
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    yMean = float(testing_data["Ydata"][i])
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-Mean"] = testYdataMean
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    if len(testing_data["Ydata"][i]) > 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i], ddof=1))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    elif len(testing_data["Ydata"][i]) == 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i]))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:
                else:
                    ySTD = float(0.0)
                    testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-StandardDeviation"] = testYdataSTD

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = []  # 應變量 y 的擬合值;
            for i in range(len(testing_data["Xdata"])):
                # yv = f_fit_model(testing_data["Xdata"][i], popt[0], popt[1], popt[2], popt[3])  # y = P4*x[i]**0 + P3*x[i]**1 + P2*x[i]**2 + P1*x[i]**3;
                yv = (popt[3]*((testing_data["Xdata"][i])**0)) + (popt[2]*((testing_data["Xdata"][i])**1)) + (popt[1]*((testing_data["Xdata"][i])**2)) + (popt[0]*((testing_data["Xdata"][i])**3))  # y = P4*x[i]**0 + P3*x[i]**1 + P2*x[i]**2 + P1*x[i]**3;
                yv = float(yv)
                testYvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            # testYvals = f_fit_model(testing_data["Xdata"], popt[0], popt[1], popt[2], popt[3])  # y = P4*x[i]**0 + P3*x[i]**1 + P2*x[i]**2 + P1*x[i]**3;
            testData["test-Yfit"] = testYvals

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = []  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = []  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if len(weight) == 0:
                # sigma_std = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
                # # 使用 curve_fit() 函數的返回值 pcov 矩陣的對角綫向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 pcov 矩陣的對角綫向量獲得的擬合誤差，得到總的不確定度;
                # # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
                # # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差向量傳遞給 curve_fit() 函數的 sigma 參數，同時將 absolute_sigma=True 設定爲 True 值，表示，傳入的 sigma 參數的標準差是絕對的，而不只是一個相對的比例值;
                # CoefficientSTDlower = popt - sigma_std
                # CoefficientSTDupper = popt + sigma_std

                # 計算應變量 y 的擬合值的誤差上下限;
                # testYvalsSTDlower = f_fit_model(testing_data["Xdata"], CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
                testYvalsSTDlower = []
                for j in range(len(testing_data["Xdata"])):
                    yv = f_fit_model(testing_data["Xdata"][j], CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
                    yv = float(yv)
                    testYvalsSTDlower.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # testYvalsUncertaintyLower = []
                for i in range(len(testYvalsSTDlower)):
                    yul = testYvals[i] - numpy.sqrt(math.pow(testYvalsSTDlower[i] - testYvals[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyLower.append(yul)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # testYvalsSTDupper = f_fit_model(testing_data["Xdata"], CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
                testYvalsSTDupper = []
                for j in range(len(testing_data["Xdata"])):
                    yv = f_fit_model(testing_data["Xdata"][j], CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
                    yv = float(yv)
                    testYvalsSTDupper.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # testYvalsUncertaintyUpper = []
                for i in range(len(testYvalsSTDupper)):
                    yuu = testYvals[i] + numpy.sqrt(math.pow(testYvalsSTDupper[i] - testYvals[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyUpper.append(yuu)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper

            # 計算測試集數據的擬合殘差;
            testResidual = []  # 擬合殘差向量;
            for i in range(len(testing_data["Ydata"])):
                # resi = float(testYdataMean[i] - testYvals[i])
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    testResidual_1D = []
                    for j in range(len(testing_data["Ydata"][i])):
                        resi = float(testing_data["Ydata"][i][j] - testYvals[i])
                        testResidual_1D.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    testResidual.append(testResidual_1D)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    resi = float(testing_data["Ydata"][i] - testYvals[i])
                    testResidual.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Residual"] = testResidual

        elif (not(testing_data.__contains__("Xdata")) or len(testing_data["Xdata"]) <= 0) and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    yMean = float(numpy.mean(testing_data["Ydata"][i]))
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    yMean = float(testing_data["Ydata"][i])
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-Mean"] = testYdataMean
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    if len(testing_data["Ydata"][i]) > 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i], ddof=1))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    elif len(testing_data["Ydata"][i]) == 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i]))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:
                else:
                    ySTD = float(0.0)
                    testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-StandardDeviation"] = testYdataSTD

            # 定義待求根的一元方程模型;
            # rf(x) = lambda x: (P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3));  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
            # 參數 P1 為自變量 3 次項系數（x^3）;
            # 參數 P2 為自變量 2 次項系數（x^2）;
            # 參數 P3 為自變量 1 次項系數（x^1）;
            # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

            # X_Root = scipy_optimize_root(rf1, X_0, args=(), method=None, jac=None);
            # print("X ≈ ", X_Root.x)  # 輸出根的值;
            # print(X_Root.fun)  # 輸出根的函數值;

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = []  # 應變量 X 的擬合值;
            # 求解 y 的 1·SD 值的根;
            testXdataSTD = []
            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = []  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = []  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            for i in range(len(testYdataMean)):

                # 求解 y 值的根;
                # 定義待求根的一元方程模型;
                # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
                # f = lambda arguments: arguments  # 參數 lambda 表示定義一個匿名函數，參數 arguments 表示傳入的自變量參數，冒號（:）之後的表達式表示函數返回值;
                f1_f_fit_model = lambda x: (f_fit_model(x, popt[0], popt[1], popt[2], popt[3]) - testYdataMean[i])
                # f1_f_fit_model = lambda x: (((popt[3]*(x**0)) + (popt[2]*(x**1)) + (popt[1]*(x**2)) + (popt[0]*(x**3))) - testYdataMean[i])
                # def f1_f_fit_model(x):
                #     # 應變量 y（Dependent Variable）;
                #     # 自變量 x（Independent Variable）;
                #     # 參數 P1 為自變量 x（Independent Variable）的 3 次項系數;
                #     # 參數 P2 為自變量 x（Independent Variable）的 2 次項系數;
                #     # 參數 P3 為自變量 x（Independent Variable）的 1 次項系數;
                #     # 參數 P4 為常數項（自變量 x（Independent Variable）的 0 次項）系數;
                #     # y = (popt[3]*(x**0)) + (popt[2]*(x**1)) + (popt[1]*(x**2)) + (popt[0]*(x**3)) - testYdataMean[i]
                #     y = f_fit_model(x, popt[0], popt[1], popt[2], popt[3]) - testYdataMean[i]
                #     return y

                # 計算二分法求根的含根區間（迭代初值）;
                X_lower = -math.inf
                X_upper = +math.inf
                if len(weight) == 0:
                    if float(testYdataMean[i]) < float(min(YdataMean)):
                    # if float(testYdataMean[i]) < float(YdataMean[1]):
                        # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = float(min(Xdata))
                        # X_upper = float(Xdata[1])
                    if float(testYdataMean[i]) > float(max(YdataMean)):
                    # if float(testYdataMean[i]) > float(YdataMean[len(YdataMean)-1]):
                        # X_lower = float(Xdata[len(Xdata)-1])
                        X_lower = float(max(Xdata))
                        # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                    # if float(testYdataMean[i]) >= float(YdataMean[1]) and float(testYdataMean[i]) <= float(YdataMean[len(YdataMean)-1]):
                        for j in range(len(YdataMean)):
                            # if j == 0:
                            # if j == int(len(YdataMean)-1):
                            if float(testYdataMean[i]) == float(YdataMean[j]):
                                X_lower = float(Xdata[j] * float(0.99))
                                X_upper = float(Xdata[j] * float(1.01))
                                break
                            if float(testYdataMean[i]) > float(YdataMean[j]):
                                X_lower = float(Xdata[j])
                            if float(testYdataMean[i]) < float(YdataMean[j]):
                                X_upper = float(Xdata[j])
                                break
                else:
                    if float(testYdataMean[i]) < float(min(YdataMean)):
                    # if float(testYdataMean[i]) < float(YdataMean[1]):
                        # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = float(min(Xdata) * max(weight))
                        # X_upper = float(Xdata[1] * weight[1])
                    if float(testYdataMean[i]) > float(max(YdataMean)):
                    # if float(testYdataMean[i]) > float(YdataMean[len(YdataMean)-1]):
                        # X_lower = float(Xdata[len(Xdata)-1] * weight[len(weight)-1])
                        X_lower = float(max(Xdata) * min(weight))
                        # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                    # if float(testYdataMean[i]) >= float(YdataMean[1]) and float(testYdataMean[i]) <= float(YdataMean[len(YdataMean)-1]):
                        for j in range(len(YdataMean)):
                            # if j == 0:
                            # if j == int(len(YdataMean)-1):
                            if float(testYdataMean[i]) == float(YdataMean[j]):
                                X_lower = float(float(Xdata[j] * weight[j]) * float(0.99))
                                X_upper = float(float(Xdata[j] * weight[j]) * float(1.01))
                                break
                            if float(testYdataMean[i]) > float(YdataMean[j]):
                                X_lower = float(Xdata[j] * weight[j])
                            if float(testYdataMean[i]) < float(YdataMean[j]):
                                X_upper = float(Xdata[j] * weight[j])
                                break
                # print(X_lower)
                # print(X_upper)

                # 參數 method='bisect' 表示二分法（Bisection），需要傳入含根區間，參數 method='hybr' 表示牛頓法（Newton），需要傳入迭代起始值，參數 method='lm' 表示最小二乘法，需要傳入迭代起始值，'broyden1', 'broyden2', 'anderson', 'linearmixing', 'diagbroyden', 'excitingmixing', 'krylov', 'df-sane’;
                # X_Root = scipy.optimize.root(rf1, X_0, args=(), method='hybr', jac=None, tol=None, callback=None, options={'full_output': 0, 'col_deriv': 0, 'diag': None, 'factor': 100, 'eps': None, 'band': None, 'func': None, 'maxfev': 0, 'xtol': 1.49012e-08});
                # print("X ≈ ", X_Root.x)  # 輸出根的值;
                # print(X_Root.fun)  # 輸出根的函數值;
                #  print(X_Root.converged)  # 算法收斂標準;
                #  print(X_Root.iterations)  # 迭代次數;
                # xv = scipy_optimize_root(f1_f_fit_model, (X_lower, X_upper), method='bisect', options={"maxfev": 10000})
                xv = scipy_optimize_root(f1_f_fit_model, (X_upper), method='hybr', options={"maxfev": 10000})
                xv = float((xv.x)[0])
                testXvals.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲方程擬合（Curve Fitting）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
                # 求解 y 的 1·SD 值的根;
                # 定義待求根的一元方程模型;
                f2_f_fit_model = lambda x: (f_fit_model(x, popt[0], popt[1], popt[2], popt[3]) - (testYdataMean[i] + testYdataSTD[i]))
                # f2_f_fit_model = lambda x: (((popt[3]*(x**0)) + (popt[2]*(x**1)) + (popt[1]*(x**2)) + (popt[0]*(x**3))) - (testYdataMean[i] + testYdataSTD[i]))
                # 參數 P1 為自變量 3 次項系數（x^3）;
                # 參數 P2 為自變量 2 次項系數（x^2）;
                # 參數 P3 為自變量 1 次項系數（x^1）;
                # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

                # 計算二分法求根的含根區間（迭代初值）;
                X_lower = -math.inf
                X_upper = +math.inf
                if len(weight) == 0:
                    if float(testYdataMean[i] + testYdataSTD[i]) < float(min(YdataMean)):
                    # if float(testYdataMean[i] + testYdataSTD[i]) < float(YdataMean[1]):
                        # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = float(min(Xdata))
                        # X_upper = float(Xdata[1])
                    if float(testYdataMean[i] + testYdataSTD[i]) > float(max(YdataMean)):
                    # if float(testYdataMean[i] + testYdataSTD[i]) > float(YdataMean[len(YdataMean)-1]):
                        # X_lower = float(Xdata[len(Xdata)-1])
                        X_lower = float(max(Xdata))
                        # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    if float(testYdataMean[i] + testYdataSTD[i]) >= float(min(YdataMean)) and float(testYdataMean[i] + testYdataSTD[i]) <= float(max(YdataMean)):
                    # if float(testYdataMean[i] + testYdataSTD[i]) >= float(YdataMean[1]) and float(testYdataMean[i] + testYdataSTD[i]) <= float(YdataMean[len(YdataMean)-1]):
                        for j in range(len(YdataMean)):
                            # if j == 0:
                            # if j == int(len(YdataMean)-1):
                            if float(testYdataMean[i] + testYdataSTD[i]) == float(YdataMean[j]):
                                X_lower = float(Xdata[j] * float(0.99))
                                X_upper = float(Xdata[j] * float(1.01))
                                break
                            if float(testYdataMean[i] + testYdataSTD[i]) > float(YdataMean[j]):
                                X_lower = float(Xdata[j])
                            if float(testYdataMean[i] + testYdataSTD[i]) < float(YdataMean[j]):
                                X_upper = float(Xdata[j])
                                break
                else:
                    if float(testYdataMean[i] + testYdataSTD[i]) < float(min(YdataMean)):
                    # if float(testYdataMean[i] + testYdataSTD[i]) < float(YdataMean[1]):
                        # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = float(min(Xdata) * max(weight))
                        # X_upper = float(Xdata[1] * weight[1])
                    if float(testYdataMean[i] + testYdataSTD[i]) > float(max(YdataMean)):
                    # if float(testYdataMean[i] + testYdataSTD[i]) > float(YdataMean[len(YdataMean)-1]):
                        # X_lower = float(Xdata[len(Xdata)-1] * weight[len(weight)-1])
                        X_lower = float(max(Xdata) * min(weight))
                        # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    if float(testYdataMean[i] + testYdataSTD[i]) >= float(min(YdataMean)) and float(testYdataMean[i] + testYdataSTD[i]) <= float(max(YdataMean)):
                    # if float(testYdataMean[i] + testYdataSTD[i]) >= float(YdataMean[1]) and float(testYdataMean[i] + testYdataSTD[i]) <= float(YdataMean[len(YdataMean)-1]):
                        for j in range(len(YdataMean)):
                            # if j == 0:
                            # if j == int(len(YdataMean)-1):
                            if float(testYdataMean[i] + testYdataSTD[i]) == float(YdataMean[j]):
                                X_lower = float(float(Xdata[j] * weight[j]) * float(0.99))
                                X_upper = float(float(Xdata[j] * weight[j]) * float(1.01))
                                break
                            if float(testYdataMean[i] + testYdataSTD[i]) > float(YdataMean[j]):
                                X_lower = float(Xdata[j] * weight[j])
                            if float(testYdataMean[i] + testYdataSTD[i]) < float(YdataMean[j]):
                                X_upper = float(Xdata[j] * weight[j])
                                break
                # print(X_lower)
                # print(X_upper)

                # xv_add_1_SD = scipy_optimize_root(f2_f_fit_model, (X_lower, X_upper), method='bisect', options={"maxfev": 10000})
                xv_add_1_SD = scipy_optimize_root(f2_f_fit_model, (X_upper), method='hybr', options={"maxfev": 10000})
                xv_add_1_SD = float((xv_add_1_SD.x)[0])

                xv_1_SD = float(abs(float(xv) - float(xv_add_1_SD)))  # 函數 abs() 表示取絕對值;

                testXdataSTD.append(xv_1_SD)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # 通過方程擬合算法（Curve Fitting Algorithm）的標準差（Standard Deviation）（擬合獲得方程參數的標準差），轉換爲擬合（Curve Fitting）之後的 X 值的擬合算法（Curve Fitting Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲擬合（Curve Fitting）之後的 X 值的總標準差（Standard Deviation）;
                # 計算 x 擬合值（Xfit）的置信限（Uncertainty）;
                if len(weight) == 0:

                    # 求解 Yfit - 1·SD 值的根;
                    # 定義待求根的一元方程模型;
                    # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
                    # f = lambda arguments: arguments  # 參數 lambda 表示定義一個匿名函數，參數 arguments 表示傳入的自變量參數，冒號（:）之後的表達式表示函數返回值;
                    f3_f_fit_model = lambda x: (f_fit_model(x, float(popt[0] - sigma_std[0]), float(popt[1] - sigma_std[1]), float(popt[2] - sigma_std[2]), float(popt[3] - sigma_std[3])) - testYdataMean[i])
                    # f3_f_fit_model = lambda x: (((popt[3] - sigma_std[3])*(x**0) + (popt[2] - sigma_std[2])*(x**1) + (popt[1] - sigma_std[1])*(x**2) + (popt[0] - sigma_std[0])*(x**3)) - testYdataMean[i])
                    # def f3_f_fit_model(x):
                    #     # 應變量 y（Dependent Variable）;
                    #     # 自變量 x（Independent Variable）;
                    #     # 參數 P1 為自變量 x（Independent Variable）的 3 次項系數;
                    #     # 參數 P2 為自變量 x（Independent Variable）的 2 次項系數;
                    #     # 參數 P3 為自變量 x（Independent Variable）的 1 次項系數;
                    #     # 參數 P4 為常數項（自變量 x（Independent Variable）的 0 次項）系數;
                    #     # y = (popt[3] - sigma_std[3])*(x**0) + (popt[2] - sigma_std[2])*(x**1) + (popt[1] - sigma_std[1])*(x**2) + (popt[0] - sigma_std[0])*(x**3) - testYdataMean[i]
                    #     y = f_fit_model(x, float(popt[0] - sigma_std[0]), float(popt[1] - sigma_std[1]), float(popt[2] - sigma_std[2]), float(popt[3] - sigma_std[3])) - testYdataMean[i]
                    #     return y

                    # 計算二分法求根的含根區間（迭代初值）;
                    X_lower = -math.inf
                    X_upper = +math.inf
                    if len(weight) == 0:
                        if float(testYdataMean[i]) < float(min(YdataMean)):
                        # if float(testYdataMean[i]) < float(YdataMean[1]):
                            # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = float(min(Xdata))
                            # X_upper = float(Xdata[1])
                        if float(testYdataMean[i]) > float(max(YdataMean)):
                        # if float(testYdataMean[i]) > float(YdataMean[len(YdataMean)-1]):
                            # X_lower = float(Xdata[len(Xdata)-1])
                            X_lower = float(max(Xdata))
                            # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                        # if float(testYdataMean[i]) >= float(YdataMean[1]) and float(testYdataMean[i]) <= float(YdataMean[len(YdataMean)-1]):
                            for j in range(len(YdataMean)):
                                # if j == 0:
                                # if j == int(len(YdataMean)-1):
                                if float(testYdataMean[i]) == float(YdataMean[j]):
                                    X_lower = float(Xdata[j] * float(0.99))
                                    X_upper = float(Xdata[j] * float(1.01))
                                    break
                                if float(testYdataMean[i]) > float(YdataMean[j]):
                                    X_lower = float(Xdata[j])
                                if float(testYdataMean[i]) < float(YdataMean[j]):
                                    X_upper = float(Xdata[j])
                                    break
                    else:
                        if float(testYdataMean[i]) < float(min(YdataMean)):
                        # if float(testYdataMean[i]) < float(YdataMean[1]):
                            # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = float(min(Xdata) * max(weight))
                            # X_upper = float(Xdata[1] * weight[1])
                        if float(testYdataMean[i]) > float(max(YdataMean)):
                        # if float(testYdataMean[i]) > float(YdataMean[len(YdataMean)-1]):
                            # X_lower = float(Xdata[len(Xdata)-1] * weight[len(weight)-1])
                            X_lower = float(max(Xdata) * min(weight))
                            # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                        # if float(testYdataMean[i]) >= float(YdataMean[1]) and float(testYdataMean[i]) <= float(YdataMean[len(YdataMean)-1]):
                            for j in range(len(YdataMean)):
                                # if j == 0:
                                # if j == int(len(YdataMean)-1):
                                if float(testYdataMean[i]) == float(YdataMean[j]):
                                    X_lower = float(float(Xdata[j] * weight[j]) * float(0.99))
                                    X_upper = float(float(Xdata[j] * weight[j]) * float(1.01))
                                    break
                                if float(testYdataMean[i]) > float(YdataMean[j]):
                                    X_lower = float(Xdata[j] * weight[j])
                                if float(testYdataMean[i]) < float(YdataMean[j]):
                                    X_upper = float(Xdata[j] * weight[j])
                                    break
                    # print(X_lower)
                    # print(X_upper)

                    # 參數 method='bisect' 表示二分法（Bisection），需要傳入含根區間，參數 method='hybr' 表示牛頓法（Newton），需要傳入迭代起始值，參數 method='lm' 表示最小二乘法，需要傳入迭代起始值，'broyden1', 'broyden2', 'anderson', 'linearmixing', 'diagbroyden', 'excitingmixing', 'krylov', 'df-sane’;
                    # X_Root = scipy.optimize.root(rf1, X_0, args=(), method='hybr', jac=None, tol=None, callback=None, options={'full_output': 0, 'col_deriv': 0, 'diag': None, 'factor': 100, 'eps': None, 'band': None, 'func': None, 'maxfev': 0, 'xtol': 1.49012e-08});
                    # print("X ≈ ", X_Root.x)  # 輸出根的值;
                    # print(X_Root.fun)  # 輸出根的函數值;
                    #  print(X_Root.converged)  # 算法收斂標準;
                    #  print(X_Root.iterations)  # 迭代次數;
                    # xvsd = scipy_optimize_root(f3_f_fit_model, (X_lower, X_upper), method='bisect', options={"maxfev": 10000})
                    xvsd = scipy_optimize_root(f3_f_fit_model, (X_upper), method='hybr', options={"maxfev": 10000})
                    xvsd = float((xvsd.x)[0])

                    # 求解 Xfit-Uncertainty-Lower 的值;
                    xvLower = float(float(xv) - math.sqrt((float(xv) - float(xvsd))**2 + float(xv_1_SD)**2))
                    testXvalsUncertaintyLower.append(xvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    # 求解 Yfit + 1·SD 值的根;
                    # 定義待求根的一元方程模型;
                    f4_f_fit_model = lambda x: (f_fit_model(x, float(popt[0] + sigma_std[0]), float(popt[1] + sigma_std[1]), float(popt[2] + sigma_std[2]), float(popt[3] + sigma_std[3])) - testYdataMean[i])
                    # f4_f_fit_model = lambda x: (((popt[3] + sigma_std[3])*(x**0) + (popt[2] + sigma_std[2])*(x**1) + (popt[1] + sigma_std[1])*(x**2) + (popt[0] + sigma_std[0])*(x**3)) - testYdataMean[i])
                    # 參數 P1 為自變量 3 次項系數（x^3）;
                    # 參數 P2 為自變量 2 次項系數（x^2）;
                    # 參數 P3 為自變量 1 次項系數（x^1）;
                    # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

                    # 計算二分法求根的含根區間（迭代初值）;
                    X_lower = -math.inf
                    X_upper = +math.inf
                    if len(weight) == 0:
                        if float(testYdataMean[i]) < float(min(YdataMean)):
                        # if float(testYdataMean[i]) < float(YdataMean[1]):
                            # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = float(min(Xdata))
                            # X_upper = float(Xdata[1])
                        if float(testYdataMean[i]) > float(max(YdataMean)):
                        # if float(testYdataMean[i]) > float(YdataMean[len(YdataMean)-1]):
                            # X_lower = float(Xdata[len(Xdata)-1])
                            X_lower = float(max(Xdata))
                            # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                        # if float(testYdataMean[i]) >= float(YdataMean[1]) and float(testYdataMean[i]) <= float(YdataMean[len(YdataMean)-1]):
                            for j in range(len(YdataMean)):
                                # if j == 0:
                                # if j == int(len(YdataMean)-1):
                                if float(testYdataMean[i]) == float(YdataMean[j]):
                                    X_lower = float(Xdata[j] * float(0.99))
                                    X_upper = float(Xdata[j] * float(1.01))
                                    break
                                if float(testYdataMean[i]) > float(YdataMean[j]):
                                    X_lower = float(Xdata[j])
                                if float(testYdataMean[i]) < float(YdataMean[j]):
                                    X_upper = float(Xdata[j])
                                    break
                    else:
                        if float(testYdataMean[i]) < float(min(YdataMean)):
                        # if float(testYdataMean[i]) < float(YdataMean[1]):
                            # X_lower = float("2.2250738585072e-308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = float(min(Xdata) * max(weight))
                            # X_upper = float(Xdata[1] * weight[1])
                        if float(testYdataMean[i]) > float(max(YdataMean)):
                        # if float(testYdataMean[i]) > float(YdataMean[len(YdataMean)-1]):
                            # X_lower = float(Xdata[len(Xdata)-1] * weight[len(weight)-1])
                            X_lower = float(max(Xdata) * min(weight))
                            # X_upper = float("1.79769313486232e+308")  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                        # if float(testYdataMean[i]) >= float(YdataMean[1]) and float(testYdataMean[i]) <= float(YdataMean[len(YdataMean)-1]):
                            for j in range(len(YdataMean)):
                                # if j == 0:
                                # if j == int(len(YdataMean)-1):
                                if float(testYdataMean[i]) == float(YdataMean[j]):
                                    X_lower = float(float(Xdata[j] * weight[j]) * float(0.99))
                                    X_upper = float(float(Xdata[j] * weight[j]) * float(1.01))
                                    break
                                if float(testYdataMean[i]) > float(YdataMean[j]):
                                    X_lower = float(Xdata[j] * weight[j])
                                if float(testYdataMean[i]) < float(YdataMean[j]):
                                    X_upper = float(Xdata[j] * weight[j])
                                    break
                    # print(X_lower)
                    # print(X_upper)

                    # xvsd = scipy_optimize_root(f4_f_fit_model, (X_lower, X_upper), method='bisect', options={"maxfev": 10000})
                    xvsd = scipy_optimize_root(f4_f_fit_model, (X_upper), method='hybr', options={"maxfev": 10000})
                    xvsd = float((xvsd.x)[0])

                    # 求解 Xfit-Uncertainty-Upper 的值;
                    xvUpper = float(float(xv) + math.sqrt((float(xv) - float(xvsd))**2 + float(xv_1_SD)**2))
                    testXvalsUncertaintyUpper.append(xvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;

            testData["test-Xvals"] = testXvals
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper

        elif testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and (not(testing_data.__contains__("Ydata")) or len(testing_data["Ydata"]) <= 0):

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = []  # 應變量 y 的擬合值;
            for i in range(len(testing_data["Xdata"])):
                # yv = f_fit_model(testing_data["Xdata"][i], popt[0], popt[1], popt[2], popt[3])  # y = P4*x[i]**0 + P3*x[i]**1 + P2*x[i]**2 + P1*x[i]**3;
                yv = (popt[3]*((testing_data["Xdata"][i])**0)) + (popt[2]*((testing_data["Xdata"][i])**1)) + (popt[1]*((testing_data["Xdata"][i])**2)) + (popt[0]*((testing_data["Xdata"][i])**3))  # y = P4*x[i]**0 + P3*x[i]**1 + P2*x[i]**2 + P1*x[i]**3;
                yv = float(yv)
                testYvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            # testYvals = f_fit_model(testing_data["Xdata"], popt[0], popt[1], popt[2], popt[3])  # y = P4*x[i]**0 + P3*x[i]**1 + P2*x[i]**2 + P1*x[i]**3;
            testData["test-Yfit"] = testYvals

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = []  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = []  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if len(weight) == 0:
                # sigma_std = numpy.sqrt(numpy.diagonal(pcov))  # numpy.sqrt() 表示開二次方根，numpy.diagonal() 表示提取矩陣的對角綫向量;
                # # 使用 curve_fit() 函數的返回值 pcov 矩陣的對角綫向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 pcov 矩陣的對角綫向量獲得的擬合誤差，得到總的不確定度;
                # # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
                # # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差向量傳遞給 curve_fit() 函數的 sigma 參數，同時將 absolute_sigma=True 設定爲 True 值，表示，傳入的 sigma 參數的標準差是絕對的，而不只是一個相對的比例值;
                # CoefficientSTDlower = popt - sigma_std
                # CoefficientSTDupper = popt + sigma_std

                # 計算應變量 y 的擬合值的誤差上下限;
                # testYvalsSTDlower = f_fit_model(testing_data["Xdata"], CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
                testYvalsSTDlower = []
                for j in range(len(testing_data["Xdata"])):
                    yv = f_fit_model(testing_data["Xdata"][j], CoefficientSTDlower[0], CoefficientSTDlower[1], CoefficientSTDlower[2], CoefficientSTDlower[3])
                    yv = float(yv)
                    testYvalsSTDlower.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # testYvalsUncertaintyLower = []
                for i in range(len(testYvalsSTDlower)):
                    yul = float(testYvalsSTDlower[i])
                    # yul = testYvals[i] - numpy.sqrt(math.pow(testYvals[i] - testYvalsSTDlower[i], 2))
                    # yul = testYvals[i] - numpy.sqrt(math.pow(testYvals[i] - testYvalsSTDlower[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyLower.append(yul)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # testYvalsSTDupper = f_fit_model(testing_data["Xdata"], CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
                testYvalsSTDupper = []
                for j in range(len(testing_data["Xdata"])):
                    yv = f_fit_model(testing_data["Xdata"][j], CoefficientSTDupper[0], CoefficientSTDupper[1], CoefficientSTDupper[2], CoefficientSTDupper[3])
                    yv = float(yv)
                    testYvalsSTDupper.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # testYvalsUncertaintyUpper = []
                for i in range(len(testYvalsSTDupper)):
                    yuu = float(testYvalsSTDupper[i])
                    # yuu = testYvals[i] + numpy.sqrt(math.pow(testYvalsSTDupper[i] - testYvals[i], 2))
                    # yuu = testYvals[i] + numpy.sqrt(math.pow(testYvalsSTDupper[i] - testYvals[i], 2) + math.pow(testYdataSTD[i], 2))
                    testYvalsUncertaintyUpper.append(yuu)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper
        # else:

    # 判斷是否輸出繪圖;
    fig = None
    if True:
        # https://matplotlib.org/stable/contents.html
        # 使用第三方擴展包「matplotlib」中的「pyplot()」函數繪製散點圖示;
        # matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, clear=False, **kwargs)
        # 參數 figsize=(float,float) 表示繪圖板的長、寬數，預設值為 figsize=[6.4,4.8] 單位為英寸；參數 dpi=float 表示圖形分辨率，預設值為 dpi=100，單位為每平方英尺中的點數；參數 constrained_layout=True 設置子圖區域不要有重叠;
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
        # 繪製散點圖;
        axes_1.scatter(
            Xdata,
            YdataMean,  # Ydata,
            s=15,  # 點大小，取 0 表示不顯示;
            c='blue',  # 點顔色;
            edgecolors='blue',  # 邊顔色;
            linewidths=0.25,  # 邊粗細;
            marker='o',  # 點標志;
            alpha=1,  # 點透明度;
            label='observation values'
        )
        # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
        # 繪製平滑折綫圖;
        axes_1.plot(
            Xnew,
            Ynew,
            color='red',
            linewidth=1.0,
            linestyle='-',
            alpha=1,
            label='polyfit values'
        )

        # 描繪擬合曲綫的置信區間;
        if len(weight) == 0:
            axes_1.fill_between(
                Xnew,
                Ynewlower,
                Ynewupper,
                color='grey',  # 'black',
                linestyle=':',
                linewidth=0.5,
                alpha=0.15,
            )

        # 設置坐標軸標題
        axes_1.set_xlabel(
            'Independent Variable ( x )',
            fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
            fontsize='xx-small'
        )
        axes_1.set_ylabel(
            'Dependent Variable ( y )',
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
            "Polynomial ( Cubic ) model",
            fontdict={"family": "SimSun", "size": 7},
            fontsize='xx-small'
        )
        # 繪製殘差散點圖;
        # matplotlib_pyplot.figure()
        # plot3 = matplotlib_pyplot.plot(
        #     Xdata,
        #     Residual,
        #     color='blue',
        #     linewidth=1.0,
        #     linestyle=':',
        #     alpha=1,
        #     marker='o',
        #     markersize=5.0,
        #     markerfacecolor='blue',
        #     markeredgewidth=1,
        #     markeredgecolor="blue",
        #     label='polyfit values'
        # )  # 繪製無綫的點圖;
        # matplotlib_pyplot.xlabel('Independent Variable ( x )')  # 設置顯示橫軸標題為 'Independent Variable ( x )'
        # matplotlib_pyplot.ylabel('Residual')  # 設置顯示縱軸標題為 'Residual'
        # # matplotlib_pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
        # matplotlib_pyplot.title('Residual')  # 設置顯示圖標題;
        # matplotlib_pyplot.show()  # 顯示圖片;
        axes_2.plot(
            Xdata,
            Residual,
            color='blue',
            linewidth=1.0,
            linestyle=':',
            alpha=1,
            marker='o',
            markersize=4.0,
            markerfacecolor='blue',
            markeredgewidth=0.25,
            markeredgecolor="blue",
            label='Residual'
        )
        # axes_2.scatter(
        #     Xdata,
        #     Residual,
        #     s=15,  # 點大小，取 0 表示不顯示;
        #     c='blue',  # 點顔色;
        #     edgecolors='blue',  # 邊顔色;
        #     linewidths=1,  # 邊粗細;
        #     marker='o',  # 點標志;
        #     alpha=0.5,  # 點透明度;
        #     label='Residual'
        # )
        # 繪製殘差均值綫;
        axes_2.plot(
            [min(Xdata), max(Xdata)],
            [numpy.mean(Residual), numpy.mean(Residual)],
            color='red',
            linewidth=1.0,
            linestyle='-',
            alpha=1,
            label='Residual mean'
        )
        # 設置坐標軸標題
        axes_2.set_xlabel(
            'Independent Variable ( x )',
            fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
            fontsize='xx-small'
        )
        axes_2.set_ylabel(
            'Residual',
            fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
            fontsize='xx-small'
        )
        # # 確定橫縱坐標範圍;
        # axes_2.set_xlim(
        #     float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
        #     float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
        # )
        # axes_2.set_ylim(
        #     float(numpy.min(Residual)) - float((numpy.max(Residual) - numpy.min(Residual)) * 0.1),
        #     float(numpy.max(Residual)) + float((numpy.max(Residual) - numpy.min(Residual)) * 0.1)
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
        # axes_2.set_yticks(Residual)
        # # axes_2.set_yticklabels(
        # #     [
        # #         str(round(Residual[0], 0)),
        # #         str(round(Residual[1], 0)),
        # #         str(round(Residual[2], 0)),
        # #         str(round(Residual[3], 0)),
        # #         str(round(Residual[4], 0)),
        # #         str(round(Residual[5], 0)),
        # #         str(round(Residual[6], 0)),
        # #         str(round(Residual[7], 0)),
        # #         str(round(Residual[8], 0)),
        # #         str(round(Residual[9], 0)),
        # #         str(round(Residual[10], 0))
        # #     ],
        # #     rotation=0,
        # #     ha='right',
        # #     fontdict={"family": "SimSun", "size": 7},
        # #     fontsize='xx-small'
        # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
        # axes_2.set_yticklabels(
        #     [str(round(Residual[i], 3)) for i in range(len(Residual))],
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
        # axes_2.legend(
        #     loc='lower right',
        #     shadow=False,
        #     frameon=False,
        #     edgecolor='grey',
        #     framealpha=1,
        #     facecolor="none",
        #     prop={"family": "Times New Roman", "size": 7},
        #     fontsize='xx-small'
        # )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
        axes_2.spines['left'].set_linewidth(0.1)
        # axes_2.spines['left'].set_visible(False)  # 去除邊框;
        axes_2.spines['top'].set_visible(False)
        axes_2.spines['right'].set_visible(False)
        # axes_2.spines['bottom'].set_visible(False)
        axes_2.spines['bottom'].set_linewidth(0.1)

        # # fig.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()
        # # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;

    resultDict = {}
    if len(weight) > 0:
        # resultDict["Coefficient"] = popt
        resultDict["Coefficient"] = []
        for i in range(len(popt)):
            resultDict["Coefficient"].append(float(popt[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Residual"] = Residual
        resultDict["Residual"] = []
        # for i in range(len(Residual)):
        #     trainingResidual_1D = []
        #     for j in range(len(Residual[i])):
        #         trainingResidual_1D.append(float(Residual[i][j]))
        #     resultDict["Residual"].append(trainingResidual_1D)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        for i in range(len(Residual)):
            resultDict["Residual"].append(float(Residual[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit"] = Yvals
        resultDict["Yfit"] = []
        for i in range(len(Yvals)):
            resultDict["Yfit"].append(float(Yvals[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Coefficient-StandardDeviation"] = sigma_std  # 使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差;
        resultDict["Coefficient-StandardDeviation"] = []
        # for i in range(len(sigma_std)):
        #     resultDict["Coefficient-StandardDeviation"].append(float(sigma_std[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Lower"] = CoefficientSTDlower
        # resultDict["Coefficient-StandardDeviation-Lower"] = []
        # for i in range(len(CoefficientSTDlower)):
        #     resultDict["Coefficient-StandardDeviation-Lower"].append(float(CoefficientSTDlower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Upper"] = CoefficientSTDupper
        # resultDict["Coefficient-StandardDeviation-Upper"] = []
        # for i in range(len(CoefficientSTDupper)):
        #     resultDict["Coefficient-StandardDeviation-Upper"].append(float(CoefficientSTDupper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower  # 擬合的應變量 Yvals 誤差下限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Lower"] = []
        # for i in range(len(YvalsUncertaintyLower)):
        #     resultDict["Yfit-Uncertainty-Lower"].append(float(YvalsUncertaintyLower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper  # 擬合的應變量 Yvals 誤差上限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Upper"] = []
        # for i in range(len(YvalsUncertaintyUpper)):
        #     resultDict["Yfit-Uncertainty-Upper"].append(float(YvalsUncertaintyUpper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        resultDict["testData"] = testData  # 傳入測試數據集的計算結果;
        resultDict["fit-image"] = fig  # 擬合曲綫繪圖;
    elif len(weight) == 0:
        # resultDict["Coefficient"] = popt
        resultDict["Coefficient"] = []
        for i in range(len(popt)):
            resultDict["Coefficient"].append(float(popt[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Residual"] = Residual
        resultDict["Residual"] = []
        # for i in range(len(Residual)):
        #     trainingResidual_1D = []
        #     for j in range(len(Residual[i])):
        #         trainingResidual_1D.append(float(Residual[i][j]))
        #     resultDict["Residual"].append(trainingResidual_1D)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        for i in range(len(Residual)):
            resultDict["Residual"].append(float(Residual[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit"] = Yvals
        resultDict["Yfit"] = []
        for i in range(len(Yvals)):
            resultDict["Yfit"].append(float(Yvals[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Coefficient-StandardDeviation"] = sigma_std  # 使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差;
        resultDict["Coefficient-StandardDeviation"] = []
        for i in range(len(sigma_std)):
            resultDict["Coefficient-StandardDeviation"].append(float(sigma_std[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Lower"] = CoefficientSTDlower
        # resultDict["Coefficient-StandardDeviation-Lower"] = []
        # for i in range(len(CoefficientSTDlower)):
        #     resultDict["Coefficient-StandardDeviation-Lower"].append(float(CoefficientSTDlower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # # resultDict["Coefficient-StandardDeviation-Upper"] = CoefficientSTDupper
        # resultDict["Coefficient-StandardDeviation-Upper"] = []
        # for i in range(len(CoefficientSTDupper)):
        #     resultDict["Coefficient-StandardDeviation-Upper"].append(float(CoefficientSTDupper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower  # 擬合的應變量 Yvals 誤差下限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Lower"] = []
        for i in range(len(YvalsUncertaintyLower)):
            resultDict["Yfit-Uncertainty-Lower"].append(float(YvalsUncertaintyLower[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        # resultDict["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper  # 擬合的應變量 Yvals 誤差上限，使用 curve_fit() 函數返回值 pcov 矩陣對角綫元素開根號，估計得到的標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Upper"] = []
        for i in range(len(YvalsUncertaintyUpper)):
            resultDict["Yfit-Uncertainty-Upper"].append(float(YvalsUncertaintyUpper[i]))  # 使用 list.append() 函數在列表末尾追加推入新元素;
        resultDict["testData"] = testData  # 傳入測試數據集的計算結果;
        resultDict["fit-image"] = fig  # 擬合曲綫繪圖;

    return resultDict


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

# # 參數初始值;
# Pdata_0 = [
#     float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])),
#     float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])),
#     float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])),
#     float(numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])) * Xdata[i]**1)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**1) for i in range(len(YdataMean))])) * Xdata[i]**1)) for i in range(len(YdataMean))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])) * Xdata[i]**2)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**2) for i in range(len(YdataMean))])) * Xdata[i]**2)) for i in range(len(YdataMean))]) + numpy.mean([float(float(YdataMean[i] % float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])) * Xdata[i]**3)) * float(float(numpy.mean([(YdataMean[i]/Xdata[i]**3) for i in range(len(YdataMean))])) * Xdata[i]**3)) for i in range(len(YdataMean))]))
# ]

# # 參數上下限值;
# Plower = [
#     -math.inf,
#     -math.inf,
#     -math.inf,
#     -math.inf
# ]
# Pupper = [
#     math.inf,
#     math.inf,
#     math.inf,
#     math.inf
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
# # result["fit-image"].savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
# matplotlib_pyplot.show()
# # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
# # plot_Thread.start()
# # matplotlib_pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;



# 插值（Interpolations）;

# import numpy
# import scipy
# from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# import scipy.stats as scipy_stats
# from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合鏈條插值（Spline）函數;
# from scipy.interpolate import BSpline as scipy_interpolate_BSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「BSpline()」函數，用於擬合一維鏈條插值（1 Dimension BSpline）函數;
# from scipy.interpolate import interp1d as scipy_interpolate_interp1d  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「interp1d()」函數，用於擬合一維插值（1 Dimension）函數;
# from scipy.interpolate import UnivariateSpline as scipy_interpolate_UnivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「UnivariateSpline()」函數，用於擬合一維鏈條插值（1 Dimension spline）函數;
# from scipy.interpolate import lagrange as scipy_interpolate_lagrange  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「lagrange()」函數，用於擬合一維拉格朗日法（lagrange）插值（1 Dimension）函數;
# from scipy.interpolate import RectBivariateSpline as scipy_interpolate_RectBivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「RectBivariateSpline()」函數，用於擬合二維鏈條插值（2 Dimension BSpline）函數;
# from scipy.interpolate import griddata as scipy_interpolate_griddata  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「griddata()」函數，用於擬合二多維非結構化插值（2 Dimension）函數;
# from scipy.interpolate import Rbf as scipy_interpolate_Rbf  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「Rbf()」函數，用於擬合多維非結構化插值（n Dimension）函數;
# https://www.scipy.org/docs.html
def MathInterpolation(training_data, **args):

    # 變量實測值;
    # Xdata = [
    #     float(0),
    #     float(1),
    #     float(2),
    #     float(3),
    #     float(4),
    #     float(5),
    #     float(6),
    #     float(7),
    #     float(8),
    #     float(9),
    #     float(10)
    # ]  # 自變量 x 的實測數據;
    Xdata = numpy.array(training_data["Xdata"])
    # print(Xdata)
    # Ydata = [
    #     [float(1000), float(2000), float(3000)],
    #     [float(2000), float(3000), float(4000)],
    #     [float(3000), float(4000), float(5000)],
    #     [float(4000), float(5000), float(6000)],
    #     [float(5000), float(6000), float(7000)],
    #     [float(6000), float(7000), float(8000)],
    #     [float(7000), float(8000), float(9000)],
    #     [float(8000), float(9000), float(10000)],
    #     [float(9000), float(10000), float(11000)],
    #     [float(10000), float(11000), float(12000)],
    #     [float(11000), float(12000), float(13000)]
    # ]  # 應變量 y 的實測數據;
    Ydata = numpy.array(training_data["Ydata"])
    # print(Ydata)

    # 計算應變量 y 的實測值 Ydata 的均值;
    YdataMean = []
    for i in range(len(Ydata)):
        # if type(Ydata[i]) is list:
        # if isinstance(Ydata[i], list):
        if type(Ydata[i]) is numpy.ndarray:
            # yMean = float(numpy.mean(Ydata[i]))
            yMean = numpy.mean(Ydata[i])
            YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        else:
            # yMean = float(Ydata[i])
            yMean = Ydata[i]
            YdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    # print(YdataMean)

    # 計算應變量 y 的實測值 Ydata 的均值;
    YdataSTD = []
    for i in range(len(Ydata)):
        # if type(Ydata[i]) is list:
        # if isinstance(Ydata[i], list):
        if type(Ydata[i]) is numpy.ndarray:
            if len(Ydata[i]) > 1:
                # ySTD = float(numpy.std(Ydata[i], ddof=1))
                ySTD = numpy.std(Ydata[i], ddof=1)
                YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            elif len(Ydata[i]) == 1:
                # ySTD = float(numpy.std(Ydata[i]))
                ySTD = numpy.std(Ydata[i])
                YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
        else:
            ySTD = float(0.0)
            YdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
    # print(YdataSTD)

    Interpolation_Method = str("BSpline(Cubic)")  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
    # λ = int(0)  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
    k = int(2)  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;

    testing_data = {}

    # 讀取傳入函數的可變參數值;
    for key, value in args.items():
        if key == "Interpolation_Method":
            Interpolation_Method = value
        # if key == "λ":
        #     λ = value
        if key == "k":
            k = value
        if key == "testing_data":
            testing_data = value
        else:
            testing_data = training_data

    # from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合鏈條插值（Spline）函數;
    # from scipy.interpolate import BSpline as scipy_interpolate_BSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「BSpline()」函數，用於擬合一維鏈條插值（1 Dimension BSpline）函數;
    # from scipy.interpolate import interp1d as scipy_interpolate_interp1d  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「interp1d()」函數，用於擬合一維插值（1 Dimension）函數;
    # from scipy.interpolate import UnivariateSpline as scipy_interpolate_UnivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「UnivariateSpline()」函數，用於擬合一維鏈條插值（1 Dimension spline）函數;
    # from scipy.interpolate import lagrange as scipy_interpolate_lagrange  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「lagrange()」函數，用於擬合一維拉格朗日法（lagrange）插值（1 Dimension）函數;
    # from scipy.interpolate import RectBivariateSpline as scipy_interpolate_RectBivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「RectBivariateSpline()」函數，用於擬合二維鏈條插值（2 Dimension BSpline）函數;
    # from scipy.interpolate import griddata as scipy_interpolate_griddata  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「griddata()」函數，用於擬合二多維非結構化插值（2 Dimension）函數;
    # from scipy.interpolate import Rbf as scipy_interpolate_Rbf  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「Rbf()」函數，用於擬合多維非結構化插值（n Dimension）函數;
    # https://www.statsmodels.org/stable/index.html
    # 構造一個「插值對象」;
    # itp = scipy.interpolate.interp1d(x, y, kind='linear', axis=-1, copy=True, bounds_error=None, fill_value=nan, assume_sorted=False)
    # itp = scipy.interpolate.UnivariateSpline(x, y, w=None, bbox=[None, None], k=3, s=None, ext=0, check_finite=False)
    # itp = scipy.interpolate.make_interp_spline(x, y, k=3, t=None, bc_type=None, axis=0, check_finite=True)
    # itp = scipy.interpolate.BSpline(t, c, k, extrapolate=True, axis=0)
    # itp = scipy.interpolate.griddata(points, values, xi, method='linear', fill_value=nan, rescale=False)
    # itp = scipy.interpolate.RectBivariateSpline(x, y, z, bbox=[None, None, None, None], kx=3, ky=3, s=0)[source]

    # Dependent variable = Xdata;
    # Independent variable = YdataMean;
    itp = None
    if Interpolation_Method == "Constant(Previous)":
        itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="previous", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "Constant(Next)":
        itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="next", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "Linear":
        itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="linear", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "BSpline(Linear)":
        # 1 次方樣條插值;
        itp = scipy_interpolate_UnivariateSpline(YdataMean, Xdata, w=None, bbox=[None, None], k=1, s=0, ext="extrapolate")
        # itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="slinear", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "BSpline(Quadratic)":
        # 2 次方樣條插值;
        itp = scipy_interpolate_UnivariateSpline(YdataMean, Xdata, w=None, bbox=[None, None], k=2, s=None, ext="extrapolate")
    elif Interpolation_Method == "BSpline(Cubic)":
        # 3 次方樣條插值;
        itp = scipy_interpolate_UnivariateSpline(YdataMean, Xdata, w=None, bbox=[None, None], k=3, s=None, ext="extrapolate")
    elif Interpolation_Method == "Polynomial(Linear)":
        # 缐性插值;
        itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="linear", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "Polynomial(Quadratic)":
        # 2 階多項式插值;
        itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="quadratic", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "Polynomial(Cubic)":
        # 3 階多項式插值;
        itp = scipy_interpolate_interp1d(YdataMean, Xdata, kind="cubic", bounds_error=False, fill_value="extrapolate", assume_sorted=False)
    elif Interpolation_Method == "Lagrange":
        itp = scipy_interpolate_lagrange(YdataMean, Xdata)
    # elif Interpolation_Method == "SteffenMonotonicInterpolation":
    #     # 單調插值;
    # elif Interpolation_Method == "Spline(Akima)":
    #     # 阿基馬（Akima）（阿基米德）樣條（Spline）插值，提供平滑效果，計算效率高;
    elif Interpolation_Method == "B-Splines":
        # 貝塞爾曲缐（B-Splines）樣條插值：BSplineInterpolation(u, t, d, pVec, knotVec) ;
        # y : Dependent variable = Xdata;
        # x : Independent variable = YdataMean;
        # 參數：k 表示，傳入 B 樣條曲缐（B-Splines）的次數，可取 2 值;
        # 參數：extrapolate 表示，是否外推插值;
        itp = scipy_interpolate_BSpline(YdataMean, Xdata, k, extrapolate=True)
    # elif Interpolation_Method == "B-Splines(Approx)":
    #     # 平滑擬合的貝塞爾曲缐（B-Splines Approx）（近似貝塞爾曲缐）樣條插值：BSplineApprox(u, t, d, h, pVec, knotVec) ;
    #     # y : Dependent variable = Xdata;
    #     # x : Independent variable = YdataMean;
    #     # 參數：d 表示，傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
    #     # 參數：h 表示，定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
    #     # 參數：pVec 表示，符號標識參數向量，可取值 pVec = :Uniform 表示參數均勻分布，取值 pVec = :ArcLen 表示由弦長法生成的參數;
    #     # 參數：knotVec 表示，符號標識結點向量，可取值 knotVec = :Uniform 表示均匀結點向量，取值 knotVec = :Average 表示平均間距的結點向量;
    #     itp = DataInterpolations.BSplineApprox(Xdata, YdataMean, d, h, :ArcLen, :Average, extrapolate=true);
    # else:

    # testData = {}
    # fig = None
    resultDict = {}
    if itp is None:
        print("The interpolation arguments cannot be recognized, the interpolation object cannot be established.")
        resultDict["error"] = str("The interpolation arguments cannot be recognized, the interpolation object cannot be established.")
        resultDict["training_data"] = training_data
        resultDict["Interpolation_Method"] = Interpolation_Method
        resultDict["λ"] = λ
        resultDict["k"] = k
        resultDict["d"] = d
        resultDict["h"] = h
        # resultDict["testing_data"] = testing_data
        # resultDict["testData"] = {};  # 傳入測試數據集的計算結果;
        # resultDict["fit-image"] = None  # 擬合曲綫繪圖;
        # println(resultDict);
        return resultDict

    # 計算測試集數據的擬合值;
    testData = {}
    if isinstance(testing_data, dict) and len(testing_data) > 0:

        testData = testing_data

        if testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    yMean = float(numpy.mean(testing_data["Ydata"][i]))
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    yMean = float(testing_data["Ydata"][i])
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-Mean"] = testYdataMean
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    if len(testing_data["Ydata"][i]) > 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i], ddof=1))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    elif len(testing_data["Ydata"][i]) == 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i]))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:
                else:
                    ySTD = float(0.0)
                    testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-StandardDeviation"] = testYdataSTD

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = []  # 應變量 X 的擬合值;
            for i in range(len(testYdataMean)):
                # # xv = None
                # if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                    xv = float(itp(testYdataMean[i]))
                    testXvals.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # # testXvals.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Xvals"] = testXvals

            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = []  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = []  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲插值（Interpolation）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
            testXdataSTD = []
            for j in range(len(testYdataSTD)):
                # # xv = None
                # if (float(testYdataMean[j]) >= float(min(YdataMean)) and float(testYdataMean[j]) <= float(max(YdataMean))) and (float(testYdataMean[j] + testYdataSTD[j]) >= float(min(YdataMean)) and float(testYdataMean[j] + testYdataSTD[j]) <= float(max(YdataMean))):
                #     xv = abs(float(itp(testYdataMean[j])) - float(itp(testYdataMean[j] + testYdataSTD[j])))
                #     testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # # testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                xv = abs(float(itp(testYdataMean[j])) - float(itp(testYdataMean[j] + testYdataSTD[j])))
                testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;

            # 通過插值算法（Interpolation Algorithm）的標準差（Standard Deviation）（插值計算結果的不確定度），轉換爲插值（Interpolation）之後的 X 值的插值算法（Interpolation Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            # 這裏因爲插值算法（Interpolation Algorithm）的的標準差（Standard Deviation）未給出，將之視爲零（0），因此 Y 值的觀察（Observation）標準差（Standard Deviation），即是轉換爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            for i in range(len(testYdataMean)):
                # xvLower = None
                # xvUpper = None
                # if not ((testXvals[i] is None) or (testXdataSTD[i] is None)):
                #     xvLower = float(testXvals[i] - testXdataSTD[i])
                #     xvUpper = float(testXvals[i] + testXdataSTD[i])
                # testXvalsUncertaintyLower.append(xvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # testXvalsUncertaintyUpper.append(xvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # if not ((testXvals[i] is None) or (testXdataSTD[i] is None)):
                if int(i) <= int(len(testXvals)) and int(i) <= int(len(testXdataSTD)):
                    xvLower = float(testXvals[i] - testXdataSTD[i])
                    testXvalsUncertaintyLower.append(xvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    xvUpper = float(testXvals[i] + testXdataSTD[i])
                    testXvalsUncertaintyUpper.append(xvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper

            # 計算測試集數據的擬合殘差;
            testResidual = []  # 擬合殘差向量;
            for i in range(len(testing_data["Xdata"])):
                # resi = None
                # if not ((testing_data["Xdata"][i] is None) or (testXvals[i] is None)):
                #     resi = float(float(testing_data["Xdata"][i]) - float(testXvals[i]))
                # testResidual.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                if int(i) <= int(len(testXvals)):
                    resi = float(float(testing_data["Xdata"][i]) - float(testXvals[i]))
                    testResidual.append(resi)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Residual"] = testResidual

        elif (not(testing_data.__contains__("Xdata")) or len(testing_data["Xdata"]) <= 0) and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    yMean = float(numpy.mean(testing_data["Ydata"][i]))
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                else:
                    yMean = float(testing_data["Ydata"][i])
                    testYdataMean.append(yMean)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-Mean"] = testYdataMean
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = []
            for i in range(len(testing_data["Ydata"])):
                # if type(testing_data["Ydata"][i]) is list:
                if isinstance(testing_data["Ydata"][i], list):
                    if len(testing_data["Ydata"][i]) > 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i], ddof=1))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    elif len(testing_data["Ydata"][i]) == 1:
                        ySTD = float(numpy.std(testing_data["Ydata"][i]))
                        testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    # else:
                else:
                    ySTD = float(0.0)
                    testYdataSTD.append(ySTD)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Ydata-StandardDeviation"] = testYdataSTD

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = []  # 應變量 X 的擬合值;
            for i in range(len(testYdataMean)):
                # # xv = None
                # if float(testYdataMean[i]) >= float(min(YdataMean)) and float(testYdataMean[i]) <= float(max(YdataMean)):
                    xv = float(itp(testYdataMean[i]))
                    testXvals.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # # testXvals.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Xvals"] = testXvals

            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = []  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = []  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲插值（Interpolation）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
            testXdataSTD = []
            for j in range(len(testYdataSTD)):
                # # xv = None
                # if (float(testYdataMean[j]) >= float(min(YdataMean)) and float(testYdataMean[j]) <= float(max(YdataMean))) and (float(testYdataMean[j] + testYdataSTD[j]) >= float(min(YdataMean)) and float(testYdataMean[j] + testYdataSTD[j]) <= float(max(YdataMean))):
                #     xv = abs(float(itp(testYdataMean[j])) - float(itp(testYdataMean[j] + testYdataSTD[j])))
                #     testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # # testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                xv = abs(float(itp(testYdataMean[j])) - float(itp(testYdataMean[j] + testYdataSTD[j])))
                testXdataSTD.append(xv)  # 使用 list.append() 函數在列表末尾追加推入新元素;

            # 通過插值算法（Interpolation Algorithm）的標準差（Standard Deviation）（插值計算結果的不確定度），轉換爲插值（Interpolation）之後的 X 值的插值算法（Interpolation Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            # 這裏因爲插值算法（Interpolation Algorithm）的的標準差（Standard Deviation）未給出，將之視爲零（0），因此 Y 值的觀察（Observation）標準差（Standard Deviation），即是轉換爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            for i in range(len(testYdataMean)):
                # xvLower = None
                # xvUpper = None
                # if not ((testXvals[i] is None) or (testXdataSTD[i] is None)):
                #     xvLower = float(testXvals[i] - testXdataSTD[i])
                #     xvUpper = float(testXvals[i] + testXdataSTD[i])
                # testXvalsUncertaintyLower.append(xvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                # testXvalsUncertaintyUpper.append(xvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                # if not ((testXvals[i] is None) or (testXdataSTD[i] is None)):
                if int(i) <= int(len(testXvals)) and int(i) <= int(len(testXdataSTD)):
                    xvLower = float(testXvals[i] - testXdataSTD[i])
                    testXvalsUncertaintyLower.append(xvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;
                    xvUpper = float(testXvals[i] + testXdataSTD[i])
                    testXvalsUncertaintyUpper.append(xvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper

        elif testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and (not(testing_data.__contains__("Ydata")) or len(testing_data["Ydata"]) <= 0):

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = []  # 應變量 y 的擬合值;
            if not (itp is None):

                for i in range(len(testing_data["Xdata"])):

                    # if float(testing_data["Xdata"][i]) >= float(min(Xdata)) and float(testing_data["Xdata"][i]) <= float(max(Xdata)):

                    #     def rf1(x):
                    #         y = float(itp(x)) - float(testing_data["Xdata"][i])
                    #         return y
                    #     # rf1 = lambda x: (float(itp(x)) - float(testing_data["Xdata"][i]))

                    #     # 計算二分法求根的含根區間（迭代初值）;
                    #     Y_lower = -math.inf
                    #     Y_upper = +math.inf
                    #     if testing_data["Xdata"][i] < min(Xdata):
                    #     # if testing_data["Xdata"][i] < Xdata[1]:
                    #         # Y_lower = float(2.2250738585072e-308)  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    #         Y_upper = min(YdataMean)
                    #         # Y_upper = YdataMean[1]
                    #     if testing_data["Xdata"][i] > max(Xdata):
                    #     # if testing_data["Xdata"][i] > Xdata[len(Xdata)]:
                    #         # Y_lower = YdataMean[len(YdataMean)]
                    #         Y_lower = max(YdataMean)
                    #         # Y_upper = float(1.79769313486232e+308)  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    #     if testing_data["Xdata"][i] >= min(Xdata) and testing_data["Xdata"][i] <= max(Xdata):
                    #     # if testing_data["Xdata"][i] >= Xdata[1] && testing_data["Xdata"][i] <= Xdata[len(Xdata)]:
                    #         for j in range(len(Xdata)):
                    #             # if int(j) == int(i):
                    #             # if int(j) == int(len(Xdata)):
                    #             if float(testing_data["Xdata"][i]) == float(Xdata[j]):
                    #                 Y_lower = YdataMean[j] * float(0.99)
                    #                 Y_upper = YdataMean[j] * float(1.01)
                    #                 break
                    #             if testing_data["Xdata"][i] > Xdata[j]:
                    #                 Y_lower = YdataMean[j]
                    #             if testing_data["Xdata"][i] < Xdata[j]:
                    #                 Y_upper = YdataMean[j]
                    #                 break
                    #     # print(Y_lower)
                    #     # print(Y_upper)

                    #     # 參數 method='bisect' 表示二分法（Bisection），需要傳入含根區間，參數 method='hybr' 表示牛頓法（Newton），需要傳入迭代起始值，參數 method='lm' 表示最小二乘法，需要傳入迭代起始值，'broyden1', 'broyden2', 'anderson', 'linearmixing', 'diagbroyden', 'excitingmixing', 'krylov', 'df-sane’;
                    #     # X_Root = scipy.optimize.root(rf1, X_0, args=(), method='hybr', jac=None, tol=None, callback=None, options={'full_output': 0, 'col_deriv': 0, 'diag': None, 'factor': 100, 'eps': None, 'band': None, 'func': None, 'maxfev': 0, 'xtol': 1.49012e-08});
                    #     # print("X ≈ ", X_Root.x)  # 輸出根的值;
                    #     # print(X_Root.fun)  # 輸出根的函數值;
                    #     #  print(X_Root.converged)  # 算法收斂標準;
                    #     #  print(X_Root.iterations)  # 迭代次數;
                    #     # yv = scipy_optimize_root(rf1, (Y_lower, Y_upper), method='bisect', options={"maxiter": 10000})
                    #     yv = scipy_optimize_root(rf1, (Y_upper), method='hybr', options={"maxiter": 10000})
                    #     yv = float((yv.x)[0])
                    #     testYvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;

                    def rf1(x):
                        y = float((itp(x))[0]) - float(testing_data["Xdata"][i])
                        return y
                    # rf1 = lambda x: (float(itp(x)) - float(testing_data["Xdata"][i]))

                    # 計算二分法求根的含根區間（迭代初值）;
                    Y_lower = -math.inf
                    Y_upper = +math.inf
                    if testing_data["Xdata"][i] < min(Xdata):
                    # if testing_data["Xdata"][i] < Xdata[1]:
                        # Y_lower = float(2.2250738585072e-308)  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        Y_upper = min(YdataMean)
                        # Y_upper = YdataMean[1]
                    if testing_data["Xdata"][i] > max(Xdata):
                    # if testing_data["Xdata"][i] > Xdata[len(Xdata)]:
                        # Y_lower = YdataMean[len(YdataMean)]
                        Y_lower = max(YdataMean)
                        # Y_upper = float(1.79769313486232e+308)  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    if testing_data["Xdata"][i] >= min(Xdata) and testing_data["Xdata"][i] <= max(Xdata):
                    # if testing_data["Xdata"][i] >= Xdata[1] && testing_data["Xdata"][i] <= Xdata[len(Xdata)]:
                        for j in range(len(Xdata)):
                            # if int(j) == int(i):
                            # if int(j) == int(len(Xdata)):
                            if float(testing_data["Xdata"][i]) == float(Xdata[j]):
                                Y_lower = YdataMean[j] * float(0.99)
                                Y_upper = YdataMean[j] * float(1.01)
                                break
                            if testing_data["Xdata"][i] > Xdata[j]:
                                Y_lower = YdataMean[j]
                            if testing_data["Xdata"][i] < Xdata[j]:
                                Y_upper = YdataMean[j]
                                break
                    # print(Y_lower)
                    # print(Y_upper)

                    # 參數 method='bisect' 表示二分法（Bisection），需要傳入含根區間，參數 method='hybr' 表示牛頓法（Newton），需要傳入迭代起始值，參數 method='lm' 表示最小二乘法，需要傳入迭代起始值，'broyden1', 'broyden2', 'anderson', 'linearmixing', 'diagbroyden', 'excitingmixing', 'krylov', 'df-sane’;
                    # X_Root = scipy.optimize.root(rf1, X_0, args=(), method='hybr', jac=None, tol=None, callback=None, options={'full_output': 0, 'col_deriv': 0, 'diag': None, 'factor': 100, 'eps': None, 'band': None, 'func': None, 'maxfev': 0, 'xtol': 1.49012e-08});
                    # print("X ≈ ", X_Root.x)  # 輸出根的值;
                    # print(X_Root.fun)  # 輸出根的函數值;
                    #  print(X_Root.converged)  # 算法收斂標準;
                    #  print(X_Root.iterations)  # 迭代次數;
                    # yv = scipy_optimize_root(rf1, (Y_lower, Y_upper), method='bisect', options={"maxfev": 10000})
                    yv = scipy_optimize_root(rf1, (Y_upper), method='hybr', options={"maxfev": 10000})
                    yv = float((yv.x)[0])
                    testYvals.append(yv)  # 使用 list.append() 函數在列表末尾追加推入新元素;

            testData["test-Yfit"] = testYvals

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = []  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = []  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            # if int(len(weight)) == int(0):
            #     for i in range(len(testing_data["Xdata"])):
            #         yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))**(P3 - sdP3))  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
            #         # yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))**(P3 - sdP3))**(P5 - sdP5))  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
            #         yvLower = testYvals[i] - numpy.sqrt((testYvals[i] - yvsd)**2)
            #         # yvLower = testYvals[i] - numpy.sqrt((testYvals[i] - yvsd)**2 + testYdataSTD[i]**2)
            #         testYvalsUncertaintyLower.append(yvLower)  # 使用 list.append() 函數在列表末尾追加推入新元素;

            #         yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))**(P3 + sdP3))  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
            #         # yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))**(P3 + sdP3))**(P5 + sdP5))  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
            #         yvUpper = testYvals[i] + numpy.sqrt((yvsd - testYvals[i])**2)
            #         # yvUpper = testYvals[i] + numpy.sqrt((yvsd - testYvals[i])**2 + testYdataSTD[i]**2)
            #         testYvalsUncertaintyUpper.append(yvUpper)  # 使用 list.append() 函數在列表末尾追加推入新元素;
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper

        # else:

    # 生成插值數據，使繪製的擬合折綫圖平滑;
    if not (itp is None):
        # # idx = range(len(Xdata))  # 記錄橫軸刻度標簽數;
        # # Xnew = numpy.linspace(min(idx), max(idx), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
        # # spl = scipy_interpolate_make_interp_spline(idx, Yvals, k=3)  # 使用第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，擬合三次多項式插值函數;
        # Xnew = numpy.linspace(min(Xdata), max(Xdata), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
        # spl = scipy_interpolate_make_interp_spline(Xdata, Yvals, k=3)  # 使用第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，擬合三次多項式插值函數;
        # Ynew = spl(Xnew)  # 生成插值縱坐標值;

        # # 生成置信區間上下限插值縱坐標值;
        # # splLower = scipy_interpolate_make_interp_spline(idx, YvalsUncertaintyLower, k=3)
        # splLower = scipy_interpolate_make_interp_spline(Xdata, YvalsUncertaintyLower, k=3)
        # Ynewlower = splLower(Xnew)  # 生成置信區間下限插值縱坐標值;
        # # splUpper = scipy_interpolate_make_interp_spline(idx, YvalsUncertaintyUpper, k=3)
        # splUpper = scipy_interpolate_make_interp_spline(Xdata, YvalsUncertaintyUpper, k=3)
        # Ynewupper = splUpper(Xnew)  # 生成置信區間上限插值縱坐標值;

        # idy = range(len(YdataMean))  # 記錄縱軸刻度標簽數;
        Ynew = numpy.linspace(min(YdataMean), max(YdataMean), 300)  # 使用第三方擴展包「numpy」中的「linspace()」函數在最大值和最小值之間均匀插入 300 個點;
        # Xnew = itp(Ynew)
        Xnew = []
        for i in range(len(Ynew)):
            Xnew_I = float(itp(Ynew[i]))  # 生成插值縱坐標值;
            Xnew.append(Xnew_I)  # 使用 list.append() 函數在列表末尾追加推入新元素;

    # 判斷是否輸出繪圖;
    fig = None
    if True:
        # https://matplotlib.org/stable/contents.html
        # 使用第三方擴展包「matplotlib」中的「pyplot()」函數繪製散點圖示;
        # matplotlib.pyplot.figure(num=None, figsize=None, dpi=None, facecolor=None, edgecolor=None, frameon=True, FigureClass=<class 'matplotlib.figure.Figure'>, clear=False, **kwargs)
        # 參數 figsize=(float,float) 表示繪圖板的長、寬數，預設值為 figsize=[6.4,4.8] 單位為英寸；參數 dpi=float 表示圖形分辨率，預設值為 dpi=100，單位為每平方英尺中的點數；參數 constrained_layout=True 設置子圖區域不要有重叠;
        fig = matplotlib_pyplot.figure(figsize=(16, 9), dpi=300, constrained_layout=True)  # 參數 constrained_layout=True 設置子圖區域不要有重叠
        # fig.tight_layout()  # 自動調整子圖參數，使之填充整個圖像區域;
        # matplotlib.pyplot.subplot2grid(shape, loc, rowspan=1, colspan=1, fig=None, **kwargs)
        # 參數 shape=(int,int) 表示創建網格行列數，傳入參數值類型為一維整型數組[int,int]；參數 loc=(int,int) 表示一個畫布所占網格起點的橫縱坐標，傳入參數值類型為一維整型數組[int,int]；參數 rowspan=1 表示該畫布占一行的長度，參數 colspan=1 表示該畫布占一列的寬度;
        axes_1 = matplotlib_pyplot.subplot2grid((2, 1), (0, 0), rowspan=1, colspan=1)  # 參數 (2,1) 表示創建 2 行 1 列的網格，參數 (0,0) 表示第一個畫布 axes_1 的起點在橫坐標為 0 縱坐標為 0 的網格，參數 rowspan=1 表示該畫布占一行的長度，參數 colspan=1 表示該畫布占一列的寬度;
        axes_2 = matplotlib_pyplot.subplot2grid((2, 1), (1, 0), rowspan=1, colspan=1)

        if testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

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
            # matplotlib_pyplot.title(str("Interpolation : " + str(Interpolation_Method) + " model"))  # 設置顯示圖標題;
            # matplotlib_pyplot.show()  # 顯示圖片;
            # 繪製散點圖;
            axes_1.scatter(
                Xdata,
                YdataMean,  # Ydata,
                s=15,  # 點大小，取 0 表示不顯示;
                c='blue',  # 點顔色;
                edgecolors='blue',  # 邊顔色;
                linewidths=0.25,  # 邊粗細;
                marker='o',  # 點標志;
                alpha=1,  # 點透明度;
                label='observation values'
            )
            # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
            # 繪製平滑折綫圖;
            axes_1.plot(
                Xnew,
                Ynew,
                color='red',
                linewidth=1.0,
                linestyle='-',
                alpha=1,
                label='polyfit values'
            )

            # # 描繪擬合曲綫的置信區間;
            # axes_1.fill_between(
            #     Xnew,
            #     Ynewlower,
            #     Ynewupper,
            #     color='grey',  # 'black',
            #     linestyle=':',
            #     linewidth=0.5,
            #     alpha=0.15,
            # )

            # 設置坐標軸標題
            axes_1.set_xlabel(
                'Independent Variable ( x )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            axes_1.set_ylabel(
                'Dependent Variable ( y )',
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
                str("Interpolation : " + str(Interpolation_Method) + " model"),
                fontdict={"family": "SimSun", "size": 7},
                fontsize='xx-small'
            )
            # 繪製殘差散點圖;
            # matplotlib_pyplot.figure()
            # plot3 = matplotlib_pyplot.plot(
            #     testing_data["Xdata"],  # Xdata,
            #     testData["test-Residual"],  # Residual,
            #     color='blue',
            #     linewidth=1.0,
            #     linestyle=':',
            #     alpha=1,
            #     marker='o',
            #     markersize=5.0,
            #     markerfacecolor='blue',
            #     markeredgewidth=1,
            #     markeredgecolor="blue",
            #     label='polyfit values'
            # )  # 繪製無綫的點圖;
            # matplotlib_pyplot.xlabel('Independent Variable ( x )')  # 設置顯示橫軸標題為 'Independent Variable ( x )'
            # matplotlib_pyplot.ylabel('Residual')  # 設置顯示縱軸標題為 'Residual'
            # # matplotlib_pyplot.legend(loc=4)  # 設置顯示圖例（legend）的位置為圖片右下角，覆蓋圖片;
            # matplotlib_pyplot.title('Residual')  # 設置顯示圖標題;
            # matplotlib_pyplot.show()  # 顯示圖片;
            axes_2.plot(
                testing_data["Xdata"],  # Xdata,
                testData["test-Residual"],  # Residual,
                color='blue',
                linewidth=1.0,
                linestyle=':',
                alpha=1,
                marker='o',
                markersize=4.0,
                markerfacecolor='blue',
                markeredgewidth=0.25,
                markeredgecolor="blue",
                label='Residual'
            )
            # axes_2.scatter(
            #     testing_data["Xdata"],  # Xdata,
            #     testData["test-Residual"],  # Residual,
            #     s=15,  # 點大小，取 0 表示不顯示;
            #     c='blue',  # 點顔色;
            #     edgecolors='blue',  # 邊顔色;
            #     linewidths=1,  # 邊粗細;
            #     marker='o',  # 點標志;
            #     alpha=0.5,  # 點透明度;
            #     label='Residual'
            # )
            # 繪製殘差均值綫;
            axes_2.plot(
                [min(testing_data["Xdata"]), max(testing_data["Xdata"])],  # [min(Xdata), max(Xdata)],
                [numpy.mean(testData["test-Residual"]), numpy.mean(testData["test-Residual"])],  # [numpy.mean(Residual), numpy.mean(Residual)],
                color='red',
                linewidth=1.0,
                linestyle='-',
                alpha=1,
                label='Residual mean'
            )
            # 設置坐標軸標題
            axes_2.set_xlabel(
                'Independent Variable ( x )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            axes_2.set_ylabel(
                'Residual',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            # # 確定橫縱坐標範圍;
            # axes_2.set_xlim(
            #     float(numpy.min(testing_data["Xdata"])) - float((numpy.max(testing_data["Xdata"]) - numpy.min(testing_data["Xdata"])) * 0.1),  # float(numpy.min(Xdata)) - float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1),
            #     float(numpy.max(testing_data["Xdata"])) + float((numpy.max(testing_data["Xdata"]) - numpy.min(testing_data["Xdata"])) * 0.1)  # float(numpy.max(Xdata)) + float((numpy.max(Xdata) - numpy.min(Xdata)) * 0.1)
            # )
            # axes_2.set_ylim(
            #     float(numpy.min(testData["test-Residual"])) - float((numpy.max(testData["test-Residual"]) - numpy.min(testData["test-Residual"])) * 0.1),  # float(numpy.min(Residual)) - float((numpy.max(Residual) - numpy.min(Residual)) * 0.1),
            #     float(numpy.max(testData["test-Residual"])) + float((numpy.max(testData["test-Residual"]) - numpy.min(testData["test-Residual"])) * 0.1)  # float(numpy.max(Residual)) + float((numpy.max(Residual) - numpy.min(Residual)) * 0.1)
            # )
            # # 設置坐標軸間隔和標簽
            # axes_2.set_xticks(testing_data["Xdata"])  # axes_2.set_xticks(Xdata)
            # # axes_2.set_xticklabels(
            # #     [
            # #         str(round(int(testing_data["Xdata"][0]), 0)),  # str(round(int(Xdata[0]), 0)),
            # #         str(round(int(testing_data["Xdata"][1]), 0)),  # str(round(int(Xdata[1]), 0)),
            # #         str(round(int(testing_data["Xdata"][2]), 0)),  # str(round(int(Xdata[2]), 0)),
            # #         str(round(int(testing_data["Xdata"][3]), 0)),  # str(round(int(Xdata[3]), 0)),
            # #         str(round(int(testing_data["Xdata"][4]), 0)),  # str(round(int(Xdata[4]), 0)),
            # #         str(round(int(testing_data["Xdata"][5]), 0)),  # str(round(int(Xdata[5]), 0)),
            # #         str(round(int(testing_data["Xdata"][6]), 0)),  # str(round(int(Xdata[6]), 0)),
            # #         str(round(int(testing_data["Xdata"][7]), 0)),  # str(round(int(Xdata[7]), 0)),
            # #         str(round(int(testing_data["Xdata"][8]), 0)),  # str(round(int(Xdata[8]), 0)),
            # #         str(round(int(testing_data["Xdata"][9]), 0)),  # str(round(int(Xdata[9]), 0)),
            # #         str(round(int(testing_data["Xdata"][10]), 0))  # str(round(int(Xdata[10]), 0))
            # #     ],
            # #     rotation=0,
            # #     ha='center',
            # #     fontdict={"family": "SimSun", "size": 7},
            # #     fontsize='xx-small'
            # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
            # axes_2.set_xticklabels(
            #     [str(round(int(testing_data["Xdata"][i]), 0)) for i in range(len(testing_data["Xdata"]))],  # [str(round(int(Xdata[i]), 0)) for i in range(len(Xdata))],
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
            # axes_2.set_yticks(testData["test-Residual"])  # axes_2.set_yticks(Residual)
            # # axes_2.set_yticklabels(
            # #     [
            # #         str(round(testData["test-Residual"][0], 0)),  # str(round(Residual[0], 0)),
            # #         str(round(testData["test-Residual"][1], 0)),  # str(round(Residual[1], 0)),
            # #         str(round(testData["test-Residual"][2], 0)),  # str(round(Residual[2], 0)),
            # #         str(round(testData["test-Residual"][3], 0)),  # str(round(Residual[3], 0)),
            # #         str(round(testData["test-Residual"][4], 0)),  # str(round(Residual[4], 0)),
            # #         str(round(testData["test-Residual"][5], 0)),  # str(round(Residual[5], 0)),
            # #         str(round(testData["test-Residual"][6], 0)),  # str(round(Residual[6], 0)),
            # #         str(round(testData["test-Residual"][7], 0)),  # str(round(Residual[7], 0)),
            # #         str(round(testData["test-Residual"][8], 0)),  # str(round(Residual[8], 0)),
            # #         str(round(testData["test-Residual"][9], 0)),  # str(round(Residual[9], 0)),
            # #         str(round(testData["test-Residual"][10], 0))  # str(round(Residual[10], 0))
            # #     ],
            # #     rotation=0,
            # #     ha='right',
            # #     fontdict={"family": "SimSun", "size": 7},
            # #     fontsize='xx-small'
            # # )  # [str(round([0, 0.2, 0.4, 0.6, 0.8, 1][i], 1)) for i in range(len([0, 0.2, 0.4, 0.6, 0.8, 1]))]
            # axes_2.set_yticklabels(
            #     [str(round(testData["test-Residual"][i], 3)) for i in range(len(testData["test-Residual"]))],  # [str(round(Residual[i], 3)) for i in range(len(Residual))],
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
            # axes_2.legend(
            #     loc='lower right',
            #     shadow=False,
            #     frameon=False,
            #     edgecolor='grey',
            #     framealpha=1,
            #     facecolor="none",
            #     prop={"family": "Times New Roman", "size": 7},
            #     fontsize='xx-small'
            # )  # best', 'upper left','center left' 在圖上顯示圖例標志 'x-large';
            axes_2.spines['left'].set_linewidth(0.1)
            # axes_2.spines['left'].set_visible(False)  # 去除邊框;
            axes_2.spines['top'].set_visible(False)
            axes_2.spines['right'].set_visible(False)
            # axes_2.spines['bottom'].set_visible(False)
            axes_2.spines['bottom'].set_linewidth(0.1)

        if (not(testing_data.__contains__("Xdata")) or len(testing_data["Xdata"]) <= 0) and testing_data.__contains__("Ydata") and len(testing_data["Ydata"]) > 0:

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
            # matplotlib_pyplot.title(str("Interpolation : " + str(Interpolation_Method) + " model"))  # 設置顯示圖標題;
            # matplotlib_pyplot.show()  # 顯示圖片;
            # 繪製散點圖;
            axes_1.scatter(
                Xdata,
                YdataMean,  # Ydata,
                s=15,  # 點大小，取 0 表示不顯示;
                c='blue',  # 點顔色;
                edgecolors='blue',  # 邊顔色;
                linewidths=0.25,  # 邊粗細;
                marker='o',  # 點標志;
                alpha=1,  # 點透明度;
                label='observation values'
            )
            # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
            # 繪製平滑折綫圖;
            axes_1.plot(
                Xnew,
                Ynew,
                color='red',
                linewidth=1.0,
                linestyle='-',
                alpha=1,
                label='polyfit values'
            )

            # # 描繪擬合曲綫的置信區間;
            # axes_1.fill_between(
            #     Xnew,
            #     Ynewlower,
            #     Ynewupper,
            #     color='grey',  # 'black',
            #     linestyle=':',
            #     linewidth=0.5,
            #     alpha=0.15,
            # )

            # 設置坐標軸標題
            axes_1.set_xlabel(
                'Independent Variable ( x )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            axes_1.set_ylabel(
                'Dependent Variable ( y )',
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
                str("Interpolation : " + str(Interpolation_Method) + " model"),
                fontdict={"family": "SimSun", "size": 7},
                fontsize='xx-small'
            )

        if testing_data.__contains__("Xdata") and len(testing_data["Xdata"]) > 0 and (not(testing_data.__contains__("Ydata")) or len(testing_data["Ydata"]) <= 0):

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
            # matplotlib_pyplot.title(str("Interpolation : " + str(Interpolation_Method) + " model"))  # 設置顯示圖標題;
            # matplotlib_pyplot.show()  # 顯示圖片;
            # 繪製散點圖;
            axes_1.scatter(
                Xdata,
                YdataMean,  # Ydata,
                s=15,  # 點大小，取 0 表示不顯示;
                c='blue',  # 點顔色;
                edgecolors='blue',  # 邊顔色;
                linewidths=0.25,  # 邊粗細;
                marker='o',  # 點標志;
                alpha=1,  # 點透明度;
                label='observation values'
            )
            # axes_1.plot(Xdata, Yvals, color='red', linewidth=2.0, linestyle='-', label='polyfit values')  # 繪製折綫圖;
            # 繪製平滑折綫圖;
            axes_1.plot(
                Xnew,
                Ynew,
                color='red',
                linewidth=1.0,
                linestyle='-',
                alpha=1,
                label='polyfit values'
            )

            # # 描繪擬合曲綫的置信區間;
            # axes_1.fill_between(
            #     Xnew,
            #     Ynewlower,
            #     Ynewupper,
            #     color='grey',  # 'black',
            #     linestyle=':',
            #     linewidth=0.5,
            #     alpha=0.15,
            # )

            # 設置坐標軸標題
            axes_1.set_xlabel(
                'Independent Variable ( x )',
                fontdict={"family": "Times New Roman", "size": 7},  # "family": "SimSun"
                fontsize='xx-small'
            )
            axes_1.set_ylabel(
                'Dependent Variable ( y )',
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
                str("Interpolation : " + str(Interpolation_Method) + " model"),
                fontdict={"family": "SimSun", "size": 7},
                fontsize='xx-small'
            )

        # # fig.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;
        # matplotlib_pyplot.show()
        # # plot_Thread = threading.Thread(target=matplotlib_pyplot.show, args=(), daemon=False)
        # # plot_Thread.start()
        # # matplotlib_pyplot.savefig('./fit-curve.png', dpi=400, bbox_inches='tight')  # 將圖片保存到硬盤文檔, 參數 bbox_inches='tight' 邊界緊致背景透明;

    # resultDict = {}
    resultDict["testData"] = testData  # 傳入測試數據集的計算結果;
    resultDict["fit-image"] = fig  # 擬合曲綫繪圖;
    # print(resultDict)

    return resultDict


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
