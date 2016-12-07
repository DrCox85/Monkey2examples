#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class world
	Field map:Int[,] = New Int[1,1]
	Field tw:Float,th:Float
	Field sw:Int,sh:Int
	Field mw:Int,mh:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.mw = mw
		Self.mh = mh
		Self.sw = sw
		Self.sh = sh
		tw = Float(sw)/Float(mw)
		th = Float(sh)/Float(mh)
		map = New Int[mw,mh]
		makemap()
	End Method
	Method makemap()
		Local eloop:Bool=False		
		While eloop=False
			Local x1:Int=Rnd(-10,mw)
			Local y1:Int=Rnd(-10,mh)
			Local w:Int=Rnd(1,12)
			Local h:Int=Rnd(1,10)
			For Local y2:=y1 To y1+h
			For Local x2:=x1 To x1+w
				If x2>=0 And x2<mw And y2>=0 And y2<mh
					map[x2,y2] = map[x2,y2] + 1
					If map[x2,y2] > 31 Then eloop=True					
				End If
			Next
			Next		
		Wend
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			map[x,y] = (10.0/31)*map[x,y]
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:float=0 Until mh Step 1
		For Local x:Float=0 Until mw Step 1
			Local t:Int=map[x,y]
			Select t
			Case 0
			canvas.Color = New Color(0,0,.5)
			Case 2
			canvas.Color = New Color(0,0,.6)
			Case 3
			canvas.Color = New Color(0,0,.7)
			Case 4
			canvas.Color = New Color(.1,.1,.7)
			Case 5
			canvas.Color = New Color(1,.8,0)
			Case 6
			canvas.Color = New Color(.2,1,.1)
			Case 7
			canvas.Color = New Color(0,.5,0)
			Case 8
			canvas.Color = New Color(0,.2,0)			
			Case 9
			canvas.Color = New Color(.9,.8,.9)			
			Case 10
			canvas.Color = New Color(.9,.9,.9)			
			End Select
			canvas.DrawRect(x*tw,y*th,tw,th)
		Next
		Next
	End Method
End Class

Global myworld:world

Class MyWindow Extends Window
	Field cnt:Int
	Method New()
		Title="Monkey 2 - World map Generator"
		myworld = New world(Width,Height,100,100)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		cnt+=1
		If cnt>200
			cnt=0
			Local s:Int=Rnd(32,256)
			myworld = New world(Width,Height,s,s)
		End If 
		myworld.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
