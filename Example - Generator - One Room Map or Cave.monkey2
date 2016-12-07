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
		Local l1:Int=Rnd(20,30)
		Local h1:Int=Rnd(31,50)
		Local l2:Float=Rnd(0.02,0.1)
		Local h2:Float=Rnd(0.11,0.2)
		mapshape(50,50,l1,h1,l2,h2)
		'mapshape(50,50,20,50,0.05,0.5)
		'mapshape(50,50,20,50,0.1,0.2)
	End Method
	Method mapshape(x:Int,y:Int,l1:float,h1:Float,l2:Float,h2:Float)
		Local eloop:Bool=False
		Local angle:Float=0
		Local x1:Float=x
		Local y1:Float=y
		Local x2:Float=x+Cos(angle)*l1
		Local y2:Float=y+Sin(angle)*l1
		Local x3:Float
		Local y3:Float
		While eloop=False
			Local d:Float=Rnd(l1,h1)
			x3=x1+(Cos(angle)*d)
			y3=y1+(Sin(angle)*d)
			mapline(x2,y2,x3,y3,1)
			x2=x3
			y2=y3
			angle+=Rnd(l2,h2)	
			If angle>TwoPi Then eloop=True		
		Wend
		mapline(x2,y2,x+Cos(angle)*l1,y+Sin(angle)*l1,1)
		' fill map
		Local sx:Stack<Int> = New Stack<Int>
		Local sy:Stack<Int>	= New Stack<Int>
		sx.Push(50)
		sy.Push(50)
		Local mx:Int[] = New Int[](0,1,0,-1)
		Local my:Int[] = New Int[](-1,0,1,0)
		While sx.Empty = False
			Local x4:Int = sx.Get(0)
			Local y4:Int = sy.Get(0)
			sx.Erase(0)
			sy.Erase(0)
			For Local i:=0 Until 4
				Local x5:Int=x4+mx[i]
				Local y5:Int=y4+my[i]
				If map[x5,y5] = 0
					sx.Push(x5)
					sy.Push(y5)
					map[x5,y5] = 2
				End If
			Next
		Wend
		
	End Method
	Method mapline(x1:Int,y1:Int,x2:Int,y2:Int,tile:Int)
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
		     If x1>=0 And x1<mw And y1>=0 And y1<mh
		        map[x1,y1] = tile
		     End If
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
	End Method 	
	Method draw(canvas:Canvas)
		For Local y:float=0 Until mh Step 1
		For Local x:Float=0 Until mw Step 1
			Local t:Int=map[x,y]
			If t>0
			Select t			
			Case 1
			canvas.Color = New Color(1,1,1)
			Case 2
			canvas.Color = New Color(.2,.2,.2)
			End Select
			canvas.DrawRect(x*tw,y*th,tw,th)
			End If
		Next
		Next
	End Method
End Class

Global myworld:world

Class MyWindow Extends Window
	Field cnt:Int
	Method New()
		Title="Monkey 2 - One Room Map/Cave Generator"
		myworld = New world(Width,Height,100,100)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		myworld.draw(canvas)
		cnt+=1
		If cnt>100
			cnt=0
			myworld = New world(Width,Height,100,100)
		End If
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
