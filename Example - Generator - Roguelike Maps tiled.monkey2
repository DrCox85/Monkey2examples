#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class thetiles
	Field tw:Float,th:Float
	Field mw:Int,mh:Int
	Method New()
		tw = mymap.tw+1
		th = mymap.th+1
		mw = mymap.mw
		mh = mymap.mh
	End Method
	Method drawtile(canvas:Canvas,t:Int,x:Int,y:Int)
		Select t
			Case -1 ' floor tile
				drawfloor(canvas,x,y)
			Case 14 ' upper wall
				drawupperwall(canvas,x,y)
			Case 7 'left wall
				drawleftwall(canvas,x,y)
			Case 13 'right wall
				drawrightwall(canvas,x,y)
			Case 11 'bottom wall
				drawbottomwall(canvas,x,y)
			Case 5 'left free right free
				drawleftfreerightfreewall(canvas,x,y)
			Case 6 'left top free
				drawlefttopfreewall(canvas,x,y)
			Case 12 'right top free
				drawrighttopfreewall(canvas,x,y)
			Case 9 ' right bottom free
				drawrightbottomfreewall(canvas,x,y)
			Case 3 ' left bottom free
				drawleftbottomfreewall(canvas,x,y)
			Case 15 ' allaround
				drawallaround(canvas,x,y)
		End Select 
	End Method
	Method drawallaround(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)			
		canvas.Color = New Color(.7,.7,.7,.5)
		canvas.DrawRect(x+tw/3,y,tw/3,th)	
		spikle(canvas,x,y)
	End Method
	Method drawleftbottomfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x,y+th-th/3,tw,th/3)		
		spikle(canvas,x,y)
	End Method
	Method drawrightbottomfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3,th)
		canvas.DrawRect(x,y+th-th/3,tw,th/3)		
		spikle(canvas,x,y)	
	End Method
	Method drawrighttopfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw+1,th/3)			
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3,th)				
		spikle(canvas,x,y)		
	End Method

	Method drawlefttopfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw,th/3)			
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3,th)				
		spikle(canvas,x,y)	
	End Method
	Method drawleftfreerightfreewall(canvas:Canvas,x:Int,y:Int)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3+1,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3,th)
		spikle(canvas,x,y)
	End Method
	Method drawbottomwall(canvas:Canvas,x:Int,y:Int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x,y+th-th/3,tw,th/3)
		spikle(canvas,x,y)		
	End Method
	Method drawrightwall(canvas:Canvas,x:Int,y:int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.DarkGrey
		canvas.DrawRect(x+tw-tw/3,y,tw/3,th)
		spikle(canvas,x,y)
	End Method
	Method drawleftwall(canvas:Canvas,x:Int,y:int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw/3,th)
		spikle(canvas,x,y)
	End Method
	Method drawupperwall(canvas:Canvas,x:int,y:int)
		SeedRnd(1)
		canvas.Color = Color.Grey
		canvas.DrawRect(x,y,tw,th)
		canvas.Color = Color.LightGrey
		canvas.DrawRect(x,y,tw,th/3)
		spikle(canvas,x,y)			
	End Method
	Method drawfloor(canvas:Canvas,x:Int,y:int)
		SeedRnd(1)
		canvas.Color = New Color(0.4,.4,.3)
		canvas.DrawRect(x,y,tw,th)
		For Local i:=0 Until 10
			Local x2:Float=Rnd(0,tw)
			Local y2:Float=Rnd(0,th)
			Local d:Float=Rnd(-.2,.1)
			canvas.Color = New Color(.5+d,.5+d,.2+d,Rnd(0.1,0.7))
			canvas.DrawPoint(x+x2,y+y2)
		Next
		spikle(canvas,x,y)			
	End Method
	Method spikle(canvas:Canvas,x:int,y:int)
		SeedRnd(x*y)
		Local a:Int=Rnd(th*th/50,tw*th/20)
		For Local i:=0 Until a
			Local x2:Float=Rnd(0,tw-3)
			Local y2:Float=Rnd(0,th-3)
			Local d:Float=Rnd(-.4,0)
			canvas.Color = New Color(.5+d,.5+d,.5+d,Rnd(0,.25))
			canvas.DrawRect(x+x2,y+y2,3,3)
			canvas.Color = New Color(.7,.7,.7,Rnd(0,.45))
			canvas.DrawRect(x+x2-1,y+y2,2,1)
			canvas.Color = New Color(.2,.2,.2,Rnd(0,.45))
			canvas.DrawRect(x+x2+1,y+y2+2,2,1)

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
		' Here we read around a wall tile and then
		' we use a formula to turn it into a number
		' and put this into the tilemap.
		' The formula is.
		'
		' x1x
		' 8x2
		' x4x
		'
		' We add up the numbers if their position is
		' a wall. Aboveleftrightbottom
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			' create the ground tile
			If map[x,y] = 0 Then tilemap[x,y] = -1

			Local s:Int=0
			If y-1 >=0 And map[x,y-1] = 0 Then s = 0 Else s = 1
			If x+1 < mw And map[x+1,y] = 0 Then s += 0 Else s += 2
			If y+1 < mh And map[x,y+1] = 0 Then s += 0 Else s += 4
			If x-1 >= 0 And map[x-1,y] = 0 Then s += 0 Else s += 8

			If map[x,y] = 0 Then Continue
			tilemap[x,y] = s
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
		SeedRnd(Millisecs())
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
		Local cnt2:Int=200
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
			cnt2-=1
			If cnt2 < 0 Then Exit
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
		canvas.Clear(Color.Black)
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
	Field ms:Int=Millisecs()+3000
	Field size:Int=15 ' Contains the size of the map w/h
		
	Method New()
		mymap = New themap(Width,Height,size,size)
		mytiles = New thetiles()
		ClearColor = Color.Black
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(Color.Black)		
		mymap.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
		If Keyboard.KeyReleased(Key.Space)  Or Millisecs()>ms
			ms = Millisecs()+3000
			SeedRnd(Millisecs())
			size = Rnd(14,50)
			mymap = New themap(Width,Height,size,size)
			mytiles = New thetiles()
 		End If
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
