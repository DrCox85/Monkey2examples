#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class bushfire
	Field map:Int[,] = New Int[1,1]
	Field mw:Int,mh:Int
	Field tw:Float,th:Float
	Field cols:Color[] = New Color[20]
	Method New(w:Float,h:Float,num:Int)
		Self.mw = 100
		Self.mh = 100
		Self.tw = w/mw
		Self.th = h/mh
		map = New  Int[mw,mh]
		cols = New Color[num+1]
		For Local i:Int = 0 Until num
		map[Rnd(10,mw-10),Rnd(10,mh-10)] = i
		Local gs:Float=Rnd()
		cols[i] = New Color(gs,gs,gs)
		Next
	End Method
	Method burnmap(tile:Int,amount:Int)
		
		For Local i:=0 Until amount
			Local x1:Int=Rnd(1,mw-1)
			Local y1:Int=Rnd(1,mh-1)
			If map[x1,y1] = tile				
				For Local y2:Int=-1 To 1
				For Local x2:Int=-1 To 1
					Local x3:Int=x1+x2
					Local y3:Int=y1+y2
					If Rnd()<.3
						If map[x3,y3] = 0
							map[x3,y3] = tile
						End If
					End If
				Next
				Next
			End If
		Next
	End Method
	Method draw(canvas:Canvas)				
		canvas.Color=Color.Brown
		For Local y:Float=0 Until mh Step 1
		For Local x:Float=0 Until mw Step 1
			If map[x,y] > 0			
			canvas.Color = cols[map[x,y]]
			canvas.DrawRect(x*tw,y*th,tw,th)
			End If
		Next
		Next
	End Method
End Class

Global mybushfire:bushfire

Class MyWindow Extends Window
	Field num:Int=10
	field cnt:Int
	Method New()
		Title="Monkey 2 - Bushfire map generator." 
		mybushfire = New bushfire(Width,Height,num)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(Color.Black)
		cnt+=1
		If cnt>800 Or Mouse.ButtonDown(MouseButton.Left)
			cnt=0
			num=Rnd(3,40)
			mybushfire = New bushfire(Width,Height,num)			
		Endif
		For Local i:Int=0 Until num
			mybushfire.burnmap(i,Rnd(100,800))
		Next
		mybushfire.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class


Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
