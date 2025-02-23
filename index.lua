--this is a sample project that uses openRPGEngine
dofile("app0:/openRPGEngine.lua")
color=Color.new(255,255,255)
dialogFont=Font.load("app0:/Arial.ttf")
table.insert(ordersList,
function()
	mediaGarbageCollection._addToVmem(imgMem,{"app0:/testImage.png"})
	mediaGarbageCollection._addToGenmem(genMem,{{"app0:/morpgefTest.morpgef",morpgefToArray("app0:/morpgefTest.morpgef",imgMem)}})
	mediaGarbageCollection._addToEventsMem(eventsMem,{{"testDialog",event({1,time1input(SCE_CTRL_CROSS)},
	function(eventVar)
		for _,i in ipairs({{1,{"Hello !","Welcome in this demo"}},{2,{"if you can read this text,","that means the event system of my game engine(openRPG ENGINE) is working !",""}},{3,{"Ah and i want tell you something very important, even if the playstation vita is officially dead,","in the homebrew scene, she is alive as she never was before !"}}}) do
			if eventVar._index==i[1] then
				eventVar._cache[1]=0
				showDialogBox(0,360,imgMem["app0:/testImage.png"],{{0,360,126,240,96,90,9,2}},i[2],dialogFont,color,20)
				if eventVar._cache[2]._verify() then
					eventVar._cache[1]=1
				end
			end
		end

		if eventVar._index>3 then
			eventVar._index=0
			for i,_ in ipairs(instancesList) do
				if instancesList[i]._eventId==eventVar._eventId then
					table.remove(instancesList,i)
				end
			end
		end
		eventVar._index=eventVar._index+eventVar._cache[1]
	end,"testDialog")}})
	charaChara=mcharacter("chara-chara",0,0,200,50,50,"nothing",0,0,{},"nothing",{animatedImage(imgMem["app0:/testImage.png"],0,0,41,111,{{374,4,41,111},{374,121,41,111},{374,238,41,111},{374,238,41,111}},1,0.1,"app0:/testImage.png"),animatedImage(imgMem["app0:/testImage.png"],0,0,41,111,{{434,4,41,111},{434,121,41,111},{434,238,41,111},{434,238,41,111}},1,0.1,"app0:/testImage.png"),animatedImage(imgMem["app0:/testImage.png"],0,0,36,111,{{554,4,36,111},{554,121,36,111},{554,238,36,111},{554,238,36,111}},1,0.1,"app0:/testImage.png"),animatedImage(imgMem["app0:/testImage.png"],0,0,36,111,{{497,4,36,111},{497,121,36,111},{497,238,36,111},{497,238,36,111}},1,0.1,"app0:/testImage.png")},41,111)
	table.insert(instancesList,map(genMem["app0:/morpgefTest.morpgef"],{},"nothing",0,0,960,544,0,{charaChara}))
end
)
--fin section objets

--Section code principal
while true do
	Graphics.initBlend()
	Screen.clear()
	for _,instance in ipairs(instancesList) do
		if instance._isJustCreated then
			instance._create()
			instance._isJustCreated=false
		end
		instance._step()
		instance._draw()
	end
	if #ordersList~=0 then
		Graphics.debugPrint(680,520," DO NOT CLOSE ! Loading...",color)
	end
	Graphics.termBlend()
	Screen.waitVblankStart()
	Screen.flip()
	for orderIndex,_ in ipairs(ordersList) do
		ordersList[orderIndex]()
		table.remove(ordersList,orderIndex)
	end
end
