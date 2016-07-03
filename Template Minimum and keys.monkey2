#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global instance:AppInstance

Class MyWindow Extends Window

	Method New()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then instance.Terminate()		
	End Method	
	
End	Class

Function Main()
	instance = New AppInstance	
	
	New MyWindow
	
	App.Run()
	
End Function
