' UpdateVersion.vbs v1.0, Sven Rowoldt, Sep. 2022, works with VisualStudio 2019
'
' Put the following into pre-compile build commands: "Path-to-this-script\UpdateVersion.vbs"  "$(ProjectDir)"
' Updates automaticly the version strings to: (Major version).(Minor version).([year][dayofyear]).(increment)
' expects strings in AssemblyInfo.cs like:
'[assembly: AssemblyVersion("1.5.0.0")]
'[assembly: AssemblyFileVersion("1.4.0.0")]

set ws = CreateObject("WScript.Shell")
set o_FSO = CreateObject("Scripting.FileSystemObject")

If (WScript.Arguments.Count = 0) Then
	WScript.Echo ("Folder must be specified as command line parameter")
	Call WScript.Quit(1)
End If

Dim singleFolder: singleFolder = WScript.Arguments.Item(0)
Dim inputfile: inputfile = singleFolder & "\Properties\AssemblyInfo.cs"


Dim V3: V3 = Right(Year(now), 2)
Dim strDateTime: strDateTime = Now()
strPastDay = #01/01#
Dim V4: V4 = INT(strDateTime - strPastDay)

If o_FSO.FileExists (inputfile) Then
	set TextStream = o_FSO.OpenTextFile(inputfile, 1)

	original = ""
	do until TextStream.AtEndOfStream
		'OutFile.WriteLine Replace (TextStream.ReadLine, altstr, neustr)
		str = TextStream.ReadLine

		if Left(str, 27) = "[assembly: AssemblyVersion(" Then 
			Ostr1 = str
			a = findNth(str, ".", 2)
			verstart = InStr(str, "(") + 2
			AVers = Mid(str, verstart, a-verstart) '1.5
			a = findNth(str, ".", 3)
			b = inStr(str, ")")
			ABuild = Mid(str, a+1, b-a-2)
		End If
		if Left(str, 31) = "[assembly: AssemblyFileVersion(" Then 
			Ostr2 = str
			a = findNth(str, ".", 2)
			verstart = InStr(str, "(") + 2
			AFVers = Mid(str, verstart, a-verstart) '1.4
			a = findNth(str, ".", 3)
			'b = findNth(str, ")", 1)-1
			b = inStr(str, ")")
			BBuild = Mid(str, a+1, b-a-2)			
		End If
		original = original & str & vbcrlf
	Loop
	Textstream.close
	Vstr1 = "[assembly: AssemblyVersion(""" & AVers & "." & V3 & V4 & "." & (ABuild+1) & """)]"
	Vstr2 = "[assembly: AssemblyFileVersion(""" & AFVers & "." & V3 & V4 & "." & (BBuild+1) & """)]"
	
	outfile = Replace(original, Ostr1, Vstr1)
	outfile = Replace(outfile, Ostr2, Vstr2)
	
	set TextStream = o_FSO.OpenTextFile(inputfile, 2, true)	
		Textstream.Write outfile
	Textstream.close
	
	Call WScript.Quit(0)
else
	msgbox(inputfile & " was not found!")
	Call WScript.Quit(2)		
end if

Function findNth(str, substr, count)
	a=0
	for i=1 to count
		a=InStr(a+1, str, substr)
	Next
	findNth=a
End Function