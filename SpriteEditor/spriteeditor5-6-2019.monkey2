#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class spriteeditor
	Field canvasx:Int,canvasy:Int
	Field canvaswidth:Float,canvasheight:Float
	Field gridwidth:Float,gridheight:Float	
	Field spritewidth:Int,spriteheight:Int
	
	' palette
	
	Field c64color:Color[] ' our colors
	Field paletteselected:Int ' our selected color from palette
	Field palettex:Int,palettey:Int 'screen x and y
	Field palettewidth:Float,paletteheight:Float ' our palette screen w and h
	Field palettecellwidth:Float,palettecellheight:Float 'cell width and height of color
	Field numpalette:Int 'number of colors
	Method New()
		'palette setup
		inic64colors()
		palettex = 320
		palettey = 0
		palettewidth = 100
		paletteheight = 100
		numpalette = 16
		palettecellwidth = 16
		palettecellheight = 16		

		'sprite canvas setup
		canvasx = 0
		canvasy = 0
		spritewidth = 8
		spriteheight = 8		
		canvaswidth=320
		canvasheight=240
		gridwidth = canvaswidth/spritewidth		
		gridheight = canvasheight/spriteheight
		
	End Method
	Method spritegrid(canvas:Canvas)
		
		canvas.Color = Color.Grey
		
		For Local y:Int=0 Until spriteheight
		For Local x:Int=0 Until spritewidth
			Local pointx:Int=(x*gridwidth)+canvasx
			Local pointy:Int=(y*gridheight)+canvasy
			canvas.DrawLine(pointx,pointy,pointx+gridwidth,pointy)			
			canvas.DrawLine(pointx,pointy,pointx,pointy+gridheight)
		Next
		Next
	End Method
	Method paletteview(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(palettex,palettey,palettewidth,paletteheight)
		Local cc:Int=0
		For Local y:Int=0 Until paletteheight Step palettecellheight
		For Local x:Int=0 Until palettewidth Step palettecellwidth
			If cc>=numpalette Then Exit			
			Local pointx:Float=x+palettex
			Local pointy:Float=y+palettey
			'
			' Draw our color
			canvas.Color = c64color[cc]
			canvas.DrawRect(pointx,pointy,palettecellwidth,palettecellheight)
			'
			' Draw a white bar around the currently selected color
			If paletteselected = cc
			canvas.OutlineMode = OutlineMode.Solid
			canvas.OutlineWidth = 3
			canvas.OutlineColor = Color.Black
			canvas.DrawRect(pointx+2,pointy+2,palettecellwidth-4,palettecellheight-4)
			canvas.OutlineMode = OutlineMode.Solid
			canvas.OutlineWidth = 1
			canvas.OutlineColor = Color.Yellow
			canvas.DrawRect(pointx+2,pointy+2,palettecellwidth-4,palettecellheight-4)

			canvas.OutlineMode = OutlineMode.None
			End If
			'
			' Select our color
			If Mouse.ButtonDown(MouseButton.Left)
			
			If rectsoverlap(Mouse.X,Mouse.Y,1,1,pointx,pointy,palettecellwidth,palettecellheight) = true
				Print Microsecs()
				paletteselected = cc
			End If
			End if
			'
			cc+=1			
		Next
		Next
		'canvas.Color = c64color[2]
	End Method
	Method draw(canvas:Canvas)
		spritegrid(canvas)
		paletteview(canvas)
	End Method
	Method inic64colors()
		c64color = New Color[16]
		c64color[0 ] = New Color(intof(0)  ,intof(0)  ,intof(0)  )'Black
		c64color[1 ] = New Color(intof(255),intof(255),intof(255))'White
		c64color[2 ] = New Color(intof(136),intof(0)  ,intof(0)  )'Red
		c64color[3 ] = New Color(intof(170),intof(255),intof(238))'Cyan
		c64color[4 ] = New Color(intof(204),intof(68) ,intof(204))'Violet / Purple
		c64color[5 ] = New Color(intof(0)  ,intof(204),intof(85) )'Green
		c64color[6 ] = New Color(intof(0)  ,intof(0)  ,intof(170))'Blue
		c64color[7 ] = New Color(intof(238),intof(238),intof(119))'Yellow
		c64color[8 ] = New Color(intof(221),intof(136),intof(85) )'Orange
		c64color[9 ] = New Color(intof(102),intof(68) ,intof(0)  )'Brown
		c64color[10] = New Color(intof(255),intof(119),intof(119))'Light red
		c64color[11] = New Color(intof(51) ,intof(51) ,intof(51) )'Dark grey / Grey 1
		c64color[12] = New Color(intof(119),intof(119),intof(119))'Grey 2
		c64color[13] = New Color(intof(170),intof(255),intof(102))'Light green
		c64color[14] = New Color(intof(0)  ,intof(136),intof(255))'Light blue
		c64color[15] = New Color(intof(187),intof(187),intof(187))'Light grey / grey 3
	End Method
	
	Function intof:Float(a:Int)
		Return 1.0/255.0*a
	End Function

End Class



Class MyWindow Extends Window
	Field myspriteeditor:spriteeditor
	
	Method New()
		myspriteeditor = New spriteeditor()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(New Color(0,0,0,1))		
		myspriteeditor.draw(canvas)

		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End
