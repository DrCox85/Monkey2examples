#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window
	Field a:Int = 10
	Field b:Int = 5
	Field c:Int=10
	Field d:Int=0
	Method New()
		' Elvis Operator.
		'
		' If b = any other value of 0 then a gets 
		' value of b else it gets value of -1 .
		a=b?Else-1
		' Here c gets the value of -1 because d = 0. 
		'
		c=d?Else-1
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Color = Color.Black
		canvas.DrawText("a = "+a,0,0)
		canvas.DrawText("c = "+c,0,15)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
