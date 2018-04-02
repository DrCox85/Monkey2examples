#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window

	Field range:Int=6
	Field len:Int=500

	Class node
		Field x:Int
		Field y:Int
		Method New(x:Int,y:Int)
			Self.x = x
			Self.y = y
		End Method
	End Class

	Field brownian:Stack<node>

	Field my_x:Int[,] = New Int[1000,2]

	Method New()
		make()		
	End method
	
	Method make()
		brownian = New Stack<node>
		brownian.Push(New node(100,100))
		For Local i:Int=0 Until len
			Local nx:Int=brownian.Get(i).x
			Local ny:Int=brownian.Get(i).y
			SeedRnd(Microsecs())
			nx += Rnd(-range,range)
			ny += Rnd(-range,range)
 			nx = Clamp(nx,0,200)
			ny = Clamp(ny,0,200)
			brownian.Push(New node(nx,ny))			
		Next

		my_x = New Int[1000,2]
		'get the leftest x on y
		For Local i:Int=0 Until brownian.Length
			Local x:Int=brownian.Get(i).x
			Local y:Int=brownian.Get(i).y
			'Print x+","+y
			If my_x[y,0] = 0 Then my_x[y,0] = x ; Continue
			If x<my_x[y,0] Then my_x[y,0] = x
		Next
		'get the rightest x on y
		For Local i:Int=0 Until brownian.Length
			Local x:Int=brownian.Get(i).x
			Local y:Int=brownian.Get(i).y
			If my_x[y,1] = 0 Then my_x[y,1] = x ; Continue
			If x>my_x[y,1] Then my_x[y,1] = x
		Next		
		'if left and right is same then make wider
		For Local i:Int=0 Until 1000
			If my_x[i,0] >0
				If my_x[i,0] = my_x[i,1] Then my_x[i,1]+=Rnd(20)
			End If			
		Next		
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(Color.Black)
		canvas.Color = Color.White
		For Local i:Int=0 Until 240
			If my_x[i,0] = 0 Then Continue
			If my_x[i,1] = 0 Then Continue

			canvas.DrawRect(my_x[i,0]+50,50+i,my_x[i,1]-my_x[i,0],10)
		Next
'		' If key pace then new map
		If Keyboard.KeyReleased(Key.Space) Then make()		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function
