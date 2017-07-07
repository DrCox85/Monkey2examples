'
' Bresenham line algorithm
'

#Import "<std>"
#Import "<mojo>"
'

Using std..
Using mojo..


Class MyWindow Extends Window

	Method New()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		' Draw some text
		canvas.Color = Color.Black
		'
		For Local i:Int=0 Until 50
			Local x1:Int=Rnd(0,Width)
			Local y1:Int=Rnd(0,Height)
			Local x2:Int=Rnd(0,Width)
			Local y2:Int=Rnd(0,Height)
			bline(canvas,x1,y1,x2,y2)
		Next
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function bline:Void(canvas:Canvas,x1:Int,y1:Int,x2:Int,y2:Int)
    Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
    dx = Abs(x2 - x1)
    sx = -1
    If x1 < x2 Then sx = 1      
    dy = Abs(y2 - y1)
    sy = -1
    If y1 < y2 Then sy = 1
    If dx < dy Then 
        e = dx / 2 
    Else 
        e = dy / 2          
    End If
    Local exitloop:Bool=False
    While exitloop = False
		canvas.DrawPoint(x1,y1)  

      If x1 = x2 
          If y1 = y2
              exitloop = True
          End If
      End If
      If dx > dy Then
          x1 += sx ; e -= dy 
           If e < 0 Then e += dx ; y1 += sy
      Else
          y1 += sy ; e -= dx 
          If e < 0 Then e += dy ; x1 += sx
      Endif

    Wend

End Function


Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
