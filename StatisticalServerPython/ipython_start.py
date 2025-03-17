#!/usr/bin/python3
# -*- coding: utf-8 -*-


# /root/.ipython/profile_default/startup/ipython_start.py

# https://jupyter.org/
# https://jupyterlab.readthedocs.io/en/stable/index.html


# import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
# import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
# # import multiprocessing
# # from multiprocessing import Pool
# import math  # 導入 Python 原生包「math」，用於數學計算;
# import random  # 導入 Python 原生包「random」，用於生成隨機數;
# import copy  # 導入 Python 原生包「copy」，用於對字典對象的複製操作（深複製（傳值）、潛複製（傳址））;
# import json  # 導入 Python 原生模組「json」，用於解析 JSON 文檔;
# import csv  # 導入 Python 原生模組「csv」，用於解析 .csv 文檔;
# import pickle  # 導入 Python 原生模組「pickle」，用於將結構化的内存數據直接備份到硬盤二進制文檔，以及從硬盤文檔直接導入結構化内存數據;
# import string  # 加載Python原生的字符串處理模組;
# import time  # 加載Python原生的日期數據處理模組;
# import datetime  # 加載Python原生的日期數據處理模組;
# # import warnings
# # # 棄用控制臺打印警告信息;
# # def fxn():
# #     warnings.warn("deprecated", DeprecationWarning)  # 棄用控制臺打印警告信息;
# # with warnings.catch_warnings():
# #     warnings.simplefilter("ignore")
# #     fxn()
# # with warnings.catch_warnings(record=True) as w:
# #     # Cause all warnings to always be triggered.
# #     warnings.simplefilter("always")
# #     # Trigger a warning.
# #     fxn()
# #     # Verify some things
# #     assert len(w) == 1
# #     assert issubclass(w[-1].category, DeprecationWarning)
# #     assert "deprecated" in str(w[-1].message)


# # https://numpy.org/
# # https://numpy.org/doc/stable/
# import numpy # as np

# # https://pandas.pydata.org/
# # https://pandas.pydata.org/docs/
# import pandas # as pd
# # import pyarrow
# # import openpyxl
# # import xlrd

# # https://matplotlib.org/
# # https://matplotlib.org/stable/users/index
# import matplotlib # as mpl
# # import matplotlib.font_manager as fm
# matplotlib.rcParams['figure.figsize'] = [10, 4]  # 設置圖片預設大小;
# matplotlib.rcParams['axes.grid'] = False  # 設置圖片不顯示網格缐;
# matplotlib.rcParams['font.size'] = 14  # 設置圖片中的字體大小;
# # matplotlib.rcParams['font.sans-serif'] = ['SimHei']  # 指定預設圖片顯示字體爲黑體（"SimHei"），以支持顯示中文字符;
# matplotlib.rcParams['font.family'] = 'DejaVu Sans'  # 指定圖片顯示字體爲文泉驛（fonts-wqy-zenhei）正黑（"DejaVu Sans"）字體，以支持顯示中文字符，需在 Ubuntu 系統預先安裝：root@localhost:~# sudo apt install fonts-wqy-zenhei ，配置成功;
# matplotlib.rcParams['axes.unicode_minus'] = False  # 解決保存圖片負號（"-"）顯示爲亂碼的問題;
# %matplotlib notebook  # 設置在 Jupyter notebook 中自動縮放圖片，以適應輸出顯示;
# %matplotlib inline  # 設置在 Jupyter notebook 中使用交互式（backend）操作;
# # %config InlineBackend.figure_formats = ['svg']  # 指定顯示圖片格式爲了矢量圖（svg）格式，以便於瀏覽器渲染顯示;
# # import matplotlib.pyplot as plt
# # import mplfinance # as mplf  # 導入第三方擴展包「mplfinance」，用於製作日棒缐（K Days Line）圖;
# # from mplfinance.original_flavor import candlestick_ohlc as ohlc  # 從第三方擴展包「mplfinance」中導入「original_flavor」模組的「candlestick_ohlc()」函數，用於繪製股票作日棒缐（K Days Line）圖;
# # import seaborn  # as sns

# # https://www.scipy.org/docs.html
# # import scipy # as sci
# from scipy import ‌io  # 導入第三方擴展包「scipy」中的外設（硬盤等）文檔讀寫模組「‌io」，用於讀寫數據;
# from scipy import stats  # 導入第三方擴展包「scipy」中的基本統計學算法模組「stats」，包括統計分佈函數等，用於統計學計算;
# from scipy import ‌constants  # 導入第三方擴展包「scipy」中的物理和數學常數模組「‌constants」，包括 Π 和 光速（C）等，用於統計學計算;
# from scipy import ‌misc  # 導入第三方擴展包「scipy」中的雜項模組「‌misc」，包括圖像處理和數學常數等，用於統計學計算;
# from scipy import ‌special  # 導入第三方擴展包「scipy」中的特殊函數模組「‌special」，包括貝塞爾函數、伽馬函數等，用於統計學計算;
# from scipy import ‌sparse  # 導入第三方擴展包「scipy」中的稀疏矩陣（sparse matrix）模組「‌sparse」，用於儲存和操作稀疏矩陣（sparse matrix）數據;
# from scipy import ‌linalg  # 導入第三方擴展包「scipy」中的缐性代數運算模組「‌linalg」，用於缐性代數行列式矩陣計算;
# from scipy import ‌fftpack  # 導入第三方擴展包「scipy」中的傅里葉變換（fast Fourier transform ）模組「‌fftpack」，用於快速傅里葉變換（fast Fourier transform ）計算;
# from scipy import ‌integrate  # 導入第三方擴展包「scipy」中的數值積分和常微分方程（ordinary differential equation）模組「‌integrate」，用於數值積分和常微分方程（ordinary differential equation）計算;
# from scipy import ‌interpolate  # 導入第三方擴展包「scipy」中的插值（Interpolation）模組「‌interpolate」，用於插值（Interpolation）計算;
# from scipy import ‌ndimage  # 導入第三方擴展包「scipy」中的圖像處理模組「‌ndimage」，如濾波、插值等，用於操作圖像數據;
# from scipy import ‌ode  # 導入第三方擴展包「scipy」中的求解常微分方程（ordinary differential equation）模組「‌ode」，用於求解常微分方程（ordinary differential equation）計算;
# from scipy import ‌optimize  # 導入第三方擴展包「scipy」中的最優化（‌Optimize）模組「‌optimize」，用於最優化過程（‌Optimize）求解計算;
# from scipy import ‌signal  # 導入第三方擴展包「scipy」中的信號（Communication Signals）處理模組「‌signal」，包括濾波（Wave filtering）、卷積（Convolution）等，用於處理通訊信號（Communication Signals）數據運算;
# from scipy import ‌spatial  # 導入第三方擴展包「scipy」中的空間（Spatial）數據結構和算法模組「‌spatial」，包括：Delaunay 三角剖分、Voronoi 圖分析等，用於處理空間（Spatial）數據;
# # from scipy import stats as scipy_stats  # 導入第三方擴展包「scipy」，用於統計學計算;
# # import scipy.stats as scipy_stats
# # from scipy.optimize import minimize as scipy_optimize_minimize  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「minimize()」函數，用於通用形式優化問題求解（optimization）;
# # from scipy.optimize import curve_fit as scipy_optimize_curve_fit  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「curve_fit()」函數，用於擬合自定義函數;
# # from scipy.optimize import root as scipy_optimize_root  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「root()」函數，用於一元方程求根計算;
# # from scipy.optimize import fsolve as scipy_optimize_fsolve  # 導入第三方擴展包「scipy」中的優化模組「optimize」中的「fsolve()」函數，用於多元非缐性方程組求根計算;
# # from scipy.interpolate import make_interp_spline as scipy_interpolate_make_interp_spline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「make_interp_spline()」函數，用於擬合鏈條插值（Spline）函數;
# # from scipy.interpolate import BSpline as scipy_interpolate_BSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「BSpline()」函數，用於擬合一維鏈條插值（1 Dimension BSpline）函數;
# # from scipy.interpolate import interp1d as scipy_interpolate_interp1d  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「interp1d()」函數，用於擬合一維插值（1 Dimension）函數;
# # from scipy.interpolate import UnivariateSpline as scipy_interpolate_UnivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「UnivariateSpline()」函數，用於擬合一維鏈條插值（1 Dimension spline）函數;
# # from scipy.interpolate import lagrange as scipy_interpolate_lagrange  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「lagrange()」函數，用於擬合一維拉格朗日法（lagrange）插值（1 Dimension）函數;
# # from scipy.interpolate import RectBivariateSpline as scipy_interpolate_RectBivariateSpline  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「RectBivariateSpline()」函數，用於擬合二維鏈條插值（2 Dimension BSpline）函數;
# # from scipy.interpolate import griddata as scipy_interpolate_griddata  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「griddata()」函數，用於擬合二多維非結構化插值（2 Dimension）函數;
# # from scipy.interpolate import Rbf as scipy_interpolate_Rbf  # 導入第三方擴展包「scipy」中的插值模組「interpolate」中的「Rbf()」函數，用於擬合多維非結構化插值（n Dimension）函數;
# # from scipy.misc import derivative as scipy_derivative_derivative  # 導入第三方擴展包「scipy」中的數值微分計算模組「misc」中的「derivative()」函數，用於一元方程（一維）（1 Dimension）微分計算;
# # from scipy.derivative import derivative as scipy_derivative_derivative  # 導入第三方擴展包「scipy」中的數值微分計算模組「derivative」中的「derivative()」函數，用於一元方程（一維）（1 Dimension）微分計算;
# # from scipy.integrate import quad as scipy_integrate_quad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「quad()」函數，用於一元方程（一維）（1 Dimension）定積分計算;
# # from scipy.integrate import dblquad as scipy_integrate_dblquad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「dblquad()」函數，用於二元方程（二維）（2 Dimension）定積分計算;
# # from scipy.integrate import tplquad as scipy_integrate_tplquad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「tplquad()」函數，用於三元方程（三維）（3 Dimension）定積分計算;
# # from scipy.integrate import nquad as scipy_integrate_nquad  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「nquad()」函數，用於多元方程（多維）（n Dimension）定積分計算;
# # from scipy.integrate import odeint as scipy_integrate_odeint  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「odeint()」函數，用於求解常微分方程（Ordinary Differential Equation）;
# # from scipy.integrate import ode as scipy_integrate_ode  # 導入第三方擴展包「scipy」中的數值積分計算模組「integrate」中的「ode()」函數，用於求解常微分方程（大系統、複雜系統）（Ordinary Differential Equation）;
# # from scipy.linalg import solve as scipy_linalg_solve  # 導入第三方擴展包「scipy」中的缐性代數模組「linalg」中的「solve()」函數，用於求解矩陣（matrix）乘、除法（multiplication, division）（求解缐性方程組）計算;
# # from scipy.linalg import inv as scipy_linalg_inv  # 導入第三方擴展包「scipy」中的缐性代數模組「linalg」中的「inv()」函數，用於求解矩陣（matrix）的逆（Inverse matrix）計算;

# # https://scikit-learn.org/stable/
# # https://scikit-learn.org/stable/user_guide.html
# # https://www.scikitlearn.com.cn/
# # import sklearn # as skl
# from xgboost import XGBClassifier
# from sklearn.preprocessing import OneHotEncoder, LabelEncoder
# from sklearn import feature_selection
# from sklearn import model_selection
# from sklearn import neightbors  # 導入第三方擴展包「sklearn」中的最近鄰模型算法庫「neightbors」模組，用於最近鄰（Nearest Neighbor model）模型擬合;
# from sklearn import linear_model  # 導入第三方擴展包「sklearn」中的缐性模型算法庫「linear_model」模組，用於擬合缐性模型模型，包括缐性回歸算法、Logistics 回歸算法、嶺回歸（LASSO）算法等;
# from sklearn import naive_bayes  # 導入第三方擴展包「sklearn」中的樸素貝葉斯模型算法庫「naive_bayes」模組，用於貝葉斯（bayes）模型擬合;
# from sklearn import tree  # 導入第三方擴展包「sklearn」中的決策樹模型算法庫「tree」模組，用於決策樹（Decision Tree）模型擬合;
# from sklearn import ensemble  # 導入第三方擴展包「sklearn」中的隨機森林模型算法庫「ensemble」模組，用於隨機森林（Random Forest）模型擬合;
# from sklearn import svm  # 導入第三方擴展包「sklearn」中的支持向量機模型算法庫「svm」模組，用於支持向量機（Support Vector Machine）模型擬合;
# from sklearn import neural_network  # 導入第三方擴展包「sklearn」中的神經網絡模型算法庫「neural_network」模組，用於神經網絡（Neural Network model）模型擬合;
# from sklearn import cluster  # 導入第三方擴展包「sklearn」中的聚類模型算法庫「cluster」模組，用於聚類（Cluster）模型擬合;
# from sklearn import discriminant_analysis  # 導入第三方擴展包「sklearn」中的判別分析模型算法庫「discriminant_analysis」模組，用於判別分析（Discriminant analysis）模型擬合;
# from sklearn import gaussian_process  # 導入第三方擴展包「sklearn」中的高斯過程算法庫「gaussian_process」模組，用於處理高斯過程（Gaussian Process）模型數據;

# # https://www.statsmodels.org/stable/index.html
# import statsmodels # as sm
# # import statsmodels.api as statsmodels_api  # 導入第三方擴展包「statsmodels」中的「api()」函數，用於模型方程式擬合自定義函數;
# # import statsmodels.formula.api as statsmodels_formula_api  # 導入第三方擴展包「statsmodels」中的公式模組「formula」中的「api()」函數，用於模型方程式擬合;
# # from statsmodels.tsa.arima_model import ARIMA as statsmodels_tsa_arima_model_ARIMA  # 導入第三方擴展包「statsmodels」中的時間序列（Time Series）分析模組「tsa」中的自回歸差分移動平均模型模組「arima_model」中的「ARIMA()」函數，用於擬合自回歸移動平均模型（ARIMA）;
# # from statsmodels.tsa.seasonal import seasonal_decompose as statsmodels_tsa_seasonal_seasonal_decompose  # 導入第三方擴展包「statsmodels」中的時間序列（Time Series）分析模組「tsa」中的自回歸差分移動平均模型模組「seasonal」中的「seasonal_decompose()」函數，用於擬合自回歸移動平均模型（ARIMA）;

# # https://docs.sympy.org/latest/tutorial/preliminaries.html#installation
# import sympy # as sym  # 導入第三方擴展包「sympy」，用於符號計算;

# # https://factor-analyzer.readthedocs.io/en/latest/index.html
# # import factor_analyzer as fa  # 導入第三方擴展包「factor_analyzer」，用於做因子分析計算;
# from factor_analyzer import FactorAnalyzer
# from factor_analyzer import (ConfirmatoryFactorAnalyzer, ModelSpecificationParser)
# from factor_analyzer import FactorAnalyzer, Rotator

# # https://dateutil.readthedocs.io/en/latest/
# # https://github.com/dateutil/dateutil
# # 先升級 pip 擴展包管理工具：root@localhost:~# python -m pip install --upgrade pip
# # 再安裝第三方擴展包：root@localhost:~# pip install python-dateutil -i https://pypi.mirrors.ustc.edu.cn/simple
# from dateutil.relativedelta import relativedelta as dateutil_relativedelta_relativedelta    # 從第三方擴展包「dateutil」中導入「relativedelta」模組中的「relativedelta()」函數，用於處理日期數據加減量，需要事先安裝：pip install python-dateutil 配置成功;
# from dateutil.parser import parse as dateutil_parser_parse  # 從第三方擴展包「dateutil」中導入「parser」模組中的「parse()」函數，用於格式化日期數據，需要事先安裝：pip install python-dateutil 配置成功;

# # https://alkaline-ml.com/pmdarima/
# # https://github.com/alkaline-ml/pmdarima
# from pmdarima.arima import auto_arima as arima  # 導入第三方擴展包「pmdarima」中的自回歸差分移動平均模型模組「arima」中的「auto_arima()」函數，用於自動擬合含有季節周期的時間序列（Time Series）模型預測分析;


# # 匯入自定義路由模組脚本文檔「./Router.py」;
# # os.getcwd() # 獲取當前工作目錄路徑;
# # os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# # os.path.join(os.path.abspath("."), 'Router.py')  # 拼接路徑字符串;
# # pathlib.Path(os.path.join(os.path.abspath("."), Router.py)  # 返回路徑對象;
# # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# import Router as Router  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Router.py」;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
# do_data = Router.do_data
# do_Request = Router.do_Request
# do_Response = Router.do_Response

# # 匯入自定義統計描述模組脚本文檔「./Statis_Descript.py」;
# # # sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
# # 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」;
# from Statis_Descript import Transformation as Transformation  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的數據歸一化、數據變換函數「Transformation()」，用於將原始數據歸一化處理;
# from Statis_Descript import outliers_clean as outliers_clean  # 導入自定義 Python 脚本文檔「./Statis_Descript.py」中的離群值檢查（含有粗大誤差的數據）函數「outliers_clean()」，用於檢查原始數據歸中的離群值;
