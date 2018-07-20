#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class world
	Class kagent
		Field kpx:Int,kpy:Int,kw:Int,kh:Int
		Field genetic:Stack<Int> = New Stack<Int>
		Field currentpos:Int
		Field time:Int,timeend:Int=10
		Field die:Bool=False
		Field winner:Bool=False		
		Field dis:Int 'last distance to target
		Field closest:Int 'flood distance
		Field origx:Int,origy:Int
		Method New(x:Int,y:Int)
			kpx = x
			kpy = y
			origx = x
			origy = y
			kw = 10
			kh = 10
		End Method
		Method updatewinner()
			time+=1
			move()

			If time>timeend Then 
				time = 0
				currentpos += 1
				If int(kpx/myworld.tw) = myworld.endx And int(kpy/myworld.th) = myworld.endy Then 
					currentpos = 0
					kpx = origx
					kpy = origy
					myworld.setmap1()
					Print "reset"
				End If
			End If

		End Method
		Method move()
			Select genetic.Get(currentpos)
				Case 0
					kpx-=1
					kpy-=1
				Case 1
					kpy-=1
				Case 2
					kpx+=1
					kpy-=1
				Case 3
					kpx-=1
				Case 4
				Case 5
					kpx+=1
				Case 6
					kpx-=1
					kpy+=1
				Case 7
					kpy+=1
				Case 8
					kpx+=1
					kpy+=1
			End Select

		End Method
		Method update()
			If die=True Then Return
			move()
			If Int(kpx/myworld.tw) = myworld.endx And Int(kpy/myworld.th) = myworld.endy
				For Local i:Int=0 Until myworld.myagent.Length
					myworld.myagent.Get(i).winner = false
				Next
				winner = True
				currentpos = 0
				kpx = origx
				kpy = origy				
				myworld.completed = True
				myworld.setmap1()
				Return
			End If
			time+=1
			If time>timeend Then 
				time = 0
				currentpos += 1
				If currentpos = genetic.Length Then die = True
			End If
			If collidemap()
				die = True
			End If
			If collideobstacle()
				die = True
			End If
		End Method
		Method growgenetic()
			For Local i:Int=0 Until 5
				genetic.Push(Rnd(0,9))
			Next
		End Method
		Method draw(canvas:Canvas)
			canvas.Color = Color.Red
			canvas.DrawOval(kpx,kpy,kw,kh)
		End Method
		Method collideobstacle:Bool()
			For Local i:Int=0 Until myworld.myobstacle.Length
				Local x2:Int=myworld.myobstacle.Get(i).kx
				Local y2:Int=myworld.myobstacle.Get(i).ky
				Local w2:Int=myworld.myobstacle.Get(i).kw
				Local h2:Int=myworld.myobstacle.Get(i).kh
				x2+=w2/2
				y2+=h2/2
				If rectsoverlap(kpx+kw/2,kpy+kh/2,kw,kh,x2,y2,w2,h2)
					Return True
				End if
			Next
			Return False
		End Method
		Method collidemap:Bool()
			Local cx:Int=(kpx+kw/2)/myworld.tw
			Local cy:Int=(kpy+kh/2)/myworld.th
			For Local y1:Int=cy-2 To cy+2
			For Local x1:Int=cx-2 To cx+2
				If x1<0 Or y1<0 Or x1>=myworld.mapw Or y1>=myworld.maph Then Continue
				If myworld.map[x1,y1] = 1
					Local x2:Int=x1*myworld.tw
					Local y2:Int=y1*myworld.th					
					If rectsoverlap(kpx,kpy,kw,kh,x2,y2,myworld.tw,myworld.th) Then Return True
				End if
			Next
			Next
			Return False
		End Method
		Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
		    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
		    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
		    Return True
		End Function
	End Class
	Class kobstacle
		Field kx:Int,ky:Int
		Field incx:Int,incy:Int
		Field kw:Int,kh:Int
		Field kd:String
		Method New(x:Int,y:Int,w:Int,h:Int,d:String)
			Self.kx = x
			Self.ky = y
			Self.kw = w
			Self.kh = h
			If d = "u" Then incy = -1
			If d = "d" Then incy = 1
			If d = "l" Then incx = -1
			If d = "r" Then incx = 1			
			Self.kd = d
		End Method
		Method update()			
			kx += incx
			ky += incy
			If collidemap() Then
				If kd = "u" Then 
					kd = "d"
					incy = 1					
				Elseif kd = "d"
					kd = "u"
					incy = -1
				End If
				If kd = "l" Then 
					kd = "r"
					incx = 1					
				Elseif kd = "r"
					kd = "l"
					incx = -1
				End If

			End If 
		End Method
		Method draw(canvas:Canvas)
			canvas.Color = Color.Blue
			canvas.DrawOval(kx+kw/2,ky+kh/2,kw,kh)
		End Method
		Method collidemap:Bool()
			Local cx:Int=(kx+kw/2)/myworld.tw
			Local cy:Int=(ky+kh/2)/myworld.th
			For Local y1:Int=cy-2 To cy+2
			For Local x1:Int=cx-2 To cx+2
				If x1<0 Or y1<0 Or x1>=myworld.mapw Or y1>=myworld.maph Then Continue
				If myworld.map[x1,y1] = 1
					Local x2:Int=x1*myworld.tw
					Local y2:Int=y1*myworld.th					
					If rectsoverlap(kx+kw/2,ky+kh/2,kw,kh,x2,y2,myworld.tw,myworld.th) Then Return True
				End if
			Next
			Next
			Return False
		End Method
		Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
		    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
		    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
		    Return True
		End Function
	End Class
	'
	Field sw:Int,sh:Int
	Field tw:Float,th:Float
	Field mapw:Int,maph:Int
	Field map:Int[,]
	Field dmap:Int[,] 'contains distances from end to start
	Field myagent:Stack<kagent> = New Stack<kagent>
	Field myobstacle:Stack<kobstacle> = New Stack<kobstacle>
	Field startx:Int,starty:Int,endx:Int,endy:Int
	Field completed:Bool=False
	Field currentlevel:Int
	Method New(sw:Int,sh:Int,level:Int)
		Self.sw = sw
		Self.sh = sh
		currentlevel = level
		setmap1()
		

		For Local i:Int=0 Until 300
			myagent.Push(New kagent(startx*tw,starty*th))
			myagent.Get(i).growgenetic()
		Next
	End Method
	Method update()
		If completed
			For Local i:Int=0 Until myobstacle.Length
				myobstacle.Get(i).update()
			Next
			For Local i:Int=0 Until myagent.Length				
				If myagent.Get(i).winner = True
					myagent.Get(i).updatewinner()					
				End If
			Next
			Return
		End If
		
		
		For Local ii:Int=0 Until 150
		' update the obstacles
		'While completed=False
		For Local i:Int=0 Until myobstacle.Length
			myobstacle.Get(i).update()
		Next

'		' update the agents
		If alldead() = False		
			For Local i:Int=0 Until myagent.Length
				myagent.Get(i).update()
			Next
		Else
			newagents()
			Exit
		End If
		'Wend
		If completed = True Then Exit
		Next
	End Method
	Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
		Return Abs(x2-x1)+Abs(y2-y1)
	End Method
	Method newagents()
		If completed = True Then Return
		'If Rnd()<.05 Then Print Microsecs()
		SeedRnd(Millisecs())
		' find the agent closest to the destination
		Local closest:Int=9999999
		Local dis:Int=99999999
		Local closestid:Int=-1
		For Local i:Int=0 Until myagent.Length
			Local ax:Int=myagent.Get(i).kpx/tw
			Local ay:Int=myagent.Get(i).kpy/th
			If dmap[ax,ay]<closest And dmap[ax,ay]>0'distance(ax,ay,endx,endy)<dis Then
				closest = dmap[ax,ay]
				closestid = i
				'dis = distance(ax,ay,endx,endy)
			End If
		Next

		

		'If dis<5 Then
		'	 Print "made it...."
		'	 myagent.Get(closestid).winner = True			 
		'	 completed=True
		'End If

		' cut off 1 of length
'		For Local i:Int = 0 Until myagent.Length
'			For Local ii:Int=0 To 1
'			myagent.Get(i).genetic.Pop			
'			Next
'		Next
'
		' copy the genetic of the closest into every other
		For Local i:Int=0 Until myagent.Length
			If i <> closestid
				Local ax:Int=myagent.Get(i).kpx/tw
				Local ay:Int=myagent.Get(i).kpy/th				
				'If dmap[ax,ay] <>0 And dmap[ax,ay]+2 < closest Then Continue
				myagent.Get(i).genetic.Clear()
				For Local ii:Int=0 Until myagent.Get(closestid).genetic.Length
					myagent.Get(i).genetic.Push(myagent.Get(closestid).genetic.Get(ii))
				Next
			End If
		Next
		
''		'Mutate some
		Local l:Int=1.0/Float(myagent.Get(0).genetic.Length)
		For Local i:Int=0 Until myagent.Length	
			If i<>closestid 'And Rnd()<.1
			For Local ii:Int=0 Until myagent.Get(i).genetic.Length
				If ii>myagent.Get(i).genetic.Length/3 Or Rnd()<.2
				If Rnd(myagent.Get(i).genetic.Length)<ii/5 Or Rnd()<.1 Then myagent.Get(i).genetic.Set(ii,Rnd(0,9))
				End If
			Next
			End If
		Next		
		'add length of 5
		For Local i:Int=0 Until myagent.Length	
			For Local ii:Int=0 Until 5
				Local nd:Int=Rnd(0,9)
				myagent.Get(i).genetic.Push(nd)
			Next
		Next
		'reset agents
		For Local i:Int=0 Until myagent.Length
			myagent.Get(i).kpx = startx*tw
			myagent.Get(i).kpy = starty*th
			myagent.Get(i).currentpos = 0
			myagent.Get(i).die = False
			myagent.Get(i).time = 0
			'myagent.Get(i).winner = False
		Next		
		setmap1()
	End Method
	Method alldead:Bool()
		For Local i:Int=0 Until myagent.Length
			If myagent.Get(i).die = False Then Return False
		Next
		Return True
	End Method
	Method setmap1()
		myobstacle = New Stack<kobstacle>
		Local l:String[] 
		If currentlevel = 2
			l = New String[10]
			' 0 - floor
			' 1 - wall
			' a - start position
			' z - end position
			' u - move up obstacle
			' d - move down obstacle
			l[0]="11111111111111111111"
			l[1]="1a000011000111111111"
			l[2]="10000011000000d00001"
			l[3]="10000011000000000001"
			l[4]="10000011000110000001"
			l[5]="10000l11r00110000001"
			l[6]="10000011000111111001"
			l[7]="10000011000110d00001"
			l[8]="100u000000011z000001"
			l[9]="11111111111111111111"
		End If

		If currentlevel = 3
			l = New String[10]
			' 0 - floor
			' 1 - wall
			' a - start position
			' z - end position
			' u - move up obstacle
			' d - move down obstacle
			l[0]="00000011111111100000"
			l[1]="000000100a1111100000"
			l[2]="01111110001111111111"
			l[3]="010d0000000000000001"
			l[4]="010000000000u0000001"
			l[5]="01000011111111111111"
			l[6]="01000l100d0001000011"
			l[7]="010000100000000000z1"
			l[8]="0100000000000100u001"
			l[9]="01111111111111111111"
		End If
		If currentlevel = 1
			l = New String[10]
			' 0 - floor
			' 1 - wall
			' a - start position
			' z - end position
			' u - move up obstacle
			' d - move down obstacle
			l[0]="00000011111111000000"
			l[1]="000000101010d1000000"
			l[2]="00000010101001000000"
			l[3]="11111010d0d001011111"
			l[4]="10001110000001110001"
			l[5]="10a000000000000000z1"
			l[6]="10001110000001110001"
			l[7]="11111010101001011111"
			l[8]="0000001u1u1u01000000"
			l[9]="00000011111111000000"
		End If

		map = New Int[l[0].Length,l.GetSize(0)]
		dmap = New Int[l[0].Length,l.GetSize(0)]
		mapw = map.GetSize(0)
		maph = map.GetSize(1)
		tw = Float(sw)/Float(map.GetSize(0))
		th = Float(sh)/Float(map.GetSize(1))
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			Local t:String=l[y].Mid(x,1)
			Select t
				Case "0"
					map[x,y] = 0
				Case "1"
					map[x,y] = 1
				Case "u","d","l","r"
					myobstacle.Push(New kobstacle(x*tw,y*th,tw/2,th/2,t))
				Case "a"
					startx = x
					starty = y
				Case "z"
					endx = x
					endy = y					
			End Select
		Next
		Next
		flooddistance(endx,endy,startx,starty)
	End Method
	Method flooddistance(sx:Int,sy:Int,ex:Int,ey:Int)
		Local dx:Stack<Int> = New Stack<Int>
		Local dy:Stack<Int> = New Stack<Int>
		Local dd:Stack<Int> = New Stack<Int>
		dx.Push(sx)
		dy.Push(sy)
		dmap[sx,sy] = 1
		Local x:Int,y:Int,d:Int
		Local mx:Int[]=New Int[](-1,0,1,0)
		Local my:Int[]=New Int[](0,-1,0,1)
		While dx.Length>0
			x = dx.Get(0)
			y = dy.Get(0)
			dx.Erase(0)
			dy.Erase(0)
			For Local i:Int=0 Until mx.Length
				Local x1:Int=x+mx[i]
				Local y1:Int=y+my[i]
				If x1<0 Or y1<0 Or x1>=mapw Or y1>=maph Then Continue
				If map[x1,y1] = 0 And dmap[x1,y1] = 0
					dx.Push(x1)
					dy.Push(y1)
					dmap[x1,y1] = dmap[x,y]+1
				End If
			Next
		Wend
	End Method
	Method draw(canvas:Canvas)
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			Select map[x,y]
				Case 0
					canvas.Color = Color.DarkGrey
				Case 1
					canvas.Color = Color.Grey
			End Select
			canvas.DrawRect(x*tw,y*th,tw+1,th+1)
		Next
		Next
		' draw the obstacles
		For Local i:Int=0 Until myobstacle.Length
			myobstacle.Get(i).draw(canvas)
		Next
'		' draw the agents
'		If myagent
		For Local i:Int=0 Until myagent.Length
			If completed = False
				myagent.Get(i).draw(canvas)
			Elseif completed = True				
				If myagent.Get(i).winner = True				
					myagent.Get(i).draw(canvas)
					
				End If
			End If
		Next
'		End If
		' Draw the distances
		If Keyboard.KeyDown(Key.Key1)
			canvas.Color=Color.Black
			For Local y:Int=0 Until dmap.GetSize(1)
			For Local x:Int=0 Until dmap.GetSize(0)
				canvas.DrawText(dmap[x,y],x*tw,y*th)
			Next
			Next	
		End If
	End Method
End Class

Global myworld:world

Class MyWindow Extends Window
	Field level:Int=1
	Method New()
		SeedRnd(Microsecs())
		myworld = New world(Width,Height,level)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		myworld.update()
		myworld.draw(canvas)
		
		'If myworld.completed
		If Keyboard.KeyReleased(Key.Space)
			level+=1
			If level>3 Then level=1
			myworld = New world(Width,Height,level)
		End If
		'End If
		
		canvas.Color = Color.Red
		canvas.DrawText("Press space to Train new - (can take a while)",0,0)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
