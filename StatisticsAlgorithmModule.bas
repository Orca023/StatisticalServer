Attribute VB_Name = "StatisticsAlgorithmModule"

'Author: ��������
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
'Date: ��ʮ����


'The codes were enhanced for both VBA7 (64-bit) and others (32-bit) by Long Vh.
#If VBA7 Then

    Private Declare PtrSafe Sub sleep Lib "kernel64" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 64 λܛ��ʹ���@�l�Z����
    Private Declare PtrSafe Function timeGetTime Lib "winmm.dll" () As Long: Rem 64 λܛ��ʹ���@�l�Z����
    
    '�� SendMessage ���������� SendMessage �� Windows ϵ�y API ������ʹ��ǰ���������Ȼ�����ʹ�á�
    Private Declare PtrSafe Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 64 λܛ��ʹ���@�l�Z����

#Else

    Private Declare Sub sleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 32 λܛ��ʹ���@�l�Z�������� sleep ���������� sleep �� Windows API ������ʹ��ǰ�����������Ȼ����ʹ�á��@�l�Z���Ǟ�����ʹ�� sleep �������_�ӕrʹ�õģ���������в�ʹ�� sleep ���������Ԅh���@�l�Z�䡣���� sleep ��ʹ�÷����ǣ�sleep 3000  '3000 ��ʾ 3000 ���롣���� sleep �ӕr�Ǻ��뼉�ģ����_�ȱ��^�ߣ��������ӕr�r�������������ʹ����ϵ�y���r�o��푑��Ñ������������L�ӕr���m��ʹ�á�
    Private Declare Function timeGetTime Lib "winmm.dll" () As Long: Rem 32 λܛ��ʹ���@�l�Z�������� timeGetTime ���������� timeGetTime �� Windows API ������ʹ��ǰ�����������Ȼ����ʹ�á��@�l�Z���Ǟ�����ʹ�� timeGetTime �������_�ӕrʹ�õģ���������в���Ҫʹ�� timeGetTime ����Ҳ���Ԅh���@�l�Z�䡣���� timeGetTime ���ص����_�C���F�ڵĺ��딵������֧�� 1 ������g���r�g��һֱ���ӡ�

    '�� SendMessage ���������� SendMessage �� Windows ϵ�y API ������ʹ��ǰ���������Ȼ�����ʹ�á�
    Private Declare Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 32 λܛ��ʹ���@�l�Z�������� SendMessage ���������� SendMessage �� Windows ϵ�y API ������ʹ��ǰ���������Ȼ�����ʹ�á�

#End If
Private Const WM_SYSCOMMAND = &H112: Rem ����������ʹ�õĳ���ֵ
Private Const SC_MINIMIZE = &HF020&: Rem ����������ʹ�õĳ���ֵ
'ʹ�ú���ʾ��
'SendMessage IEA.hwnd, WM_SYSCOMMAND, SC_MINIMIZE, 0: Rem ��g�[�����ڰl����Ϣ����С���g�[�����ڣ��@��ʹ�õ� Windows ϵ�y�� API ��������ģ�K�^���Ďחl�Z�������^



Rem ���ʹ��ȫ��׃�� public �ķ������F�����Ñ����w�Y߅��ȫ��׃���xֵ��ʽ���£�
Option Explicit: Rem �Z�� Option Explicit ��ʾǿ��Ҫ��׃����Ҫ������ʹ�ã���ȫ��׃�������Կ�Խ���������^��֮�gʹ�õģ����ڱO�y���w�а�ť�ؼ��c����B��
Public PublicCurrentWorkbookName As String: Rem ���xһ��ȫ���ͣ�Public���ַ�����׃����PublicCurrentWorkbookName������춴�Ů�ǰ�����������Q
Public PublicCurrentWorkbookFullName As String: Rem ���xһ��ȫ���ͣ�Public���ַ�����׃����PublicCurrentWorkbookFullName������춴�Ů�ǰ��������ȫ����������·�������Q��
Public PublicCurrentSheetName As String: Rem ���xһ��ȫ���ͣ�Public���ַ�����׃����PublicCurrentSheetName������춴�Ů�ǰ����������Q


Public Public_Statistics_Algorithm_module_name As String: Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ���
Public PublicVariableStartORStopButtonClickState As Boolean: Rem ���xһ��ȫ���ͣ�Public�������ͱ�����PublicVariableStartORStopButtonClickState����춱O�y���w�І���Ӌ�㰴ť�ؼ����c����B�����Ƿ������M��Ӌ��Ġ�B��ʾ

Public Public_Database_Server_Url As String: Rem ��춴惦Ӌ��Y���Ĕ�����������Wַ���ַ���׃��
Public Public_Statistics_Algorithm_Server_Url As String: Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
Public Public_Statistics_Algorithm_Server_Username As String: Rem ������ṩ�yӋ�\���������C���~�������ַ���׃��
Public Public_Statistics_Algorithm_Server_Password As String: Rem ������ṩ�yӋ�\���������C���~���ܴa���ַ���׃��
Public Public_Data_Receptors As String: Rem ��춴惦Ӌ��Y������������}�x��ֵ���ַ���׃������ȡֵ��("Database"��"Excel_and_Database"��"Excel")������ȡֵ��CStr("Excel")
Public Public_Statistics_Algorithm_Name As String: Rem ��ʾ�Д��x��ʹ�õı��R�yӋ�㷨�N�����ȡֵ��("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ���;
Public Public_Delay_length_input As Long: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L�Ļ��Aֵ����λ����
Public Public_Delay_length_random_input As Single: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L���S�C����������λ����Aֵ�İٷֱ�
Public Public_Delay_length As Long: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L����λ����
'Public Public_Delay_length As Integer: Rem ѭ�h�c������֮�g���t�ȴ��ĕr�L����λ����

'����ݔ��ݔ�������O��
Public Public_Data_name_input_position As String: Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���
Public Public_Data_input_position As String: Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���
Public Public_Result_output_position As String: Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���



Public Sub StatisticsAlgorithmModule_Initialize(): Rem �o׃���x��ֵ�����^�� Variable_Initialize ���������ęn���_���\�г�ʼ��

    '�Z�� On Error Resume Next ��ʹ�����ծa���e�`���Z��֮����Z���^�m����
    On Error Resume Next

    PublicCurrentWorkbookName = ThisWorkbook.name: Rem �@�î�ǰ�����������Q��Ч����ͬ춡� = ActiveWorkbook.Name ��
    PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem �@�î�ǰ��������ȫ����������·�������Q��
    PublicCurrentSheetName = ActiveSheet.name: Rem �@�î�ǰ����������Q
    'Debug.Print PublicCurrentSheetName


    Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

    'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���

    Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem ��춴惦Ӌ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://localhost:27016/insert?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password")
    Public_Data_Receptors = CStr("Excel"): Rem ��춴惦Ӌ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")

    Public_Delay_length_input = CLng(3000): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
    Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
    Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����

    Public_Statistics_Algorithm_Name = CStr("Interpolation"): Rem ��ʾ�Д��x��ʹ�õı��R�yӋ�㷨�N�����ȡֵ��("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ���;
    Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem ������ṩ�yӋ�\���������C���~�������ַ���׃��
    Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem ������ṩ�yӋ�\���������C���~���ܴa���ַ���׃��
    'Public_Statistics_Algorithm_Server_Url = "http://[::1]:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
    Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
    'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
    'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��

    '����ݔ��ݔ�������O��
    Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$L$1 ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���
    Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$L$12 ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���
    Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:M12"): Rem CStr(PublicCurrentSheetName & "!" & "K1:U12") : Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$N$1:$Y$12 Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���

    '�o�O�y���w�І����\�㰴ť�ؼ����c����B׃���x��ֵ��ʼ��
    PublicVariableStartORStopButtonClickState = True: Rem ������׃������춱O�y���w�І����\�㰴ť�ؼ����c����B�����Ƿ������M���\��Ġ�B��ʾ


    '���в�����崰�ڿؼ� StatisticsAlgorithmControlPanel �е�׃����ʼ���x��ֵ���� UserForm_Initialize()
    If Not (StatisticsAlgorithmControlPanel.Controls("UserForm_Initialize") Is Nothing) Then
        Call StatisticsAlgorithmControlPanel.UserForm_Initialize  '�{�ò�����崰�ڿؼ� StatisticsAlgorithmControlPanel �е�׃����ʼ���x��ֵ���� UserForm_Initialize()
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��O�y���w�І����\�㰴ť�ؼ����c����B��׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
        StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��yӋ�㷨ģ�K���Q�ַ�����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_module_name") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_module_name = Public_Statistics_Algorithm_module_name
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���춴惦Ӌ��Y���Ĕ�����������Wַ���ַ����ͣ�׃���x��ֵ������ CStr() ��ʾ�D�Q���ַ������
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Value = CStr(Public_Database_Server_Url)
        StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Text = CStr(Public_Database_Server_Url)
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���춴惦Ӌ��Y������������}�x��ֵ�ַ�����׃���x��ֵ����ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")������ CStr() ��ʾ�D�Q���ַ������
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_Receptors") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_Receptors = CStr(Public_Data_Receptors)
    End If
    'Debug.Print StatisticsAlgorithmControlPanel.Public_Data_Receptors
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
        '��v����а�������Ԫ�ء�
        Dim element_i
        For Each element_i In StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame").Controls
            If Public_Data_Receptors = "Excel_and_Database" Then
                '�Д��}�x��ؼ����@ʾֵ�ַ��������� CStr() ��ʾǿ���D�Q���ַ�����ͣ��K�����O���}�x��ؼ����x�Р�B
                If (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(0))) Or (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(1))) Then
                    element_i.Value = True: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                Else
                    element_i.Value = False: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                End If
            Else
                '�Д��}�x��ؼ����@ʾֵ�ַ��������� CStr() ��ʾǿ���D�Q���ַ�����ͣ��K�����O���}�x��ؼ����x�Р�B
                If CStr(element_i.Caption) = CStr(Public_Data_Receptors) Then
                    element_i.Value = True: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                Else
                    element_i.Value = False: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                End If
            End If
        Next
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�����ṩ�yӋ�\��ķ������Wַ���ַ����ͣ�׃���x��ֵ������ CStr() ��ʾ�D�Q���ַ������
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Value = CStr(Public_Statistics_Algorithm_Server_Url)
        StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Text = CStr(Public_Statistics_Algorithm_Server_Url)
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���ʾ�Д��x��ʹ�õı��R�yӋ�㷨�N��x��ֵ�ַ�����׃���x��ֵ������ȡֵ��("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ��������� CStr() ��ʾ�D�Q���ַ������;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Name") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name = CStr(Public_Statistics_Algorithm_Name)
    End If
    'Debug.Print StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame") Is Nothing) Then
        '��v����а�������Ԫ�ء�
        'Dim element_i
        For Each element_i In StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame").Controls
            '�Д����x��ؼ����@ʾֵ�ַ��������� CStr() ��ʾǿ���D�Q���ַ�����ͣ��K�����O���}�x��ؼ����x�Р�B
            If CStr(element_i.Caption) = CStr(Public_Statistics_Algorithm_Name) Then
                element_i.Value = True: Rem �O�Æ��x����x�Р�B���Y���鲼���͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                'Exit For
            Else
                element_i.Value = False: Rem �O�Æ��x����x�Р�B���Y���鲼���͡����� CStr() ��ʾ�D�Q���ַ�����͡�
                'Exit For
            End If
        Next
        Set element_i = Nothing
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�������ṩ�yӋ�\���������C���~�����ַ�����׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Username") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Username_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Value = Public_Statistics_Algorithm_Server_Username
        StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Text = Public_Statistics_Algorithm_Server_Username
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�������ṩ�yӋ�\���������C���~���ܴa�ַ�����׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Password") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Password_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Value = Public_Statistics_Algorithm_Server_Password
        StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Text = Public_Statistics_Algorithm_Server_Password
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃���x��ֵ������ CLng() ��ʾǿ���D�Q���L����;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        If CLng(Public_Delay_length_input) = CLng(0) Then
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value = ""
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value = CStr(Public_Delay_length_input): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y�����L���͡�
            StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text = CStr(Public_Delay_length_input): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y�����L���͡�
        End If
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃���x��ֵ������ CSng() ��ʾǿ���D�Q��ξ��ȸ��c��;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        If CSng(Public_Delay_length_input) = CSng(0#) Then
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value = ""
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value = CStr(Public_Delay_length_random_input): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y����ξ��ȸ��c�͡�
            StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text = CStr(Public_Delay_length_random_input): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����ξ��ȸ��c�͡�
        End If
    End If
    
    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��ˠ��ӕr�ȴ��ĕr�L����λ���룬�L���ͣ�׃���x��ֵ������ CLng() ��ʾǿ���D�Q���L����;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length = CLng(Public_Delay_length)
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�ã��ַ����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_name_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_name_input_position = Public_Data_name_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Value = CStr(Public_Data_name_input_position): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
        StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Text = CStr(Public_Data_name_input_position): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���Ӌ��Ĕ����ֶ���Excel����еĂ���λ�ã��ַ����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_input_position = Public_Data_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Data_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Value = CStr(Public_Data_input_position): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
        StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Text = CStr(Public_Data_input_position): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�ã��ַ����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Result_output_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Result_output_position = Public_Result_output_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Value = CStr(Public_Result_output_position): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
        StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Text = CStr(Public_Result_output_position): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
    End If

End Sub


'Sub delay(T As Long): Rem ����һ���Զ��x���_�ӕr���^�̣����������Ҫ�ӕr���ܕrֱ���{�á��÷��飺delay(T);��T������Ҫ�ӕr�ĕr�L����λ�Ǻ��룬ȡֵ��󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ���@��ֵ�Ĺ����� 0 �� 2^32 ֮�g����s�� 49.71 �ա��P�I�� Private ��ʾ���^��������ֻ�ڱ�ģ�K��Ч���P�I�� Public ��ʾ���^��������������ģ�K����Ч
'    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣
'    Dim time1 As Long
'    time1 = timeGetTime: Rem ���� timeGetTime ��ʾϵ�y�r�g��ԓ�r�g���ϵ�y�_�����������^�ĕr�g����λ���룩�����m�n��ӛ䛡�
'    Do
'        'If Not (StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
'        '    If timeGetTime - time1 < T Then
'        '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ " & CStr(timeGetTime - time1) & " ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
'        '    End If
'        '    If timeGetTime - time1 >= T Then
'        '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ 0 ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
'        '    End If
'        'End If
'
'        DoEvents: Rem �Z�� DoEvents ��ʾ����ϵ�y CPU ���ƙ�߀�o����ϵ�y��Ҳ�����ڴ�ѭ�h�A�Σ��Ñ�����ͬ�r������X���������ã������ǌ��������ֱ��ѭ�h�Y����

'    Loop While timeGetTime - time1 < T
'
'    'If Not (StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
'    '    If timeGetTime - time1 < T Then
'    '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ " & CStr(timeGetTime - time1) & " ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
'    '    End If
'    '    If timeGetTime - time1 >= T Then
'    '        StatisticsAlgorithmControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "�ӕr�ȴ� [ 0 ] ����": Rem ˢ����ʾ�˺����@ʾ�ˠ��ӕr�ȴ��ĕr�g�L�ȣ���λ���롣
'    '    End If
'    'End If
'
'End Sub


'���w StatisticsAlgorithmControlPanel �е��ı�ݔ���TextBox���ؼ�����Զ��x���A�Oֵ;
Public Sub input_default_value_StatisticsAlgorithmControlPanel(ByVal Statistics_Algorithm_Name As String, ByVal Database_Server_Url_TextBox_name As String, ByVal Data_Receptors_Frame_name As String, ByVal Statistics_Algorithm_Server_Url_TextBox_name As String, ByVal Username_TextBox_name As String, ByVal Password_TextBox_name As String, ByVal Delay_input_TextBox_name As String, ByVal Delay_random_input_TextBox_name As String, ByVal Field_name_of_Data_Input_TextBox_name As String, ByVal Data_TextBox_name As String, ByVal Output_position_TextBox_name As String)


    '�Z�� On Error Resume Next ��ʹ�����ծa���e�`���Z��֮����Z���^�m����
    On Error Resume Next


    Public_Statistics_Algorithm_Name = CStr(Statistics_Algorithm_Name): Rem ��ʾ�Д��x��ʹ�õı��R�yӋ�㷨�N�����ȡֵ��("test", "Interpolation", "Logistic", "Cox", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ���;


    PublicCurrentWorkbookName = ThisWorkbook.name: Rem �@�î�ǰ�����������Q��Ч����ͬ춡� = ActiveWorkbook.Name ��
    PublicCurrentWorkbookFullName = ThisWorkbook.FullName: Rem �@�î�ǰ��������ȫ����������·�������Q��
    PublicCurrentSheetName = ActiveSheet.name: Rem �@�î�ǰ����������Q
    'Debug.Print PublicCurrentSheetName


    ''���в�����崰�ڿؼ� StatisticsAlgorithmControlPanel �е�׃����ʼ���x��ֵ���� UserForm_Initialize()
    'If Not (StatisticsAlgorithmControlPanel.Controls("UserForm_Initialize") Is Nothing) Then
    '    Call StatisticsAlgorithmControlPanel.UserForm_Initialize  '�{�ò�����崰�ڿؼ� StatisticsAlgorithmControlPanel �е�׃����ʼ���x��ֵ���� UserForm_Initialize()
    'End If


    ''�o�O�y���w�І����\�㰴ť�ؼ����c����B׃���x��ֵ��ʼ��
    'PublicVariableStartORStopButtonClickState = True: Rem ������׃������춱O�y���w�І����\�㰴ť�ؼ����c����B�����Ƿ������M���\��Ġ�B��ʾ

    ''�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��O�y���w�І����\�㰴ť�ؼ����c����B��׃���x��ֵ
    'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    'End If


    Select Case Statistics_Algorithm_Name

        Case Is = "Interpolation"

            Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���

            Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem ��춴惦Ӌ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem ��춴惦Ӌ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")

            Public_Delay_length_input = CLng(1000): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
            Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
            Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����

            Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem ������ṩ�yӋ�\���������C���~�������ַ���׃��
            Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem ������ṩ�yӋ�\���������C���~���ܴa���ַ���׃��
            'Public_Statistics_Algorithm_Server_Url = "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
            Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��

            '����ݔ��ݔ�������O��
            Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$L$1 ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���
            Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$L$12 ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���
            Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:M12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$N$1:$Y$12 Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���
 
        Case Is = "Polynomial3Fit"

            Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���

            Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem ��춴惦Ӌ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem ��춴惦Ӌ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")

            Public_Delay_length_input = CLng(1000): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
            Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
            Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����

            Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem ������ṩ�yӋ�\���������C���~�������ַ���׃��
            Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem ������ṩ�yӋ�\���������C���~���ܴa���ַ���׃��
            Public_Statistics_Algorithm_Server_Url = "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
            'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��

            '����ݔ��ݔ�������O��
            Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$L$1 ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���
            Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$L$12 ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���
            Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:U12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$N$1:$Y$12 Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���
 
        Case Is = "LC5PFit"

            Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���

            Public_Database_Server_Url = CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem ��춴惦Ӌ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem ��춴惦Ӌ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")

            Public_Delay_length_input = CLng(1000): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
            Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
            Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����

            Public_Statistics_Algorithm_Server_Username = CStr("username"): Rem ������ṩ�yӋ�\���������C���~�������ַ���׃��
            Public_Statistics_Algorithm_Server_Password = CStr("password"): Rem ������ṩ�yӋ�\���������C���~���ܴa���ַ���׃��
            Public_Statistics_Algorithm_Server_Url = "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
            'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��

            '����ݔ��ݔ�������O��
            Public_Data_name_input_position = CStr(PublicCurrentSheetName & "!" & "A1:I1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$L$1 ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���
            Public_Data_input_position = CStr(PublicCurrentSheetName & "!" & "A2:I12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$L$12 ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���
            Public_Result_output_position = CStr(PublicCurrentSheetName & "!" & "K1:U12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$N$1:$Y$12 Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���

        Case Else

            'MsgBox "ݔ����Զ��x�yӋ�㷨���Q�e�`���o���R�e��������Q��Statistics Algorithm name = " & CStr(Statistics_Algorithm_Name) & "����Ŀǰֻ�u����� (""test"", ""Interpolation"", ""Logistic"", ""Cox"", ""Polynomial3Fit"", ""LC5PFit"", ...) ���Զ��x�ĽyӋ�㷨."
            'Exit Sub

            'Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

            'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
            'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���

            Public_Database_Server_Url = "": Rem CStr("http://localhost:27016/insertOne?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"): Rem ��춴惦Ӌ��Y���Ĕ�����������Wַ���ַ���׃�������磺CStr("http://localhost:27016/insert?dbName=testWebData&dbTableName=test20220703&dbUser=admin_testWebData&dbPass=admin&Key=username:password")
            Public_Data_Receptors = CStr("Excel"): Rem ��춴惦Ӌ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")

            Public_Delay_length_input = CLng(0): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
            Public_Delay_length_random_input = CSng(0): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
            'Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
            Public_Delay_length = CLng(0): Rem CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����

            Public_Statistics_Algorithm_Server_Username = "": Rem CStr("username"): Rem ������ṩ�yӋ�\���������C���~�������ַ���׃��
            Public_Statistics_Algorithm_Server_Password = "": Rem CStr("password"): Rem ������ṩ�yӋ�\���������C���~���ܴa���ַ���׃��
            Public_Statistics_Algorithm_Server_Url = "": Rem "http://localhost:10001/" & CStr(Public_Statistics_Algorithm_Name) & "?Key=" & CStr(Public_Statistics_Algorithm_Server_Username) & ":" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmUser=" & CStr(Public_Statistics_Algorithm_Server_Username) & "&algorithmPass=" & CStr(Public_Statistics_Algorithm_Server_Password) & "&algorithmName=" & CStr(Public_Statistics_Algorithm_Name): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��
            'Public_Statistics_Algorithm_Server_Url = CStr("http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"): Rem ����ṩ�yӋ�\��ķ������Wַ���ַ���׃��

            '����ݔ��ݔ�������O��
            Public_Data_name_input_position = "": Rem CStr(PublicCurrentSheetName & "!" & "A1:L1"): Rem Sheet1!A1:L1 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$L$1 ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���
            Public_Data_input_position = "": Rem CStr(PublicCurrentSheetName & "!" & "A2:L12"): Rem Sheet1!A2:L12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$L$12 ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���
            Public_Result_output_position = "": Rem CStr(PublicCurrentSheetName & "!" & "N1:Y12"): Rem Sheet1!N1:Y12 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$N$1:$Y$12 Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���
 
    End Select


    ''�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��yӋ�㷨ģ�K���Q�ַ�����ͣ�׃���x��ֵ
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_module_name") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_module_name = Public_Statistics_Algorithm_module_name
    'End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���춴惦Ӌ��Y���Ĕ�����������Wַ���ַ����ͣ�׃���x��ֵ������ CStr() ��ʾ�D�Q���ַ������
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Database_Server_Url_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Database_Server_Url_TextBox_name).Value = CStr(Public_Database_Server_Url)
        StatisticsAlgorithmControlPanel.Controls(Database_Server_Url_TextBox_name).Text = CStr(Public_Database_Server_Url)
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���춴惦Ӌ��Y������������}�x��ֵ�ַ�����׃���x��ֵ����ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")������ CStr() ��ʾ�D�Q���ַ������
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_Receptors") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_Receptors = CStr(Public_Data_Receptors)
    End If
    'Debug.Print StatisticsAlgorithmControlPanel.Public_Data_Receptors
    '�Д��ӿ�ܿؼ��Ƿ����
    If Not (StatisticsAlgorithmControlPanel.Controls(Data_Receptors_Frame_name) Is Nothing) Then
        '��v����а�������Ԫ�ء�
        Dim element_i
        For Each element_i In StatisticsAlgorithmControlPanel.Controls(Data_Receptors_Frame_name).Controls
            If Public_Data_Receptors = "Excel_and_Database" Then
                '�Д��}�x��ؼ����@ʾֵ�ַ��������� CStr() ��ʾǿ���D�Q���ַ�����ͣ��K�����O���}�x��ؼ����x�Р�B
                If (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(0))) Or (CStr(element_i.Caption) = CStr(VBA.Split(Public_Data_Receptors, "_and_")(1))) Then
                    element_i.Value = True: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                Else
                    element_i.Value = False: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                End If
            Else
                '�Д��}�x��ؼ����@ʾֵ�ַ��������� CStr() ��ʾǿ���D�Q���ַ�����ͣ��K�����O���}�x��ؼ����x�Р�B
                If CStr(element_i.Caption) = CStr(Public_Data_Receptors) Then
                    element_i.Value = True: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                Else
                    element_i.Value = False: Rem �O���}�x��ؼ����x�Р�B���Y���鲼���͡�
                End If
            End If
        Next
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�����ṩ�yӋ�\��ķ������Wַ���ַ����ͣ�׃���x��ֵ������ CStr() ��ʾ�D�Q���ַ������
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Url") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Statistics_Algorithm_Server_Url_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Statistics_Algorithm_Server_Url_TextBox_name).Value = CStr(Public_Statistics_Algorithm_Server_Url)
        StatisticsAlgorithmControlPanel.Controls(Statistics_Algorithm_Server_Url_TextBox_name).Text = CStr(Public_Statistics_Algorithm_Server_Url)
    End If

    ''�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���ʾ�Д��x��ʹ�õı��R�yӋ�㷨�N��x��ֵ�ַ�����׃���x��ֵ������ȡֵ��("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ��������� CStr() ��ʾ�D�Q���ַ������;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Name") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name = CStr(Public_Statistics_Algorithm_Name)
    'End If
    ''Debug.Print StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name
    ''�Д��ӿ�ܿؼ��Ƿ����
    'If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame") Is Nothing) Then
    '    '��v����а�������Ԫ�ء�
    '    'Dim element_i
    '    For Each element_i In StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame").Controls
    '        '�Д����x��ؼ����@ʾֵ�ַ��������� CStr() ��ʾǿ���D�Q���ַ�����ͣ��K�����O���}�x��ؼ����x�Р�B
    '        If CStr(element_i.Caption) = CStr(Public_Statistics_Algorithm_Name) Then
    '            element_i.Value = True: Rem �O�Æ��x����x�Р�B���Y���鲼���͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '            'Exit For
    '        Else
    '            element_i.Value = False: Rem �O�Æ��x����x�Р�B���Y���鲼���͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '            'Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing
    'End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�������ṩ�yӋ�\���������C���~�����ַ�����׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Username") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Username_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Username_TextBox_name).Value = Public_Statistics_Algorithm_Server_Username
        StatisticsAlgorithmControlPanel.Controls(Username_TextBox_name).Text = Public_Statistics_Algorithm_Server_Username
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�������ṩ�yӋ�\���������C���~���ܴa�ַ�����׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Password") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Password_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Password_TextBox_name).Value = Public_Statistics_Algorithm_Server_Password
        StatisticsAlgorithmControlPanel.Controls(Password_TextBox_name).Text = Public_Statistics_Algorithm_Server_Password
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��ˠ��ӕr�ȴ��r�L���Aֵ����λ���룬�L���ͣ�׃���x��ֵ������ CLng() ��ʾǿ���D�Q���L����;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name) Is Nothing) Then
        If CLng(Public_Delay_length_input) = CLng(0) Then
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Value = ""
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Value = CStr(Public_Delay_length_input): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y�����L���͡�
            StatisticsAlgorithmControlPanel.Controls(Delay_input_TextBox_name).Text = CStr(Public_Delay_length_input): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y�����L���͡�
        End If
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȣ��ξ��ȸ��c�ͣ�׃���x��ֵ������ CSng() ��ʾǿ���D�Q��ξ��ȸ��c��;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name) Is Nothing) Then
        If CSng(Public_Delay_length_input) = CSng(0#) Then
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Value = ""
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Text = ""
        Else
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Value = CStr(Public_Delay_length_random_input): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y����ξ��ȸ��c�͡�
            StatisticsAlgorithmControlPanel.Controls(Delay_random_input_TextBox_name).Text = CStr(Public_Delay_length_random_input): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����ξ��ȸ��c�͡�
        End If
    End If
    
    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ��ˠ��ӕr�ȴ��ĕr�L����λ���룬�L���ͣ�׃���x��ֵ������ CLng() ��ʾǿ���D�Q���L����;
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length = CLng(Public_Delay_length)
    End If


    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�ã��ַ����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_name_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_name_input_position = Public_Data_name_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Field_name_of_Data_Input_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Field_name_of_Data_Input_TextBox_name).Value = CStr(Public_Data_name_input_position): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
        StatisticsAlgorithmControlPanel.Controls(Field_name_of_Data_Input_TextBox_name).Text = CStr(Public_Data_name_input_position): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ���Ӌ��Ĕ����ֶ���Excel����еĂ���λ�ã��ַ����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_input_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Data_input_position = Public_Data_input_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Data_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Data_TextBox_name).Value = CStr(Public_Data_input_position): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
        StatisticsAlgorithmControlPanel.Controls(Data_TextBox_name).Text = CStr(Public_Data_input_position): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
    End If

    '�������崰�ڿؼ� StatisticsAlgorithmControlPanel �а����ģ�Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�ã��ַ����ͣ�׃���x��ֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Result_output_position") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Result_output_position = Public_Result_output_position
    End If
    If Not (StatisticsAlgorithmControlPanel.Controls(Output_position_TextBox_name) Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls(Output_position_TextBox_name).Value = CStr(Public_Result_output_position): Rem ���ı�ݔ���ؼ��� .Value �����xֵ���Y���������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
        StatisticsAlgorithmControlPanel.Controls(Output_position_TextBox_name).Text = CStr(Public_Result_output_position): Rem ���ı�ݔ���ؼ��� .Text �����xֵ���Y����������׃�������� CInt() ��ʾǿ���D�Q������ͣ����� CStr() ��ʾǿ���D�Q���ַ������;
    End If

End Sub


'�Զ��x�����\��;
Public Sub startCalculate(ByVal Statistics_Algorithm_Name As String, ByVal Data_Receptors As String, ByVal Database_Server_Url As String, ByVal Statistics_Algorithm_Server_Url As String, ByVal Statistics_Algorithm_Server_Username As String, ByVal Statistics_Algorithm_Server_Password As String, ByVal Data_name_input_position As String, ByVal Data_input_position As String, ByVal Result_output_position As String, ParamArray OtherArgs())
'����һ������ ParamArray OtherArgs() ��ʾ��׃�������A�Oֵ��� "" �ַ������ɂ��� ("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ���֮һ��
'�{��ʾ����Call StatisticsAlgorithmModule.startCalculate(Public_Statistics_Algorithm_Name, Public_Data_Receptors, Public_Database_Server_Url, Public_Statistics_Algorithm_Server_Url, Public_Statistics_Algorithm_Server_Username, Public_Statistics_Algorithm_Server_Password, Public_Data_name_input_position, Public_Data_input_position, Public_Result_output_position, "test")
'��Ҫ����������²�����
'�����_�����І��� Julia �yӋ�㷨��������C:\>C:\Criss\Julia\Julia-1.6.2\bin\julia.exe -p 4 --project=C:/Criss/jl/ C:\Criss\jl\src\Router.jl
'����
'�����_�����І��� Python �yӋ�㷨��������C:\>C:\Criss\Python\Python38\python.exe C:\Criss\py\src\Router.py
'�����_�����І��� Python �yӋ�㷨��������C:\>C:\Criss\py\Scripts\python.exe C:\Criss\py\src\Router.py
'���� C:\Criss\py\Scripts\python.exe ��ʾʹ�ø��x�h�� py �е� python.exe �����\��;
'�����_�����І��� MongoDB ������������ˑ��ã�C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
'�����_�����І������朽Ӳ��� MongoDB ������������ˑ��õ��Զ��x�� Node.js ��������C:\Criss\DatabaseServer\MongoDB>C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:\Criss\DatabaseServer\MongoDB\Nodejs2MongodbServer.js host=0.0.0.0 port=27016 number_cluster_Workers=0 MongodbHost=0.0.0.0 MongodbPort=27017 dbUser=admin_MathematicalStatisticsData dbPass=admin dbName=MathematicalStatisticsData
'�����_�����І��� MongoDB ������͑��ˑ��ã�C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongo.exe mongodb://127.0.0.1:27017/MathematicalStatisticsData
'��ע�⣬�@һ����������횣����Ǳ�횆���  MongoDB ������͑��ˑ��ã������x�񲻆��ӣ�


    Application.CutCopyMode = False: Rem �˳��r�����@ʾԃ�����Ƿ���ռ��N�匦Ԓ��
    On Error Resume Next: Rem ��������e�r�����^���e���Z�䣬�^�m������һ�l�Z�䡣
    
    Dim i, j As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��


    ''ѭ�h�xȡ�����ȫ����׃������ֵ
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
        OtherArgs_Statistics_Algorithm_Name = "LC5PFit": Rem �Д��Զ��x�x��ĽyӋ�㷨�N�����ȡֵ��("test", "Interpolation", "Logistic", "Cox", "LC5PFit")
    End If
    'Debug.Print OtherArgs(LBound(OtherArgs))
    'Debug.Print OtherArgs_Statistics_Algorithm_Name


    ''���İ��o��B�͘�־
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
    ''ˢ�²�����崰�w�ؼ��е�׃��ֵ
    ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopButtonClickState ֵ��
    ''�������崰�w�ؼ� StatisticsAlgorithmControlPanel �а����ģ��O�y���w�І����\�㰴ť�ؼ����c����B�������ͣ�׃�������xֵ
    'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    'End If
    ''�Д��Ƿ��������^�̲��^�m��������Ą���
    'If PublicVariableStartORStopButtonClickState Then

    '    ''ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    '    'If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '    '    StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�\���^�̱���ֹ.": Rem ��ʾ�\���^�̈��Р�B���xֵ�o�˺��ؼ� calculate_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���calculate_status_Label���ġ�text������ֵ calculate_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    '    'End If

    '    ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopButtonClickState ֵ��
    '    ''ˢ���d��ĽyӋ�㷨ģ�K�е�׃��ֵ���yӋ�㷨ģ�K���Qֵ�飺("StatisticsAlgorithmModule")
    '    'StatisticsAlgorithmModule.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState: Rem �錧������x����ģ�K StatisticsAlgorithmModule �а����ģ��O�y���w�І����\�㰴ť�ؼ����c����B�������ͣ�׃�������xֵ
    '    ''Debug.Print VBA.TypeName(StatisticsAlgorithmModule)
    '    ''Debug.Print VBA.TypeName(StatisticsAlgorithmModule.PublicVariableStartORStopButtonClickState)
    '    ''Debug.Print StatisticsAlgorithmModule.PublicVariableStartORStopButtonClickState
    '    ''Application.Evaluate Public_Statistics_Algorithm_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
    '    ''Application.Run Public_Statistics_Algorithm_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"

    '    'ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
    '    If Not (StatisticsAlgorithmControlPanel.Controls("delay") Is Nothing) Then
    '        Call StatisticsAlgorithmControlPanel.delay(StatisticsAlgorithmControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
    '    End If

    '    StatisticsAlgorithmControlPanel.Start_calculate_CommandButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еİ��o�ؼ� Start_calculate_CommandButton�������\�㰴�o����False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Database_Server_Url_TextBox����춱���Ӌ��Y���Ĕ�����������Wַ URL �ַ���ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĶ��x��ؼ� Data_Receptors_CheckBox1������Д���R�x��Ӌ��Y��������� Database �Ķ��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĶ��x��ؼ� Data_Receptors_CheckBox2������Д���R�x��Ӌ��Y��������� Excel �Ķ��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Statistics_Algorithm_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Statistics_Algorithm_Server_Url_TextBox���ṩ�yӋ�㷨�ķ������Wַ URL �ַ���ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Username_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Username_TextBox�������C�ṩ�yӋ�㷨�ķ��������~����ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Password_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еİ��o�ؼ� Password_TextBox�������C�ṩ�yӋ�㷨�ķ��������~���ܴaݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Field_name_of_Data_Input_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Field_name_of_Data_Input_TextBox������ԭʼ�����ֶ����� Excel ��񱣴�^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Data_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Data_TextBox������ԭʼ������ Excel ��񱣴�^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Output_position_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Output_position_TextBox������Ӌ��Y���� Excel ���^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.FisherDiscriminant_OptionButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĆ��x��ؼ� FisherDiscriminant_OptionButton����춘��R�x��ĳһ�����w�㷨 FisherDiscriminant �Ć��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    StatisticsAlgorithmControlPanel.Interpolate_OptionButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĆ��x��ؼ� Interpolate_OptionButton����춘��R�x��ĳһ�����w�㷨 Interpolate �Ć��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
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


    '�Ŀ�����崰�w�а������ı�ݔ������xȡֵ��ˢ�´�Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ���ַ���;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox") Is Nothing) Then
    '    'Public_Data_name_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����ͣ���������ı�ݔ���ؼ���ݔ��ֵ��Sheet1!A1:H1 �� 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$H$1������Public_Data_name_input_position = "$A$1:$H$1"��
    '    Public_Data_name_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Field_name_of_Data_Input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����ͣ���������ı�ݔ���ؼ���ݔ��ֵ��Sheet1!A1:H1 �� 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$1:$H$1������Public_Data_name_input_position = "$A$1:$H$1"��
    'End If
    'Debug.Print Public_Data_name_input_position
    ''ˢ�¿�����崰�w�а�����׃������Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�ã��ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_name_input_position") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Data_name_input_position = Public_Data_name_input_position
    'End If
    'Dim Data_name_input_position As String
    'Data_name_input_position = Public_Data_name_input_position

    Dim Data_name_input_sheetName As String: Rem �ַ����ָ�֮��õ���ָ���Ĺ�����Sheet���������ַ���;
    Data_name_input_sheetName = ""
    Dim Data_name_input_rangePosition As String: Rem �ַ����ָ�֮��õ���ָ���Ć�Ԫ��^��Range����λ���ַ���;
    Data_name_input_rangePosition = ""
    If (Data_name_input_position <> "") And (InStr(1, Data_name_input_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
        Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M
        ReDim tempArr(0): Rem ��Ք��M
        tempArr = VBA.Split(Data_name_input_position, delimiter:="!", limit:=2, Compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '�h���ַ����׵Ć���̖��'��;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '�h���ַ���β�Ć���̖��'��;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�õĹ�����Sheet���������ַ���
        Data_name_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        'tempArr = VBA.Split(Data_name_input_position, delimiter:="!")
        '�h���ַ����׵Ć���̖��'��;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''�h���ַ���β�Ć���̖��'��;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�õĹ�����Sheet���������ַ���
        'Data_name_input_rangePosition = "": Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Data_name_input_rangePosition = Data_name_input_rangePosition & CStr(tempArr(i)): Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        '    Else
        '        Data_name_input_rangePosition = Data_name_input_rangePosition & "!" & CStr(tempArr(i)): Rem ��Ӌ��Ĕ����ֶ�����ֵ��Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        '    End If
        'Next
        'Debug.Print Data_name_input_sheetName & ", " & Data_name_input_rangePosition
    Else
        Data_name_input_rangePosition = Data_name_input_position
    End If


    ''�Ŀ�����崰�w�а������ı�ݔ������xȡֵ��ˢ�´�Ӌ��Ĕ����ֶ���Excel����еĂ���λ���ַ���;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Data_TextBox") Is Nothing) Then
    '    'Public_Data_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����ͣ���������ı�ݔ���ؼ���ݔ��ֵ��Sheet1!A2:H12 �� 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$H$12������Public_Data_input_position = "$A$2:$H$12"��
    '    Public_Data_input_position = CStr(StatisticsAlgorithmControlPanel.Controls("Data_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����ͣ���������ı�ݔ���ؼ���ݔ��ֵ��Sheet1!A2:H12 �� 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$A$2:$H$12������Public_Data_input_position = "$A$2:$H$12"��
    'End If
    'Debug.Print Public_Data_input_position
    ''ˢ�¿�����崰�w�а�����׃������Ӌ��Ĕ����ֶ���Excel����еĂ���λ�ã��ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_input_position") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Data_input_position = Public_Data_input_position
    'End If
    'Dim Data_input_position As String
    'Data_input_position = Public_Data_input_position

    Dim Data_input_sheetName As String: Rem �ַ����ָ�֮��õ���ָ���Ĺ�����Sheet���������ַ���;
    Data_input_sheetName = ""
    Dim Data_input_rangePosition As String: Rem �ַ����ָ�֮��õ���ָ���Ć�Ԫ��^��Range����λ���ַ���;
    Data_input_rangePosition = ""
    If (Data_input_position <> "") And (InStr(1, Data_input_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
        'Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M
        ReDim tempArr(0): Rem ��Ք��M
        tempArr = VBA.Split(Data_input_position, delimiter:="!", limit:=2, Compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '�h���ַ����׵Ć���̖��'��;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '�h���ַ���β�Ć���̖��'��;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ�õĹ�����Sheet���������ַ���
        Data_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        'tempArr = VBA.Split(Data_input_position, delimiter:="!")
        '�h���ַ����׵Ć���̖��'��;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''�h���ַ���β�Ć���̖��'��;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ�õĹ�����Sheet���������ַ���
        'Data_input_rangePosition = "": Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Data_input_rangePosition = Data_input_rangePosition & CStr(tempArr(i)): Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        '    Else
        '        Data_input_rangePosition = Data_input_rangePosition & "!" & CStr(tempArr(i)): Rem ��Ӌ��Ĕ����ֶ���Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        '    End If
        'Next
        'Debug.Print Data_input_sheetName & ", " & Data_input_rangePosition
    Else
        Data_input_rangePosition = Data_input_position
    End If


    ''�Ŀ�����崰�w�а������ı�ݔ������xȡֵ��ˢ��Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ���ַ���;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox") Is Nothing) Then
    '    'Public_Result_output_position = CStr(StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����ͣ���������ı�ݔ���ؼ���ݔ��ֵ��Sheet1!J1:L5 �� 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$J$1:$L$5������Public_Result_output_position = "$J$1:$L$5"��
    '    Public_Result_output_position = CStr(StatisticsAlgorithmControlPanel.Controls("Output_position_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����ͣ���������ı�ݔ���ؼ���ݔ��ֵ��Sheet1!J1:L5 �� 'C:\Criss\vba\Statistics\[ʾ��.xlsx]Sheet1'!$J$1:$L$5������Public_Result_output_position = "$J$1:$L$5"��
    'End If
    'Debug.Print Public_Result_output_position
    ''ˢ�¿�����崰�w�а�����׃����Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�ã��ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Result_output_position") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Result_output_position = Public_Result_output_position
    'End If
    'Dim Result_output_position As String
    'Result_output_position = Public_Result_output_position

    Dim Result_output_sheetName As String: Rem �ַ����ָ�֮��õ���ָ���Ĺ�����Sheet���������ַ���;
    Result_output_sheetName = ""
    Dim Result_output_rangePosition As String: Rem �ַ����ָ�֮��õ���ָ���Ć�Ԫ��^��Range����λ���ַ���;
    Result_output_rangePosition = ""
    If (Result_output_position <> "") And (InStr(1, Result_output_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem ���ͣ�ӛ� for ѭ�h�Δ�׃��
        'Dim tempArr() As String: Rem �ַ����ָ�֮��õ��Ĕ��M
        ReDim tempArr(0): Rem ��Ք��M
        tempArr = VBA.Split(Result_output_position, delimiter:="!", limit:=2, Compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '�h���ַ����׵Ć���̖��'��;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '�h���ַ���β�Ć���̖��'��;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Result_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�õĹ�����Sheet���������ַ���
        Result_output_rangePosition = CStr(tempArr(UBound(tempArr))): Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        'tempArr = VBA.Split(Result_output_position, delimiter:="!")
        '�h���ַ����׵Ć���̖��'��;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''�h���ַ���β�Ć���̖��'��;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Result_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�õĹ�����Sheet���������ַ���
        'Result_output_rangePosition = "": Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Result_output_rangePosition = Result_output_rangePosition & CStr(tempArr(i)): Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        '    Else
        '        Result_output_rangePosition = Result_output_rangePosition & "!" & CStr(tempArr(i)): Rem Ӌ��֮��ĽY��ݔ����Excel����еĂ���λ�õĆ�Ԫ��^��Range����λ�õ��ַ���
        '    End If
        'Next
        'Debug.Print Result_output_sheetName & ", " & Result_output_rangePosition
    Else
        Result_output_rangePosition = Result_output_position
    End If


    ''ˢ����춱���Ӌ��Y���Ĕ�����������Wַ URL �ַ���
    'If Not (StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Value)
    '    Public_Database_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    'End If
    ''Debug.Print "Database Server Url = " & "[ " & Public_Database_Server_Url & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Database_Server_Url ֵ��
    ''ˢ�¿�����崰�w�а�����׃������춱���Ӌ��Y���Ĕ�����������Wַ URL �ַ������ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    'End If
    'Dim Database_Server_Url As String
    'Database_Server_Url = Public_Database_Server_Url

    ''��춴惦�ɼ��Y������������}�x��ֵ���ַ���׃������ȡ "Database"��"Excel_and_Database"��"Excel" ֵ������ȡֵ��CStr("Excel")
    ''�Д��ӿ�ܿؼ��Ƿ����
    'If Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame") Is Nothing) Then
    '    Public_Data_Receptors = ""
    '    '��v����а�������Ԫ�ء�
    '    Dim element_i
    '    For Each element_i In StatisticsAlgorithmControlPanel.Controls("Data_Receptors_Frame").Controls
    '        '�Д��}�x��ؼ����x�Р�B
    '        If element_i.Value Then
    '            If Public_Data_Receptors = "" Then
    '                Public_Data_Receptors = CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '            Else
    '                Public_Data_Receptors = Public_Data_Receptors & "_and_" & CStr(element_i.Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '            End If
    '        End If
    '    Next
    '    Set element_i = Nothing
    '    'If (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    '    Public_Data_Receptors = CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '    'ElseIf (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value) And (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    '    Public_Data_Receptors = CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Caption) & "_and_" & CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '    'ElseIf (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value) Then
    '    '    Public_Data_Receptors = CStr(StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Caption): Rem ���}�x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '    'ElseIf (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox1").Value)) And (Not (StatisticsAlgorithmControlPanel.Controls("Data_Receptors_CheckBox2").Value)) Then
    '    '    Public_Data_Receptors = ""
    '    'Else
    '    'End If

    '    'Debug.Print "Data Receptors = " & "[ " & Public_Data_Receptors & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Data_Receptors ֵ��
    '    'ˢ�¿�����崰�w�а�����׃������춴惦�ɼ��Y������������}�x��ֵ���ַ�����͵�׃��;
    '    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Data_Receptors") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Public_Data_Receptors = Public_Data_Receptors
    '    End If
    'End If
    'Dim Data_Receptors As String
    'Data_Receptors = Public_Data_Receptors

    ''ˢ���ṩ�yӋ�㷨�ķ������Wַ URL �ַ���
    'If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Statistics_Algorithm_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Value)
    '    Public_Statistics_Algorithm_Server_Url = CStr(StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Server_Url_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����ַ�����͡�
    'End If
    ''Debug.Print "Statistics Algorithm Server Url = " & "[ " & Public_Statistics_Algorithm_Server_Url & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Statistics_Algorithm_Server_Url ֵ��
    ''ˢ�¿�����崰�w�а�����׃�����ṩ�yӋ�㷨�ķ������Wַ URL �ַ������ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Url") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url
    'End If
    'Dim Statistics_Algorithm_Server_Url As String
    'Statistics_Algorithm_Server_Url = Public_Statistics_Algorithm_Server_Url

    ''�Єe���R�x��ָ��ĳһ�����w�ĽyӋ�㷨�N��ַ�����׃��������ȡֵ��("test", "Interpolation", "Logistic", "Cox", "Polynomial3Fit", "LC5PFit") ���Զ��x���㷨���Qֵ�ַ��������� CStr() ��ʾ�D�Q���ַ�����ͣ�����ȡֵ��CStr(2)
    ''�Д��ӿ�ܿؼ��Ƿ����
    'If Not (StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame") Is Nothing) Then
    '    '��v����а�������Ԫ�ء�
    '    'Dim element_i
    '    For Each element_i In StatisticsAlgorithmControlPanel.Controls("Statistics_Algorithm_Frame").Controls
    '        '�Д����x��ؼ����x�Р�B
    '        If element_i.Value Then
    '            Public_Statistics_Algorithm_Name = CStr(element_i.Caption): Rem �Ć��x����ȡֵ���Y�����ַ����͡����� CStr() ��ʾ�D�Q���ַ�����͡�
    '            Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing

    '    'Debug.Print "Statistics Algorithm name = " & "[ " & Public_Statistics_Algorithm_Name & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Statistics_Algorithm_Name ֵ��
    '    'ˢ�¿�����崰�w�а�����׃��������Єe���R�x��ָ��ĳһ�����w�ĽyӋ�㷨�NĘ�־���ַ�����͵�׃��;
    '    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Name") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Name = Public_Statistics_Algorithm_Name
    '    End If
    'End If
    'Dim Statistics_Algorithm_Name As String
    'Statistics_Algorithm_Name = Public_Statistics_Algorithm_Name

    ''ˢ�������C�ṩ�yӋ�㷨�ķ��������~�����ַ���
    'If Not (StatisticsAlgorithmControlPanel.Controls("Username_TextBox") Is Nothing) Then
    '    'Public_Statistics_Algorithm_Server_Username = CStr(StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Value)
    '    Public_Statistics_Algorithm_Server_Username = CStr(StatisticsAlgorithmControlPanel.Controls("Username_TextBox").Text)
    'End If
    ''Debug.Print "Statistics Algorithm Server Username = " & "[ " & Public_Statistics_Algorithm_Server_Username & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Statistics_Algorithm_Server_Username ֵ��
    ''ˢ�¿�����崰�w�а�����׃���������C�ṩ�yӋ�㷨�ķ��������~�����ַ������ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Username") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username
    'End If
    'Dim Statistics_Algorithm_Server_Username As String
    'Statistics_Algorithm_Server_Username = Public_Statistics_Algorithm_Server_Username

    ''ˢ�������C�ṩ�yӋ�㷨�ķ��������~���ܴa�ַ���
    'If Not (StatisticsAlgorithmControlPanel.Controls("Password_TextBox") Is Nothing) Then
    '    'Public_Statistics_Algorithm_Server_Password = CStr(StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Value)
    '    Public_Statistics_Algorithm_Server_Password = CStr(StatisticsAlgorithmControlPanel.Controls("Password_TextBox").Text)
    'End If
    ''Debug.Print "Statistics Algorithm Server Password = " & "[ " & Public_Statistics_Algorithm_Server_Password & " ]"
    ''ˢ�¿�����崰�w�а�����׃���������C�ṩ�yӋ�㷨�ķ��������~���ܴa�ַ������ַ�����͵�׃��;
    'If Not (StatisticsAlgorithmControlPanel.Controls("Public_Statistics_Algorithm_Server_Password") Is Nothing) Then
    '    StatisticsAlgorithmControlPanel.Public_Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password
    'End If
    'Dim Statistics_Algorithm_Server_Password As String
    'Statistics_Algorithm_Server_Password = Public_Statistics_Algorithm_Server_Password


    '���͔����ܱ�ʾ�Ĕ���������-32768 ~ 32767
    '�L���͔����ܱ�ʾ�Ĕ���������-2147483648 ~ 2147483647
    '�ξ��ȸ��c�ͣ��ڱ�ʾؓ���r���ܱ�ʾ�Ĕ���������-3.402823 �� E38 ~ -1.401298 �� E-45
    '�ξ��ȸ��c�ͣ��ڱ�ʾ�����r���ܱ�ʾ�Ĕ���������1.401298 �� E-45 ~ 3.402823 �� E38
    '�p���ȸ��c�ͣ��ڱ�ʾؓ���r���ܱ�ʾ�Ĕ���������-1.79769313486231 �� E308 ~ -4.94065645841247 �� E-324
    '�p���ȸ��c�ͣ��ڱ�ʾؓ���r���ܱ�ʾ�Ĕ���������4.94065645841247 �� E-324 ~ 1.79769313486231 �� E308
    'ע�⣬�ξ��ȸ��c�͔������侫���ǣ�6����ֻ�ܱ���С���c����� 6 λС���Ĕ������p���ȸ��c�ͣ��侫���ǣ�14����ֻ�ܱ���С���c����� 14 λС���Ĕ�����������������L�ȣ��t�������֕����h�����K�ҕ��Ԅ��Ē����롣


    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�xȡ Excel ����еĔ��� read data ��": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    End If


    Dim RNG As Range: Rem ���xһ�� Range ����׃����Rng����Range ������ָ Excel �������Ԫ����߆�Ԫ��^��

    Dim inputDataNameArray() As Variant: Rem Variant��String ��һ�������L���S���M׃������춴�Ŵ�Ӌ���ԭʼ�������Զ��x���Qֵ�ַ�����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    'ReDim inputDataNameArray(0 To X_UBound, 0 To Y_UBound) As String: Rem ���¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ�������Զ��x���Qֵ�ַ�����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    Dim inputDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������L���S���M׃������춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    'ReDim inputDataArray(0 To X_UBound, 0 To Y_UBound) As Single: Rem Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ

    Dim Data_Dict As Object  '��������ֵ�ֵ䣬ӛ����㷨�������l�͵ģ���춽yӋ�\���ԭʼ��������������l��֮ǰ��Ҫ�õ�������ģ�M��Module�����ֵ�׃���D�Q�� JSON �ַ���;
    Set Data_Dict = CreateObject("Scripting.Dictionary")

    Dim requestJSONText As String: Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
    requestJSONText = ""

    'ʹ�õ�����ģ�M��Module����clsJsConverter����ԭʼ�����ֵ� Data_Dict �D�Q�����㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ�����ע����h�ֵȷǣ�ASCII, American Standard Code for Information Interchange��������Ϣ���Q�˜ʴ��a���ַ������D�Q�� unicode ���a;
    'ʹ�õ�����ģ�M��Module����clsJsConverter �� Github �ٷ��}��Wַ��https://github.com/VBA-tools/VBA-JSON
    Dim JsonConverter As New clsJsConverter: Rem ��һ�� JSON ��������clsJsConverter������׃������� JSON �ַ����� VBA �ֵ䣨Dict��֮�g�����D�Q��JSON ��������clsJsConverter������׃���ǵ������ģ�K clsJsConverter ���Զ��x���b��ʹ��ǰ��Ҫ�_���ѽ�����ԓ�ģ�K��


    'Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

    'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���


    'Dim RNG As Range: Rem ���xһ�� Range ����׃����Rng����Range ������ָ Excel �������Ԫ����߆�Ԫ��^��
    If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
        Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
        MsgBox "��춽yӋ�\���ԭʼ�������Զ��x��־���Q�ֶε� Excel �����x�񹠇���Data name input = " & CStr(Public_Data_name_input_position) & "�����ջ�Y���e�`��Ŀǰֻ�ܽ������ Sheet1!A1:C5 �Y�����ַ���."
        Exit Sub
    Else
    End If
    'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant��String ���¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ�������Զ��x���Qֵ�ַ�����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    'inputDataNameArray = RNG: Rem RNG.Value
    'ʹ�� For ѭ�hǶ�ױ�v�ķ������� Excel ������Ć�Ԫ���е�ֵ������S���M������ Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
    ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem ���¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ�������Զ��x���Qֵ�ַ�����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    For i = 1 To RNG.Rows.Count
        For j = 1 To RNG.Columns.Count
            'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ
            inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
            'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
        Next j
    Next i
    Set RNG = Nothing: Rem ��Ռ���׃����RNG����ጷ��ڴ�
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
        MsgBox "��춽yӋ�\���ԭʼ����ֵ�� Excel �����x�񹠇���Data input = " & CStr(Public_Data_input_position) & "�����ջ�Y���e�`��Ŀǰֻ�ܽ������ Sheet1!A1:C5 �Y�����ַ���."
        Exit Sub
    Else
    End If
    ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant��Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    inputDataArray = RNG: Rem RNG.Value
    ''ʹ�� For ѭ�hǶ�ױ�v�ķ������� Excel ������Ć�Ԫ���е�ֵ������S���M������ Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
    'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    'For i = 1 To RNG.Rows.Count
    '    For j = 1 To RNG.Columns.Count
    '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ
    '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
    '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
    '    Next j
    'Next i
    Set RNG = Nothing: Rem ��Ռ���׃����RNG����ጷ��ڴ�
    'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
    '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
    '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
    '    Next j
    'Next i

    'Dim Data_Dict As Object  '��������ֵ�ֵ䣬ӛ����㷨�������l�͵ģ���춽yӋ�\���ԭʼ��������������l��֮ǰ��Ҫ�õ�������ģ�M��Module�����ֵ�׃���D�Q�� JSON �ַ���;
    'Set Data_Dict = CreateObject("Scripting.Dictionary")
    'Debug.Print Data_Dict.Count

    '�Д����M inputDataNameArray �Ƿ񠑿�
    'Dim Len_inputDataArray As Integer
    'Len_inputDataArray = UBound(inputDataArray, 1)
    'If Err.Number = 13 Then
    '    MsgBox "������춽yӋ�\���ԭʼ�����Ķ��S���M����."
    '    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    '    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "���C Stand by": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
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
        MsgBox "������춽yӋ�\���ԭʼ�����Ķ��S���M����."
        'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
        If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "���C Stand by": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
        End If
        Exit Sub
    End If

    'ѭ�h��v���S���M inputDataNameArray �� inputDataArray���xȡ����x��ȫ����춽yӋ�\���ԭʼ�������Զ��x��־���Q�ֶ�ֵ�ַ����͌����Ĕ���;
    Dim columnDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    Dim Len_empty As Integer: Rem ӛ䛔��M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ;
    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

        '��v�xȡ���еĔ�������һ�S���M
        'Dim columnDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
        ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
        'Dim Len_empty As Integer: Rem ӛ䛔��M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ;
        Len_empty = 0: Rem ӛ䛔��M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ;
        For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
            'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
            'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
            '�Д����M inputDataArray ��ǰԪ���Ƿ񠑿��ַ���
            If inputDataArray(i, j) = "" Then
                Len_empty = Len_empty + 1: Rem �����M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ�f�M��һ;
            Else
                columnDataArray(i) = inputDataArray(i, j)
            End If
            'Debug.Print columnDataArray(i)
        Next i
        'Debug.Print LBound(columnDataArray)
        'Debug.Print UBound(columnDataArray)

        '�ض��x���� Excel ĳһ�Д�����һ�S���M׃�����оS�ȣ��h������Ԫ�؞���ַ�����""����Ԫ�أ�ע�⣬���ʹ�� Preserve �������tֻ�����¶��x���S���M������һ���S�ȣ����оS�ȣ��������Ա������M��ԭ�е�Ԫ��ֵ����춴�Ů�ǰ����вɼ����Ĕ����Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
        If Len_empty <> 0 Then
            If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
                ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem �ض��x���� Excel ĳһ�Д�����һ�S���M׃�����оS�ȣ��h������Ԫ�؞���ַ�����""����Ԫ�أ�ע�⣬���ʹ�� Preserve �������tֻ�����¶��x���S���M������һ���S�ȣ����оS�ȣ��������Ա������M��ԭ�е�Ԫ��ֵ����춴�Ů�ǰ����вɼ����Ĕ����Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
            Else
                'ReDim columnDataArray(0): Rem ��Ք��M
                Erase columnDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M
            End If
        End If
        'Debug.Print LBound(columnDataArray)
        'Debug.Print UBound(columnDataArray)

        '�Д����M inputDataNameArray �Ƿ񠑿�
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
            '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
            If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
                Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
            Else
                Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem �ֵ�����ָ�����Iֵ��
            End If
        ElseIf inputDataNameArray(j) = "" Then
            '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
            If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
                Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
            Else
                Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem �ֵ�����ָ�����Iֵ��
            End If
        Else
            '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
            If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then
                Data_Dict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
            Else
                Data_Dict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem �ֵ�����ָ�����Iֵ��
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

    'ReDim inputDataNameArray(0): Rem ��Ք��M��ጷ��ڴ�
    Erase inputDataNameArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    'ReDim inputDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    Erase inputDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    Len_empty = 0
    'ReDim columnDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    Erase columnDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�

    Dim columnsDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '�����Д����M trainYdata-1��2��3 �Ƿ񠑿�
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
        ReDim columnsDataArray(LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
        For i = LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))
            Dim rowtrainYdataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 ��ÿһ�еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
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
    '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    If Data_Dict.Exists("trainYdata") Then
        Dim Len_trainYdata As String
        Len_trainYdata = ""
        Len_trainYdata = Trim(Join(Data_Dict("trainYdata")))
        If Len(Len_trainYdata) <> 0 Then
            ReDim columnsDataArray(LBound(Data_Dict("trainYdata")) To UBound(Data_Dict("trainYdata"))) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
            For i = LBound(Data_Dict("trainYdata")) To UBound(Data_Dict("trainYdata"))
                'Dim rowtrainYdataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 ��ÿһ�еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
                ReDim rowtrainYdataArray(1 To 1) As Variant
                rowtrainYdataArray(1) = Data_Dict("trainYdata")(i)
                columnsDataArray(i) = rowtrainYdataArray
            Next i
            Data_Dict.Item("trainYdata") = columnsDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
        End If
    ElseIf (Data_Dict.Exists("trainYdata_1") And Len(Len_trainYdata1) <> 0) Or (Data_Dict.Exists("trainYdata_2") And Len(Len_trainYdata2) <> 0) Or (Data_Dict.Exists("trainYdata_3") And Len(Len_trainYdata3) <> 0) Or (Data_Dict.Exists("trainYdata_4") And Len(Len_trainYdata4) <> 0) Or (Data_Dict.Exists("trainYdata_5") And Len(Len_trainYdata5) <> 0) Then
        Data_Dict.Add "trainYdata", columnsDataArray: Rem �ֵ�����ָ�����Iֵ��
    Else
        'ReDim columnsDataArray(0) As Variant
        'Data_Dict.Add "trainYdata", columnsDataArray: Rem �ֵ�����ָ�����Iֵ�������Ք��M
    End If

    ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_1"
    'If Data_Dict.Exists("trainYdata_1") Then
    '    Data_Dict.Remove ("trainYdata_1")
    'End If
    ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_2"
    'If Data_Dict.Exists("trainYdata_2") Then
    '    Data_Dict.Remove ("trainYdata_2")
    'End If
    ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_3"
    'If Data_Dict.Exists("trainYdata_3") Then
    '    Data_Dict.Remove ("trainYdata_3")
    'End If
    ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_4"
    'If Data_Dict.Exists("trainYdata_4") Then
    '    Data_Dict.Remove ("trainYdata_4")
    'End If
    ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_5"
    'If Data_Dict.Exists("trainYdata_5") Then
    '    Data_Dict.Remove ("trainYdata_5")
    'End If

    '�����Д����M testYdata-1��2��3 �Ƿ񠑿�
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
        ReDim columnsDataArray(LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ������ testYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
        For i = LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))
            Dim rowtestYdataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ testYdata-1��2��3 ��ÿһ�еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
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
    '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    If Data_Dict.Exists("testYdata") Then
        Dim Len_testYdata As String
        Len_testYdata = ""
        Len_testYdata = Trim(Join(Data_Dict("testYdata")))
        If Len(Len_testYdata) <> 0 Then
            ReDim columnsDataArray(LBound(Data_Dict("testYdata")) To UBound(Data_Dict("testYdata"))) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ������ testYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
            For i = LBound(Data_Dict("testYdata")) To UBound(Data_Dict("testYdata"))
                'Dim rowtestYdataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ testYdata-1��2��3 ��ÿһ�еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
                ReDim rowtestYdataArray(1 To 1) As Variant
                rowtestYdataArray(1) = Data_Dict("testYdata")(i)
                columnsDataArray(i) = rowtestYdataArray
            Next i
            Data_Dict.Item("testYdata") = columnsDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
        End If
    ElseIf (Data_Dict.Exists("testYdata_1") And Len(Len_testYdata1) <> 0) Or (Data_Dict.Exists("testYdata_2") And Len(Len_testYdata2) <> 0) Or (Data_Dict.Exists("testYdata_3") And Len(Len_testYdata3) <> 0) Then
        Data_Dict.Add "testYdata", columnsDataArray: Rem �ֵ�����ָ�����Iֵ��
    Else
        'ReDim columnsDataArray(0) As Variant
        'Data_Dict.Add "testYdata", columnsDataArray: Rem �ֵ�����ָ�����Iֵ�������Ք��M
    End If

    ''�h���ֵ� Data_Dict �еėlĿ "testYdata_1"
    'If Data_Dict.Exists("testYdata_1") Then
    '    Data_Dict.Remove ("testYdata_1")
    'End If
    ''�h���ֵ� Data_Dict �еėlĿ "testYdata_2"
    'If Data_Dict.Exists("testYdata_2") Then
    '    Data_Dict.Remove ("testYdata_2")
    'End If
    ''�h���ֵ� Data_Dict �еėlĿ "testYdata_3"
    'If Data_Dict.Exists("testYdata_3") Then
    '    Data_Dict.Remove ("testYdata_3")
    'End If


    ''������Ӌ��Y���Ķ��S���M׃�� resultDataArray �ք��D�Q�������� JSON ��ʽ���ַ���;
    'Dim columnName() As String: Rem ���S���M�������ֶΣ����У����Q�ַ���һ�S���M;
    'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem ���S���M�������ֶΣ����У����Q�ַ���һ�S���M;
    'columnName(1) = "Column_1"
    'columnName(2) = "Column_2"
    ''For i = 1 To UBound(columnName, 1)
    ''    Debug.Print columnName(i)
    ''Next i

    'Dim PostCode As String: Rem ��ʹ�� POST Ո��r���������SՈ��һ��l�͵��������˵� POST ֵ�ַ���
    'PostCode = ""
    'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""һ��"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""����"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""����"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""����"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""����"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""����""}"
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

    ''ʹ�� For ѭ�hǶ�ױ�v�ķ�������һ�S���M��ֵƴ�Ӟ� JSON �ַ��������� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
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
    '    'Debug.Print PostCode: Rem ���������ڴ�ӡƴ�����Ո�� Post ֵ��

    '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem Ո���^������POST �������L�ȡ�

    '    WHR.Send (PostCode): Rem ��������l�� Http Ո��(��Ո�����d�W퓔���)������ WHR.Open �rʹ�� "get" ��������ֱ���{�á�WHR.Send���l�ͣ��������������̖�еą��� (PostCode)��
    '    'WHR.WaitForResponse: Rem �ȴ���������XMLHTTP��Ҳ����ʹ��

    '    '�xȡ���������ص�푑�ֵ
    '    WHR.Response.write.Status: Rem ��ʾ�������˽ӵ�Ո���ᣬ���ص� HTTP 푑���B�a
    '    WHR.Response.write.responseText: Rem �O���������˷��ص�푑�ֵ�����ı���ʽ����
    '    'WHR.Response.BinaryWrite.ResponseBody: Rem �O���������˷��ص�푑�ֵ���Զ��M�Ɣ�������ʽ����

    '    ''Dim HTMLCode As Object: Rem ��һ�� htmlfile ����׃������춱��淵�ص�푑�ֵ��ͨ���� HTML �W�Դ���a
    '    ''Set HTMLCode = CreateObject("htmlfile"): Rem ����һ�� htmlfile ���󣬌���׃���xֵ��Ҫʹ�� set �P�I�ֲ��Ҳ���ʡ�ԣ���ͨ׃���xֵʹ�� let �P�I�ֿ���ʡ��
    '    '''HTMLCode.designMode = "on": Rem �_����݋ģʽ
    '    'HTMLCode.write .responseText: Rem ���딵���������������ص�푑�ֵ���x�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode��������푑��^�ęn
    '    'HTMLCode.body.innerhtml = WHR.responseText: Rem �����������ص�푑�ֵ HTML �W�Դ�a�еľW��w��body���ęn���ֵĴ��a���xֵ�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode�������� ��responsetext�� ����������ӵ��͑��˰l�͵� Http Ո��֮�ᣬ���ص�푑�ֵ��ͨ���� HTML Դ���a�������N��ʽ����ʹ�Å��� ResponseText ��ʾ�����������ص�푑�ֵ�������ַ����ı���������ʹ�Å��� ResponseXML ��ʾ�����������ص�푑�ֵ�� DOM ������푑�ֵ������ DOM �������m�t����ʹ�� JavaScript �Z�Բ��� DOM �������댢푑�ֵ������ DOM �����Ҫ����������ص�푑�ֵ��횠� XML ����ַ�������ʹ�Å��� ResponseBody ��ʾ�����������ص�푑�ֵ��������M����͵Ĕ��������M�Ɣ�������ʹ�� Adodb.Stream �M�в�����
    '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    '    'HTMLHead = WHR.GetAllResponseHeaders: Rem �xȡ���������ص�푑�ֵ HTML �W�Դ���a�е��^��head���ęn�������Ҫ��ȡ�W��^�ęn�е� Cookie ����ֵ����ʹ�á�.GetResponseHeader("set-cookie")��������

    '    Response_Text = WHR.responseText
    '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    '    'Debug.Print Response_Text

    'Next i


    ''ʹ�� For ѭ�hǶ�ױ�v�ķ����������S���M��ֵƴ�Ӟ� JSON �ַ��������� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
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
    'Debug.Print PostCode: Rem ���������ڴ�ӡƴ�����Ո�� Post ֵ��


    'ʹ�õ�����ģ�M��Module����clsJsConverter����ԭʼ�����ֵ� Data_Dict �D�Q�����㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ�����ע����h�ֵȷǣ�ASCII, American Standard Code for Information Interchange��������Ϣ���Q�˜ʴ��a���ַ������D�Q�� unicode ���a;
    'ʹ�õ�����ģ�M��Module����clsJsConverter �� Github �ٷ��}��Wַ��https://github.com/VBA-tools/VBA-JSON
    'Dim JsonConverter As New clsJsConverter: Rem ��һ�� JSON ��������clsJsConverter������׃������� JSON �ַ����� VBA �ֵ䣨Dict��֮�g�����D�Q��JSON ��������clsJsConverter������׃���ǵ������ģ�K clsJsConverter ���Զ��x���b��ʹ��ǰ��Ҫ�_���ѽ�����ԓ�ģ�K��
    'requestJSONText = JsonConverter.ConvertToJson(Data_Dict, Whitespace:=2): Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
    requestJSONText = JsonConverter.ConvertToJson(Data_Dict): Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
    'Debug.Print requestJSONText

    'ReDim columnsDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    Erase columnsDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    Data_Dict.RemoveAll: Rem ����ֵ䣬ጷ��ڴ�
    Set Data_Dict = Nothing: Rem ��Ռ���׃����Data_Dict����ጷ��ڴ�


    'Select Case Statistics_Algorithm_Name

    '    Case Is = "Interpolation"

    '    Case Is = "Logistic"

    '    Case Is = "Cox"

    '    Case Is = "Polynomial3Fit"

    '    Case Is = "LC5PFit"

    '        'Public_Statistics_Algorithm_module_name = "StatisticsAlgorithmModule": Rem ����ĽyӋ�㷨ģ�K���Զ��x����ֵ�ַ�������ǰ��̎��ģ�K����

    '        'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ęn·��ȫ��
    '        'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '�Ƿ�F�ھ�Ҫ�x�_����棿'+'///n'+'����Ҫ��Ҫ���c�� < ȡ�� > �P�]����棬�ڱ���һ��֮�����x�_�أ�';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) ��ʾ���x��һ������һ���΅�����һ�� j ���Ŀ�����������Ȼ���Եڶ��� j �錍���M���{��; */;};": Rem ������Ŀ�˔���Դ���� JavaScript �ű��ַ���

    '        'Dim RNG As Range: Rem ���xһ�� Range ����׃����Rng����Range ������ָ Excel �������Ԫ����߆�Ԫ��^��

    '        If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
    '        ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
    '        ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
    '            MsgBox "��춽yӋ�\���ԭʼ�������Զ��x��־���Q�ֶε� Excel �����x�񹠇���Data name input = " & CStr(Public_Data_name_input_position) & "�����ջ�Y���e�`��Ŀǰֻ�ܽ������ Sheet1!A1:C5 �Y�����ַ���."
    '            Exit Sub
    '        Else
    '        End If
    '        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant��String ���¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ�������Զ��x���Qֵ�ַ�����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '        'inputDataNameArray = RNG: Rem RNG.Value
    '        'ʹ�� For ѭ�hǶ�ױ�v�ķ������� Excel ������Ć�Ԫ���е�ֵ������S���M������ Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
    '        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem ���¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ�������Զ��x���Qֵ�ַ�����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '        For i = 1 To RNG.Rows.Count
    '            For j = 1 To RNG.Columns.Count
    '                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ
    '                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
    '                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
    '            Next j
    '        Next i
    '        Set RNG = Nothing: Rem ��Ռ���׃����RNG����ጷ��ڴ�

    '        If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
    '        ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
    '            Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
    '        ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
    '            MsgBox "��춽yӋ�\���ԭʼ����ֵ�� Excel �����x�񹠇���Data input = " & CStr(Public_Data_input_position) & "�����ջ�Y���e�`��Ŀǰֻ�ܽ������ Sheet1!A1:C5 �Y�����ַ���."
    '            Exit Sub
    '        Else
    '        End If
    '        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant��Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '        inputDataArray = RNG: Rem RNG.Value
    '        ''ʹ�� For ѭ�hǶ�ױ�v�ķ������� Excel ������Ć�Ԫ���е�ֵ������S���M������ Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
    '        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '        'For i = 1 To RNG.Rows.Count
    '        '    For j = 1 To RNG.Columns.Count
    '        '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ
    '        '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
    '        '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
    '        '    Next j
    '        'Next i
    '        Set RNG = Nothing: Rem ��Ռ���׃����RNG����ጷ��ڴ�

    '        'Dim Data_Dict As Object  '��������ֵ�ֵ䣬ӛ����㷨�������l�͵ģ���춽yӋ�\���ԭʼ��������������l��֮ǰ��Ҫ�õ�������ģ�M��Module�����ֵ�׃���D�Q�� JSON �ַ���;
    '        'Set Data_Dict = CreateObject("Scripting.Dictionary")
    '        'Debug.Print Data_Dict.Count

    '        '�Д����M inputDataNameArray �Ƿ񠑿�
    '        'Dim Len_inputDataArray As Integer
    '        'Len_inputDataArray = UBound(inputDataArray, 1)
    '        'If Err.Number = 13 Then
    '        '    MsgBox "������춽yӋ�\���ԭʼ�����Ķ��S���M����."
    '        '    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    '        '    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '        '        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "���C Stand by": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
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
    '            MsgBox "������춽yӋ�\���ԭʼ�����Ķ��S���M����."
    '            'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    '            If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '                StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "���C Stand by": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    '            End If
    '            Exit Sub
    '        End If

    '        'ѭ�h��v���S���M inputDataNameArray �� inputDataArray���xȡ����x��ȫ����춽yӋ�\���ԭʼ�������Զ��x��־���Q�ֶ�ֵ�ַ����͌����Ĕ���;
    '        Dim columnDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '        Dim Len_empty As Integer: Rem ӛ䛔��M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ;
    '        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

    '            '��v�xȡ���еĔ�������һ�S���M
    '            'Dim columnDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '            ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '            'Dim Len_empty As Integer: Rem ӛ䛔��M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ;
    '            Len_empty = 0: Rem ӛ䛔��M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ;
    '            For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
    '                'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
    '                'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer��Long��Single��Double�����¶��S���M׃�������оS�ȣ���춴�Ŵ�Ӌ���ԭʼ����ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '                '�Д����M inputDataArray ��ǰԪ���Ƿ񠑿��ַ���
    '                If inputDataArray(i, j) = "" Then
    '                    Len_empty = Len_empty + 1: Rem �����M inputDataArray Ԫ�ؠ����ַ�����""���Ĕ�Ŀ�f�M��һ;
    '                Else
    '                    columnDataArray(i) = inputDataArray(i, j)
    '                End If
    '                'Debug.Print columnDataArray(i)
    '            Next i
    '            'Debug.Print LBound(columnDataArray)
    '            'Debug.Print UBound(columnDataArray)

    '            '�ض��x���� Excel ĳһ�Д�����һ�S���M׃�����оS�ȣ��h������Ԫ�؞���ַ�����""����Ԫ�أ�ע�⣬���ʹ�� Preserve �������tֻ�����¶��x���S���M������һ���S�ȣ����оS�ȣ��������Ա������M��ԭ�е�Ԫ��ֵ����춴�Ů�ǰ����вɼ����Ĕ����Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '            If Len_empty <> 0 Then
    '                If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
    '                    ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem �ض��x���� Excel ĳһ�Д�����һ�S���M׃�����оS�ȣ��h������Ԫ�؞���ַ�����""����Ԫ�أ�ע�⣬���ʹ�� Preserve �������tֻ�����¶��x���S���M������һ���S�ȣ����оS�ȣ��������Ա������M��ԭ�е�Ԫ��ֵ����춴�Ů�ǰ����вɼ����Ĕ����Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '                Else
    '                    'ReDim columnDataArray(0): Rem ��Ք��M
    '                    Erase columnDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M
    '                End If
    '            End If
    '            'Debug.Print LBound(columnDataArray)
    '            'Debug.Print UBound(columnDataArray)

    '            '�Д����M inputDataNameArray �Ƿ񠑿�
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
    '                '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    '                If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
    '                    Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
    '                Else
    '                    Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem �ֵ�����ָ�����Iֵ��
    '                End If
    '            ElseIf inputDataNameArray(j) = "" Then
    '                '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    '                If Data_Dict.Exists(CStr("Column" & "-" & CStr(j))) Then
    '                    Data_Dict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
    '                Else
    '                    Data_Dict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem �ֵ�����ָ�����Iֵ��
    '                End If
    '            Else
    '                '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    '                If Data_Dict.Exists(CStr(inputDataNameArray(j))) Then
    '                    Data_Dict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
    '                Else
    '                    Data_Dict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem �ֵ�����ָ�����Iֵ��
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

    '        'ReDim inputDataNameArray(0): Rem ��Ք��M��ጷ��ڴ�
    '        Erase inputDataNameArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    '        'ReDim inputDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    '        Erase inputDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    '        Len_empty = 0
    '        'ReDim columnDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    '        Erase columnDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�

    '        Dim columnsDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '        '�����Д����M trainYdata-1��2��3 �Ƿ񠑿�
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
    '            ReDim columnsDataArray(LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '            For i = LBound(Data_Dict("trainYdata_1")) To UBound(Data_Dict("trainYdata_1"))
    '                Dim rowtrainYdataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ trainYdata-1��2��3 ��ÿһ�еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '                ReDim rowtrainYdataArray(1 To 3) As Variant
    '                rowtrainYdataArray(1) = Data_Dict("trainYdata_1")(i)
    '                rowtrainYdataArray(2) = Data_Dict("trainYdata_2")(i)
    '                rowtrainYdataArray(3) = Data_Dict("trainYdata_3")(i)
    '                columnsDataArray(i) = rowtrainYdataArray
    '            Next i
    '        End If
    '        '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    '        If Data_Dict.Exists("trainYdata") Then
    '            Data_Dict.Item("trainYdata") = columnsDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
    '        Else
    '            Data_Dict.Add "trainYdata", columnsDataArray: Rem �ֵ�����ָ�����Iֵ��
    '        End If

    '        ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_1"
    '        'If Data_Dict.Exists("trainYdata_1") Then
    '        '    Data_Dict.Remove ("trainYdata_1")
    '        'End If
    '        ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_2"
    '        'If Data_Dict.Exists("trainYdata_2") Then
    '        '    Data_Dict.Remove ("trainYdata_2")
    '        'End If
    '        ''�h���ֵ� Data_Dict �еėlĿ "trainYdata_3"
    '        'If Data_Dict.Exists("trainYdata_3") Then
    '        '    Data_Dict.Remove ("trainYdata_3")
    '        'End If

    '        '�����Д����M testYdata-1��2��3 �Ƿ񠑿�
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
    '            ReDim columnsDataArray(LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))) As Variant: Rem Variant��Integer��Long��Single��Double�����ò����Lһ�S���M׃�����L�ȣ���춴�Ŵ�Ӌ���ԭʼ������ testYdata-1��2��3 �������еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '            For i = LBound(Data_Dict("testYdata_1")) To UBound(Data_Dict("testYdata_1"))
    '                Dim rowtestYdataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������Lһ�S���M׃������춴�Ŵ�Ӌ���ԭʼ������ testYdata-1��2��3 ��ÿһ�еĔ���ֵ��ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    '                ReDim rowtestYdataArray(1 To 3) As Variant
    '                rowtestYdataArray(1) = Data_Dict("testYdata_1")(i)
    '                rowtestYdataArray(2) = Data_Dict("testYdata_2")(i)
    '                rowtestYdataArray(3) = Data_Dict("testYdata_3")(i)
    '                columnsDataArray(i) = rowtestYdataArray
    '            Next i
    '        End If
    '        '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    '        If Data_Dict.Exists("testYdata") Then
    '            Data_Dict.Item("testYdata") = columnsDataArray: Rem ˢ���ֵ�ָ�����Iֵ��
    '        Else
    '            Data_Dict.Add "testYdata", columnsDataArray: Rem �ֵ�����ָ�����Iֵ��
    '        End If

    '        ''�h���ֵ� Data_Dict �еėlĿ "testYdata_1"
    '        'If Data_Dict.Exists("testYdata_1") Then
    '        '    Data_Dict.Remove ("testYdata_1")
    '        'End If
    '        ''�h���ֵ� Data_Dict �еėlĿ "testYdata_2"
    '        'If Data_Dict.Exists("testYdata_2") Then
    '        '    Data_Dict.Remove ("testYdata_2")
    '        'End If
    '        ''�h���ֵ� Data_Dict �еėlĿ "testYdata_3"
    '        'If Data_Dict.Exists("testYdata_3") Then
    '        '    Data_Dict.Remove ("testYdata_3")
    '        'End If


    '        ''������Ӌ��Y���Ķ��S���M׃�� resultDataArray �ք��D�Q�������� JSON ��ʽ���ַ���;
    '        'Dim columnName() As String: Rem ���S���M�������ֶΣ����У����Q�ַ���һ�S���M;
    '        'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem ���S���M�������ֶΣ����У����Q�ַ���һ�S���M;
    '        'columnName(1) = "Column_1"
    '        'columnName(2) = "Column_2"
    '        ''For i = 1 To UBound(columnName, 1)
    '        ''    Debug.Print columnName(i)
    '        ''Next i

    '        'Dim PostCode As String: Rem ��ʹ�� POST Ո��r���������SՈ��һ��l�͵��������˵� POST ֵ�ַ���
    '        'PostCode = ""
    '        'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""һ��"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""����"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""����"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""����"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""����"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""����""}"
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

    '        ''ʹ�� For ѭ�hǶ�ױ�v�ķ�������һ�S���M��ֵƴ�Ӟ� JSON �ַ��������� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
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
    '        '    'Debug.Print PostCode: Rem ���������ڴ�ӡƴ�����Ո�� Post ֵ��

    '        '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem Ո���^������POST �������L�ȡ�

    '        '    WHR.Send (PostCode): Rem ��������l�� Http Ո��(��Ո�����d�W퓔���)������ WHR.Open �rʹ�� "get" ��������ֱ���{�á�WHR.Send���l�ͣ��������������̖�еą��� (PostCode)��
    '        '    'WHR.WaitForResponse: Rem �ȴ���������XMLHTTP��Ҳ����ʹ��

    '        '    '�xȡ���������ص�푑�ֵ
    '        '    WHR.Response.write.Status: Rem ��ʾ�������˽ӵ�Ո���ᣬ���ص� HTTP 푑���B�a
    '        '    WHR.Response.write.responseText: Rem �O���������˷��ص�푑�ֵ�����ı���ʽ����
    '        '    'WHR.Response.BinaryWrite.ResponseBody: Rem �O���������˷��ص�푑�ֵ���Զ��M�Ɣ�������ʽ����

    '        '    ''Dim HTMLCode As Object: Rem ��һ�� htmlfile ����׃������춱��淵�ص�푑�ֵ��ͨ���� HTML �W�Դ���a
    '        '    ''Set HTMLCode = CreateObject("htmlfile"): Rem ����һ�� htmlfile ���󣬌���׃���xֵ��Ҫʹ�� set �P�I�ֲ��Ҳ���ʡ�ԣ���ͨ׃���xֵʹ�� let �P�I�ֿ���ʡ��
    '        '    '''HTMLCode.designMode = "on": Rem �_����݋ģʽ
    '        '    'HTMLCode.write .responseText: Rem ���딵���������������ص�푑�ֵ���x�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode��������푑��^�ęn
    '        '    'HTMLCode.body.innerhtml = WHR.responseText: Rem �����������ص�푑�ֵ HTML �W�Դ�a�еľW��w��body���ęn���ֵĴ��a���xֵ�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode�������� ��responsetext�� ����������ӵ��͑��˰l�͵� Http Ո��֮�ᣬ���ص�푑�ֵ��ͨ���� HTML Դ���a�������N��ʽ����ʹ�Å��� ResponseText ��ʾ�����������ص�푑�ֵ�������ַ����ı���������ʹ�Å��� ResponseXML ��ʾ�����������ص�푑�ֵ�� DOM ������푑�ֵ������ DOM �������m�t����ʹ�� JavaScript �Z�Բ��� DOM �������댢푑�ֵ������ DOM �����Ҫ����������ص�푑�ֵ��횠� XML ����ַ�������ʹ�Å��� ResponseBody ��ʾ�����������ص�푑�ֵ��������M����͵Ĕ��������M�Ɣ�������ʹ�� Adodb.Stream �M�в�����
    '        '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    '        '    'HTMLHead = WHR.GetAllResponseHeaders: Rem �xȡ���������ص�푑�ֵ HTML �W�Դ���a�е��^��head���ęn�������Ҫ��ȡ�W��^�ęn�е� Cookie ����ֵ����ʹ�á�.GetResponseHeader("set-cookie")��������

    '        '    Response_Text = WHR.responseText
    '        '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    '        '    'Debug.Print Response_Text

    '        'Next i


    '        ''ʹ�� For ѭ�hǶ�ױ�v�ķ����������S���M��ֵƴ�Ӟ� JSON �ַ��������� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
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
    '        'Debug.Print PostCode: Rem ���������ڴ�ӡƴ�����Ո�� Post ֵ��


    '        'ʹ�õ�����ģ�M��Module����clsJsConverter����ԭʼ�����ֵ� Data_Dict �D�Q�����㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ�����ע����h�ֵȷǣ�ASCII, American Standard Code for Information Interchange��������Ϣ���Q�˜ʴ��a���ַ������D�Q�� unicode ���a;
    '        'ʹ�õ�����ģ�M��Module����clsJsConverter �� Github �ٷ��}��Wַ��https://github.com/VBA-tools/VBA-JSON
    '        'Dim JsonConverter As New clsJsConverter: Rem ��һ�� JSON ��������clsJsConverter������׃������� JSON �ַ����� VBA �ֵ䣨Dict��֮�g�����D�Q��JSON ��������clsJsConverter������׃���ǵ������ģ�K clsJsConverter ���Զ��x���b��ʹ��ǰ��Ҫ�_���ѽ�����ԓ�ģ�K��
    '        'requestJSONText = JsonConverter.ConvertToJson(Data_Dict, Whitespace:=2): Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
    '        requestJSONText = JsonConverter.ConvertToJson(Data_Dict): Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
    '        'Debug.Print requestJSONText

    '        'ReDim columnsDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    '        Erase columnsDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    '        Data_Dict.RemoveAll: Rem ����ֵ䣬ጷ��ڴ�
    '        Set Data_Dict = Nothing: Rem ��Ռ���׃����Data_Dict����ጷ��ڴ�

    '    Case Else

    '        MsgBox "ݔ����Զ��x�yӋ�㷨���Q�e�`���o���R�e��������Q��Statistics Algorithm name = " & CStr(Statistics_Algorithm_Name) & "����Ŀǰֻ�u����� (""test"", ""Interpolation"", ""Logistic"", ""Cox"", ""LC5PFit"", ...) ���Զ��x�ĽyӋ�㷨."
    '        Exit Sub

    'End Select


    '�Д��Ƿ��������^�̲��^�m��������Ą���
    'If PublicVariableStartORStopButtonClickState Then
    '    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    '    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
    '        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�\���^�̱���ֹ.": Rem ��ʾ�\���^�̈��Р�B���xֵ�o�˺��ؼ� calculate_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���calculate_status_Label���ġ�text������ֵ calculate_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    '    End If
    '    ''���İ��o��B�͘�־
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
    '    ''ˢ�²�����崰�w�ؼ��е�׃��ֵ
    '    ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopButtonClickState ֵ��
    '    ''�������崰�w�ؼ� StatisticsAlgorithmControlPanel �а����ģ��O�y���w�І����\�㰴ť�ؼ����c����B�������ͣ�׃�������xֵ
    '    'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    '    'End If
    '    ''ȡ����������д��w�ؼ��еİ��o���à�B
    '    'StatisticsAlgorithmControlPanel.Start_calculate_CommandButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еİ��o�ؼ� Start_calculate_CommandButton�������\�㰴�o����False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Database_Server_Url_TextBox����춱���Ӌ��Y���Ĕ�����������Wַ URL �ַ���ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĶ��x��ؼ� Data_Receptors_CheckBox1������Д���R�x��Ӌ��Y��������� Database �Ķ��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĶ��x��ؼ� Data_Receptors_CheckBox2������Д���R�x��Ӌ��Y��������� Excel �Ķ��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Statistics_Algorithm_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Statistics_Algorithm_Server_Url_TextBox���ṩ�yӋ�㷨�ķ������Wַ URL �ַ���ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Username_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Username_TextBox�������C�ṩ�yӋ�㷨�ķ��������~����ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Password_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еİ��o�ؼ� Password_TextBox�������C�ṩ�yӋ�㷨�ķ��������~���ܴaݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Field_name_of_Data_Input_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Field_name_of_Data_Input_TextBox������ԭʼ�����ֶ����� Excel ��񱣴�^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Data_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Data_TextBox������ԭʼ������ Excel ��񱣴�^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Output_position_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Output_position_TextBox������Ӌ��Y���� Excel ���^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.FisherDiscriminant_OptionButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĆ��x��ؼ� FisherDiscriminant_OptionButton����춘��R�x��ĳһ�����w�㷨 FisherDiscriminant �Ć��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
    '    'StatisticsAlgorithmControlPanel.Interpolate_OptionButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĆ��x��ؼ� Interpolate_OptionButton����춘��R�x��ĳһ�����w�㷨 Interpolate �Ć��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
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


    'ˢ���Զ��x���ӕr�ȴ��r�L
    'Public_Delay_length_input = CLng(1500): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
        'Public_delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
        Public_Delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�

        'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_input ֵ��
        'ˢ�¿�����崰�w�а�����׃�����ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
        If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
        End If
    End If
    'Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
    If Not (StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
        'Public_delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
        Public_Delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�

        'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_random_input ֵ��
        'ˢ�¿�����崰�w�а�����׃�����ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
        If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
        End If
    End If
    Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
    Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
    'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length ֵ��
    'ˢ�¿�����崰�w�а�����׃�������^�S�C��֮����K�õ����ӕr�L��
    If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Public_Delay_length = Public_Delay_length
    End If

    ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
    'If Not (StatisticsAlgorithmControlPanel.Controls("delay") Is Nothing) Then
    '    Call StatisticsAlgorithmControlPanel.delay(StatisticsAlgorithmControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
    'End If

    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "��yӋ�������l�͔��� upload data ��": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    End If

    '����һ�� http �͑��� AJAX 朽������� VBA �� XMLHttpRequest ����;
    Dim WHR As Object: Rem ����һ�� XMLHttpRequest ����
    Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem �����K���� WinHttp.WinHttpRequest.5.1 ����Msxml2.XMLHTTP ����� Microsoft.XMLHTTP ���󲻿����ڰl�� header �а��� Cookie �� referer��MSXML2.ServerXMLHTTP ��������� header �аl�� Cookie �����ܰl referer��
    WHR.abort: Rem �� XMLHttpRequest �����λ��δ��ʼ����B;
    Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
    resolveTimeout = 10000: Rem ���� DNS ���ֵĳ��r�r�L��10000 ���롣
    connectTimeout = Public_Delay_length: Rem 10000: Rem: ���� Winsock 朽ӵĳ��r�r�L��10000 ���롣
    sendTimeout = Public_Delay_length: Rem 120000: Rem �l�͔����ĳ��r�r�L��120000 ���롣
    receiveTimeout = Public_Delay_length: Rem 60000: Rem ���� response �ĳ��r�r�L��60000 ���롣
    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem �O�ò������r�r�L;

    WHR.Option(6) = False: Rem ��ȡ True ֵ�r����ʾ��Ո������ض������D�r�Ԅ����D����ȡ False ֵ�r����ʾ���Ԅ����D����ȡ���ն˷��صĵ� 302 ��B��
    'WHR.Option(4) = 13056: Rem �����e�`��־

    '"http://localhost:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit"
    WHR.Open "post", Statistics_Algorithm_Server_Url, False: Rem �����c�������������朽ӣ����� post ��ʽՈ�󣬅��� False ��ʾ�����M�̣��ȴ��յ����������ص�푑������ĕr�����^�m�������m�Ĵ��a�Z�䣬��߀�]�յ����������ص�푑������r���͕������@�Y����������ֱ���յ�������푑�������ֹ�����ȡ True ֵ�ͱ�ʾ���ȴ�����������ֱ���^�m��������Ĵ��a���������^�Į����@ȡ������
    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem Ո���^���������a��ʽ
    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem Ո���^�������Ñ��˽��ܵĔ������
    WHR.SetRequestHeader "Referer", "http://localhost:10001/": Rem Ո���^�����������l��Ո���Դ
    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" 'Ո���^�������Ñ�ϵ�y�Z��
    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem Ո���^�������Ñ��˞g�[�������汾��Ϣ
    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem Ո���^����������朽ӡ���ȡ "Close" ֵ�r����ʾ�����B�ӡ�

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
        WHR.SetRequestHeader "authorization", requst_Authorization: Rem �O��Ո���^������Ո����C�~̖�ܴa��
    End If
    'Debug.Print requst_Authorization: Rem ���������ڴ�ӡƴ�����Ո����C�~̖�ܴaֵ��

    Dim CookiePparameter As String: Rem Ո�� Cookie ֵ�ַ���
    CookiePparameter = "Session_ID=request_Key->username:password"
    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
    'Debug.Print CookiePparameter: Rem ���������ڴ�ӡƴ�����Ո�� Cookie ֵ��
    If CookiePparameter <> "" Then
        If Not (StatisticsAlgorithmControlPanel.Controls("Base64Encode") Is Nothing) Then
            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
        End If
        'If Not (StatisticsAlgorithmControlPanel.Controls("Base64Decode") Is Nothing) Then
        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
        'End If
        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem �O��Ո���^������Ո�� Cookie��
    End If
    'Debug.Print CookiePparameter: Rem ���������ڴ�ӡƴ�����Ո�� Cookie ֵ��

    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem Ո���^��������ʾ֪ͨ�������˷��� gzip, deflate ���s�^�ľ��a

    WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem Ո���^������POST �������L�ȡ�

    WHR.Send (requestJSONText): Rem ��������l�� Http Ո��(��Ո�����d�W퓔���)������ WHR.Open �rʹ�� "get" ��������ֱ���{�á�WHR.Send���l�ͣ��������������̖�еą��� (PostCode)��
    'WHR.WaitForResponse: Rem �ȴ���������XMLHTTP��Ҳ����ʹ��

    'requestJSONText = "": Rem �ÿգ�ጷ��ڴ�

    '�xȡ���������ص�푑�ֵ
    WHR.Response.Write.Status: Rem ��ʾ�������˽ӵ�Ո���ᣬ���ص� HTTP 푑���B�a
    WHR.Response.Write.responseText: Rem �O���������˷��ص�푑�ֵ�����ı���ʽ����
    'WHR.Response.BinaryWrite.ResponseBody: Rem �O���������˷��ص�푑�ֵ���Զ��M�Ɣ�������ʽ����

    ''Dim HTMLCode As Object: Rem ��һ�� htmlfile ����׃������춱��淵�ص�푑�ֵ��ͨ���� HTML �W�Դ���a
    ''Set HTMLCode = CreateObject("htmlfile"): Rem ����һ�� htmlfile ���󣬌���׃���xֵ��Ҫʹ�� set �P�I�ֲ��Ҳ���ʡ�ԣ���ͨ׃���xֵʹ�� let �P�I�ֿ���ʡ��
    '''HTMLCode.designMode = "on": Rem �_����݋ģʽ
    'HTMLCode.write .responseText: Rem ���딵���������������ص�푑�ֵ���x�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode��������푑��^�ęn
    'HTMLCode.body.innerhtml = WHR.responseText: Rem �����������ص�푑�ֵ HTML �W�Դ�a�еľW��w��body���ęn���ֵĴ��a���xֵ�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode�������� ��responsetext�� ����������ӵ��͑��˰l�͵� Http Ո��֮�ᣬ���ص�푑�ֵ��ͨ���� HTML Դ���a�������N��ʽ����ʹ�Å��� ResponseText ��ʾ�����������ص�푑�ֵ�������ַ����ı���������ʹ�Å��� ResponseXML ��ʾ�����������ص�푑�ֵ�� DOM ������푑�ֵ������ DOM �������m�t����ʹ�� JavaScript �Z�Բ��� DOM �������댢푑�ֵ������ DOM �����Ҫ����������ص�푑�ֵ��횠� XML ����ַ�������ʹ�Å��� ResponseBody ��ʾ�����������ص�푑�ֵ��������M����͵Ĕ��������M�Ɣ�������ʹ�� Adodb.Stream �M�в�����
    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    'HTMLHead = WHR.GetAllResponseHeaders: Rem �xȡ���������ص�푑�ֵ HTML �W�Դ���a�е��^��head���ęn�������Ҫ��ȡ�W��^�ęn�е� Cookie ����ֵ����ʹ�á�.GetResponseHeader("set-cookie")��������

    Dim Response_Text As String: Rem �нӷ��������ص�푑�ֵ�ַ���;
    Response_Text = WHR.responseText
    'Debug.Print Response_Text

    Dim responseJSONText As String: Rem �㷨������푑����ص�Ӌ��Y���� JSON ��ʽ���ַ���;
    responseJSONText = Response_Text
    'responseJSONText = StrConv(Response_Text, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
    'Debug.Print responseJSONText

    'WHR.abort: Rem �� XMLHttpRequest �����λ��δ��ʼ����B;

    Response_Text = "": Rem �ÿգ�ጷ��ڴ�
    'Set HTMLCode = Nothing
    'Set WHR = Nothing: Rem ��Ռ���׃����WHR����ጷ��ڴ�

    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�ĽyӋ����������푑�ֵӋ��Y�� download result.": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    End If

    Dim responseJSONDict As Object: Rem �㷨������푑����ص�Ӌ��Y���� JSON ��ʽ���ַ����D�Q��� VBA �ֵ䌦��;

    'ʹ�õ�����ģ�M��Module����clsJsConverter�����㷨������푑����ص�Ӌ��Y���� JSON ��ʽ���ַ����D�Q�� VBA �ֵ䌦��ע����h�ֵȷǣ�ASCII, American Standard Code for Information Interchange��������Ϣ���Q�˜ʴ��a���ַ���ʹ�Ì����� unicode ���a��ʾ��;
    'ʹ�õ�����ģ�M��Module����clsJsConverter �� Github �ٷ��}��Wַ��https://github.com/VBA-tools/VBA-JSON
    'Dim JsonConverter As New clsJsConverter: Rem ��һ�� JSON ��������clsJsConverter������׃������� JSON �ַ����� VBA �ֵ䣨Dict��֮�g�����D�Q��JSON ��������clsJsConverter������׃���ǵ������ģ�K clsJsConverter ���Զ��x���b��ʹ��ǰ��Ҫ�_���ѽ�����ԓ�ģ�K��
    Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem �㷨������푑����ص�Ӌ��Y���� JSON ��ʽ���ַ����D�Q�� VBA �ֵ䌦��;
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

    'responseJSONText = "": Rem �ÿգ�ጷ��ڴ�
    'Set JsonConverter = Nothing: Rem ��Ռ���׃����JsonConverter����ጷ��ڴ�


    Dim resultDataArray() As Variant: Rem Variant��Integer��Long��Single��Double����һ�������L���S���M׃������춴���㷨���������ص�Ӌ��Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    'ReDim resultDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant��Integer��Long��Single��Double�����ö��S���M׃�������оS�ȣ���춴���㷨���������ص�Ӌ��Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ

    ''���Y���ֵ� responseJSONDict �е����Д����D�������S���M resultDataArray ��;
    ''��ȡ�Y���ֵ� responseJSONDict ���Д���Ԫ���е�����Д�:
    'Dim max_Rows As Integer
    'max_Rows = 0
    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
    '    If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
    '        max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
    '    End If
    'Next i
    'max_Rows = CInt(max_Rows + 1): Rem ����һ�����}��
    ''ʹ�� for ѭ�h�����Y���ֵ� responseJSONDict �е�ȫ�������������D�������S���M resultDataArray �У�
    'ReDim resultDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Variant: Rem Variant��Integer��Long��Single��Double�����ö��S���M׃�������оS�ȣ���춴���㷨���������ص�Ӌ��Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
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


    ''���Y���ֵ� responseJSONDict �е�ָ���Ĕ����D�������S���M resultDataArray ��;
    '��ȡ�Y���ֵ� responseJSONDict ָ���Ĕ���Ԫ���е�����Д�:
    Dim max_Rows As Integer
    max_Rows = 0
    '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
    'Debug.Print responseJSONDict.Exists("Coefficient")
    If responseJSONDict.Exists("Coefficient") Then
        'Debug.Print responseJSONDict.Item("Coefficient")(1)
        'Debug.Print responseJSONDict.Item("Coefficient").Count
        If CInt(responseJSONDict.Item("Coefficient").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient").Count)
            'Debug.Print max_Rows
        End If
    End If
    If responseJSONDict.Exists("Residual") Then
        If CInt(responseJSONDict.Item("Residual").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Residual").Count)
        End If
    End If
    If responseJSONDict.Exists("Yfit") Then
        If CInt(responseJSONDict.Item("Yfit").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Yfit").Count)
        End If
    End If
    If responseJSONDict.Exists("Coefficient-StandardDeviation") Then
        If CInt(responseJSONDict.Item("Coefficient-StandardDeviation").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient-StandardDeviation").Count)
        End If
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Lower-95%") Then
        If CInt(responseJSONDict.Item("Coefficient-Confidence-Lower-95%").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient-Confidence-Lower-95%").Count)
        End If
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Upper-95%") Then
        If CInt(responseJSONDict.Item("Coefficient-Confidence-Upper-95%").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Coefficient-Confidence-Upper-95%").Count)
        End If
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Lower") Then
        If CInt(responseJSONDict.Item("Yfit-Uncertainty-Lower").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Yfit-Uncertainty-Lower").Count)
        End If
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Upper") Then
        If CInt(responseJSONDict.Item("Yfit-Uncertainty-Upper").Count) > max_Rows Then
            max_Rows = CInt(responseJSONDict.Item("Yfit-Uncertainty-Upper").Count)
        End If
    End If
    If responseJSONDict.Exists("testData") Then
        If responseJSONDict.Item("testData").Exists("test-Xvals") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Xvals").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Xvals").Count)
            End If
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Lower") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Lower").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Lower").Count)
            End If
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Upper") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Upper").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Upper").Count)
            End If
        End If
        If responseJSONDict.Item("testData").Exists("test-Yfit") Then
            If CInt(responseJSONDict.Item("testData").Item("test-Yfit").Count) > max_Rows Then
                max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Yfit").Count)
            End If
        End If
        'If responseJSONDict.Item("testData").Exists("test-Ydata-StandardDeviation") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Ydata-StandardDeviation").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Ydata-StandardDeviation").Count)
        '    End If
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Lower") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Lower").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Lower").Count)
        '    End If
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Upper") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Upper").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Upper").Count)
        '    End If
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Residual") Then
        '    If CInt(responseJSONDict.Item("testData").Item("test-Residual").Count) > max_Rows Then
        '        max_Rows = CInt(responseJSONDict.Item("testData").Item("test-Residual").Count)
        '    End If
        'End If
    End If
    max_Rows = CInt(max_Rows + 1): Rem ����һ�����}��
    'Debug.Print max_Rows
    '���Y���ֵ� responseJSONDict ��ָ���Ĕ����D�������S���M resultDataArray �У�
    ReDim resultDataArray(1 To max_Rows, 1 To 13) As Variant: Rem Variant��Integer��Long��Single��Double�����ö��S���M׃�������оS�ȣ���춴���㷨���������ص�Ӌ��Y����ע�� VBA �Ķ��S���M�����ǣ���̖����̖����ʽ
    Dim Value As Variant
    If responseJSONDict.Exists("Coefficient") Then
        resultDataArray(1, 1) = "Coefficient"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient")
            j = j + 1
            'Debug.Print "Coefficient:(" & j & ") = " & Value
            resultDataArray(j + 1, 1) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Coefficient-StandardDeviation") Then
        resultDataArray(1, 2) = "Coefficient-StandardDeviation"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient-StandardDeviation")
            j = j + 1
            'Debug.Print "Coefficient-StandardDeviation:(" & j & ") = " & Value
            resultDataArray(j + 1, 2) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Lower-95%") Then
        resultDataArray(1, 3) = "Coefficient-Confidence-Lower-95%"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient-Confidence-Lower-95%")
            j = j + 1
            'Debug.Print "Coefficient-Confidence-Lower-95%:(" & j & ") = " & Value
            resultDataArray(j + 1, 3) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Coefficient-Confidence-Upper-95%") Then
        resultDataArray(1, 4) = "Coefficient-Confidence-Upper-95%"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Coefficient-Confidence-Upper-95%")
            j = j + 1
            'Debug.Print "Coefficient-Confidence-Upper-95%:(" & j & ") = " & Value
            resultDataArray(j + 1, 4) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Yfit") Then
        resultDataArray(1, 5) = "Yfit"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Yfit")
            j = j + 1
            'Debug.Print "Yfit:(" & j & ") = " & Value
            resultDataArray(j + 1, 5) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Lower") Then
        resultDataArray(1, 6) = "Yfit-Uncertainty-Lower"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Yfit-Uncertainty-Lower")
            j = j + 1
            'Debug.Print "Yfit-Uncertainty-Lower:(" & j & ") = " & Value
            resultDataArray(j + 1, 6) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Yfit-Uncertainty-Upper") Then
        resultDataArray(1, 7) = "Yfit-Uncertainty-Upper"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Yfit-Uncertainty-Upper")
            j = j + 1
            'Debug.Print "Yfit-Uncertainty-Upper:(" & j & ") = " & Value
            resultDataArray(j + 1, 7) = Value
        Next Value
    End If
    If responseJSONDict.Exists("Residual") Then
        resultDataArray(1, 8) = "Residual"
        'Dim Value As Variant
        j = 0
        For Each Value In responseJSONDict.Item("Residual")
            j = j + 1
            'Debug.Print "Residual:(" & j & ") = " & Value
            resultDataArray(j + 1, 8) = Value
        Next Value
    End If
    'If responseJSONDict.Exists("Residual") Then
    '    resultDataArray(1, 8) = "Residual_1"
    '    resultDataArray(1, 9) = "Residual_2"
    '    resultDataArray(1, 10) = "Residual_3"
    '    'Dim Value As Variant
    '    j = 0
    '    For Each Value In responseJSONDict.Item("Residual")
    '        j = j + 1
    '        'Debug.Print "Residual:(" & j & ") = " & Value(1) & ", " & Value(2) & ", " & Value(3)
    '        resultDataArray(j + 1, 8) = Value(1)
    '        resultDataArray(j + 1, 9) = Value(2)
    '        resultDataArray(j + 1, 10) = Value(3)
    '    Next Value
    'End If
    If responseJSONDict.Exists("testData") Then
        If responseJSONDict.Item("testData").Exists("test-Xvals") Then
            resultDataArray(1, 9) = "test-Xvals"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Xvals")
                j = j + 1
                'Debug.Print "test-Xvals:(" & j & ") = " & Value
                resultDataArray(j + 1, 9) = Value
            Next Value
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Lower") Then
            resultDataArray(1, 10) = "test-Xfit-Uncertainty-Lower"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Lower")
                j = j + 1
                'Debug.Print "test-Xfit-Uncertainty-Lower:(" & j & ") = " & Value
                resultDataArray(j + 1, 10) = Value
            Next Value
        End If
        If responseJSONDict.Item("testData").Exists("test-Xfit-Uncertainty-Upper") Then
            resultDataArray(1, 11) = "test-Xfit-Uncertainty-Upper"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Xfit-Uncertainty-Upper")
                j = j + 1
                'Debug.Print "test-Xfit-Uncertainty-Upper:(" & j & ") = " & Value
                resultDataArray(j + 1, 11) = Value
            Next Value
        End If
        If responseJSONDict.Item("testData").Exists("test-Yfit") Then
            resultDataArray(1, 12) = "test-Yfit"
            'Dim Value As Variant
            j = 0
            For Each Value In responseJSONDict.Item("testData").Item("test-Yfit")
                j = j + 1
                'Debug.Print "test-Yfit:(" & j & ") = " & Value
                resultDataArray(j + 1, 12) = Value
            Next Value
        End If
        'If responseJSONDict.Item("testData").Exists("test-Ydata-StandardDeviation") Then
        '    resultDataArray(1, 13) = "test-Ydata-StandardDeviation"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Ydata-StandardDeviation")
        '        j = j + 1
        '        'Debug.Print "test-Ydata-StandardDeviation:(" & j & ") = " & Value
        '        resultDataArray(j + 1, 13) = Value
        '    Next Value
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Lower") Then
        '    resultDataArray(1, 14) = "test-Yfit-Uncertainty-Lower"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Lower")
        '        j = j + 1
        '        'Debug.Print "test-Yfit-Uncertainty-Lower:(" & j & ") = " & Value
        '        resultDataArray(j + 1, 14) = Value
        '    Next Value
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Yfit-Uncertainty-Upper") Then
        '    resultDataArray(1, 15) = "test-Yfit-Uncertainty-Upper"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Yfit-Uncertainty-Upper")
        '        j = j + 1
        '        'Debug.Print "test-Yfit-Uncertainty-Upper:(" & j & ") = " & Value
        '        resultDataArray(j + 1, 15) = Value
        '    Next Value
        'End If
        'If responseJSONDict.Item("testData").Exists("test-Residual") Then
        '    resultDataArray(1, 16) = "test-Residual_1"
        '    resultDataArray(1, 17) = "test-Residual_2"
        '    resultDataArray(1, 18) = "test-Residual_3"
        '    'Dim Value As Variant
        '    j = 0
        '    For Each Value In responseJSONDict.Item("testData").Item("test-Residual")
        '        j = j + 1
        '        'Debug.Print "test-Residual:(" & j & ") = " & Value(1) & ", " & Value(2) & ", " & Value(3)
        '        resultDataArray(j + 1, 16) = Value(1)
        '        resultDataArray(j + 1, 17) = Value(2)
        '        resultDataArray(j + 1, 18) = Value(3)
        '    Next Value
        'End If
    End If
    'For i = LBound(resultDataArray, 1) To UBound(resultDataArray, 1)
    '    For j = LBound(resultDataArray, 2) To UBound(resultDataArray, 2)
    '        Debug.Print "resultDataArray:(" & i & ", " & j & ") = " & resultDataArray(i, j)
    '    Next j
    'Next i


    '�Д�Y�������ı���ģʽ����������� Excel ���
    'Debug.Print Data_Receptors
    If (Data_Receptors = "Excel") Or (Data_Receptors = "Excel_and_Database") Then

        'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
        If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
            StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�� Excel ����Ќ���Ӌ��Y�� write result.": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
        End If

        'Dim RNG As Range: Rem ���xһ�� Range ����׃����Rng����Range ������ָ Excel �������Ԫ����߆�Ԫ��^��

        '�����Ӌ��Y���Ķ��S���M resultDataArray �еĔ������� Excel ���ָ����λ�õĆ�Ԫ���У�
        If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

            Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
            'Debug.Print RNG.Row & " �� " & RNG.Column

            'RNG = resultDataArray
            ''ʹ�� Range(2, 1).Resize(4, 3) = array ���� Cells(2, 1).Resize(4, 3) = array �ķ����������S���Mһ���Ԍ��� Excel ��������ָ���^��Ć�Ԫ���У����� .Resize(4, 3) ��ʾ Excel �������x�Ѕ^��Ĵ�С�� 4 �� �� 3 �У����� Range(2, 1). �� Cells(2, 1). ��ʾ Excel �������x�Ѕ^���һ����λ���x�Ѕ^������Ͻǵĵ�һ����Ԫ�������ֵ���ڱ����о��� Excel �������еĵ� 2 ���c�� 1 �У�A �У����c�Ć�Ԫ��
            ''RNG.Resize(CInt(UBound(resultDataArray, 1) - LBound(resultDataArray, 1) + CInt(1)), CInt(UBound(resultDataArray, 2) - LBound(resultDataArray, 2) + CInt(1))) = resultDataArray: Rem ���ɼ����ĽY�����S���M�x�oָ���^��� Excel �������Ć�Ԫ���ڔ������ܴ����r���@�N���w�xֵ������Ч�ʕ��@�����ʹ�� For ѭ�h�xֵ��Ч�ʡ�

            'ʹ�� For ѭ�hǶ�ױ�v�ķ����������S���M��ֵ���� Excel ������Ć�Ԫ���У����� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
            For i = 0 To UBound(resultDataArray, 1) - LBound(resultDataArray, 1)
                For j = 0 To UBound(resultDataArray, 2) - LBound(resultDataArray, 2)
                    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
                    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
                Next j
            Next i

            'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ

        ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

            Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
            'Debug.Print RNG.Row & " �� " & RNG.Column

            'RNG = resultDataArray
            ''ʹ�� Range(2, 1).Resize(4, 3) = array ���� Cells(2, 1).Resize(4, 3) = array �ķ����������S���Mһ���Ԍ��� Excel ��������ָ���^��Ć�Ԫ���У����� .Resize(4, 3) ��ʾ Excel �������x�Ѕ^��Ĵ�С�� 4 �� �� 3 �У����� Range(2, 1). �� Cells(2, 1). ��ʾ Excel �������x�Ѕ^���һ����λ���x�Ѕ^������Ͻǵĵ�һ����Ԫ�������ֵ���ڱ����о��� Excel �������еĵ� 2 ���c�� 1 �У�A �У����c�Ć�Ԫ��
            ''RNG.Resize(CInt(UBound(resultDataArray, 1) - LBound(resultDataArray, 1) + CInt(1)), CInt(UBound(resultDataArray, 2) - LBound(resultDataArray, 2) + CInt(1))) = resultDataArray: Rem ���ɼ����ĽY�����S���M�x�oָ���^��� Excel �������Ć�Ԫ���ڔ������ܴ����r���@�N���w�xֵ������Ч�ʕ��@�����ʹ�� For ѭ�h�xֵ��Ч�ʡ�

            'ʹ�� For ѭ�hǶ�ױ�v�ķ����������S���M��ֵ���� Excel ������Ć�Ԫ���У����� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
            For i = 0 To UBound(resultDataArray, 1) - LBound(resultDataArray, 1)
                For j = 0 To UBound(resultDataArray, 2) - LBound(resultDataArray, 2)
                    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
                    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
                Next j
            Next i

            'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ

        ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

            'MsgBox "�yӋ�\��ĽY��ݔ�����x�񹠇���Result output = " & CStr(Public_Result_output_position) & "�����ջ�Y���e�`��Ŀǰֻ�ܽ������ Sheet1!A1:C5 �Y�����ַ���."
            'Exit Sub

            Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem �� Excel �������е� A �е�����һ���ǿՆ�Ԫ���x��׃�� RNG������ (Rows.Count, 1) �е� 1 ��ʾ Excel ������ĵ� 1 �У�A �У�
            'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem �� Excel �������е� B �е�����һ���ǿՆ�Ԫ���x��׃�� RNG������ (Rows.Count, 2) �е� 2 ��ʾ Excel ������ĵ� 2 �У�B �У�
            Set RNG = RNG.Offset(2): Rem ��׃�� Rng ���Þ� Rng ��ͬ�����еĆ�Ԫ�񣨼�ͬ�еĵڶ����Ն�Ԫ��
            'Set RNG = RNG.Offset(1): Rem ��׃�� Rng ���Þ� Rng ��ͬ����һ�еĆ�Ԫ�񣨼�ͬ�еĵ�һ���Ն�Ԫ��
            'Debug.Print RNG.Row & " �� " & RNG.Column

            ''ʹ�� Range(2, 1).Resize(4, 3) = array ���� Cells(2, 1).Resize(4, 3) = array �ķ����������S���Mһ���Ԍ��� Excel ��������ָ���^��Ć�Ԫ���У����� .Resize(4, 3) ��ʾ Excel �������x�Ѕ^��Ĵ�С�� 4 �� �� 3 �У����� Range(2, 1). �� Cells(2, 1). ��ʾ Excel �������x�Ѕ^���һ����λ���x�Ѕ^������Ͻǵĵ�һ����Ԫ�������ֵ���ڱ����о��� Excel �������еĵ� 2 ���c�� 1 �У�A �У����c�Ć�Ԫ��
            'RNG.Resize(CInt(UBound(resultDataArray, 1) - LBound(resultDataArray, 1) + CInt(1)), CInt(UBound(resultDataArray, 2) - LBound(resultDataArray, 2) + CInt(1))) = resultDataArray: Rem ���ɼ����ĽY�����S���M�x�oָ���^��� Excel �������Ć�Ԫ���ڔ������ܴ����r���@�N���w�xֵ������Ч�ʕ��@�����ʹ�� For ѭ�h�xֵ��Ч�ʡ�

            'ʹ�� For ѭ�hǶ�ױ�v�ķ����������S���M��ֵ���� Excel ������Ć�Ԫ���У����� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
            For i = 0 To UBound(resultDataArray, 1) - LBound(resultDataArray, 1)
                For j = 0 To UBound(resultDataArray, 2) - LBound(resultDataArray, 2)
                    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
                    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = resultDataArray(LBound(resultDataArray, 1) + i, LBound(resultDataArray, 2) + j): Rem ���� Cell.Row �� Range.Row ��ʾ Excel ��������ָ����Ԫ�����̖�a������ Cell.Column �� Range.Column ��ʾ Excel ��������ָ����Ԫ�����̖�a��
                Next j
            Next i

            'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem �@�l�Z������{ԇ��Ч���ǌ��r�ڡ��������ڡ���ӡ�Y��ֵ
        
        Else
        End If

        '�� Excel �������ڝL�ӵ���ǰ��Ҋ��Ԫ���Д���һ��̎��
        ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem �@�l�Z��������ǣ��� Excel �������ڝL�ӵ���ǰ��Ҋ��Ԫ���Д���һ��̎��������ActiveWindow.ScrollRow = RNG.Row����ʾ����ǰ Excel �������ڝL�ӵ�ָ���� RNG ��Ԫ����̖��λ�ã�������Windows(1).VisibleRange.Cells.Rows.Count������˼��Ӌ�㮔ǰ Excel ���������п�Ҋ��Ԫ��Ŀ��Д�����̖��/���� VBA �б�ʾ��ͨ��������̖��mod���� VBA �б�ʾ����ȡ��������̖��\���� VBA �б�ʾ����ȡ��������̖��\���c��Int(N/N)��Ч����ͬ������ Int() ��ʾȡ����
        'RNG.EntireRow.Delete: Rem �h����һ�б��^
        'Columns("C:J").Clear: Rem ��� C �� J ��
        'Windows(1).VisibleRange.Cells.Count: Rem ������Windows(1).VisibleRange.Cells.Count������˼��Ӌ�㮔ǰ Excel ���������п�Ҋ��Ԫ��Ŀ���
        'Windows(1).VisibleRange.Cells.Rows.Count: Rem ������Windows(1).VisibleRange.Cells.Rows.Count������˼��Ӌ�㮔ǰ Excel ���������п�Ҋ��Ԫ��ĿG�Д�
        'Windows(1).VisibleRange.Cells.Columns.Count: Rem ������Windows(1).VisibleRange.Cells.Columns.Count������˼��Ӌ�㮔ǰ Excel ���������п�Ҋ��Ԫ��ĿG�Д�
        'ActiveWindow.RangeSelection.Address: Rem �����x�еĆ�Ԫ��ĵ�ַ����̖����̖��
        'ActiveCell.Address: Rem ���ػ�ӆ�Ԫ��ĵ�ַ����̖����̖��
        'ActiveCell.Row: Rem ���ػ�ӆ�Ԫ�����̖
        'ActiveCell.Column: Rem ���ػ�ӆ�Ԫ�����̖
        'ActiveWindow.ScrollRow = ActiveCell.Row: Rem ��ʾ����ӆ�Ԫ�����̖���xֵ�o Excel �������ڴ�ֱ�L�ӗl�L�ӵ���λ�ã�ע�⣬ԓ����ֻ�ܽ����L���� Long ׃���������H��Ч�����ǌ� Excel �������ڵ���߅��L�ӵ���ӆ�Ԫ�����̖̎��
        'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem �@�l�Z��������ǌ� Excel �������ڝL�ӵ���ǰ��Ҋ��Ԫ��G�Д���һ��̎�����磬���������ActiveWindow.ScrollRow = 2���t��ʾ�� Excel ���ڝL�ӵ��ڶ��е�λ��̎����̖��/���� VBA �б�ʾ��ͨ��������̖��mod���� VBA �б�ʾ����ȡ��������̖��\���� VBA �б�ʾ����ȡ��������̖��\���c��Int(N/N)��Ч����ͬ������ Int() ��ʾȡ����

        Set RNG = Nothing: Rem ��Ռ���׃����RNG����ጷ��ڴ�
        ''ReDim resultDataArray(0): Rem ��Ք��M��ጷ��ڴ�
        'Erase resultDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
        'responseJSONDict.RemoveAll: Rem ����ֵ䣬ጷ��ڴ�
        'Set responseJSONDict = Nothing: Rem ��Ռ���׃����responseJSONDict����ጷ��ڴ�

    End If


    '�Д�Y�������ı���ģʽ����������� Excel ���
    'Debug.Print Data_Receptors
    If (Data_Receptors = "Database") Or (Data_Receptors = "Excel_and_Database") Then

        If Database_Server_Url <> "" Then

            'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
            If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
                StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�����������������Ӌ��Y�� upload result ��": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
            End If

            'MsgBox "Is = Database, Is = Excel_and_Database"
            '��Ҫ�����ѽ����� MongoDB ��������ն��ӷ�����
            'C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
            'C:\Criss\DatabaseServer\MongoDB>C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:\Criss\DatabaseServer\MongoDB\Nodejs2MongodbServer.js host=0.0.0.0 port=8000 number_cluster_Workers=0 Key=username:password MongodbHost=0.0.0.0 MongodbPort=27017 dbUser=administrator dbPass=administrator dbName=testWebData

            'ˢ���Զ��x���ӕr�ȴ��r�L
            'Public_Delay_length_input = CLng(1500): Rem �ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
            If Not (StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
                'Public_delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�
                Public_Delay_length_input = CLng(StatisticsAlgorithmControlPanel.Controls("Delay_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y�����L���͡�

                'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_input ֵ��
                'ˢ�¿�����崰�w�а�����׃�����ˠ��ӕr�ȴ��r�L���Aֵ����λ���롣���� CLng() ��ʾǿ���D�Q���L����
                If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
                    StatisticsAlgorithmControlPanel.Public_Delay_length_input = Public_Delay_length_input
                End If
            End If
            'Public_Delay_length_random_input = CSng(0.2): Rem �ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
            If Not (StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
                'Public_delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Value): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�
                Public_Delay_length_random_input = CSng(StatisticsAlgorithmControlPanel.Controls("Delay_random_input_TextBox").Text): Rem ���ı�ݔ���ؼ�����ȡֵ���Y����ξ��ȸ��c�͡�

                'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length_random_input ֵ��
                'ˢ�¿�����崰�w�а�����׃�����ˠ��ӕr�ȴ��r�L�S�C���ӹ�������λ����Aֵ�İٷֱȡ����� CSng() ��ʾǿ���D�Q��ξ��ȸ��c��
                If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
                    StatisticsAlgorithmControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
                End If
            End If
            Randomize: Rem ���� Randomize ��ʾ����һ���S�C���N�ӣ�seed��
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)������ Rnd() ��ʾ���� [0,1) ���S�C����
            'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� Public_Delay_length ֵ��
            'ˢ�¿�����崰�w�а�����׃�������^�S�C��֮����K�õ����ӕr�L��
            If Not (StatisticsAlgorithmControlPanel.Controls("Public_Delay_length") Is Nothing) Then
                StatisticsAlgorithmControlPanel.Public_Delay_length = Public_Delay_length
            End If

            ''ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'If Not (StatisticsAlgorithmControlPanel.Controls("delay") Is Nothing) Then
            '    Call StatisticsAlgorithmControlPanel.delay(StatisticsAlgorithmControlPanel.Public_Delay_length): Rem ʹ���Զ��x���^���ӕr�ȴ� 3000 ���루3 ��犣����ȴ��W퓼��d�ꮅ���Զ��x�ӕr�ȴ����^�̂��녢����ȡֵ����󹠇����L���� Long ׃�����p�֣�4 �ֹ��������ֵ�������� 0 �� 2^32 ֮�g��
            'End If

            '����һ�� http �͑��� AJAX 朽������� VBA �� XMLHttpRequest ����;
            'Dim WHR As Object: Rem ����һ�� XMLHttpRequest ����
            'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem �����K���� WinHttp.WinHttpRequest.5.1 ����Msxml2.XMLHTTP ����� Microsoft.XMLHTTP ���󲻿����ڰl�� header �а��� Cookie �� referer��MSXML2.ServerXMLHTTP ��������� header �аl�� Cookie �����ܰl referer��
            WHR.abort: Rem �� XMLHttpRequest �����λ��δ��ʼ����B;
            'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
            resolveTimeout = 10000: Rem ���� DNS ���ֵĳ��r�r�L��10000 ���롣
            connectTimeout = Public_Delay_length: Rem 10000: Rem: ���� Winsock 朽ӵĳ��r�r�L��10000 ���롣
            sendTimeout = Public_Delay_length: Rem 120000: Rem �l�͔����ĳ��r�r�L��120000 ���롣
            receiveTimeout = Public_Delay_length: Rem 60000: Rem ���� response �ĳ��r�r�L��60000 ���롣
            WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem �O�ò������r�r�L;

            WHR.Option(6) = False: Rem ��ȡ True ֵ�r����ʾ��Ո������ض������D�r�Ԅ����D����ȡ False ֵ�r����ʾ���Ԅ����D����ȡ���ն˷��صĵ� 302 ��B��
            'WHR.Option(4) = 13056: Rem �����e�`��־

            '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
            WHR.Open "post", Database_Server_Url, False: Rem �����c�������������朽ӣ����� post ��ʽՈ�󣬅��� False ��ʾ�����M�̣��ȴ��յ����������ص�푑������ĕr�����^�m�������m�Ĵ��a�Z�䣬��߀�]�յ����������ص�푑������r���͕������@�Y����������ֱ���յ�������푑�������ֹ�����ȡ True ֵ�ͱ�ʾ���ȴ�����������ֱ���^�m��������Ĵ��a���������^�Į����@ȡ������
            WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem Ո���^���������a��ʽ
            WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem Ո���^�������Ñ��˽��ܵĔ������
            WHR.SetRequestHeader "Referer", "http://localhost:27016/": Rem Ո���^�����������l��Ո���Դ
            WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" 'Ո���^�������Ñ�ϵ�y�Z��
            WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem Ո���^�������Ñ��˞g�[�������汾��Ϣ
            WHR.SetRequestHeader "Connection", "Keep-Alive": Rem Ո���^����������朽ӡ���ȡ "Close" ֵ�r����ʾ�����B�ӡ�

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
                WHR.SetRequestHeader "authorization", requst_Authorization: Rem �O��Ո���^������Ո����C�~̖�ܴa��
            End If
            'Debug.Print requst_Authorization: Rem ���������ڴ�ӡƴ�����Ո����C�~̖�ܴaֵ��

            'Dim CookiePparameter As String: Rem Ո�� Cookie ֵ�ַ���
            CookiePparameter = "Session_ID=request_Key->username:password"
            'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
            '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
            '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
            'Debug.Print CookiePparameter: Rem ���������ڴ�ӡƴ�����Ո�� Cookie ֵ��
            If CookiePparameter <> "" Then
                If Not (StatisticsAlgorithmControlPanel.Controls("Base64Encode") Is Nothing) Then
                    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                End If
                'If Not (StatisticsAlgorithmControlPanel.Controls("Base64Decode") Is Nothing) Then
                '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(StatisticsAlgorithmControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                'End If
                WHR.SetRequestHeader "Cookie", CookiePparameter: Rem �O��Ո���^������Ո�� Cookie��
            End If
            'Debug.Print CookiePparameter: Rem ���������ڴ�ӡƴ�����Ո�� Cookie ֵ��

            'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem Ո���^��������ʾ֪ͨ�������˷��� gzip, deflate ���s�^�ľ��a


            ''������Ӌ��Y���Ķ��S���M׃�� resultDataArray �ք��D�Q�������� JSON ��ʽ���ַ���;
            'Dim columnName() As String: Rem �ɼ��Y�����ֶΣ����У����Q�ַ���һ�S���M;
            'ReDim columnName(1 To UBound(resultDataArray, 2)): Rem �ɼ��Y�����ֶΣ����У����Q�ַ���һ�S���M;
            'columnName(1) = "Column_1"
            'columnName(2) = "Column_2"
            ''For i = 1 To UBound(columnName, 1)
            ''    Debug.Print columnName(i)
            ''Next i

            'Dim PostCode As String: Rem ��ʹ�� POST Ո��r���������SՈ��һ��l�͵��������˵� POST ֵ�ַ���
            'PostCode = ""
            'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""һ��"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""����"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""����"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""����"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""����"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""����""}"
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

            ''ʹ�� For ѭ�hǶ�ױ�v�ķ�������һ�S���M��ֵƴ�Ӟ� JSON �ַ��������� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
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
            '    'Debug.Print PostCode: Rem ���������ڴ�ӡƴ�����Ո�� Post ֵ��

            '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem Ո���^������POST �������L�ȡ�

            '    WHR.Send (PostCode): Rem ��������l�� Http Ո��(��Ո�����d�W퓔���)������ WHR.Open �rʹ�� "get" ��������ֱ���{�á�WHR.Send���l�ͣ��������������̖�еą��� (PostCode)��
            '    'WHR.WaitForResponse: Rem �ȴ���������XMLHTTP��Ҳ����ʹ��

            '    '�xȡ���������ص�푑�ֵ
            '    WHR.Response.write.Status: Rem ��ʾ�������˽ӵ�Ո���ᣬ���ص� HTTP 푑���B�a
            '    WHR.Response.write.responseText: Rem �O���������˷��ص�푑�ֵ�����ı���ʽ����
            '    'WHR.Response.BinaryWrite.ResponseBody: Rem �O���������˷��ص�푑�ֵ���Զ��M�Ɣ�������ʽ����

            '    ''Dim HTMLCode As Object: Rem ��һ�� htmlfile ����׃������춱��淵�ص�푑�ֵ��ͨ���� HTML �W�Դ���a
            '    ''Set HTMLCode = CreateObject("htmlfile"): Rem ����һ�� htmlfile ���󣬌���׃���xֵ��Ҫʹ�� set �P�I�ֲ��Ҳ���ʡ�ԣ���ͨ׃���xֵʹ�� let �P�I�ֿ���ʡ��
            '    '''HTMLCode.designMode = "on": Rem �_����݋ģʽ
            '    'HTMLCode.write .responseText: Rem ���딵���������������ص�푑�ֵ���x�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode��������푑��^�ęn
            '    'HTMLCode.body.innerhtml = WHR.responseText: Rem �����������ص�푑�ֵ HTML �W�Դ�a�еľW��w��body���ęn���ֵĴ��a���xֵ�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode�������� ��responsetext�� ����������ӵ��͑��˰l�͵� Http Ո��֮�ᣬ���ص�푑�ֵ��ͨ���� HTML Դ���a�������N��ʽ����ʹ�Å��� ResponseText ��ʾ�����������ص�푑�ֵ�������ַ����ı���������ʹ�Å��� ResponseXML ��ʾ�����������ص�푑�ֵ�� DOM ������푑�ֵ������ DOM �������m�t����ʹ�� JavaScript �Z�Բ��� DOM �������댢푑�ֵ������ DOM �����Ҫ����������ص�푑�ֵ��횠� XML ����ַ�������ʹ�Å��� ResponseBody ��ʾ�����������ص�푑�ֵ��������M����͵Ĕ��������M�Ɣ�������ʹ�� Adodb.Stream �M�в�����
            '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
            '    'HTMLHead = WHR.GetAllResponseHeaders: Rem �xȡ���������ص�푑�ֵ HTML �W�Դ���a�е��^��head���ęn�������Ҫ��ȡ�W��^�ęn�е� Cookie ����ֵ����ʹ�á�.GetResponseHeader("set-cookie")��������

            '    Response_Text = WHR.responseText
            '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
            '    'Debug.Print Response_Text
            'Next i

            ''ʹ�� For ѭ�hǶ�ױ�v�ķ����������S���M��ֵƴ�Ӟ� JSON �ַ��������� Array ����S���M���t���� UBound(Array, 1) ��ʾ���S���M�ĵ� 1 ���S�ȵ��������̖������ UBound(Array, 2) ��ʾ���S���M�ĵ� 2 ���S�ȵ��������̖��
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
            ''Debug.Print PostCode: Rem ���������ڴ�ӡƴ�����Ո�� Post ֵ��

            'responseJSONDict.RemoveAll: Rem ����ֵ䣬ጷ��ڴ�
            'Set responseJSONDict = Nothing: Rem ��Ռ���׃����responseJSONDict����ጷ��ڴ�
            ''ReDim resultDataArray(0): Rem ��Ք��M��ጷ��ڴ�
            'Erase resultDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�


            Dim toDatabase_Dict As Object  '��������ֵ�ֵ䣬ӛ��򔵓���������l�͵ģ���춽yӋ�\���ԭʼ�������ͽ��^�㷨������Ӌ��֮��õ��ĽY������������l��֮ǰ��Ҫ�õ�������ģ�M��Module�����ֵ�׃���D�Q�� JSON �ַ���;
            Set toDatabase_Dict = CreateObject("Scripting.Dictionary")
            'Debug.Print Data_Dict.Count
            '�z���ֵ����Ƿ��ѽ�ָ�����Iֵ��
            If toDatabase_Dict.Exists("requestData") Then
                toDatabase_Dict.Item("requestData") = requestJSONText: Rem ˢ���ֵ�ָ�����Iֵ��
            Else
                toDatabase_Dict.Add "requestData", requestJSONText: Rem �ֵ�����ָ�����Iֵ��
            End If
            'Debug.Print toDatabase_Dict.Item("requestData")
            If toDatabase_Dict.Exists("responseResult") Then
                toDatabase_Dict.Item("responseResult") = responseJSONText: Rem ˢ���ֵ�ָ�����Iֵ��
            Else
                toDatabase_Dict.Add "responseResult", responseJSONText: Rem �ֵ�����ָ�����Iֵ��
            End If
            'Debug.Print toDatabase_Dict.Item("responseResult")


            'ʹ�õ�����ģ�M��Module����clsJsConverter����ԭʼ�����ֵ� Data_Dict �D�Q�����㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ�����ע����h�ֵȷǣ�ASCII, American Standard Code for Information Interchange��������Ϣ���Q�˜ʴ��a���ַ������D�Q�� unicode ���a;
            'ʹ�õ�����ģ�M��Module����clsJsConverter �� Github �ٷ��}��Wַ��https://github.com/VBA-tools/VBA-JSON
            'Dim JsonConverter As New clsJsConverter: Rem ��һ�� JSON ��������clsJsConverter������׃������� JSON �ַ����� VBA �ֵ䣨Dict��֮�g�����D�Q��JSON ��������clsJsConverter������׃���ǵ������ģ�K clsJsConverter ���Զ��x���b��ʹ��ǰ��Ҫ�_���ѽ�����ԓ�ģ�K��
            Dim PostCode As String: Rem ��ʹ�� POST Ո��r���������SՈ��һ��l�͵��������˵� POST ֵ�ַ���
            'PostCode = JsonConverter.ConvertToJson(toDatabase_Dict, Whitespace:=2): Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
            PostCode = JsonConverter.ConvertToJson(toDatabase_Dict): Rem ���㷨�������l�͵�ԭʼ������ JSON ��ʽ���ַ���;
            'Debug.Print PostCode

            toDatabase_Dict.RemoveAll: Rem ����ֵ䣬ጷ��ڴ�
            Set toDatabase_Dict = Nothing: Rem ��Ռ���׃����toDatabase_Dict����ጷ��ڴ�
            requestJSONText = "": Rem �ÿգ�ጷ��ڴ�
            responseJSONText = "": Rem �ÿգ�ጷ��ڴ�
            Set JsonConverter = Nothing: Rem ��Ռ���׃����JsonConverter����ጷ��ڴ�


            WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem Ո���^������POST �������L�ȡ�

            WHR.Send (PostCode): Rem ��������l�� Http Ո��(��Ո�����d�W퓔���)������ WHR.Open �rʹ�� "get" ��������ֱ���{�á�WHR.Send���l�ͣ��������������̖�еą��� (PostCode)��
            'WHR.WaitForResponse: Rem �ȴ���������XMLHTTP��Ҳ����ʹ��

            '�xȡ���������ص�푑�ֵ
            WHR.Response.Write.Status: Rem ��ʾ�������˽ӵ�Ո���ᣬ���ص� HTTP 푑���B�a
            WHR.Response.Write.responseText: Rem �O���������˷��ص�푑�ֵ�����ı���ʽ����
            'WHR.Response.BinaryWrite.ResponseBody: Rem �O���������˷��ص�푑�ֵ���Զ��M�Ɣ�������ʽ����

            ''Dim HTMLCode As Object: Rem ��һ�� htmlfile ����׃������춱��淵�ص�푑�ֵ��ͨ���� HTML �W�Դ���a
            ''Set HTMLCode = CreateObject("htmlfile"): Rem ����һ�� htmlfile ���󣬌���׃���xֵ��Ҫʹ�� set �P�I�ֲ��Ҳ���ʡ�ԣ���ͨ׃���xֵʹ�� let �P�I�ֿ���ʡ��
            '''HTMLCode.designMode = "on": Rem �_����݋ģʽ
            'HTMLCode.write .responseText: Rem ���딵���������������ص�푑�ֵ���x�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode��������푑��^�ęn
            'HTMLCode.body.innerhtml = WHR.responseText: Rem �����������ص�푑�ֵ HTML �W�Դ�a�еľW��w��body���ęn���ֵĴ��a���xֵ�o֮ǰ���� htmlfile ��͵Č���׃����HTMLCode�������� ��responsetext�� ����������ӵ��͑��˰l�͵� Http Ո��֮�ᣬ���ص�푑�ֵ��ͨ���� HTML Դ���a�������N��ʽ����ʹ�Å��� ResponseText ��ʾ�����������ص�푑�ֵ�������ַ����ı���������ʹ�Å��� ResponseXML ��ʾ�����������ص�푑�ֵ�� DOM ������푑�ֵ������ DOM �������m�t����ʹ�� JavaScript �Z�Բ��� DOM �������댢푑�ֵ������ DOM �����Ҫ����������ص�푑�ֵ��횠� XML ����ַ�������ʹ�Å��� ResponseBody ��ʾ�����������ص�푑�ֵ��������M����͵Ĕ��������M�Ɣ�������ʹ�� Adodb.Stream �M�в�����
            'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
            'HTMLHead = WHR.GetAllResponseHeaders: Rem �xȡ���������ص�푑�ֵ HTML �W�Դ���a�е��^��head���ęn�������Ҫ��ȡ�W��^�ęn�е� Cookie ����ֵ����ʹ�á�.GetResponseHeader("set-cookie")��������

            'Dim Response_Text As String: Rem �нӷ��������ص�푑�ֵ�ַ���;
            Response_Text = WHR.responseText
            Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem �����d��ķ�����푑�ֵ�ַ����D�Q�� GBK ���a��������푑�ֵ�@ʾ�y�a�r���Ϳ���ͨ�^ʹ�� StrConv �������ַ������a�D�Q���Զ��xָ���� GBK ���a���@�Ӿ͕��@ʾ���w���ģ�&H804��GBK��&H404��big5��
            'Debug.Print Response_Text

            'WHR.abort: Rem �� XMLHttpRequest �����λ��δ��ʼ����B;

            Response_Text = "": Rem �ÿգ�ጷ��ڴ�
            PostCode = "": Rem �ÿգ�ጷ��ڴ�
            'Set HTMLCode = Nothing
            Set WHR = Nothing: Rem ��Ռ���׃����WHR����ጷ��ڴ�

        Else

            Debug.Print "��춱���Y���Ĕ������������ַ����ֵ�e�`:" & Chr(10) & "�������춱���Y���Ĕ������������ַ Data Server Url = { " & CStr(Database_Server_Url) & " } ����."

            If Data_Receptors = "Database" Then

                'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
                If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
                    StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "�����e�`���������������ַ DataServer={" & CStr(Database_Server_Url) & "} ����.": Rem ��ʾ�������춱���Y���Ĕ������������ַ����ֵ�e�`���xֵ�o�˺��ؼ� Web_page_load_status_Label �Č���ֵ .Caption �@ʾ�����ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
                End If

                ''���Ŀ�������д��w�ؼ��а��o��B�͘�־;
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
                ''ˢ�²�����崰�w�ؼ��е�׃��ֵ
                ''Debug.Print "Start or Stop Calculate Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem �@�l�Z������{ʽ���{ԇ�ꮅ��Ʉh����Ч�����ڡ��������ڡ����@ʾ�xȡ���� PublicVariableStartORStopButtonClickState ֵ��
                ''�������崰�w�ؼ� StatisticsAlgorithmControlPanel �а����ģ��O�y���w�І����\�㰴ť�ؼ����c����B�������ͣ�׃�������xֵ
                'If Not (StatisticsAlgorithmControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
                '    StatisticsAlgorithmControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
                'End If
                ''ȡ����������д��w�ؼ��еİ��o���à�B
                'StatisticsAlgorithmControlPanel.Start_calculate_CommandButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еİ��o�ؼ� Start_calculate_CommandButton�������\�㰴�o����False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Database_Server_Url_TextBox����춱���Ӌ��Y���Ĕ�����������Wַ URL �ַ���ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox1.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĶ��x��ؼ� Data_Receptors_CheckBox1������Д���R�x��Ӌ��Y��������� Database �Ķ��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Data_Receptors_CheckBox2.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĶ��x��ؼ� Data_Receptors_CheckBox2������Д���R�x��Ӌ��Y��������� Excel �Ķ��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Statistics_Algorithm_Server_Url_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Statistics_Algorithm_Server_Url_TextBox���ṩ�yӋ�㷨�ķ������Wַ URL �ַ���ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Username_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Username_TextBox�������C�ṩ�yӋ�㷨�ķ��������~����ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Password_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еİ��o�ؼ� Password_TextBox�������C�ṩ�yӋ�㷨�ķ��������~���ܴaݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Field_name_of_Data_Input_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Field_name_of_Data_Input_TextBox������ԭʼ�����ֶ����� Excel ��񱣴�^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Data_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Data_TextBox������ԭʼ������ Excel ��񱣴�^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Output_position_TextBox.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �е��ı�ݔ���ؼ� Output_position_TextBox������Ӌ��Y���� Excel ���^�g��ݔ��򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.FisherDiscriminant_OptionButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĆ��x��ؼ� FisherDiscriminant_OptionButton����춘��R�x��ĳһ�����w�㷨 FisherDiscriminant �Ć��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
                'StatisticsAlgorithmControlPanel.Interpolate_OptionButton.Enabled = True: Rem ���ò�����崰�w StatisticsAlgorithmControlPanel �еĆ��x��ؼ� Interpolate_OptionButton����춘��R�x��ĳһ�����w�㷨 Interpolate �Ć��x�򣩣�False ��ʾ�����c����True ��ʾ�����c��
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
            returnMsgBox = MsgBox("�������춱���Y���Ĕ������������ַ����ֵ�e�`." & Chr(10) & "�������춱���Y���Ĕ������������ַ DataServer = { " & CStr(Database_Server_Url) & " } ����." & Chr(10) & "�ڔ������������ַ DataServer = { } ���յ���r�£��������򔵓���������l�͔������Y��ֻ���� Excel �����." & Chr(10) & "�Γ� { �_�� } ���o���^�m�\�У��Γ� { ȡ�� } ���o����ֹ�\��.", 49, "����")

            Select Case returnMsgBox

                Case Is = 1

                Case Is = 2

                    Exit Sub

                Case Else

                    MsgBox "�����e�` ( MsgBox Reteurn = " & CStr(returnMsgBox) & " )��ֻ��ȡ������ֵ 1��2 ֮һ."
                    Exit Sub

            End Select

        End If

    End If

    'ReDim resultDataArray(0): Rem ��Ք��M��ጷ��ڴ�
    Erase resultDataArray: Rem ���� Erase() ��ʾ�ÿՔ��M��ጷ��ڴ�
    responseJSONDict.RemoveAll: Rem ����ֵ䣬ጷ��ڴ�
    Set responseJSONDict = Nothing: Rem ��Ռ���׃����responseJSONDict����ጷ��ڴ�

    'ˢ�¿�����崰�w�ؼ��а�������ʾ�˺��@ʾֵ
    If Not (StatisticsAlgorithmControlPanel.Controls("calculate_status_Label") Is Nothing) Then
        StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Caption = "���C Stand by": Rem ��ʾ�˺������ԓ�ؼ�λ춲�����崰�w StatisticsAlgorithmControlPanel �У���������� .Controls() �����@ȡ���w�а�����ȫ����Ԫ�ؼ��ϣ��Kͨ�^ָ����Ԫ�����ַ����ķ�ʽ��@ȡĳһ��ָ������Ԫ�أ����硰StatisticsAlgorithmControlPanel.Controls("calculate_status_Label").Text����ʾ�Ñ����w�ؼ��еĘ˺���Ԫ�ؿؼ���Web_page_load_status_Label���ġ�text������ֵ Web_page_load_status_Label.text�����ԓ�ؼ�λ춹������У��������ʹ�� OleObjects ������ʾ�������а�����������Ԫ�ؿؼ����ϣ����� Sheet1 ���������пؼ� CommandButton1����������@�ӫ@ȡ����Sheet1.OLEObjects("CommandButton" & i).Object.Caption ��ʾ CommandButton1.Caption����ע�� Object ����ʡ�ԡ�
    End If

End Sub


'�������x
Public Sub StatisticsAlgorithm()  '�P�I�� Private ��ʾ���^��ֻ�ڱ�ģ�K����Ч���P�I�� Public ��ʾ���^��������ģ�K�ж���Ч

    Call StatisticsAlgorithmModule_Initialize  '����������Ĺ�����������ֵ��ʼ��

    StatisticsAlgorithmControlPanel.show  '�@ʾ�Զ��x�Ĳ�����崰�w�ؼ�
    'StatisticsAlgorithmControlPanel.Hide  '�[���Զ��x�Ĳ�����崰�w�ؼ�
    'Unload StatisticsAlgorithmControlPanel
    'Load UserForm: StatisticsAlgorithmControlPanel
    'For i = 0 To StatisticsAlgorithmControlPanel.Controls.Count - 1
    '    DoEvents: Rem �Z�� DoEvents ��ʾ����ϵ�y CPU ���ƙ�߀�o����ϵ�y��Ҳ�����ڴ�ѭ�h�A�Σ��Ñ�����ͬ�r������X���������ã������ǌ��������ֱ��ѭ�h�Y����
    'Next i

    'MsgBox "�yӋ�㷨ʾ�����̣�LC5PFit - 5 ����߉݋���Q�M��."

End Sub




'*********************************************************************************************************************************************************************************



'�xȡ����Ӳ�P JSON �ęn������ʾ�����a
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
