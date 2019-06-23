function inarray(elem,array)
   for inarr = 1,#array do
      if ( elem[1]== array[inarr][1] and elem[2] == array[inarr][2]) then
         return true
      end
   end
   return false
end

function inarraysub(elem,array)
   for inarr = 1,#array do
      if ( elem== array[inarr]) then
         return inarr
      end
   end
end

function buttonclick(x,y,button,pic)
   list = {simple,medium,expert,custom}
   h = inarraysub(pic,list)*50 + 100
   if(button == 1 and x>=76 and x<=76 + pic:getWidth( ) and y>=h and y<=h + pic:getHeight()) then
      return true
   end
   return false
end

function check(x,y,boom,w,h)
   cal = 0
   if(x>1 and y>1) then
      if(inarray({x-1,y-1},boom)) then cal = cal + 1 end
   end
   if(x>1) then
      if(inarray({x-1,y},boom)) then cal = cal + 1 end
   end
   if(x>1 and y<h) then
      if(inarray({x-1,y+1},boom)) then  cal = cal + 1 end
   end
   if(y>1) then
      if(inarray({x,y-1},boom)) then cal = cal + 1 end
   end
   if(y<h) then
      if(inarray({x,y+1},boom)) then cal = cal + 1 end
   end
   if(x<w and y>1) then
      if(inarray({x+1,y-1},boom)) then cal = cal + 1 end
   end
   if(x<w) then
      if(inarray({x+1,y},boom)) then cal = cal + 1 end
   end
   if(x<w and y<h) then
      if(inarray({x+1,y+1},boom)) then cal = cal + 1 end
   end
   maze[x][y] = cal + 1
   if (cal == 0) then
      if(x>1) then
         if(maze[x-1][y] == 13) then check(x-1,y,boom,w,h) end
      end
      if(x<w) then
         if(maze[x+1][y] == 13) then check(x+1,y,boom,w,h) end
      end
      if(y>1) then
         if(maze[x][y-1] == 13) then check(x,y-1,boom,w,h) end
      end
      if(y<h) then
         if(maze[x][y+1] == 13) then check(x,y+1,boom,w,h) end
      end
      if(x>1 and y>1) then 
         if(maze[x-1][y-1] == 13) then check(x-1,y-1,boom,w,h) end
      end
      if(x>1 and y<h) then
         if(maze[x-1][y+1] == 13) then check(x-1,y+1,boom,w,h) end
      end
      if(x<w and y>1) then
         if(maze[x+1][y-1] == 13) then check(x+1,y-1,boom,w,h) end
      end
      if(x<w and y<h) then
         if(maze[x+1][y+1] == 13) then check(x+1,y+1,boom,w,h) end
      end
   end
end

function love.load()
   font = love.graphics.newFont( 30, 'normal')

   initial = love.graphics.newImage("image/initial.png")
   blank = love.graphics.newImage("image/grid.png")
   flags = love.graphics.newImage("image/flag.png")
   b1 = love.graphics.newImage("image/1.png")
   b2 = love.graphics.newImage("image/2.png")
   b3 = love.graphics.newImage("image/3.png")
   b4 = love.graphics.newImage("image/4.png")
   b5 = love.graphics.newImage("image/5.png")
   b6 = love.graphics.newImage("image/6.png")
   b7 = love.graphics.newImage("image/7.png")
   b8 = love.graphics.newImage("image/8.png")
   bombdisc = love.graphics.newImage("image/bombdisc.png")
   bombboom = love.graphics.newImage("image/bombboom.png")
   won = love.graphics.newImage("image/win.png")
   title = love.graphics.newImage("image/title.png")

   simple = love.graphics.newText(font, "Simple (9*9,10 mines)")
   medium = love.graphics.newText(font,"Medium (16*16,40 mines)")
   expert = love.graphics.newText(font,"Expert (30*16,99 mines)")
   --custom = love.graphics.newText(font,"Custom")

   start = false
   continue = true

   love.window.setMode(512,512)
   element ={blank,b1,b2,b3,b4,b5,b6,b7,b8,flags,bombdisc,bombboom,initial}
end

function love.draw()
   if(start) then
      love.graphics.setBackgroundColor(0.7,1,1,1)
      for i = 1,wide do
         for j = 1,height do 
            love.graphics.draw(element[maze[i][j]], 18+32*i, 18+32*j)
         end
      end
      if(win) then
         love.graphics.draw(won,50,32*height+49)
      end
   else
      love.graphics.draw(title,0,20)
      love.graphics.draw(simple,76,150)
      love.graphics.draw(medium,76,200)
      love.graphics.draw(expert,76,250)
      --love.graphics.draw(custom,76,300)
   end 

end

function love.mousepressed (x, y, button, istouch)
   if(start) then
      if(continue) then
         gridx = (x-18-(x-18)%32)/32
         gridy = (y-18-(y-18)%32)/32
         if(gridx>=1 and gridx<= wide and gridy>=1 and gridy<=height) then
            if(button == 1) then
               if(maze[gridx][gridy] == 13) then
                  if(inarray({gridx,gridy},bombxy)) then 
                     continue = false
                     for i = 1, number do
                        if(maze[bombxy[i][1]][bombxy[i][2]] == 10) then
                           maze[bombxy[i][1]][bombxy[i][2]] = 11
                        else
                           maze[bombxy[i][1]][bombxy[i][2]] = 12
                        end
                     end
                  else
                     check(gridx,gridy,bombxy,wide,height) 
                  end
               end
            end
            if(button == 2) then
               if(maze[gridx][gridy] == 13) then
                  maze[gridx][gridy] = 10
               elseif(maze[gridx][gridy] == 10) then
                  maze[gridx][gridy] = 13
               end
            end
         end
         if(continue) then
            win = true
            for i = 1, wide do
               for j = 1, height do
                  if (maze[i][j] == 13) then
                     win = false
                  end
               end
            end
            if(win) then 
               continue = false
            end 
         end
      end
   else
      if(buttonclick(x,y,button,simple)) then
         validclick = true
         wide = 9
         height = 9
         number = 10
      end
      if(buttonclick(x,y,button,medium)) then
         validclick = true
         wide = 16
         height =16
         number =40
      end
      if(buttonclick(x,y,button,expert)) then
         validclick = true
         wide = 30 
         height = 16
         number = 99
      end
      if(validclick) then
         love.window.updateMode(32*wide+100,32*height+100)
         maze ={}
         for i = 1,wide do
            maze[i] = {}
         end
         for i = 1,wide do
            for j = 1,height do
               maze[i][j] = 13
            end
         end
         bombxy ={}
         bombxy[1] = {love.math.random( 1, wide ),love.math.random( 1, height )}
         for k = 2,number do
            temp = {love.math.random( 1, wide ),love.math.random( 1, height )}
            while (inarray(temp,bombxy)) do
               temp = {love.math.random( 1, wide ),love.math.random( 1, height )}
            end
            bombxy[k] = temp
         end
         start = true
      end
   end
end

