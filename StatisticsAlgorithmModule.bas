Attribute VB_Name = "StatisticsAlgorithmModule"

'Author: 趙健
'E-mail: 283640621@qq.com
'Telephont Number: +86-18604537694
'Date: 六十九年


'The codes were enhanced for both VBA7 (64-bit) and others (32-bit) by Long Vh.
#If VBA7 Then

    Private Declare PtrSafe Sub sleep Lib "kernel64" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 64 位軟件使用這條語句聲明
    Private Declare PtrSafe Function timeGetTime Lib "winmm.dll" () As Long: Rem 64 位軟件使用這條語句聲明
    
    '聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。
    Private Declare PtrSafe Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 64 位軟件使用這條語句聲明

#Else

    Private Declare Sub sleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 32 位軟件使用這條語句聲明，聲明 sleep 函數，函數 sleep 是 Windows API 函數，使用前，必須先聲明，然後再使用。這條語句是為後面使用 sleep 函數精確延時使用的，如果程序中不使用 sleep 函數，可以刪除這條語句。函數 sleep 的使用方法是，sleep 3000  '3000 表示 3000 毫秒。函數 sleep 延時是毫秒級的，精確度比較高，但它在延時時，會將程序挂起，使操作系統暫時無法響應用戶操作，所以長延時不適合使用。
    Private Declare Function timeGetTime Lib "winmm.dll" () As Long: Rem 32 位軟件使用這條語句聲明，聲明 timeGetTime 函數，函數 timeGetTime 是 Windows API 函數，使用前，必須先聲明，然後再使用。這條語句是為後面使用 timeGetTime 函數精確延時使用的，如果程序中不需要使用 timeGetTime 函數也可以刪除這條語句。函數 timeGetTime 返回的是開機到現在的毫秒數，可以支持 1 毫秒的間隔時間，一直增加。

    '聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。
    Private Declare Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 32 位軟件使用這條語句聲明，聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。

#End If
Private Const WM_SYSCOMMAND = &H112: Rem 聲明函數參數使用的常數值
Private Const SC_MINIMIZE = &HF020&: Rem 聲明函數參數使用的常數值
'使用函數示例
'SendMessage IEA.hwnd, WM_SYSCOMMAND, SC_MINIMIZE, 0: Rem 向瀏覽器窗口發送消息，最小化瀏覽器窗口，這是使用的 Windows 系統的 API 函數，在模塊頭部的幾條語句中聲明過



Rem 如果使用全局變量 public 的方法實現，在用戶窗體裏邊的全局變量賦值方式如下：
Option Explicit: Rem 語句 Option Explicit 表示强制要求變量需要先聲明後使用；聲明全局變量，可以跨越函數和子過程之間使用的，用于監測窗體中按钮控件點擊狀態。
Public PublicCurrentWorkbookName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentWorkbookName”，用於存放當前工作簿的名稱
Public PublicCurrentWorkbookFullName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentWorkbookFullName”，用於存放當前工作簿的全名（工作簿路徑和名稱）
Public PublicCurrentSheetName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentSheetName”，用於存放當前工作表的名稱


Public Public_Statistics_Algorithm_module_name As String: Rem 導入的統計算法模塊的自定義命名值字符串
Public PublicVariableStartORStopButtonClickState As Boolean: Rem 定義一個全局型（Public）布爾型变量“PublicVariableStartORStopButtonClickState”用於監測窗體中啓動計算按钮控件的點擊狀態，即是否正在進行計算的狀態提示

Public Public_Database_Server_Url As String: Rem 用於存儲計算結果的數據庫服務器網址，字符串變量
Public Public_Statistics_Algorithm_Server_Url As String: Rem 用於提供統計運算的服務器網址，字符串變量
Public Public_Statistics_Algorithm_Server_Username As String: Rem 用於向提供統計運算服務器驗證的賬戶名，字符串變量
Public Public_Statistics_Algorithm_Server_Password As String: Rem 用於向提供統計運算服務器驗證的賬戶密碼，字符串變量
Public Public_Data_Receptors As String: Rem 用於存儲計算結果的容器類型複選框值，字符串變量，可取值：("Database"，"Excel_and_Database"，"Excel")，例如取值：CStr("Excel")
Public Public_Statistics_Algorithm_Name As String: Rem 表示判斷選擇使用的辨識統計算法種類，可以取值：("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") 等自定義的算法名稱值字符串;
Public Public_Delay_length_input As Long: Rem 循環點擊操作之間延遲等待的時長的基礎值，單位毫秒
Public Public_Delay_length_random_input As Single: Rem 循環點擊操作之間延遲等待的時長的隨機化範圍，單位為基礎值的百分比
Public Public_Delay_length As Long: Rem 循環點擊操作之間延遲等待的時長，單位毫秒
'Public Public_Delay_length As Integer: Rem 循環點擊操作之間延遲等待的時長，單位毫秒

'數據輸入輸出參數設置
Public Public_Data_name_input_position As String: Rem 待計算的數據字段命名值在Excel表格中的傳入位置字符串
Public Public_Data_input_position As String: Rem 待計算的數據字段在Excel表格中的傳入位置字符串
Public Public_Result_output_position As String: Rem 計算之後的結果輸出在Excel表格中的傳入位置字符串



Public Sub StatisticsAlgorithmModule_Initialize(): Rem 給變量賦初值，子過程 Variable_Initialize 的作用是文檔打開即運行初始化

    '語句 On Error Resume Next 會使程序按照產生錯誤的語句之後的語句繼續執行
    On Error Resume Next

    PublicCurrentWorkbookName = ThisWorkbook.name: Rem 獲得當前工作簿的名稱，效果等同於“ = ActiveWorkbook.Name ”
    PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem 獲得當前工作簿的全名（工作簿路徑和名稱）
    PublicCurrentSheetName = ActiveSheet.name: Rem 獲得當前工作表的名稱
    'Debug.Print PublicCurrentSheetName


    Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

    'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串

    Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem 用於存儲計算結果的數據庫服務器網址，字符串變量，例如：CStr("http://localhost:27016/insert?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password")
    Public_Data_Receptors = CStr("Excel"): Rem 用於存儲計算結果的容器類型複選框值，字符串變量，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")

    Public_Delay_length_input = CLng(3000): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

    Public_Statistics_Algorithm_Name = CStr("Interpolation"): Rem 表示判斷選擇使用的辨識統計算法種類，可以取值：("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") 等自定義的算法名稱值字符串;
    Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem 用於向提供統計運算服務器驗證的賬戶名，字符串變量
    Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem 用於向提供統計運算服務器驗證的賬戶密碼，字符串變量
    'Public_Statistics_Algorithm_Server_Url = "http://[::1]:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem 用於提供統計運算的服務器網址，字符串變量
    Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1"): Rem 用於提供統計運算的服務器網址，字符串變量
    'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit"): Rem 用於提供統計運算的服務器網址，字符串變量
    'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"): Rem 用於提供統計運算的服務器網址，字符串變量

    '數據輸入輸出參數設置
    Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$L$1 待計算的數據字段命名值在Excel表格中的傳入位置字符串
    Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$L$12 待計算的數據字段在Excel表格中的傳入位置字符串
    Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:M12"): Rem CStr(PublicCurrentSheetName & "!" & "K1:U12") : Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$N$1:$Y$12 計算之後的結果輸出在Excel表格中的傳入位置字符串

    '給監測窗體中啓動運算按钮控件的點擊狀態變量賦初值初始化
    PublicVariableStartORStopButtonClickState = True: Rem 布爾型變量，用於監測窗體中啓動運算按钮控件的點擊狀態，即是否正在進行運算的狀態提示


    '執行操作面板窗口控件 StatisticsAlgorithmControlPanel 中的變量初始化賦初值函數 UserForm_Initialize()
    If Not (StatisticsAlgorithmControlPanel.Controls("UserForm_Initialize") Is Nothing) Then
        Call StatisticsAlgorithmControlPanel.UserForm_Initialize  '調用操作面板窗口控件 StatisticsAlgorithmControlPanel 中的變量初始化賦初值函數 UserForm_Initialize()
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（監測窗體中啓動運算按钮控件的點擊狀態）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
        StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（統計算法模塊名稱字符串類型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_module_name") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_module_name = Public_Statistics_Algorithm_module_name
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於存儲計算結果的數據庫服務器網址，字符串型）變量賦初值。函數 CStr() 表示轉換爲字符串類型
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Value = CStr(Public_Database_Server_Url)
        StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Text = CStr(Public_Database_Server_Url)
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於存儲計算結果的容器類型複選框值字符串）變量賦初值，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")。函數 CStr() 表示轉換爲字符串類型
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_Receptors") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_Receptors = CStr(Public_Data_Receptors)
    End If
    'Debug.Print StatisticsAlgorithmControlPanel.Public_Data_Receptors
    '判斷子框架控件是否存在
    If Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame").Controls
            If Public_Data_Receptors = "Excel_and_Database" Then
                '判斷複選框控件的顯示值字符串，函數 CStr() 表示强制轉換爲字符串類型，並據此設定複選框控件的選中狀態
                If (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(0))) Or (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(1))) Then
                    element_i.Value = True: Rem 設置複選框控件的選中狀態，結果為布爾型。
                Else
                    element_i.Value = False: Rem 設置複選框控件的選中狀態，結果為布爾型。
                End If
            Else
                '判斷複選框控件的顯示值字符串，函數 CStr() 表示强制轉換爲字符串類型，並據此設定複選框控件的選中狀態
                If CStr(element_i.Caption) = CStr(Public_Data_Receptors) Then
                    element_i.Value = True: Rem 設置複選框控件的選中狀態，結果為布爾型。
                Else
                    element_i.Value = False: Rem 設置複選框控件的選中狀態，結果為布爾型。
                End If
            End If
        Next
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於提供統計運算的服務器網址，字符串型）變量賦初值。函數 CStr() 表示轉換爲字符串類型
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Value = CStr(Public_Statistics_Algorithm_Server_Url)
        StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Text = CStr(Public_Statistics_Algorithm_Server_Url)
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（表示判斷選擇使用的辨識統計算法種類單選框值字符串）變量賦初值，可以取值：("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") 等自定義的算法名稱值字符串。函數 CStr() 表示轉換爲字符串類型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Name") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name = CStr(Public_Statistics_Algorithm_Name)
    End If
    'Debug.Print StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name
    '判斷子框架控件是否存在
    If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        'Dim element_i
        For Each element_i In StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame").Controls
            '判斷單選框控件的顯示值字符串，函數 CStr() 表示强制轉換爲字符串類型，並據此設定複選框控件的選中狀態
            If CStr(element_i.Caption) = CStr(Public_Statistics_Algorithm_Name) Then
                element_i.Value = True: Rem 設置單選框的選中狀態，結果為布爾型。函數 CStr() 表示轉換爲字符串類型。
                'Exit For
            Else
                element_i.Value = False: Rem 設置單選框的選中狀態，結果為布爾型。函數 CStr() 表示轉換爲字符串類型。
                'Exit For
            End If
        Next
        Set element_i = Nothing
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於向提供統計運算服務器驗證的賬戶名字符串）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Username") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Username_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Value = Public_Statistics_Algorithm_Server_Username
        StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Text = Public_Statistics_Algorithm_Server_Username
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於向提供統計運算服務器驗證的賬戶密碼字符串）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Password") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Password_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Value = Public_Statistics_Algorithm_Server_Password
        StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Text = Public_Statistics_Algorithm_Server_Password
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量賦初值。函數 CLng() 表示强制轉換為長整型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        If CLng(Public_Delay_length_input) = CLng(0) Then
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value = ""
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value = CStr(Public_Delay_length_input): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為長整型。
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text = CStr(Public_Delay_length_input): Rem 為文本輸入框控件的 .Text 屬性賦值，結果為長整型。
        End If
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量賦初值。函數 CSng() 表示强制轉換為單精度浮點型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        If CSng(Public_Delay_length_input) = CSng(0#) Then
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value = ""
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value = CStr(Public_Delay_length_random_input): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為單精度浮點型。
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text = CStr(Public_Delay_length_random_input): Rem 為文本輸入框控件的 .Text 屬性賦值，結果為單精度浮點型。
        End If
    End If
    
    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（人爲延時等待的時長，單位毫秒，長整型）變量賦初值。函數 CLng() 表示强制轉換為長整型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length = CLng(Public_Delay_length)
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（待計算的數據字段命名值在Excel表格中的傳入位置，字符串型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_name_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_name_input_position = Public_Data_name_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Value = CStr(Public_Data_name_input_position): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
        StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Text = CStr(Public_Data_name_input_position): Rem 為文本輸入框控件的 .Text 屬性賦值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（待計算的數據字段在Excel表格中的傳入位置，字符串型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_input_position = Public_Data_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Data_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Value = CStr(Public_Data_input_position): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
        StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Text = CStr(Public_Data_input_position): Rem 為文本輸入框控件的 .Text 屬性賦值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（計算之後的結果輸出在Excel表格中的傳入位置，字符串型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Result_output_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Result_output_position = Public_Result_output_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Value = CStr(Public_Result_output_position): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
        StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Text = CStr(Public_Result_output_position): Rem 為文本輸入框控件的 .Text 屬性賦值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
    End If

End Sub


'Sub delay(T As Long): Rem 創建一個自定義精確延時子過程，用於後面需要延時功能時直接調用。用法為：delay(T);“T”就是要延時的時長，單位是毫秒，取值最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，這個值的範圍在 0 到 2^32 之間，大約爲 49.71 日。關鍵字 Private 表示子過程作用域只在本模塊有效，關鍵字 Public 表示子過程作用域在所有模塊都有效
'    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。
'    Dim time1 As Long
'    time1 = timeGetTime: Rem 函數 timeGetTime 表示系統時間，該時間為從系統開啓算起所經過的時間（單位毫秒），持續纍加記錄。
'    Do
'        'If Not (StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
'        '    If timeGetTime - time1 < T Then
'        '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'        '    End If
'        '    If timeGetTime - time1 >= T Then
'        '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'        '    End If
'        'End If
'
'        DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。

'    Loop While timeGetTime - time1 < T
'
'    'If Not (StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
'    '    If timeGetTime - time1 < T Then
'    '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'    '    End If
'    '    If timeGetTime - time1 >= T Then
'    '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'    '    End If
'    'End If
'
'End Sub


'向窗體 StatisticsAlgorithmControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;
Public Sub input_default_value_StatisticsAlgorithmControlPanel(ByVal Statistics_Algorithm_Name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Data_Receptors_Frame_name As String, ByVal Statistics_Algorithm_Server_Url_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Field_name_of_Data_Input_TextBox_name As String, ByVal Data_TextBox_name As String, ByVal Output_position_TextBox_name As String)


    '語句 On Error Resume Next 會使程序按照產生錯誤的語句之後的語句繼續執行
    On Error Resume Next

    Dim i, j, k As Integer: Rem 整型，記錄 for 循環次數變量

    Public_Statistics_Algorithm_Name = CStr(Statistics_Algorithm_Name): Rem 表示判斷選擇使用的辨識統計算法種類，可以取值：("test", "Interpolation", "Logistic", "Cox", "LC5PFit") 等自定義的算法名稱值字符串;


    PublicCurrentWorkbookName = ThisWorkbook.name: Rem 獲得當前工作簿的名稱，效果等同於“ = ActiveWorkbook.Name ”
    PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem 獲得當前工作簿的全名（工作簿路徑和名稱）
    PublicCurrentSheetName = ActiveSheet.name: Rem 獲得當前工作表的名稱
    'Debug.Print PublicCurrentSheetName


    ''執行操作面板窗口控件 StatisticsAlgorithmControlPanel 中的變量初始化賦初值函數 UserForm_Initialize()
    'If Not (StatisticsAlgorithmControlPanel.Controls("UserForm_Initialize") Is Nothing) Then
    '    Call StatisticsAlgorithmControlPanel.UserForm_Initialize  '調用操作面板窗口控件 StatisticsAlgorithmControlPanel 中的變量初始化賦初值函數 UserForm_Initialize()
    'End If


    ''給監測窗體中啓動運算按钮控件的點擊狀態變量賦初值初始化
    'PublicVariableStartORStopButtonClickState = True: Rem 布爾型變量，用於監測窗體中啓動運算按钮控件的點擊狀態，即是否正在進行運算的狀態提示

    ''為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（監測窗體中啓動運算按钮控件的點擊狀態）變量賦初值
    'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    'End If


    Select Case Statistics_Algorithm_Name

        Case Is = "Interpolation"

            Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串

            Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem 用於存儲計算結果的數據庫服務器網址，字符串變量，例如：CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem 用於存儲計算結果的容器類型複選框值，字符串變量，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")

            Public_Delay_length_input = CLng(1000): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
            Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
            Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

            Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem 用於向提供統計運算服務器驗證的賬戶名，字符串變量
            Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem 用於向提供統計運算服務器驗證的賬戶密碼，字符串變量
            'Public_Statistics_Algorithm_Server_Url = "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem 用於提供統計運算的服務器網址，字符串變量
            Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1"): Rem 用於提供統計運算的服務器網址，字符串變量

            '數據輸入輸出參數設置
            Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$L$1 待計算的數據字段命名值在Excel表格中的傳入位置字符串
            Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$L$12 待計算的數據字段在Excel表格中的傳入位置字符串
            Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:M12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$N$1:$Y$12 計算之後的結果輸出在Excel表格中的傳入位置字符串
 
        Case Is = "Polynomial3Fit"

            Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串

            Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem 用於存儲計算結果的數據庫服務器網址，字符串變量，例如：CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem 用於存儲計算結果的容器類型複選框值，字符串變量，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")

            Public_Delay_length_input = CLng(1000): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
            Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
            Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

            Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem 用於向提供統計運算服務器驗證的賬戶名，字符串變量
            Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem 用於向提供統計運算服務器驗證的賬戶密碼，字符串變量
            Public_Statistics_Algorithm_Server_Url = "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem 用於提供統計運算的服務器網址，字符串變量
            'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit"): Rem 用於提供統計運算的服務器網址，字符串變量

            '數據輸入輸出參數設置
            Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$L$1 待計算的數據字段命名值在Excel表格中的傳入位置字符串
            Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$L$12 待計算的數據字段在Excel表格中的傳入位置字符串
            Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:U12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$N$1:$Y$12 計算之後的結果輸出在Excel表格中的傳入位置字符串
 
        Case Is = "LC5PFit"

            Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串

            Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem 用於存儲計算結果的數據庫服務器網址，字符串變量，例如：CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem 用於存儲計算結果的容器類型複選框值，字符串變量，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")

            Public_Delay_length_input = CLng(1000): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
            Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
            Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

            Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem 用於向提供統計運算服務器驗證的賬戶名，字符串變量
            Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem 用於向提供統計運算服務器驗證的賬戶密碼，字符串變量
            Public_Statistics_Algorithm_Server_Url = "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem 用於提供統計運算的服務器網址，字符串變量
            'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"): Rem 用於提供統計運算的服務器網址，字符串變量

            '數據輸入輸出參數設置
            Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$L$1 待計算的數據字段命名值在Excel表格中的傳入位置字符串
            Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$L$12 待計算的數據字段在Excel表格中的傳入位置字符串
            Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:U12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$N$1:$Y$12 計算之後的結果輸出在Excel表格中的傳入位置字符串

        Case Else

            'MsgBox "輸入的自定義統計算法名稱錯誤，無法識別傳入的名稱（Statistics Algorithm name = " & CStr(Statistics_Algorithm_Name) & "），目前只製作完成 (""test"", ""Interpolation"", ""Logistic"", ""Cox"", ""Polynomial3Fit"", ""LC5PFit"", ...) 等自定義的統計算法."
            'Exit Sub

            'Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串

            Public_Database_Server_Url = "": Rem CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem 用於存儲計算結果的數據庫服務器網址，字符串變量，例如：CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem 用於存儲計算結果的容器類型複選框值，字符串變量，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")

            Public_Delay_length_input = CLng(0): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
            Public_Delay_length_random_input = CSng(0): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
            'Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
            Public_Delay_length = CLng(0): Rem CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

            Public_Statistics_Algorithm_Server_Username = "": Rem CStr("username"): Rem 用於向提供統計運算服務器驗證的賬戶名，字符串變量
            Public_Statistics_Algorithm_Server_Password = "": Rem CStr("password"): Rem 用於向提供統計運算服務器驗證的賬戶密碼，字符串變量
            Public_Statistics_Algorithm_Server_Url = "": Rem "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem 用於提供統計運算的服務器網址，字符串變量
            'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"): Rem 用於提供統計運算的服務器網址，字符串變量

            '數據輸入輸出參數設置
            Public_Data_name_input_position = "": Rem CStr(PublicCurrentSheetName & "!" & "A1:L1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$L$1 待計算的數據字段命名值在Excel表格中的傳入位置字符串
            Public_Data_input_position = "": Rem CStr(PublicCurrentSheetName & "!" & "A2:L12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$L$12 待計算的數據字段在Excel表格中的傳入位置字符串
            Public_Result_output_position = "": Rem CStr(PublicCurrentSheetName & "!" & "N1:Y12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$N$1:$Y$12 計算之後的結果輸出在Excel表格中的傳入位置字符串
 
    End Select


    '讀取指定電子表格（Excel）裏傳入的參數，並拼接到 URL 字符串的查詢項;
    If (CStr(Statistics_Algorithm_Name) = "KLineCleaning") Or (CStr(Statistics_Algorithm_Name) = "MarketTiming") Or (CStr(Statistics_Algorithm_Name) = "PickStock") Or (CStr(Statistics_Algorithm_Name) = "SizePosition") Or (CStr(Statistics_Algorithm_Name) = "BackTesting") Then

        Dim Data_name_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
        Data_name_input_sheetName = ""
        Dim Data_name_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
        Data_name_input_rangePosition = ""
        Dim Data_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
        Data_input_sheetName = ""
        Dim Data_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
        Data_input_rangePosition = ""
        Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        Dim inputDataNameArray() As Variant: Rem Variant、String 聲明一個不定長二維數組變量，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
        ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
        'Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
        Dim inputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        ReDim inputDataArray(0): Rem 清空數組，釋放内存
        'Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
        Dim Len_inputDataNameArray As String
        Len_inputDataNameArray = ""
        Dim Len_inputDataArray As String
        Len_inputDataArray = ""
        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於統計運算的原始數據的自定義標志名稱字段值字符串和對應的數據;
        Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        ReDim columnDataArray(0): Rem 清空數組，釋放内存
        'Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
        Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
        Len_empty = 0
        Dim Len_columnDataArray As String
        Len_columnDataArray = ""
        Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存

        '讀取傳入的變量名稱的記錄值;
        'Dim Data_name_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
        Data_name_input_sheetName = ""
        'Dim Data_name_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
        Data_name_input_rangePosition = ""
        If (Public_Data_name_input_position <> "") And (InStr(1, Public_Data_name_input_position, "!", 1) <> 0) Then
            'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
            'Dim tempArr() As String: Rem 字符串分割之後得到的數組
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_Data_name_input_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            '刪除字符串首的單引號「'」;
            Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
                tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
                'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
            Loop
            'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
            '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
            'End If
            '刪除字符串尾的單引號「'」;
            Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
                tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
                'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
            Loop
            'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
            '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
            'End If
            Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
            Data_name_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            'tempArr = VBA.Split(Public_Data_name_input_position, delimiter:="!")
            '刪除字符串首的單引號「'」;
            'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
            'Loop
            ''刪除字符串尾的單引號「'」;
            'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
            'Loop
            'Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
            'Data_name_input_rangePosition = "": Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Data_name_input_rangePosition = Data_name_input_rangePosition & CStr(tempArr(i)): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            '    Else
            '        Data_name_input_rangePosition = Data_name_input_rangePosition & "!" & CStr(tempArr(i)): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            '    End If
            'Next
            'Debug.Print Data_name_input_sheetName & ", " & Data_name_input_rangePosition
        Else
            Data_name_input_rangePosition = Public_Data_name_input_position
        End If

        'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存

        'Dim inputDataNameArray() As Variant: Rem Variant、String 聲明一個不定長二維數組變量，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
        'ReDim inputDataNameArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
        ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
        'Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存

        'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
        If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
            Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
        ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
            Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
        ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
            'MsgBox "用於統計運算的原始數據的自定義標志名稱字段的 Excel 表格的選擇範圍（Data name input = " & CStr(Public_Data_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
            'Exit Sub
        Else
        End If
        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
        'inputDataNameArray = RNG: Rem RNG.Value2
        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
        For i = 1 To RNG.Rows.Count
            For j = 1 To RNG.Columns.Count
                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
            Next j
        Next i
        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
        '    Debug.Print "inputDataNameArray:(" & i & ") = " & inputDataNameArray(i)
        '    'For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
        '    '    Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
        '    'Next j
        'Next i

        '讀取傳入的變量值;
        'Dim Data_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
        Data_input_sheetName = ""
        'Dim Data_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
        Data_input_rangePosition = ""
        If (Public_Data_input_position <> "") And (InStr(1, Public_Data_input_position, "!", 1) <> 0) Then
            'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
            'Dim tempArr() As String: Rem 字符串分割之後得到的數組
            ReDim tempArr(0): Rem 清空數組
            tempArr = VBA.Split(Public_Data_input_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
            'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
            '刪除字符串首的單引號「'」;
            Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
                tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
                'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
            Loop
            'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
            '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
            'End If
            '刪除字符串尾的單引號「'」;
            Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
                tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
                'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
            Loop
            'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
            '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
            'End If
            Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
            Data_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            'tempArr = VBA.Split(Public_Data_input_position, delimiter:="!")
            '刪除字符串首的單引號「'」;
            'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
            'Loop
            ''刪除字符串尾的單引號「'」;
            'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
            'Loop
            'Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
            'Data_input_rangePosition = "": Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
            '    If i = CInt(LBound(tempArr) + CInt(1)) Then
            '        Data_input_rangePosition = Data_input_rangePosition & CStr(tempArr(i)): Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            '    Else
            '        Data_input_rangePosition = Data_input_rangePosition & "!" & CStr(tempArr(i)): Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
            '    End If
            'Next
            'Debug.Print Data_input_sheetName & ", " & Data_input_rangePosition
        Else
            Data_input_rangePosition = Public_Data_input_position
        End If

        'Dim inputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        'ReDim inputDataArray(0 To X_UBound, 0 To Y_UBound) As Single: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        ReDim inputDataArray(0): Rem 清空數組，釋放内存
        'Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

        'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
        If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
            Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
        ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
            Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
        ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
            'MsgBox "用於統計運算的原始數據值的 Excel 表格的選擇範圍（Data input = " & CStr(Public_Data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
            'Exit Sub
        Else
        End If
        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        inputDataArray = RNG: Rem RNG.Value2
        ''使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        'For i = 1 To RNG.Rows.Count
        '    For j = 1 To RNG.Columns.Count
        '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
        '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
        '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
        '    Next j
        'Next i
        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
        'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
        '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
        '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
        '    Next j
        'Next i

        '判斷數組 inputDataNameArray 是否爲空
        'Dim Len_inputDataNameArray As Integer
        'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
        'If Err.Number = 13 Then
        'Dim Len_inputDataNameArray As String
        Len_inputDataNameArray = ""
        Len_inputDataNameArray = Trim(Join(inputDataNameArray))
        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
        '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
        '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
        '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
        '    Next j
        'Next i
        'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
        If Len(Len_inputDataNameArray) > 0 Then

            '判斷數組 inputDataNameArray 是否爲空
            'Dim Len_inputDataArray As Integer
            'Len_inputDataArray = UBound(inputDataArray, 1)
            'If Err.Number = 13 Then
            '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
            '    '刷新控制面板窗體控件中包含的提示標簽顯示值
            '    If Not (QuantitativeTradeControlPanel.Controls("calculate_status_Label") Is Nothing) Then
            '        QuantitativeTradeControlPanel.Controls("calculate_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 QuantitativeTradeControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“QuantitativeTradeControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            '    End If
            '    Exit Sub
            'End If
            'Dim Len_inputDataArray As String
            Len_inputDataArray = ""
            'Len_inputDataArray = Trim(Join(inputDataArray))
            For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                    'Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                    Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
                Next j
            Next i
            Len_inputDataArray = Trim(Len_inputDataArray)
            If Len(Len_inputDataArray) > 0 Then

                '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於統計運算的原始數據的自定義標志名稱字段值字符串和對應的數據;
                'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                ReDim columnDataArray(0): Rem 清空數組，釋放内存
                'Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                Len_empty = 0
                For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

                    If (CStr(inputDataNameArray(j)) = "configFile") Or (CStr(inputDataNameArray(j)) = "input_K_Line") Or (CStr(inputDataNameArray(j)) = "is_save_JLD") Or (CStr(inputDataNameArray(j)) = "output_jld_K_Line") Or (CStr(inputDataNameArray(j)) = "is_save_pickle") Or (CStr(inputDataNameArray(j)) = "output_pickle_K_Line") Or (CStr(inputDataNameArray(j)) = "is_save_csv") Or (CStr(inputDataNameArray(j)) = "output_csv_K_Line") Or (CStr(inputDataNameArray(j)) = "is_save_xlsx") Or (CStr(inputDataNameArray(j)) = "output_xlsx_K_Line") _
                    Or (CStr(inputDataNameArray(j)) = "Cleaned_K_Line") _
                    Or (CStr(inputDataNameArray(j)) = "trading_direction") Or (CStr(inputDataNameArray(j)) = "ticker_symbol") Or (CStr(inputDataNameArray(j)) = "is_Optimize") Or (CStr(inputDataNameArray(j)) = "MarketTiming_Pdata_0") Or (CStr(inputDataNameArray(j)) = "MarketTiming_Plower") Or (CStr(inputDataNameArray(j)) = "MarketTiming_Pupper") Or (CStr(inputDataNameArray(j)) = "MarketTiming_weight") _
                    Or (CStr(inputDataNameArray(j)) = "PickStock_Pdata_0") Or (CStr(inputDataNameArray(j)) = "PickStock_Plower") Or (CStr(inputDataNameArray(j)) = "PickStock_Pupper") Or (CStr(inputDataNameArray(j)) = "PickStock_weight") _
                    Or (CStr(inputDataNameArray(j)) = "SizePosition_Pdata_0") Or (CStr(inputDataNameArray(j)) = "SizePosition_Plower") Or (CStr(inputDataNameArray(j)) = "SizePosition_Pupper") Or (CStr(inputDataNameArray(j)) = "SizePosition_weight") _
                    Or (CStr(inputDataNameArray(j)) = "risk_threshold") Or (CStr(inputDataNameArray(j)) = "training_sequence_length") Or (CStr(inputDataNameArray(j)) = "training_ticker_symbol") Or (CStr(inputDataNameArray(j)) = "testing_sequence_length") Or (CStr(inputDataNameArray(j)) = "testing_ticker_symbol") _
                    Or (CStr(inputDataNameArray(j)) = "training_data_file") Or (CStr(inputDataNameArray(j)) = "testing_data_file") Or (CStr(inputDataNameArray(j)) = "stepping_data_file") Then

                        '遍歷讀取逐列的數據推入一維數組
                        'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                        ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                        For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                            'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                            'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                            '判斷數組 inputDataArray 當前元素是否爲空字符串
                            '對於 inputDataArray As Object 類型的數組，可以使用 inputDataArray(i, j) Is Nothing 方法判斷判斷元素是爲 Nothing 值（只適用於 As Object 類型的數組），對於 inputDataArray As Variant 類型的數組，可以使用：IsEmpty(inputDataArray(i, j)) 方法判斷元素是否爲空，使用：IsError(inputDataArray(i, j)) 方法判斷元素是否爲 Excel 的：#N/A、#VALUE!、#REF!、#DIV/0!、#NUM!、#NAME?、#NULL! 錯誤值，使用：IsNull(inputDataArray(i, j)) 方法判斷元素是否爲 null 值，使用：Len(Trim(inputDataArray(i, j))) = 0 來判斷元素是否爲空字符串（""）、空格（Space）、制表符（Tabulation）值;
                            If IsEmpty(inputDataArray(i, j)) And (Not (IsError(inputDataArray(i, j)) Or IsNull(inputDataArray(i, j)))) Then
                                Len_empty = Len_empty + 1: Rem 將數組 inputDataArray 元素爲空字符串（""）的數目遞進加一;
                                columnDataArray(i) = CStr("null")
                            Else
                                columnDataArray(i) = inputDataArray(i, j)
                            End If
                            'Debug.Print columnDataArray(i)
                        Next i
                        'Debug.Print LBound(columnDataArray)
                        'Debug.Print UBound(columnDataArray)

                        '重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                        If Len_empty <> 0 Then
                            If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
                                ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem 重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                            Else
                                'ReDim columnDataArray(0): Rem 清空數組
                                Erase columnDataArray: Rem 函數 Erase() 表示置空數組
                            End If
                        End If
                        'Debug.Print LBound(columnDataArray)
                        'Debug.Print UBound(columnDataArray)

                        'Dim Len_columnDataArray As String
                        Len_columnDataArray = ""
                        'Len_columnDataArray = Trim(Join(columnDataArray))
                        For k = LBound(columnDataArray) To UBound(columnDataArray)
                            'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                            Len_columnDataArray = Len_columnDataArray & columnDataArray(k)
                        Next k
                        Len_columnDataArray = Trim(Len_columnDataArray)
                        If Len(Len_columnDataArray) > 0 Then

                            Select Case Statistics_Algorithm_Name

                                Case Is = "KLineCleaning"

                                    Select Case CStr(inputDataNameArray(j))

                                        Case Is = "configFile"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "input_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "is_save_JLD"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "output_jld_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "is_save_pickle"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "output_pickle_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "is_save_csv"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "output_csv_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "is_save_xlsx"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "output_xlsx_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "Cleaned_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Else

                                    End Select

                                Case Is = "MarketTiming"

                                    Select Case CStr(inputDataNameArray(j))

                                        Case Is = "trading_direction"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "ticker_symbol"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "is_Optimize"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "MarketTiming_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "Cleaned_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "training_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "testing_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "stepping_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Else

                                    End Select

                                Case Is = "PickStock"

                                    Select Case CStr(inputDataNameArray(j))

                                        Case Is = "trading_direction"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "ticker_symbol"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "is_Optimize"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "MarketTiming_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "Cleaned_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "training_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "testing_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "stepping_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Else

                                    End Select

                                Case Is = "SizePosition"

                                    Select Case CStr(inputDataNameArray(j))

                                        Case Is = "trading_direction"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "ticker_symbol"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "is_Optimize"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "MarketTiming_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                ElseIf (CStr(columnDataArray(k)) = "average") Or (CStr(columnDataArray(k)) = "Average") Or (CStr(columnDataArray(k)) = "AVERAGE") Or (CStr(columnDataArray(k)) = "mean") Or (CStr(columnDataArray(k)) = "Mean") Or (CStr(columnDataArray(k)) = "MEAN") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "Cleaned_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "training_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "testing_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "stepping_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Else

                                    End Select

                                Case Is = "BackTesting"

                                    Select Case CStr(inputDataNameArray(j))

                                        Case Is = "trading_direction"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "ticker_symbol"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "is_Optimize"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "MarketTiming_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "MarketTiming_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "PickStock_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_Pdata_0"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_Plower"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_Pupper"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "SizePosition_weight"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                If (CStr(columnDataArray(k)) = "Infinity") Or (CStr(columnDataArray(k)) = "-Infinity") Or (CStr(columnDataArray(k)) = "+Infinity") Or (CStr(columnDataArray(k)) = "infinity") Or (CStr(columnDataArray(k)) = "-infinity") Or (CStr(columnDataArray(k)) = "+infinity") Or (CStr(columnDataArray(k)) = "Inf") Or (CStr(columnDataArray(k)) = "-Inf") Or (CStr(columnDataArray(k)) = "+Inf") Or (CStr(columnDataArray(k)) = "inf") Or (CStr(columnDataArray(k)) = "-inf") Or (CStr(columnDataArray(k)) = "+inf") Or (CStr(columnDataArray(k)) = "INF") Or (CStr(columnDataArray(k)) = "-INF") Or (CStr(columnDataArray(k)) = "+INF") Then
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                                Else
                                                    Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & CStr(columnDataArray(k)) & ","
                                                End If
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "risk_threshold"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "training_sequence_length"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "training_ticker_symbol"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "testing_sequence_length"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "testing_ticker_symbol"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=["

                                            For k = LBound(columnDataArray) To UBound(columnDataArray)
                                                'Debug.Print "columnDataArray:(" & k & ") = " & columnDataArray(k)
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & Chr(34) & CStr(columnDataArray(k)) & Chr(34) & ","
                                            Next k

                                            '判斷，若字符串末尾爲逗號（,）字符，則刪除;
                                            If Chr(Right(Public_Statistics_Algorithm_Server_Url, 1)) = "," Then
                                                Public_Statistics_Algorithm_Server_Url = CStr(Mid(Public_Statistics_Algorithm_Server_Url, 1, Len(Public_Statistics_Algorithm_Server_Url) - 1))
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            Else
                                                Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "]"
                                            End If

                                        Case Is = "Cleaned_K_Line"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "training_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "testing_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Is = "stepping_data_file"

                                            Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url & "&" & CStr(inputDataNameArray(j)) & "=" & CStr(columnDataArray(LBound(columnDataArray)))

                                        Case Else

                                    End Select

                                Case Is = "Interpolation"

                                Case Is = "Polynomial3Fit"

                                Case Is = "LC5PFit"

                                Case Else

                            End Select

                        End If
                        'Debug.Print Public_Statistics_Algorithm_Server_Url

                    End If

                Next j

            End If

        End If

        'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
        Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
        'ReDim inputDataArray(0): Rem 清空數組，釋放内存
        Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
        Len_empty = 0: Rem 釋放内存
        'ReDim columnDataArray(0): Rem 清空數組，釋放内存
        Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
        Len_columnDataArray = 0: Rem 釋放内存

    End If


    ''為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（統計算法模塊名稱字符串類型）變量賦初值
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_module_name") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_module_name = Public_Statistics_Algorithm_module_name
    'End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於存儲計算結果的數據庫服務器網址，字符串型）變量賦初值。函數 CStr() 表示轉換爲字符串類型
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Database_Server_Url_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Database_Server_Url_TextBox_name).Value = CStr(Public_Database_Server_Url)
        StatisticsAlgorithmControlPanel.Controls(Database_Server_Url_TextBox_name).Text = CStr(Public_Database_Server_Url)
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於存儲計算結果的容器類型複選框值字符串）變量賦初值，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")。函數 CStr() 表示轉換爲字符串類型
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_Receptors") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_Receptors = CStr(Public_Data_Receptors)
    End If
    'Debug.Print StatisticsAlgorithmControlPanel.Public_Data_Receptors
    '判斷子框架控件是否存在
    If Not (StatisticsAlgorithmControlPanel.Controls(Data_Receptors_Frame_name) Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In StatisticsAlgorithmControlPanel.Controls(Data_Receptors_Frame_name).Controls
            If Public_Data_Receptors = "Excel_and_Database" Then
                '判斷複選框控件的顯示值字符串，函數 CStr() 表示强制轉換爲字符串類型，並據此設定複選框控件的選中狀態
                If (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(0))) Or (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(1))) Then
                    element_i.Value = True: Rem 設置複選框控件的選中狀態，結果為布爾型。
                Else
                    element_i.Value = False: Rem 設置複選框控件的選中狀態，結果為布爾型。
                End If
            Else
                '判斷複選框控件的顯示值字符串，函數 CStr() 表示强制轉換爲字符串類型，並據此設定複選框控件的選中狀態
                If CStr(element_i.Caption) = CStr(Public_Data_Receptors) Then
                    element_i.Value = True: Rem 設置複選框控件的選中狀態，結果為布爾型。
                Else
                    element_i.Value = False: Rem 設置複選框控件的選中狀態，結果為布爾型。
                End If
            End If
        Next
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於提供統計運算的服務器網址，字符串型）變量賦初值。函數 CStr() 表示轉換爲字符串類型
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Statistics_Algorithm_Server_Url_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Statistics_Algorithm_Server_Url_TextBox_name).Value = CStr(Public_Statistics_Algorithm_Server_Url)
        StatisticsAlgorithmControlPanel.Controls(Statistics_Algorithm_Server_Url_TextBox_name).Text = CStr(Public_Statistics_Algorithm_Server_Url)
    End If

    ''為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（表示判斷選擇使用的辨識統計算法種類單選框值字符串）變量賦初值，可以取值：("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") 等自定義的算法名稱值字符串。函數 CStr() 表示轉換爲字符串類型;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Name") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name = CStr(Public_Statistics_Algorithm_Name)
    'End If
    ''Debug.Print StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name
    ''判斷子框架控件是否存在
    'If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame") Is Nothing) Then
    '    '遍歷框架中包含的子元素。
    '    'Dim element_i
    '    For Each element_i In StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame").Controls
    '        '判斷單選框控件的顯示值字符串，函數 CStr() 表示强制轉換爲字符串類型，並據此設定複選框控件的選中狀態
    '        If CStr(element_i.Caption) = CStr(Public_Statistics_Algorithm_Name) Then
    '            element_i.Value = True: Rem 設置單選框的選中狀態，結果為布爾型。函數 CStr() 表示轉換爲字符串類型。
    '            'Exit For
    '        Else
    '            element_i.Value = False: Rem 設置單選框的選中狀態，結果為布爾型。函數 CStr() 表示轉換爲字符串類型。
    '            'Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing
    'End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於向提供統計運算服務器驗證的賬戶名字符串）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Username") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Username_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Username_TextBox_name).Value = Public_Statistics_Algorithm_Server_Username
        StatisticsAlgorithmControlPanel.Controls(Username_TextBox_name).Text = Public_Statistics_Algorithm_Server_Username
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（用於向提供統計運算服務器驗證的賬戶密碼字符串）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Password") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Password_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Password_TextBox_name).Value = Public_Statistics_Algorithm_Server_Password
        StatisticsAlgorithmControlPanel.Controls(Password_TextBox_name).Text = Public_Statistics_Algorithm_Server_Password
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量賦初值。函數 CLng() 表示强制轉換為長整型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name) Is Nothing) Then
        If CLng(Public_Delay_length_input) = CLng(0) Then
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Value = ""
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Value = CStr(Public_Delay_length_input): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為長整型。
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Text = CStr(Public_Delay_length_input): Rem 為文本輸入框控件的 .Text 屬性賦值，結果為長整型。
        End If
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量賦初值。函數 CSng() 表示强制轉換為單精度浮點型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name) Is Nothing) Then
        If CSng(Public_Delay_length_input) = CSng(0#) Then
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Value = ""
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Value = CStr(Public_Delay_length_random_input): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為單精度浮點型。
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Text = CStr(Public_Delay_length_random_input): Rem 為文本輸入框控件的 .Text 屬性賦值，結果為單精度浮點型。
        End If
    End If
    
    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（人爲延時等待的時長，單位毫秒，長整型）變量賦初值。函數 CLng() 表示强制轉換為長整型;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length = CLng(Public_Delay_length)
    End If


    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（待計算的數據字段命名值在Excel表格中的傳入位置，字符串型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_name_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_name_input_position = Public_Data_name_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Field_name_of_Data_Input_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Field_name_of_Data_Input_TextBox_name).Value = CStr(Public_Data_name_input_position): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
        StatisticsAlgorithmControlPanel.Controls(Field_name_of_Data_Input_TextBox_name).Text = CStr(Public_Data_name_input_position): Rem 為文本輸入框控件的 .Text 屬性賦值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（待計算的數據字段在Excel表格中的傳入位置，字符串型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_input_position = Public_Data_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Data_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Data_TextBox_name).Value = CStr(Public_Data_input_position): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
        StatisticsAlgorithmControlPanel.Controls(Data_TextBox_name).Text = CStr(Public_Data_input_position): Rem 為文本輸入框控件的 .Text 屬性賦值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
    End If

    '為操作面板窗口控件 StatisticsAlgorithmControlPanel 中包含的（計算之後的結果輸出在Excel表格中的傳入位置，字符串型）變量賦初值
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Result_output_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Result_output_position = Public_Result_output_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Output_position_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Output_position_TextBox_name).Value = CStr(Public_Result_output_position): Rem 為文本輸入框控件的 .Value 屬性賦值，結果為短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
        StatisticsAlgorithmControlPanel.Controls(Output_position_TextBox_name).Text = CStr(Public_Result_output_position): Rem 為文本輸入框控件的 .Text 屬性賦值，結果爲短整型變量，函數 CInt() 表示强制轉換為短整型，函數 CStr() 表示强制轉換為字符串類型;
    End If

End Sub


'自定義啓動運算;
Public Sub startCalculate(ByVal Statistics_Algorithm_Name As String, ByVal Data_Receptors As String, ByVal Database_Server_Url As String, ByVal Statistics_Algorithm_Server_Url As String, ByVal Statistics_Algorithm_Server_Username As String, ByVal Statistics_Algorithm_Server_Password As String, ByVal Data_name_input_position As String, ByVal Data_input_position As String, ByVal Result_output_position As String, ParamArray OtherArgs())
'最後一個參數 ParamArray OtherArgs() 表示可變參數，預設值為空 "" 字符串，可傳入 ("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") 等自定義的算法名稱值字符串之一。
'調用示例：Call StatisticsAlgorithmModule.startCalculate(Public_Statistics_Algorithm_Name, Public_Data_Receptors, Public_Database_Server_Url, Public_Statistics_Algorithm_Server_Url, Public_Statistics_Algorithm_Server_Username, Public_Statistics_Algorithm_Server_Password, Public_Data_name_input_position, Public_Data_input_position, Public_Result_output_position, "test")
'需要事先完成如下操作：
'控制臺命令行啓動 Julia 統計算法服務器：C:\>C:\Criss\Julia\Julia-1.6.2\bin\julia.exe -p 4 --project=C:/Criss/jl/ C:\Criss\jl\src\Router.jl
'或者
'控制臺命令行啓動 Python 統計算法服務器：C:\>C:\Criss\Python\Python38\python.exe C:\Criss\py\src\Router.py
'控制臺命令行啓動 Python 統計算法服務器：C:\>C:\Criss\py\Scripts\python.exe C:\Criss\py\src\Router.py
'參數 C:\Criss\py\Scripts\python.exe 表示使用隔離環境 py 中的 python.exe 啓動運行;
'控制臺命令行啓動 MongoDB 數據庫服務器端應用：C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
'控制臺命令行啓動用於鏈接操作 MongoDB 數據庫服務器端應用的自定義的 Node.js 服務器：C:\Criss\DatabaseServer\MongoDB>C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:\Criss\DatabaseServer\MongoDB\Nodejs2MongodbServer.js host=0.0.0.0 port=27016 number_cluster_Workers=0 MongodbHost=0.0.0.0 MongodbPort=27017 dbUser=admin_MathematicalStatisticsData dbPass=admin dbName=MathematicalStatisticsData
'控制臺命令行啓動 MongoDB 數據庫客戶端應用：C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongo.exe mongodb://127.0.0.1:27017/MathematicalStatisticsData
'（注意，這一步操作不必須，不是必須啓動  MongoDB 數據庫客戶端應用，可以選擇不啓動）


    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。

    Dim i, j, k As Integer: Rem 整型，記錄 for 循環次數變量


    ''循環讀取傳入的全部可變參數的值
    'Dim OtherArgsValues As String
    'Dim i As Integer
    'For i = 0 To UBound(OtherArgs)
    '    OtherArgsValues = OtherArgsValues & "/n" & OtherArgs(i)
    'Next
    'Debug.Print OtherArgsValues: Rem ("InternetExplorer", "Edge", "Chrome", "Firefox")

    Dim OtherArgs_Statistics_Algorithm_Name As String
    If (UBound(OtherArgs) > -1) And OtherArgs(LBound(OtherArgs)) <> "" Then
        OtherArgs_Statistics_Algorithm_Name = CStr(OtherArgs(LBound(OtherArgs)))
    Else
        OtherArgs_Statistics_Algorithm_Name = "LC5PFit": Rem 判斷自定義選擇的統計算法種類，可以取值：("test", "Interpolation", "Logistic", "Cox", "LC5PFit")
    End If
    'Debug.Print OtherArgs(LBound(OtherArgs))
    'Debug.Print OtherArgs_Statistics_Algorithm_Name


    ''更改按鈕狀態和標志
    'PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
    'If Not (StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton") Is Nothing) Then
    '    Select Case PublicVariableStartORStopButtonClickState
    '        Case True
    '            StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton").Caption = CStr("Start calculate")
    '        Case False
    '            StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton").Caption = CStr("Stop calculate")
    '        Case Else
    '            MsgBox "Start or Stop Calculate Button" & "\\n" & "Private Sub Start_calculate_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
    '    End Select
    'End If
    ''刷新操作面板窗體控件中的變量值
    ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
    ''為操作面板窗體控件 StatisticsAlgorithmControlPanel 中包含的（監測窗體中啓動運算按钮控件的點擊狀態，布爾型）變量更新賦值
    'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    'End If
    ''判斷是否跳出子過程不繼續執行後面的動作
    'If PublicVariableStartORStopButtonClickState Then

    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
    '    'If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '    '    StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "運算過程被中止.": Rem 提示運算過程執行狀態，賦值給標簽控件 calculate_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“calculate_status_Label”的“text”屬性值 calculate_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    '    'End If

    '    ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
    '    ''刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("StatisticsAlgorithmModule")
    '    'StatisticsAlgorithmModule.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState: Rem 為導入的爬蟲策略模塊 StatisticsAlgorithmModule 中包含的（監測窗體中啓動運算按钮控件的點擊狀態，布爾型）變量更新賦值
    '    ''Debug.Print VBA.TypeName(StatisticsAlgorithmModule)
    '    ''Debug.Print VBA.TypeName(StatisticsAlgorithmModule.PublicVariableStartORStopButtonClickState)
    '    ''Debug.Print StatisticsAlgorithmModule.PublicVariableStartORStopButtonClickState
    '    ''Application.Evaluate Public_Statistics_Algorithm_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
    '    ''Application.Run Public_Statistics_Algorithm_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"

    '    '使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    '    If Not (StatisticsAlgorithmControlPanel.Controls("delay") Is Nothing) Then
    '        Call StatisticsAlgorithmControlPanel.delay(StatisticsAlgorithmControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    '    End If

    '    StatisticsAlgorithmControlPanel.Start_calculate_CommandButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的按鈕控件 Start_calculate_CommandButton（啓動運算按鈕），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的多選框控件 Data_Receptors_CheckBox1（用於判斷辨識選擇計算結果保存類型 Database 的多選框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的多選框控件 Data_Receptors_CheckBox2（用於判斷辨識選擇計算結果保存類型 Excel 的多選框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Statistics_Algorithm_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Statistics_Algorithm_Server_Url_TextBox（提供統計算法的服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供統計算法的服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供統計算法的服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Field_name_of_Data_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Field_name_of_Data_Input_TextBox（保存原始數據字段命名 Excel 表格保存區間的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Data_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Data_TextBox（保存原始數據的 Excel 表格保存區間的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Output_position_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Output_position_TextBox（保存計算結果的 Excel 表格區間的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.FisherDiscriminant_OptionButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的單選框控件 FisherDiscriminant_OptionButton（用於標識選擇某一個具體算法 FisherDiscriminant 的單選框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Interpolate_OptionButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的單選框控件 Interpolate_OptionButton（用於標識選擇某一個具體算法 Interpolate 的單選框），False 表示禁用點擊，True 表示可以點擊
    '    StatisticsAlgorithmControlPanel.Logistic_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Cox_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Polynomial3_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.LC5p_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.PCA_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Factor_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.TimeSeries_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Meta_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Optimal_run_length_estimate_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Test_accuracy_estimate_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Test_power_estimate_OptionButton.Enabled = True: Rem
    '    StatisticsAlgorithmControlPanel.Statistical_sampling_OptionButton.Enabled = True: Rem

    '    Exit Sub

    'End If


    '從控制面板窗體中包含的文本輸入框中讀取值，刷新待計算的數據字段命名值在Excel表格中的傳入位置字符串;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox") Is Nothing) Then
    '    'Public_Data_name_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A1:H1 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$H$1，即：Public_Data_name_input_position = "$A$1:$H$1"。
    '    Public_Data_name_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A1:H1 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$H$1，即：Public_Data_name_input_position = "$A$1:$H$1"。
    'End If
    'Debug.Print Public_Data_name_input_position
    ''刷新控制面板窗體中包含的變量，待計算的數據字段命名值在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_name_input_position") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Data_name_input_position = Public_Data_name_input_position
    'End If
    'Dim Data_name_input_position As String
    'Data_name_input_position = Public_Data_name_input_position

    Dim Data_name_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Data_name_input_sheetName = ""
    Dim Data_name_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Data_name_input_rangePosition = ""
    If (Data_name_input_position <> "") And (InStr(1, Data_name_input_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Data_name_input_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Data_name_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Data_name_input_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Data_name_input_rangePosition = "": Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Data_name_input_rangePosition = Data_name_input_rangePosition & CStr(tempArr(i)): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Data_name_input_rangePosition = Data_name_input_rangePosition & "!" & CStr(tempArr(i)): Rem 待計算的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Data_name_input_sheetName & ", " & Data_name_input_rangePosition
    Else
        Data_name_input_rangePosition = Data_name_input_position
    End If


    ''從控制面板窗體中包含的文本輸入框中讀取值，刷新待計算的數據字段在Excel表格中的傳入位置字符串;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Data_TextBox") Is Nothing) Then
    '    'Public_Data_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A2:H12 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$H$12，即：Public_Data_input_position = "$A$2:$H$12"。
    '    Public_Data_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A2:H12 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$H$12，即：Public_Data_input_position = "$A$2:$H$12"。
    'End If
    'Debug.Print Public_Data_input_position
    ''刷新控制面板窗體中包含的變量，待計算的數據字段在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_input_position") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Data_input_position = Public_Data_input_position
    'End If
    'Dim Data_input_position As String
    'Data_input_position = Public_Data_input_position

    Dim Data_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Data_input_sheetName = ""
    Dim Data_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Data_input_rangePosition = ""
    If (Data_input_position <> "") And (InStr(1, Data_input_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Data_input_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Data_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Data_input_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待計算的數據字段在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Data_input_rangePosition = "": Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Data_input_rangePosition = Data_input_rangePosition & CStr(tempArr(i)): Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Data_input_rangePosition = Data_input_rangePosition & "!" & CStr(tempArr(i)): Rem 待計算的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Data_input_sheetName & ", " & Data_input_rangePosition
    Else
        Data_input_rangePosition = Data_input_position
    End If


    ''從控制面板窗體中包含的文本輸入框中讀取值，刷新計算之後的結果輸出在Excel表格中的傳入位置字符串;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox") Is Nothing) Then
    '    'Public_Result_output_position = CStr(StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!J1:L5 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5，即：Public_Result_output_position = "$J$1:$L$5"。
    '    Public_Result_output_position = CStr(StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!J1:L5 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5，即：Public_Result_output_position = "$J$1:$L$5"。
    'End If
    'Debug.Print Public_Result_output_position
    ''刷新控制面板窗體中包含的變量，計算之後的結果輸出在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Result_output_position") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Result_output_position = Public_Result_output_position
    'End If
    'Dim Result_output_position As String
    'Result_output_position = Public_Result_output_position

    Dim Result_output_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Result_output_sheetName = ""
    Dim Result_output_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Result_output_rangePosition = ""
    If (Result_output_position <> "") And (InStr(1, Result_output_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Result_output_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Result_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem 計算之後的結果輸出在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Result_output_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 計算之後的結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Result_output_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Result_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem 計算之後的結果輸出在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Result_output_rangePosition = "": Rem 計算之後的結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Result_output_rangePosition = Result_output_rangePosition & CStr(tempArr(i)): Rem 計算之後的結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Result_output_rangePosition = Result_output_rangePosition & "!" & CStr(tempArr(i)): Rem 計算之後的結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Result_output_sheetName & ", " & Result_output_rangePosition
    Else
        Result_output_rangePosition = Result_output_position
    End If


    ''刷新用於保存計算結果的數據庫服務器網址 URL 字符串
    'If Not (StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Value)
    '    Public_Database_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    'End If
    ''Debug.Print "Database Server Url = " & "[ " & Public_Database_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_Server_Url 值。
    ''刷新控制面板窗體中包含的變量，用於保存計算結果的數據庫服務器網址 URL 字符串，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    'End If
    'Dim Database_Server_Url As String
    'Database_Server_Url = Public_Database_Server_Url

    ''用於存儲采集結果的容器類型複選框值，字符串變量，可取 "Database"，"Excel_and_Database"，"Excel" 值，例如取值：CStr("Excel")
    ''判斷子框架控件是否存在
    'If Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
    '    Public_Data_Receptors = ""
    '    '遍歷框架中包含的子元素。
    '    Dim element_i
    '    For Each element_i In StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame").Controls
    '        '判斷複選框控件的選中狀態
    '        If element_i.Value Then
    '            If Public_Data_Receptors = "" Then
    '                Public_Data_Receptors = CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            Else
    '                Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            End If
    '        End If
    '    Next
    '    Set element_i = Nothing
    '    'If (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    '    Public_Data_Receptors = CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '    'ElseIf (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    '    Public_Data_Receptors = CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '    'ElseIf (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    '    Public_Data_Receptors = CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem 從複選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '    'ElseIf (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    '    Public_Data_Receptors = ""
    '    'Else
    '    'End If

    '    'Debug.Print "Data Receptors = " & "[ " & Public_Data_Receptors & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Data_Receptors 值。
    '    '刷新控制面板窗體中包含的變量，用於存儲采集結果的容器類型複選框值，字符串類型的變量;
    '    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_Receptors") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Public_Data_Receptors = Public_Data_Receptors
    '    End If
    'End If
    'Dim Data_Receptors As String
    'Data_Receptors = Public_Data_Receptors

    ''刷新提供統計算法的服務器網址 URL 字符串
    'If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Statistics_Algorithm_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Value)
    '    Public_Statistics_Algorithm_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    'End If
    ''Debug.Print "Statistics Algorithm Server Url = " & "[ " & Public_Statistics_Algorithm_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Statistics_Algorithm_Server_Url 值。
    ''刷新控制面板窗體中包含的變量，提供統計算法的服務器網址 URL 字符串，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Url") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url
    'End If
    'Dim Statistics_Algorithm_Server_Url As String
    'Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url

    ''判別辨識選擇指定某一個具體的統計算法種類，字符串型變量，可以取值：("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") 等自定義的算法名稱值字符串。函數 CStr() 表示轉換爲字符串類型，例如取值：CStr(2)
    ''判斷子框架控件是否存在
    'If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame") Is Nothing) Then
    '    '遍歷框架中包含的子元素。
    '    'Dim element_i
    '    For Each element_i In StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame").Controls
    '        '判斷單選框控件的選中狀態
    '        If element_i.Value Then
    '            Public_Statistics_Algorithm_Name = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing

    '    'Debug.Print "Statistics Algorithm name = " & "[ " & Public_Statistics_Algorithm_Name & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Statistics_Algorithm_Name 值。
    '    '刷新控制面板窗體中包含的變量，用於判別辨識選擇指定某一個具體的統計算法種類的標志，字符串類型的變量;
    '    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Name") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name = Public_Statistics_Algorithm_Name
    '    End If
    'End If
    'Dim Statistics_Algorithm_Name As String
    'Statistics_Algorithm_Name = Public_Statistics_Algorithm_Name

    ''刷新用於驗證提供統計算法的服務器的賬戶名字符串
    'If Not (StatisticsAlgorithmControlPanel.Controls("Username_TextBox") Is Nothing) Then
    '    'Public_Statistics_Algorithm_Server_Username = CStr(StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Value)
    '    Public_Statistics_Algorithm_Server_Username = CStr(StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Text)
    'End If
    ''Debug.Print "Statistics Algorithm Server Username = " & "[ " & Public_Statistics_Algorithm_Server_Username & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Statistics_Algorithm_Server_Username 值。
    ''刷新控制面板窗體中包含的變量，用於驗證提供統計算法的服務器的賬戶名字符串，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Username") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username
    'End If
    'Dim Statistics_Algorithm_Server_Username As String
    'Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username

    ''刷新用於驗證提供統計算法的服務器的賬戶密碼字符串
    'If Not (StatisticsAlgorithmControlPanel.Controls("Password_TextBox") Is Nothing) Then
    '    'Public_Statistics_Algorithm_Server_Password = CStr(StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Value)
    '    Public_Statistics_Algorithm_Server_Password = CStr(StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Text)
    'End If
    ''Debug.Print "Statistics Algorithm Server Password = " & "[ " & Public_Statistics_Algorithm_Server_Password & " ]"
    ''刷新控制面板窗體中包含的變量，用於驗證提供統計算法的服務器的賬戶密碼字符串，字符串類型的變量;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Password") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password
    'End If
    'Dim Statistics_Algorithm_Server_Password As String
    'Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password


    '整型數據能表示的數據範圍：-32768 ~ 32767
    '長整型數據能表示的數據範圍：-2147483648 ~ 2147483647
    '單精度浮點型，在表示負數時，能表示的數據範圍：-3.402823 × E38 ~ -1.401298 × E-45
    '單精度浮點型，在表示正數時，能表示的數據範圍：1.401298 × E-45 ~ 3.402823 × E38
    '雙精度浮點型，在表示負數時，能表示的數據範圍：-1.79769313486231 × E308 ~ -4.94065645841247 × E-324
    '雙精度浮點型，在表示負數時，能表示的數據範圍：4.94065645841247 × E-324 ~ 1.79769313486231 × E308
    '注意，單精度浮點型數據，其精度是：6，即只能保存小數點後最多 6 位小數的數據，雙精度浮點型，其精度是：14，即只能保存小數點後最多 14 位小數的數據，如果超出以上長度，則超出部分會被刪除，並且會自動四捨五入。


    '刷新控制面板窗體控件中包含的提示標簽顯示值
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "讀取 Excel 表格中的數據 read data …": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    End If


    Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

    Dim inputDataNameArray() As Variant: Rem Variant、String 聲明一個不定長二維數組變量，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim inputDataNameArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    Dim inputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim inputDataArray(0 To X_UBound, 0 To Y_UBound) As Single: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式

    Dim Data_Dict As Object  '函數返回值字典，記錄向算法服務器發送的，用於統計運算的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
    Set Data_Dict = CreateObject("Scripting.Dictionary")

    Dim requestJSONText As String: Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
    requestJSONText = ""

    '使用第三方模組（Module）：clsJsConverter，將原始數據字典 Data_Dict 轉換爲向算法服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
    Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。


    'Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

    'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串


    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
    If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
        Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
        MsgBox "用於統計運算的原始數據的自定義標志名稱字段的 Excel 表格的選擇範圍（Data name input = " & CStr(Public_Data_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
        Exit Sub
    Else
    End If
    'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    'inputDataNameArray = RNG: Rem RNG.Value2
    '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    For i = 1 To RNG.Rows.Count
        For j = 1 To RNG.Columns.Count
            'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
            inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
            'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
        Next j
    Next i
    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
    '    Debug.Print "inputDataNameArray:(" & i & ") = " & inputDataNameArray(i)
    '    'For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
    '    '    Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
    '    'Next j
    'Next i

    If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
        Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
    ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
    ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
        MsgBox "用於統計運算的原始數據值的 Excel 表格的選擇範圍（Data input = " & CStr(Public_Data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
        Exit Sub
    Else
    End If
    ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    inputDataArray = RNG: Rem RNG.Value2
    ''使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    'For i = 1 To RNG.Rows.Count
    '    For j = 1 To RNG.Columns.Count
    '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
    '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
    '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
    '    Next j
    'Next i
    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
    'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
    '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
    '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
    '    Next j
    'Next i

    'Dim Data_Dict As Object  '函數返回值字典，記錄向算法服務器發送的，用於統計運算的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
    'Set Data_Dict = CreateObject("Scripting.Dictionary")
    'Debug.Print Data_Dict.Count

    '判斷數組 inputDataNameArray 是否爲空
    'Dim Len_inputDataArray As Integer
    'Len_inputDataArray = UBound(inputDataArray, 1)
    'If Err.Number = 13 Then
    '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
    '    '刷新控制面板窗體控件中包含的提示標簽顯示值
    '    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    '    End If
    '    Exit Sub
    'End If
    Dim Len_inputDataArray As String
    Len_inputDataArray = ""
    'Len_inputDataArray = Trim(Join(inputDataArray))
    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
            'Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
            Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
        Next j
    Next i
    Len_inputDataArray = Trim(Len_inputDataArray)
    If Len(Len_inputDataArray) = 0 Then
        MsgBox "保存用於統計運算的原始數據的二維數組爲空."
        '刷新控制面板窗體控件中包含的提示標簽顯示值
        If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
        End If
        Exit Sub
    End If

    '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於統計運算的原始數據的自定義標志名稱字段值字符串和對應的數據;
    Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

        '遍歷讀取逐列的數據推入一維數組
        'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
        For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
            'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
            'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
            '判斷數組 inputDataArray 當前元素是否爲空字符串
            '對於 inputDataArray As Object 類型的數組，可以使用 inputDataArray(i, j) Is Nothing 方法判斷判斷元素是爲 Nothing 值（只適用於 As Object 類型的數組），對於 inputDataArray As Variant 類型的數組，可以使用：IsEmpty(inputDataArray(i, j)) 方法判斷元素是否爲空，使用：IsError(inputDataArray(i, j)) 方法判斷元素是否爲 Excel 的：#N/A、#VALUE!、#REF!、#DIV/0!、#NUM!、#NAME?、#NULL! 錯誤值，使用：IsNull(inputDataArray(i, j)) 方法判斷元素是否爲 null 值，使用：Len(Trim(inputDataArray(i, j))) = 0 來判斷元素是否爲空字符串（""）、空格（Space）、制表符（Tabulation）值;
            If IsEmpty(inputDataArray(i, j)) And (Not (IsError(inputDataArray(i, j)) Or IsNull(inputDataArray(i, j)))) Then
                Len_empty = Len_empty + 1: Rem 將數組 inputDataArray 元素爲空字符串（""）的數目遞進加一;
                columnDataArray(i) = CStr("null")
            Else
                columnDataArray(i) = inputDataArray(i, j)
            End If
            'Debug.Print columnDataArray(i)
        Next i
        'Debug.Print LBound(columnDataArray)
        'Debug.Print UBound(columnDataArray)

        '重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
        If Len_empty <> 0 Then
            If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
                ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem 重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
            Else
                'ReDim columnDataArray(0): Rem 清空數組
                Erase columnDataArray: Rem 函數 Erase() 表示置空數組
            End If
        End If
        'Debug.Print LBound(columnDataArray)
        'Debug.Print UBound(columnDataArray)

        '判斷數組 inputDataNameArray 是否爲空
        'Dim Len_inputDataNameArray As Integer
        'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
        'If Err.Number = 13 Then
        Dim Len_inputDataNameArray As String
        Len_inputDataNameArray = ""
        Len_inputDataNameArray = Trim(Join(inputDataNameArray))
        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
        '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
        '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
        '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
        '    Next j
        'Next i
        'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
        If Len(Len_inputDataNameArray) = 0 Then

            '檢查字典中是否已經指定的鍵值對
            If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
                Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
            Else
                Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
            End If

        ElseIf inputDataNameArray(j) = "" Then

            '檢查字典中是否已經指定的鍵值對
            If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
                Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
            Else
                Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
            End If

        Else

            If CStr(inputDataNameArray(j) = "training_data") Then

                '檢查字典中是否已經指定的鍵值對
                If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then

                    'Data_Dict.Item(CStr(inputDataNameArray(j))) = Data_Dict_training_data: Rem 刷新字典指定的鍵值對

                Else

                    Dim Data_Dict_training_data As Object  '訓練數據集字典，需要用到第三方模組（Module）字典變量;
                    Set Data_Dict_training_data = CreateObject("Scripting.Dictionary")

                    Data_Dict.Add CStr(inputDataNameArray(j)), Data_Dict_training_data: Rem 字典新增指定的鍵值對

                End If


                If UBound(columnDataArray) - LBound(columnDataArray) >= 0 Then

                    If Data_Dict.Item(CStr(inputDataNameArray(j))).Exists(CStr(columnDataArray(LBound(columnDataArray)))) Then

                        'Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))) = Data_Dict_training_data_ticker: Rem 刷新字典指定的鍵值對

                    Else

                        Dim Data_Dict_training_data_ticker As Object  '訓練數據集字典，需要用到第三方模組（Module）字典變量;
                        Set Data_Dict_training_data_ticker = CreateObject("Scripting.Dictionary")

                        Data_Dict.Item(CStr(inputDataNameArray(j))).Add CStr(columnDataArray(LBound(columnDataArray))), Data_Dict_training_data_ticker: Rem 字典新增指定的鍵值對

                    End If


                    If UBound(columnDataArray) - LBound(columnDataArray) >= 1 Then

                        If Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Exists(CStr(columnDataArray(LBound(columnDataArray) + 1))) Then

                            Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Item(CStr(columnDataArray(LBound(columnDataArray) + 1))) = Filter(Filter(columnDataArray, columnDataArray(LBound(columnDataArray)), False, vbBinaryCompare), columnDataArray(LBound(columnDataArray) + 1), False, vbBinaryCompare): Rem 刷新字典指定的鍵值對
                            '函數 Filter(sourceArray, matchString, [include], [compare]) 用於篩選數組中的元素，基於指定的條件返回一個新數組，而不會修改原始數組;
                            '説明：
                            '必選參數：sourceArray 表示原始數組;
                            '必選參數：matchString 表示篩選條件字符串，可以是單個值，或是一個表達式，例如取 ">3" 表示篩選大於 3 的元素;
                            '可選參數：include 預設爲 True 值，若取 True 值表示函數返回值爲所有匹配的元素構成的一個新的數組，若取 False 值表示函數返回值爲所有不匹配元素構成的一個新數組;
                            '可選參數：compare 表示用於指定比較的變量類型（如文本比較或二進位比較），預設值爲 vbBinaryCompare 值，若取 vbTextCompare 值表示進行文本比較;

                        Else

                            Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Add CStr(columnDataArray(LBound(columnDataArray) + 1)), Filter(Filter(columnDataArray, columnDataArray(LBound(columnDataArray)), False, vbBinaryCompare), columnDataArray(LBound(columnDataArray) + 1), False, vbBinaryCompare): Rem 字典新增指定的鍵值對
                            '函數 Filter(sourceArray, matchString, [include], [compare]) 用於篩選數組中的元素，基於指定的條件返回一個新數組，而不會修改原始數組;
                            '説明：
                            '必選參數：sourceArray 表示原始數組;
                            '必選參數：matchString 表示篩選條件字符串，可以是單個值，或是一個表達式，例如取 ">3" 表示篩選大於 3 的元素;
                            '可選參數：include 預設爲 True 值，若取 True 值表示函數返回值爲所有匹配的元素構成的一個新的數組，若取 False 值表示函數返回值爲所有不匹配元素構成的一個新數組;
                            '可選參數：compare 表示用於指定比較的變量類型（如文本比較或二進位比較），預設值爲 vbBinaryCompare 值，若取 vbTextCompare 值表示進行文本比較;

                        End If

                    End If

                End If

            ElseIf CStr(inputDataNameArray(j)) = "testing_data" Then

                '檢查字典中是否已經指定的鍵值對
                If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then

                    'Data_Dict.Item(CStr(inputDataNameArray(j))) = Data_Dict_testing_data: Rem 刷新字典指定的鍵值對

                Else

                    Dim Data_Dict_testing_data As Object  '訓練數據集字典，需要用到第三方模組（Module）字典變量;
                    Set Data_Dict_testing_data = CreateObject("Scripting.Dictionary")

                    Data_Dict.Add CStr(inputDataNameArray(j)), Data_Dict_testing_data: Rem 字典新增指定的鍵值對

                End If


                If UBound(columnDataArray) - LBound(columnDataArray) >= 0 Then

                    If Data_Dict.Item(CStr(inputDataNameArray(j))).Exists(CStr(columnDataArray(LBound(columnDataArray)))) Then

                        'Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))) = Data_Dict_testing_data_ticker: Rem 刷新字典指定的鍵值對

                    Else

                        Dim Data_Dict_testing_data_ticker As Object  '訓練數據集字典，需要用到第三方模組（Module）字典變量;
                        Set Data_Dict_testing_data_ticker = CreateObject("Scripting.Dictionary")

                        Data_Dict.Item(CStr(inputDataNameArray(j))).Add CStr(columnDataArray(LBound(columnDataArray))), Data_Dict_testing_data_ticker: Rem 字典新增指定的鍵值對

                    End If


                    If UBound(columnDataArray) - LBound(columnDataArray) >= 1 Then

                        If Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Exists(CStr(columnDataArray(LBound(columnDataArray) + 1))) Then

                            Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Item(CStr(columnDataArray(LBound(columnDataArray) + 1))) = Filter(Filter(columnDataArray, columnDataArray(LBound(columnDataArray)), False, vbBinaryCompare), columnDataArray(LBound(columnDataArray) + 1), False, vbBinaryCompare): Rem 刷新字典指定的鍵值對
                            '函數 Filter(sourceArray, matchString, [include], [compare]) 用於篩選數組中的元素，基於指定的條件返回一個新數組，而不會修改原始數組;
                            '説明：
                            '必選參數：sourceArray 表示原始數組;
                            '必選參數：matchString 表示篩選條件字符串，可以是單個值，或是一個表達式，例如取 ">3" 表示篩選大於 3 的元素;
                            '可選參數：include 預設爲 True 值，若取 True 值表示函數返回值爲所有匹配的元素構成的一個新的數組，若取 False 值表示函數返回值爲所有不匹配元素構成的一個新數組;
                            '可選參數：compare 表示用於指定比較的變量類型（如文本比較或二進位比較），預設值爲 vbBinaryCompare 值，若取 vbTextCompare 值表示進行文本比較;

                        Else

                            Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Add CStr(columnDataArray(LBound(columnDataArray) + 1)), Filter(Filter(columnDataArray, columnDataArray(LBound(columnDataArray)), False, vbBinaryCompare), columnDataArray(LBound(columnDataArray) + 1), False, vbBinaryCompare): Rem 字典新增指定的鍵值對
                            '函數 Filter(sourceArray, matchString, [include], [compare]) 用於篩選數組中的元素，基於指定的條件返回一個新數組，而不會修改原始數組;
                            '説明：
                            '必選參數：sourceArray 表示原始數組;
                            '必選參數：matchString 表示篩選條件字符串，可以是單個值，或是一個表達式，例如取 ">3" 表示篩選大於 3 的元素;
                            '可選參數：include 預設爲 True 值，若取 True 值表示函數返回值爲所有匹配的元素構成的一個新的數組，若取 False 值表示函數返回值爲所有不匹配元素構成的一個新數組;
                            '可選參數：compare 表示用於指定比較的變量類型（如文本比較或二進位比較），預設值爲 vbBinaryCompare 值，若取 vbTextCompare 值表示進行文本比較;

                        End If

                    End If

                End If

            ElseIf CStr(inputDataNameArray(j)) = "stepping_data" Then

                '檢查字典中是否已經指定的鍵值對
                If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then

                    'Data_Dict.Item(CStr(inputDataNameArray(j))) = Data_Dict_stepping_data: Rem 刷新字典指定的鍵值對

                Else

                    Dim Data_Dict_stepping_data As Object  '訓練數據集字典，需要用到第三方模組（Module）字典變量;
                    Set Data_Dict_stepping_data = CreateObject("Scripting.Dictionary")

                    Data_Dict.Add CStr(inputDataNameArray(j)), Data_Dict_stepping_data: Rem 字典新增指定的鍵值對

                End If


                If UBound(columnDataArray) - LBound(columnDataArray) >= 0 Then

                    If Data_Dict.Item(CStr(inputDataNameArray(j))).Exists(CStr(columnDataArray(LBound(columnDataArray)))) Then

                        'Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))) = Data_Dict_stepping_data_ticker: Rem 刷新字典指定的鍵值對

                    Else

                        Dim Data_Dict_stepping_data_ticker As Object  '訓練數據集字典，需要用到第三方模組（Module）字典變量;
                        Set Data_Dict_stepping_data_ticker = CreateObject("Scripting.Dictionary")

                        Data_Dict.Item(CStr(inputDataNameArray(j))).Add CStr(columnDataArray(LBound(columnDataArray))), Data_Dict_stepping_data_ticker: Rem 字典新增指定的鍵值對

                    End If


                    If UBound(columnDataArray) - LBound(columnDataArray) >= 1 Then

                        If Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Exists(CStr(columnDataArray(LBound(columnDataArray) + 1))) Then

                            Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Item(CStr(columnDataArray(LBound(columnDataArray) + 1))) = Filter(Filter(columnDataArray, columnDataArray(LBound(columnDataArray)), False, vbBinaryCompare), columnDataArray(LBound(columnDataArray) + 1), False, vbBinaryCompare): Rem 刷新字典指定的鍵值對
                            '函數 Filter(sourceArray, matchString, [include], [compare]) 用於篩選數組中的元素，基於指定的條件返回一個新數組，而不會修改原始數組;
                            '説明：
                            '必選參數：sourceArray 表示原始數組;
                            '必選參數：matchString 表示篩選條件字符串，可以是單個值，或是一個表達式，例如取 ">3" 表示篩選大於 3 的元素;
                            '可選參數：include 預設爲 True 值，若取 True 值表示函數返回值爲所有匹配的元素構成的一個新的數組，若取 False 值表示函數返回值爲所有不匹配元素構成的一個新數組;
                            '可選參數：compare 表示用於指定比較的變量類型（如文本比較或二進位比較），預設值爲 vbBinaryCompare 值，若取 vbTextCompare 值表示進行文本比較;

                        Else

                            Data_Dict.Item(CStr(inputDataNameArray(j))).Item(CStr(columnDataArray(LBound(columnDataArray)))).Add CStr(columnDataArray(LBound(columnDataArray) + 1)), Filter(Filter(columnDataArray, columnDataArray(LBound(columnDataArray)), False, vbBinaryCompare), columnDataArray(LBound(columnDataArray) + 1), False, vbBinaryCompare): Rem 字典新增指定的鍵值對
                            '函數 Filter(sourceArray, matchString, [include], [compare]) 用於篩選數組中的元素，基於指定的條件返回一個新數組，而不會修改原始數組;
                            '説明：
                            '必選參數：sourceArray 表示原始數組;
                            '必選參數：matchString 表示篩選條件字符串，可以是單個值，或是一個表達式，例如取 ">3" 表示篩選大於 3 的元素;
                            '可選參數：include 預設爲 True 值，若取 True 值表示函數返回值爲所有匹配的元素構成的一個新的數組，若取 False 值表示函數返回值爲所有不匹配元素構成的一個新數組;
                            '可選參數：compare 表示用於指定比較的變量類型（如文本比較或二進位比較），預設值爲 vbBinaryCompare 值，若取 vbTextCompare 值表示進行文本比較;

                        End If

                    End If

                End If

            Else

                '檢查字典中是否已經指定的鍵值對
                If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then
                    Data_Dict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                Else
                    Data_Dict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem 字典新增指定的鍵值對
                End If

            End If

        End If
        'Debug.Print Data_Dict.Item(CStr(inputDataNameArray(j)))

    Next j
    'Debug.Print Data_Dict.Count
    'Debug.Print LBound(Data_Dict.Keys())
    'Debug.Print UBound(Data_Dict.Keys())
    'For i = LBound(Data_Dict.Keys()) To UBound(Data_Dict.Keys())
    '    'Debug.Print Data_Dict.Keys()(i)
    '    'Debug.Print LBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i))))
    '    'Debug.Print UBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i))))
    '    For j = LBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i)))) To UBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i))))
    '        Debug.Print Data_Dict.Keys()(i) & ":(" & j & ") = " & Data_Dict.Item(Data_Dict.Keys()(i))(j)
    '    Next j
    'Next i

    'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
    Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
    'ReDim inputDataArray(0): Rem 清空數組，釋放内存
    Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
    Len_empty = 0
    'ReDim columnDataArray(0): Rem 清空數組，釋放内存
    Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

    Dim columnsDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 trainYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '依次判斷數組 trainYdata-1、2、3 是否爲空
    'Dim Len_trainYdata1 As Integer
    'Len_trainYdata1 = UBound(Data_Dict("trainYdata_1"), 1)
    'Dim Len_trainYdata2 As Integer
    'Len_trainYdata2 = UBound(Data_Dict("trainYdata_2"), 1)
    'Dim Len_trainYdata3 As Integer
    'Len_trainYdata3 = UBound(Data_Dict("trainYdata_3"), 1)
    'If Err.Number <> 13 Then
    Dim Len_trainYdata1 As String
    Len_trainYdata1 = ""
    If Data_Dict.Exists("trainYdata_1") Then
        Len_trainYdata1 = Trim(Join(Data_Dict("trainYdata_1")))
        'For i = LBound(Data_Dict("trainYdata_1"), 1) To UBound(Data_Dict("trainYdata_1"), 1)
        '    For j = LBound(Data_Dict("trainYdata_1"), 2) To UBound(Data_Dict("trainYdata_1"), 2)
        '        'Debug.Print "Data_Dict(""trainYdata_1""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_1")(i, j)
        '        Len_trainYdata1 = Len_trainYdata1 & Data_Dict("trainYdata_1")(i, j)
        '    Next j
        'Next i
        'Len_trainYdata1 = Trim(Len_trainYdata1)
    End If
    Dim Len_trainYdata2 As String
    Len_trainYdata2 = ""
    If Data_Dict.Exists("trainYdata_2") Then
        Len_trainYdata2 = Trim(Join(Data_Dict("trainYdata_2")))
        'For i = LBound(Data_Dict("trainYdata_2"), 1) To UBound(Data_Dict("trainYdata_2"), 1)
        '    For j = LBound(Data_Dict("trainYdata_2"), 2) To UBound(Data_Dict("trainYdata_2"), 2)
        '        'Debug.Print "Data_Dict(""trainYdata_2""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_2")(i, j)
        '        Len_trainYdata2 = Len_trainYdata2 & Data_Dict("trainYdata_2")(i, j)
        '    Next j
        'Next i
        'Len_trainYdata2 = Trim(Len_trainYdata2)
    End If
    Dim Len_trainYdata3 As String
    Len_trainYdata3 = ""
    If Data_Dict.Exists("trainYdata_3") Then
        Len_trainYdata3 = Trim(Join(Data_Dict("trainYdata_3")))
        'For i = LBound(Data_Dict("trainYdata_3"), 1) To UBound(Data_Dict("trainYdata_3"), 1)
        '    For j = LBound(Data_Dict("trainYdata_3"), 2) To UBound(Data_Dict("trainYdata_3"), 2)
        '        'Debug.Print "Data_Dict(""trainYdata_3""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_3")(i, j)
        '        Len_trainYdata3 = Len_trainYdata3 & Data_Dict("trainYdata_3")(i, j)
        '    Next j
        'Next i
        'Len_trainYdata3 = Trim(Len_trainYdata3)
    End If
    Dim Len_trainYdata4 As String
    Len_trainYdata4 = ""
    If Data_Dict.Exists("trainYdata_4") Then
        Len_trainYdata4 = Trim(Join(Data_Dict("trainYdata_4")))
        'For i = LBound(Data_Dict("trainYdata_4"), 1) To UBound(Data_Dict("trainYdata_4"), 1)
        '    For j = LBound(Data_Dict("trainYdata_4"), 2) To UBound(Data_Dict("trainYdata_4"), 2)
        '        'Debug.Print "Data_Dict(""trainYdata_4""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_4")(i, j)
        '        Len_trainYdata4 = Len_trainYdata4 & Data_Dict("trainYdata_4")(i, j)
        '    Next j
        'Next i
        'Len_trainYdata4 = Trim(Len_trainYdata4)
    End If
    Dim Len_trainYdata5 As String
    Len_trainYdata5 = ""
    If Data_Dict.Exists("trainYdata_5") Then
        Len_trainYdata5 = Trim(Join(Data_Dict("trainYdata_5")))
        'For i = LBound(Data_Dict("trainYdata_5"), 1) To UBound(Data_Dict("trainYdata_5"), 1)
        '    For j = LBound(Data_Dict("trainYdata_5"), 2) To UBound(Data_Dict("trainYdata_5"), 2)
        '        'Debug.Print "Data_Dict(""trainYdata_5""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_5")(i, j)
        '        Len_trainYdata5 = Len_trainYdata5 & Data_Dict("trainYdata_5")(i, j)
        '    Next j
        'Next i
        'Len_trainYdata5 = Trim(Len_trainYdata5)
    End If
    If (Data_Dict.Exists("trainYdata_1") And Len(Len_trainYdata1) <> 0) Or (Data_Dict.Exists("trainYdata_2") And Len(Len_trainYdata2) <> 0) Or (Data_Dict.Exists("trainYdata_3") And Len(Len_trainYdata3) <> 0) Or (Data_Dict.Exists("trainYdata_4") And Len(Len_trainYdata4) <> 0) Or (Data_Dict.Exists("trainYdata_5") And Len(Len_trainYdata5) <> 0) Then
        ReDim columnsDataArray(LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據中 trainYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        For i = LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))
            Dim rowtrainYdataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 trainYdata-1、2、3 中每一行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
            If Data_Dict.Exists("trainYdata_1") And Len(Len_trainYdata1) <> 0 Then
                ReDim rowtrainYdataArray(1 To 1) As Variant
                rowtrainYdataArray(1) = Data_Dict("trainYdata_1")(i)
            End If
            If Data_Dict.Exists("trainYdata_2") And Len(Len_trainYdata2) <> 0 Then
                ReDim Preserve rowtrainYdataArray(1 To 2) As Variant
                rowtrainYdataArray(2) = Data_Dict("trainYdata_2")(i)
            End If
            If Data_Dict.Exists("trainYdata_3") And Len(Len_trainYdata3) <> 0 Then
                ReDim Preserve rowtrainYdataArray(1 To 3) As Variant
                rowtrainYdataArray(3) = Data_Dict("trainYdata_3")(i)
            End If
            If Data_Dict.Exists("trainYdata_4") And Len(Len_trainYdata4) <> 0 Then
                ReDim Preserve rowtrainYdataArray(1 To 4) As Variant
                rowtrainYdataArray(4) = Data_Dict("trainYdata_4")(i)
            End If
            If Data_Dict.Exists("trainYdata_5") And Len(Len_trainYdata5) <> 0 Then
                ReDim Preserve rowtrainYdataArray(1 To 5) As Variant
                rowtrainYdataArray(5) = Data_Dict("trainYdata_5")(i)
            End If
            columnsDataArray(i) = rowtrainYdataArray
        Next i
    End If
    '檢查字典中是否已經指定的鍵值對
    If Data_Dict.Exists("trainYdata") Then
        Dim Len_trainYdata As String
        Len_trainYdata = ""
        Len_trainYdata = Trim(Join(Data_Dict("trainYdata")))
        If Len(Len_trainYdata) <> 0 Then
            ReDim columnsDataArray(LBound(Data_Dict("trainYdata")) To UBound(Data_Dict("trainYdata"))) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據中 trainYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
            For i = LBound(Data_Dict("trainYdata")) To UBound(Data_Dict("trainYdata"))
                'Dim rowtrainYdataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 trainYdata-1、2、3 中每一行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                ReDim rowtrainYdataArray(1 To 1) As Variant
                rowtrainYdataArray(1) = Data_Dict("trainYdata")(i)
                columnsDataArray(i) = rowtrainYdataArray
            Next i
            Data_Dict.Item("trainYdata") = columnsDataArray: Rem 刷新字典指定的鍵值對
        End If
    ElseIf (Data_Dict.Exists("trainYdata_1") And Len(Len_trainYdata1) <> 0) Or (Data_Dict.Exists("trainYdata_2") And Len(Len_trainYdata2) <> 0) Or (Data_Dict.Exists("trainYdata_3") And Len(Len_trainYdata3) <> 0) Or (Data_Dict.Exists("trainYdata_4") And Len(Len_trainYdata4) <> 0) Or (Data_Dict.Exists("trainYdata_5") And Len(Len_trainYdata5) <> 0) Then
        Data_Dict.Add "trainYdata", columnsDataArray: Rem 字典新增指定的鍵值對
    Else
        'ReDim columnsDataArray(0) As Variant
        'Data_Dict.Add "trainYdata", columnsDataArray: Rem 字典新增指定的鍵值對，爲空數組
    End If

    ''刪除字典 Data_Dict 中的條目 "trainYdata_1"
    'If Data_Dict.Exists("trainYdata_1") Then
    '    Data_Dict.Remove ("trainYdata_1")
    'End If
    ''刪除字典 Data_Dict 中的條目 "trainYdata_2"
    'If Data_Dict.Exists("trainYdata_2") Then
    '    Data_Dict.Remove ("trainYdata_2")
    'End If
    ''刪除字典 Data_Dict 中的條目 "trainYdata_3"
    'If Data_Dict.Exists("trainYdata_3") Then
    '    Data_Dict.Remove ("trainYdata_3")
    'End If
    ''刪除字典 Data_Dict 中的條目 "trainYdata_4"
    'If Data_Dict.Exists("trainYdata_4") Then
    '    Data_Dict.Remove ("trainYdata_4")
    'End If
    ''刪除字典 Data_Dict 中的條目 "trainYdata_5"
    'If Data_Dict.Exists("trainYdata_5") Then
    '    Data_Dict.Remove ("trainYdata_5")
    'End If

    '依次判斷數組 testYdata-1、2、3 是否爲空
    'Dim Len_testYdata1 As Integer
    'Len_testYdata1 = UBound(Data_Dict("testYdata_1"), 1)
    'Dim Len_testYdata2 As Integer
    'Len_testYdata2 = UBound(Data_Dict("testYdata_2"), 1)
    'Dim Len_testYdata3 As Integer
    'Len_testYdata3 = UBound(Data_Dict("testYdata_3"), 1)
    'If Err.Number <> 13 Then
    Dim Len_testYdata1 As String
    Len_testYdata1 = ""
    If Data_Dict.Exists("testYdata_1") Then
        Len_testYdata1 = Trim(Join(Data_Dict("testYdata_1")))
        'For i = LBound(Data_Dict("testYdata_1"), 1) To UBound(Data_Dict("testYdata_1"), 1)
        '    For j = LBound(Data_Dict("testYdata_1"), 2) To UBound(Data_Dict("testYdata_1"), 2)
        '        'Debug.Print "Data_Dict(""testYdata_1""):(" & i & ", " & j & ") = " & Data_Dict("testYdata_1")(i, j)
        '        Len_testYdata1 = Len_testYdata1 & Data_Dict("testYdata_1")(i, j)
        '    Next j
        'Next i
        'Len_testYdata1 = Trim(Len_testYdata1)
    End If
    Dim Len_testYdata2 As String
    Len_testYdata2 = ""
    If Data_Dict.Exists("testYdata_2") Then
        Len_testYdata2 = Trim(Join(Data_Dict("testYdata_2")))
        'For i = LBound(Data_Dict("testYdata_2"), 1) To UBound(Data_Dict("testYdata_2"), 1)
        '    For j = LBound(Data_Dict("testYdata_2"), 2) To UBound(Data_Dict("testYdata_2"), 2)
        '        'Debug.Print "Data_Dict(""testYdata_2""):(" & i & ", " & j & ") = " & Data_Dict("testYdata_2")(i, j)
        '        Len_testYdata2 = Len_testYdata2 & Data_Dict("testYdata_2")(i, j)
        '    Next j
        'Next i
        'Len_testYdata2 = Trim(Len_testYdata2)
    End If
    Dim Len_testYdata3 As String
    Len_testYdata3 = ""
    If Data_Dict.Exists("testYdata_3") Then
        Len_testYdata3 = Trim(Join(Data_Dict("testYdata_3")))
        'For i = LBound(Data_Dict("testYdata_3"), 1) To UBound(Data_Dict("testYdata_3"), 1)
        '    For j = LBound(Data_Dict("testYdata_3"), 2) To UBound(Data_Dict("testYdata_3"), 2)
        '        'Debug.Print "Data_Dict(""testYdata_3""):(" & i & ", " & j & ") = " & Data_Dict("testYdata_3")(i, j)
        '        Len_testYdata3 = Len_testYdata3 & Data_Dict("testYdata_3")(i, j)
        '    Next j
        'Next i
        'Len_testYdata3 = Trim(Len_testYdata3)
    End If
    If (Data_Dict.Exists("testYdata_1") And Len(Len_testYdata1) <> 0) Or (Data_Dict.Exists("testYdata_2") And Len(Len_testYdata2) <> 0) Or (Data_Dict.Exists("testYdata_3") And Len(Len_testYdata3) <> 0) Then
        ReDim columnsDataArray(LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據中 testYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
        For i = LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))
            Dim rowtestYdataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 testYdata-1、2、3 中每一行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
            If Data_Dict.Exists("testYdata_1") And Len(Len_testYdata1) <> 0 Then
                ReDim rowtestYdataArray(1 To 1) As Variant
                rowtestYdataArray(1) = Data_Dict("testYdata_1")(i)
            End If
            If Data_Dict.Exists("testYdata_2") And Len(Len_testYdata2) <> 0 Then
                ReDim Preserve rowtestYdataArray(1 To 2) As Variant
                rowtestYdataArray(2) = Data_Dict("testYdata_2")(i)
            End If
            If Data_Dict.Exists("testYdata_3") And Len(Len_testYdata3) <> 0 Then
                ReDim Preserve rowtestYdataArray(1 To 3) As Variant
                rowtestYdataArray(3) = Data_Dict("testYdata_3")(i)
            End If
            columnsDataArray(i) = rowtestYdataArray
        Next i
    End If
    '檢查字典中是否已經指定的鍵值對
    If Data_Dict.Exists("testYdata") Then
        Dim Len_testYdata As String
        Len_testYdata = ""
        Len_testYdata = Trim(Join(Data_Dict("testYdata")))
        If Len(Len_testYdata) <> 0 Then
            ReDim columnsDataArray(LBound(Data_Dict("testYdata")) To UBound(Data_Dict("testYdata"))) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據中 testYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
            For i = LBound(Data_Dict("testYdata")) To UBound(Data_Dict("testYdata"))
                'Dim rowtestYdataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 testYdata-1、2、3 中每一行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                ReDim rowtestYdataArray(1 To 1) As Variant
                rowtestYdataArray(1) = Data_Dict("testYdata")(i)
                columnsDataArray(i) = rowtestYdataArray
            Next i
            Data_Dict.Item("testYdata") = columnsDataArray: Rem 刷新字典指定的鍵值對
        End If
    ElseIf (Data_Dict.Exists("testYdata_1") And Len(Len_testYdata1) <> 0) Or (Data_Dict.Exists("testYdata_2") And Len(Len_testYdata2) <> 0) Or (Data_Dict.Exists("testYdata_3") And Len(Len_testYdata3) <> 0) Then
        Data_Dict.Add "testYdata", columnsDataArray: Rem 字典新增指定的鍵值對
    Else
        'ReDim columnsDataArray(0) As Variant
        'Data_Dict.Add "testYdata", columnsDataArray: Rem 字典新增指定的鍵值對，爲空數組
    End If

    ''刪除字典 Data_Dict 中的條目 "testYdata_1"
    'If Data_Dict.Exists("testYdata_1") Then
    '    Data_Dict.Remove ("testYdata_1")
    'End If
    ''刪除字典 Data_Dict 中的條目 "testYdata_2"
    'If Data_Dict.Exists("testYdata_2") Then
    '    Data_Dict.Remove ("testYdata_2")
    'End If
    ''刪除字典 Data_Dict 中的條目 "testYdata_3"
    'If Data_Dict.Exists("testYdata_3") Then
    '    Data_Dict.Remove ("testYdata_3")
    'End If


    ''將保存計算結果的二維數組變量 resultDataArray 手動轉換爲對應的 JSON 格式的字符串;
    'Dim columnName() As String: Rem 二維數組數據各字段（各列）名稱字符串一維數組;
    'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem 二維數組數據各字段（各列）名稱字符串一維數組;
    'columnName(1) = "Column_1"
    'columnName(2) = "Column_2"
    ''For i = 1 To UBound(columnName, 1)
    ''    Debug.Print columnName(i)
    ''Next i

    'Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
    'PostCode = ""
    'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""一級"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""二級"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""二級"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""二級"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""二級"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""二級""}"
    'PostCode = "{" & """Column_1""" & ":" & """" & CStr(inputDataArray(1, 1)) & """" & "," _
    '         & """Column_2""" & ":" & """" & CStr(inputDataArray(1, 2)) & """" & "}" _
    '         & """Column_3""" & ":" & """" & CStr(inputDataArray(1, 3)) & """" & "," _
    '         & """Column_4""" & ":" & """" & CStr(inputDataArray(1, 4)) & """" & "," _
    '         & """Column_5""" & ":" & """" & CStr(inputDataArray(1, 5)) & """" & "," _
    '         & """Column_6""" & ":" & """" & CStr(inputDataArray(1, 6)) & """" & "," _
    '         & """Column_7""" & ":" & """" & CStr(inputDataArray(1, 7)) & """" & "," _
    '         & """Column_8""" & ":" & """" & CStr(inputDataArray(1, 8)) & """" & "," _
    '         & """Column_9""" & ":" & """" & CStr(inputDataArray(1, 9)) & """" & "," _
    '         & """Column_10""" & ":" & """" & CStr(inputDataArray(1, 10)) & """" & "," _
    '         & """Column_11""" & ":" & """" & CStr(inputDataArray(1, 11)) & """" & "," _
    '         & """Column_12""" & ":" & """" & CStr(inputDataArray(1, 12)) & """" & "}"

    ''使用 For 循環嵌套遍歷的方法，將一維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    'For i = 1 To UBound(inputDataArray, 1)
    '    PostCode = ""
    '    For j = 1 To UBound(inputDataArray, 2)
    '        If (j = 1) Then
    '            If (UBound(inputDataArray, 2) > 1) Then
    '                PostCode = PostCode & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '            End If
    '            If (UBound(inputDataArray, 2) = 1) Then
    '                PostCode = PostCode & "'" & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
    '            End If
    '        End If
    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '        End If
    '        If (j = UBound(inputDataArray, 2)) Then
    '            If (UBound(inputDataArray, 2) > 1) Then
    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & "]"
    '            End If
    '            If (UBound(inputDataArray, 2) = 1) Then
    '                PostCode = PostCode & "}" & "]"
    '            End If
    '        End If
    '    Next j
    '    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

    '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

    '    WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
    '    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

    '    '讀取服務器返回的響應值
    '    WHR.Response.write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
    '    WHR.Response.write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
    '    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

    '    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
    '    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
    '    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
    '    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
    '    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
    '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

    '    Response_Text = WHR.responseText
    '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '    'Debug.Print Response_Text

    'Next i


    ''使用 For 循環嵌套遍歷的方法，將二維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    'PostCode = "["
    'For i = 1 To UBound(inputDataArray, 1)
    '    For j = 1 To UBound(inputDataArray, 2)
    '        If (j = 1) Then
    '            If (UBound(inputDataArray, 2) > 1) Then
    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '            End If
    '            If (UBound(inputDataArray, 2) = 1) Then
    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
    '            End If
    '        End If
    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '        End If
    '        If (i < UBound(inputDataArray, 1)) Then
    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & ","
    '            End If
    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
    '                PostCode = PostCode & "}" & ","
    '            End If
    '        End If
    '        If (i = UBound(inputDataArray, 1)) Then
    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}"
    '            End If
    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
    '                PostCode = PostCode & "}"
    '            End If
    '        End If
    '    Next j
    'Next i
    'PostCode = PostCode & "]"
    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。


    '使用第三方模組（Module）：clsJsConverter，將原始數據字典 Data_Dict 轉換爲向算法服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
    'requestJSONText = JsonConverter.ConvertToJson(Data_Dict, Whitespace:=2): Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
    requestJSONText = JsonConverter.ConvertToJson(Data_Dict): Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
    'Debug.Print requestJSONText

    'ReDim columnsDataArray(0): Rem 清空數組，釋放内存
    Erase columnsDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
    Data_Dict.RemoveAll: Rem 清空字典，釋放内存
    Set Data_Dict = Nothing: Rem 清空對象變量“Data_Dict”，釋放内存


    'Select Case Statistics_Algorithm_Name

    '    Case Is = "Interpolation"

    '    Case Is = "Logistic"

    '    Case Is = "Cox"

    '    Case Is = "Polynomial3Fit"

    '    Case Is = "LC5PFit"

    '        'Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem 導入的統計算法模塊的自定義命名值字符串（當前所處的模塊名）

    '        'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    '        'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串

    '        'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

    '        If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
    '        ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
    '        ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
    '            MsgBox "用於統計運算的原始數據的自定義標志名稱字段的 Excel 表格的選擇範圍（Data name input = " & CStr(Public_Data_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
    '            Exit Sub
    '        Else
    '        End If
    '        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    '        'inputDataNameArray = RNG: Rem RNG.Value2
    '        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    '        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放待計算的原始數據的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    '        For i = 1 To RNG.Rows.Count
    '            For j = 1 To RNG.Columns.Count
    '                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
    '                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
    '                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
    '            Next j
    '        Next i
    '        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存

    '        If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
    '        ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
    '        ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
    '            MsgBox "用於統計運算的原始數據值的 Excel 表格的選擇範圍（Data input = " & CStr(Public_Data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
    '            Exit Sub
    '        Else
    '        End If
    '        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '        inputDataArray = RNG: Rem RNG.Value2
    '        ''使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    '        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '        'For i = 1 To RNG.Rows.Count
    '        '    For j = 1 To RNG.Columns.Count
    '        '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
    '        '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
    '        '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value2: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
    '        '    Next j
    '        'Next i
    '        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存

    '        'Dim Data_Dict As Object  '函數返回值字典，記錄向算法服務器發送的，用於統計運算的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
    '        'Set Data_Dict = CreateObject("Scripting.Dictionary")
    '        'Debug.Print Data_Dict.Count

    '        '判斷數組 inputDataNameArray 是否爲空
    '        'Dim Len_inputDataArray As Integer
    '        'Len_inputDataArray = UBound(inputDataArray, 1)
    '        'If Err.Number = 13 Then
    '        '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
    '        '    '刷新控制面板窗體控件中包含的提示標簽顯示值
    '        '    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '        '        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    '        '    End If
    '        '    Exit Sub
    '        'End If
    '        Dim Len_inputDataArray As String
    '        Len_inputDataArray = ""
    '        'Len_inputDataArray = Trim(Join(inputDataArray))
    '        For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
    '            For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
    '                'Debug.Print "inputDataArray(" & i & ", " & j & ") = " & inputDataArray(i, j)
    '                Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
    '            Next j
    '        Next i
    '        Len_inputDataArray = Trim(Len_inputDataArray)
    '        If Len(Len_inputDataArray) = 0 Then
    '            MsgBox "保存用於統計運算的原始數據的二維數組爲空."
    '            '刷新控制面板窗體控件中包含的提示標簽顯示值
    '            If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '                StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    '            End If
    '            Exit Sub
    '        End If

    '        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於統計運算的原始數據的自定義標志名稱字段值字符串和對應的數據;
    '        Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '        Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
    '        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

    '            '遍歷讀取逐列的數據推入一維數組
    '            'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '            ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '            'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
    '            Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
    '            For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
    '                'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
    '                'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '                '判斷數組 inputDataArray 當前元素是否爲空字符串
    '                '對於 inputDataArray As Object 類型的數組，可以使用 inputDataArray(i, j) Is Nothing 方法判斷判斷元素是爲 Nothing 值（只適用於 As Object 類型的數組），對於 inputDataArray As Variant 類型的數組，可以使用：IsEmpty(inputDataArray(i, j)) 方法判斷元素是否爲空，使用：IsError(inputDataArray(i, j)) 方法判斷元素是否爲 Excel 的：#N/A、#VALUE!、#REF!、#DIV/0!、#NUM!、#NAME?、#NULL! 錯誤值，使用：IsNull(inputDataArray(i, j)) 方法判斷元素是否爲 null 值，使用：Len(Trim(inputDataArray(i, j))) = 0 來判斷元素是否爲空字符串（""）、空格（Space）、制表符（Tabulation）值;
    '                If IsEmpty(inputDataArray(i, j)) And (Not (IsError(inputDataArray(i, j)) Or IsNull(inputDataArray(i, j)))) Then
    '                    Len_empty = Len_empty + 1: Rem 將數組 inputDataArray 元素爲空字符串（""）的數目遞進加一;
    '                    columnDataArray(i) = CStr("null")
    '                Else
    '                    columnDataArray(i) = inputDataArray(i, j)
    '                End If
    '                'Debug.Print columnDataArray(i)
    '            Next i
    '            'Debug.Print LBound(columnDataArray)
    '            'Debug.Print UBound(columnDataArray)

    '            '重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
    '            If Len_empty <> 0 Then
    '                If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
    '                    ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem 重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
    '                Else
    '                    'ReDim columnDataArray(0): Rem 清空數組
    '                    Erase columnDataArray: Rem 函數 Erase() 表示置空數組
    '                End If
    '            End If
    '            'Debug.Print LBound(columnDataArray)
    '            'Debug.Print UBound(columnDataArray)

    '            '判斷數組 inputDataNameArray 是否爲空
    '            'Dim Len_inputDataNameArray As Integer
    '            'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
    '            'If Err.Number = 13 Then
    '            Dim Len_inputDataNameArray As String
    '            Len_inputDataNameArray = ""
    '            Len_inputDataNameArray = Trim(Join(inputDataNameArray))
    '            'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
    '            '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
    '            '        'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
    '            '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
    '            '    Next j
    '            'Next i
    '            'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
    '            If Len(Len_inputDataNameArray) = 0 Then
    '                '檢查字典中是否已經指定的鍵值對
    '                If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
    '                    Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
    '                Else
    '                    Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
    '                End If
    '            ElseIf inputDataNameArray(j) = "" Then
    '                '檢查字典中是否已經指定的鍵值對
    '                If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
    '                    Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
    '                Else
    '                    Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
    '                End If
    '            Else
    '                '檢查字典中是否已經指定的鍵值對
    '                If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then
    '                    Data_Dict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
    '                Else
    '                    Data_Dict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem 字典新增指定的鍵值對
    '                End If
    '            End If
    '            'Debug.Print Data_Dict.Item(CStr(inputDataNameArray(j)))

    '        Next j
    '        'Debug.Print Data_Dict.Count
    '        'Debug.Print LBound(Data_Dict.Keys())
    '        'Debug.Print UBound(Data_Dict.Keys())
    '        'For i = LBound(Data_Dict.Keys()) To UBound(Data_Dict.Keys())
    '        '    'Debug.Print Data_Dict.Keys()(i)
    '        '    'Debug.Print LBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i))))
    '        '    'Debug.Print UBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i))))
    '        '    For j = LBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i)))) To UBound(Data_Dict.Item(CStr(Data_Dict.Keys()(i))))
    '        '        Debug.Print Data_Dict.Keys()(i) & ":(" & j & ") = " & Data_Dict.Item(Data_Dict.Keys()(i))(j)
    '        '    Next j
    '        'Next i

    '        'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
    '        Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
    '        'ReDim inputDataArray(0): Rem 清空數組，釋放内存
    '        Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
    '        Len_empty = 0
    '        'ReDim columnDataArray(0): Rem 清空數組，釋放内存
    '        Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

    '        Dim columnsDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 trainYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '        '依次判斷數組 trainYdata-1、2、3 是否爲空
    '        'Dim Len_trainYdata1 As Integer
    '        'Len_trainYdata1 = UBound(Data_Dict("trainYdata_1"), 1)
    '        'Dim Len_trainYdata2 As Integer
    '        'Len_trainYdata2 = UBound(Data_Dict("trainYdata_2"), 1)
    '        'Dim Len_trainYdata3 As Integer
    '        'Len_trainYdata3 = UBound(Data_Dict("trainYdata_3"), 1)
    '        'If Err.Number <> 13 Then
    '        Dim Len_trainYdata1 As String
    '        Len_trainYdata1 = ""
    '        Len_trainYdata1 = Trim(Join(Data_Dict("trainYdata_1")))
    '        'For i = LBound(Data_Dict("trainYdata_1"), 1) To UBound(Data_Dict("trainYdata_1"), 1)
    '        '    For j = LBound(Data_Dict("trainYdata_1"), 2) To UBound(Data_Dict("trainYdata_1"), 2)
    '        '        'Debug.Print "Data_Dict(""trainYdata_1""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_1")(i, j)
    '        '        Len_trainYdata1 = Len_trainYdata1 & Data_Dict("trainYdata_1")(i, j)
    '        '    Next j
    '        'Next i
    '        'Len_trainYdata1 = Trim(Len_trainYdata1)
    '        Dim Len_trainYdata2 As String
    '        Len_trainYdata2 = ""
    '        Len_trainYdata2 = Trim(Join(Data_Dict("trainYdata_2")))
    '        'For i = LBound(Data_Dict("trainYdata_2"), 1) To UBound(Data_Dict("trainYdata_2"), 1)
    '        '    For j = LBound(Data_Dict("trainYdata_2"), 2) To UBound(Data_Dict("trainYdata_2"), 2)
    '        '        'Debug.Print "Data_Dict(""trainYdata_2""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_2")(i, j)
    '        '        Len_trainYdata2 = Len_trainYdata2 & Data_Dict("trainYdata_2")(i, j)
    '        '    Next j
    '        'Next i
    '        'Len_trainYdata2 = Trim(Len_trainYdata2)
    '        Dim Len_trainYdata3 As String
    '        Len_trainYdata3 = ""
    '        Len_trainYdata3 = Trim(Join(Data_Dict("trainYdata_3")))
    '        'For i = LBound(Data_Dict("trainYdata_3"), 1) To UBound(Data_Dict("trainYdata_3"), 1)
    '        '    For j = LBound(Data_Dict("trainYdata_3"), 2) To UBound(Data_Dict("trainYdata_3"), 2)
    '        '        'Debug.Print "Data_Dict(""trainYdata_3""):(" & i & ", " & j & ") = " & Data_Dict("trainYdata_3")(i, j)
    '        '        Len_trainYdata3 = Len_trainYdata3 & Data_Dict("trainYdata_3")(i, j)
    '        '    Next j
    '        'Next i
    '        'Len_trainYdata3 = Trim(Len_trainYdata3)
    '        If Len(Len_trainYdata1) <> 0 Or Len(Len_trainYdata2) <> 0 Or Len(Len_trainYdata3) <> 0 Then
    '            ReDim columnsDataArray(LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據中 trainYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '            For i = LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))
    '                Dim rowtrainYdataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 trainYdata-1、2、3 中每一行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '                ReDim rowtrainYdataArray(1 To 3) As Variant
    '                rowtrainYdataArray(1) = Data_Dict("trainYdata_1")(i)
    '                rowtrainYdataArray(2) = Data_Dict("trainYdata_2")(i)
    '                rowtrainYdataArray(3) = Data_Dict("trainYdata_3")(i)
    '                columnsDataArray(i) = rowtrainYdataArray
    '            Next i
    '        End If
    '        '檢查字典中是否已經指定的鍵值對
    '        If Data_Dict.Exists("trainYdata") Then
    '            Data_Dict.Item("trainYdata") = columnsDataArray: Rem 刷新字典指定的鍵值對
    '        Else
    '            Data_Dict.Add "trainYdata", columnsDataArray: Rem 字典新增指定的鍵值對
    '        End If

    '        ''刪除字典 Data_Dict 中的條目 "trainYdata_1"
    '        'If Data_Dict.Exists("trainYdata_1") Then
    '        '    Data_Dict.Remove ("trainYdata_1")
    '        'End If
    '        ''刪除字典 Data_Dict 中的條目 "trainYdata_2"
    '        'If Data_Dict.Exists("trainYdata_2") Then
    '        '    Data_Dict.Remove ("trainYdata_2")
    '        'End If
    '        ''刪除字典 Data_Dict 中的條目 "trainYdata_3"
    '        'If Data_Dict.Exists("trainYdata_3") Then
    '        '    Data_Dict.Remove ("trainYdata_3")
    '        'End If

    '        '依次判斷數組 testYdata-1、2、3 是否爲空
    '        'Dim Len_testYdata1 As Integer
    '        'Len_testYdata1 = UBound(Data_Dict("testYdata_1"), 1)
    '        'Dim Len_testYdata2 As Integer
    '        'Len_testYdata2 = UBound(Data_Dict("testYdata_2"), 1)
    '        'Dim Len_testYdata3 As Integer
    '        'Len_testYdata3 = UBound(Data_Dict("testYdata_3"), 1)
    '        'If Err.Number <> 13 Then
    '        Dim Len_testYdata1 As String
    '        Len_testYdata1 = ""
    '        Len_testYdata1 = Trim(Join(Data_Dict("testYdata_1")))
    '        'For i = LBound(Data_Dict("testYdata_1"), 1) To UBound(Data_Dict("testYdata_1"), 1)
    '        '    For j = LBound(Data_Dict("testYdata_1"), 2) To UBound(Data_Dict("testYdata_1"), 2)
    '        '        'Debug.Print "Data_Dict(""testYdata_1""):(" & i & ", " & j & ") = " & Data_Dict("testYdata_1")(i, j)
    '        '        Len_testYdata1 = Len_testYdata1 & Data_Dict("testYdata_1")(i, j)
    '        '    Next j
    '        'Next i
    '        'Len_testYdata1 = Trim(Len_testYdata1)
    '        Dim Len_testYdata2 As String
    '        Len_testYdata2 = ""
    '        Len_testYdata2 = Trim(Join(Data_Dict("testYdata_2")))
    '        'For i = LBound(Data_Dict("testYdata_2"), 1) To UBound(Data_Dict("testYdata_2"), 1)
    '        '    For j = LBound(Data_Dict("testYdata_2"), 2) To UBound(Data_Dict("testYdata_2"), 2)
    '        '        'Debug.Print "Data_Dict(""testYdata_2""):(" & i & ", " & j & ") = " & Data_Dict("testYdata_2")(i, j)
    '        '        Len_testYdata2 = Len_testYdata2 & Data_Dict("testYdata_2")(i, j)
    '        '    Next j
    '        'Next i
    '        'Len_testYdata2 = Trim(Len_testYdata2)
    '        Dim Len_testYdata3 As String
    '        Len_testYdata3 = ""
    '        Len_testYdata3 = Trim(Join(Data_Dict("testYdata_3")))
    '        'For i = LBound(Data_Dict("testYdata_3"), 1) To UBound(Data_Dict("testYdata_3"), 1)
    '        '    For j = LBound(Data_Dict("testYdata_3"), 2) To UBound(Data_Dict("testYdata_3"), 2)
    '        '        'Debug.Print "Data_Dict(""testYdata_3""):(" & i & ", " & j & ") = " & Data_Dict("testYdata_3")(i, j)
    '        '        Len_testYdata3 = Len_testYdata3 & Data_Dict("testYdata_3")(i, j)
    '        '    Next j
    '        'Next i
    '        'Len_testYdata3 = Trim(Len_testYdata3)
    '        If Len(Len_testYdata1) <> 0 Or Len(Len_testYdata2) <> 0 Or Len(Len_testYdata3) <> 0 Then
    '            ReDim columnsDataArray(LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據中 testYdata-1、2、3 中所有行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '            For i = LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))
    '                Dim rowtestYdataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據中 testYdata-1、2、3 中每一行的數據值，注意 VBA 的二維數組索引是（行號，列號）格式
    '                ReDim rowtestYdataArray(1 To 3) As Variant
    '                rowtestYdataArray(1) = Data_Dict("testYdata_1")(i)
    '                rowtestYdataArray(2) = Data_Dict("testYdata_2")(i)
    '                rowtestYdataArray(3) = Data_Dict("testYdata_3")(i)
    '                columnsDataArray(i) = rowtestYdataArray
    '            Next i
    '        End If
    '        '檢查字典中是否已經指定的鍵值對
    '        If Data_Dict.Exists("testYdata") Then
    '            Data_Dict.Item("testYdata") = columnsDataArray: Rem 刷新字典指定的鍵值對
    '        Else
    '            Data_Dict.Add "testYdata", columnsDataArray: Rem 字典新增指定的鍵值對
    '        End If

    '        ''刪除字典 Data_Dict 中的條目 "testYdata_1"
    '        'If Data_Dict.Exists("testYdata_1") Then
    '        '    Data_Dict.Remove ("testYdata_1")
    '        'End If
    '        ''刪除字典 Data_Dict 中的條目 "testYdata_2"
    '        'If Data_Dict.Exists("testYdata_2") Then
    '        '    Data_Dict.Remove ("testYdata_2")
    '        'End If
    '        ''刪除字典 Data_Dict 中的條目 "testYdata_3"
    '        'If Data_Dict.Exists("testYdata_3") Then
    '        '    Data_Dict.Remove ("testYdata_3")
    '        'End If


    '        ''將保存計算結果的二維數組變量 resultDataArray 手動轉換爲對應的 JSON 格式的字符串;
    '        'Dim columnName() As String: Rem 二維數組數據各字段（各列）名稱字符串一維數組;
    '        'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem 二維數組數據各字段（各列）名稱字符串一維數組;
    '        'columnName(1) = "Column_1"
    '        'columnName(2) = "Column_2"
    '        ''For i = 1 To UBound(columnName, 1)
    '        ''    Debug.Print columnName(i)
    '        ''Next i

    '        'Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
    '        'PostCode = ""
    '        'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""一級"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""二級"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""二級"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""二級"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""二級"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""二級""}"
    '        'PostCode = "{" & """Column_1""" & ":" & """" & CStr(inputDataArray(1, 1)) & """" & "," _
    '        '         & """Column_2""" & ":" & """" & CStr(inputDataArray(1, 2)) & """" & "}" _
    '        '         & """Column_3""" & ":" & """" & CStr(inputDataArray(1, 3)) & """" & "," _
    '        '         & """Column_4""" & ":" & """" & CStr(inputDataArray(1, 4)) & """" & "," _
    '        '         & """Column_5""" & ":" & """" & CStr(inputDataArray(1, 5)) & """" & "," _
    '        '         & """Column_6""" & ":" & """" & CStr(inputDataArray(1, 6)) & """" & "," _
    '        '         & """Column_7""" & ":" & """" & CStr(inputDataArray(1, 7)) & """" & "," _
    '        '         & """Column_8""" & ":" & """" & CStr(inputDataArray(1, 8)) & """" & "," _
    '        '         & """Column_9""" & ":" & """" & CStr(inputDataArray(1, 9)) & """" & "," _
    '        '         & """Column_10""" & ":" & """" & CStr(inputDataArray(1, 10)) & """" & "," _
    '        '         & """Column_11""" & ":" & """" & CStr(inputDataArray(1, 11)) & """" & "," _
    '        '         & """Column_12""" & ":" & """" & CStr(inputDataArray(1, 12)) & """" & "}"

    '        ''使用 For 循環嵌套遍歷的方法，將一維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    '        'For i = 1 To UBound(inputDataArray, 1)
    '        '    PostCode = ""
    '        '    For j = 1 To UBound(inputDataArray, 2)
    '        '        If (j = 1) Then
    '        '            If (UBound(inputDataArray, 2) > 1) Then
    '        '                PostCode = PostCode & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '        '            End If
    '        '            If (UBound(inputDataArray, 2) = 1) Then
    '        '                PostCode = PostCode & "'" & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
    '        '            End If
    '        '        End If
    '        '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
    '        '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '        '        End If
    '        '        If (j = UBound(inputDataArray, 2)) Then
    '        '            If (UBound(inputDataArray, 2) > 1) Then
    '        '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & "]"
    '        '            End If
    '        '            If (UBound(inputDataArray, 2) = 1) Then
    '        '                PostCode = PostCode & "}" & "]"
    '        '            End If
    '        '        End If
    '        '    Next j
    '        '    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

    '        '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

    '        '    WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
    '        '    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

    '        '    '讀取服務器返回的響應值
    '        '    WHR.Response.write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
    '        '    WHR.Response.write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
    '        '    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

    '        '    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
    '        '    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
    '        '    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
    '        '    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
    '        '    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
    '        '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '        '    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

    '        '    Response_Text = WHR.responseText
    '        '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '        '    'Debug.Print Response_Text

    '        'Next i


    '        ''使用 For 循環嵌套遍歷的方法，將二維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
    '        'PostCode = "["
    '        'For i = 1 To UBound(inputDataArray, 1)
    '        '    For j = 1 To UBound(inputDataArray, 2)
    '        '        If (j = 1) Then
    '        '            If (UBound(inputDataArray, 2) > 1) Then
    '        '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '        '            End If
    '        '            If (UBound(inputDataArray, 2) = 1) Then
    '        '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
    '        '            End If
    '        '        End If
    '        '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
    '        '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
    '        '        End If
    '        '        If (i < UBound(inputDataArray, 1)) Then
    '        '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
    '        '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & ","
    '        '            End If
    '        '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
    '        '                PostCode = PostCode & "}" & ","
    '        '            End If
    '        '        End If
    '        '        If (i = UBound(inputDataArray, 1)) Then
    '        '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
    '        '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}"
    '        '            End If
    '        '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
    '        '                PostCode = PostCode & "}"
    '        '            End If
    '        '        End If
    '        '    Next j
    '        'Next i
    '        'PostCode = PostCode & "]"
    '        'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。


    '        '使用第三方模組（Module）：clsJsConverter，將原始數據字典 Data_Dict 轉換爲向算法服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
    '        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
    '        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
    '        'requestJSONText = JsonConverter.ConvertToJson(Data_Dict, Whitespace:=2): Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
    '        requestJSONText = JsonConverter.ConvertToJson(Data_Dict): Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
    '        'Debug.Print requestJSONText

    '        'ReDim columnsDataArray(0): Rem 清空數組，釋放内存
    '        Erase columnsDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
    '        Data_Dict.RemoveAll: Rem 清空字典，釋放内存
    '        Set Data_Dict = Nothing: Rem 清空對象變量“Data_Dict”，釋放内存

    '    Case Else

    '        MsgBox "輸入的自定義統計算法名稱錯誤，無法識別傳入的名稱（Statistics Algorithm name = " & CStr(Statistics_Algorithm_Name) & "），目前只製作完成 (""test"", ""Interpolation"", ""Logistic"", ""Cox"", ""LC5PFit"", ...) 等自定義的統計算法."
    '        Exit Sub

    'End Select


    '判斷是否跳出子過程不繼續執行後面的動作
    'If PublicVariableStartORStopButtonClickState Then
    '    '刷新控制面板窗體控件中包含的提示標簽顯示值
    '    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "運算過程被中止.": Rem 提示運算過程執行狀態，賦值給標簽控件 calculate_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“calculate_status_Label”的“text”屬性值 calculate_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    '    End If
    '    ''更改按鈕狀態和標志
    '    ''PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
    '    'If Not (StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton") Is Nothing) Then
    '    '    Select Case PublicVariableStartORStopButtonClickState
    '    '        Case True
    '    '            StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton").Caption = CStr("Start calculate")
    '    '        Case False
    '    '            StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton").Caption = CStr("Stop calculate")
    '    '        Case Else
    '    '            MsgBox "Start or Stop Calculate Button" & "\\n" & "Private Sub Start_calculate_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
    '    '    End Select
    '    'End If
    '    ''刷新操作面板窗體控件中的變量值
    '    ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
    '    ''為操作面板窗體控件 StatisticsAlgorithmControlPanel 中包含的（監測窗體中啓動運算按钮控件的點擊狀態，布爾型）變量更新賦值
    '    'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    '    'End If
    '    ''取消控制面板中窗體控件中的按鈕禁用狀態
    '    'StatisticsAlgorithmControlPanel.Start_calculate_CommandButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的按鈕控件 Start_calculate_CommandButton（啓動運算按鈕），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的多選框控件 Data_Receptors_CheckBox1（用於判斷辨識選擇計算結果保存類型 Database 的多選框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的多選框控件 Data_Receptors_CheckBox2（用於判斷辨識選擇計算結果保存類型 Excel 的多選框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Statistics_Algorithm_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Statistics_Algorithm_Server_Url_TextBox（提供統計算法的服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供統計算法的服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供統計算法的服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Field_name_of_Data_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Field_name_of_Data_Input_TextBox（保存原始數據字段命名 Excel 表格保存區間的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Data_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Data_TextBox（保存原始數據的 Excel 表格保存區間的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Output_position_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Output_position_TextBox（保存計算結果的 Excel 表格區間的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.FisherDiscriminant_OptionButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的單選框控件 FisherDiscriminant_OptionButton（用於標識選擇某一個具體算法 FisherDiscriminant 的單選框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Interpolate_OptionButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的單選框控件 Interpolate_OptionButton（用於標識選擇某一個具體算法 Interpolate 的單選框），False 表示禁用點擊，True 表示可以點擊
    '    'StatisticsAlgorithmControlPanel.Logistic_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Cox_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Polynomial3_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.LC5p_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.PCA_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Factor_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.TimeSeries_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Meta_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Optimal_run_length_estimate_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Test_accuracy_estimate_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Test_power_estimate_OptionButton.Enabled = True: Rem
    '    'StatisticsAlgorithmControlPanel.Statistical_sampling_OptionButton.Enabled = True: Rem
    '    Exit Sub
    'End If


    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
        Public_Delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
        '刷新控制面板窗體中包含的變量，人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
        If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
        End If
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
        Public_Delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
        '刷新控制面板窗體中包含的變量，人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
        If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
        End If
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新控制面板窗體中包含的變量，經過隨機化之後最終得到的延時長度
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length = Public_Delay_length
    End If

    ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    'If Not (StatisticsAlgorithmControlPanel.Controls("delay") Is Nothing) Then
    '    Call StatisticsAlgorithmControlPanel.delay(StatisticsAlgorithmControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    'End If

    '刷新控制面板窗體控件中包含的提示標簽顯示值
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "向統計服務器發送數據 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    End If

    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
    Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
    Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
    Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

    '"http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"
    WHR.Open "post", Statistics_Algorithm_Server_Url, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
    WHR.SetRequestHeader "Referer", "http://localhost:10001/": Rem 請求頭參數：著名發送請求來源
    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
    WHR.SetRequestHeader "Connection", "Close": Rem 請求頭參數：保持鏈接，當取 "Keep-Alive" 值時，表示保持連接，當取 "Close" 值時，表示響應結束即斷開連接。

    Dim requst_Authorization As String
    requst_Authorization = ""
    If (Statistics_Algorithm_Server_Url <> "") And (InStr(1, Statistics_Algorithm_Server_Url, "&Key=", 1) <> 0) Then
        requst_Authorization = CStr(VBA.Split(Statistics_Algorithm_Server_Url, "&Key=")(1))
        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
        End If
    End If
    'Debug.Print requst_Authorization
    If requst_Authorization <> "" Then
        If Not (StatisticsAlgorithmControlPanel.Controls("Base64Encode") Is Nothing) Then
            requst_Authorization = CStr("Basic") & " " & CStr(StatisticsAlgorithmControlPanel.Base64Encode(CStr(requst_Authorization)))
        End If
        'If Not (StatisticsAlgorithmControlPanel.Controls("Base64Decode") Is Nothing) Then
        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(StatisticsAlgorithmControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
        'End If
        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
    End If
    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

    Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
    CookiePparameter = "Session_ID=request_Key->username:password"
    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
    If CookiePparameter <> "" Then
        If Not (StatisticsAlgorithmControlPanel.Controls("Base64Encode") Is Nothing) Then
            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
        End If
        'If Not (StatisticsAlgorithmControlPanel.Controls("Base64Decode") Is Nothing) Then
        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
        'End If
        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
    End If
    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

    WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

    WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

    'requestJSONText = "": Rem 置空，釋放内存

    '讀取服務器返回的響應值
    WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
    WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

    Dim Response_Text As String: Rem 承接服務器返回的響應值字符串;
    Response_Text = WHR.responseText
    'Debug.Print Response_Text

    Dim responseJSONText As String: Rem 算法服務器響應返回的計算結果的 JSON 格式的字符串;
    responseJSONText = Response_Text
    'responseJSONText = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    'Debug.Print responseJSONText

    'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

    Response_Text = "": Rem 置空，釋放内存
    'Set HTMLCode = Nothing
    'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

    '刷新控制面板窗體控件中包含的提示標簽顯示值
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "從統計服務器接收響應值計算結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    End If

    Dim responseJSONDict As Object: Rem 算法服務器響應返回的計算結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

    '使用第三方模組（Module）：clsJsConverter，將算法服務器響應返回的計算結果的 JSON 格式的字符串轉換爲 VBA 字典對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
    Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 算法服務器響應返回的計算結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
    ''Debug.Print responseJSONDict.Count
    ''Debug.Print LBound(responseJSONDict.Keys())
    ''Debug.Print UBound(responseJSONDict.Keys())
    'Dim Value As Variant
    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
    '    'Debug.Print responseJSONDict.Keys()(i)
    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
    '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
    '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
    '    'Next j
    '    j = 0
    '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
    '        j = j + 1
    '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
    '    Next Value
    'Next i

    'responseJSONText = "": Rem 置空，釋放内存
    'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存


    Dim resultDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim resultDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式

    ''將結果字典 responseJSONDict 中的所有數據轉存至二維數組 resultDataArray 中;
    ''求取結果字典 responseJSONDict 所有數據元素中的最大行數:
    'Dim max_Rows As Integer
    'max_Rows = 0
    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
    '    If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
    '        max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
    '    End If
    'Next i
    'max_Rows = CInt(max_Rows + 1): Rem 增加一個標題行
    ''使用 for 循環，將結果字典 responseJSONDict 中的全部數據，依次轉存至二維數組 resultDataArray 中：
    'ReDim resultDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式
    'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
    '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
    '    'Debug.Print responseJSONDict.Item(CStr(Data_Dict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))(1)
    '    'Debug.Print responseJSONDict.Item(CStr(Data_Dict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
    '    resultDataArray(1, i) = responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
    '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
    '    '    Debug.Print CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))(j)
    '    '    resultDataArray(j + 1, i) = responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))(j)
    '    'Next j
    '    Dim Value As Variant
    '    j = 0
    '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
    '        j = j + 1
    '        Debug.Print CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ":(" & j & ") = " & Value
    '        resultDataArray(j + 1, i) = Value
    '    Next Value
    'Next i


    ''將結果字典 responseJSONDict 中的指定的數據轉存至二維數組 resultDataArray 中;
    '求取結果字典 responseJSONDict 指定的數據元素中的最大行（Column）數和最大列（Row）數:
    Dim max_Rows As Integer
    max_Rows = 0
    Dim max_Columns As Integer
    max_Columns = 0
    '檢查字典中是否已經指定的鍵值對
    'Debug.Print responseJSONDict.Exists("Coefficient")
    If responseJSONDict.Exists("Coefficient") Then
        'Debug.Print responseJSONDict.Item("Coefficient")(1)
        'Debug.Print responseJSONDict.Item("Coefficient").Count
        If CInt(responseJSONDict.Item("Coefficient").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient").Count)
            'Debug.Print max_Rows
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Residual") Then
        If CInt(responseJSONDict.Item("Residual").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Residual").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Yfit") Then
        If CInt(responseJSONDict.Item("Yfit").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Yfit").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Coefficient-StandardDeviation") Then
        If CInt(responseJSONDict.Item("Coefficient-StandardDeviation").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient-StandardDeviation").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Lower-95%") Then
        If CInt(responseJSONDict.Item("Coefficient-Confidence-Lower-95%").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient-Confidence-Lower-95%").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Upper-95%") Then
        If CInt(responseJSONDict.Item("Coefficient-Confidence-Upper-95%").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient-Confidence-Upper-95%").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Lower") Then
        If CInt(responseJSONDict.Item("Yfit-Uncertainty-Lower").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Yfit-Uncertainty-Lower").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Upper") Then
        If CInt(responseJSONDict.Item("Yfit-Uncertainty-Upper").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Yfit-Uncertainty-Upper").Count)
        End If
        max_Columns = max_Columns + CInt(1)
    End If
    If responseJSONDict.Exists("testData") Then
        If responseJSONDict.Item("testData").Exists("test-Xvals") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Xvals").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Xvals").Count)
            End If
            max_Columns = max_Columns + CInt(1)
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Lower") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Lower").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Lower").Count)
            End If
            max_Columns = max_Columns + CInt(1)
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Upper") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Upper").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Upper").Count)
            End If
            max_Columns = max_Columns + CInt(1)
        End If
        If responseJSONDict.Item("testData").Exists("test-Yfit") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Yfit").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Yfit").Count)
            End If
            max_Columns = max_Columns + CInt(1)
        End If
        'If responseJSONDict.Item("testData").Exists("test-Ydata-StandardDeviation") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Ydata-StandardDeviation").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Ydata-StandardDeviation").Count)
        '    End If
        '    max_Columns = max_Columns + CInt(1)
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Lower") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Lower").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Lower").Count)
        '    End If
        '    max_Columns = max_Columns + CInt(1)
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Upper") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Upper").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Upper").Count)
        '    End If
        '    max_Columns = max_Columns + CInt(1)
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Residual") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Residual").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Residual").Count)
        '    End If
        '    max_Columns = max_Columns + CInt(1)
        'End If
    End If
    max_Rows = CInt(max_Rows + 1): Rem 增加一個標題行
    'Debug.Print "output array Rows = " & max_Rows
    'Debug.Print "output array Columns = " & max_Columns

    '將結果字典 responseJSONDict 中指定的數據轉存至二維數組 resultDataArray 中：
    ReDim resultDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim Preserve resultDataArray(LBound(resultDataArray, 1) To max_Rows, LBound(resultDataArray, 2) To UBound(resultDataArray, 2)) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim Preserve resultDataArray(LBound(resultDataArray, 1) To UBound(resultDataArray, 1), LBound(resultDataArray, 2) To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式
    '求取結果字典 responseJSONDict 指定的數據元素中的行（Column）步進數和列（Row）步進數:
    'Dim Row_J As Integer
    'Row_J = 0
    'Dim Column_I As Integer
    'Column_I = 0
    i = CInt(0)
    Dim Value As Variant
    If responseJSONDict.Exists("Coefficient") Then
        'Column_I = Column_I + CInt(1)
        i = i + CInt(1)
        resultDataArray(1, i) = "Coefficient"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient")
            j = j + 1
            'Debug.Print "Coefficient:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Coefficient-StandardDeviation") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Coefficient-StandardDeviation"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient-StandardDeviation")
            j = j + 1
            'Debug.Print "Coefficient-StandardDeviation:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Lower-95%") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Coefficient-Confidence-Lower-95%"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient-Confidence-Lower-95%")
            j = j + 1
            'Debug.Print "Coefficient-Confidence-Lower-95%:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Upper-95%") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Coefficient-Confidence-Upper-95%"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient-Confidence-Upper-95%")
            j = j + 1
            'Debug.Print "Coefficient-Confidence-Upper-95%:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Yfit") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Yfit"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Yfit")
            j = j + 1
            'Debug.Print "Yfit:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Lower") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Yfit-Uncertainty-Lower"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Yfit-Uncertainty-Lower")
            j = j + 1
            'Debug.Print "Yfit-Uncertainty-Lower:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Upper") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Yfit-Uncertainty-Upper"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Yfit-Uncertainty-Upper")
            j = j + 1
            'Debug.Print "Yfit-Uncertainty-Upper:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Residual") Then
        i = i + CInt(1)
        resultDataArray(1, i) = "Residual"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Residual")
            j = j + 1
            'Debug.Print "Residual:(" & j & ") = " & Value
            resultDataArray(j + 1, i) = Value
        Next Value
    End If
    'If responseJSONDict.Exists("Residual") Then
    '    i = i + CInt(1)
    '    resultDataArray(1, i) = "Residual_1"
    '    j = 0
    '    For Each Value In responseJSONDict.Item("Residual")
    '        j = j + 1
    '        'Debug.Print "Residual:(" & i & "," & j & ") = " & Value(1)
    '        resultDataArray(j + 1, i) = Value(1)
    '    Next Value
    '    i = i + CInt(1)
    '    resultDataArray(1, i) = "Residual_2"
    '    j = 0
    '    For Each Value In responseJSONDict.Item("Residual")
    '        j = j + 1
    '        'Debug.Print "Residual:(" & i & "," & j & ") = " & Value(2)
    '        resultDataArray(j + 1, i) = Value(2)
    '    Next Value
    '    i = i + CInt(1)
    '    resultDataArray(1, i) = "Residual_3"
    '    j = 0
    '    For Each Value In responseJSONDict.Item("Residual")
    '        j = j + 1
    '        'Debug.Print "Residual:(" & i & "," & j & ") = " & Value(3)
    '        resultDataArray(j + 1, i) = Value(3)
    '    Next Value
    '    'resultDataArray(1, 8) = "Residual_1"
    '    'resultDataArray(1, 9) = "Residual_2"
    '    'resultDataArray(1, 10) = "Residual_3"
    '    ''Dim Value As Variant
    '    'j = 0
    '    'For Each Value In responseJSONDict.Item("Residual")
    '    '    j = j + 1
    '    '    'Debug.Print "Residual:(" & j & ") = " & Value(1) & ", " & Value(2) & ", " & Value(3)
    '    '    resultDataArray(j + 1, 8) = Value(1)
    '    '    resultDataArray(j + 1, 9) = Value(2)
    '    '    resultDataArray(j + 1, 10) = Value(3)
    '    'Next Value
    'End If
    If responseJSONDict.Exists("testData") Then
        If responseJSONDict.Item("testData").Exists("test-Xvals") Then
            i = i + CInt(1)
            resultDataArray(1, i) = "test-Xvals"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Xvals")
                j = j + 1
                'Debug.Print "test-Xvals:(" & j & ") = " & Value
                resultDataArray(j + 1, i) = Value
            Next Value
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Lower") Then
            i = i + CInt(1)
            resultDataArray(1, i) = "test-Xfit-Uncertainty-Lower"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Lower")
                j = j + 1
                'Debug.Print "test-Xfit-Uncertainty-Lower:(" & j & ") = " & Value
                resultDataArray(j + 1, i) = Value
            Next Value
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Upper") Then
            i = i + CInt(1)
            resultDataArray(1, i) = "test-Xfit-Uncertainty-Upper"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Upper")
                j = j + 1
                'Debug.Print "test-Xfit-Uncertainty-Upper:(" & j & ") = " & Value
                resultDataArray(j + 1, i) = Value
            Next Value
        End If
        If responseJSONDict.Item("testData").Exists("test-Yfit") Then
            i = i + CInt(1)
            resultDataArray(1, i) = "test-Yfit"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Yfit")
                j = j + 1
                'Debug.Print "test-Yfit:(" & j & ") = " & Value
                resultDataArray(j + 1, i) = Value
            Next Value
        End If
        'If responseJSONDict.Item("testData").Exists("test-Ydata-StandardDeviation") Then
        '    i = i + CInt(1)
        '    resultDataArray(1, i) = "test-Ydata-StandardDeviation"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Ydata-StandardDeviation")
        '        j = j + 1
        '        'Debug.Print "test-Ydata-StandardDeviation:(" & j & ") = " & Value
        '        resultDataArray(j + 1, i) = Value
        '    Next Value
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Lower") Then
        '    i = i + CInt(1)
        '    resultDataArray(1, i) = "test-Yfit-Uncertainty-Lower"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Lower")
        '        j = j + 1
        '        'Debug.Print "test-Yfit-Uncertainty-Lower:(" & j & ") = " & Value
        '        resultDataArray(j + 1, i) = Value
        '    Next Value
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Upper") Then
        '    i = i + CInt(1)
        '    resultDataArray(1, i) = "test-Yfit-Uncertainty-Upper"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Upper")
        '        j = j + 1
        '        'Debug.Print "test-Yfit-Uncertainty-Upper:(" & j & ") = " & Value
        '        resultDataArray(j + 1, i) = Value
        '    Next Value
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Residual") Then
        '    i = i + CInt(1)
        '    resultDataArray(1, i) = "test-Residual_1"
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Residual")
        '        j = j + 1
        '        'Debug.Print "test-Residual:(" & i & "," & j & ") = " & Value(1)
        '        resultDataArray(j + 1, i) = Value(1)
        '    Next Value
        '    i = i + CInt(1)
        '    resultDataArray(1, i) = "test-Residual_2"
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Residual")
        '        j = j + 1
        '        'Debug.Print "test-Residual:(" & i & "," & j & ") = " & Value(2)
        '        resultDataArray(j + 1, i) = Value(2)
        '    Next Value
        '    i = i + CInt(1)
        '    resultDataArray(1, i) = "test-Residual_3"
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Residual")
        '        j = j + 1
        '        'Debug.Print "test-Residual:(" & i & "," & j & ") = " & Value(3)
        '        resultDataArray(j + 1, i) = Value(3)
        '    Next Value
        '    'resultDataArray(1, 16) = "test-Residual_1"
        '    'resultDataArray(1, 17) = "test-Residual_2"
        '    'resultDataArray(1, 18) = "test-Residual_3"
        '    ''Dim Value As Variant
        '    'j = 0
        '    'For Each Value In responseJSONDict.Item("testData").Item("test-Residual")
        '    '    j = j + 1
        '    '    'Debug.Print "test-Residual:(" & j & ") = " & Value(1) & ", " & Value(2) & ", " & Value(3)
        '    '    resultDataArray(j + 1, 16) = Value(1)
        '    '    resultDataArray(j + 1, 17) = Value(2)
        '    '    resultDataArray(j + 1, 18) = Value(3)
        '    'Next Value
        'End If
    End If
    i = 0: Rem 復位歸零;
    j = 0: Rem 復位歸零;
    'For i = LBound(resultDataArray, 1) To UBound(resultDataArray, 1)
    '    For j = LBound(resultDataArray, 2) To UBound(resultDataArray, 2)
    '        Debug.Print "resultDataArray:(" & i & ", " & j & ") = " & resultDataArray(i, j)
    '    Next j
    'Next i


    '判斷結果數據的保存模式（數據庫或者 Excel 表格）
    'Debug.Print Data_Receptors
    If (Data_Receptors = "Excel") Or (Data_Receptors = "Excel_and_Database") Then

        '刷新控制面板窗體控件中包含的提示標簽顯示值
        If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "向 Excel 表格中寫入計算結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
        End If

        'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

        '將存放計算結果的二維數組 resultDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
        If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

            Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
            'Debug.Print RNG.Row & " × " & RNG.Column

            'RNG = resultDataArray
            ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
            ''RNG.Resize(CInt(UBound(resultDataArray, 1) - LBound(resultDataArray, 1) + CInt(1)), CInt(UBound(resultDataArray, 2) - LBound(resultDataArray, 2) + CInt(1))) = resultDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

            '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
            For i = 0 To UBound(resultDataArray, 1) - LBound(resultDataArray, 1)
                For j = 0 To UBound(resultDataArray, 2) - LBound(resultDataArray, 2)
                    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value2 = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value2 = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                Next j
            Next i

            'Debug.Print Cells(RNG.Row, RNG.Column).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

        ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

            Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
            'Debug.Print RNG.Row & " × " & RNG.Column

            'RNG = resultDataArray
            ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
            ''RNG.Resize(CInt(UBound(resultDataArray, 1) - LBound(resultDataArray, 1) + CInt(1)), CInt(UBound(resultDataArray, 2) - LBound(resultDataArray, 2) + CInt(1))) = resultDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

            '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
            For i = 0 To UBound(resultDataArray, 1) - LBound(resultDataArray, 1)
                For j = 0 To UBound(resultDataArray, 2) - LBound(resultDataArray, 2)
                    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value2 = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value2 = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                Next j
            Next i

            'Debug.Print Cells(RNG.Row, RNG.Column).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

        ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

            'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Result_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
            'Exit Sub

            Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
            'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
            Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
            'Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
            'Debug.Print RNG.Row & " × " & RNG.Column

            ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
            'RNG.Resize(CInt(UBound(resultDataArray, 1) - LBound(resultDataArray, 1) + CInt(1)), CInt(UBound(resultDataArray, 2) - LBound(resultDataArray, 2) + CInt(1))) = resultDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

            '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
            For i = 0 To UBound(resultDataArray, 1) - LBound(resultDataArray, 1)
                For j = 0 To UBound(resultDataArray, 2) - LBound(resultDataArray, 2)
                    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value2 = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value2 = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                Next j
            Next i

            'Debug.Print Cells(RNG.Row, RNG.Column).Value2: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
        
        Else
        End If

        '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
        ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
        'RNG.EntireRow.Delete: Rem 刪除第一行表頭
        'Columns("C:J").Clear: Rem 清空 C 至 J 列
        'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
        'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
        'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
        'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
        'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
        'ActiveCell.Row: Rem 返回活動單元格的行號
        'ActiveCell.Column: Rem 返回活動單元格的列號
        'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
        'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
        ''ReDim resultDataArray(0): Rem 清空數組，釋放内存
        'Erase resultDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
        'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
        'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存

    End If


    '判斷結果數據的保存模式（數據庫或者 Excel 表格）
    'Debug.Print Data_Receptors
    If (Data_Receptors = "Database") Or (Data_Receptors = "Excel_and_Database") Then

        If Database_Server_Url <> "" Then

            '刷新控制面板窗體控件中包含的提示標簽顯示值
            If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
                StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "往數據庫服務器寫入計算結果 upload result …": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            End If

            'MsgBox "Is = Database, Is = Excel_and_Database"
            '需要事先已經啓動 MongoDB 數據庫服務端驅動服務器
            'C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
            'C:\Criss\DatabaseServer\MongoDB>C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:\Criss\DatabaseServer\MongoDB\Nodejs2MongodbServer.js host=0.0.0.0 port=8000 number_cluster_Workers=0 Key=username:password MongodbHost=0.0.0.0 MongodbPort=27017 dbUser=administrator dbPass=administrator dbName=testWebData

            '刷新自定義的延時等待時長
            'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
            If Not (StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
                'Public_delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
                Public_Delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

                'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
                '刷新控制面板窗體中包含的變量，人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
                If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
                    StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
                End If
            End If
            'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
            If Not (StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
                'Public_delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
                Public_Delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

                'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
                '刷新控制面板窗體中包含的變量，人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
                If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
                    StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
                End If
            End If
            Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
            '刷新控制面板窗體中包含的變量，經過隨機化之後最終得到的延時長度
            If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
                StatisticsAlgorithmControlPanel.Public_Delay_length = Public_Delay_length
            End If

            ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'If Not (StatisticsAlgorithmControlPanel.Controls("delay") Is Nothing) Then
            '    Call StatisticsAlgorithmControlPanel.delay(StatisticsAlgorithmControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'End If

            '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
            'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
            'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
            WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
            'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
            resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
            connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
            sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
            receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
            WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

            WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
            'WHR.Option(4) = 13056: Rem 忽略錯誤標志

            '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
            WHR.Open "post", Database_Server_Url, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
            WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
            WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
            WHR.SetRequestHeader "Referer", "http://localhost:27016/": Rem 請求頭參數：著名發送請求來源
            WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
            WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
            WHR.SetRequestHeader "Connection", "Close": Rem 請求頭參數：保持鏈接，當取 "Keep-Alive" 值時，表示保持連接，當取 "Close" 值時，表示響應結束即斷開連接。

            'Dim requst_Authorization As String
            requst_Authorization = ""
            If (Database_Server_Url <> "") And (InStr(1, Database_Server_Url, "&Key=", 1) <> 0) Then
                requst_Authorization = CStr(VBA.Split(Database_Server_Url, "&Key=")(1))
                If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                    requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                End If
            End If
            'Debug.Print requst_Authorization
            If requst_Authorization <> "" Then
                If Not (StatisticsAlgorithmControlPanel.Controls("Base64Encode") Is Nothing) Then
                    requst_Authorization = CStr("Basic") & " " & CStr(StatisticsAlgorithmControlPanel.Base64Encode(CStr(requst_Authorization)))
                End If
                'If Not (StatisticsAlgorithmControlPanel.Controls("Base64Decode") Is Nothing) Then
                '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(StatisticsAlgorithmControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                'End If
                WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
            End If
            'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

            'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
            CookiePparameter = "Session_ID=request_Key->username:password"
            'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
            '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
            '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
            'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
            If CookiePparameter <> "" Then
                If Not (StatisticsAlgorithmControlPanel.Controls("Base64Encode") Is Nothing) Then
                    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                End If
                'If Not (StatisticsAlgorithmControlPanel.Controls("Base64Decode") Is Nothing) Then
                '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                'End If
                WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
            End If
            'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

            'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼


            ''將保存計算結果的二維數組變量 resultDataArray 手動轉換爲對應的 JSON 格式的字符串;
            'Dim columnName() As String: Rem 采集結果各字段（各列）名稱字符串一維數組;
            'ReDim columnName(1 To UBound(resultDataArray, 2)): Rem 采集結果各字段（各列）名稱字符串一維數組;
            'columnName(1) = "Column_1"
            'columnName(2) = "Column_2"
            ''For i = 1 To UBound(columnName, 1)
            ''    Debug.Print columnName(i)
            ''Next i

            'Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
            'PostCode = ""
            'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""一級"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""二級"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""二級"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""二級"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""二級"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""二級""}"
            'PostCode = "{" & """Column_1""" & ":" & """" & CStr(resultDataArray(1, 1)) & """" & "," _
            '         & """Column_2""" & ":" & """" & CStr(resultDataArray(1, 2)) & """" & "}" _
            '         & """Column_3""" & ":" & """" & CStr(resultDataArray(1, 3)) & """" & "," _
            '         & """Column_4""" & ":" & """" & CStr(resultDataArray(1, 4)) & """" & "," _
            '         & """Column_5""" & ":" & """" & CStr(resultDataArray(1, 5)) & """" & "," _
            '         & """Column_6""" & ":" & """" & CStr(resultDataArray(1, 6)) & """" & "," _
            '         & """Column_7""" & ":" & """" & CStr(resultDataArray(1, 7)) & """" & "," _
            '         & """Column_8""" & ":" & """" & CStr(resultDataArray(1, 8)) & """" & "," _
            '         & """Column_9""" & ":" & """" & CStr(resultDataArray(1, 9)) & """" & "," _
            '         & """Column_10""" & ":" & """" & CStr(resultDataArray(1, 10)) & """" & "," _
            '         & """Column_11""" & ":" & """" & CStr(resultDataArray(1, 11)) & """" & "," _
            '         & """Column_12""" & ":" & """" & CStr(resultDataArray(1, 12)) & """" & "}"

            ''使用 For 循環嵌套遍歷的方法，將一維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
            'For i = 1 To UBound(resultDataArray, 1)
            '    PostCode = ""
            '    For j = 1 To UBound(resultDataArray, 2)
            '        If (j = 1) Then
            '            If (UBound(resultDataArray, 2) > 1) Then
            '                PostCode = PostCode & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & ","
            '            End If
            '            If (UBound(resultDataArray, 2) = 1) Then
            '                PostCode = PostCode & "'" & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """"
            '            End If
            '        End If
            '        If (j > 1) And (j < UBound(resultDataArray, 2)) Then
            '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & ","
            '        End If
            '        If (j = UBound(resultDataArray, 2)) Then
            '            If (UBound(resultDataArray, 2) > 1) Then
            '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & "}" & "]"
            '            End If
            '            If (UBound(resultDataArray, 2) = 1) Then
            '                PostCode = PostCode & "}" & "]"
            '            End If
            '        End If
            '    Next j
            '    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

            '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

            '    WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
            '    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

            '    '讀取服務器返回的響應值
            '    WHR.Response.write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
            '    WHR.Response.write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
            '    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

            '    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
            '    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
            '    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
            '    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
            '    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
            '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
            '    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

            '    Response_Text = WHR.responseText
            '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
            '    'Debug.Print Response_Text
            'Next i

            ''使用 For 循環嵌套遍歷的方法，將二維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
            'PostCode = "["
            'For i = 1 To UBound(resultDataArray, 1)
            '    For j = 1 To UBound(resultDataArray, 2)
            '        If (j = 1) Then
            '            If (UBound(resultDataArray, 2) > 1) Then
            '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & ","
            '            End If
            '            If (UBound(resultDataArray, 2) = 1) Then
            '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """"
            '            End If
            '        End If
            '        If (j > 1) And (j < UBound(resultDataArray, 2)) Then
            '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & ","
            '        End If
            '        If (i < UBound(resultDataArray, 1)) Then
            '            If (j = UBound(resultDataArray, 2)) And (UBound(resultDataArray, 2) > 1) Then
            '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & "}" & ","
            '            End If
            '            If (j = UBound(resultDataArray, 2)) And (UBound(resultDataArray, 2) = 1) Then
            '                PostCode = PostCode & "}" & ","
            '            End If
            '        End If
            '        If (i = UBound(resultDataArray, 1)) Then
            '            If (j = UBound(resultDataArray, 2)) And (UBound(resultDataArray, 2) > 1) Then
            '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(resultDataArray(i, j)) & """" & "}"
            '            End If
            '            If (j = UBound(resultDataArray, 2)) And (UBound(resultDataArray, 2) = 1) Then
            '                PostCode = PostCode & "}"
            '            End If
            '        End If
            '    Next j
            'Next i
            'PostCode = PostCode & "]"
            ''Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
            ''ReDim resultDataArray(0): Rem 清空數組，釋放内存
            'Erase resultDataArray: Rem 函數 Erase() 表示置空數組，釋放内存


            Dim toDatabase_Dict As Object  '函數返回值字典，記錄向數據庫服務器發送的，用於統計運算的原始數據，和經過算法服務器計算之後得到的結果，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
            Set toDatabase_Dict = CreateObject("Scripting.Dictionary")
            'Debug.Print Data_Dict.Count
            '檢查字典中是否已經指定的鍵值對
            If toDatabase_Dict.Exists("requestData") Then
                toDatabase_Dict.Item("requestData") = requestJSONText: Rem 刷新字典指定的鍵值對
            Else
                toDatabase_Dict.Add "requestData", requestJSONText: Rem 字典新增指定的鍵值對
            End If
            'Debug.Print toDatabase_Dict.Item("requestData")
            If toDatabase_Dict.Exists("responseResult") Then
                toDatabase_Dict.Item("responseResult") = responseJSONText: Rem 刷新字典指定的鍵值對
            Else
                toDatabase_Dict.Add "responseResult", responseJSONText: Rem 字典新增指定的鍵值對
            End If
            'Debug.Print toDatabase_Dict.Item("responseResult")


            '使用第三方模組（Module）：clsJsConverter，將原始數據字典 Data_Dict 轉換爲向算法服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
            '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
            'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
            Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
            'PostCode = JsonConverter.ConvertToJson(toDatabase_Dict, Whitespace:=2): Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
            PostCode = JsonConverter.ConvertToJson(toDatabase_Dict): Rem 向算法服務器發送的原始數據的 JSON 格式的字符串;
            'Debug.Print PostCode

            toDatabase_Dict.RemoveAll: Rem 清空字典，釋放内存
            Set toDatabase_Dict = Nothing: Rem 清空對象變量“toDatabase_Dict”，釋放内存
            requestJSONText = "": Rem 置空，釋放内存
            responseJSONText = "": Rem 置空，釋放内存
            Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存


            WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

            WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
            'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

            '讀取服務器返回的響應值
            WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
            WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
            'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

            ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
            ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
            '''HTMLCode.designMode = "on": Rem 開啓編輯模式
            'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
            'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
            'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
            'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

            'Dim Response_Text As String: Rem 承接服務器返回的響應值字符串;
            Response_Text = WHR.responseText
            Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
            'Debug.Print Response_Text

            'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

            Response_Text = "": Rem 置空，釋放内存
            PostCode = "": Rem 置空，釋放内存
            'Set HTMLCode = Nothing
            Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

        Else

            Debug.Print "用於保存結果的數據庫服務器地址參數值錯誤:" & Chr(10) & "傳入的用於保存結果的數據庫服務器地址 Data Server Url = { " & CStr(Database_Server_Url) & " } 爲空."

            If Data_Receptors = "Database" Then

                '刷新控制面板窗體控件中包含的提示標簽顯示值
                If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
                    StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "參數錯誤，數據庫服務器地址 DataServer={" & CStr(Database_Server_Url) & "} 爲空.": Rem 提示傳入的用於保存結果的數據庫服務器地址參數值錯誤，賦值給標簽控件 Web_page_load_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                End If

                ''更改控制面板中窗體控件中按鈕狀態和標志;
                'PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
                'If Not (StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton") Is Nothing) Then
                '    Select Case PublicVariableStartORStopButtonClickState
                '        Case True
                '            StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton").Caption = CStr("Start calculate")
                '        Case False
                '            StatisticsAlgorithmControlPanel.Controls("Start_calculate_CommandButton").Caption = CStr("Stop calculate")
                '        Case Else
                '            MsgBox "Start or Stop Calculate Button" & "\\n" & "Private Sub Start_calculate_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
                '    End Select
                'End If
                ''刷新操作面板窗體控件中的變量值
                ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
                ''為操作面板窗體控件 StatisticsAlgorithmControlPanel 中包含的（監測窗體中啓動運算按钮控件的點擊狀態，布爾型）變量更新賦值
                'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
                '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
                'End If
                ''取消控制面板中窗體控件中的按鈕禁用狀態
                'StatisticsAlgorithmControlPanel.Start_calculate_CommandButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的按鈕控件 Start_calculate_CommandButton（啓動運算按鈕），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的多選框控件 Data_Receptors_CheckBox1（用於判斷辨識選擇計算結果保存類型 Database 的多選框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的多選框控件 Data_Receptors_CheckBox2（用於判斷辨識選擇計算結果保存類型 Excel 的多選框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Statistics_Algorithm_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Statistics_Algorithm_Server_Url_TextBox（提供統計算法的服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供統計算法的服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供統計算法的服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Field_name_of_Data_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Field_name_of_Data_Input_TextBox（保存原始數據字段命名 Excel 表格保存區間的輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Data_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Data_TextBox（保存原始數據的 Excel 表格保存區間的輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Output_position_TextBox.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的文本輸入框控件 Output_position_TextBox（保存計算結果的 Excel 表格區間的輸入框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.FisherDiscriminant_OptionButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的單選框控件 FisherDiscriminant_OptionButton（用於標識選擇某一個具體算法 FisherDiscriminant 的單選框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Interpolate_OptionButton.Enabled = True: Rem 啓用操作面板窗體 StatisticsAlgorithmControlPanel 中的單選框控件 Interpolate_OptionButton（用於標識選擇某一個具體算法 Interpolate 的單選框），False 表示禁用點擊，True 表示可以點擊
                'StatisticsAlgorithmControlPanel.Logistic_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Cox_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.LC5p_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.PCA_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Factor_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.TimeSeries_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Meta_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Optimal_run_length_estimate_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Test_accuracy_estimate_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Test_power_estimate_OptionButton.Enabled = True: Rem
                'StatisticsAlgorithmControlPanel.Statistical_sampling_OptionButton.Enabled = True: Rem

                Exit Sub

            End If

            Dim returnMsgBox As Integer
            returnMsgBox = MsgBox("傳入的用於保存結果的數據庫服務器地址參數值錯誤." & Chr(10) & "傳入的用於保存結果的數據庫服務器地址 DataServer = { " & CStr(Database_Server_Url) & " } 爲空." & Chr(10) & "在數據庫服務器地址 DataServer = { } 爲空的情況下，將不會向數據庫服務器發送數據，結果只寫入 Excel 表格中." & Chr(10) & "單擊 { 確定 } 按鈕將繼續運行，單擊 { 取消 } 按鈕將中止運行.", 49, "警告")

            Select Case returnMsgBox

                Case Is = 1

                Case Is = 2

                    Exit Sub

                Case Else

                    MsgBox "參數錯誤 ( MsgBox Reteurn = " & CStr(returnMsgBox) & " )，只能取短整型值 1、2 之一."
                    Exit Sub

            End Select

        End If

    End If

    'ReDim resultDataArray(0): Rem 清空數組，釋放内存
    Erase resultDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存

    '刷新控制面板窗體控件中包含的提示標簽顯示值
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 StatisticsAlgorithmControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    End If

End Sub


'啓動爬蟲
Public Sub StatisticsAlgorithm()  '關鍵字 Private 表示子過程只在本模塊中有效，關鍵字 Public 表示子過程在所有模塊中都有效

    Call StatisticsAlgorithmModule_Initialize  '将上述定义的公共变量赋初值初始化

    StatisticsAlgorithmControlPanel.show  '顯示自定義的操作面板窗體控件
    'StatisticsAlgorithmControlPanel.Hide  '隱藏自定義的操作面板窗體控件
    'Unload StatisticsAlgorithmControlPanel
    'Load UserForm: StatisticsAlgorithmControlPanel
    'For i = 0 To StatisticsAlgorithmControlPanel.Controls.Count - 1
    '    DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。
    'Next i

    'MsgBox "統計算法示例工程：LC5PFit - 5 參數邏輯曲綫擬合."

End Sub




'*********************************************************************************************************************************************************************************



'讀取本地硬盤 JSON 文檔數據的示例代碼
'' Advanced example: Read .json file and load into sheet (Windows-only)
'' (add reference to Microsoft Scripting Runtime)
'' {"values":[{"a":1,"b":2,"c": 3},...]}
'
'Dim FSO As New FileSystemObject
'Dim JsonTS As TextStream
'Dim JsonText As String
'Dim Parsed As Dictionary
'
'' Read .json file
'Set JsonTS = FSO.OpenTextFile("example.json", ForReading)
'JsonText = JsonTS.ReadAll
'JsonTS.Close
'
'' Parse json to Dictionary
'' "values" is parsed as Collection
'' each item in "values" is parsed as Dictionary
'Set Parsed = JsonConverter.ParseJson(JsonText)
'
'' Prepare and write values to sheet
'Dim Values As Variant
'ReDim Values(Parsed("values").Count, 3)
'
'Dim Value As Dictionary
'Dim i As Long
'
'i = 0
'For Each Value In Parsed("values")
'  Values(i, 0) = Value("a")
'  Values(i, 1) = Value("b")
'  Values(i, 2) = Value("c")
'  i = i + 1
'Next Value
'
'Sheets("example").Range(Cells(1, 1), Cells(Parsed("values").Count, 3)) = Values
