function getElementIndexInListById(tab,id)
	for i,_ in ipairs(tab) do
		if tab[i]._id==id then
			return i
		end
	end
end
function dicoSize(dict) 
	local count = 0
	for _ in pairs(dict) do
    	count = count + 1
	end
	return count
end

function getEventById(id,tab)
	for i,_ in ipairs(tab) do
		if tab[i]._eventId==id then
			return tab[i]
		end
	end
end

function showWindow(windowImage)
	for winBckY=360,552,96 do
		for winBckX=0,960,98 do
			Graphics.drawPartialImage(winBckX,winBckY,windowImage,0,0,99,97)
		end
	end
	for i=360,544,92 do
		Graphics.drawPartialImage(0,i,windowImage,98,2,4,92)
	end
	for i=360,544,92 do
		Graphics.drawPartialImage(956,i,windowImage,98,2,4,92)
	end
	for i=0,960,92 do
		Graphics.drawPartialImage(i,360,windowImage,98,2,92,4)
	end
	for i=0,960,92 do
		Graphics.drawPartialImage(i,540,windowImage,98,2,92,4)
	end
end

function showPartialImages(windowImage,imageParts)
	for _,i in ipairs(imageParts) do
		for xRepeat=0,i[7],1 do
			for yRepeat=0,i[8],1 do
				Graphics.drawPartialImage(i[1]+i[5]*xRepeat,i[2]+i[6]*yRepeat,windowImage,i[3],i[4],i[5],i[6])
			end
		end
	end 
end

function showDialogBox(x,y,windowImage,imageParts,textLines,font,color,textSize)
	showPartialImages(windowImage,imageParts)
	drawMultilinesText(x+4,y+4,textLines,font,color,textSize)
end

function objectTypeIn(objIdType,Array)
	for _,i in ipairs(Array) do
		if objIdType==i._objId then
			return true
		end
	end
	return false
end

function cleanimgMem(imgMemVar)
	for i,_ in pairs(imgMemVar) do
		if imgMemVar[i]~=nil then
			Graphics.freeImage(imgMemVar[i])
			imgMemVar[i]=nil
		end
	end
end

function cleanAudioMem(videoMemArray)
	for i,_ in pairs(videoMemArray) do
		Sound.close(videoMemArray[i])
		videoMemArray[i]=nil
	end
end

function cleanGenMem(videoMemArray)
	for i,_ in ipairs(videoMemArray) do
		videoMemArray[i]=nil
	end
end

function convertArrayValuesToNumber(array)
    for i = 1, #array do
        if type(array[i]) == "string" then
            array[i] = tonumber(array[i]) 
        elseif type(array[i]) == "table" then
            convertArrayValuesToNumber(array[i]) 
        end
    end
    return array
end

function checkOneKeyIsPressed(listOfKeys)
	local temp=0
	for _,key in ipairs(listOfKeys) do
		if key then
			temp=temp+1
		end
	end
	if temp~=0 then
		return true
	else
		return false 
	end
end
function drawMultilinesText(x,y,textLines,font,color,textSize)
	local lineNbr=y
	Font.setPixelSizes(font,textSize)
	for _,line in ipairs(textLines) do
		Font.print(font,x,lineNbr,line,color)
		lineNbr=lineNbr+25
	end
end

function objectIn(list,object)
	for _,i in ipairs(list) do 
		if i._objId==object then
		  return true
		end
	end
  return false
end

function eventIn(list,event)
	for _,i in ipairs(list) do
		if isSpecificObject(i,"event") then
			if i._eventId==event._eventId then
				return true
			end
		end
	end
	return false
end

function slice(tab,beginTab,endTab)
	local outTab={}
	for indexElt=beginTab,endTab do
		table.insert(outTab,tab[indexElt])
	end
	return outTab
end

function toBool(str)
	if str=="True" then
		return true
	elseif str=="False" then
		return false
	end
end

function surroundedByBracket(str,characterId)
	local temp=0
	for i=1,#str,1 do
		if string.sub(str,i,i)=="[" then
			temp=temp+1
	  	elseif string.sub(str,i,i)=="]" then
			temp=temp-1
	  	elseif temp>0 and i==characterId then
			return true
	  	end
	end
	return false
end
  
function customFirstOccurenceOf(str,elem,step)
	local a=1
	local b=#str
	if step<0 then
		a,b=b,a
	end
	for i=a,b,step do
		if string.sub(str,i,i)==elem and not surroundedByBracket(str,i) then
			return i
	  	end
	end
	return nil
end
  
--fonction à vérifier
function customSplit(str, separator)
    local temp = {}
    local firstOccurence = customFirstOccurenceOf(str, separator,1)
    if firstOccurence then
        table.insert(temp, string.sub(str, 1, firstOccurence - 1))
    else
        -- Si le séparateur n'existe pas, toute la chaîne est ajoutée
        table.insert(temp, str)
        return temp
    end

    for i = 1, #str do
        if string.sub(str, i, i) == separator and not surroundedByBracket(str, i) then
            local nextComaIndex = customFirstOccurenceOf(string.sub(str, i + 1, #str), separator,1)
            if nextComaIndex then
                local nextComa = i + nextComaIndex
                table.insert(temp, string.sub(str, i + 1, nextComa - 1))
            else
                table.insert(temp, string.sub(str, i + 1, #str))
            end
        end
    end
    return temp
end
  
function customLoads(str)
	local temp=customSplit(string.sub(str,2,#str-1),",")
    local finalList={}
    for _,i in ipairs(temp) do
    	if string.sub(i,1,1)=="[" and string.sub(i,#i,#i)=="]" then
        	table.insert(finalList,customLoads(i))
      	else
        	table.insert(finalList,i)
      	end
    end
    return finalList
end

function instancesListTransition(newInstancesList,newImgmemDataList,newAudiomemDataList,newGenMemDataList)
	instancesList={}
	cleanimgMem(imgMem)
	cleanAudioMem(sndMem)
	mediaGarbageCollection._addToVmem(imgMem,newImgmemDataList)
	mediaGarbageCollection._addToSndmem(sndMem,newAudiomemDataList)
	mediaGarbageCollection._addToGenmem(genMem,newGenMemDataList)
	for _,player in ipairs(playersList) do
		for _,playersAnimatedImage in ipairs(player._animatedImagesList) do
			playersAnimatedImage._spritesheet=imgMem[playersAnimatedImage._spritesheetLocation]
		end
	end
	instancesList=newInstancesList
end

function readlines(openedFile) 
	local openedFileSize=System.sizeFile(openedFile)
	local openedFileText=System.readFile(openedFile,openedFileSize)
	local linesArray={}
	for i=1,#openedFileText do
		local firstClose=string.sub(openedFileText,i,i)
		if firstClose==">" then
			local firstOpen=customFirstOccurenceOf(string.sub(openedFileText,1,i),"<",-1)
			table.insert(linesArray,string.sub(openedFileText,firstOpen+1,i-1))
		end
	end
	return linesArray
end

function loadAnimatedImage(str,imgMemDict)
    local line=customLoads(str)
    local imageCoords=line[7]
    for i=1,#imageCoords,1 do
        for j=1,#imageCoords[i],1 do
            imageCoords[i][j]=tonumber(imageCoords[i][j])
		end
	end
	for tabElementIndex,tabElement in pairs(imgMemDict) do
		if tabElementIndex==line[2] then
			return animatedImage(tabElement,tonumber(line[3]),tonumber(line[4]),tonumber(line[5]),tonumber(line[6]),imageCoords,tonumber(line[8]),tonumber(line[9]))
		end
	end
	imgMemDict[line[2]]=Graphics.loadImage(line[2])
    return animatedImage(imgMemDict[line[2]],tonumber(line[3]),tonumber(line[4]),tonumber(line[5]),tonumber(line[6]),imageCoords,tonumber(line[8]),tonumber(line[9]))
end

function loadLaunchEventObject(str,imgMemDict)
	local line=customLoads(str)
    local imageCoords=line[2][7]
    for i=1,#imageCoords,1 do
        for j=1,#imageCoords[i],1 do
            imageCoords[i][j]=tonumber(imageCoords[i][j])
		end
	end
	for tabElementIndex,tabElement in pairs(imgMemDict) do
		if tabElementIndex==line[2][2] then
			return launchEventObject(animatedImage(tabElement,tonumber(line[2][3]),tonumber(line[2][4]),tonumber(line[2][5]),tonumber(line[2][6]),imageCoords,tonumber(line[2][8]),tonumber(line[2][9])),line[3],toBool(line[4]))
		end
	end
	imgMemDict[line[2][2]]=Graphics.loadImage(line[2][2])
    return launchEventObject(animatedImage(imgMemDict[line[2][2]],tonumber(line[2][3]),tonumber(line[2][4]),tonumber(line[2][5]),tonumber(line[2][6]),imageCoords,tonumber(line[2][8]),tonumber(line[2][9])),line[3],toBool(line[4]))
end

function morpgefToArray(filename,imgMemDict)
	local Array={}
	local file=System.openFile(filename,FREAD)
	local lines=readlines(file)
	for i=1,#lines,1 do
		if string.sub(lines[i],1,3)=="BEG" then
			local target=customLoads("["..string.sub(lines[i],5,#lines[i]).."]")
			if target[1]=="animatedImage" then
				for j=i+1,#lines,1 do
					if string.sub(lines[j],1,9)=="DEFCOORDS" then
						local xAndYCoords=convertArrayValuesToNumber(customLoads("["..string.sub(lines[j],11,#lines[j]).."]"))
						local alreadyCreatedImage=false
						for kIndex,_ in pairs(imgMemDict) do
							if kIndex==target[2] then
								alreadyCreatedImage=true
							end
						end
						if alreadyCreatedImage==false then
							imgMemDict[target[2]]=Graphics.loadImage(target[2])
						end
						for _,xcoord in ipairs(xAndYCoords[1]) do
							for _,ycoord in ipairs(xAndYCoords[2]) do
								table.insert(Array,animatedImage(imgMemDict[target[2]],xcoord,ycoord,tonumber(target[3]),tonumber(target[4]),convertArrayValuesToNumber(target[5]),tonumber(target[6]),tonumber(target[7]),target[2]))
							end
						end
					end
					if string.sub(lines[j],1,3)=="BEG" then
						break
					end
				end
			elseif target[1]=="launchEventObject" then
				for j=i+1,#lines,1 do
					if string.sub(lines[j],1,9)=="DEFCOORDS" then
						local xAndYCoords=convertArrayValuesToNumber(customLoads("["..string.sub(lines[j],11,#lines[j]).."]"))
						local alreadyCreatedImage=false
						for kIndex,_ in pairs(imgMemDict) do
							if kIndex==target[2] then
								alreadyCreatedImage=true
							end
						end
						if alreadyCreatedImage==false then
							imgMemDict[target[2]]=Graphics.loadImage(target[2])
						end
						for _,xcoord in ipairs(xAndYCoords[1]) do
							for _,ycoord in ipairs(xAndYCoords[2]) do
								table.insert(Array,launchEventObject(animatedImage(imgMemDict[target[2]],xcoord,ycoord,tonumber(target[3]),tonumber(target[4]),convertArrayValuesToNumber(target[5]),tonumber(target[6]),tonumber(target[7]),target[2]),target[8],toBool(target[9])))
							end
						end
					end
					if string.sub(lines[j],1,3)=="BEG" then
						break
					end
				end
			end
		end
	end
	System.closeFile(file)
	return Array
end

function isSpecificObject(object,objectId)
  if object._objId==objectId then
    return true
  end
  return false
end

function collideObjects(elem1,elem2)
	local temp={up=false,down=false,left=false,right=false,collided=false}
	local obj={{elem1,elem2}}
	local i=1
	if ((obj[i][1]._x>=obj[i][2]._x)and(obj[i][1]._x<=obj[i][2]._x+obj[i][2]._width)) or ((obj[i][1]._x+obj[i][1]._width>=obj[i][2]._x)and(obj[i][1]._x+obj[i][1]._width<=obj[i][2]._x+obj[i][2]._width)) or ((obj[i][1]._y<obj[i][2]._y)and(obj[i][1]._y+obj[i][1]._height>obj[i][2]._y+obj[i][2]._height))then
		if (obj[i][1]._y<=obj[i][2]._y+obj[i][2]._height) and (obj[i][1]._y>=obj[i][2]._y+(obj[i][2]._height/2)) then
			temp.down=true
			temp.collided=true
		end
		if (obj[i][1]._y+obj[i][1]._height>=obj[i][2]._y) and (obj[i][1]._y+obj[i][1]._height<=obj[i][2]._y+(obj[i][2]._height/2)) then
			temp.up=true
			temp.collided=true
		end
	end
	if ((obj[i][1]._y>=obj[i][2]._y)and(obj[i][1]._y<=obj[i][2]._y+obj[i][2]._height)) or ((obj[i][1]._y+obj[i][1]._height>=obj[i][2]._y)and(obj[i][1]._y+obj[i][1]._height<=obj[i][2]._y+obj[i][2]._height)) or ((obj[i][1]._y<obj[i][2]._y)and(obj[i][1]._y+obj[i][1]._height>obj[i][2]._y+obj[i][2]._height))then
		if (obj[i][1]._x<=obj[i][2]._x+obj[i][2]._width) and (obj[i][1]._x>=obj[i][2]._x+(obj[i][2]._width/2)) then
			temp.right=true
			temp.collided=true
		end
		if (obj[i][1]._x+obj[i][1]._width>=obj[i][2]._x) and (obj[i][1]._x+obj[i][1]._width<=obj[i][2]._x+(obj[i][2]._width/2)) then
			temp.left=true
			temp.collided=true
		end
	end
	return temp
end
function detectInbound(element,x,y,width,height)
	if (element._x>=x and element._x<=x+width) or (element._x+element._width>=x and element._x+element._width<=x+width) or (element._x<=x and element._x+element._width>=x+width) then
		if (element._y>=y and element._y<=y+height) or (element._y+element._height>=y and element._y+element._height<=y+height) or (element._y<=y and element._y+element._height>=y+height) then
			return true
		end
	end
end

function solid(elem1,elem2)
	local elem1Final=elem1
	if elem1[1]~=nil then
		elem1Final=elem1[1]
	end
	if detectInbound(elem2,elem1Final._x-50,elem1Final._y-50,elem1Final._width+50,elem1Final._height+50) then
		if elem1Final._x < elem2._x + elem2._width and
		elem1Final._x + elem1Final._width > elem2._x and
		elem1Final._y < elem2._y + elem2._height and
		elem1Final._y + elem1Final._height > elem2._y then
			
			-- Calcul des côtés de collision
			local overlapX = math.min(elem1Final._x + elem1Final._width - elem2._x, elem2._x + elem2._width - elem1Final._x)
			local overlapY = math.min(elem1Final._y + elem1Final._height - elem2._y, elem2._y + elem2._height - elem1Final._y)

			if overlapX < overlapY then
				-- Collision sur l'axe X
				if elem1Final._x + elem1Final._width / 2 < elem2._x + elem2._width / 2 then
					elem1Final._x = elem1Final._x - overlapX -- Pousse à gauche
					if elem1[1]~=nil then
						for i=1,#elem1 do
							table.remove(elem1[i]._listePositions,#elem1[i]._listePositions)
						end
					end
				else
					elem1Final._x = elem1Final._x + overlapX -- Pousse à droite
					if elem1[1]~=nil then
						for i=1,#elem1 do
							table.remove(elem1[i]._listePositions,#elem1[i]._listePositions)
						end
					end
				end
			else
				-- Collision sur l'axe Y
				if elem1Final._y + elem1Final._height / 2 < elem2._y + elem2._height / 2 then
					elem1Final._y = elem1Final._y - overlapY -- Pousse vers le haut
					if elem1[1]~=nil then
						for i=1,#elem1 do
							table.remove(elem1[i]._listePositions,#elem1[i]._listePositions)
						end
					end
				else
					elem1Final._y = elem1Final._y + overlapY -- Pousse vers le bas
					if elem1[1]~=nil then
						for i=1,#elem1 do
							table.remove(elem1[i]._listePositions,#elem1[i]._listePositions)
						end
					end
				end
			end
		end
	end
end

--fin de la section fonctions

--section objects
function time1input(checkedInput)
	local this={
		_checkedInput=checkedInput,
		_latency=0,
		_pressed=false
	}
	function verify()
		local Pad=Controls.read()
		if this._latency<10 then
			this._latency=this._latency+1
		end
		if Controls.check(Pad,this._checkedInput) and this._pressed==false and this._latency==10 and objectTypeIn("fonduEnchaine",instancesList)==false then
			this._latency=0
			this._pressed=true
			return true
		elseif Controls.check(Pad,this._checkedInput) and objectTypeIn("fonduEnchaine",instancesList)==true then 
			return false
		else 
			this._pressed=false
		end
	end
	this["_verify"]=verify
	return this
end
function cinematic(filename,x,y)
	return {
		_filename=filename,
		_x=x,
		_y=y,
		_objId="cinematic"
	}
end

function menu(elements,cursor,texts)
	local this={
        _elements = elements,
		_texts=texts,
        _cursor = cursor,
        _objId = "menu",
		_isJustCreated=true
    }
	function create()
	end
	function step()
		this._cursor._step()
	end
	function draw()
		for _,element in ipairs(this._elements) do
			element._draw(element._x,element._y)
		end 
		for _,text in ipairs(this._texts) do
			drawMultilinesText(text[1],text[2],text[3],text[4],text[5],text[6])
		end
		this._cursor._draw()
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function stdCanvas(elements)
	local this={
		_elements=elements,
		_objId = "stdCanvas"
	}
	function create()
	end
	function step()
	end
	function draw()
		for _,element in ipairs(this._elements) do
			element._draw(element._x,element._y)
		end 
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function background(image,x,y,width,height)
	local this={
		_image=image,
		_x=x,
		_y=y,
		_width=width,
		_height=height,
		_speed=0,
		_objId="background",
		_isJustCreated=true
	}
	function create()
	end
	function step()
	end
	function draw(x,y)
		Graphics.drawImage(x,y,this._image)
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function camera(x,y,width,height,givedMap)
	if x=="None" then
		x=0
	end
	if y=="None" then
		y=0
	end
	if width=="None" then
		width=960
	end
	if width=="None" then 
		height=544
	end
	local this={
		_x=x,
		_y=y,
		_width=width,
		_height=height,
		_playerFollowing=true,
		_givedMap=givedMap,
		_lock=false,
		_objId="camera",
		_isJustCreated=true
	}
	function create()
	end
	function step()
		for _,camlimit in ipairs({{this._x<=0,"x",0},{this._y<=0,"y",0},{this._x+this._width>=this._givedMap._x+this._givedMap._width,"x",this._givedMap._x+this._givedMap._width-this._width},{this._y+this._height>=this._givedMap._y+this._givedMap._height,"y",this._givedMap._y+this._givedMap._height-this._height}}) do
			if camlimit[1] then
				if camlimit[2]=="x" then
					this._x=camlimit[3]
				else
					this._y=camlimit[3]
				end
			end
		end
	end
	function draw()
		if this._givedMap._background~="nothing" then
			this._givedMap._background._draw(this._givedMap._x-this._x,this._givedMap._y-this._y)
		end
		for _,plan in ipairs({this._givedMap._firstPlanElements,this._givedMap._playerslist,this._givedMap._secondPlanElements}) do
			if plan~=this._givedMap._playerslist then
				for _,elt in ipairs(plan) do
					if isSpecificObject(elt,"animatedImage") then
						if detectInbound(elt,this._x,this._y,this._width,this._height) then
							elt._draw(elt._x-this._x,elt._y-this._y)
						end
					elseif isSpecificObject(elt,"launchEventObject") then
						if detectInbound(elt._animatedimage,this._x,this._y,this._width,this._height) then
							elt._draw(elt._animatedimage._x-this._x,elt._animatedimage._y-this._y)
						end
					end
				end
			else
				for _,player in ipairs(plan) do
					player._draw(player._x-this._x,player._y-this._y)
				end
			end
		end
		
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function mcharacter(nom,x,y,Atk,pv,jus,battle_sprite_headspace_image,carteposx,carteposy,liste_des_fonctions,battle_sprite_headspace,animatedImagesList,width,height)
	local this={
		_isJustCreated=true,
		_collided=false,
		_listePositions={},
		_nom=nom,
		_x=x,
		_y=y,
		_Atk=Atk,
		_pv=pv,
		_jus=jus,
		_battle_sprite_headspace_image=battle_sprite_headspace_image,
		_carteposx=carteposx,
		_carteposy=carteposy,
		_liste_des_fonctions=liste_des_fonctions,
		_battle_sprite_headspace=battle_sprite_headspace,
		_animatedImagesList=animatedImagesList,
		_animatedImagesListIndex=1,
		_width=width,
		_height=height,
		_forceAnimation=false,
		_objId="mcharacter",
		_isJustCreated=true
	}
	this["_animatedimage"]=this._animatedImagesList[this._animatedImagesListIndex]
	function create()
	end
	function step()
	end
	function draw(x,y)
		this._animatedimage._draw(x,y)
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function button(image,position_x,position_y,image_position_concerned,pressed,command)
	local this={
		_isJustCreated=true,
		_image=image,
		_position_x=position_x,
		_position_y=position_y,
		_image_position_concerned=image_position_concerned,
		_pressed=pressed,
		_command=command,
		_objId="button",
		_isJustCreated=true
	}
	function create()
	end
	function step()
	end
	function draw()
		Graphics.drawPartialImage(this._position_x,this._position_y,this._image,this._image_position_concerned[1],this._image_position_concerned[2],this._image_position_concerned[3],this._image_position_concerned[4])
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function enemy(nom, pv, Atk, def, sprite, competences,image_position_concerned)
	local this={
		_isJustCreated=true,
		_nom=nom,
		_pv=pv,
		_Atk=Atk,
		_def=def,
		_sprite=sprite,
		_competences=competences,
		_image_position_concerned=image_position_concerned,
		_index=0,
		_posx=450,
		_posy=200,
		_objId="enemy",
		_isJustCreated=true
	}
	function create()
	end
	function step()
	end
	function draw()
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function competence_enemie(actions,index)
	return{
		_isJustCreated=true,
		_actions=actions,
		_index=index,
		_objId="competence_enemie",
		_isJustCreated=true
	}
end

function cursor(animatedimage,avaliable_cursor_positions)
	local this={
		_isJustCreated=true,
		_index=1,
		_animatedimage=animatedimage,
		_avaliable_cursor_positions=avaliable_cursor_positions,
		_objId="cursor",
		_keys={time1input(SCE_CTRL_UP),time1input(SCE_CTRL_DOWN),time1input(SCE_CTRL_LEFT),time1input(SCE_CTRL_RIGHT)},
		_isJustCreated=true
	}
	function create()
	end
	function step()
		if this._index>#this._avaliable_cursor_positions then
			this._index=#this._avaliable_cursor_positions
		end
		if this._index<1 then
			this._index=1
		end
		
		this._animatedimage._x=this._avaliable_cursor_positions[this._index][1]
		this._animatedimage._y=this._avaliable_cursor_positions[this._index][2]
		if this._keys[4]._verify() then
			this._index=this._index+1
		end
		if this._keys[3]._verify() then
			this._index=this._index-1
		end
		if this._keys[1]._verify() then
			this._index=this._index+2
		end
		if this._keys[2]._verify() then
			this._index=this._index-2
		end
	end
	function draw()
		this._animatedimage._draw(this._animatedimage._x,this._animatedimage._y)
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function map(firstPlanElements,secondPlanElements,background,x,y,width,height,spaceBetweenPlayers,playerslist)
	local this={
		_isJustCreated=true,
		_firstPlanElements=firstPlanElements,
		_secondPlanElements=secondPlanElements,
		_background=background,
		_x=x,
		_y=y,
		_width=width,
		_height=height,
		_spaceBetweenPlayers=spaceBetweenPlayers,
		_objId="map",
		_playerslist=playerslist,
		_isJustCreated=true,
		_playerFollowingCamera=true
	}
	this["_cam"]=camera(0,0,960,544,this)

	function create()
	end

	function step()
		pad=Controls.read()
		if this._playerFollowingCamera then
			this._cam._x=this._playerslist[1]._x-(960/2)
			this._cam._y=this._playerslist[1]._y-(544/2)
		end
		this._cam._step()
		if checkOneKeyIsPressed({Controls.check(pad,SCE_CTRL_RIGHT),Controls.check(pad,SCE_CTRL_LEFT),Controls.check(pad,SCE_CTRL_UP),Controls.check(pad,SCE_CTRL_DOWN)}) then
			for _,inputClicked in ipairs({{Controls.check(pad,SCE_CTRL_DOWN),"y",2,0.1,1},{Controls.check(pad,SCE_CTRL_UP),"y",-2,0.1,2},{Controls.check(pad,SCE_CTRL_LEFT),"x",-2,0.1,3},{Controls.check(pad,SCE_CTRL_RIGHT),"x",2,0.1,4}}) do
				if inputClicked[1] and objectTypeIn("fonduEnchaine",instancesList)==false then
					this._playerslist[1]._animatedImagesListIndex=inputClicked[5]
					this._playerslist[1]._animatedimage=this._playerslist[1]._animatedImagesList[this._playerslist[1]._animatedImagesListIndex]
					for indexPlayer,player in ipairs(this._playerslist) do
						table.insert(player._listePositions,{player._x,player._y,player._animatedimage._animationSpeed,player._animatedImagesListIndex})
						if #player._listePositions>=100 then
							player._listePositions=slice(player._listePositions,84,100)
						end
						if indexPlayer~=#this._playerslist then
							if #this._playerslist[indexPlayer]._listePositions>16 then
								this._playerslist[indexPlayer+1]._x=this._playerslist[indexPlayer]._listePositions[#this._playerslist[indexPlayer]._listePositions-16][1]
								this._playerslist[indexPlayer+1]._y=this._playerslist[indexPlayer]._listePositions[#this._playerslist[indexPlayer]._listePositions-16][2]
								this._playerslist[indexPlayer+1]._animatedimage._animationSpeed=this._playerslist[indexPlayer]._listePositions[#this._playerslist[indexPlayer]._listePositions-16][3]
								this._playerslist[indexPlayer+1]._animatedImagesListIndex=this._playerslist[indexPlayer]._listePositions[#this._playerslist[indexPlayer]._listePositions-16][4]
								this._playerslist[indexPlayer+1]._animatedimage=this._playerslist[indexPlayer+1]._animatedImagesList[this._playerslist[indexPlayer+1]._animatedImagesListIndex]
							end
						end
					end
					if inputClicked[2]=="y" then
						this._playerslist[1]._y=this._playerslist[1]._y+inputClicked[3]
						this._playerslist[1]._animatedimage._animationSpeed=inputClicked[4]
					end
					if inputClicked[2]=="x" then
						this._playerslist[1]._x=this._playerslist[1]._x+inputClicked[3]
						this._playerslist[1]._animatedimage._animationSpeed=inputClicked[4]
					end
				end
			end
		else
			for _,player in ipairs(this._playerslist) do
				if player._forceAnimation==false then
					player._animatedimage._animationSpeed=0
				end
			end
		end

		for _,plan in ipairs({this._firstPlanElements,this._secondPlanElements}) do
			for _,elem in ipairs(plan) do
				if isSpecificObject(elem,"launchEventObject") then
					solid(this._playerslist,elem._animatedimage)
					if detectInbound(this._playerslist[1],elem._animatedimage._x-5,elem._animatedimage._y-5,elem._animatedimage._width+10,elem._animatedimage._height+10) then
						elem._step()
					end
				end
			end
		end

	end

	function draw()
		this._cam._draw()
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function event(cache,Function,eventId) 
	local this={
		_cache=cache,
		_Function=Function,
		_objId="event",
		_eventId=eventId,
		_index=0
	}
	function create()
	end
	function step()
		this._Function(this)
	end
	function draw()
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end



function animatedImage(spritesheet,x,y,width,height,imageCoords,imageCoordsIndex,animationSpeed,spritesheetLocation)
	local this={
		_spritesheet=spritesheet,
		_x=x,
		_y=y,
		_width=width,
		_height=height,
		_imageCoords=imageCoords,
		_imageCoordsIndex=imageCoordsIndex,
		_animationSpeed=animationSpeed,
		_objId="animatedImage",
		_isJustCreated=true,
		_spritesheetLocation=spritesheetLocation
	}
	function create()
	end
	function step()
	end
	function draw(x,y)
		Graphics.drawPartialImage(x,y,this._spritesheet,this._imageCoords[math.floor(this._imageCoordsIndex)][1],this._imageCoords[math.floor(this._imageCoordsIndex)][2],this._imageCoords[math.floor(this._imageCoordsIndex)][3],this._imageCoords[math.floor(this._imageCoordsIndex)][4])
		this._imageCoordsIndex=this._imageCoordsIndex+this._animationSpeed
		if this._imageCoordsIndex>#this._imageCoords then
			this._imageCoordsIndex=1
		end
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function launchEventObject(animatedimage,Event,solid)
	local this={
		_animatedimage=animatedimage,
		_Event=Event,
		_solid=solid,
		_objId="launchEventObject",
		_isJustCreated=true,
		_cross=time1input(SCE_CTRL_CROSS)
	}
	function create()
	end
	function step()
        if this._Event~="nothing" then
			if eventIn(instancesList,eventsMem[this._Event])==false and this._cross._verify() then
				table.insert(instancesList,eventsMem[this._Event])
			end
        end
	end
	function draw(x,y)
		this._animatedimage._draw(x,y)
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

function automaticMemoryGestion()
	local this={
		_cleanMem=false,
		_objId="automaticMemoryGestion"
	}

	function addToVmem(vmem,addedContent)
		for _,elt in ipairs(addedContent) do
			vmem[elt]=Graphics.loadImage(elt)
		end
	end
	function addToSndmem(sndmem,addedContent)
		for _,elt in ipairs(addedContent) do
			sndmem[elt]=Sound.open(elt)
		end
	end
	function addToGenmem(genmem,addedContent)
		for _,elt in ipairs(addedContent) do
			genmem[elt[1]]=elt[2]
		end
	end

	function addToEventsMem(eventmem,addedContent)
		for _,elt in ipairs(addedContent) do
			eventmem[elt[1]]=elt[2]
		end
	end

	function clearMem(vmem,audiomem,generalMem)
		if this._cleanMem then
			instancesList={}
			cleanGenMem(generalMem)
			cleanAudioMem(audiomem)
			cleanimgMem(vmem)
			this._cleanMem=false
		end
	end
	this["_addToVmem"]=addToVmem
	this["_addToSndmem"]=addToSndmem
	this["_addToGenmem"]=addToGenmem
	this["_addToEventsMem"]=addToEventsMem
	this["_clearMem"]=clearMem
	return this
end

function fonduEnchaine(mode,order,removeAfterEnd)
	local this={
		_mode=mode,
		_order=order,
		_alpha=0,
		_removeAfterEnd=removeAfterEnd,
		_objId="fonduEnchaine"
	}
	if this._mode=="risingAlpha" then
		this._alpha=0
	elseif this._mode=="downingAlpha" then
		this._alpha=255
	end
	function create()
	end
	function step()
		if this._mode=="risingAlpha" then
			if this._alpha<255 then
				this._alpha=this._alpha+1
			elseif this._order ~="none" then
				table.insert(ordersList,this._order)
			elseif this._removeAfterEnd==true then
				for i,_ in ipairs(instancesList) do
					if instancesList[i]==this then
						table.remove(instancesList,i)
					end
				end
			end
		elseif this._mode=="downingAlpha" then
			if this._alpha>0 then
				this._alpha=this._alpha-1
			elseif this._order ~="none" then
				table.insert(ordersList,this._order)
			elseif this._removeAfterEnd==true then
				for i,_ in ipairs(instancesList) do
					if instancesList[i]==this then
						table.remove(instancesList,i)
					end
				end
			end
		end
	end
	function draw()
		Graphics.fillRect(0,960,0,544,Color.new(0,0,0,math.floor(this._alpha)))
	end
	this["_create"]=create
	this["_step"]=step
	this["_draw"]=draw
	return this
end

mediaGarbageCollection=automaticMemoryGestion()
ordersList={}
sndMem={}
imgMem={}
genMem={}
videoMem={}
eventsMem={}
instancesList={}
playersList={}
Sound.init()