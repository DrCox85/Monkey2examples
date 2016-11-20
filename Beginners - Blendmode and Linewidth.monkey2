#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window

	Method New()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.BlendMode=BlendMode.Opaque
		canvas.LineWidth = 10		 
		canvas.DrawLine(0,0,100,100)
		canvas.BlendMode=BlendMode.None
		canvas.LineWidth = 20
		canvas.DrawLine(100,0,200,100)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
