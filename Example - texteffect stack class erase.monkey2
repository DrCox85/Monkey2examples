#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class texteffect 
	Field x:Int,y:Int
	Field l:Int
	Field text:String
	Field type:String="begin"
	Field cnt:Int
	Field time:Float
	Field delay:Float=60
	Field timeend:Int=60
	Field deleteme:Bool=False
	Method New(text:String,x:Int,y:Int)
		Self.x = x/2
		Self.y = y/2
		Self.text = text
		l = text.Length
	End Method 
	Method update()
		time+=1
		If time>delay Then 
			time=0
			If type = "begin"
				cnt+=1
				while text[cnt-1] = 32 
					If cnt>=l Then exit
					cnt+=1
				Wend
				If cnt>=l Then type = "finished"
			End If
		End If
		If type = "finished"
			timeend-=1
			If timeend=0 Then deleteme=true
		End If
	End Method 

	Method draw(canvas:Canvas)
		canvas.PushMatrix()
		canvas.Scale(2,2)	
		canvas.Color = New Color(0.7,0.7,0.7)
		Select type
		Case "begin"
		For Local x2:=0 Until cnt
			
			If x2=cnt-1 Then 
				Local s:Float=(0.3/delay)*time
				canvas.Color = New Color(1-s,1-s,1-s)
			End If
			
			canvas.DrawText(text.Mid(x2,1),x+(x2*14),y)
			
		Next
		Case "finished"
			For Local x2:Int=0 Until l
				canvas.DrawText(text.Mid(x2,1),x+(x2*14),y)
			Next
		End Select		
		canvas.PopMatrix()
	End Method
end Class

Global mytexteffect:Stack<texteffect> = New Stack<texteffect>



Class MyWindow Extends Window
	Field t:String[] = New String[](    "This is a test.",
										"Monkey 2 is great!",
										"Programming",
										"Coding Coding..")
	Method New()
		Title = "Tinted Gradient background Example.."
		
		mytexteffect.Push(New texteffect(t[Rnd(0,t.Length)],Rnd(50,Width-100),Rnd(20,Height-40)))
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		canvas.Clear(Color.Black)
		'
		If Millisecs() Mod 15 = 1 Then'
		If Rnd()<.5
		mytexteffect.Push(New texteffect(t[Rnd(0,t.Length)],Rnd(-50,Width+50),Rnd(0,Height)))
		End If
		End If
		'	
		For Local i:=Eachin mytexteffect
			i.update()
			i.draw(canvas)
		Next		
		' remove from stack
		Local it:= mytexteffect.All()
		While Not it.AtEnd
		    Local item:=it.Current
		    If item.deleteme it.Erase() Else it.Bump()
		Wend
		' if key escape then quit		
		canvas.Color = Color.White
		canvas.DrawText("Press space for new screen..",0,0)
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
