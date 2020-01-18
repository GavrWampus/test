print("Project: Tic-tac-toe"); -- Пишем в консоле название проекта

display.setStatusBar( display.HiddenStatusBar ) -- Прячем статусбар(который ешо наверху такой)

local background = display.newImageRect("background.jpg", display.contentWidth, display.contentHeight); -- Добавляем круток бекграунд ;)
background.x = display.contentCenterX -- Центруем по иксу
background.y = display.contentCenterY -- Центруеи по игреку

---------------------------------------------------------------------------------------------------------------------------------------------
-- Добавляем музыкальны кнопки
---------------------------------------------------------------------------------------------------------------------------------------------
local musicPlayButton = display.newImageRect("playButton.png", 112.5, 62.5 ); -- Добавляем кнопку play!
musicPlayButton.x = 60 -- Координаты по иксу
musicPlayButton.y = 40 -- Координаты по игреку
musicPlayButton.enabled = true; -- делаем её изначально доступной

local musicStopButton = display.newImageRect("stopButton.png", 112.5, 62.5 ); -- Добавляем кнопку stop!
musicStopButton.x = 260 -- Координаты по иксу
musicStopButton.y = 40 -- Координаты по игреку
musicStopButton.enabled = false; -- делаем её изначально недоступной
cnd = true; -- Делаем переменную condition(условие)

-----------------------------------------------------------------------------------------------------------------------------------------------

local bgSound = audio.loadSound( "music/bg.mp3" ); -- Загружаем на саунд из папки music

function musicPlayButton:touch(e) -- Функция, отвечающая за включение и возобновление музыки
    if (e.phase == "ended" and musicPlayButton.enabled == true and cnd == true) then -- ended - когда отпускаешь ЛКМ
        audio.setVolume( 0.1, { channel=1 } ) -- Устанавливаем громкость
        audio.play(bgSound, { channel = 1, loops = -1, fadein = 6000 }); -- Воспроизводим музыку на канале 1 с бесконечным повторением и входом в 6 секунд
        musicPlayButton.enabled = false; -- Делаем что бы нельзя было воспроизводить одну и ту же музыку по 10000 раз
        musicStopButton.enabled = true; --Делаем так что бы можно было остановить наш музик
        cnd = false;
    elseif (e.phase == "ended" and musicPlayButton.enabled == true and cnd == false) then
        audio.resume(1); --возобновляем музыку на канале 1 после остановки, если это надо
    end
end

function musicStopButton:touch(e) -- Функция, отвечающаа за остановку музыки
    if (e.phase == "ended" and cnd == false) then
        audio.pause(1); -- Приостанавливаем музыку на канале 1
        musicPlayButton.enabled = true; -- Делаем так чтобы её можно было возобновить кнопкой play!
        musicStopButton.enabled = false; -- На всякий случай)
        cnd = false; -- Тоже на всякий случай, если проигрывающаа функция не переведёт условие в нужный момент в false
    end
end


musicPlayButton:addEventListener("touch", musicPlayButton) -- Можно назвать это использованием библиотеки(на самом деле нельзя, он просто отслеживает события, а точнее прослушивает)
musicStopButton:addEventListener("touch", musicStopButton) -- Такая хрень реагирует на нажатия



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Создаём все необходимые переменные, массивы и группы
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local count = 3;
local countToWin = 3;
      posX = 0;
      posY = 0;
local curRect = nil;
local W = display.contentWidth; -- Создаём переменную W что бы не писать каждый раз Width
local H = display.contentHeight; -- Создаём переменную H что бы не писать каждый раз Height
local size = display.contentWidth/count;
local startX = W/2 + size/2 - size*count/2;
local startY = H/2 + size/2 - size*count/2;
local array = {};
local arrayText = {};

local mainGroup = display.newGroup(); -- Тут создаём главную "группу" на которой будет находиться всё что у нас есть(Но это не точно ;)
mainGroup.parent:insert(mainGroup);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Функция, которая считает свободные квадратки
function getCountFreeRect()
    local countFree = count^2;
    for i = 1, #array do
        local item_mc = array[i];
        if (item_mc.enabled == false) then
            countFree = countFree - 1;
        end
    end
    return countFree;
end

function turnAI() -- Тут у нас ИИ ставит нолики(Пункция хрень, патамушта он ставит их рандомно, а нам надо, что бы он играл осознанно(Идея в процессе разработки))
    if(getCountFreeRect() > 0) then
        local rnd = math.ceil(math.random()*count^2)
        local item_mc = array[rnd];
        if (item_mc.enabled) then
            arrayText[rnd].text = "O";
            item_mc.enabled = false;
        else
            turnAI()
        end
    end
end

local function checkWin()
        local function checkWinHorizontal()
            for i= 1, count^2 do
                if ( countToWin == 3 and arrayText[i] == "1" ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == "1" ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] and arrayText[i+2] == arrayText[i+3] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == "1" ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+1] and arrayText[i+1] == arrayText[i+2] and arrayText[i+2] == arrayText[i+3] and arrayText[i+3] == arrayText[i+4] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end
        local function checkWinVertical()
            for i=1, count^2 do
                if ( countToWin == 3 and arrayText[i] == "1" ) then
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 4 and arrayText[i] == "1" ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] and arrayText[i+count*2] == arrayText[i+count*3] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
                if ( countToWin == 5 and arrayText[i] == "1" ) then
                    print("X:" .. i )
                    if ( arrayText[i] == arrayText[i+count] and arrayText[i+count] == arrayText[i+count*2] and arrayText[i+count*2] == arrayText[i+count*3] and arrayText[i+count*3] == arrayText[i+count*4] ) then
                        print("X Won")
                        local myText = display.newText( "X Won" , display.contentCenterX, display.contentCenterY*1.85, "Algerian", display.contentWidth/6 ) -- Добавляем текст выигрыша. Пока он будет за место функции gotoX()
                        myText:setFillColor( 1, 1, 1 )
                        for i=1, #array do
                            item_mc = array[i];
                            item_mc.enabled = false;
                        end
                    end
                end
            end
        end
        checkWinVertical()
        checkWinHorizontal()
end
-- Дохрена сложная функция :D
local function checkButtons(event)
    print( "Оно работает!" )
    for i = 1, #array do -- пробегаемся по массиву, который мы привязали к квадратикам
        local item_mc = array[i]; -- Обозначаем переменную item_mc
        local _x, _y = item_mc:localToContent( 0, 0 ); -- Тут узнаём координаты центров всех квадратов
        local dx = event.x - _x; --считаем разницу нажатия и координат квадратика от центра по x
        local dy = event.y - _y; --считаем разницу нажатия и координат квадратика от центра по y
        local wh  = item_mc.width; -- записываем длину квадрата в переменную
        local ht  = item_mc.height; -- записываем ширину квадрата в переменную

        if (math.abs(dx)<wh/2 and math.abs(dy)<ht/2) then --Если расстояние от центра одного квадрата меньше, чем половина его длины/ширины, то мы понимаем, что нему было произведено нажатие
            if( item_mc.selected == false ) then -- Если по квадратику было произведено нажатие, но до этого он не был выбран - выбираем его
                item_mc.selected = true;
                print('S')
            end
        else
            if ( item_mc.selected == true ) then -- если уже выбран какой то ещё объект, то делаем ему сатаус "Не выбран"
                item_mc.selected = false;
                print( 'unS' )

            end
        end
    end
end

-- Функция отвечает за то что ты ставишь крестики
local function touchTurn(event)
    local phase = event.phase;
    print( "touchTurn" )

    if ( phase == 'began' ) then
        checkButtons(event);
    elseif( phase == 'moved' ) then
        checkButtons(event);
    else
        if(getCountFreeRect() > 0) then
            for i = 1, #array do
                local item_mc = array[i];
                if (item_mc.selected and item_mc.enabled) then -- Если квадратик выбран и доступен, ставим там крестик
                    arrayText[i].text = "X";
                    arrayText[i] = "1";
                    item_mc.enabled = false;
                    checkWin();
                    turnAI();
                end
            end
        end
    end
end

-- Тута у нас функция рисующая прямоугольники
local function createRect(_id, _x, _y)
    rnd1 = math.random(0.0, 1.0) --R
    rnd2 = math.random(0.0, 1.0) --G
    rnd3 = math.random(0.0, 1.0) --B
    if (rnd1 == 0.0 and rnd2 == 0.0 and rnd3 == 0.0) then -- Если цвет квадрата чёрный, то превращаем его в белый
        rnd1 = 1
        rnd2 = 1
        rnd3 = 1
    end

    local rectangle = display.newRect( _x, _y, size, size ) -- Создаём квадрат(Хотя программа его воспринимает как прямоугольник) с шириной size и координатами _x, _y
    rectangle.strokeWidth = 3 -- Указываем ширину линий из которых он состоит
    rectangle:setFillColor( black, 0.01 ) -- Делаем квадратик прозрачным :)
    rectangle:setStrokeColor( rnd1, rnd2, rnd3 ) -- Делаем рандомный цвет квадратику
    rectangle.selected = false;
    rectangle.enabled = true;
    mainGroup.parent:insert(rectangle)-- Добавляем наш прямоугольник на сцену
    table.insert( array, rectangle ) -- привязываем массив к нашему квадратику
    local myText = display.newText( "" , _x, _y, "Algerian", size/1.5 ) -- Добавляем текст. Да это хреново, но пока он будет за место эконки
    myText:setFillColor( 1, 1, 1 )
    mainGroup.parent:insert(myText)
    table.insert( arrayText, myText )
    rectangle:addEventListener( "touch", touchTurn )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Делаем цикл непосредственно рисующий наши "прямоугольники"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for i = 1, count^2 do
    createRect( i,  startX + posX*size, startY + posY*size ); -- тут чистая математика, просто надо разобраться и всё
    posX = posX + 1 -- прибавляем к иксу + 1, после рисовки каждого квадрата
    if ( posX % count == 0 ) then -- Пишем условный оператор, который делает из строчки квадратов поле для игры
          posX = 0;
          posY = posY + 1
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
