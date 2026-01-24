VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} DatabaseControlPanel 
   Caption         =   "Database control panel"
   ClientHeight    =   9300
   ClientLeft      =   108
   ClientTop       =   456
   ClientWidth     =   11160
   OleObjectBlob   =   "DatabaseControlPanel.frx":0000
   StartUpPosition =   1  '所有者中心
End
Attribute VB_Name = "DatabaseControlPanel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False



'Author: 弘毅先生
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
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


'如果使用全局變量 public 的方法實現，在用戶窗體裏邊的全局變量賦值方式如下：
Option Explicit: Rem 語句 Option Explicit 表示强制要求變量需要先聲明後使用；聲明全局變量，可以跨越函數和子過程之間使用的，用于監測窗體中按钮控件點擊狀態。
Public PublicCurrentWorkbookName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentWorkbookName”，用於存放當前工作簿的名稱
Public PublicCurrentWorkbookFullName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentWorkbookFullName”，用於存放當前工作簿的全名（工作簿路徑和名稱）
Public PublicCurrentSheetName As String: Rem 定義一個全局型（Public）字符串型變量“PublicCurrentSheetName”，用於存放當前工作表的名稱

Public Public_Database_module_name As String: Rem 導入的鏈接操控數據庫模塊的自定義命名值字符串，字符串類型的變量，例如可取值：CStr("DatabaseModule")
Public PublicVariableStartORStopButtonClickState As Boolean: Rem 定義一個全局型（Public）布爾型变量“PublicVariableStartORStopButtonClickState”用於監測窗體中啓動運行按钮控件的點擊狀態，即是否正在運行的狀態提示

Public Public_Database_software As String: Rem 表示判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("Microsoft Office Access"，"MongoDB"，"MariaDB"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB")
Public Public_Database_Server_Url As String: Rem 提供存儲數據功能的數據庫服務器網址，字符串變量，可取值：CStr("C:/StatisticalServer/Data/MathematicalStatisticsData.accdb")，可取值：CStr("http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=Interpolate&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password")
Public Public_Database_custom_name As String: Rem 用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串，字符串變量，例如可取值：CStr("MathematicalStatisticsData")，表示將會鏈接自定義的名爲：MathematicalStatisticsData 的數據庫
Public Public_Data_table_custom_name As String: Rem 用於指定數據庫服務器中待鏈接操控的自定義數據庫中包含的數據二維表格（集合）名稱字符串，字符串變量，例如可取值：CStr("LC5PFit")，表示將會鏈接自定義的名爲：MathematicalStatisticsData 的數據庫中包含的名爲：LC5PFit 的二維數據表格（集合）
Public Public_Database_Server_Username As String: Rem 用於鏈接數據庫服務器的驗證賬戶名，字符串變量，可取值：CStr("admin_MathematicalStatisticsData")
Public Public_Database_Server_Password As String: Rem 用於鏈接數據庫服務器的驗證賬戶密碼，字符串變量，可取值：CStr("admin")
Public Public_Database_operational_order As String: Rem 表示判斷選擇使用的辨識對數據庫操作的指令，可以取值：("Add data", "Retrieve data", "Update data", "Delete data", "Retrieve count", "Add table(collection)", "Delete table(collection)", "SQL") 等自定義的操控指令名稱值字符串;
Public Public_Delay_length_input As Long: Rem 自定義人爲延遲等待的時長的基礎值，單位毫秒，長整型變量
Public Public_Delay_length_random_input As Single: Rem 自定義人爲延遲等待的時長的隨機化範圍，單位為基礎值的百分比，單精度浮點型變量
Public Public_Delay_length As Long: Rem 循環點擊操作之間延遲等待的時長，單位毫秒，長整型變量
'Public Public_Delay_length As Integer: Rem 循環點擊操作之間延遲等待的時長，單位毫秒，整型變量

'數據輸入輸出參數設置
Public Public_Field_name_input_position As String: Rem 需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串
Public Public_Field_data_input_position As String: Rem 需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串
Public Public_Field_name_output_position As String: Rem 從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串
Public Public_Field_data_output_position As String: Rem 從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串

Public Sub UserForm_Initialize()
'窗體打開前事件，給窗體控件中的全局變量賦初值，函數 UserForm_Initialize 的作用是窗體控件打開即運行初始化

    '語句 On Error Resume Next 會使程序按照產生錯誤的語句之後的語句繼續執行
    On Error Resume Next

    DatabaseControlPanel.PublicCurrentWorkbookName = ThisWorkbook.name: Rem 獲得當前工作簿的名稱，效果等同於“ = ActiveWorkbook.Name ”
    DatabaseControlPanel.PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem 獲得當前工作簿的全名（工作簿路徑和名稱）
    DatabaseControlPanel.PublicCurrentSheetName = ActiveSheet.name: Rem 獲得當前工作表的名稱


    '給監測窗體中啓動運算按钮控件的點擊狀態變量賦初值初始化
    PublicVariableStartORStopButtonClickState = True: Rem 布爾型變量，用於監測窗體中啓動運行按钮控件的點擊狀態，即是否正在運行的狀態提示

    '給當前變量賦初值初始化
    Public_Database_module_name = "": Rem 導入的鏈接操控數據庫模塊的自定義命名值字符串，字符串類型的變量，例如可取值：CStr("DatabaseModule")

    Public_Database_software = "": Rem 表示判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("Microsoft Office Access"，"MongoDB"，"MariaDB"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB");
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
        'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Value Then
        '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Value Then
        '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Value Then
        '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Value Then
        '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Caption)
        'End If
    End If


    Public_Database_operational_order = "": Rem 表示判斷選擇使用的辨識對數據庫操作的指令，可以取值：("Add data", "Retrieve data", "Update data", "Delete data", "Retrieve count", "Add table(collection)", "Delete table(collection)", "SQL") 等自定義的操控指令名稱值字符串;
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        'Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
        'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_data_OptionButton").Value Then
        '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_data_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Retrieve_data_OptionButton").Value Then
        '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Retrieve_data_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Update_Data_OptionButton").Value Then
        '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Update_Data_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete_data_OptionButton").Value Then
        '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete_data_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_table_OptionButton").Value Then
        '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_table_OptionButton").Caption)
        'End If
        'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete table(collection)").Value Then
        '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete table(collection)").Caption)
        'End If
    End If

    Public_Database_Server_Url = "": Rem 提供存儲數據服務的數據庫服務器網址，字符串變量，例如：CStr("C:/Database-to-Excel-VBA/Access/Database1.accdb")，例如：CStr("http://username:password@localhost:9001/insertMany?dbName=Data2&dbTableName=table2&dbUser=username&dbPass=password&Key=username:password")
    'If Not (DatabaseControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If

    Public_Database_custom_name = "": Rem 用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串，字符串變量，例如可取值：CStr("Database1")，表示將會鏈接自定義的名爲：Database1 的數據庫
    'If Not (DatabaseControlPanel.Controls("Database_name_input_TextBox") Is Nothing) Then
    '    'Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If

    Public_Data_table_custom_name = "": Rem 用於指定數據庫服務器中待鏈接操控的自定義數據庫中包含的數據二維表格（集合）名稱字符串，字符串變量，例如可取值：CStr("Collection1")，表示將會鏈接自定義的名爲：Database1 的數據庫中包含的名爲：Collection1 的二維數據表格（集合）
    'If Not (DatabaseControlPanel.Controls("Data_table_name_input_TextBox") Is Nothing) Then
    '    'Public_Data_table_custom_name = CStr(DatabaseControlPanel.Controls("Data_table_name_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Data_table_custom_name = CStr(DatabaseControlPanel.Controls("Data_table_name_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If

    Public_Database_Server_Username = "": Rem 用於鏈接數據庫服務器驗證的賬戶名，字符串變量
    'If Not (DatabaseControlPanel.Controls("Username_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Username = CStr(DatabaseControlPanel.Controls("Username_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Database_Server_Username = CStr(DatabaseControlPanel.Controls("Username_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If
    Public_Database_Server_Password = "": Rem 用於鏈接數據庫服務器驗證的賬戶密碼，字符串變量
    'If Not (DatabaseControlPanel.Controls("Password_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Password = CStr(DatabaseControlPanel.Controls("Password_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Database_Server_Password = CStr(DatabaseControlPanel.Controls("Password_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If

    Public_Delay_length_input = CLng(0): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型，例如取值：CLng(1500)
    Public_Delay_length_random_input = CSng(0): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型，例如取值：CSng(0.2)
    'If Not (DatabaseControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
    '    If CStr(DatabaseControlPanel.Controls("Delay_input_TextBox").Text) = CStr("") Then
    '        Public_Delay_length_input = CLng(0)
    '    Else
    '        'Public_delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
    '        Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。
    '    End If
    'End If
    'If Not (DatabaseControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
    '    If CStr(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text) = CStr("") Then
    '        Public_Delay_length_random_input = CSng(0)
    '    Else
    '        'Public_delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
    '        Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
    '    End If
    'End If
    'Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng(0)  'CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(0)  'CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。

    '數據輸入輸出參數設置
    Public_Field_name_input_position = "": Rem Sheet1!A1:H1 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$H$1 需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串
    'If Not (DatabaseControlPanel.Controls("Field_name_position_Input_TextBox") Is Nothing) Then
    '    'Public_Field_name_input_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Field_name_input_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If
    Public_Field_data_input_position = "": Rem Sheet1!A2:H12 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$H$12 需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串
    'If Not (DatabaseControlPanel.Controls("Field_data_position_Input_TextBox") Is Nothing) Then
    '    'Public_Field_data_input_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Field_data_input_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If
    Public_Field_name_output_position = "": Rem Sheet1!J1:L5 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5 從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串
    'If Not (DatabaseControlPanel.Controls("Field_name_position_Output_TextBox") Is Nothing) Then
    '    'Public_Field_name_output_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Output_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Field_name_output_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Output_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If
    Public_Field_data_output_position = "": Rem Sheet1!J1:L5 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5 從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串
    'If Not (DatabaseControlPanel.Controls("Field_data_position_Output_TextBox") Is Nothing) Then
    '    'Public_Field_data_output_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Output_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Field_data_output_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Output_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    'End If



    'Public_First_level_page_number_source_xpath = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的 XPath 值字符串
    'If Not (DatabaseControlPanel.Controls("First_level_page_number_source_xpath_TextBox") Is Nothing) Then
    '    'Public_First_level_page_number_source_xpath = CStr(DatabaseControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_First_level_page_number_source_xpath = CStr(DatabaseControlPanel.Controls("First_level_page_number_source_xpath_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型

    '    'If Public_Browser_Name = "InternetExplorer" Then
    '    '    '定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串和位置索引整數值
    '    '    ReDim tempArr(0): Rem 清空數組
    '    '    tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-", limit:=2, compare:=vbBinaryCompare)
    '    '    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
    '    '    Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
    '    '    Public_First_level_page_number_source_tag_name = CStr(tempArr(UBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    'tempArr = VBA.Split(Public_First_level_page_number_source_xpath, delimiter:="-")
    '    '    'Public_First_level_page_number_source_position_index = CInt(tempArr(LBound(tempArr))): Rem 定位“當前第一層級頁面中頁碼信息源元素”的位置索引整數值
    '    '    'Public_First_level_page_number_source_tag_name = "": Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
    '    '    '    If i = CInt(LBound(tempArr) + CInt(1)) Then
    '    '    '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    '    Else
    '    '    '        Public_First_level_page_number_source_tag_name = Public_First_level_page_number_source_tag_name & "-" & CStr(tempArr(i)): Rem 定位“當前第一層級頁面中頁碼信息源元素”的標簽名稱值字符串
    '    '    '    End If
    '    '    'Next
    '    '    'Debug.Print Public_First_level_page_number_source_tag_name & ", " & Public_First_level_page_number_source_position_index
    '    'End If
    'End If




    ''Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
    'Public_Inject_data_page_JavaScript = "": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串
    ''If Not (DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    ''    'Public_Inject_data_page_JavaScript = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    ''    Public_Inject_data_page_JavaScript = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    ''End If
    ''Public_Inject_data_page_JavaScript_filePath = "C:/Criss/vba/Automatic/test/test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'Public_Inject_data_page_JavaScript_filePath = "": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'If Not (DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    '    'Public_Inject_data_page_JavaScript_filePath = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    Public_Inject_data_page_JavaScript_filePath = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串型。函數 CStr() 表示强制轉換為字符串型
    '    'Debug.Print Public_Inject_data_page_JavaScript_filePath
    'End If
    'If Public_Inject_data_page_JavaScript_filePath <> "" Then

    '    '判斷自定義的待插入目標數據源頁面的 JavaScript 脚本文檔是否存在
    '    Dim fso As Object, sFile As Object
    '    Set fso = CreateObject("Scripting.FileSystemObject")

    '    If fso.Fileexists(Public_Inject_data_page_JavaScript_filePath) Then

    '        'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

    '        '使用 OpenTextFile 方法打開一個指定的文檔並返回一個 TextStream 對象，該對象可以對文檔進行讀操作或追加寫入操作
    '        '函數語法：object.OpenTextFile(filename[,iomode[,create[,format]]])
    '        '參數 filename 為目標文檔的路徑全名字符串
    '        '參數 iomode 表示輸入和輸出方式，可以為兩個常數之一：ForReading、ForAppending
    '        '參數 Create 表示如果指定的 filename 不存在時，是否可以新創建一個新文檔，為 Boolean 值，若創建新文檔取 True 值，不創建則取 False 值，預設為 False 值
    '        '參數 Format 為三種 Tristate 值之一，預設為以 ASCII 格式打開文檔

    '        '設置打開文檔參數常量
    '        Const ForReading = 1: Rem 打開一個只讀文檔，不能對文檔進行寫操作
    '        Const ForWriting = 2: Rem 打開一個可讀可寫操作的文檔，注意，會清空刪除文檔中原有的内容
    '        Const ForAppending = 8: Rem 打開一個可寫操作的文檔，並將指針移動到文檔的末尾，執行在文檔尾部追加寫入操作，不會刪除文檔中原有的内容
    '        Const TristateUseDefault = -2: Rem 使用系統缺省的編碼方式打開文檔
    '        Const TristateTrue = -1: Rem 以 Unicode 編碼的方式打開文檔
    '        Const TristateFalse = 0: Rem 以 ASCII 編碼的方式打開文檔，注意，漢字會亂碼

    '        '以只讀方式打開文檔
    '        Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

    '        ''判斷如果不是文檔文本的尾端，則持續讀取數據拼接
    '        'Public_Inject_data_page_JavaScript = ""
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem 從打開的文檔中讀取一行字符串拼接，並在字符串結尾加上一個回車符號
    '        '    'Debug.Print sFile.ReadLine: Rem 讀取一行，不包括行尾的換行符
    '        'Loop
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem 從打開的文檔中讀取一個字符拼接
    '        '    'Debug.Print sFile.Read(1): Rem 讀取一個字符
    '        'Loop

    '        Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem 讀取文檔中的全部數據
    '        'Debug.Print sFile.ReadAll
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem 將 Unicode 編碼的字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        sFile.Close

    '    Else

    '        Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
    '        'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

    '    End If

    '    Set sFile = Nothing
    '    Set fso = Nothing

    'End If

End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
'窗體關閉前事件（鼠標左鍵單擊右上角×號）。
'參數 Cancel 為 > 0 的值時，表示禁止關閉動作的發生。即不允許用戶點擊窗體右上角的 × 號，也不允許使用“控制”菜單中的“關閉”命令。
'參數 CloseMode 表示關閉的模式。

    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。

End Sub

'VBA Base64 編碼函數：
Function Base64Encode(StrA As String) As String
    On Error GoTo over
    Dim buf() As Byte, Length As Long, mods As Long
    Dim Str() As Byte
    Dim i, kk As Integer
    kk = Len(StrA) - 1
    ReDim Str(kk)
    For i = 0 To kk
        Str(i) = Asc(Mid(StrA, i + 1, 1))
    Next i
    Const B64_CHAR_DICT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    mods = (UBound(Str) + 1) Mod 3
    Length = UBound(Str) + 1 - mods
    ReDim buf(Length / 3 * 4 + IIf(mods <> 0, 4, 0) - 1)
    For i = 0 To Length - 1 Step 3
        buf(i / 3 * 4) = (Str(i) And &HFC) / &H4
        buf(i / 3 * 4 + 1) = (Str(i) And &H3) * &H10 + (Str(i + 1) And &HF0) / &H10
        buf(i / 3 * 4 + 2) = (Str(i + 1) And &HF) * &H4 + (Str(i + 2) And &HC0) / &H40
        buf(i / 3 * 4 + 3) = Str(i + 2) And &H3F
    Next
    If mods = 1 Then
        buf(Length / 3 * 4) = (Str(Length) And &HFC) / &H4
        buf(Length / 3 * 4 + 1) = (Str(Length) And &H3) * &H10
        buf(Length / 3 * 4 + 2) = 64
        buf(Length / 3 * 4 + 3) = 64
    ElseIf mods = 2 Then
        buf(Length / 3 * 4) = (Str(Length) And &HFC) / &H4
        buf(Length / 3 * 4 + 1) = (Str(Length) And &H3) * &H10 + (Str(Length + 1) And &HF0) / &H10
        buf(Length / 3 * 4 + 2) = (Str(Length + 1) And &HF) * &H4
        buf(Length / 3 * 4 + 3) = 64
    End If
    For i = 0 To UBound(buf)
        Base64Encode = Base64Encode + Mid(B64_CHAR_DICT, buf(i) + 1, 1)
    Next
over:
End Function

'VBA Base64 解碼函數：
Function Base64Decode(B64 As String) As String
    On Error GoTo over
    Dim OutStr() As Byte, i As Long, j As Long
    Const B64_CHAR_DICT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    If InStr(1, B64, "=") <> 0 Then B64 = left(B64, InStr(1, B64, "=") - 1)
    Dim kk, Length As Long, mods As Long
    mods = Len(B64) Mod 4
    Length = Len(B64) - mods
    ReDim OutStr(Length / 4 * 3 - 1 + Switch(mods = 0, 0, mods = 2, 1, mods = 3, 2))
    For i = 1 To Length Step 4
        Dim buf(3) As Byte
        For j = 0 To 3
            buf(j) = InStr(1, B64_CHAR_DICT, Mid(B64, i + j, 1)) - 1
        Next
        OutStr((i - 1) / 4 * 3) = buf(0) * &H4 + (buf(1) And &H30) / &H10
        OutStr((i - 1) / 4 * 3 + 1) = (buf(1) And &HF) * &H10 + (buf(2) And &H3C) / &H4
        OutStr((i - 1) / 4 * 3 + 2) = (buf(2) And &H3) * &H40 + buf(3)
    Next
    If mods = 2 Then
        OutStr(Length / 4 * 3) = (InStr(1, B64_CHAR_DICT, Mid(B64, Length + 1, 1)) - 1) * &H4 + ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 2, 1)) - 1) And &H30) / 16
    ElseIf mods = 3 Then
        OutStr(Length / 4 * 3) = (InStr(1, B64_CHAR_DICT, Mid(B64, Length + 1, 1)) - 1) * &H4 + ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 2, 1)) - 1) And &H30) / 16
        OutStr(Length / 4 * 3 + 1) = ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 2, 1)) - 1) And &HF) * &H10 + ((InStr(1, B64_CHAR_DICT, Mid(B64, Length + 3, 1)) - 1) And &H3C) / &H4
    End If
    For i = 0 To UBound(OutStr)
        Base64Decode = Base64Decode & Chr(OutStr(i))
    Next i
over:
End Function

Public Sub delay(T As Long): Rem 創建一個自定義精確延時子過程，用於後面需要延時功能時直接調用。用法為：delay(T);“T”就是要延時的時長，單位是毫秒，取值最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，這個值的範圍在 0 到 2^32 之間，大約爲 49.71 日。關鍵字 Private 表示子過程作用域只在本模塊有效，關鍵字 Public 表示子過程作用域在所有模塊都有效
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。
    Dim time1 As Long
    time1 = timeGetTime: Rem 函數 timeGetTime 表示系統時間，該時間為從系統開啓算起所經過的時間（單位毫秒），持續纍加記錄。
    Do
        If Not (DatabaseControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
            If timeGetTime - time1 < T Then
                DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
            End If
            If timeGetTime - time1 >= T Then
                DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
            End If
        End If

        DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。

    Loop While timeGetTime - time1 < T

    If Not (DatabaseControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
        If timeGetTime - time1 < T Then
            DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
        End If
        If timeGetTime - time1 >= T Then
            DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
        End If
    End If

End Sub


'單選框鼠標左鍵單擊事件，表示判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("Microsoft Office Access"，"MongoDB"，"MariaDB"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB");
Private Sub Access_OptionButton_Click()
    '判斷單選框控件的選中狀態
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Caption)
    'End If
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub MongoDB_OptionButton_Click()
    '判斷單選框控件的選中狀態
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Value Then
    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Caption)
    'End If
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub MariaDB_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub PostgreSQL_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub MySQL_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub


'監聽文本輸入框（textbox）控件内容的改變事件，自定義人爲延遲等待的時長的基礎值，單位毫秒，長整型變量
Private Sub Delay_input_TextBox_Change()

    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (DatabaseControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        If CStr(DatabaseControlPanel.Controls("Delay_input_TextBox").Text) = CStr("") Then
            Public_Delay_length_input = CLng(0)
        Else
            'Public_delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
            Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

            'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
            DatabaseModule.Public_Delay_length_input = Public_Delay_length_input
            'DatabaseModule.Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(DatabaseModule)
            'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length_input)
            'Debug.Print DatabaseModule.Public_Delay_length_input
            'Application.Evaluate Public_Database_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            'Application.Run Public_Database_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
        End If
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (DatabaseControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        If CStr(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text) = CStr("") Then
            Public_Delay_length_random_input = CSng(0)
        Else
            'Public_delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
            Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

            'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
            DatabaseModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
            'DatabaseModule.Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text)
            'Debug.Print VBA.TypeName(DatabaseModule)
            'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length_random_input)
            'Debug.Print DatabaseModule.Public_Delay_length_random_input
            'Application.Evaluate Public_Database_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            'Application.Run Public_Database_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
        End If
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
    DatabaseModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
    'Debug.Print VBA.TypeName(DatabaseModule)
    'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length)
    'Debug.Print DatabaseModule.Public_Delay_length
    'Application.Evaluate Public_Database_module_name & ".Public_Delay_length = Public_Delay_length"
    'Application.Run Public_Database_module_name & ".Public_Delay_length = Public_Delay_length"

End Sub

'監聽文本輸入框（textbox）控件内容的改變事件，自定義人爲延遲等待的時長的隨機化範圍，單位為基礎值的百分比，單精度浮點型變量
Private Sub Delay_random_input_TextBox_Change()

    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (DatabaseControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        If CStr(DatabaseControlPanel.Controls("Delay_input_TextBox").Text) = CStr("") Then
            Public_Delay_length_input = CLng(0)
        Else
            'Public_delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
            Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

            'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
            DatabaseModule.Public_Delay_length_input = Public_Delay_length_input
            'DatabaseModule.Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
            'Debug.Print VBA.TypeName(DatabaseModule)
            'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length_input)
            'Debug.Print DatabaseModule.Public_Delay_length_input
            'Application.Evaluate Public_Database_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
            'Application.Run Public_Database_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
        End If
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (DatabaseControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        If CStr(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text) = CStr("") Then
            Public_Delay_length_random_input = CSng(0)
        Else
            'Public_delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
            Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

            'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
            DatabaseModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
            'DatabaseModule.Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text)
            'Debug.Print VBA.TypeName(DatabaseModule)
            'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length_random_input)
            'Debug.Print DatabaseModule.Public_Delay_length_random_input
            'Application.Evaluate Public_Database_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
            'Application.Run Public_Database_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
        End If
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
    DatabaseModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
    'Debug.Print VBA.TypeName(DatabaseModule)
    'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length)
    'Debug.Print DatabaseModule.Public_Delay_length
    'Application.Evaluate Public_Database_module_name & ".Public_Delay_length = Public_Delay_length"
    'Application.Run Public_Database_module_name & ".Public_Delay_length = Public_Delay_length"

End Sub

'監聽文本輸入框（textbox）控件内容的改變事件，自定義指定的資料庫名稱：「MathematicalStatisticsData」;
Private Sub Database_name_input_TextBox_Change()

    ''Public_Database_software = "": Rem 表示判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("Microsoft Office Access"，"MongoDB"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB");
    ''判斷子框架控件是否存在
    'If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
    '    '遍歷框架中包含的子元素。
    '    Dim element_i
    '    For Each element_i In Database_software_Frame.Controls
    '        '判斷單選框控件的選中狀態
    '        If element_i.Value Then
    '            Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Caption)
    '    'End If
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Caption)
    '    'End If
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Caption)
    '    'End If
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Caption)
    '    'End If
    'End If

    If Public_Database_software = "Microsoft Office Access" Then

        '刷新自定義的指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串變量;
        'Public_Database_custom_name = CStr("MathematicalStatisticsData"): Rem 用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串變量，例如可取值：CStr("MathematicalStatisticsData")，表示將會鏈接自定義的名爲：MathematicalStatisticsData 的數據庫;
        If Not (DatabaseControlPanel.Controls("Database_name_input_TextBox") Is Nothing) Then

            If Len(Trim(CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text))) = 0 Then

                Public_Database_custom_name = CStr("")

            Else

                'Public_Database_custom_name = CStr(Trim(CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text))): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                'Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                'Debug.Print "Database custom name input = " & "[ " & Public_Database_custom_name & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_custom_name 值;

            End If

            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
            DatabaseModule.Public_Database_custom_name = Public_Database_custom_name: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串變量，更新賦值;
            'DatabaseModule.Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text)
            'Debug.Print VBA.TypeName(DatabaseModule)
            'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_custom_name)
            'Debug.Print DatabaseModule.Public_Database_custom_name
            'Application.Evaluate Public_Database_module_name & ".Public_Database_custom_name = Public_Database_custom_name"
            'Application.Run Public_Database_module_name & ".Public_Database_custom_name = Public_Database_custom_name"

        End If

        If Public_Database_custom_name <> "" Then

            '刷新自定義的提供存儲數據功能的數據庫服務器網址;
            'Public_Database_Server_Url = CStr("C:/StatisticalServer/Data/MathematicalStatisticsData.accdb"): Rem 提供存儲數據功能的數據庫服務器網址，字符串變量，可取值：CStr("C:/StatisticalServer/Data/MathematicalStatisticsData.accdb")，可取值：CStr("http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=Interpolate&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password")
            If Not (DatabaseControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then

                If Len(Trim(CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text))) = 0 Then

                    Public_Database_Server_Url = CStr("")

                Else

                    'Public_Database_Server_Url = CStr(Trim(CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text))): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                    Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                    'Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value)
                    'Debug.Print "Database Server URL input = " & "[ " & Public_Database_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_Server_Url 值。

                End If

                If Public_Database_Server_Url <> "" Then
                    'Debug.Print left(Public_Database_Server_Url, CInt(InStrRev(Public_Database_Server_Url, "/") - 1))
                    'Debug.Print Mid(Public_Database_Server_Url, CInt(InStrRev(Public_Database_Server_Url, "/") + 1))
                    'Debug.Print left(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), CInt(InStrRev(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), ".") - 1))
                    'Debug.Print Mid(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), CInt(InStrRev(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), ".") + 1))

                    If (InStr(1, Public_Database_Server_Url, ".accdb", 1) <> 0) Or (InStr(1, Public_Database_Server_Url, ".mdb", 1) <> 0) Then

                        If CStr(left(CStr(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1)), CInt(InStrRev(CStr(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1)), ".") - 1))) <> Public_Database_custom_name Then

                            If InStr(1, Public_Database_Server_Url, ".accdb", 1) <> 0 Then
                                If InStr(1, Public_Database_Server_Url, "/", 1) <> 0 Then
                                    Public_Database_Server_Url = CStr(CStr(left(Public_Database_Server_Url, CInt(InStrRev(Public_Database_Server_Url, "/") - 1))) & "/" & CStr(Public_Database_custom_name) & "." & CStr(Mid(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), CInt(InStrRev(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), ".") + 1))))
                                End If
                            End If

                            If InStr(1, Public_Database_Server_Url, ".mdb", 1) <> 0 Then
                                If InStr(1, Public_Database_Server_Url, "/", 1) <> 0 Then
                                    Public_Database_Server_Url = CStr(CStr(left(Public_Database_Server_Url, CInt(InStrRev(Public_Database_Server_Url, "/") - 1))) & "/" & CStr(Public_Database_custom_name) & "." & CStr(Mid(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), CInt(InStrRev(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), ".") + 1))))
                                End If
                            End If

                            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
                            DatabaseModule.Public_Database_Server_Url = Public_Database_Server_Url
                            'DatabaseModule.Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的數據庫操控模塊 DatabaseModule 中包含的提供存儲數據功能的數據庫服務器網址字符串變量，更新賦值;
                            'Debug.Print VBA.TypeName(DatabaseModule)
                            'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_Server_Url)
                            'Debug.Print DatabaseModule.Public_Database_Server_Url
                            'Application.Evaluate Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"
                            'Application.Run Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"

                            '刷新操作面板中文本輸入框TextBox）元素："Database_Server_Url_TextBox" 的值，自定義的提供存儲數據功能的數據庫服務器網址的文本輸入框元素（TextBox）;
                            DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text = CStr(Public_Database_Server_Url)
                            'DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value = CStr(Public_Database_Server_Url)

                        Else
                        End If

                    Else

                        If Right(Public_Database_Server_Url, 1) = "/" Then
                            Public_Database_Server_Url = CStr(CStr(Public_Database_Server_Url) & CStr(Public_Database_custom_name) & ".accdb")
                        Else
                            Public_Database_Server_Url = CStr(CStr(Public_Database_Server_Url) & "/" & CStr(Public_Database_custom_name) & ".accdb")
                        End If

                        '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
                        DatabaseModule.Public_Database_Server_Url = Public_Database_Server_Url
                        'DatabaseModule.Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的數據庫操控模塊 DatabaseModule 中包含的提供存儲數據功能的數據庫服務器網址字符串變量，更新賦值;
                        'Debug.Print VBA.TypeName(DatabaseModule)
                        'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_Server_Url)
                        'Debug.Print DatabaseModule.Public_Database_Server_Url
                        'Application.Evaluate Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"
                        'Application.Run Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"

                        '刷新操作面板中文本輸入框TextBox）元素："Database_Server_Url_TextBox" 的值，自定義的提供存儲數據功能的數據庫服務器網址的文本輸入框元素（TextBox）;
                        DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text = CStr(Public_Database_Server_Url)
                        'DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value = CStr(Public_Database_Server_Url)

                    End If

                End If

            End If

        End If

    End If

End Sub

'監聽文本輸入框（textbox）控件内容的改變事件，自定義指定的資料庫存儲路徑全名：「C:/StatisticalServer/Data/MathematicalStatisticsData.accdb」;
Private Sub Database_Server_Url_TextBox_Change()

    ''Public_Database_software = "": Rem 表示判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("Microsoft Office Access"，"MongoDB"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB");
    ''判斷子框架控件是否存在
    'If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
    '    '遍歷框架中包含的子元素。
    '    Dim element_i
    '    For Each element_i In Database_software_Frame.Controls
    '        '判斷單選框控件的選中狀態
    '        If element_i.Value Then
    '            Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MongoDB_OptionButton").Caption)
    '    'End If
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("Access_OptionButton").Caption)
    '    'End If
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("PostgreSQL_OptionButton").Caption)
    '    'End If
    '    'If DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Value Then
    '    '    Public_Database_software = CStr(DatabaseControlPanel.Controls("Database_software_Frame").Controls("MySQL_OptionButton").Caption)
    '    'End If
    'End If

    If Public_Database_software = "Microsoft Office Access" Then

        '刷新自定義的提供存儲數據功能的數據庫服務器網址;
        'Public_Database_Server_Url = CStr("C:/StatisticalServer/Data/MathematicalStatisticsData.accdb"): Rem 提供存儲數據功能的數據庫服務器網址，字符串變量，可取值：CStr("C:/StatisticalServer/Data/MathematicalStatisticsData.accdb")，可取值：CStr("http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=Interpolate&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password")
        If Not (DatabaseControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then

            If Len(Trim(CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text))) = 0 Then

                Public_Database_Server_Url = CStr("")

            Else

                'Public_Database_Server_Url = CStr(Trim(CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text))): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                'Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value)
                'Debug.Print "Database Server URL input = " & "[ " & Public_Database_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_Server_Url 值。

            End If

            '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
            DatabaseModule.Public_Database_Server_Url = Public_Database_Server_Url
            'DatabaseModule.Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的數據庫操控模塊 DatabaseModule 中包含的提供存儲數據功能的數據庫服務器網址字符串變量，更新賦值;
            'Debug.Print VBA.TypeName(DatabaseModule)
            'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_Server_Url)
            'Debug.Print DatabaseModule.Public_Database_Server_Url
            'Application.Evaluate Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"
            'Application.Run Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"

        End If

        If Public_Database_Server_Url <> "" Then
            'Debug.Print left(Public_Database_Server_Url, CInt(InStrRev(Public_Database_Server_Url, "/") - 1))
            'Debug.Print Mid(Public_Database_Server_Url, CInt(InStrRev(Public_Database_Server_Url, "/") + 1))
            'Debug.Print left(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), CInt(InStrRev(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), ".") - 1))
            'Debug.Print Mid(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), CInt(InStrRev(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1), ".") + 1))

            If (InStr(1, Public_Database_Server_Url, ".accdb", 1) <> 0) Or (InStr(1, Public_Database_Server_Url, ".mdb", 1) <> 0) Then

                '刷新自定義的指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串變量;
                'Public_Database_custom_name = CStr("MathematicalStatisticsData"): Rem 用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串變量，例如可取值：CStr("MathematicalStatisticsData")，表示將會鏈接自定義的名爲：MathematicalStatisticsData 的數據庫;
                If Not (DatabaseControlPanel.Controls("Database_name_input_TextBox") Is Nothing) Then

                    If Len(Trim(CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text))) = 0 Then

                        Public_Database_custom_name = CStr("")

                    Else

                        'Public_Database_custom_name = CStr(Trim(CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text))): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                        Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                        'Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型;
                        'Debug.Print "Database custom name input = " & "[ " & Public_Database_custom_name & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_custom_name 值;

                    End If

                    If CStr(left(CStr(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1)), CInt(InStrRev(CStr(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1)), ".") - 1))) <> Public_Database_custom_name Then

                        Public_Database_custom_name = CStr(left(CStr(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1)), CInt(InStrRev(CStr(Mid(Public_Database_Server_Url, InStrRev(Public_Database_Server_Url, "/") + 1)), ".") - 1)))

                        '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
                        DatabaseModule.Public_Database_custom_name = Public_Database_custom_name: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串變量，更新賦值;
                        'DatabaseModule.Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text)
                        'Debug.Print VBA.TypeName(DatabaseModule)
                        'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_custom_name)
                        'Debug.Print DatabaseModule.Public_Database_custom_name
                        'Application.Evaluate Public_Database_module_name & ".Public_Database_custom_name = Public_Database_custom_name"
                        'Application.Run Public_Database_module_name & ".Public_Database_custom_name = Public_Database_custom_name"

                        '刷新操作面板中文本輸入框TextBox）元素："Database_name_input_TextBox" 的值，自定義的用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串串的文本輸入框元素（TextBox）;
                        DatabaseControlPanel.Controls("Database_name_input_TextBox").Text = CStr(Public_Database_custom_name)
                        'DatabaseControlPanel.Controls("Database_name_input_TextBox").Value = CStr(Public_Database_custom_name)

                    Else
                    End If

                End If

            Else
            End If

        End If

    End If

End Sub


'單選框鼠標左鍵單擊事件，表示判斷選擇使用的辨識對數據庫操作的指令，可以取值：("Add data", "Retrieve data", "Update data", "Delete data", "Retrieve count", "Add table(collection)", "Delete table(collection)", "SQL") 等自定義的操控指令名稱值字符串;
Private Sub Add_data_OptionButton_Click()
    '判斷單選框控件的選中狀態
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_data_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_data_OptionButton").Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Retrieve_data_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Retrieve_data_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Update_Data_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Update_Data_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete_data_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete_data_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Retrieve_count_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Retrieve_count_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_table_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Add_table_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete_table_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("Delete_table_OptionButton").Caption)
    'End If
    'If DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("SQL_OptionButton").Value Then
    '    Public_Database_operational_order = CStr(DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls("SQL_OptionButton").Caption)
    'End If
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub Retrieve_data_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub Update_Data_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub Delete_data_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub Retrieve_count_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub Add_table_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub Delete_table_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub
Private Sub SQL_OptionButton_Click()
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing
    End If
    '調用自定義的鏈接操控數據庫模塊 DatabaseModule 中的子過程，向窗體 DatabaseControlPanel 中的文本輸入框（TextBox）控件中填寫自定義的預設值;：
    'Public Sub input_default_value_DatabaseControlPanel(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_software_Frame_name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Database_name_input_TextBox_name As String, ByVal Data_table_name_input_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Manipulate_database_Frame_name As String, ByVal Field_name_position_Input_Label_name As String, ByVal Field_name_position_Input_TextBox_name As String, ByVal Field_data_position_Input_Label_name As String, ByVal Field_data_position_Input_TextBox_name As String, ByVal Field_name_position_Output_Label_name As String, ByVal Field_name_position_Output_TextBox_name As String, ByVal Field_data_position_Output_Label_name As String, ByVal Field_data_position_Output_TextBox_name As String, ParamArray OtherArgs())
    Call DatabaseModule.input_default_value_DatabaseControlPanel(Public_Database_software, Public_Database_operational_order, "Database_software_Frame", "Database_Server_Url_TextBox", "Database_name_input_TextBox", "Data_table_name_input_TextBox", "Username_TextBox", "Password_TextBox", "Delay_input_TextBox", "Delay_random_input_TextBox", "Manipulate_database_Frame", "Field_name_position_Input_Label", "Field_name_position_Input_TextBox", "Field_data_position_Input_Label", "Field_data_position_Input_TextBox", "Field_name_position_Output_Label", "Field_name_position_Output_TextBox", "Field_data_position_Output_Label", "Field_data_position_Output_TextBox")
End Sub

Private Sub Run_CommandButton_Click()
'鼠標左鍵單擊“啓動運行（Run）”按鈕事件。
'用戶窗體運行後，鼠標左鍵單擊“Run”命令按鈕，執行這段程序。調用子程序 “DatabaseModule.Run(Public_Database_software, Public_Database_operational_order, Public_Database_Server_Url, Public_Database_custom_name, Public_Data_table_custom_name, Public_Database_Server_Username, Public_Database_Server_Password, Public_Field_name_input_position, Public_Field_data_input_position, Public_Field_name_output_position, Public_Field_data_output_position)” 。


    '更改按鈕狀態和標志
    PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
    If Not (DatabaseControlPanel.Controls("Run_CommandButton") Is Nothing) Then
        Select Case PublicVariableStartORStopButtonClickState
            Case True
                DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Run")
            Case False
                DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Abort")
            Case Else
                MsgBox "Run or Abort Button" & "\\n" & "Private Sub Run_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
        End Select
    End If
    'Debug.Print "Run or Abort Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
    '刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
    DatabaseModule.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（監測窗體中啓動運行按钮控件的點擊狀態，布爾型）變量更新賦值
    'Debug.Print VBA.TypeName(DatabaseModule)
    'Debug.Print VBA.TypeName(DatabaseModule.PublicVariableStartORStopButtonClickState)
    'Debug.Print DatabaseModule.PublicVariableStartORStopButtonClickState
    'Application.Evaluate Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
    'Application.Run Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
    '判斷是否跳出子過程不繼續執行後面的動作
    If PublicVariableStartORStopButtonClickState Then

        ''刷新控制面板窗體控件中包含的提示標簽顯示值
        'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
        '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "運行過程被中止.": Rem 提示運行過程執行狀態，賦值給標簽控件 Database_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Database_status_Label”的“text”屬性值 Database_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
        'End If

        'Debug.Print "Run or Abort Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
        '刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
        DatabaseModule.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（監測窗體中啓動運行按钮控件的點擊狀態，布爾型）變量更新賦值
        'Debug.Print VBA.TypeName(DatabaseModule)
        'Debug.Print VBA.TypeName(DatabaseModule.PublicVariableStartORStopButtonClickState)
        'Debug.Print DatabaseModule.PublicVariableStartORStopButtonClickState
        'Application.Evaluate Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
        'Application.Run Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"

        '使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
        If Not (DatabaseControlPanel.Controls("delay") Is Nothing) Then
            Call DatabaseControlPanel.delay(DatabaseControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
        End If

        DatabaseControlPanel.Run_CommandButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Run_CommandButton（啓動運行按鈕），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Access_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Access_OptionButton（用於判別標識指定使用 Microsoft Office Access 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.MongoDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MongoDB_OptionButton（用於判別標識指定使用 MongoDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.MariaDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MariaDB_OptionButton（用於判別標識指定使用 MariaDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.PostgreSQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 PostgreSQL_OptionButton（用於判別標識指定使用 PostgreSQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.MySQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MySQL_OptionButton（用於判別標識指定使用 MySQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Database_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_name_input_TextBox（用於指定待鏈接操控的自定義數據庫命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Data_table_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Data_table_name_input_TextBox（用於指定待鏈接操控的自定義數據庫包含的數據二維表格（集合）命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Field_name_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_name_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Field_data_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Field_name_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Field_data_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Add_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_data_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入數據）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Retrieve_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_data_OptionButton（用於標識選擇某一個具體操控指令（檢索查找數據）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Update_Data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Update_Data_OptionButton（用於標識選擇某一個具體操控指令（修改更新數據）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Delete_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_data_OptionButton（用於標識選擇某一個具體操控指令（刪除指定數據）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Retrieve_count_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_count_OptionButton（用於標識選擇某一個具體操控指令（檢索數據的條數）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Add_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_table_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.Delete_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_table_OptionButton（用於標識選擇某一個具體操控指令（刪除指定保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
        DatabaseControlPanel.SQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 SQL_OptionButton（用於標識選擇某一個具體操控指令（執行傳入的 SQL 指令）的單選框），False 表示禁用點擊，True 表示可以點擊

        Exit Sub

    End If

    DatabaseControlPanel.Run_CommandButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Run_CommandButton（啓動運行按鈕），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Access_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Access_OptionButton（用於判別標識指定使用 Microsoft Office Access 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.MongoDB_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 MongoDB_OptionButton（用於判別標識指定使用 MongoDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.MariaDB_OptionButton.Enabled = False: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MariaDB_OptionButton（用於判別標識指定使用 MariaDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.PostgreSQL_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 PostgreSQL_OptionButton（用於判別標識指定使用 PostgreSQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.MySQL_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 MySQL_OptionButton（用於判別標識指定使用 MySQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Database_Server_Url_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Database_name_input_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_name_input_TextBox（用於指定待鏈接操控的自定義數據庫命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Data_table_name_input_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Data_table_name_input_TextBox（用於指定待鏈接操控的自定義數據庫包含的數據二維表格（集合）命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Username_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Password_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_name_position_Input_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_name_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_data_position_Input_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_name_position_Output_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_data_position_Output_TextBox.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Add_data_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_data_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Retrieve_data_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_data_OptionButton（用於標識選擇某一個具體操控指令（檢索查找數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Update_Data_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Update_Data_OptionButton（用於標識選擇某一個具體操控指令（修改更新數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Delete_data_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_data_OptionButton（用於標識選擇某一個具體操控指令（刪除指定數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Retrieve_count_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_count_OptionButton（用於標識選擇某一個具體操控指令（檢索數據的條數）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Add_table_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_table_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Delete_table_OptionButton.Enabled = False: Rem 禁用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_table_OptionButton（用於標識選擇某一個具體操控指令（刪除指定保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.SQL_OptionButton.Enabled = False: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 SQL_OptionButton（用於標識選擇某一個具體操控指令（執行傳入的 SQL 指令）的單選框），False 表示禁用點擊，True 表示可以點擊

    'Call UserForm_Initialize: Rem 窗體初始化賦初值

    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。

    '判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("Microsoft Office Access"，"MongoDB"，"MariaDB"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB")
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        Dim element_i
        For Each element_i In Database_software_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing

        'Debug.Print "Database software = " & "[ " & Public_Database_software & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_software 值。
        '刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
        DatabaseModule.Public_Database_software = Public_Database_software: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串型變量）變量更新賦值
        'Debug.Print VBA.TypeName(DatabaseModule)
        'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_software)
        'Debug.Print DatabaseModule.Public_Database_software
        'Application.Evaluate Public_Database_module_name & ".Public_Database_software"
        'Application.Run Public_Database_module_name & ".Public_Database_software = Public_Database_software"
    End If

    '刷新提供數據存儲服務的數據庫服務器網址 URL 字符串
    If Not (DatabaseControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
        'Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value)
        Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    End If
    'Debug.Print "Database Server Url = " & "[ " & Public_Database_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_Server_Url 值。
    '刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
    DatabaseModule.Public_Database_Server_Url = Public_Database_Server_Url: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（提供數據存儲服務的數據庫服務器網址 URL 字符串）變量更新賦值
    'DatabaseModule.Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text)
    'DatabaseModule.Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value)
    'Debug.Print VBA.TypeName(DatabaseModule)
    'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_Server_Url)
    'Debug.Print DatabaseModule.Public_Database_Server_Url
    'Application.Evaluate Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"
    'Application.Run Public_Database_module_name & ".Public_Database_Server_Url = Public_Database_Server_Url"

    '刷新用於指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串
    If Not (DatabaseControlPanel.Controls("Database_name_input_TextBox") Is Nothing) Then
        'Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Value)
        Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text)
    End If
    DatabaseModule.Public_Database_custom_name = Public_Database_custom_name

    '刷新用於指定數據庫服務器中待鏈接操控的自定義數據庫中包含的數據二維表格（集合）名稱字符串
    If Not (DatabaseControlPanel.Controls("Data_table_name_input_TextBox") Is Nothing) Then
        'Public_Data_table_custom_name = CStr(DatabaseControlPanel.Controls("Data_table_name_input_TextBox").Value)
        Public_Data_table_custom_name = CStr(DatabaseControlPanel.Controls("Data_table_name_input_TextBox").Text)
    End If
    DatabaseModule.Public_Data_table_custom_name = Public_Data_table_custom_name

    '刷新用於驗證提供存儲數據服務的服務器的賬戶名字符串
    If Not (DatabaseControlPanel.Controls("Username_TextBox") Is Nothing) Then
        'Public_Database_Server_Username = CStr(DatabaseControlPanel.Controls("Username_TextBox").Value)
        Public_Database_Server_Username = CStr(DatabaseControlPanel.Controls("Username_TextBox").Text)
    End If
    DatabaseModule.Public_Database_Server_Username = Public_Database_Server_Username

    '刷新用於驗證提供存儲數據服務的服務器的賬戶密碼字符串
    If Not (DatabaseControlPanel.Controls("Password_TextBox") Is Nothing) Then
        'Public_Database_Server_Password = CStr(DatabaseControlPanel.Controls("Password_TextBox").Value)
        Public_Database_Server_Password = CStr(DatabaseControlPanel.Controls("Password_TextBox").Text)
    End If
    DatabaseModule.Public_Database_Server_Password = Public_Database_Server_Password

    '判斷選擇使用的辨識對數據庫操作的指令，可以取值：("Add data", "Retrieve data", "Update data", "Delete data", "Retrieve count", "Add table(collection)", "Delete table(collection)") 等自定義的操控指令名稱值字符串;
    '判斷子框架控件是否存在
    If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
        '遍歷框架中包含的子元素。
        'Dim element_i
        For Each element_i In Manipulate_database_Frame.Controls
            '判斷單選框控件的選中狀態
            If element_i.Value Then
                Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
                Exit For
            End If
        Next
        Set element_i = Nothing

        'Debug.Print "Database operational order = " & "[ " & Public_Database_operational_order & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_operational_order 值。
        '刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
        DatabaseModule.Public_Database_operational_order = Public_Database_operational_order: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（判斷選擇使用的辨識對數據庫操作的指令，字符串型變量）變量更新賦值
        'Debug.Print VBA.TypeName(DatabaseModule)
        'Debug.Print VBA.TypeName(DatabaseModule.Public_Database_operational_order)
        'Debug.Print DatabaseModule.Public_Database_operational_order
        'Application.Evaluate Public_Database_module_name & ".Public_Database_operational_order"
        'Application.Run Public_Database_module_name & ".Public_Database_operational_order = Public_Database_operational_order"
    End If

    '刷新向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串
    If Not (DatabaseControlPanel.Controls("Field_name_position_Input_TextBox") Is Nothing) Then
        'Public_Field_name_input_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Input_TextBox").Value)
        Public_Field_name_input_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Input_TextBox").Text)
    End If
    DatabaseModule.Public_Field_name_input_position = Public_Field_name_input_position

    '刷新向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串
    If Not (DatabaseControlPanel.Controls("Field_data_position_Input_TextBox") Is Nothing) Then
        'Public_Field_data_input_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Input_TextBox").Value)
        Public_Field_data_input_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Input_TextBox").Text)
    End If
    DatabaseModule.Public_Field_data_input_position = Public_Field_data_input_position

    '刷新從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串
    If Not (DatabaseControlPanel.Controls("Field_name_position_Output_TextBox") Is Nothing) Then
        'Public_Field_name_output_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Output_TextBox").Value)
        Public_Field_name_output_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Output_TextBox").Text)
    End If
    DatabaseModule.Public_Field_name_output_position = Public_Field_name_output_position

    '刷新從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串
    If Not (DatabaseControlPanel.Controls("Field_data_position_Output_TextBox") Is Nothing) Then
        'Public_Field_data_output_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Output_TextBox").Value)
        Public_Field_data_output_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Output_TextBox").Text)
    End If
    DatabaseModule.Public_Field_data_output_position = Public_Field_data_output_position

    '刷新自定義的延時等待時長
    'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
    If Not (DatabaseControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
        Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
        '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
        DatabaseModule.Public_Delay_length_input = Public_Delay_length_input
        'DatabaseModule.Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（人爲延時等待時長基礎值，單位毫秒，長整型）變量更新賦值
        'Debug.Print VBA.TypeName(DatabaseModule)
        'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length_input)
        'Debug.Print DatabaseModule.Public_Delay_length_input
        'Application.Evaluate Public_Database_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
        'Application.Run Public_Database_module_name & ".Public_Delay_length_input = Public_Delay_length_input"
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
    If Not (DatabaseControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
        Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
        '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
        DatabaseModule.Public_Delay_length_random_input = Public_Delay_length_random_input: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（人爲延時等待時長隨機波動範圍，單位為基礎值的百分比，單精度浮點型）變量更新賦值
        'DatabaseModule.Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text)
        'Debug.Print VBA.TypeName(DatabaseModule)
        'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length_random_input)
        'Debug.Print DatabaseModule.Public_Delay_length_random_input
        'Application.Evaluate Public_Database_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
        'Application.Run Public_Database_module_name & ".Public_Delay_length_random_input = Public_Delay_length_random_input"
    End If
    Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
    '刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
    DatabaseModule.Public_Delay_length = Public_Delay_length: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（經過隨機化之後的延時等待時長，長整型）變量更新賦值
    'Debug.Print VBA.TypeName(DatabaseModule)
    'Debug.Print VBA.TypeName(DatabaseModule.Public_Delay_length)
    'Debug.Print DatabaseModule.Public_Delay_length
    'Application.Evaluate Public_Database_module_name & ".Public_Delay_length = Public_Delay_length"
    'Application.Run Public_Database_module_name & ".Public_Delay_length = Public_Delay_length"



    ''刷新待插入目標數據源頁面的 JavaScript 脚本字符串
    'If Not (DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox") Is Nothing) Then
    '    'Public_Inject_data_page_JavaScript_filePath = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Value)
    '    Public_Inject_data_page_JavaScript_filePath = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    '    'Debug.Print Public_Inject_data_page_JavaScript_filePath
    'End If
    'If Public_Inject_data_page_JavaScript_filePath <> "" Then

    '    '判斷自定義的待插入目標數據源頁面的 JavaScript 脚本文檔是否存在
    '    Dim fso As Object, sFile As Object
    '    Set fso = CreateObject("Scripting.FileSystemObject")

    '    If fso.FileExists(Public_Inject_data_page_JavaScript_filePath) Then

    '        'Debug.Print "Inject_data_page_JavaScript source file: " & Public_Inject_data_page_JavaScript_filePath

    '        '使用 OpenTextFile 方法打開一個指定的文檔並返回一個 TextStream 對象，該對象可以對文檔進行讀操作或追加寫入操作
    '        '函數語法：object.OpenTextFile(filename[,iomode[,create[,format]]])
    '        '參數 filename 為目標文檔的路徑全名字符串
    '        '參數 iomode 表示輸入和輸出方式，可以為兩個常數之一：ForReading、ForAppending
    '        '參數 Create 表示如果指定的 filename 不存在時，是否可以新創建一個新文檔，為 Boolean 值，若創建新文檔取 True 值，不創建則取 False 值，預設為 False 值
    '        '參數 Format 為三種 Tristate 值之一，預設為以 ASCII 格式打開文檔

    '        '設置打開文檔參數常量
    '        Const ForReading = 1: Rem 打開一個只讀文檔，不能對文檔進行寫操作
    '        Const ForWriting = 2: Rem 打開一個可讀可寫操作的文檔，注意，會清空刪除文檔中原有的内容
    '        Const ForAppending = 8: Rem 打開一個可寫操作的文檔，並將指針移動到文檔的末尾，執行在文檔尾部追加寫入操作，不會刪除文檔中原有的内容
    '        Const TristateUseDefault = -2: Rem 使用系統缺省的編碼方式打開文檔
    '        Const TristateTrue = -1: Rem 以 Unicode 編碼的方式打開文檔
    '        Const TristateFalse = 0: Rem 以 ASCII 編碼的方式打開文檔，注意，漢字會亂碼

    '        '以只讀方式打開文檔
    '        Set sFile = fso.OpenTextFile(Public_Inject_data_page_JavaScript_filePath, ForReading, False, TristateUseDefault)

    '        ''判斷如果不是文檔文本的尾端，則持續讀取數據拼接
    '        'Public_Inject_data_page_JavaScript = ""
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.ReadLine & Chr(13): Rem 從打開的文檔中讀取一行字符串拼接，並在字符串結尾加上一個回車符號
    '        '    'Debug.Print sFile.ReadLine: Rem 讀取一行，不包括行尾的換行符
    '        'Loop
    '        'Do While Not sFile.AtEndOfStream
    '        '    Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript & sFile.Read(1): Rem 從打開的文檔中讀取一個字符拼接
    '        '    'Debug.Print sFile.Read(1): Rem 讀取一個字符
    '        'Loop

    '        Public_Inject_data_page_JavaScript = sFile.ReadAll: Rem 讀取文檔中的全部數據
    '        'Debug.Print sFile.ReadAll
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        'Public_Inject_data_page_JavaScript = StrConv(Public_Inject_data_page_JavaScript, vbUnicode, &H804): Rem 將 Unicode 編碼的字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
    '        'Debug.Print Public_Inject_data_page_JavaScript

    '        sFile.Close

    '    Else

    '        Debug.Print "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."
    '        'MsgBox "Inject_data_page_JavaScript ( " & Public_Inject_data_page_JavaScript_filePath & " ) error, Source file is Nothing."

    '    End If

    '    Set sFile = Nothing
    '    Set fso = Nothing

    'End If
    ''Debug.Print "Inject data page JavaScript filePath = " & "[ " & Public_Inject_data_page_JavaScript_filePath & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Inject_data_page_JavaScript_filePath 值。
    ''Debug.Print "Inject data page JavaScript = " & "[ " & Public_Inject_data_page_JavaScript & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Inject_data_page_JavaScript 值。
    ''刷新載入的統計算法模塊中的變量值，統計算法模塊名稱值為：("DatabaseModule")
    'DatabaseModule.Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本路徑全名）變量更新賦值
    ''DatabaseModule.Public_Inject_data_page_JavaScript_filePath = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    ''Debug.Print VBA.TypeName(DatabaseModule)
    ''Debug.Print VBA.TypeName(DatabaseModule.Public_Inject_data_page_JavaScript_filePath)
    ''Debug.Print DatabaseModule.Public_Inject_data_page_JavaScript_filePath
    ''Application.Evaluate Public_Database_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
    ''Application.Run Public_Database_module_name & ".Public_Inject_data_page_JavaScript_filePath = Public_Inject_data_page_JavaScript_filePath"
    'DatabaseModule.Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript: Rem 為導入的爬蟲策略模塊 DatabaseModule 中包含的（待插入目標數據源頁面的 JavaScript 脚本字符串）變量更新賦值
    '''DatabaseModule.Public_Inject_data_page_JavaScript = CStr(DatabaseControlPanel.Controls("Inject_data_page_JavaScript_TextBox").Text)
    ''Debug.Print VBA.TypeName(DatabaseModule)
    ''Debug.Print VBA.TypeName(DatabaseModule.Public_Inject_data_page_JavaScript)
    ''Debug.Print DatabaseModule.Public_Inject_data_page_JavaScript
    ''Application.Evaluate Public_Database_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"
    ''Application.Run Public_Database_module_name & ".Public_Inject_data_page_JavaScript = Public_Inject_data_page_JavaScript"



    '[A1] = URL1: Rem 這條語句用於測試，調式完畢後可刪除，效果是在 Excel 當前活動工作簿中的 A1 單元格中顯示變量 URL1 的值。
    'URL1 = Format(URL1, "yyyy-mm\/dd"): Rem "yyyy-mm\/dd" 轉換爲日期格式顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式
    'URL1 = Format(URL1, "GeneralNumber"): Rem GeneralNumber 轉換爲普通數字顯示。函數 format 是格式化字符串函數，可以規定輸出字符串的格式

    'DatabaseControlPanel.Hide: Rem 隱藏用戶窗體



    '刷新控制面板窗體控件中包含的提示標簽顯示值
    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
        DatabaseControlPanel.Controls("Database_status_Label").Caption = "假裝在等待的樣子 …": Rem 提示運行過程執行狀態，賦值給標簽控件 Database_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Database_status_Label”的“text”屬性值 Database_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    End If


    '調用運行導入的鏈接操控數據庫模塊 DatabaseModule 中包含的“Public Sub Run(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_Server_Url As String, ByVal Database_custom_name As String, ByVal Data_table_custom_name As String, ByVal Database_Server_Username As String, ByVal Database_Server_Password As String, ByVal Field_name_input_position As String, ByVal Field_data_input_position As String, ByVal Field_name_output_position As String, ByVal Field_data_output_position As String, ParamArray OtherArgs())”子過程/函數，啓動運算。Private 關鍵字表示子過程只在本模塊中有效，public 關鍵字表示子過程在所有模塊中都有效
    Call DatabaseModule.Run(Public_Database_software, Public_Database_operational_order, Public_Database_Server_Url, Public_Database_custom_name, Public_Data_table_custom_name, Public_Database_Server_Username, Public_Database_Server_Password, Public_Field_name_input_position, Public_Field_data_input_position, Public_Field_name_output_position, Public_Field_data_output_position): Rem
    'ThisWorkbook.VBProject.VBComponents("DatabaseModule").Controls("Run")


    ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    'If Not (DatabaseControlPanel.Controls("delay") Is Nothing) Then
    '    Call DatabaseControlPanel.delay(DatabaseControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    'End If


    ''刷新控制面板窗體控件中包含的提示標簽顯示值
    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "Execution completed.": Rem 提示運行過程執行狀態，賦值給標簽控件 Database_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Database_status_Label”的“text”屬性值 Database_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    'End If

    'Exit Sub


    '更改按鈕狀態和標志
    If Not PublicVariableStartORStopButtonClickState Then
        PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
        If Not (DatabaseControlPanel.Controls("Run_CommandButton") Is Nothing) Then
            Select Case PublicVariableStartORStopButtonClickState
                Case True
                    DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Run")
                Case False
                    DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Abort")
                Case Else
                    MsgBox "Run or Abort Button" & "\\n" & "Private Sub Run_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
            End Select
        End If
        'Debug.Print "Run or Abort Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
        '刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
        DatabaseModule.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（監測窗體中啓動運行按钮控件的點擊狀態，布爾型）變量更新賦值
        'Debug.Print VBA.TypeName(DatabaseModule)
        'Debug.Print VBA.TypeName(DatabaseModule.PublicVariableStartORStopButtonClickState)
        'Debug.Print DatabaseModule.PublicVariableStartORStopButtonClickState
        'Application.Evaluate Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
        'Application.Run Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
    End If

    DatabaseControlPanel.Run_CommandButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Run_CommandButton（啓動運行按鈕），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Access_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Access_OptionButton（用於判別標識指定使用 Microsoft Office Access 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.MongoDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MongoDB_OptionButton（用於判別標識指定使用 MongoDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.MariaDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MariaDB_OptionButton（用於判別標識指定使用 MariaDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.PostgreSQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 PostgreSQL_OptionButton（用於判別標識指定使用 PostgreSQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.MySQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MySQL_OptionButton（用於判別標識指定使用 MySQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Database_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_name_input_TextBox（用於指定待鏈接操控的自定義數據庫命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Data_table_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Data_table_name_input_TextBox（用於指定待鏈接操控的自定義數據庫包含的數據二維表格（集合）命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_name_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_name_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_data_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_name_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Field_data_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Add_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_data_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Retrieve_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_data_OptionButton（用於標識選擇某一個具體操控指令（檢索查找數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Update_Data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Update_Data_OptionButton（用於標識選擇某一個具體操控指令（修改更新數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Delete_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_data_OptionButton（用於標識選擇某一個具體操控指令（刪除指定數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Retrieve_count_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_count_OptionButton（用於標識選擇某一個具體操控指令（檢索數據的條數）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Add_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_table_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.Delete_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_table_OptionButton（用於標識選擇某一個具體操控指令（刪除指定保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
    DatabaseControlPanel.SQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 SQL_OptionButton（用於標識選擇某一個具體操控指令（執行傳入的 SQL 指令）的單選框），False 表示禁用點擊，True 表示可以點擊

End Sub



'*********************************************************************************************************************************************************************************


'如何通过VBA高亮显示EXCEL活动单元格所在行和列

'Private Sub Worksheet_SelectionChange(ByVal Target As Range)
'    If Target.EntireColumn.Address = Target.Address Then
'        Cells.Interior.ColorIndex = xlNone
'        Exit Sub
'    End If
'    If Target.EntireRow.Address = Target.Address Then
'        Cells.Interior.ColorIndex = xlNone
'        Exit Sub
'    End If
'    Cells.Interior.ColorIndex = xlNone
'    Rows(Selection.Row & ":" & Selection.Row + Selection.Rows.Count - 1).Interior.ColorIndex = 35
'    Columns(Selection.Column).Resize(, Selection.Columns.Count).Interior.ColorIndex = 20
'End Sub



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

