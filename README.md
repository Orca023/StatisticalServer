## 統計計算服務器 StatisticalServer : StatisticalServerJulia , StatisticalServerPython
#### Julia, Python
#### 使用「Criss」倉庫（repositories）「Interface.jl」和「Interface.py」模組（module），搭建可擴展的統計計算服務器框架（scalable statistical calculation server frame），借用第三方擴展模組（third-party extensions ( libraries or modules )），分別使用 Julia 和 Python 程式設計語言（computer programming language）各自獨立實現的竝立兩套方案算法（algorithm）.
---
<p word-wrap: break-word; word-break: break-all; overflow-x: hidden; overflow-x: hidden;>
一. 其中 StatisticalServerJulia 項目，使用 Julia 程式設計語言（computer programming language），借用第三方擴展模組（third-party extensions ( libraries or modules )）：「HTTP.jl」「JSON.jl」「LsqFit.jl」「Interpolations.jl」「DataInterpolations.jl」「Roots.jl」實現.

1. 借用「HTTP.jl」模組，實現 http 協議 web 服務器（server）功能.

2. 借用「JSON.jl」模組，實現 Julia 原生數據類型字典（Base.Dict）對象（Object）與 JSON 字符串（String）對象之間，相互轉換數據類型.

3. 借用「LsqFit.jl」模組，實現任意形式自定義初等函數方程擬合（Fit）運算.

4. 借用「Interpolations.jl」和「DataInterpolations.jl」模組，實現插值（Interpolation）運算.

5. 借用「Roots.jl」模組，實現任意形式自定義初等函數一元方程求根（Solving Equation），即求解反函數（Inverse）.

二. 使用外設網卡 ( Network Interface Card ) 作橋 ( Intermediary ), 創建監聽伺服器 ( http_Server ), 創建用戶端鏈接器 ( http_Client ), 伺服器 ( http_Server ) 監聽指定網卡 ( Network Interface Card ) 的自定義的埠 ( Port ), 從指定的埠號讀取用戶端 ( http_Client ) 發送的請求數據 ( required ), 經過運算 ( Data Processing ), 將運算結果 ( Response ) 回饋至對應發送請求的用戶端 ( http_Client ), 從而完成一次跨語言 ( Cross Language ) 的數據交換 ( Information exchange ).
</p>

---

一. Interface :

代碼脚本 ( Script ) 檔 : Interface 是伺服器 ( Server ) 函數 ( Function ) , 具體功能是實現: 讀入 ( read ) 數據, 寫出 ( write ) 結果.

二. application

代碼脚本 ( Script ) 檔 : application 引用 ( Import ) 檔 Interface 裏的伺服器 ( Server ) 讀入 ( read ) 待處理的原始數據, 然後, 實現數據分發路由 ( Router ) 功能, 可通過修改檔 application 裏的 : do_data 和 do_Request 兩個函數 ( Function ) , 實現自定義規則的數據分發運算處理並返回 ( return ) 運算結果, 然後再將運算結果, 通過引用 ( Import ) 檔 Interface 裏的伺服器 ( Server ) 回饋寫出 ( write ) 結果.

其中, 檔 application 裏的 : do_data 函數 ( Function ) 是執行文檔 ( file ) 監聽伺服器 ( file_Monitor ) 讀入的數據分發路由 ( Router ) 功能.

其中, 檔 application 裏的 : do_Request 函數 ( Function ) 是執行網路 ( web ) 伺服器 ( http_Server ) 讀入的從用戶端 ( http_Client ) 發送的請求 ( Request ) 數據的分發路由 ( Router ) 功能.

其中, 檔 application 裏的 : do_Response 函數 ( Function ) 是執行網路 ( web ) 用戶端鏈接器 ( http_Client ) 接收到從伺服器 ( http_Server ) 回饋的響應 ( Response ) 數據 ( 運算處理結果 ) 的分發路由 ( Router ) 功能.

可在檔 application 裏創建, 自定義運算規則的函數 ( Function ) 用以執行讀入 ( read ) 數據具體的運算處理 ( calculator ) 功能並返回 ( return ) 處理結果, 也可以在檔 application 之外增設新的代碼脚本 ( Script ) 檔, 在新的代碼脚本 ( Script ) 檔裏創建自定義運算規則的函數 ( Function ) 並返回處理結果, 然後再由檔 application 引用 ( Import ) 新增設的代碼脚本 ( Script ) 檔裏的函數 ( Function ) 以實現讀入 ( read ) 數據具體的運算處理 ( calculator ) 功能並返回 ( return ) 處理結果.

![]()

---

Operating System :

Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

Acer-NEO-2023 Linux-Ubuntu-22.04 x86_64 Inter(R)-Core(TM)-m3-6Y30

Google-Pixel-6 Android-11 Termux-0.118 Linux-Ubuntu-22.04-LTS-rootfs Arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280

---

Node.js : Interface.js, application.js

計算機程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 與作業系統 ( Operating System ) 環境配置釋明 :

Title: Node.js server v20161211

Explain: Node.js file server, Node.js http server, Node.js http client

Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

Interpreter: node-v20.15.0-x64.msi, node-v20.15.0-x86.msi

Interpreter: node-v20.15.0-linux-x64.tar.gz

Operating System: Google-Pixel-7 Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280

Interpreter: node-v20.15.0-linux-arm64.tar.gz

使用説明:

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 )

控制臺命令列 ( bash ) 運行啓動指令 :

root@localhost:~# /usr/bin/node /home/Criss/js/application.js configFile=/home/Criss/js/config.txt interface_Function=file_Monitor webPath=/home/Criss/html/ host=::0 port=10001 Key=username:password number_cluster_Workers=0 is_monitor=false delay=20 monitor_dir=/home/Criss/Intermediary/ monitor_file=C:/home/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt temp_cache_IO_data_dir=/home/Criss/temp/

微軟視窗系統 ( Window10 x86_64 )

控制臺命令列 ( cmd ) 運行啓動指令 :

C:\Criss> C:/Criss/NodeJS/Nodejs-20.15.0/node.exe C:/Criss/js/application.js configFile=C:/Criss/js/config.txt interface_Function=file_Monitor webPath=C:/Criss/html/ host=::0 port=10001 Key=username:password number_cluster_Workers=0 is_monitor=false delay=20 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt temp_cache_IO_data_dir=C:/Criss/temp/

控制臺啓動傳參釋意, 各參數之間以一個空格字符 ( SPACE ) ( 00100000 ) 分隔, 鍵(Key) ~ 值(Value) 之間以一個等號字符 ( = ) 連接, 即類比 Key=Value 的形式 :

1. (必), (自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名, 預設值爲 :  C:/Criss/NodeJS/Nodejs-20.15.0/node.exe

2. (必), (自定義), 語言 ( JavaScript ) 程式代碼脚本 ( Script ) 檔 ( application.js ) 的存儲路徑全名, 預設值爲 :  C:/Criss/js/application.js

   注意, 因爲「application.js」檔中脚本代碼需要加載引入「Interface.js」檔, 所以需要保持「application.js」檔與「Interface.js」檔在相同目錄下, 不然就需要手動修改「application.js」檔中有關引用「Interface.js」檔的加載路徑代碼, 以確保能正確引入「Interface.js」檔.

3. (選), (鍵 configFile 固定, 值 C:/Criss/js/config.txt 自定義), 用於傳入配置文檔的保存路徑全名, 預設值爲 :  configFile=C:/Criss/js/config.txt

4. (選), (鍵 interface_Function 固定, 值 file_Monitor 自定義, [ file_Monitor, http_Server, http_Client ] 取其一), 用於傳入選擇啓動哪一種接口服務, 外設硬盤 ( Hard Disk ) 文檔 ( File ) 作橋, 外設網卡 ( Network Interface Card ) 埠 ( Port ) 作橋, 預設值爲 :  interface_Function=file_Monitor

以下是當參數 : interface_Function 取 : file_Monitor 值時, 可在控制臺命令列傳入的參數 :

5. (選), (鍵 is_monitor 固定, 值 false 自定義, [ true, false ] 取其一), 用於判斷只運行一次, 還是保持文檔監聽, 預設值爲 :  is_monitor=false

6. (選), (鍵 delay 固定, 值 20 自定義), 用於傳入監聽文檔輪詢延遲時長，單位 ( Unit ) 爲毫秒 ( MilliSecond ), 預設值爲 :  delay=20

7. (選), (鍵 number_Worker_threads 固定, 值 0 自定義), 用於傳入創建子進程 ( Sub Process ) 數目, 用於執行數據運算的 Node.js 集群 ( Cluster ) 進程 ( Process ), 即工作進程 ( Worker Process ), 可以設爲等於物理中央處理器 ( Central Processing Unit ) 的數目, 取 0 值表示不開啓多進程集群, 預設值爲 :  number_Worker_threads=0

8. (選), (鍵 monitor_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 用於接收傳值的媒介目錄 ( 監聽文件夾 ) 存儲路徑全名, 預設值爲 :  monitor_dir=C:/Criss/Intermediary/

9. (選), (鍵 monitor_file 固定, 值 C:/Criss/Intermediary/intermediary_write_C.txt 自定義), 用於接收傳值的媒介文檔 ( 監聽文檔 ) 存儲路徑全名, 預設值爲 :  monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt

10. (選), (鍵 output_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 用於輸出運算結果傳值的媒介目錄 ( 運算結果文檔儲存文件夾 ) 存儲路徑全名, 預設值爲 :  output_dir=C:/Criss/Intermediary/

11. (選), (鍵 output_file 固定, 值 C:/Criss/Intermediary/intermediary_write_Nodejs.txt 自定義), 用於輸出運算結果傳值的媒介文檔 ( 運算結果輸出保存文檔 ) 存儲路徑全名, 預設值爲 :  output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt

12. (選), (鍵 temp_cache_IO_data_dir 固定, 值 C:/Criss/temp/ 自定義), 用於暫存傳入傳出數據的臨時媒介文件夾路徑全名, 預設值爲 :  temp_cache_IO_data_dir=C:/Criss/temp/

以下是當參數 : interface_Function 取 : http_Server 值時, 可在控制臺命令列傳入的參數 :

13. (選), (鍵 host 固定, 值 ::0 自定義, 例如 [ ::0, ::1, 0.0.0.0, 127.0.0.1, localhost ] 取其一), 用於傳入伺服器 ( http_Server ) 監聽的外設網卡 ( Network Interface Card ) 地址 ( IPv6, IPv4 ) 或域名, 預設值爲 :  host=::0

14. (選), (鍵 port 固定, 值 10001 自定義), 用於傳入伺服器 ( http_Server ) 監聽的外設網卡 ( Network Interface Card ) 自定義設定的埠號 ( 1 ~ 65535 ), 預設值爲 :  port=10001

15. (選), (鍵 Key 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 用於傳入自定義的訪問網站驗證 ( Authorization ) 用戶名和密碼, 預設值爲 :  Key=username:password

16. (選), (鍵 number_cluster_Workers 固定, 值 0 自定義), 用於傳入創建子進程 ( Sub Process ) 數目, 用於傳入執行數據運算的 Node.js 集群 ( Cluster ) 進程 ( Process ), 即工作進程 ( Worker Process ), 可以設爲等於物理中央處理器 ( Central Processing Unit ) 的數目, 取 0 值表示不開啓多進程集群, 預設值爲 :  number_cluster_Workers=0

17. (選), (鍵 webPath 固定, 值 C:/Criss/html/ 自定義), 用於傳入伺服器 ( http_Server ) 啓動運行的自定義的根目錄 (項目空間) 路徑全名, 預設值爲 :  webPath=C:/Criss/html/

以下是當參數 : interface_Function 取 : http_Client 值時, 可在控制臺命令列傳入的參數 :

13. (選), (鍵 host 固定, 值 ::1 自定義, 例如 [ ::1, 127.0.0.1, localhost ] 取其一), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的地址 ( IPv6, IPv4 ) 或域名, 預設值爲 :  host=::1

14. (選), (鍵 port 固定, 值 10001 自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的埠號 ( 1 ~ 65535 ), 預設值爲 :  port=10001

18. (選), (鍵 URL 固定, 值 / 自定義, 例如配置爲 http://[::1]:10001/index.html 值), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的地址, 萬維網統一資源定位系統 ( Uniform Resource Locator ) 地址字符串, 預設值爲 :  URL=/

19. (選), (鍵 Method 固定, 值 POST 自定義, 例如 [ POST, GET ] 取其一), 用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的類型, 預設值爲 :  Method=POST

20. (選), (鍵 time_out 固定, 值 1000 自定義), 用於傳入設置鏈接超時自動中斷的時長，單位 ( Unit ) 爲毫秒 ( MilliSecond ), 預設值爲 :  time_out=1000

21. (選), (鍵 request_Auth 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的驗證 ( Authorization ) 的賬號密碼字符串, 預設值爲 :  request_Auth=username:password

22. (選), (鍵 request_Cookie 固定, 其中 Cookie 名稱 Session_ID 可以設計爲固定, Cookie 值 request_Key->username:password 可以設計爲自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的 Cookies 值字符串, 預設值爲 :  request_Cookie=Session_ID=request_Key->username:password

![]()

Interpreter :

node - v20.15.0

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方網站](https://node.js.org/): 
https://node.js.org/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方網站](https://nodejs.org/en/): 
https://nodejs.org/en/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方下載頁](https://nodejs.org/en/download/package-manager): 
https://nodejs.org/en/download/package-manager

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方 GitHub 網站賬戶](https://github.com/nodejs): 
https://github.com/nodejs

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方 GitHub 網站倉庫](https://github.com/nodejs/node): 
https://github.com/nodejs/node.git

---

Python : Interface.py, application.py

計算機程式設計語言 ( Python ) 解釋器 ( Interpreter ) 與作業系統 ( Operating System ) 環境配置釋明 :

Title: Python server v20161211

Explain: Python file server, Python http server, Python http client

Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

Interpreter: python-3.12.4-amd64.exe

Interpreter: Python-3.12.4-tar.xz

Operating System: Google-Pixel-7 Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280

Interpreter: Python-3.12.4-tar.xz

使用説明:

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 )

控制臺命令列 ( bash ) 運行啓動指令 :

root@localhost:~# /usr/bin/python3 /home/Criss/py/application.py configFile=/home/Criss/py/config.txt interface_Function=file_Monitor webPath=/home/Criss/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=Multi-Threading is_monitor=False time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/Criss/temp/

微軟視窗系統 ( Window10 x86_64 )

控制臺命令列 ( cmd ) 運行啓動指令 :

C:\Criss> C:/Criss/Python/Python-3.12.4/python.exe C:/Criss/py/application.py configFile=C:/Criss/py/config.txt interface_Function=file_Monitor webPath=C:/Criss/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=Multi-Threading is_monitor=False time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=C:/Criss/temp/

控制臺啓動傳參釋意, 各參數之間以一個空格字符 ( SPACE ) ( 00100000 ) 分隔, 鍵(Key) ~ 值(Value) 之間以一個等號字符 ( = ) 連接, 即類比 Key=Value 的形式 :

1. (必), (自定義), 安裝配置的程式設計語言 ( Python ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名, 預設值爲 :  C:/Criss/Python/Python-3.12.4/python.exe

2. (必), (自定義), 語言 ( Python ) 程式代碼脚本 ( Script ) 檔 ( application.py ) 的存儲路徑全名, 預設值爲 :  C:/Criss/py/application.py

   注意, 因爲「application.py」檔中脚本代碼需要加載引入「Interface.py」檔, 所以需要保持「application.py」檔與「Interface.py」檔在相同目錄下, 不然就需要手動修改「application.py」檔中有關引用「Interface.py」檔的加載路徑代碼, 以確保能正確引入「Interface.py」檔.

3. (選), (鍵 configFile 固定, 值 C:/Criss/py/config.txt 自定義), 用於傳入配置文檔的保存路徑全名, 預設值爲 :  configFile=C:/Criss/py/config.txt

4. (選), (鍵 interface_Function 固定, 值 file_Monitor 自定義, [ file_Monitor, http_Server, http_Client ] 取其一), 用於傳入選擇啓動哪一種接口服務, 外設硬盤 ( Hard Disk ) 文檔 ( File ) 作橋, 外設網卡 ( Network Interface Card ) 埠 ( Port ) 作橋, 預設值爲 :  interface_Function=file_Monitor

以下是當參數 : interface_Function 取 : file_Monitor 值時, 可在控制臺命令列傳入的參數 :

5. (選), (鍵 is_monitor 固定, 值 False 自定義, [ True, False ] 取其一), 用於判斷只運行一次, 還是保持文檔監聽, 預設值爲 :  is_monitor=False

6. (選), (鍵 time_sleep 固定, 值 0.02 自定義), 用於傳入監聽文檔輪詢延遲時長，單位 ( Unit ) 爲秒 ( Second ), 預設值爲 :  time_sleep=0.02

7. (選), (鍵 number_Worker_process 固定, 值 0 自定義), 用於傳入創建並發數目, 子進程 ( Sub Process ) 並發, 或者, 子缐程 ( Sub Threading ) 並發, 即, 可以設爲等於物理中央處理器 ( Central Processing Unit ) 的數目, 取 0 值表示不開啓並發架構, 預設值爲 :  number_Worker_process=0

8. (選), (鍵 is_Monitor_Concurrent 固定, 值 Multi-Threading 自定義, 例如 [ 0, Multi-Threading, Multi-Processes ] 取其一), 用於選擇並發種類, 多進程 ( Process ) 並發, 或者, 多缐程 ( Threading ) 並發, 取 0 值表示不開啓並發架構, 預設值爲 :  is_Monitor_Concurrent=0

9. (選), (鍵 monitor_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 用於接收傳值的媒介目錄 ( 監聽文件夾 ) 存儲路徑全名, 預設值爲 :  monitor_dir=C:/Criss/Intermediary/

10. (選), (鍵 monitor_file 固定, 值 C:/Criss/Intermediary/intermediary_write_C.txt 自定義), 用於接收傳值的媒介文檔 ( 監聽文檔 ) 存儲路徑全名, 預設值爲 :  monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt

11. (選), (鍵 output_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 用於輸出運算結果傳值的媒介目錄 ( 運算結果文檔儲存文件夾 ) 存儲路徑全名, 預設值爲 :  output_dir=C:/Criss/Intermediary/

12. (選), (鍵 output_file 固定, 值 C:/Criss/Intermediary/intermediary_write_Nodejs.txt 自定義), 用於輸出運算結果傳值的媒介文檔 ( 運算結果輸出保存文檔 ) 存儲路徑全名, 預設值爲 :  output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt

13. (選), (鍵 temp_cache_IO_data_dir 固定, 值 C:/Criss/temp/ 自定義), 用於暫存傳入傳出數據的臨時媒介文件夾路徑全名, 預設值爲 :  temp_cache_IO_data_dir=C:/Criss/temp/

以下是當參數 : interface_Function 取 : http_Server 值時, 可在控制臺命令列傳入的參數 :

14. (選), (鍵 host 固定, 值 ::0 自定義, 例如 [ ::0, ::1, 0.0.0.0, 127.0.0.1 ] 取其一), 用於傳入伺服器 ( http_Server ) 監聽的外設網卡 ( Network Interface Card ) 地址 ( IPv6, IPv4 ) 或域名, 預設值爲 :  host=::0

15. (選), (鍵 port 固定, 值 10001 自定義), 用於傳入伺服器 ( http_Server ) 監聽的外設網卡 ( Network Interface Card ) 自定義設定的埠號 ( 1 ~ 65535 ), 預設值爲 :  port=10001

16. (選), (鍵 Key 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 用於傳入自定義的訪問網站驗證 ( Authorization ) 用戶名和密碼, 預設值爲 :  Key=username:password

17. (選), (鍵 Is_multi_thread 固定, 值 False 自定義, 例如 [ True, False ] 取其一), 用於判斷是否開啓多缐程 ( Threading ) 並發, 預設值爲 :  Is_multi_thread=False

18. (選), (鍵 number_Worker_process 固定, 值 0 自定義), 用於傳入創建並發數目, 子進程 ( Sub Process ) 並發, 或者, 子缐程 ( Sub Threading ) 並發, 即, 可以設爲等於物理中央處理器 ( Central Processing Unit ) 的數目, 取 0 值表示不開啓並發架構, 預設值爲 :  number_Worker_process=0

19. (選), (鍵 webPath 固定, 值 C:/Criss/html/ 自定義), 用於傳入伺服器 ( http_Server ) 啓動運行的自定義的根目錄 (項目空間) 路徑全名, 預設值爲 :  webPath=C:/Criss/html/

以下是當參數 : interface_Function 取 : http_Client 值時, 可在控制臺命令列傳入的參數 :

14. (選), (鍵 host 固定, 值 ::1 自定義, 例如 [ ::1, 127.0.0.1, localhost ] 取其一), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的地址 ( IPv6, IPv4 ) 或域名, 預設值爲 :  host=::1

15. (選), (鍵 port 固定, 值 10001 自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的埠號 ( 1 ~ 65535 ), 預設值爲 :  port=10001

20. (選), (鍵 URL 固定, 值 / 自定義, 例如配置爲 http://[::1]:10001/index.html 值), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的地址, 萬維網統一資源定位系統 ( Uniform Resource Locator ) 地址字符串, 預設值爲 :  URL=/

21. (選), (鍵 Method 固定, 值 POST 自定義, 例如 [ POST, GET ] 取其一), 用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的類型, 預設值爲 :  Method=POST

22. (選), (鍵 time_out 固定, 值 0.5 自定義), 用於傳入設置鏈接超時自動中斷的時長，單位 ( Unit ) 爲秒 ( Second ), 預設值爲 :  time_out=0.5

23. (選), (鍵 request_Auth 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的驗證 ( Authorization ) 的賬號密碼字符串, 預設值爲 :  request_Auth=username:password

24. (選), (鍵 request_Cookie 固定, 其中 Cookie 名稱 Session_ID 可以設計爲固定, Cookie 值 request_Key->username:password 可以設計爲自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的 Cookies 值字符串, 預設值爲 :  request_Cookie=Session_ID=request_Key->username:password

![]()

Interpreter :

python - 3.12.4

[程式設計 Python 語言解釋器 ( Interpreter ) 官方網站](https://www.python.org/): 
https://www.python.org/

[程式設計 Python 語言解釋器 ( Interpreter ) 官方下載頁](https://www.python.org/downloads/): 
https://www.python.org/downloads/

[程式設計 Python 語言解釋器 ( Interpreter ) 官方 GitHub 網站賬戶](https://github.com/python): 
https://github.com/python

[程式設計 Python 語言解釋器 ( Interpreter ) 官方 GitHub 網站倉庫](https://github.com/python/cpython): 
https://github.com/python/cpython.git

---

Julia : Interface.jl, application.jl

計算機程式設計語言 ( Julia ) 解釋器 ( Interpreter ) 與作業系統 ( Operating System ) 環境配置釋明 :

Title: Julia server v20161211

Explain: Julia file server, Julia http server, Julia http client

Operating System: Acer-NEO-2023 Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

Interpreter: julia-1.10.4-win64.exe

Interpreter: julia-1.10.4-linux-x86_64.tar.gz

Operating System: Google-Pixel-7 Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280

Interpreter: julia-1.10.4-linux-aarch64.tar.gz

注意,

程式代碼脚本檔 Interface.jl 裏, 函數 http_Server, http_Client 使用了第三方模組 HTTP.jl , JSON.jl 擴展包 ( packages ),

程式代碼脚本檔 application.jl 裏, 函數 do_data, do_Request, do_Response 使用了第三方模組 JSON.jl 擴展包 ( packages ),

所以, 需事先安裝配置成功, 加載導入之後, 才能正常運行.

首先在作業系統 ( Operating System ) 控制臺命令列窗口 ( bash, cmd ) 啓動程式設計語言 ( Julia ) 解釋器 ( Interpreter ) 進入語言 ( Julia ) 的運行環境 :

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 ) 控制臺命令列 ( bash ) 運行啓動指令 :

root@localhost:~# /usr/julia/julia-1.10.4/bin/julia --project=/home/Criss/jl/

微軟視窗系統 ( Window10 x86_64 ) 控制臺命令列 ( cmd ) 運行啓動指令 :

C:\Criss> C:/Criss/Julia/Julia-1.10.4/bin/julia.exe --project=C:/Criss/jl/

然後, 在程式設計語言 ( Julia ) 解釋器 ( Interpreter ) 運行環境下, 安裝配置第三方擴展包 ( packages ) :

程式設計語言 ( Julia ) 的第三方擴展模組 HTTP.jl 安裝配置説明 :

julia> using Pkg

julia> Pkg.add("HTTP")

程式設計語言 ( Julia ) 的第三方擴展模組 HTTP.jl 加載導入説明 :

julia> using HTTP

程式設計語言 ( Julia ) 的第三方擴展模組 JSON.jl 安裝配置説明 :

julia> using Pkg

julia> Pkg.add("JSON")

程式設計語言 ( Julia ) 的第三方擴展模組 JSON.jl 加載導入説明 :

julia> using JSON

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方擴展模組 ( module ) ( packages ) 托管網站官方手冊](https://julialang.org/packages/): 
https://julialang.org/packages/

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 General.jl 模組 GitHub 網站倉庫](https://github.com/JuliaRegistries/General): 
https://github.com/JuliaRegistries/General.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方擴展模組 HTTP.jl 的官方 GitHub 網站倉庫](https://github.com/JuliaWeb/HTTP.jl): 
https://github.com/JuliaWeb/HTTP.jl.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方擴展模組 JSON.jl 的官方 GitHub 網站倉庫](https://github.com/JuliaIO/JSON.jl): 
https://github.com/JuliaIO/JSON.jl.git

使用説明:

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 )

控制臺命令列 ( bash ) 運行啓動指令 :

root@localhost:~# /usr/julia/julia-1.10.4/bin/julia -p 4 --project=/home/Criss/jl/ /home/Criss/jl/application.jl configFile=/home/Criss/jl/config.txt interface_Function=file_Monitor webPath=/home/Criss/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks readtimeout=0 connecttimeout=0 is_monitor=false isDoTasksOrThreads=Tasks isMonitorThreadsOrProcesses=0 time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/Criss/temp/

微軟視窗系統 ( Window10 x86_64 )

控制臺命令列 ( cmd ) 運行啓動指令 :

C:\Criss> C:/Criss/Julia/Julia-1.10.4/bin/julia.exe -p 4 --project=C:/Criss/jl/ C:/Criss/jl/application.jl configFile=C:/Criss/jl/config.txt interface_Function=file_Monitor webPath=C:/Criss/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks readtimeout=0 connecttimeout=0 is_monitor=false isDoTasksOrThreads=Tasks isMonitorThreadsOrProcesses=0 time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/Criss/temp/

控制臺啓動傳參釋意, 各參數之間以一個空格字符 ( SPACE ) ( 00100000 ) 分隔, 鍵(Key) ~ 值(Value) 之間以一個等號字符 ( = ) 連接, 即類比 Key=Value 的形式 :

1. (必), (自定義), 安裝配置的程式設計語言 ( Julia ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名, 預設值爲 :  C:/Criss/Julia/Julia-1.10.4/bin/julia.exe

2. (必), (自定義), 語言 ( Julia ) 程式代碼脚本 ( Script ) 檔 ( application.jl ) 的存儲路徑全名, 預設值爲 :  C:/Criss/jl/application.jl

   注意, 因爲「application.jl」檔中脚本代碼需要加載引入「Interface.jl」檔, 所以需要保持「application.jl」檔與「Interface.jl」檔在相同目錄下, 不然就需要手動修改「application.jl」檔中有關引用「Interface.jl」檔的加載路徑代碼, 以確保能正確引入「Interface.jl」檔.

3. (選), (鍵 configFile 固定, 值 C:/Criss/jl/config.txt 自定義), 用於傳入配置文檔的保存路徑全名, 預設值爲 :  configFile=C:/Criss/jl/config.txt

4. (選), (鍵 interface_Function 固定, 值 file_Monitor 自定義, [ file_Monitor, http_Server, http_Client ] 取其一), 用於傳入選擇啓動哪一種接口服務, 外設硬盤 ( Hard Disk ) 文檔 ( File ) 作橋, 外設網卡 ( Network Interface Card ) 埠 ( Port ) 作橋, 預設值爲 :  interface_Function=file_Monitor

以下是當參數 : interface_Function 取 : file_Monitor 值時, 可在控制臺命令列傳入的參數 :

5. (選), (鍵 is_monitor 固定, 值 false 自定義, [ true, false ] 取其一), 用於判斷只運行一次, 還是保持文檔監聽, 預設值爲 :  is_monitor=false

6. (選), (鍵 time_sleep 固定, 值 0.02 自定義), 用於傳入監聽文檔輪詢延遲時長，單位 ( Unit ) 爲秒 ( Second ), 預設值爲 :  time_sleep=0.02

7. (選), (鍵 number_Worker_threads 固定, 值 0 自定義), 用於傳入創建並發數目, 子進程 ( Sub Process ) 並發, 或者, 子缐程 ( Sub Threading ) 並發, 即, 可以設爲等於物理中央處理器 ( Central Processing Unit ) 的數目, 取 0 值表示不開啓並發架構, 預設值爲 :  number_Worker_threads=0

8. (選), (鍵 isDoTasksOrThreads 固定, 值 Tasks 自定義, 例如 [ Tasks, Multi-Threading ] 取其一), 用於選擇並發種類, 多缐程 ( Threading ) 並發, 或者, 多協程 ( Tasks ) 並發, 當取值為多缐程 Multi-Threading 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置預創建多個缐程, 預設值爲 : 
 isDoTasksOrThreads=Tasks

9. (選), (鍵 isMonitorThreadsOrProcesses 固定, 值 Multi-Threading 自定義, 例如 [ 0, Multi-Threading, Multi-Processes ] 取其一), 用於選擇並發種類, 多進程 ( Process ) 並發, 或者, 多缐程 ( Threading ) 並發, 取 0 值表示不開啓並發架構, 預設值爲 :  isMonitorThreadsOrProcesses=0

10. (選), (鍵 monitor_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 用於接收傳值的媒介目錄 ( 監聽文件夾 ) 存儲路徑全名, 預設值爲 :  monitor_dir=C:/Criss/Intermediary/

11. (選), (鍵 monitor_file 固定, 值 C:/Criss/Intermediary/intermediary_write_C.txt 自定義), 用於接收傳值的媒介文檔 ( 監聽文檔 ) 存儲路徑全名, 預設值爲 :  monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt

12. (選), (鍵 output_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 用於輸出運算結果傳值的媒介目錄 ( 運算結果文檔儲存文件夾 ) 存儲路徑全名, 預設值爲 :  output_dir=C:/Criss/Intermediary/

13. (選), (鍵 output_file 固定, 值 C:/Criss/Intermediary/intermediary_write_Nodejs.txt 自定義), 用於輸出運算結果傳值的媒介文檔 ( 運算結果輸出保存文檔 ) 存儲路徑全名, 預設值爲 :  output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt

14. (選), (鍵 temp_cache_IO_data_dir 固定, 值 C:/Criss/temp/ 自定義), 用於暫存傳入傳出數據的臨時媒介文件夾路徑全名, 預設值爲 :  temp_cache_IO_data_dir=C:/Criss/temp/

以下是當參數 : interface_Function 取 : http_Server 值時, 可在控制臺命令列傳入的參數 :

7. (選), (鍵 number_Worker_threads 固定, 值 0 自定義), 用於傳入創建並發數目, 子進程 ( Sub Process ) 並發, 或者, 子缐程 ( Sub Threading ) 並發, 即, 可以設爲等於物理中央處理器 ( Central Processing Unit ) 的數目, 取 0 值表示不開啓並發架構, 預設值爲 :  number_Worker_threads=0

15. (選), (鍵 host 固定, 值 ::0 自定義, 例如 [ ::0, ::1, 0.0.0.0, 127.0.0.1, localhost ] 取其一), 用於傳入伺服器 ( http_Server ) 監聽的外設網卡 ( Network Interface Card ) 地址 ( IPv6, IPv4 ) 或域名, 預設值爲 :  host=::0

16. (選), (鍵 port 固定, 值 10001 自定義), 用於傳入伺服器 ( http_Server ) 監聽的外設網卡 ( Network Interface Card ) 自定義設定的埠號 ( 1 ~ 65535 ), 預設值爲 :  port=10001

17. (選), (鍵 key 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 用於傳入自定義的訪問網站驗證 ( Authorization ) 用戶名和密碼, 預設值爲 :  key=username:password

18. (選), (鍵 isConcurrencyHierarchy 固定, 值 Tasks 自定義, 例如 [ Tasks, Multi-Threading, Multi-Processes ] 取其一), 用於選擇並發種類, 多進程 ( Process ) 並發, 或者, 多缐程 ( Threading ) 並發, 或者, 多協程 ( Tasks ) 並發, 當取值為多缐程 Multi-Threading 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置預創建多個缐程, 預設值爲 :  isConcurrencyHierarchy=Tasks

19. (選), (鍵 webPath 固定, 值 C:/Criss/html/ 自定義), 用於傳入伺服器 ( http_Server ) 啓動運行的自定義的根目錄 (項目空間) 路徑全名, 預設值爲 :  webPath=C:/Criss/html/

20. (選), (鍵 readtimeout 固定, 值 0 自定義), 用於傳入客戶端請求數據讀取超時中止時長，單位 ( Unit ) 爲秒 ( Second ), 取 0 值表示不做判斷是否超時, 預設值爲 :  readtimeout=0

以下是當參數 : interface_Function 取 : http_Client 值時, 可在控制臺命令列傳入的參數 :

15. (選), (鍵 host 固定, 值 ::1 自定義, 例如 [ ::1, 127.0.0.1, localhost ] 取其一), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的地址 ( IPv6, IPv4 ) 或域名, 預設值爲 :  host=::1

16. (選), (鍵 port 固定, 值 10001 自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的埠號 ( 1 ~ 65535 ), 預設值爲 :  port=10001

21. (選), (鍵 URL 固定, 取值自定義, 例如配置爲 http://[::1]:10001/index.html 值), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的地址, 萬維網統一資源定位系統 ( Uniform Resource Locator ) 地址字符串, 預設值爲 :  URL=""

22. (選), (鍵 proxy 固定, 取值自定義, 例如配置爲 http://[::1]:10001/index.html 值), 當用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求時, 若需要代理轉發, 用於傳入轉發代理服務器的地址, 萬維網統一資源定位系統 ( Uniform Resource Locator ) 地址字符串, 預設值爲 :  proxy=""

23. (選), (鍵 requestMethod 固定, 值 POST 自定義, 例如 [ POST, GET ] 取其一), 用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的類型, 預設值爲 :  requestMethod=POST

20. (選), (鍵 readtimeout 固定, 值 0 自定義), 用於傳入服務端響應數據讀取超時中止時長，單位 ( Unit ) 爲秒 ( Second ), 取 0 值表示不做判斷是否超時, 預設值爲 :  readtimeout=0

24. (選), (鍵 connecttimeout 固定, 值 0 自定義), 用於傳入客戶端請求鏈接超時中止時長，單位 ( Unit ) 爲秒 ( Second ), 取 0 值表示不做判斷是否超時, 預設值爲 :  connecttimeout=0

25. (選), (鍵 Authorization 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的驗證 ( Authorization ) 的賬號密碼字符串, 預設值爲 :  Authorization=username:password

26. (選), (鍵 Cookie 固定, 其中 Cookie 名稱 Session_ID 可以設計爲固定, Cookie 值 request_Key->username:password 可以設計爲自定義), 用於傳入用戶端連接器 ( http_Client ) 向外設網卡 ( Network Interface Card ) 發送請求的 Cookies 值字符串, 預設值爲 :  Cookie=Session_ID=request_Key->username:password

![]()

Interpreter :

julia - 1.10.4

julia - 1.10.4 - packages :

&nbsp;&nbsp;&nbsp;&nbsp;Artifacts

&nbsp;&nbsp;&nbsp;&nbsp;Base64

&nbsp;&nbsp;&nbsp;&nbsp;BitFlags - 0.1.8

&nbsp;&nbsp;&nbsp;&nbsp;CodecZlib - 0.7.4

&nbsp;&nbsp;&nbsp;&nbsp;ConcurrentUtilities - 2.4.1

&nbsp;&nbsp;&nbsp;&nbsp;Dates

&nbsp;&nbsp;&nbsp;&nbsp;ExceptionUnwrapping - 0.1.10

&nbsp;&nbsp;&nbsp;&nbsp;HTTP - 1.10.8

&nbsp;&nbsp;&nbsp;&nbsp;InteractiveUtils

&nbsp;&nbsp;&nbsp;&nbsp;JLLWrappers - 1.5.0

&nbsp;&nbsp;&nbsp;&nbsp;JSON - 0.21.4

&nbsp;&nbsp;&nbsp;&nbsp;Libdl

&nbsp;&nbsp;&nbsp;&nbsp;Logging

&nbsp;&nbsp;&nbsp;&nbsp;LoggingExtras - 1.0.3

&nbsp;&nbsp;&nbsp;&nbsp;Markdown

&nbsp;&nbsp;&nbsp;&nbsp;MbedTLS - 1.1.9

&nbsp;&nbsp;&nbsp;&nbsp;MbedTLS_jll - 2.28.2+0

&nbsp;&nbsp;&nbsp;&nbsp;Mmap

&nbsp;&nbsp;&nbsp;&nbsp;MozillaCACerts_jll - 2022.10.11

&nbsp;&nbsp;&nbsp;&nbsp;NetworkOptions - 1.2.0

&nbsp;&nbsp;&nbsp;&nbsp;OpenSSL - 1.4.3

&nbsp;&nbsp;&nbsp;&nbsp;OpenSSL_jll - 3.0.13+1

&nbsp;&nbsp;&nbsp;&nbsp;Parsers - 2.8.1

&nbsp;&nbsp;&nbsp;&nbsp;PrecompileTools - 1.2.1

&nbsp;&nbsp;&nbsp;&nbsp;Preferences - 1.4.3

&nbsp;&nbsp;&nbsp;&nbsp;Printf

&nbsp;&nbsp;&nbsp;&nbsp;Random

&nbsp;&nbsp;&nbsp;&nbsp;SHA - 0.7.0

&nbsp;&nbsp;&nbsp;&nbsp;Serialization

&nbsp;&nbsp;&nbsp;&nbsp;SimpleBufferStream - 1.1.0

&nbsp;&nbsp;&nbsp;&nbsp;Sockets

&nbsp;&nbsp;&nbsp;&nbsp;TOML - 1.0.3

&nbsp;&nbsp;&nbsp;&nbsp;Test

&nbsp;&nbsp;&nbsp;&nbsp;TranscodingStreams - 0.10.9

&nbsp;&nbsp;&nbsp;&nbsp;TranscodingStreams.extensions

&nbsp;&nbsp;&nbsp;&nbsp;URIs - 1.5.1

&nbsp;&nbsp;&nbsp;&nbsp;UUIDs

&nbsp;&nbsp;&nbsp;&nbsp;Unicode

&nbsp;&nbsp;&nbsp;&nbsp;Zlib_jll - 1.2.13+0

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方網站](https://julialang.org/): 
https://julialang.org/

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方下載頁](https://julialang.org/downloads/): 
https://julialang.org/downloads/

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 GitHub 網站賬戶](https://github.com/JuliaLang): 
https://github.com/JuliaLang

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 GitHub 網站倉庫](https://github.com/JuliaLang/julia): 
https://github.com/JuliaLang/julia.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方擴展模組 ( module ) ( packages ) 托管網站官方手冊](https://julialang.org/packages/): 
https://julialang.org/packages/

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 General.jl 模組 GitHub 網站倉庫](https://github.com/JuliaRegistries/General): 
https://github.com/JuliaRegistries/General.git

---

Window-cmd : startServer.bat

使用説明:

微軟視窗系統 ( Windows10 x86_64 )

控制臺命令列 ( cmd ) 運行啓動指令 :

C:\Criss> C:/Windows/System32/cmd.exe C:/Criss/startServer.bat C:/Criss/config.txt

控制臺啓動傳參釋意 :

1. (必), (固定), 微軟視窗作業系統 ( Window10 x86_64 ) 控制臺命令列窗口的二進制可執行檔 ( cmd.exe ) 啓動存儲路徑全名, 作業系統 ( Window10 x86_64 ) 固定存儲在路徑爲 :  C:/Windows/System32/cmd.exe

2. (必), (自定義), 微軟視窗系統 ( Windows10 x86_64 ) 批處理程式代碼脚本 ( .bat ) 檔 ( startServer.bat ) 的存儲路徑全名, 預設值爲 :  C:/Criss/startServer.bat

3. (選) (值 C:/Criss/config.txt 自定義), 用於傳入配置文檔的保存路徑全名, 配置文檔裏的橫向列首可用一個井號字符 ( # ) 注釋掉, 使用井號字符 ( # ) 注釋掉之後，該橫向列的參數即不會傳入從而失效, 若需啓用可刪除橫向列首的井號字符 ( # ) 即可, 注意橫向列首的空格也要刪除, 每一個橫向列的參數必須頂格書寫, 預設值爲 :  C:/Criss/config.txt

---

Android-Termux-Ubuntu-bash : startServer.sh

使用説明:

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 )

控制臺命令列 ( bash ) 運行啓動指令 :

root@localhost:~# /bin/bash /home/Criss/startServer.sh configFile=/home/Criss/config.txt executableFile=/bin/julia interpreterFile=-p,4,--project=/home/Criss/jl/ scriptFile=/home/Criss/jl/application.jl configInstructions=configFile=/home/Criss/jl/config.txt,interface_Function=file_Monitor,webPath=/home/Criss/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/

控制臺啓動傳參釋意, 各參數之間以一個逗號字符 ( , ) 分隔, 鍵(Key) ~ 值(Value) 之間以一個等號字符 ( = ) 連接, 即類比 Key=Value 的形式 :

1. (必), (固定), 谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 ) 控制臺命令列窗口的二進制可執行檔 ( bash ) 啓動存儲路徑全名, 作業系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 ) 固定存儲在路徑爲 :  /bin/bash

2. (必), (自定義), 谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 ) 批處理程式代碼脚本 ( .sh ) 檔 ( startServer.sh ) 的存儲路徑全名, 預設值爲 :  C:/Criss/startServer.sh

3. (選), (鍵 configFile 固定, 值 /home/Criss/config.txt 自定義), 用於傳入配置文檔的保存路徑全名, 配置文檔裏的橫向列首可用一個井號字符 ( # ) 注釋掉, 使用井號字符 ( # ) 注釋掉之後，該橫向列的參數即不會傳入從而失效, 若需啓用可刪除橫向列首的井號字符 ( # ) 即可, 注意橫向列首的空格也要刪除, 每一個橫向列的參數必須頂格書寫, 預設值爲 :  configFile=/home/Criss/config.txt

4. (選), (鍵 executableFile 固定, 值 /bin/julia 自定義, 例如 [ /bin/julia, /bin/python3, /bin/node ] 可自定義取其一配置), 用於傳入選擇啓動哪一種程式語言編寫的接口服務, 計算機 ( Computer ) 程式 ( Programming ) 設計 Julia 語言, 計算機 ( Computer ) 程式 ( Programming ) 設計 Python 語言, 計算機 ( Computer ) 程式 ( Programming ) 設計 Node.js 語言, 預設值爲 :  executableFile=/bin/julia

5. (選), (鍵 interpreterFile 固定, 值 -p,4,--project=/home/Criss/jl/ 自定義, 且可爲空, 即取 interpreterFile= 的形式, 亦可不傳入該參數), 用於傳入程式設計語言 ( Julia, Python3 Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔, 於作業系統控制臺命令列 ( Operating System Console Command ) 使用指令啓動時傳入的運行參數, 若爲多參數, 則各參數之間用一個逗號 ( , ) 字符連接, 批處理程式脚本 startServer.sh 已設計爲可自動將逗號 ( , ) 字符替換爲空格字符 ( SPACE ) ( 00100000 ), 然後再傳入程式設計語言 ( Julia, Python3 Node.js ) 解釋器 ( Interpreter ) 的運行環境, 預設值爲 :  interpreterFile=-p,4,--project=/home/Criss/jl/

6. (選), (鍵 scriptFile 固定, 值 /home/Criss/jl/application.jl 自定義, 例如 [ /home/Criss/jl/application.jl, /home/Criss/py/application.py, /home/Criss/js/application.js ] 可自定義取其一配置), 用於傳入程式 ( Programming ) 設計語言 ( Julia, Python3 Node.js ) 代碼脚本 ( Script ) 檔 ( application.jl, application.py, application.js ) 的存儲路徑全名, 預設值爲 :  scriptFile=/home/Criss/jl/application.jl

7. (選), (鍵 configInstructions 固定, 取值自定義, 且可爲空, 即取 configInstructions= 的形式, 亦可不傳入該參數), 用於傳入程式 ( Programming ) 設計語言 ( Julia, Python3 Node.js ) 代碼脚本 ( Script ) 檔 ( application.jl, application.py, application.js ) 的運行參數, 若爲多參數, 則各參數之間用一個逗號 ( , ) 字符連接, 批處理程式脚本 startServer.sh 已設計爲可自動將逗號 ( , ) 字符替換爲空格字符 ( SPACE ) ( 00100000 ), 然後再傳入代碼脚本 ( Script ) 檔 ( application.jl, application.py, application.js ) 的運行環境, 預設值爲 :  configInstructions=configFile=/home/Criss/jl/config.txt,interface_Function=file_Monitor,webPath=/home/Criss/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/

---

c2exe.c

程式設計 C 語言, 使用 FILE *fstream = popen("shell Code Script", "r") 函數, 創建子進程 ( Sub Process ), 並在子進程 ( Sub Process ) 運行外部二進制可執行檔 ( julia.exe, python.exe, node.exe ), 功能與批處理檔 startServer.sh 類似.

使用説明:

微軟視窗系統 ( Windows10 x86_64 )

Windows10 x86_64 Compiler :

Minimalist GNU on Windows ( MinGW-w64 ) mingw64-8.1.0-release-posix-seh-rt_v6-rev0

控制臺命令列 ( cmd ) 運行編譯指令 :

C:\Criss> C:\MinGW64\bin\gcc.exe C:/Criss/c/c2exe.c -o C:/Criss/c2exe.exe

控制臺命令列 ( cmd ) 運行顯示中文字符指令 :

C:\Criss> chcp 65001

控制臺命令列 ( cmd ) 運行啓動指令 :

C:\Criss> C:/Criss/c2exe.exe configFile=C:/Criss/config.txt executableFile=C:/Criss/Julia/Julia-1.10.4/julia.exe interpreterFile=-p,4,--project=C:/Criss/jl/ scriptFile=C:/Criss/jl/application.jl configInstructions=configFile=/home/Criss/jl/config.txt,interface_Function=file_Monitor,webPath=C:/Criss/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/Criss/Intermediary/,monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt,output_dir=C:/Criss/Intermediary/,output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/Criss/temp/

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 )

Android-11 Termux-0.118 Ubuntu-22.04 Arm64-aarch64 Compiler :

gcc v9.3.0, g++ v9.3.0

控制臺命令列 ( bash ) 運行編譯指令 :

root@localhost:~# /bin/gcc /home/Criss/c/c2exe.c -o /home/Criss/c2exe.exe

控制臺命令列 ( bash ) 運行啓動指令 :

root@localhost:~# /home/Criss/c2exe.exe configFile=/home/Criss/config.txt executableFile=/bin/julia interpreterFile=-p,4,--project=/home/Criss/jl/ scriptFile=/home/Criss/jl/application.jl configInstructions=configFile=/home/Criss/jl/config.txt,interface_Function=file_Monitor,webPath=/home/Criss/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/

控制臺啓動傳參釋意, 各參數之間以一個逗號字符 ( , ) 分隔, 鍵(Key) ~ 值(Value) 之間以一個等號字符 ( = ) 連接, 即類比 Key=Value 的形式 :

1. (必), (自定義), 計算機 C 語言 ( Computer Programming C Language ) 程式設計 ( Programming ) 代碼檔 ( c2exe.c ), 使用編譯器 ( Compiler ), 經過編譯之後, 轉換爲二進制可執行檔 ( .exe ), 啓動運行指令存儲路徑全名, 例如可自定義配置爲 :  C:/Criss/c2exe.exe

2. (選) (值 C:/Criss/config.txt 自定義), 用於傳入配置文檔的保存路徑全名, 配置文檔裏的橫向列首可用一個井號字符 ( # ) 注釋掉, 使用井號字符 ( # ) 注釋掉之後，該橫向列的參數即不會傳入從而失效, 若需啓用可刪除橫向列首的井號字符 ( # ) 即可, 注意橫向列首的空格也要刪除, 每一個橫向列的參數必須頂格書寫, 預設值爲 :  C:/Criss/config.txt

3. (選), (鍵 executableFile 固定, 值 /bin/julia 自定義, 例如 [ /bin/julia, /bin/python3, /bin/node ] 可自定義取其一配置), 用於傳入選擇啓動哪一種程式語言編寫的接口服務, 計算機 ( Computer ) 程式 ( Programming ) 設計 Julia 語言, 計算機 ( Computer ) 程式 ( Programming ) 設計 Python 語言, 計算機 ( Computer ) 程式 ( Programming ) 設計 Node.js 語言, 預設值爲 :  executableFile=/bin/julia

4. (選), (鍵 interpreterFile 固定, 值 -p,4,--project=/home/Criss/jl/ 自定義, 且可爲空, 即取 interpreterFile= 的形式, 亦可不傳入該參數), 用於傳入程式設計語言 ( Julia, Python3 Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔, 於作業系統控制臺命令列 ( Operating System Console Command ) 使用指令啓動時傳入的運行參數, 若爲多參數, 則各參數之間用一個逗號 ( , ) 字符連接, 代碼文檔 c2exe.c 已設計爲可自動將逗號 ( , ) 字符替換爲空格字符 ( SPACE ) ( 00100000 ), 然後再傳入程式設計語言 ( Julia, Python3 Node.js ) 解釋器 ( Interpreter ) 的運行環境, 預設值爲 :  interpreterFile=-p,4,--project=/home/Criss/jl/

5. (選), (鍵 scriptFile 固定, 值 /home/Criss/jl/application.jl 自定義, 例如 [ /home/Criss/jl/application.jl, /home/Criss/py/application.py, /home/Criss/js/application.js ] 可自定義取其一配置), 用於傳入程式 ( Programming ) 設計語言 ( Julia, Python3 Node.js ) 代碼脚本 ( Script ) 檔 ( application.jl, application.py, application.js ) 的存儲路徑全名, 預設值爲 :  scriptFile=/home/Criss/jl/application.jl

6. (選), (鍵 configInstructions 固定, 取值自定義, 且可爲空, 即取 configInstructions= 的形式, 亦可不傳入該參數), 用於傳入程式 ( Programming ) 設計語言 ( Julia, Python3 Node.js ) 代碼脚本 ( Script ) 檔 ( application.jl, application.py, application.js ) 的運行參數, 若爲多參數, 則各參數之間用一個逗號 ( , ) 字符連接, 代碼文檔 c2exe.c 已設計爲可自動將逗號 ( , ) 字符替換爲空格字符 ( SPACE ) ( 00100000 ), 然後再傳入代碼脚本 ( Script ) 檔 ( application.jl, application.py, application.js ) 的運行環境, 預設值爲 :  configInstructions=configFile=/home/Criss/jl/config.txt,interface_Function=file_Monitor,webPath=/home/Criss/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/

![]()

Compiler :

Minimalist GNU on Windows ( MinGW-w64 ) :  mingw64-8.1.0-release-posix-seh-rt_v6-rev0

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方網站](https://www.mingw-w64.org/): 
https://www.mingw-w64.org/

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方下載頁](https://www.mingw-w64.org/downloads/): 
https://www.mingw-w64.org/downloads/

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 作者官方 GitHub 網站賬戶](https://github.com/niXman): 
https://github.com/niXman

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方 GitHub 網站倉庫](https://github.com/nixman/mingw-builds): 
https://github.com/nixman/mingw-builds.git

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方 GitHub 網站倉庫預編譯二進制檔下載頁](https://github.com/niXman/mingw-builds-binaries/releases): 
https://github.com/niXman/mingw-builds-binaries/releases

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 預編譯二進制檔下載頁](https://sourceforge.net/projects/mingw-w64/): 
https://sourceforge.net/projects/mingw-w64/

---

Code Editor : Visual Studio Code , Code-Server , Jupyter-Notebook , Wcode

[代碼編輯器 ( Code Editor ) 之  Visual Studio Code 官方網站](https://code.visualstudio.com/): 
https://code.visualstudio.com/

[代碼編輯器 ( Code Editor ) 之  Visual Studio Code 官方 GitHub 網站倉庫](https://github.com/microsoft/vscode): 
https://github.com/microsoft/vscode.git

[代碼編輯器 ( Code Editor ) 之  Code-Server 官方網站](https://coder.com/): 
https://coder.com/

[代碼編輯器 ( Code Editor ) 之  Code-Server 官方 GitHub 網站倉庫](https://github.com/coder/code-server): 
https://github.com/coder/code-server.git

[代碼編輯器 ( Code Editor ) 之  Jupyter-Notebook 官方網站](https://jupyter.org/): 
https://jupyter.org/

[代碼編輯器 ( Code Editor ) 之  Jupyter-Notebook 官方網站説明頁](https://docs.jupyter.org/en/latest/): 
https://docs.jupyter.org/en/latest/

[代碼編輯器 ( Code Editor ) 之  Jupyter-Notebook 官方 GitHub 網站倉庫](https://github.com/jupyter/notebook): 
https://github.com/jupyter/notebook.git

[代碼編輯器 ( Code Editor ) 之  Wcode 官方 GitHub 網站倉庫](https://github.com/fmsouza/wcode): 
https://github.com/fmsouza/wcode.git

---

編譯器 ( Compiler ) , 解釋器 ( Interpreter ) 工具 [百度網盤(pan.baidu.com)](https://pan.baidu.com/s/1Dtp1PEcFBAnjrzareMtjNg?pwd=me5k) 下載頁: 
https://pan.baidu.com/s/1Dtp1PEcFBAnjrzareMtjNg?pwd=me5k

提取碼：me5k
