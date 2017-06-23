#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

'Texture quality
Global texturequality:String="Low" 'High , Medium and Low
' Here is how many tiles there are drawn on the screen.
' Currently tested from 16x16 up to 32x32
Global mystartmapwidth:Int=20
Global mystartmapheight:Int=20

Global blinkspeed:Int=5 ' lower is faster
Global turn:Int=1
Global activeunitmovesleft:Float=1
Global gamehasmovesleft:Bool=True
Global cityscreenopen:Bool=False
Global currentcityx:Int
Global currentcityy:Int
Global currentcityfarms:Int
Global currentcitymines:Int
Global currentcitybarracks:Bool
Global currentcitywalls:Bool
Global currentcitysize:Int
Global currentcityname:String
Global currentcityfood:Int
Global currentcityresources:Int
Global currentcityproduction:String
Global currentcityproductiontime:Int
Global currentcityharbor:Bool=False
Global currentcitycoastal:Bool=False
'This variable is increased in the main loop
'if a key is pressed and this value is >  0 then this 
'variable is set to 0 again.
Global keydelay:Int=0
Global mousedelay:Int=0

Class gamemessage	
	'This class contains the messages
	Class message
		Field tekst:String
		Method New(tekst:String)
			Self.tekst = tekst
		End Method
	End Class
	'store the messages in a stack
	Field mymessage:Stack<message>
	Field Width:Int,Height:Int
	Field time:Int 'count up to timeover means new message
	Field timeover:Int=60'message dissapear time
	Field currentmessage:String 'this contains the current message
	Method New(Width:Int,Height:Int)
		Self.Width = Width
		Self.Height = Height
		'create a message stack
		mymessage = New Stack<message>
	End Method
	'Here we add a message to the system
	Method pushmessage(tekst:String)
		mymessage.Push(New message(tekst))
'		time=timeover-5
	End Method
	'this method updates the messages
	'removing old messages
	Method update()
		If mymessage.Length > 5 Then timeover = 20 Else timeover = 60
		If mymessage.Length > 20 Then timeover = 5 
		time+=1
		If time > timeover
			time = 0
			currentmessage = ""
			If mymessage.Length
			currentmessage = mymessage.Top.tekst
			mymessage.Pop()
			End If
		End If
	End Method
	'Draw the messages to the canvas
	Method drawmessage(canvas:Canvas)
		If currentmessage = "" Then Return		
		Local mx:Float=Width/2-200
		Local my:Float=10		
		canvas.PushMatrix()
		canvas.Scale(1.2,1.2)
		canvas.Color = Color.White
		canvas.DrawRect(mx/1.2-2,my/1.2-2,400+4,20+4)
		canvas.Color = Color.Grey
		canvas.DrawRect(mx/1.2,my/1.2,400,20)
		canvas.Color = Color.White
		canvas.DrawText(currentmessage,(Width/2)/1.2,my/1.2+2,.5,0)
		canvas.PopMatrix()
		
	End Method
End Class

Class greybackground
	Field greyimage:Image
	Field greycanvas:Canvas
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field mapdepth:Int
    'Field mapr:Int[][]
    'Field mapg:Int[][]
    'Field mapb:Int[][]    
    Field mapr:Int[,]
    Field mapg:Int[,]
    Field mapb:Int[,]
    Method New(Width:float,Height:float,mapwidth:Float,mapheight:Float)	    
		greyimage = New Image(Width,Height)		
		greycanvas = New Canvas(greyimage)	    		
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = Width/Float(mapwidth)
        tileheight = Height/Float(mapheight)
        mapr = New Int[mapwidth,mapheight]
        mapg = New Int[mapwidth,mapheight]
        mapb = New Int[mapwidth,mapheight]        
        'mapr = New Int[mapwidth][]
        'mapg = New Int[mapwidth][]
        'mapb = New Int[mapwidth][]                
        'For Local i:= 0 Until mapwidth
        '    mapr[i] = New Int[mapheight]
	'		mapg[i] = New Int[mapheight]            
	'		mapb[i] = New Int[mapheight]
     '   Next 
     
        addrectslayer()
        brusheffect2()
        smooth()
        createimage(greycanvas)        
    End Method
    Method brusheffect2()
    	For Local i:=0 Until (mapwidth*mapheight)
    		Local x1:Float=Rnd(0,mapwidth)
    		Local y1:Float=Rnd(0,mapheight)
    		Local angle:Int=Rnd(-180,180)
    		Local dist:Int=Rnd(3,5)
    		For Local iii:=0 Until 20
    		For Local ii:=0 Until dist
    			Local x4:Float=x1+Rnd(-5,5)
    			Local y4:Float=y1+Rnd(-5,5)
    			Local x2:Float=x4+Cos(angle)*1
    			Local y2:Float=y4+Sin(angle)*1
    			Local x3:Float=x4+Cos(angle)*2
    			Local y3:Float=y4+Sin(angle)*2
    			If x2>-1 And y2>-1 And x2<mapwidth And y2<mapheight
    			If x3>-1 And y3>-1 And x3<mapwidth And y3<mapheight
    				mapr[x3,y3] = mapr[x2,y2]
    				mapg[x3,y3] = mapg[x2,y2]
    				mapb[x3,y3] = mapb[x2,y2]
    			End If
    			End If    			
			Next
			Next
    	Next
    End Method
    Method smooth()
    	For Local i:=0 Until (mapwidth*mapheight)
    		Local x:Int=Rnd(0,mapwidth-1)
    		Local y:Int=Rnd(0,mapheight-1)
    		Local col1r:Int=mapr[x+1,y]
    		Local col1g:Int=mapg[x+1,y]
    		Local col1b:Int=mapb[x+1,y]    		    		
    		
    		Local col2r:Int=mapr[x+1,y+1]
	   		Local col2g:Int=mapg[x+1,y+1]    		
    		Local col2b:Int=mapb[x+1,y+1]
    		
    		Local col3r:Int=mapr[x,y+1]    		    		
    		Local col3g:Int=mapg[x,y+1]    		    		
    		Local col3b:Int=mapb[x,y+1]    		    		

    		Local col4r:Int=(col1r+col2r+col3r)/3
    		Local col4g:Int=(col1g+col2g+col3g)/3
    		Local col4b:Int=(col1b+col2b+col3b)/3    		    		
    		mapr[x,y] = col4r
    		mapg[x,y] = col4g
    		mapb[x,y] = col4b
    	Next
    End Method
    Method addrectslayer()
    	For Local i:=0 Until (mapwidth*mapheight)
    		Local w:Int=Rnd(3,15)
    		Local h:Int=Rnd(3,15)
    		Local x:Int=Rnd(-3,mapwidth)
    		Local y:Int=Rnd(-3,mapheight)
    		Local colm:Int=Rnd(50)
    		Local colr:Int=205+colm
    		Local colg:Int=205+colm
    		Local colb:Int=205+colm
    		mapdrawrect(x,y,w,h,colr,colg,colb)
    	Next
    End Method
    Method mapdrawrect(x:Int,y:Int,w:Int,h:Int,colr:Int,colg:Int,colb:Int)
    	For Local y1:=y Until y+h
    	For Local x1:=x Until x+w
    		If x1>-1 And y1>-1 And x1<mapwidth And y1<mapheight
    			mapr[x1,y1] = colr
    			mapg[x1,y1] = colg
    			mapb[x1,y1] = colb
    		End If
    	Next
    	Next
    End Method
    Method draw(canvas:Canvas,x:Int=0,y:Int=0)
		canvas.DrawImage(greyimage,0,0)
	End Method
    Method createimage(canvas:Canvas)
        For Local y:=0 Until mapheight
        For Local x:=0 Until mapwidth
			Local colr:Float=mapr[x,y]
			Local colg:Float=mapg[x,y]
			Local colb:Float=mapb[x,y]
			canvas.Color = New Color(colr/255,colg/255,colb/255)
			canvas.DrawRect(x*tilewidth,y*tileheight,tilewidth+1,tileheight+1)
        Next
        Next    
        canvas.Flush()
    End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method    
End Class


Class unituserinterface
	Field Width:Int,Height:Int
	Field arrowimage:Image
	Field arrowcanvas:Canvas
	Field ix:Int,iy:Int
	Field undockx:Int,undocky:Int
	Field undockw:Int,undockh:Int
	Field dockx:Int,docky:Int
	Field dockw:Int,dockh:Int

	Field docked:Bool=false	
	Method New(Width:Int,Height:Int)
		Self.Width = Width
		Self.Height = Height
		dockside("Left")
		arrowimage = New Image(Width/10,Height/10)
		arrowcanvas = New Canvas(arrowimage)
		arrowimage.Handle = New Vec2f( .5,.5 )
		makearrow(arrowcanvas)
	End Method
	Method update()	
		' the dock undock buttons controls
		Local mx:Int,my:Int
		
		If docked = False
			If Mouse.ButtonReleased(MouseButton.Left) Or Touch.FingerReleased(0)			

			If Mouse.ButtonReleased(MouseButton.Left)
				mx = Mouse.X
				my = Mouse.Y
			End If
			If Touch.FingerReleased(0)
				mx = Touch.FingerX(0)
				my = Touch.FingerY(0)
			End If
			
			If rectsoverlap(mx,my,1,1,dockx,docky,dockw,dockh)
				docked = True
				mousedelay = 0
				Return
			End If
			End If
		End If		
		If docked = True
			If Mouse.ButtonReleased(MouseButton.Left) Or Touch.FingerReleased(0)

			If Mouse.ButtonReleased(MouseButton.Left)
				mx = Mouse.X
				my = Mouse.Y
			End If
			If Touch.FingerReleased(0)
				mx = Touch.FingerX(0)
				my = Touch.FingerY(0)
			End If
				
			If rectsoverlap(mx,my,1,1,undockx,undocky,undockw,undockh)
				docked = False
				mousedelay = 0
				Return
			End If
			End If
		End If		

		'unit movement controls (the arrows)
		If docked = False
		If Mouse.ButtonReleased(MouseButton.Left)
			Local x:Int=ix-Width/20
			Local y:Int=iy-Height/20
			Local dx:Int,dy:Int
			'find current active unit x and y position
			For Local i:=Eachin myunit
				If i.active = True
					dx=i.x
					dy=i.y
					Exit
				End If
			Next
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x,y,Width/10,Height/10)
				'Print "Up"+Millisecs()
				myunitmethod.moveactiveunitto(dx,dy-1)
				redrawgame()
				mousedelay = 0
			End If
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x,y+100,Width/10,Height/10)
				'Print "Down"+Millisecs()
				myunitmethod.moveactiveunitto(dx,dy+1)
				redrawgame()
				mousedelay = 0
			End If
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x-50,y+50,Width/10,Height/10)
				'Print "Left"+Millisecs()
				myunitmethod.moveactiveunitto(dx-1,dy)
				redrawgame()
				mousedelay = 0
			End If
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+50,y+50,Width/10,Height/10)
				'Print "Right"+Millisecs()
				myunitmethod.moveactiveunitto(dx+1,dy)
				redrawgame()
				mousedelay = 0
			End If

			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x-45,y,Width/10,Height/10)
				'Print "LeftUp"+Millisecs()
				myunitmethod.moveactiveunitto(dx-1,dy-1)
				redrawgame()
				mousedelay = 0
			End If
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x-45,y+100,Width/10,Height/10)
				'Print "LeftDown"+Millisecs()
				myunitmethod.moveactiveunitto(dx-1,dy+1)
				redrawgame()
				mousedelay = 0
			End If
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+45,y,Width/10,Height/10)
				'Print "RightUp"+Millisecs()
				myunitmethod.moveactiveunitto(dx+1,dy-1)
				redrawgame()
				mousedelay = 0
			End If
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+45,y+100,Width/10,Height/10)
				'Print "RightDown"+Millisecs()
				myunitmethod.moveactiveunitto(dx+1,dy+1)
				redrawgame()
				mousedelay = 0
			End If			
		End If 'end if rectsoverlap
		End If 'docked = false

		If docked = False
			' The unit commands. Taken directly from the controls class
			' update there means update here (lazy)
			If Mouse.ButtonReleased(MouseButton.Left)
				Local x:Int=ix
				Local y:Int=iy
				'drawunitbutton(canvas,x+100,y,"R")
				'drawunitbutton(canvas,x+100,y+32,"B")
				'drawunitbutton(canvas,x+100,y+64,"F")
				'drawunitbutton(canvas,x+100,y+96,"S")
				'drawunitbutton(canvas,x-16,y+34,"E")
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+100,y,32,32)
					'Print "Build Road"
					If myunitmethod.activeunitissetler() = False Then Return
					myunitmethod.buildroadatactiveunitpos()
					myworld.updatedrawroads(myworld.roadcanvas)	
					myunitmethod.activateamovableunit()					
					mousedelay = 0
				End If
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+100,y+32,32,32)
					'Print "Build City"
					If myunitmethod.activeunitissetler() = False Then Return
					If myunitmethod.iscityatactiveunitpos() = True Then Return
					myunitmethod.buildroadatactiveunitpos(False)
					Local x:Int,y:Int
					'get the active unit x and y coordinates
					For Local i:=Eachin myunit
						If i.active = True
							x = i.x
							y = i.y
							i.deleteme = True
							Exit
						End If
					Next					
					mycity.Add(New city(x,y))
					myworld.updatedrawroads(myworld.roadcanvas)					
					myunitmethod.activateamovableunit()
					mousedelay = 0
				End If
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+100,y+64,32,32)
					'Print "Fortify"
					myunitmethod.unitactivefortify()
					myunitmethod.activateamovableunit()					
					mousedelay = 0
				End If
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,x+100,y+96,32,32)
					'Print "Skip turn"
					myunitmethod.activeunitskipturn()
					myunitmethod.activateamovableunit()
					mousedelay = 0
				End If
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,x-16,y+34,32,32)
					'Print "End Turn"

					'Update the buildlist of each city
					For Local i:=Eachin mycity
						i.turnend()
					Next
					'restore the moves of each unit					
					For Local i:=Eachin myunit
						i.movesleft = i.originalmoves
						i.active = False				
					Next
					' set the game movement tip 
					gamehasmovesleft = True
					'increase turn
					turn+=1
					' find a moveable unit
					myunitmethod.activateamovableunit()					
					' set mouse delay so as not to double feaure click
					mousedelay = 0
				End If
			End If
		End If 'end if docked is false
	End Method
	Method dockside(side:String)
		Select side
			Case "Right"
				ix = Width-150
				iy = Height-200
				undockx = ix + 100
				undocky = iy + 160
				undockw = 32
				undockh = 20
				dockx = ix + 100
				docky = iy - 32
				dockw = 32
				dockh = 20
			Case "Left"
				ix = 150
				iy = Height-200
				undockx = ix - 140
				undocky = iy + 160
				undockw = 32
				undockh = 20
				dockx = ix - 140
				docky = iy - 32
				dockw = 32
				dockh = 20
				
		End Select
	End Method
	Method draw(canvas:Canvas)

		If docked = False Then				
			Local x:Int=ix
			Local y:Int=iy
			
			'draw the unit commands buttons.
			drawunitbutton(canvas,x+100,y,"R")
			drawunitbutton(canvas,x+100,y+32,"B")
			drawunitbutton(canvas,x+100,y+64,"F")
			drawunitbutton(canvas,x+100,y+96,"S")
			drawunitbutton(canvas,x-16,y+34,"E")
			
			'draw the arrows
			
			drawarrow(canvas,x,y,"Up")
			drawarrow(canvas,x-50,y+50,"Left")
			drawarrow(canvas,x+50,y+50,"Right")
			drawarrow(canvas,x,y+100,"Down")
	
			drawarrow(canvas,x-35,y,"LeftUp")
			drawarrow(canvas,x-35,y+100,"LeftDown")
			drawarrow(canvas,x+35,y,"RightUp")
			drawarrow(canvas,x+35,y+100,"RightDown")
	
			drawarrow2(canvas,x,y,"Up")
			drawarrow2(canvas,x-50,y+50,"Left")
			drawarrow2(canvas,x+50,y+50,"Right")
			drawarrow2(canvas,x,y+100,"Down")
	
			drawarrow2(canvas,x-45,y,"LeftUp")
			drawarrow2(canvas,x-45,y+100,"LeftDown")
			drawarrow2(canvas,x+45,y,"RightUp")
			drawarrow2(canvas,x+45,y+100,"RightDown")
			
			'draw the dock
			canvas.Color = Color.White
			canvas.DrawRect(dockx,docky,dockw,dockh)
			canvas.Color = Color.Black
			canvas.DrawLine(dockx,docky,dockx+dockw/2,docky+dockh)
			canvas.DrawLine(dockx+dockw,docky,dockx+dockw/2,docky+dockh)
		End If
		
		' if we are docked
		If docked = True			
			'draw the dock
			canvas.Color = Color.White
			canvas.DrawRect(undockx,undocky,undockw,undockh)
			canvas.Color = Color.Black
			canvas.DrawLine(undockx,undocky+undockh/2,undockx+undockw/2,undocky)
			canvas.DrawLine(undockx+undockw,undocky+undockh/2,undockx+undockw/2,undocky)
		End If			
	End Method
	Method drawunitbutton(canvas:Canvas,x:Int,y:Int,t:String)
		canvas.Color = Color.Red
		canvas.DrawRect(x,y,32,32)
		canvas.Color = Color.Black
		canvas.DrawRect(x+2,y+2,32-4,32-4)		
		canvas.Color = Color.White
		canvas.DrawText(t,x+16,y+16,.5,.5)
		
	End Method
	Method drawarrow(canvas:Canvas,x:Int,y:Int,d:String)
		Local rotation:Float=0
		Select d
			Case "RightUp"
				rotation=-Pi/1.4
			Case "RightDown"
				rotation=Pi/1.4
			Case "LeftDown"
				rotation=Pi/3.3
			Case "LeftUp"
				rotation=-Pi/3.3
			Case "Up"
				rotation=-Pi/2
			Case "Down"
				rotation=Pi/2
			Case "Left"
				rotation=0
			Case "Right"
				rotation=-Pi
		End Select				
		canvas.Color = Color.White
		canvas.DrawCircle(x,y,Width/20)
		canvas.DrawImage(arrowimage,x,y,rotation)
	end Method
	Method drawarrow2(canvas:Canvas,x:Int,y:Int,d:String)
		Local rotation:Float=0
		Select d
			Case "RightUp"
				rotation=-Pi/1.4
			Case "RightDown"
				rotation=Pi/1.4
			Case "LeftDown"
				rotation=Pi/3.3
			Case "LeftUp"
				rotation=-Pi/3.3
			Case "Up"
				rotation=-Pi/2
			Case "Down"
				rotation=Pi/2
			Case "Left"
				rotation=0
			Case "Right"
				rotation=-Pi
		End Select				
		canvas.Color = Color.Red
		canvas.DrawImage(arrowimage,x,y,rotation)
	end Method

	Method makearrow(canvas:Canvas)
		canvas.Clear(New Color(0,0,0,0))
		Local pol:= New Float[14]
		Local w:Float = Width/10
		Local h:Float = Height/10
		pol[0] = 0
		pol[1] = h/2		
		pol[2] = w/3
		pol[3] = h		
		pol[4] = w/3
		pol[5] = h/1.5		
		pol[6] = w
		pol[7] = h/1.5		
		pol[8] = w
		pol[9] = h/3		
		pol[10] = w/3
		pol[11] = 0+h/3		
		pol[12] = w/3
		pol[13] = 0
		canvas.Color = Color.Grey
		canvas.DrawPoly(pol)
		canvas.Flush()
	End Method
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	 Function

End Class

Class citycontrols
		'Here we update the production window
		Method productionupdate()
			If mousedelay < 20 Then Return
			' if opressed left mouse in production box
			If Mouse.ButtonReleased(MouseButton.Left) = True
				If mycityscreen.unitprodscreen = False
					Local x1:Int=mycityscreen.prodx
					Local y1:Int=mycityscreen.prody
					Local w1:Int=mycityscreen.prodw
					Local h1:Int=mycityscreen.prodh
					If rectsoverlap(Mouse.X,Mouse.Y,1,1,x1,y1,w1,h1)
						'if pressed on unit production info box
						mycityscreen.unitprodscreen = True
						mousedelay=0
					End If
				End If				
			End If
			'if right mouse on production box then erase production
			If Mouse.ButtonReleased(MouseButton.Right) = True
				If mycityscreen.unitprodscreen = False
					Local x1:Int=mycityscreen.prodx
					Local y1:Int=mycityscreen.prody
					Local w1:Int=mycityscreen.prodw
					Local h1:Int=mycityscreen.prodh
					If rectsoverlap(Mouse.X,Mouse.Y,1,1,x1,y1,w1,h1)
						'erase city production list
						For Local i:=Eachin mycity
							If i.x = currentcityx And i.y=currentcityy
								i.myproduction = New Stack<city.production>
								mycityscreen.updateproduction()
								mousedelay=0
							End If
						Next
					End If
				End If								
			End If
			
			If Mouse.ButtonReleased(MouseButton.Left) = True
				If mycityscreen.unitprodscreen = True 'if unitprodscreen = true		draw unit production screen		
				Local x1:Int=mycityscreen.prodsx
				Local y1:Int=mycityscreen.prodsy
				Local w1:Int=mycityscreen.prodsw
				Local h1:Int=mycityscreen.prodsh
					If rectsoverlap(Mouse.X,Mouse.Y,1,1,x1,y1,w1,h1)
						'If pressed inside new production list
						If mycityscreen.mybuildlist.Length
							Local myselt:Bool=False
							Local myseltname:String=""
							Local y:Int=20
							For Local i:=Eachin mycityscreen.mybuildlist
								If rectsoverlap(Mouse.X,Mouse.Y,1,1,x1,y1+y,w1,20)
									'Print i.name - here we have selected a production
									myselt = True
									myseltname = i.name
								End If
								y+=20
							Next
							If myselt = True 'if we have selected a unit to be build
								mousedelay=0
								mycityscreen.myproduction.Push(New cityscreen.production(myseltname,4))						
								For Local i:=Eachin mycity
									If i.x = currentcityx And i.y = currentcityy
										i.myproduction.Push(New city.production(myseltname))									
									End If
								Next
								mycityscreen.unitprodscreen = False
							End If
							
						End If
						
					End If								
				End If				
			End If
		End Method
		'Here we select a unit from the garrison
		Method garrisonupdate()			
			If mousedelay<20 Then Return			
			If Mouse.ButtonReleased(MouseButton.Left)													
			Local garx:Int=mycityscreen.garx
			Local gary:Int=mycityscreen.gary
			Local garw:Int=mycityscreen.garw
			Local garh:Int=mycityscreen.garh
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,garx,gary,garw,garh)
				If mycityscreen.mygarrison
				Local y:Int=20
				For Local i:=Eachin mycityscreen.mygarrison
					If rectsoverlap(Mouse.X,Mouse.Y,1,1,garx,gary+y,garw,20)
						'Here we have selected a unit from the garrison
						i.fortify = False
						myunitmethod.unitfortify(i.id,False)
						If i.movesleft > 0.3							
							cityscreenopen = False
							keydelay = 0
							mousedelay = 0
							myunitmethod.activateamovableunit()
							mousedelay=0
							Return				
						End If
					End If
					y+=20
				Next
				End If
			End If
			End If
		End Method
		'Here we exit the city screen
		Method controls()
			productionupdate()
			If mycityscreen.unitprodscreen = False Then				
				garrisonupdate()
			End If
			'if press on bottom screen in cityscreen window then exit back to game
			If Mouse.ButtonReleased(MouseButton.Left)
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,150,mycityscreen.Height-32,mycityscreen.Width-300,32)
				mycityscreen.unitprodscreen = False
				cityscreenopen = False
				keydelay = 0
				mousedelay = 0
			End If
			End If
			' if press esacpe or space then exit city screen
			If Keyboard.KeyReleased(Key.Escape) Or Keyboard.KeyReleased(Key.Space)
				mycityscreen.unitprodscreen = False
				cityscreenopen = False
				keydelay = 0
				mousedelay = 0
			End If
	End Method
	
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	 Function
		
End Class

Class cityscreen
	
	Class garrison
		Field name:String
		Field fortify:Bool
		Field movesleft:Float
		Field id:Int
		Method New(id:Int,name:String)
			Self.id = id			
			Self.name = name
			movesleft = myunitmethod.unitmovesleft(id)
			fortify = myunitmethod.unitisfortified(id)
		End Method
	End Class	
	Field mygarrison:Stack<garrison>
	' What is the city building
	Class production
		Field name:String="Settler"
		Field turns:Int=4		
		Method New(name:String,turns:Int)
			Self.name=name
			Self.turns = turns
		End Method
	End Class
	Field myproduction:Stack<production>
	'What can the city produce
	Class buildlist
		Field name:String
		Method New(name:String)
			Self.name = name
		End Method
	End Class
	Field mybuildlist:Stack<buildlist>

	Field Width:Int,Height:Int
	'the variables for the map of the city
	Field tw:Float
	Field th:Float
	Field citymapx:Int,citymapy:Int
	Field citymapw:Int,citymaph:Int
	'variables for the production info
	Field prodx:Int
	Field prody:Int
	Field prodw:Int
	Field prodh:Int
	Field unitprodscreen:Bool=False
	Field prodsx:Int,prodsy:Int,prodsw:int,prodsh:Int
	'variables for the units garrision
	Field garx:Int,gary:Int,garw:Int,garh:Int
	'variables for the city info
	Field cityix:Int,cityiy:int,cityiw:int,cityih:Int
	Method New(Width:Int,Height:Int)
		Self.Width = Width
		Self.Height = Height
		tw = myworld.tw
		th = myworld.th
		' fill the city map variables
		citymapw = tw*5
		citymaph = th*5
		citymapx = Width/2-citymapw/2
		citymapy = Height/2-citymaph/2
		' fill the city production info variables
		prodx = Width/1.5
		prody = Height/1.5
		prodw = Width/3.3
		prodh = Height/3.3
		prodsw = 150
		prodsh = 200
		prodsx = Width/2-prodsw/2
		prodsy = Height/2-prodsh/2
		updatecitybuildlist()		
		myproduction = New Stack<production>		
		'fill the city garrison info variables
		garx = 10
		gary = 10
		garw = 100
		garh = 100
		' fill the city info variables
		cityix = 10
		cityiy = Height/2
		cityiw = 220
		cityih = 200
	End Method
	Method updatecitybuildlist()		
		mybuildlist = New Stack<buildlist>
		If currentcitycoastal And currentcitysize > 1 Then mybuildlist.Push(New buildlist("Sea Unit"))
		If currentcitysize > 1 Then mybuildlist.Push(New buildlist("Settlers"))
		If currentcitywalls = False Then mybuildlist.Push(New buildlist("City Walls"))
		If currentcitymines < 22 Then mybuildlist.Push(New buildlist("Mine"))
		If currentcityfarms < 22 Then mybuildlist.Push(New buildlist("Farm"))
		If currentcitybarracks = False Then mybuildlist.Push(New buildlist("Barracks"))
		If currentcitysize < 22 Then mybuildlist.Push(New buildlist("Expand City"))		
	End Method
	Method draw(canvas:Canvas)				
		canvas.Color = Color.Black
		canvas.DrawRect(0,0,Width,Height)
		canvas.Color = Color.White
		canvas.Color = New Color(.7,.7,1)
		canvas.DrawImage(mygreybackground.greyimage,0,0)
		canvas.Color = Color.White
		drawcitymap(canvas)		
		drawproduction(canvas)
		drawgarrison(canvas)
		drawcityinfo(canvas)
		canvas.Color = Color.White
		canvas.DrawText("Press Space to Exit",Width/2,Height-20,.5,.5)
	End Method
	Method updateproduction()		
		myproduction = New Stack<production>
		For Local i:=Eachin mycity
			If i.x = currentcityx And i.y = currentcityy
				If i.myproduction.Length
					For Local i2:= Eachin i.myproduction
						myproduction.Push(New production(i2.name,i2.turns))						
					Next
				End If
			End If
		Next		
	End Method
	Method updategarrison()
		mygarrison = New Stack<garrison>
		For Local i:=Eachin myunit
			If i.x = currentcityx And i.y = currentcityy
				mygarrison.Push(New garrison(i.id,i.name))
			End If
		Next
	End Method
	Method drawcityinfo(canvas:Canvas)
		' Draw the textured window
		Local rec := New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec
		canvas.Color = Color.White
		canvas.DrawRect(cityix-2,cityiy-2,cityiw+4,cityih+4)
		rec = New Recti<Int>
		rec.X = cityix
		rec.Y = cityiy
		rec.Size = New Vec2i(cityiw,cityih)
		canvas.Scissor = rec
		canvas.Color = New Color(.5,.5,.5)
		canvas.DrawImage(mygreybackground.greyimage,0,0)
		rec = New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec
		' fill with text
		canvas.Color = Color.White
		' Table with text
		canvas.DrawText("Size:",cityix+10,cityiy+20*1)
		canvas.DrawText("Farms:",cityix+10,cityiy+20*2)
		canvas.DrawText("Food:",cityix+10,cityiy+20*3)
		canvas.DrawText("Mines:",cityix+10,cityiy+20*4)
		canvas.DrawText("Resources:",cityix+10,cityiy+20*5)
		canvas.DrawText("Barracks:",cityix+10,cityiy+20*6)
		canvas.DrawText("Walls:",cityix+10,cityiy+20*7)

		' Table with numbers
		Local foo:Int
		foo = currentcityfarms-currentcitysize
		Local min:Int = currentcitymines - currentcitysize
		If currentcitybarracks =True Then min-=1
		If currentcitywalls=True Then min-=1
		canvas.DrawText(currentcitysize,cityix+100,cityiy+20*1)
		canvas.DrawText(currentcityfarms,cityix+100,cityiy+20*2)
		canvas.DrawText(currentcityfood,cityix+100,cityiy+20*3)
		canvas.DrawText(currentcitymines,cityix+100,cityiy+20*4)
		canvas.DrawText(currentcityresources,cityix+100,cityiy+20*5)
		Local s:String
		If currentcitybarracks = True Then s = "Yes" else s="No"
		canvas.DrawText(s,cityix+100,cityiy+20*6)
		If currentcitywalls = True Then s = "Yes" else s="No"
		canvas.DrawText(s,cityix+100,cityiy+20*7)
		' The numbers behind the food and resources info labels
		If foo>= 0 Then 
		canvas.Color=Color.Green 
		canvas.DrawText("+"+foo,cityix+130,cityiy+20*3)
		Else 
		canvas.Color = Color.Red
		canvas.DrawText(foo,cityix+130,cityiy+20*3)
		End If
		If min>= 0 Then 
		canvas.Color=Color.Green 
		canvas.DrawText("+"+min,cityix+130,cityiy+20*5)
		Else 
		canvas.Color = Color.Red
		canvas.DrawText(min,cityix+130,cityiy+20*5)
		End If
	End Method
	Method drawgarrison(canvas:Canvas)
		Local rec := New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec

		canvas.Color = Color.White
		canvas.DrawRect(garx-2,gary-2,garw+4,garh+4)

		rec = New Recti<Int>
		rec.X = garx
		rec.Y = gary
		rec.Size = New Vec2i(garw,garh)
		canvas.Scissor = rec
		canvas.Color = New Color(.5,.5,.5)
		canvas.DrawImage(mygreybackground.greyimage,0,0)
		rec = New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec


		canvas.Color = Color.White
		canvas.DrawText("Garrison",garx,gary)
'		canvas.Color = Color.Black
'		canvas.DrawRect(garx,gary,garw,garh)
		If mygarrison.Length>0
			canvas.Color = Color.Black
			Local y:Int=gary+20
			For Local i:=Eachin mygarrison
				Local a:String=""
				If i.fortify Then 
					a+="F-"
				End If
				a+=i.name
				canvas.DrawText(a,garx,y)
				
				y+=20
				If y>garh Then Exit
			Next
		End If
	End Method
	Method drawproduction(canvas:Canvas)
		'white outline
		canvas.Color = Color.White
		canvas.DrawRect(prodx-2,prody-2,prodw+4,prodh+4)		
		' textured inside
		Local rec := New Recti<Int>
		rec.X = prodx
		rec.Y = prody
		rec.Size = New Vec2i(prodw,prodh)
		canvas.Scissor = rec
		canvas.Color = New Color(.5,.5,.5)
		canvas.DrawImage(mygreybackground.greyimage,0,0)
		' the production text
		rec = New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec
'		canvas.Color = Color.Black
'		canvas.DrawRect(prodx,prody,prodw,prodh)
		canvas.Color = Color.Black
		If myproduction.Length > 0
		canvas.DrawText("Current Production :",prodx+10,prody+10)
		canvas.DrawText(myproduction.Top.name,prodx+10,prody+30)
		canvas.DrawText(myproduction.Top.turns+" Turns Left",prodx+10,prody+50)
		End If
		canvas.DrawText("Click to add",prodx+10,prody+70)
		
		'
		' The production screen...
		If unitprodscreen = True
			canvas.Color = Color.Black
			canvas.DrawRect(prodsx-2,prodsy-2,prodsw+4,prodsh+4)		
'			canvas.Color = Color.Black
'			canvas.DrawRect(prodsx,prodsy,prodsw,prodsh)
			Local rec := New Recti<Int>
			rec.X = prodsx
			rec.Y = prodsy
			rec.Size = New Vec2i(prodsw,prodsh)
			canvas.Scissor = rec
			canvas.Color = New Color(.5,.5,.5)
			canvas.DrawImage(mygreybackground.greyimage,0,0)
			rec = New Recti<Int>
			rec.X = prodsx
			rec.Y = prodsy
			rec.Size = New Vec2i(prodsw,prodsh)
			canvas.Scissor = rec

			canvas.Color = Color.White
			If mybuildlist.Length
				Local y:Int=0
				canvas.DrawText("Select production",prodsx+10,prodsy+y)
				canvas.Color = Color.Black
				y+=20
				For Local i:=Eachin mybuildlist
					canvas.DrawText(i.name,prodsx+10,prodsy+y)
					y+=20
				Next
			End If
		End If
	End Method
	'Here we use the buffer image of the map
	'we draw it so the city we selected is in the center.
	Method drawcitymap(canvas:Canvas)
		'

		' Draw a border around the city map
		Local rec:Recti<Int>
		rec.X = citymapx-2
		rec.Y = citymapy-2
		rec.Size = New Vec2i(citymapw+4,citymaph+4)
		canvas.Scissor = rec
		canvas.Clear(Color.White)
		' Draw the inside of the city map
		rec = New Recti<Int>
		rec.X = citymapx
		rec.Y = citymapy
		rec.Size = New Vec2i(citymapw,citymaph)
		canvas.Scissor = rec
		canvas.Clear(Color.Black)

		
		' Draw the city map
		rec = New Recti<Int>
		rec.X = citymapx
		rec.Y = citymapy
		rec.Size = New Vec2i(citymapw,citymaph)
		canvas.Scissor = rec
		
		' Get the location to draw the buffer map image with.
		Local offsetx:Int=(((myworld.mw*myworld.tw)/2)-(currentcityx*myworld.tw))-myworld.tw/2
		Local offsety:Int=(((myworld.mh*myworld.th)/2)-(currentcityy*myworld.th))-myworld.th/2

		'Print sx
		canvas.Color = Color.White
		canvas.DrawImage(myworld.image,offsetx,offsety)
		canvas.DrawImage(myworld.roadimage,offsetx,offsety)
		canvas.DrawImage(myworld.fogimage,offsetx,offsety)
		' Draw the city.
		mycitymethod.drawcity(canvas,citymapx+2*myworld.tw,citymapy+2*myworld.th,myworld.tw,myworld.th,currentcitysize,currentcityname)
		
		'Restore scissor area
		rec = New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec

	End Method
End Class

' Controls like mouse pressed and keyboard
Class controls
	'fortify unit (f key)
	Method fortifyunit()
		If Keyboard.KeyReleased(Key.F)
			myunitmethod.unitactivefortify()
			myunitmethod.activateamovableunit()
		End If
	End Method

	'If press on city then open city sceen
	Method opencityscreen()
		If Keyboard.KeyDown(Key.LeftShift) = False
		If Mouse.ButtonReleased(MouseButton.Left)
		If mycitymethod.hascityatmousepos()
			currentcityx = Mouse.X / myworld.tw
			currentcityy = Mouse.Y / myworld.th
			currentcityname = mycitymethod.getcitynameat(currentcityx,currentcityy)
			currentcitysize = mycitymethod.getcitysizeat(currentcityx,currentcityy)
			currentcityproduction = mycitymethod.getproductionat(currentcityx,currentcityy)
			currentcityproductiontime = mycitymethod.getproductiontimeat(currentcityx,currentcityy)
			currentcitybarracks = mycitymethod.getcitybarracksat(currentcityx,currentcityy)
			currentcitymines = mycitymethod.getcityminesat(currentcityx,currentcityy)
			currentcityfarms = mycitymethod.getcityfarmsat(currentcityx,currentcityy)
			currentcitywalls = mycitymethod.getcitywallsat(currentcityx,currentcityy)			
			currentcityfood = mycitymethod.getcityfoodat(currentcityx,currentcityy)
			currentcityresources = mycitymethod.getcityresourcesat(currentcityx,currentcityy)
			currentcityharbor = mycitymethod.getcityharborsat(currentcityx,currentcityy)
			currentcitycoastal = mycitymethod.getcitycoastal(currentcityx,currentcityy)
			mycityscreen.updatecitybuildlist()
			mycityscreen.updategarrison()
			mycityscreen.updateproduction()
			cityscreenopen = True
			mousedelay = 0
			keydelay = 0			
		End If
		End If
		End If
		
	End Method
	'unit skip turn (space)
	Method activeunitskipturn()
		If Keyboard.KeyReleased(Key.Space)
			myunitmethod.activeunitskipturn()
			myunitmethod.activateamovableunit()
		End If
	End Method
	' build a road
	Method buildroad()		
		If Keyboard.KeyReleased(Key.R)
			If myunitmethod.activeunitissetler() = False Then Return
			myunitmethod.buildroadatactiveunitpos()	
			myworld.updatedrawroads(myworld.roadcanvas)	
			'find next movable unit
			myunitmethod.activateamovableunit()						
		End If
	End Method
	
	' End of turn
	Method myendofturn()
		If Keyboard.KeyReleased(Key.Enter) Or Mouse.ButtonReleased(MouseButton.Middle)
			'Update the buildlist of each city
			For Local i:=Eachin mycity
				i.turnend()
			Next
			'restore the moves
			For Local i:=Eachin myunit
				i.movesleft = i.originalmoves
				i.active = False				
			Next
			'rest moves
			gamehasmovesleft = True
			'increase turn
			turn+=1
			' activate a moveable unit
			myunitmethod.activateamovableunit()
			
		End If
	End Method
	' if mouse on unit then activate unit
	Method activateunit()		
		If Mouse.ButtonReleased(MouseButton.Left) = False Then Return				
		Local x:Int=Mouse.X / myworld.tw
		Local y:Int=Mouse.Y / myworld.th
		If myunitmethod.ismovableunitatpos(x,y) = False Then Return
		myunitmethod.unitsactivedisable()
		myunitmethod.activatemovableunitatpos(x,y)
			If x > myworld.mw/2 Then 
				myunituserinterface.dockside("Left")
				Else
				myunituserinterface.dockside("Right")
			End If
		
		'If Mouse.X > myworld.mw/2 Then 
		'	myunituserinterface.dockside("Left")
		'	Else
		'	myunituserinterface.dockside("Right")
		'End If		
	End Method
	' if pressed b then build city at active unit
	Method buildcity()
		If Keyboard.KeyReleased(Key.B)
			If myunitmethod.activeunitissetler() = False Then Return
			If myunitmethod.iscityatactiveunitpos() = true Then Return
			' build a road there
			myunitmethod.buildroadatactiveunitpos(False)	
			Local x:Int,y:Int
			'get the active unit x and y coordinates
			For Local i:=Eachin myunit
				If i.active = True
					x = i.x
					y = i.y
					i.deleteme = True
					Exit
				End If
			Next			
			mycity.Add(New city(x,y))
			myworld.updatedrawroads(myworld.roadcanvas)			
			myunitmethod.activateamovableunit()
		End If
	End Method
	' add a unit to the map (cheat)
	Method addunit(canvas:Canvas,Width:Int,Height:Int)
		If Keyboard.KeyDown(Key.LeftShift)
		If Mouse.Y / myworld.th < myworld.mh-1
		If Mouse.ButtonReleased(MouseButton.Left)
		If myworld.map[Mouse.X/myworld.tw,Mouse.Y/myworld.th] > 5
			myunit.Add(New unit(Mouse.X/myworld.tw,Mouse.Y/myworld.th,"Settlers"))
			myunitmethod.removefog(Mouse.X/myworld.tw,Mouse.Y/myworld.th)
			If Mouse.X > Width/2 Then 
				myunituserinterface.dockside("Left")
				Else
				myunituserinterface.dockside("Right")
			End If
			redrawgame()
			
		End If
		End If
		End If
		End If
	End Method
	' add a sea unit to the map (cheat)
	Method addseaunitat(x:Int,y:int)		
		If myworld.map[x,y] > 5
			myunit.Add(New unit(x,y,"Sea Unit"))
			myunitmethod.removefog(x,y)
			If x > myworld.mw/2 Then 
				myunituserinterface.dockside("Left")
				Else
				myunituserinterface.dockside("Right")
			End If
			redrawgame()
		End If
	End Method

	' add a unit to the map (cheat)
	Method addunitat(x:Int,y:int)		
		If myworld.map[x,y] > 5
			myunit.Add(New unit(x,y,"Settlers"))
			myunitmethod.removefog(x,y)
			If x > myworld.mw/2 Then 
				myunituserinterface.dockside("Left")
				Else
				myunituserinterface.dockside("Right")
			End If
			redrawgame()
		End If
	End Method
	Method moveunit(canvas:Canvas,Width:Int,Height:Int)
		If Mouse.ButtonReleased(MouseButton.Right)
		If Mouse.Y / myworld.th < myworld.mh-1
			Local x:Int=Mouse.X / myworld.tw
			Local y:Int=Mouse.Y / myworld.th
			myunitmethod.moveactiveunitto(x,y)
			'updatemapingame(canvas,Width,Height)
			redrawgame()
		End If			
		End If
	End Method
End Class

Class city
	Class production
		Field name:String="Settlers"
		Field turns:Int=4
		Method New(name:String="Settlers")
			Self.name=name
		End Method		
	End Class
	Field x:Int
	Field y:Int
	Field size:Int=1	
	Field farms:Int=2
	Field mines:Int=2
	Field walls:Bool=False
	Field barracks:Bool=False
	Field resources:Int=3
	Field food:Int=5 'the amount of food in the city	
	Field deleteme:Bool=False
	Field name:String
	Field myproduction:Stack<production>
	Field harbor:Bool=False
	Field coastalcity:Bool
	Method New(x:Int,y:Int)
		mygamemessage.pushmessage("A New City Was Created")
		If cityatpos(x,y) = True Then deleteme = True ; Return
		myproduction = New Stack<production>
		'myproduction.Add(new production())
		'myproduction.Add(new production())
		Self.x = x
		Self.y = y
		' givbe the city a unique name
		name = randomcityname()
		' set the flag coastalcity
		coastalcity = mycitymethod.citynexttowater(x,y)		
		' remove the unit that created the city
		myunitmethod.removeactiveunit()
		
		
	End Method
	'Give the city a random name
	Method randomcityname:String()
		Local newname:String
		Local firstname:String[] = New String[]( 	"New",
													"Old",
													"First",
													"Second",
													"Last")
													
		Local secondname:String[] = New String[]( 	"Berlin",
												"Brussel",
												"Madrid",
												"Paris",
												"Antwerp",
												"Rotterdam",
												"Rome",
												"London",
												"Milan",
												"Vienna",
												"Hamburg",
												"Budapest",
												"Warsaw",
												"Barcelona",
												"Munich",
												"Prague",
												"Sofia",
												"Cologne",
												"Amsterdam")
		Local exitloop:Bool=False
		Repeat
			newname = firstname[Rnd(firstname.Length)] + " " + secondname[Rnd(secondname.Length)]
			exitloop=True
			For Local i:=Eachin mycity
				If i.name = newname Then exitloop=False
			Next
			If exitloop = True Then Exit
		Forever
		Return newname
	End Method
	'return true if there is a city at the input coords
	Method cityatpos:Bool(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y Then Return True
		Next
		Return False
	End Method
	'draw the city
	Method draw(canvas:Canvas)
		Local mx:Int=x*myworld.tw
		Local my:Int=y*myworld.th
		Local tw:Int=myworld.tw
		Local th:Int=myworld.th
'					Local rec:Recti<Int>
'					rec.X = mx-40
'					rec.Y = my-40
'					rec.Size = New Vec2i(tw+80,th+80)
'					canvas.Scissor = rec
		mycitymethod.drawcity(canvas,mx,my,tw,th,size,name)
	End Method
	Method turnend()
		
		'see if we can create anything
		If myproduction.Length
			myproduction.Top.turns-=1
			If myproduction.Top.turns=0
				Select myproduction.Top.name
					Case "Sea Unit"
						mycontrols.addseaunitat(x,y)
						mygamemessage.pushmessage(name+" Sea Unit Build")
						size-=1
					Case "Settlers"
						mycontrols.addunitat(x,y)
						mygamemessage.pushmessage(name+" Settlers Build")
						size-=1
					Case "City Walls"
						'Print "Walls Created"
						walls = True
						mygamemessage.pushmessage(name+" City Walls Build")
					Case "Barracks"
						'Print "Barracks Created"
						mygamemessage.pushmessage(name+" Barracks Build")
						barracks = True
					Case "Mine"
						'Print "Mine created"
						mygamemessage.pushmessage(name+" Mine Build")
						mines+=1
					Case "Farm"
						'Print "Farm Created"
						mygamemessage.pushmessage(name+" Farm build")
						farms+=1
					Case "Expand City"
						mygamemessage.pushmessage(name+" City Expanded")
						size+=1					
				End Select			
				myproduction.Pop()
			End If
		End If		
		' increase food
		food += farms
		' increase resources
		resources += mines
		' population cost
		food -= size		
		resources -= size
		
		'improvement costs
		If walls = True Then resources-=1
		If barracks = True Then resources-=1
		
		' schrink city if shortages
		If resources < 0 Or food < 0 Then 
			size -= 1 		
			mygamemessage.pushmessage(name+" Decreased In Size.")
		End If			
		If size<1 Then size = 1
		
		'grow city in time of plenty
		If food > 10 And resources > 10 Then 
			mygamemessage.pushmessage(name+" Grew In Size")
			food -= 4
			resources -= 4
			size+=1
		End If
		
		'decrease population size if shortages
	End Method
End Class

'city methods
Class citymethod
	' Return if the city is coastal.
	Method getcitycoastal:bool(x:Int,y:int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.coastalcity
			End If
		Next
		Return False
	End Method
	'return true or false if city at x,y is next to water
	Method citynexttowater:bool(x:Int,y:int)
		For Local y2:=-1 To 1
		For Local x2:=-1 To 1
			Local x3:Int=x+x2
			Local y3:Int=y+y2
			If x3>=0 And y3>=0 And x3<myworld.mw And y3<myworld.mh
				If myworld.map[x3,y3] <= 5							
					Return True
				End If
			End If
		Next
		Next
		Return False
	End Method
	' return true or false if city has harbor
	Method getcityharborsat:Bool(x:Int,y:int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.harbor
			End If
		Next
		Return False		
	End Method
	' get the amount of food in the city
	Method getcityfoodat:Int(x:int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.food
			End If
		Next
		Return -1		
	End Method
	'get the amount of resources in the city
	Method getcityresourcesat:int(x:int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.resources
			End If
		Next
		Return -1
	End Method


	' return bool if city at x,y has barracks
	Method getcitybarracksat:bool(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.barracks
			End If
		Next
		Return False
	End Method
	' return int if city at x,y has mines
	Method getcityminesat:Int(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.mines
			End If
		Next
		Return -1
	End Method	
	'return int with number of farms in city at x,y	
	Method getcityfarmsat:Int(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.farms			
			End If
		Next		
		Return -1
	End Method
	' return bool if city at x,y has walls
	Method getcitywallsat:Bool(x:Int,y:Int)			
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return i.walls
			End If
		Next		
		Return False
	End Method
	Method getproductionat:String(x:int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				If i.myproduction.Length>0
					Return i.myproduction.Top.name
				End If
			End If
		Next
		Return "No Production"
	End Method
	Method getproductiontimeat:int(x:int,y:int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				If i.myproduction.Length>0
					return i.myproduction.Top.turns
				End If
			End If
		Next
		Return -1
	End Method

	Method getcitynameat:String(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x and i.y = y Then Return i.name
		Next
		Return ""
	End Method
	Method getcitysizeat:int(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x and i.y = y Then Return i.size
		Next
		Return 0
	End Method


	Method hascityatmousepos:Bool()
		Local x:Int=Mouse.X / myworld.tw
		Local y:Int=Mouse.Y / myworld.th
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return True
			End If
		Next
		Return False
	End Method
	Method drawcity(canvas:Canvas,mx:Int,my:Int,tw:int,th:int,size:int,name:string)
		canvas.Color = New Color(1,0,0)
		canvas.DrawRect(mx,my,tw,th)
		canvas.Color = New Color(1,1,1)
		canvas.DrawRect(mx+4,my+4,tw-8,th-8)
		canvas.Color = New Color(0,0,0)
		canvas.DrawText(size,mx+tw/2,my+th/2,.5,.5)		
		canvas.Color = New Color(0,0,0)
		canvas.DrawText(name,(mx+tw/2),(my),0.5,.8)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText(name,(mx+tw/2)+1,(my)+1.2,0.5,.8)		
	End Method	
End Class

' Methods to modify units
Class unitmethod
	' Returns if the active unit is a settler
	Method activeunitissetler:bool()
		For Local i:=Eachin myunit
			If i.active = True
				If i.name = "Settlers" Then Return True
			End If
		Next
		Return False
	End Method
	' return true if a land or sea unit moves into illegal terrain
	Method activeunitillegalmove:Bool(x2:int,y2:int)
		'is he moving into a harbor?
		For Local i:=Eachin mycity
			If i.x = x2 And i.y = y2
				Return False 'can move here
			End If
		Next
		' Is he moving into land or sea when impossible to do that?
		For Local i:=Eachin myunit
			If i.active = True
				If i.seaunit And myworld.map[x2,y2] > 5 Then Return True
				If i.landunit And myworld.map[x2,y2] <=5 Then Return True
			End If
		Next
		'No problems found
		Return False
	End Method
	' Does the unit with id have moves left
	Method unitmovesleft:Float(id:Int)
		Local retval:Float=-1
		For Local i:=Eachin myunit
			If i.id = id Then Return i.movesleft
		Next
		Print "Error - myunitmethod.unitmovesleft unit not found id"
		Return retval
	End Method
	' Set the fortify flag of a unit (id)
	Method unitfortify(id:Int,val:Bool)		
		For Local i:=Eachin myunit
			If i.id = id
				i.fortify = val
				Return
			End If
		Next
		Print "Error in myunitmethod.unitfortify.."
	End Method
	' Returns true or false if a unit is fortified
	Method unitisfortified:Bool(id:Int)		
		For Local i:=Eachin myunit
			If i.id = id Then Return i.fortify
		Next
		Print "Error - Unit id not found in unitmethod.unitisfortied(id)"
		Return -1
	End Method
	' Create a unique number for a new unit
	Method getuniqueid:Int()
		Local eloop:Bool=True
		Local rval:Int
		Repeat
			rval=Rnd(100000)
			eloop = True			
			For Local i:=Eachin myunit
				If i.id = rval Then eloop = False
			Next
		Until eloop = True
		Return rval
	End Method
	'Remove the fog around the input coordinates
	Method removefog(x:int,y:int)
		Local lefttop:Bool=False
		Local righttop:Bool=False
		Local leftbottom:Bool=False
		Local rightbottom:Bool=False
		If x-2 >= 0 And y-2 >= 0 And myworld.fogmap[x-2,y-2] = True Then lefttop = True
		If x+2 < myworld.mw And y-2 >=0 And myworld.fogmap[x+2,y-2] = True Then righttop = True
		If x-2 >= 0 And y+2 <myworld.mh And myworld.fogmap[x-2,y+2] = True Then leftbottom = True
		If x+2 < myworld.mw And y+2 < myworld.mh And myworld.fogmap[x+2,y+2] = True Then rightbottom = True
		For Local y1:=y-2 To y+2
		For Local x1:=x-2 To x+2
			If x1>=0 And y1>=0 And x1<myworld.mw And y1<myworld.mh
				myworld.fogmap[x1,y1] = False
			End If
		Next
		Next	
		If lefttop = True Then myworld.fogmap[x-2,y-2] = True
		If righttop = True Then myworld.fogmap[x+2,y-2] = true
		If leftbottom = True Then myworld.fogmap[x-2,y+2] = True
		If rightbottom = True Then myworld.fogmap[x+2,y+2] = True
	End Method
	'fortify the active unit
	Method unitactivefortify()
		For Local i:=Eachin myunit
			If i.active = True
				i.active = False
				i.visible = True
				i.movesleft = 0
				i.fortify = True
				Exit
			End If
		Next
	End Method
	' skip the turn of a unit (set its moves to 0)
	Method activeunitskipturn()
		For Local i:=Eachin myunit
			If i.active = True
				i.active = False
				i.visible = True
				i.movesleft = 0
				Return
			End If
		Next
	End Method
	' returns if there is a city at the active unit its position	
	Method iscityatactiveunitpos:bool()	
		For Local i:=Eachin myunit
			If i.active=True
				For Local i2:=Eachin mycity
					If i2.x = i.x And i2.y = i.y Then Return true
				Next
			End If
		Next
		Return False
	End Method
	' build a road at the active unit its position
	Method buildroadatactiveunitpos(modifyunit:Bool=True)
		For Local i:=Eachin myunit
			If i.active = True And myworld.roadmap[i.x,i.y].hasroad = False
				If modifyunit = True Then
					i.active = False
					i.movesleft = 0
					i.visible = True
				End If
				myworld.roadmap[i.x,i.y].hasroad = True
				' has road north
				If i.y-1 >=0
					If myworld.roadmap[i.x,i.y-1].hasroad = True Then
						myworld.roadmap[i.x,i.y].n = True
						myworld.roadmap[i.x,i.y-1].s = true
					End If
				End If
				'has a road north east
				If i.x+1<myworld.mw And i.y-1 >=0
					If myworld.roadmap[i.x+1,i.y-1].hasroad = True
						myworld.roadmap[i.x,i.y].ne = True
						myworld.roadmap[i.x+1,i.y-1].sw = True
					End If
				End If
				'has a road east
				If i.x+1<myworld.mw 
					If myworld.roadmap[i.x+1,i.y].hasroad = True
						myworld.roadmap[i.x,i.y].e = True
						myworld.roadmap[i.x+1,i.y].w = True
					End If
				End If
				'has a road south east
				If i.x+1<myworld.mw 
					If myworld.roadmap[i.x+1,i.y+1].hasroad = True
						myworld.roadmap[i.x,i.y].se = True
						myworld.roadmap[i.x+1,i.y+1].nw = True
					End If
				End If
				'has a road south
				If i.y+1<myworld.mh
					If myworld.roadmap[i.x,i.y+1].hasroad = True
						myworld.roadmap[i.x,i.y].s = True
						myworld.roadmap[i.x,i.y+1].n = True
					End If
				End If
				'has a road south west
				If i.x-1 >=0 And i.y+1<myworld.mh
					If myworld.roadmap[i.x-1,i.y+1].hasroad = True
						myworld.roadmap[i.x,i.y].sw = True
						myworld.roadmap[i.x-1,i.y+1].ne = True
					End If
				End If
				'has a road west
				If i.x-1 >=0 
					If myworld.roadmap[i.x-1,i.y].hasroad = True
						myworld.roadmap[i.x,i.y].w = True
						myworld.roadmap[i.x-1,i.y].e = True
					End If
				End If
				'has a north west
				If i.x-1 >=0 And i.y-1>=0
					If myworld.roadmap[i.x-1,i.y-1].hasroad = True
						myworld.roadmap[i.x,i.y].nw = True
						myworld.roadmap[i.x-1,i.y-1].se = True
					End If
				End If
				redrawgame()
				Exit
			End If
		Next
	End Method
	' this function finds a unit that has not moved yet.
	Method activateamovableunit()
		'return if there is already a active unit
		For Local i:=Eachin myunit
			If i.active = True Then 
				Return
			End If
		Next
		' find and activate a unit
		For Local i:=Eachin myunit
			If i.deleteme = False			
			If i.movesleft > .3	And i.fortify = False							
				myunitmethod.disableunitontopat(i.x,i.y)
				i.active = True
				i.ontop = True
				i.visible = True
				i.blinktimer = 0
				activeunitmovesleft = i.movesleft
				If i.x > myworld.mw/2
					myunituserinterface.dockside("Left")
					Else
					myunituserinterface.dockside("Right")
				End If
				Return
			End If			
			End If
		Next
		gamehasmovesleft=False
	End Method
	'activate unit at position	
	Method activatemovableunitatpos(x:int,y:int)		
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
			If i.movesleft > .3
				i.fortify = False
				i.active = True
				myunitmethod.disableunitontopat(i.x,i.y)
				i.ontop = True
				i.visible = True
				i.blinktimer = 0
				activeunitmovesleft = i.movesleft
				Return
			End If
			End If
		Next
	End Method
	' disable ontop flag at pos x,y
	Method disableunitontopat(x:Int,y:Int)
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
				i.ontop = False
			End If
		Next
	End Method
	'see if there is a unit at pos x,y
	Method ismovableunitatpos:bool(x:Int,y:Int)
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
				If i.movesleft > 0
					'is there not a city here?
					If iscityatpos(x,y) = False
						Return True
					End If
				End If
			End If
		Next
		Return False
	End Method
	'is there a city at position x,y
	Method iscityatpos:Bool(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y Then Return True
		Next
		Return False
	End Method
	'disable the active unit state
	Method unitsactivedisable()
		For Local i:=Eachin myunit
			If i.active = True
				i.active = False
				i.visible = True
				return
			End If
		Next
	End Method
	' Remove the current active unit
	Method removeactiveunit()
		For Local i:=Eachin myunit
			If i.active = True Then 
				i.active = False
				i.deleteme = True
			End If
		Next
	End Method
	' Move active unit to this possition if possible
	' checks if reachable. 
	Method moveactiveunitto(newposx:Int,newposy:Int)
		If newposx<0 Or newposx>=myworld.mw Then Return
		If newposy<0 Or newposy>=myworld.mh Then return
		' if destination is water then return
		' If myworld.map[newposx,newposy] <= 5 Then Return
		If myunitmethod.activeunitillegalmove(newposx,newposy) Then Return
		' find unit and move
		For Local i:=Eachin myunit
			If i.active = True And i.movesleft > .3				
				If i.x = newposx And i.y = newposy Then Return
				Local oldposx:Int=i.x
				Local oldposy:Int=i.y
				' see if we can move here.
				If rectsoverlap(newposx,newposy,1,1,oldposx-1,oldposy-1,3,3)										
					' at old position set one unit to visible
					' and ontop
					For Local i2:=Eachin myunit
						If i<>i2
						If i2.x = oldposx And i2.y = oldposy
							i2.visible = True							 
							i2.ontop = True							 
							Exit
						End If
						End If
					Next					
					' at new pos set units to invible
					' and not ontop
					For Local i2:=Eachin myunit
						If i2.x = newposx And i2.y = newposy
							i2.visible = False
							i2.ontop = False
						End If
					Next					
					i.x = newposx
					i.y = newposy
					myunitmethod.removefog(i.x,i.y)					
					i.visible = True
					i.ontop = True
					i.blinktimer = 0
					' here we do the movement cost
					If myworld.roadmap[newposx,newposy].hasroad = True
						i.movesleft -=.33
					Else
						i.movesleft -= 1
					End If
					activeunitmovesleft = i.movesleft
					If i.movesleft < .3 Then 
						i.visible = True
						i.active = False
						myunitmethod.activateamovableunit()
						return
					End If
				End If
			End If
		Next
	End Method
	
	
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	 Function

End Class

Class unit
	Field id:Int
	Field x:Int,y:Int
	Field name:String="Settler"
	Field ontop:Bool=True
	Field active:Bool=False
	Field deleteme:Bool=False
	Field visible:Bool=True
	Field blinktimer:Int
	Field movesleft:Float=1
	Field originalmoves:Float=1
	Field fortify:Bool=False
	Field seaunit:Bool=False
	Field landunit:Bool=True
	Method New(mx:Int,my:Int,name:String)
		Self.id = myunitmethod.getuniqueid()		
		Self.x = mx
		Self.y = my
		Self.name = name
		If name="Sea Unit" Then landunit=False;seaunit=True;originalmoves=2
		If name="Settlers" Then landunit=true;seaunit=False
		movesleft = originalmoves
		removeontop(mx,my)
		ontop = True
		removeallactivestatus()
		resetblink()
		active = True		
	End Method
	' remove ontop status of all units at position x,y
	Method removeontop(mx:Int,my:Int)
		For Local i:=Eachin myunit
			If i.x = mx And i.y = my
				i.ontop = False
			End If
		Next
	End Method
	' Set active status of all units at x,y to false
	Method removeallactivestatus()
		For Local i:=Eachin myunit
			i.active = False
		Next
	End Method
	' Reset blink timers and set visible to true
	Method resetblink()
			For Local i:=Eachin myunit
				i.visible = True
				i.blinktimer = 0
			Next
	End Method
	Method draw(canvas:Canvas)
		If ontop = True And visible = True			
			Local mx:Float = x * myworld.tw
			Local my:Float = y * myworld.th
			Local rec:Recti<Int>
			rec.X = mx
			rec.Y = my
			rec.Size = New Vec2i(myworld.tw,myworld.th)
			canvas.Scissor = rec
			
			canvas.Color = New Color(1,1,1)
			canvas.DrawRect(mx,my,myworld.tw,myworld.th)
			'
			If movesleft <= .3 or fortify=true
				canvas.Color = New Color(.5,.5,.5)				
				For Local x1:Int = mx-10 Until mx+myworld.tw Step 5				
					canvas.DrawLine(x1,my,x1+10,my+myworld.th)
				Next				
			End If
			If fortify = True
				canvas.Color = New Color(.2,.2,.2)
				canvas.DrawText("F",mx+myworld.tw/2,my+myworld.th/2,.5,.5)
			End If
		End If
	End Method
End Class

Class tile
	Field tw:Float
	Field th:Float
	Method New()
		Self.tw = myworld.tw
		Self.th = myworld.th
	End Method	

	Method drawmountain(x:Float,y:Float,canvas:Canvas)		
		SeedRnd(x*y)
		canvas.Color = New Color(.5,0.6,0.2)
		canvas.DrawRect(x,y,tw,th)
		Local w:Float=tw/10
		Local h:Float=th/10
		
		For Local i1:=0 Until 5
		Local x1:Float=x+tw/2+Rnd(-w,w)
		Local y1:Float=y+th/2+Rnd(-h,h)
		For Local i2:=0 Until 12
			Local x2:float=x1+Rnd(-tw/3,tw/3)
			Local y2:float=y1+Rnd(-th/3,th/3)
			canvas.Color = New Color(.5+Rnd(.2),0.6+Rnd(.2),0.2+Rnd(.1))
			
			canvas.DrawCircle(x2,y2,Rnd(w/2,w*1/5))
		Next
		Next


		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(Rnd(0.3,0.5),Rnd(0.2,0.7),Rnd(0.1,0.3))
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method

	Method drawhill(x:Float,y:Float,canvas:Canvas)		
		SeedRnd(x*y)
		canvas.Color = New Color(.5,0.3,0)
		canvas.DrawRect(x,y,tw,th)
		Local w:Float=tw/10
		Local h:Float=th/10
		
		For Local i1:=0 Until 5
		Local x1:Float=x+tw/2+Rnd(-w,w)
		Local y1:Float=y+th/2+Rnd(-h,h)
		For Local i2:=0 Until 3
			Local x2:float=x1+Rnd(-tw/3,tw/3)
			Local y2:float=y1+Rnd(-th/3,th/3)
			canvas.Color = New Color(.5+Rnd(0.2),.3+Rnd(.1),0)
			'canvas.Color = New Color(0,Rnd(0,0.5),0)
			canvas.DrawCircle(x2,y2,Rnd(w,w*1.5))
		Next
		Next
		
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(Rnd(0.3,0.5),Rnd(0.1,0.3),0)
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method


	Method drawtree(x:Float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(0,0.5,0)
		canvas.DrawRect(x,y,tw,th)		
		Local w:Float=tw/8
		Local h:Float=th/8
		For Local i1:=0 Until 5
		Local x1:Float=x+Rnd(tw)
		Local y1:Float=y+Rnd(th)
		For Local i2:=0 Until 5
			Local x2:float=x1+Rnd(-w,w)
			Local y2:float=y1+Rnd(-h,h)
			canvas.Color = New Color(0,Rnd(0,0.5),0)
			canvas.DrawCircle(x2,y2,w)
		Next
		Next
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0.1,0.3),0)
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method

	Method drawgrass(x:float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(0,0.5,0)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0.2,0.6),0)
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method

	Method drawwater(x:float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(0,0,0.5)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0.2,0.3),Rnd(0.4,0.7))
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method
	
	Method drawwaterdeep(x:float,y:Float,canvas:Canvas)
		SeedRnd(1)
		canvas.Color = New Color(0,0,0.3)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0,0.1),Rnd(0.2,0.6))
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next
	End Method
End Class

Class world
	Field image:Image
	Field icanvas:Canvas
	Field roadimage:Image	
	Field roadcanvas:Canvas
	Field fogimage:Image
	Field fogcanvas:Canvas
	Class roadconnection
		Field hasroad:Bool = False
		Field n:Bool=False,ne:Bool=False
		Field e:Bool=False,se:Bool=False
		Field s:Bool=False,sw:Bool=False
		Field w:Bool=False,nw:Bool=False
		Method New()
			'n=True
			'e=True
			's=True
			'w=True
			'ne=True
			'se=True
			'sw=True
			'nw=True
			'hasroad=True
		End Method	
	End Class
	Field roadmap:roadconnection[,] = New roadconnection[1,1]
	Field map:Int[,] = New Int[1,1]
	Field fogmap:Bool[,] = New bool[1,1]
	Field tw:Float,th:Float
	Field sw:Int,sh:Int
	Field mw:Int,mh:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		image=New Image( sw,sh)
		image.Handle=New Vec2f( 0,0 )
		icanvas=New Canvas( image )
		roadimage = New Image(sw,sh)
		roadimage.Handle=New Vec2f( 0,0 )
		roadcanvas = New Canvas(roadimage)
		fogimage = New Image(sw,sh)
		fogimage.Handle=New Vec2f( 0,0 )
		fogcanvas = New Canvas(fogimage)

		Self.mw = mw
		Self.mh = mh
		Self.sw = sw
		Self.sh = sh
		tw = Float(sw)/Float(mw)
		th = Float(sh)/Float(mh)
		map = New Int[mw,mh]
		roadmap = New roadconnection[mw,mh]
		For Local my:=0 Until mh
		For Local mx:=0 Until mw
			roadmap[mx,my] = New roadconnection()
		Next
		Next
		fogmap = New Bool[mw,mh]
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			fogmap[x,y] = True
		Next
		Next
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
					If map[x2,y2] > 46 Then eloop=True					
				End If
			Next
			Next		
		Wend
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			map[x,y] = (10.0/46)*map[x,y]
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		canvas.DrawImage(image,0,0)
		canvas.DrawImage(roadimage,0,0)
		canvas.DrawImage(fogimage,0,0)
	End Method
'	Method drawroads(canvas:Canvas)
'		canvas.DrawImage(image
'	End Method
	Method updatedraw(canvas:Canvas)
		canvas.Clear(Color.Black)
		For Local y:Float=0 Until mh-1 Step 1
		For Local x:Float=0 Until mw Step 1
			Local t:Int=map[x,y]
			Local x2:Float=x*tw
			Local y2:Float=y*th
			Select t
			Case 0
			'canvas.Color = New Color(0,0,.5)
			mytile.drawwaterdeep(x2,y2,canvas)
			Case 2
			'canvas.Color = New Color(0,0,.6)
			mytile.drawwaterdeep(x2,y2,canvas)
			Case 3
			mytile.drawwaterdeep(x2,y2,canvas)
			'canvas.Color = New Color(0,0,.7)
			Case 4
			mytile.drawwater(x2,y2,canvas)
			'canvas.Color = New Color(.1,.1,.7)
			Case 5
			mytile.drawwater(x2,y2,canvas)
			Case 6
			mytile.drawgrass(x2,y2,canvas)
			'canvas.Color = New Color(.2,1,.1)
			Case 7
			'canvas.Color = New Color(0,.5,0)
			mytile.drawtree(x2,y2,canvas)
			Case 8
			'canvas.Color = New Color(0,.2,0)			
			mytile.drawhill(x2,y2,canvas)
			Case 9
			mytile.drawmountain(x2,y2,canvas)
			'canvas.Color = New Color(.9,.8,.9)			
			Case 10
			mytile.drawmountain(x2,y2,canvas)
			'canvas.Color = New Color(.9,.9,.9)			
			End Select
			'canvas.DrawRect(x*tw,y*th,tw,th)
		Next
		Next
		canvas.Flush()
	End Method
	Method updatedrawfog(canvas:Canvas)
		canvas.Clear(New Color(0,0,0,0))		
		canvas.Color = Color.Black
		For Local y:Float=0 Until mh-1 Step 1
		For Local x:Float=0 Until mw Step 1			
			Local x2:Float=x*tw
			Local y2:Float=y*th
			If fogmap[x,y] = True Then
				canvas.DrawRect(x2,y2,tw,th)
			end If			
		Next
		Next		
		canvas.Flush()
	End Method
	Method updatedrawroads(canvas:Canvas)	
		canvas.Clear(New Color(0,0,0,0))
		canvas.Color = New Color(.7,.3,0)
		For Local y:Float=0 Until mh-1 Step 1
		For Local x:Float=0 Until mw Step 1			
			Local x2:Float=x*tw
			Local y2:Float=y*th
			Local cx:Float=x2+tw/2
			Local cy:Float=y2+th/2
			If roadmap[x,y].hasroad = True 'And fogmap[x,y] = false
				canvas.DrawRect(x2+tw/2,y2+th/2,4,4)			
				If roadmap[x,y].n = True Then
					drawroadline(canvas,cx,cy,cx,cy-th/2)				
				End If
				If roadmap[x,y].ne = True Then
					drawroadline(canvas,cx,cy,cx+tw/2,cy-th/2)				
				End If
				If roadmap[x,y].e = True Then
					drawroadline(canvas,cx,cy,cx+tw/2,cy)				
				End If
				If roadmap[x,y].se = True Then
					drawroadline(canvas,cx,cy,cx+tw/2,cy+th/2)				
				End If
				If roadmap[x,y].s = True Then
					drawroadline(canvas,cx,cy,cx,cy+th/2)				
				End If
				If roadmap[x,y].sw = True Then
					drawroadline(canvas,cx,cy,cx-tw/2,cy+th/2)				
				End If
				If roadmap[x,y].w = True Then
					drawroadline(canvas,cx,cy,cx-tw/2,cy)				
				End If
				If roadmap[x,y].nw = True Then
					drawroadline(canvas,cx,cy,cx-tw/2,cy-th/2)				
				End If
				
			End If
		Next
		Next
		canvas.Flush()		
	End Method
	Method drawroadline(canvas:Canvas,x1:Float,y1:Float,x2:Float,y2:Float)
		SeedRnd(0)
		Local x3:Float=x1
		Local y3:Float=y1
		Local s:Float=tw*th/600
		If s<1 Then s=1
		'Print tw*th/200
		
		Repeat
			If x3<x2 Then x3+=Rnd(2)
			If y3<y2 Then y3+=Rnd(2)
			If x3>x2 Then x3-=Rnd(2)
			If y3>y2 Then y3-=Rnd(2)
			For Local z:=0 Until 9
				canvas.Color = New Color(Rnd(0.4,.7),Rnd(0.0,.3),0)			
				canvas.DrawCircle(x3+Rnd(-1,1),y3+Rnd(-1,1),Rnd(0,s))
				canvas.Color = New Color(Rnd(0.2,.4),Rnd(0.0,.2),0)			
				canvas.DrawPoint(x3+Rnd(-3,3),y3+Rnd(-3,3))
			Next
			
			If rectsoverlap(x3,y3,2,2,x2,y2,2,2) Then Exit
		Forever
	End Method
	Method updatedrawfogedge(canvas:Canvas)				
		'canvas.Clear(New Color(0,0,0,0))
		For Local my:=0 Until mh-1
		For Local mx:=0 Until mw
			Local lefttopx:Int=mx*tw
			Local lefttopy:Int=my*th
			Local righttopx:Int=mx*tw+tw
			Local righttopy:Int=my*th
			Local rightbottomx:Int=mx*tw+tw
			Local rightbottomy:Int=my*th+th
			Local leftbottomx:Int=mx*tw
			Local leftbottomy:Int=my*th+th			
			
			If fogmap[mx,my] = true 'if fog tile
			
			If mx-1>=0 And fogmap[mx-1,my] = False 'if left is visible
				drawfogline(canvas,lefttopx,lefttopy,leftbottomx,leftbottomy)
			End If	
					
			If my-1>=0 And fogmap[mx,my-1] = False 'if top is visible
				drawfogline(canvas,lefttopx,lefttopy,righttopx,righttopy)
			End If
			
			If mx+1<mw And fogmap[mx+1,my] = False 'if right is visible
				drawfogline(canvas,righttopx,righttopy,rightbottomx,rightbottomy)
			End If
			
			If my+1<mh And fogmap[mx,my+1] = false 'if bottom is visible			
				drawfogline(canvas,leftbottomx,leftbottomy,rightbottomx,rightbottomy)			
			End If
			
			End If
		Next
		Next
		
		canvas.Flush()
	End Method	
	Function drawfogline(canvas:Canvas,x1:Double,y1:double,x2:Double,y2:double)		
		SeedRnd(x1*y1)
		'Local oldx:double=x1,oldy:Double=y1
		Local x3:Double=x1,y3:double=y1
		Local exitloop:Bool = False
		Repeat
			
			If x3<x2 Then x3+=Rnd(1)
			If y3<y2 Then y3+=Rnd(1)
			If x3>x2 Then x3-=Rnd(1)
			If y3>y2 Then y3-=Rnd(1)	
			Local c:Float=0
			'If Rnd(1)<.9
				canvas.Color = New Color(c,c,c)
				Local ts:Float=myworld.tw/7
				canvas.DrawRect(x3+Rnd(-ts,ts),y3+Rnd(-ts,ts),Rnd(1,4),Rnd(1,4))				
  			'End If
						'If Rnd(1)<.5
						'canvas.Color = New Color(1,1,1)
						'canvas.DrawPoint(x3,y3)
						'End If
			
			If rectsoverlap(x3,y3,2,2,x2,y2,2,2) = True Then 						
				Return
			End If
		Until exitloop=True
		
	End Function

	Method updatedrawwateredge(canvas:Canvas)
		For Local my:=0 Until mh-1
		For Local mx:=0 until mw
			Local lefttopx:Int=mx*tw
			Local lefttopy:Int=my*th
			Local righttopx:Int=mx*tw+tw
			Local righttopy:Int=my*th
			Local rightbottomx:Int=mx*tw+tw
			Local rightbottomy:Int=my*th+th
			Local leftbottomx:Int=mx*tw
			Local leftbottomy:Int=my*th+th
			If map[mx,my] <= 5 'if water tile
			If mx-1>=0 And map[mx-1,my] > 5 'if left is land
				drawwaterline(canvas,lefttopx,lefttopy,leftbottomx,leftbottomy)
			End If
			If my-1>=0 And map[mx,my-1] > 5 'if top is land
				drawwaterline(canvas,lefttopx,lefttopy,righttopx,righttopy)
			End If
			If mx+1<mw And map[mx+1,my]>5 'if right is land
				drawwaterline(canvas,righttopx,righttopy,rightbottomx,rightbottomy)
			End If
			If my+1<mh And map[mx,my+1]>5 'if bottom is land
				drawwaterline(canvas,leftbottomx,leftbottomy,rightbottomx,rightbottomy)
			End If
			End If
		Next
		Next
		canvas.Flush()
	End Method
	Method drawwaterline(canvas:Canvas,x1:Float,y1:Float,x2:float,y2:float)		
		SeedRnd(0)
		Local oldx:Float=x1,oldy:Float=y1
		Local x3:Float=x1,y3:Float=y1
		Repeat
			If x3<x2 Then x3+=Rnd(1)
			If y3<y2 Then y3+=Rnd(1)
			If x3>x2 Then x3-=Rnd(1)
			If y3>y2 Then y3-=Rnd(1)
			canvas.Color = New Color(0,Rnd(0.1,.2),Rnd(0.7,1))
			canvas.DrawRect(x3+Rnd(-2,2),y3+Rnd(-2,2),Rnd(2,4),Rnd(2,4))
			If Rnd(1)<.5
			canvas.Color = New Color(1,1,1)
			canvas.DrawPoint(x3,y3)
			End If
			If rectsoverlap(x3,y3,2,2,x2,y2,2,2) Then Return
		Forever
	End Method	
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	 Function	
End Class

Global mycontrols:controls
Global mytile:tile
Global myworld:world
Global myunit:List<unit> = New List<unit>
Global myunitmethod:unitmethod
Global mycity:List<city> = New List<city>
Global mycityscreen:cityscreen
Global mycitymethod:citymethod
Global mycitycontrols:citycontrols
Global myunituserinterface:unituserinterface
Global mygamemessage:gamemessage

'textures
Global mygreybackground:greybackground

Class MyWindow Extends Window
	Method New()
		Title="CivClone"
		
		startnewgame(Width,Height,0)
		
		mygamemessage.pushmessage("Press 1 for the help screen")
		mygamemessage.pushmessage("Programmed by R.v.Etten in 2017")		
		mygamemessage.pushmessage("Welcome to #CivClone")				
		
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		keydelay+=1
		mousedelay+=1
		If mousedelay>2000 Then mousedelay = 1000
		If keydelay>2000 Then keydelay = 1000
		App.RequestRender() ' Activate this method 
		'
		'the arrows to move the player with
		If cityscreenopen = False
			myunituserinterface.update()
'			myunituserinterface.draw(canvas)
		End If
		'
		If cityscreenopen = False
		If Keyboard.KeyDown(Key.Key1) = False
		If mousedelay > 12 And keydelay>12			
		mycontrols.addunit(canvas,Width,Height)
		mycontrols.moveunit(canvas,Width,Height)
		mycontrols.buildcity()		
		mycontrols.activateunit()
		mycontrols.myendofturn()
		mycontrols.buildroad()
		mycontrols.activeunitskipturn()
		mycontrols.opencityscreen()
		mycontrols.fortifyunit()
		End If
		End If
		End If



		If cityscreenopen = True
			mycitycontrols.controls()
			mycityscreen.draw(canvas)
		End If
		If cityscreenopen = False
			updatemapingame(canvas,Width,Height)
		End If
		
		' if key escape then quit
		If keydelay>10 And cityscreenopen = False
			If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
		End If
		If Keyboard.KeyReleased(Key.F2)
			'free images from memory
			mygreybackground.greyimage.Discard()
			myworld.image.Discard()	
			myworld.fogimage.Discard()
			myworld.roadimage.Discard()
			'start new game 
			startnewgame(Width,Height,Millisecs())
		End If
		
		If cityscreenopen = False
			myunituserinterface.draw(canvas)
		End If

		
	End Method	
	
End	Class

Function updatemapingame(canvas:Canvas,Width:Int,Height:int)
		Local rec:Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec

		'Draw world
		myworld.draw(canvas)
		'myworld.drawwateredge(canvas)
		'Draw roads
		'myworld.drawroads(canvas)

		'Draw units
		For Local i:=Eachin myunit
			i.draw(canvas)
		Next

		'restore the scissor to the entire screen
		rec = new Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(myworld.sw,myworld.sh)
		canvas.Scissor = rec
		
		' Draw cities
		For Local i:=Eachin mycity
			i.draw(canvas)
		Next		

		
		'draw active unit
		For Local i:=Eachin myunit
			If i.active = True
				i.draw(canvas)
			End If
		Next
		' Refresh unit list
		For Local i:=Eachin myunit
			' blink update
			If i.active = True 
				i.blinktimer += 1
				If i.blinktimer > blinkspeed
					i.blinktimer = 0
					If i.visible = True Then i.visible = False Else i.visible = true
				End If
			End If
			If i.deleteme = True Then myunit.Remove(i)
		Next
		' Refresh city list
		For Local i:=Eachin mycity
			If i.deleteme = True Then mycity.Remove(i)
		Next	
		'
		rec = New Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec

		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(0,Height-myworld.th,Width,20)
		
		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(0,Height-20,70,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Turn:"+turn,0,Height-15)

		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(100,Height-20,180,20)
		canvas.Color = New Color(1,1,1)
		Local mystr:String = "Moves Left:"+activeunitmovesleft
		canvas.DrawText(mystr.Mid(0,14),100,Height-15)
		
		If gamehasmovesleft = False
		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(300,Height-20,200,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Press Enter for new turn",300,Height-15)
		End If

		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(500,Height-20,200,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Hold 1 for help.",500,Height-15)

		canvas.DrawText(App.FPS,0,0)
		'game messaging system
		mygamemessage.update()
		mygamemessage.drawmessage(canvas)

		If Keyboard.KeyDown(Key.Key1) Then drawhelpscreen(canvas,Width,Height)				
		
End Function

Function drawhelpscreen(canvas:Canvas,Width:int,Height:Int)
	canvas.Color = New Color(0,0,0)
	canvas.DrawRect(50,50,Width-100,Height-100)
	canvas.Color = Color.White
	canvas.DrawText("Key 1 - This help screen",60,60)
	canvas.DrawText("Left Mouse on movable Unit - Activate unit",60,80)
	canvas.DrawText("Left Mouse and Shift - Create unit",60,100)
	canvas.DrawText("Right Mouse - Move active unit.",60,120)
	canvas.DrawText("R - Build Road",60,140)
	canvas.DrawText("B - Build City",60,160)
	canvas.DrawText("Enter or mmb - Next Turn",60,180)
	canvas.DrawText("Space - Unit Skip Turn.",60,200)
	canvas.DrawText("F - Fortify",60,220)
	canvas.DrawText("Left Mouse on City - Open city screen",60,240)
	canvas.DrawText("F2 - Reset To New Map",60,260)
	
End Function

Function redrawgame()
	myworld.updatedraw(myworld.icanvas)
	
	myworld.updatedrawwateredge(myworld.icanvas)
	'myworld.updatedrawroads(myworld.roadcanvas)	

	myworld.updatedrawfog(myworld.fogcanvas)

	myworld.updatedrawfogedge(myworld.fogcanvas)

End Function

Function startnewgame(Width:Int,Height:int,seed:Double)	
	SeedRnd(seed)	
	myunit = New List<unit>		
	mycity = New List<city>	
	
	myworld = New world(Width,Height,mystartmapwidth,mystartmapheight)
	mytile = New tile()	
	'myunit.Add(New unit(5,5))
	myunitmethod = New unitmethod()
	mycityscreen = New cityscreen(Width,Height)
	mycitymethod = New citymethod()
	mycitycontrols = New citycontrols()
	
	myunituserinterface = New unituserinterface(Width,Height)
	If texturequality = "Low"
		mygreybackground = New greybackground(Width,Height,100,100)
	Elseif texturequality = "Medium"
		mygreybackground = New greybackground(Width,Height,320,240)
	Else
		mygreybackground = New greybackground(Width,Height,640,480)
	End If
	
	' initialize/reset the game message system
	mygamemessage = New gamemessage(Width,Height)
	mygamemessage.pushmessage("New Map Generated")		
	
	findunitstartingposition()
	
	redrawgame()
	myworld.updatedrawroads(myworld.roadcanvas)
End Function

Function findunitstartingposition()
	Repeat
		Local x:Int=Rnd(myworld.mw)
		Local y:Int=Rnd(myworld.mh-1)
		If myworld.map[x,y] > 5
			myunit.Add(New unit(x,y,"Settlers"))
			myunitmethod.removefog(x,y)
			If x>myworld.mw/2
				myunituserinterface.dockside("Left")
				Else
				myunituserinterface.dockside("Right")
			End If
			Exit
		End If
	Forever
End Function

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
