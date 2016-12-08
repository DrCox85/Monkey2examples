#Rem

Flood Fill Pathfinding

With floodfill pathfinding you fill the map with numbers.
The number starts with 1 at the position where you want The
player or the badguy to move to. You start filling and each Step 
outwards you increase the value on the map with one. Thus creating
a path from outwards to the destination. 
You can move any amount of units using a single flood map towards one
destination. Just keep it moving to the lowest valued surrounding tile.
You could let the ai check if the number is close (<5 or so) and let
him start moving towards the player. If that number gets higher(player runs away)
then he could stop chasing you.
#end


#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class ffpath
	Field map:Int[,] = New Int[1,1]
	Field fmap:Int[,] = New Int[1,1]
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
		fmap = New Int[mw,mh]
		makemap()
	End Method
	Method makemap()
		For Local i:=0 Until mw*mw/25
			Local x:Int=Rnd(-5,mw)
			Local y:Int=Rnd(-5,mh)
			Local w:Int=Rnd(1,6)
			Local h:Int=Rnd(1,6)
			For Local y2:=y To y+h
			For local x2:=x To x+w
				If x2>=0 And x2<mw And y2>=0 And y2<mh
				map[x2,y2] = 1
				End If
			Next
			Next
		Next
		For Local y2:=mh/2-4 To mh/2+4
		For local x2:=mw/2-4 To mw/2+4
			If x2>=0 And x2<mw And y2>=0 And y2<mh
			map[x2,y2] = 0
			End If
		Next
		Next		
	End Method
	Method floodmap(x:Int,y:Int)
		If map[x,y] <> 0 Then return
		fmap = New Int[mw,mh]		
		Local sx:Stack<Int> = New Stack<Int>
		Local sy:Stack<Int> = New Stack<Int>
		Local sd:Stack<Int> = New Stack<Int>
		sx.Push(x)
		sy.Push(y)
		sd.Push(1)
		fmap[x,y] = 1
		Local mx:Int[] = New Int[](0,1,0,-1)
		Local my:Int[] = New Int[](-1,0,1,0)
		While sx.Empty = False
			Local x2:Int=sx.Get(0)
			Local y2:Int=sy.Get(0)
			Local d2:Int=sd.Get(0)
			sx.Erase(0)
			sy.Erase(0)
			sd.Erase(0)
			For Local i:=0 Until 4
				Local x3:Int=x2+mx[i]
				Local y3:Int=y2+my[i]
				If x3>=0 And x3<mw And y3>=0 And y3<mh
				If map[x3,y3] = 0 And fmap[x3,y3] = 0
				fmap[x3,y3] = d2+1
				sx.Push(x3)
				sy.Push(y3)
				sd.Push(d2+1)
				End If
				End If 
			Next
		Wend
	End Method
	Method draw(canvas:Canvas)
		For Local y:float=0 Until mh Step 1
		For Local x:Float=0 Until mw Step 1
			Local t:Int=map[x,y]
			Select t			
			Case 0
			canvas.Color = Color.White
			canvas.DrawText(fmap[x,y],x*tw,y*th)
			Case 1
			Local col:Float=((0.5/32)*y)+0.5
			canvas.Color = New Color(col,col,col)
			canvas.DrawRect(x*tw,y*th,tw,th)
			End Select
			
		Next
		Next

	End Method
End Class

Global mypath:ffpath

Class MyWindow Extends Window	
	Method New()
		SeedRnd(3478)
		Title="Monkey 2 - FloodFill Pathfinding. Move the mouse or tap"
		' create a flood path class with 32x32 size
		mypath = New ffpath(Width,Height,32,32)
		' set destination at center of the map
		mypath.floodmap(16,16)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mypath.draw(canvas)
		' mouse x and y is end position of the flood path
		Local x:Int=Mouse.X/mypath.tw
		Local y:Int=Mouse.Y/mypath.th
		mypath.floodmap(x,y)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
