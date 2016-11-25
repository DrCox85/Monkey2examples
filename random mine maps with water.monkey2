#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class watermap
	Field freq:Int 'how many updates per cycle
	Field tw:Float,th:Float
	Field w:Int,h:Int
	Field map:= New Int[1,1] 

	Method New(sw:float,sh:float,w:float,h:Float,freq:int)
		Self.freq = freq
		tw = sw/w
		th = sh/h
		map = New Int[w,h]
		Self.w = w
		Self.h = h
	End Method 
	Method update()
		If Mouse.ButtonDown(MouseButton.Left)
			Local x:Int= Mouse.X/tw
			Local y:Int = Mouse.Y/th
			If x>0 And x<w And y>0 And y<h 
				map[x,y] = 2
			End If
		End If
		If Mouse.ButtonDown(MouseButton.Right)
			Local x:Int= Mouse.X/tw
			Local y:Int = Mouse.Y/th
			If x>0 And x<w And y>0 And y<h 
				map[x,y] = 1
			End If
		End If
		If Mouse.ButtonDown(MouseButton.Middle)
			Local x:Int= Mouse.X/tw
			Local y:Int = Mouse.Y/th
			If x>0 And x<w And y>0 And y<h 
				map[x,y] = 0
			End If
		End If

		For Local i := 0 Until freq
			updatewater(Rnd(2,w-2),Rnd(2,h-2))
		Next
	End Method 
	Method updatewater(x:Int,y:Int)
		Local s:Int=Rnd(0,6)
		If map[x,y] = 2 Then
			Select s
			Case 0
				If map[x-1,y] = 0
				If map[x+1,y] = 1
					map[x-1,y] = 2
					map[x,y] = 0				
				End If
				Endif
			Case 1
				If map[x-1,y] = 1
				If map[x+1,y] = 0
					map[x+1,y] = 2
					map[x,y] = 0				
				End If
				End If
			Case 2
				If map[x,y+1] = 0
					map[x,y+1] = 2
					map[x,y] = 0
				End If				
			Case 3
				If map[x-1,y] = 0
				If map[x-1,y+1] = 0
				If map[x,y+1] = 2
					map[x,y] = 0
					map[x-1,y+1] = 2
				End If	
				End If 
				End If
			Case 4 'swooop right
				If map[x+1,y] = 0
				If map[x-1,y] = 2
					Local exitloop:Bool=False
					Local mx:Int=x
					While exitloop = False										
						If map[mx,y] <> 2 Then exitloop = True					
						mx-=1
					Wend
					
					map[x+1,y] = 2
					Local el:Bool=False
					Local v:Int
					While el=False
					v=Rnd(mx+1,x)
					If map[v,y] = 2 Then el=True
					Wend
					map[v,y] = 0												
				End If
				End If 
			
			Case 5 'swooop left
				If map[x-1,y] = 0
				If map[x+1,y] = 2
					Local exitloop:Bool=False
					Local mx:Int=x
					While exitloop = False										
						If map[mx,y] <> 2 Then exitloop = True					
						mx+=1
					Wend
					map[x-1,y] = 2
					map[Rnd(x,mx-1),y] = 0												
				End If 
				End If
			End Select
		End If
	End Method 
	Method makewater(x:Int,y:Int,w:Int,h:Int)
		For Local y1:=y Until y+h
		For Local x1:=x Until x+w
			map[x1,y1] = 2
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:=0 Until h
		For Local x:=0 Until w
			If map[x,y] = 0
				canvas.Color = Color.Black
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
			If map[x,y] = 1
				canvas.Color = Color.Grey
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
			If map[x,y] = 2
				canvas.Color = Color.Blue
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
			If map[x,y] = 3
				canvas.Color = Color.Brown
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
		Next
		Next
	End Method 
End Class 

Class map
	Field tw:Float,th:Float
	Field mw:Float,mh:Float
	Field sw:Float,sh:Float,mmh:Float,mmw:Float
	Field map:=New Int[1,1]
	Field mapfinal:=New Int[1,1]
	Method New(sw:float,sh:Float,mw:Float,mh:Float)
		Self.mmw = mw
		Self.mmh = mh
		Self.mw = mw/3
		Self.mh = mh/3		
		Self.sw = sw
		Self.sh = sh
		tw = sw/mmw
		th = sh/mmh
		map = New Int[mw,mh]
		mapfinal = New Int[mmw,mmh]
		makemap()
		finalizemap()
	End Method 
	Method finalizemap()
	For Local y:=1 Until mh-1
	For Local x:=1 Until mw-1
		If map[x,y] = 1
			For Local y2:=-1 To 1
			For Local x2:=-1 To 1
				mapfinal[(x*3)+x2,(y*3)+y2] = 1				
			Next
			Next			
		End If
	Next
	Next
	End Method
	Method makemap()
		For Local y:=mh/3 Until mh/2+10
		map[mw/2,y] = 1
		Next
		For Local i:=0 Until (mw*mh)*6
			Local x:Int=Rnd(2,mw-4)
			Local y:Int=Rnd(2,mh-4)
			If map[x,y] = 1				
				Local v:Int=Rnd(0,2)
				Select v
					Case 0'go left or right					
					If map[x-1,y] = 0
					If map[x+1,y] = 0					
					makeside(x,y,Rnd(0,2))
					End If 
					End If
					Case 1'go down Or up
					If map[x,y-1]=0
					If map[x,y+1]=0
					makevert(x,y,Rnd(0,2))
					End If
					End If
				End Select
			End If
		Next
		widenhorizontal()
	End Method
	Method widenhorizontal()
		For Local i:=0 Until mw*mh/2
			Local x:Int=Rnd(2,mw-2)
			Local y:Int=Rnd(2,mh-2)
			If map[x,y] = 1 And map[x,y-1] = 0 And map[x,y+1] = 0				
				Local w:Int=0
				Local x2:Int=x
				Local exitloop:Bool=False
				While exitloop = False
					If map[x2,y] = 0 Then exitloop = true 
					If map[x2,y-1] = 1 Then exitloop = True
					If map[x2,y+1] = 1 Then exitloop = True				
					x2+=1
					w+=1
				Wend
				'
				
				If w-2>3					
					For Local x2:Int=x To x+w-2
						map[x2,y-1] = 1
						map[x2,y+1] = 1
						If x2>x+2 And w>6 And x2<(x+5)
							map[x2,y+2] = 1
						End If
					Next
				End If
			End If
		Next
	End Method
	Method makevert(x:Int,y:Int,side:Int)
		Local l:Int=Rnd(4,20)
		If y<22 Then Return
		If y>mw-22 Then Return
		If side =  0'down		
			If overlap(x-4,y+1,x+4,y+l+2) = False
				For Local y2:=y To y+l
					map[x,y2] = 1
				Next
			End If
		End If
		If side =  1'up
			If overlap(x-4,(y-l)-3,x+4,y-1) = False
				For Local y2:=y-l To y
					map[x,y2] = 1
				Next
			End If
		End If

	End Method
	Method makeside(x:Int,y:Int,side:Int)		
		Local l:Int=Rnd(4,20)
		If x<22 Then Return
		If x>mw-22 Then Return		
		If side=0 Then 'left				
			If overlap((x-l)-2,y-5,x,y+5) = False				
				For Local x2:=x-l Until x
					map[x2,y] = 1
				Next
			End If
		End If
		If side=1 Then 'right		
			If overlap(x+1,y-5,x+l+2,y+5) = False								
				For Local x2:=x Until x+l
					map[x2,y] = 1
				Next
			End If			
		end If		
	End Method
	Method overlap:bool(x1:Int,y1:Int,x2:Int,y2:int)
		For Local y:=y1 Until y2
		For Local x:=x1 Until x2
			If x>0 And x<mw And y>0 And y<mh
				If map[x,y] = 1 Then Return True
			End If
		Next
		Next
		Return False
	End Method
	Method draw(canvas:Canvas)
		For Local y:=0 Until mmh
		For Local x:=0 Until mmw
			Select mapfinal[x,y]
				Case 0
				canvas.Color = Color.Black
				Case 1
				canvas.Color = Color.White
			End Select			
			canvas.DrawRect(x*tw,y*th,tw,th)
		Next
		Next
	End Method 
End Class

Global mymap:map
Global mywatermap:watermap

Class MyWindow Extends Window
	Field time:Int
	Method New()
		SeedRnd(100)
		local s:Int=180
		mymap = New map(Width,Height,s,s)
		mywatermap = New watermap(Width,Height,s,s,23000)
		For Local y:=0 Until s
		For Local x:=0 Until s
			mywatermap.map[x,y] = mymap.mapfinal[x,y]
			If mywatermap.map[x,y] = 1 Then mywatermap.map[x,y] = 0 Else mywatermap.map[x,y] = 1
		Next
		Next
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		time+=1
		mywatermap.update()
		mywatermap.draw(canvas)
		'mymap.draw(canvas)
		' if key escape then quit
		canvas.Color = Color.White
		canvas.DrawText(App.FPS,0,0)
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
