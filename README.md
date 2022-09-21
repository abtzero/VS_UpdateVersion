# VS_UpdateVersion
A script that automaticly updates the version number in Visula Studio

UpdateVersion.vbs 1.0, Sven Rowoldt, Sep. 2022, works with VisualStudio 2019

setting the version-strings to 1.0.* does not automaticly update the version at compile.
gitEven by setting the Deterministic - flag in Your-project-name.crproj to false,

So I made this little vb-script, which does do the job.

Copy this script into a folder and put the following into pre-compile build-commandline:
"Path-to-this-script\UpdateVersion.vbs"  "$(ProjectDir)"
(including the quotes and filling in the real path of Your machine)

Updates automaticly the version strings to: (Major version).(Minor version).([year][dayofyear]).(increment)
It keeps the Major version and the Minor version numbers and adds as third number XXYYY, where XX presents
the last 2 digits of the current year and YYY the number of the actual day in the current year.
The last number is read from the file and will be incremented by 1 on every compile.

Set the strings in AssemblyInfo.cs for example like:
[assembly: AssemblyVersion("1.1.0.0")]
[assembly: AssemblyFileVersion("1.1.0.0")]

They will be changed i.e. to ("1.1.22262.1")

After setting up the pre-compile-build-commandline Your are done.
It changes the version number on every compile in Debug as well in Release mode.
Just add a whitespace to any file of Your project to have a new compilation when
using "Start".
