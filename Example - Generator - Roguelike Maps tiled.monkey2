#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class thetiles
	Field tw:Float,th:Float
	Method New()
		tw = mymap.tw
		th = mymap.th
	End Method
	Method drawtile(canvas:Canvas,t:Int,x:Int,y:Int)
		Select t
			Case 1 ' floor tile
				drawfloor(canvas,x,y)
			Case 2 ' upper wall
				drawupperwall(canvas,x,y)
			Case 3 'left wall
				drawleftwall(canvas,x,y)
			Case 4 'right wall
				drawrightwall(canvas,x,y)
			Case 5 'bottom wall
				drawbottomwall(canvas,x,y)
			Case 6 'left free right free
				drawleftfreerightfreewall(canvas,x,y)
			Case 7 'left top free
				drawlefttopfreewall(canvas,x,y)
			Case 8 'right top free
				drawrighttopfreewall(canvas,x,y)
			Case 9 ' right bottom free
				drawrightbottomfreewall(canvas,x,y)
			Case 10 ' left bottom free
				drawleftbottomfreewall(canvas,x,y)
		End Select 
	End Method
	Method drawleftbottomfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x,y+th-th/3,tw,th/3)		
	End Method
	Method drawrightbottomfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3,th)
		canvas.DrawRect(x,y+th-th/3,tw,th/3)		
	End Method
	Method drawrighttopfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw+1,th/3)			
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3+1,th)				
	End Method

	Method drawlefttopfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw,th/3)			
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3,th)				
	End Method
	Method drawleftfreerightfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3+1,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3+1,th)
	End Method
	Method drawbottomwall(canvas:Canvas,x:Int,y:Int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x,y+th-th/3,tw,th/3+1)
	End Method
	Method drawrightwall(canvas:Canvas,x:Int,y:int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3+1,th)
	End Method
	Method drawleftwall(canvas:Canvas,x:int,y:int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3,th)
	End Method
	Method drawupperwall(canvas:Canvas,x:int,y:int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw,th/3)			
	End Method
	Method drawfloor(canvas:Canvas,x:Int,y:int)
		SeedRnd(1)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x,y,tw,th)
		For Local i:=0 Until 20
			Local x2:Float=Rnd(0,tw)
			Local y2:Float=Rnd(0,th)
			Local d:Float=Rnd(-.4,.1)
			canvas.Color = New Color(.5+d,.5+d,.5+d)
			canvas.DrawPoint(x+x2,y+y2)
		Next
			
	End Method
End Class

Class themap
	Field tw:Float,th:Float 'tile width and height
	Field mw:Int,mh:Int ' map width and height
	Field sw:Int,sh:Int ' screen width and height
	Field map:Int[,]  ' the array that holds the map
	Field tilemap:Int[,]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw) / Float(mw)
		th = Float(sh) / Float(mh)
		' create the monkey array
		map = New Int[mw,mh]
		' create the tilemap
		tilemap = New Int[mw,mh]
		' Here we create a random map
		createmap()
		' Create borders
		createborders()
		' Here we remove islands (unreachable area's)
		fillislands()
		' createtilemap
		createtilemap()
	End Method
	Method createtilemap()
		' tile 1 = floor tile
		' tile 2 = upper wall
		' tile 3 = left wall
		' tile 4 = right wall
		' tile 6 = left free right free
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			' create the ground tile
			'If map[x,y] = 0 Then tilemap[x,y] = 1
			Local s:Int[] = New Int[9]
			If map[x,y] = 0 Then s[0] = 0 Else s[0] = 1
			If y-1 >=0 And map[x,y-1] = 0 Then s[1] = 0 Else s[1] = 1
			If x+1 < mw And map[x+1,y] = 0 Then s[2] = 0 Else s[2] = 1
			If y+1 < mh And map[x,y+1] = 0 Then s[3] = 0 Else s[3] = 1
			If x-1 >= 0 And map[x-1,y] = 0 Then s[4] = 0 Else s[4] = 1
			
			Local ss:String=""
			For Local i:=0 To 4
				ss+=String(s[i])
			Next
			If ss="10000" Then tilemap[x,y] = 1 ' ground tile 
			If ss="10111" Then tilemap[x,y] = 2 ' upper wall
			If ss="11110" Then tilemap[x,y] = 3 ' left wall
			If ss="11011" Then tilemap[x,y] = 4 ' right wall
			If ss="11101" Then tilemap[x,y] = 5 'bottom wall
			If ss="11010" Then tilemap[x,y] = 6 'left free right free
			If ss="10110" Then tilemap[x,y] = 7 ' left and top free
			If ss="10011" then tilemap[x,y] = 8 'right and top free
			If ss="11001" Then tilemap[x,y] = 9 ' right and bottom free
			If ss="11100" Then tilemap[x,y] = 10 ' left and bottom free
			
		Next
		Next
	End Method
	'
	' Here we create the borders of the map
	' the lines top left right and bottom
	'
	Method createborders()
		For Local y:=0 Until mh
			map[0,y] = 1
			map[mw-1,y] = 1
		Next
		For Local x:=0 Until mw
			map[x,0] = 1
			map[x,mh-1] = 1
		Next
	End Method

	'
	' Here we floodfill the map. We flood a open area and if done
	' we check if we can flood another unflooded area. We give
	' this a new value. We count the amount of tiles per island so
	' we can fill the islands with the smallest area's.
	'
	Method fillislands()
		' create out flood map	
		Local fmap:Int[,] = New Int[mw,mh]

		' create the open list
		Local olistx:List<Int> = New List<Int>
		Local olisty:List<Int> = New List<Int>
		Local floodcount:Int=1
		Local floodindex:Int[] = New Int[100]
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x,y] = 0 And fmap[x,y] = 0
				'flood here
				floodcount+=1
				olistx = New List<Int>
				olisty = New List<Int>
				olistx.AddLast(x)
				olisty.AddLast(y)
				fmap[x,y] = floodcount
				Local xs:Int[]= New Int[](-1,0,1,0)
				Local ys:Int[]= New Int[](0,-1,0,1)
				While olistx.Count() > 0
					Local x2:Int=olistx.First
					Local y2:Int=olisty.First
					Local nx:Int
					Local ny:Int
					olistx.RemoveFirst()
					olisty.RemoveFirst()
					For Local i:=0 Until 4						
						nx = x2+xs[i]
						ny = y2+ys[i]
						If nx >=0 And nx<mw And ny>=0 And ny<mh And fmap[nx,ny] = 0 And map[nx,ny] = 0
							olistx.AddLast(nx)
							olisty.AddLast(ny)
							fmap[nx,ny] = floodcount
							floodindex[floodcount] += 1
						End If
					Next
				Wend
			End If
		Next
		Next
		' Here we know how many island there are. We need
		' to fill the smallest islands
		If floodcount <= 2 Then Return  'If only one area then finished
		' Here we find the largest surface and select this to not
		' be filled.
		Local largest:Int=0
		Local donotflood:Int=-1
		For Local i:=0 Until floodcount
			If floodindex[i] > largest Then largest = floodindex[i] ; donotflood=i
		Next
		' Fill every unreachable island
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x,y] = 0 And fmap[x,y] <> donotflood Then map[x,y] = 1
		Next
		Next
	End Method
	' Here we create the map. Solid tiles (walls) are
	' value 1. nothing is value 0.
	' We create with the largest room size and see if it
	' fits on the map. The actual solid area size is 
	' a little bit smaller since we want movement space
	' between the blocks. If we can not fit a area
	' then we decrease the size and then see if it 
	' fits in the map and so on.
	Method createmap()
		Local rw:Int = (mw*mh)/100 ' roomwidth
		Local rh:Int = (mw*mh)/100' roomheight
		' Do not start with rooms to large or to small
		' and keep them somewhat squared in shape.
		If rw > 10 Then rw = 10 ; rh = 10
		If rh > 10 Then rh = 10 ; rw = 10
		If rw < 10 Then rw = 10 ; rh = 10
		If rh < 10 Then rh = 10 ; rw = 10
		Local countdown:Int=mw*mh/20
		Repeat
			Local x:Int=Rnd(0,mw-(rw+1))
			Local y:Int=Rnd(0,mh-(rh+1))
			' does the current block fit in the map?
			If fitshere(x,y,rw,rh)
				' Put it in
				putitin(x,y,rw,rh)
			Else  ' If it does not fit
				countdown-=1 	' give it some time to try other
								' locations
				If countdown <=0 Then  ' when tried enough times
					countdown = mw*mh/20
					rw -= 1 ' decrease the width and height of the rooms
					rh -= 1
				End If
			End If
			If rw <= 4 Or rh <= 4 Then Exit
		Forever
		
		' create vertical lines with corridors
		Local numcors:Int=mw/5
		Local xpos:List<Int> = New List<Int> 'for the vertical walls (location x)
		While numcors > 0			
			Local x:Int=Rnd(3,mw-3)
			Local good:Bool=True
			' make sure we do not place the walls near each other
			For Local i:=Eachin xpos
				If x = i Or x-1 = i Or x+1 = i Then good = False
				If x-2 = i Or x+2 = i Then good = False
			Next
			' if we are not placing the walls near each other
			If good = True
				' make a wall
				For Local y:=0 Until mh
					map[x,y] = 1
					xpos.AddLast(x)
				Next
				'make a couple of corridors in the wall
				For Local i:=0 Until mh/5
					Local cnt:Int=100
					Repeat
						Local y:Int=Rnd(mh-1)
						If map[x-1,y] = 0 And map[x+1,y] = 0
							map[x,y] = 0
							Exit
						End If
						cnt-=1
						If cnt<0 Then Exit
					Forever
				Next
				numcors -= 1
			End If
		Wend
	End Method
	' Here we draw(fill in) the rectangle input into 
	' the map.
	
	Method putitin(x1:Int,y1:Int,w:Int,h:Int)
		For Local y2:=y1+2 Until y1+h-1
		For Local x2:=x1+2 Until x1+w-1
			map[x2,y2] = 1
		Next
		Next
	End Method
	' This takes rectangular area and see's if there is
	' a solid(1) value underneath it. If so it returns
	' a false.
	Method fitshere:Bool(x1:Int,y1:Int,w:Int,h:Int)
		For Local y2:=y1 Until y1+h
		For Local x2:=x1 Until x1+w
			If map[x2,y2] = 1 Then Return False
		Next
		Next
		Return True ' nothing underneath so it fits
	End Method
	' This method simply draws the map to the screen.
	Method draw(canvas:Canvas)
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			If map[x,y] = 1
				canvas.Color = Color.White
				canvas.DrawRect(x*tw,y*th,tw+1,th+1)
			End If
			mytiles.drawtile(canvas,tilemap[x,y],x*tw,y*th)
			'If map[x,y] = 0 Then
			'	mytiles.drawtile(canvas,1,x*tw,y*th)
			'End If
		Next
		Next
	End Method
End Class

Global mymap:themap
Global mytiles:thetiles

Class MyWindow Extends Window
	Field cntdown:Int=5
	Field size:Int=15 ' Contains the size of the map w/h
		
	Method New()
		mymap = New themap(Width,Height,size,size)
		mytiles = New thetiles()
		ClearColor = Color.Black
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		mymap.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
		If Keyboard.KeyReleased(Key.Space) Then 
			size = Rnd(20,60)
			mymap = New themap(Width,Height,size,size)
		End If
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function